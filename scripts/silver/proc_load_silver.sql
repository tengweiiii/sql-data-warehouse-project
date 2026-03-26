/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME,
			@batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY 
		SET @batch_start_time = GETDATE();
		PRINT '==================================================================='
		PRINT 'Loading silver layer...';
		PRINT '==================================================================='

		PRINT '-------------------------------------------------------------------'
		PRINT 'Loading CRM Tables...';
		PRINT '-------------------------------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info; 
		PRINT '>> Loading Data Into: silver.crm_cust_info';
		INSERT INTO silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)

		SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname, -- data cleansing: remove unwanted spaces from first and last name
			TRIM(cst_lastname) AS cst_lastname, 
			CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			ELSE 'n/a'
			END AS cst_marital_status, -- data normalization & standardization: normalize marital status values to descriptive values
			CASE WHEN UPPER(TRIM(cst_gndr)) ='F' THEN 'Female'
				 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				 ELSE 'n/a' -- data transformation: handle missing values
			END AS cst_gndr, -- data normalization & standardization: normalize gender values to descriptive values

			cst_create_date
		FROM(
			SELECT 
				*,
				ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last -- data cleansing: remove duplicates by assigning a row number to each record 
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		)t WHERE flag_last = 1; -- data filtering: keep only the latest record for each customer 
		SET @end_time = GETDATE();
		PRINT '>> Time taken to load silver.crm_cust_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info; 
		PRINT '>> Loading Data Into: silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)

		SELECT 
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- derived column: extract category ID from prd_key, replace dash with underscore 
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, -- derived column: extract the product key 
			prd_nm,
			ISNULL(prd_cost, 0) AS prd_cost, -- data transformation: replace NULL values in prd_cost with 0
			CASE UPPER(TRIM(prd_line)) 
				WHEN 'M' THEN 'Mountain'
				WHEN 'R' THEN 'Road'
				WHEN 'S' THEN 'Other Sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'n/a'
			END AS prd_line, -- data normalization: standardize prd_line values to more descriptive values.
			CAST(prd_start_dt AS DATE) AS prd_start_dt, -- data type casting: convert prd_start_dt to DATE data type
			CAST(
				LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 
				AS DATE
			) AS prd_end_dt -- data enrichment: calculate end date as one day before the next start date
		FROM bronze.crm_prd_info
		SET @end_time = GETDATE();
		PRINT '>> Time taken to load silver.crm_prd_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details; 
		PRINT '>> Loading Data Into: silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)

		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL -- data transformation: handle invalid date formats and values by replacing them with NULL
				 ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) -- data type casting: convert int to date by first converting to varchar and then to date
			END AS sls_order_dt,
			CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) 
			END AS sls_ship_dt,
			CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) 
			END AS sls_due_dt,
			CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) -- handling missing and invalid sales values
					THEN sls_quantity * ABS(sls_price) -- if sls_sales is NULL, zero, negative, or not equal to quantity * price, then recalculate it as quantity * price
				ELSE sls_sales 
			END AS sls_sales,
			sls_quantity,
			CASE WHEN sls_price IS NULL OR sls_price <= 0
					THEN sls_sales/ NULLIF(sls_quantity, 0)
				ELSE sls_price 
			END AS sls_price
		FROM bronze.crm_sales_details
		SET @end_time = GETDATE();
		PRINT '>> Time taken to load silver.crm_sales_details: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------------------------------------'



		PRINT '-------------------------------------------------------------------'
		PRINT 'Loading ERP Tables...';
		PRINT '-------------------------------------------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_CUST_AZ12';
		TRUNCATE TABLE silver.erp_CUST_AZ12; 
		PRINT '>> Loading Data Into: silver.erp_CUST_AZ12';
		-- erp_CUST_AZ12
		INSERT INTO silver.erp_CUST_AZ12 (
			cid,
			bdate,
			gen
		)

		SELECT 
			CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) -- data transformation: remove 'NAS' prefix if present 
				 ELSE cid 
			END AS cid,
			CASE WHEN bdate > GETDATE() THEN NULL
				ELSE bdate -- data transformation: set future birth dates to NULL as they are invalid
			END AS bdate,
			CASE WHEN UPPER(TRIM(gen)) IN ('F', 'Female') THEN 'Female' -- data normalization: normalize gender values to descriptive values
			WHEN UPPER(TRIM(gen)) IN ('M', 'Male') THEN 'Male' 
			ELSE 'n/a'
			END AS gen
		FROM bronze.erp_CUST_AZ12
		SET @end_time = GETDATE();
		PRINT '>> Time taken to load silver.erp_CUST_AZ12: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_LOC_A101';
		TRUNCATE TABLE silver.erp_LOC_A101; 
		PRINT '>> Loading Data Into: silver.erp_LOC_A101';
		INSERT INTO silver.erp_LOC_A101 (
			cid,
			cntry
		)
		SELECT
			REPLACE(cid, '-', '') AS cid, -- data transformation: remove dashes from cid 
			CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
				 WHEN TRIM(cntry) = '' OR TRIM(cntry) IS NULL THEN 'n/a'
				 ELSE TRIM(cntry) -- data normalization: standardize country codes and handle missing values
			END AS cntry
		FROM bronze.erp_LOC_A101
		SET @end_time = GETDATE();
		PRINT '>> Time taken to load silver.erp_LOC_A101: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_PX_CAT_G1V2';
		TRUNCATE TABLE silver.erp_PX_CAT_G1V2; 
		PRINT '>> Loading Data Into: silver.erp_PX_CAT_G1V2';
		INSERT INTO silver.erp_PX_CAT_G1V2 (
			id,
			cat,
			subcat,
			maintenance
		)

		SELECT 
			id, 
			cat, 
			subcat, 
			maintenance
		FROM bronze.erp_PX_CAT_G1V2
		SET @end_time = GETDATE();
		PRINT '>> Time taken to load silver.erp_PX_CAT_G1V2: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------------------------------------'
		SET @batch_end_time = GETDATE();
		PRINT '==================================================================='
		PRINT 'Finished loading silver layer.';
		PRINT '   - Total time taken to load silver layer: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '==================================================================='
	END TRY
	BEGIN CATCH
		PRINT '==================================================================='
		PRINT 'Error occurred while loading silver layer.';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '==================================================================='
	END CATCH
END
