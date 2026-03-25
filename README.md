# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀  
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

---

### 🙏 Credits / Acknowledgements
- This Data Warehouse Project was developed following a tutorial by https://www.youtube.com/@DataWithBaraa  
- Any references or learning resources used are acknowledged here
 
---

## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
![Data Architecture](docs/data_architecture.png)

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

🎯 This repository is an excellent resource for professionals and students looking to showcase expertise in:
- SQL Development
- Data Architect
- Data Engineering  
- ETL Pipeline Developer  
- Data Modeling  
- Data Analytics  

---

## 🛠️ Important Links & Tools:

Everything is for Free!
- **[Datasets](datasets/):** Access to the project dataset (csv files).
- **[SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads):** Lightweight server for hosting your SQL database.
- **[SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16):** GUI for managing and interacting with databases.
- **[Git Repository](https://github.com/):** Set up a GitHub account and repository to manage, version, and collaborate on your code efficiently.
- **[DrawIO](https://www.drawio.com/):** Design data architecture, models, flows, and diagrams.
- **[Notion](https://www.notion.com/templates/sql-data-warehouse-project):** Get the Project Template from Notion
- **[Notion Project Steps](https://thankful-pangolin-2ca.notion.site/SQL-Data-Warehouse-Project-16ed041640ef80489667cfe2f380b269?pvs=4):** Access to All Project Phases and Tasks.

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.  

For more details, refer to [docs/requirements.md](docs/requirements.md).

## 📂 Repository Structure
```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file shows all different techniquies and methods of ETL
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
```

---

## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

## 👋 About Me

Hi, I'm Teng Wei — a Computer Science student specializing in Data Analytics.  
I’m passionate about working with data and currently exploring data analytics, data engineering, and data science.

- 📊 Interested in building data-driven solutions  
- 🏗️ Currently working on a data warehouse project using SQL Server  
- 🌱 Learning data modeling, ETL processes, and analytics workflows  
- 🚀 Exploring how data systems are designed and used in real-world applications  

---

### 🛠️ Tech Stack
- **Languages:** HTML, CSS, JavaScript, Python, Java, C#, SQL, PHP  
- **Tools:** Git, VS Code, Microsoft SQL Server, PyCharm, Apache NetBeans, RStudio, XAMPP  
- **Data & Visualization:** Power BI, Tableau  
- **Concepts:** Data Warehousing, Data Modeling, ETL, Data Analytics, Full-Stack Web Development, OOP, Gamification  

---

### 📂 Projects

#### 🏢 Data Warehouse Project (Current Focus)
- Built using CRM and ERP datasets  
- Designed a modern data warehouse using SQL Server  
- Implemented ETL processes and data modeling  
- Structured data for efficient querying and analytics  

#### 🎓 Gamified E-Learning Platform (Diploma Final Year Project)
- Developed a web-based platform for undergraduate students  
- Features gamification to increase engagement: points, badges, achievements, and leaderboards  
- **User Roles & Access:**  
  - Students: Access course materials, participate in quizzes, track progress, engage in forums, earn rewards, receive feedback  
  - Teachers: Create/manage course content, design quizzes, provide feedback, monitor student progress  
  - Administrators: Manage users, approve content, configure points/badges/rankings  
- **Learning & Assessment Tools:** Interactive quizzes, real-time feedback, discussion forums  
- **Content Management:** Structured course modules, multimedia support 
- Focused on enhancing engagement, learning experience, and user-friendly navigation  

#### 💻 Java-Based Systems (NetBeans)

- **APU Assessment Feedback System (AFS)**  
  - Developed using Java and Apache NetBeans with text-file based storage  
  - Built for Admin, Academic Leaders, Lecturers and Students  
  - Features: managing user accounts, grading system, class/module management, feedback, assessment tracking, reporting  
  - Focused on transparency, usability, and enhancing student learning experiences at Asia Pacific University (APU)  

- **APU Psychology Consultation Management System**  
  - Developed using Java and Apache NetBeans with an object-oriented approach  
  - Designed for Students and Psychology Lecturers at Asia Pacific University (APU)  
  - Features: account registration, booking appointments, viewing past appointments, feedback/ratings, reschedule management  
  - Focused on navigation, smooth UX, modularity, reusability, and scalability  

#### 🌐 FOMO Driving Academy (Web Project)
- Built using XAMPP, HTML, CSS, JavaScript, PHP, and MySQL  
- Developed for the Malaysian Driving Centre to help users prepare for driving theory tests  
- Features: interactive quizzes, study materials, personalized profiles, real-time simulations, detailed test reviews  
- Focused on user-friendly interface and comprehensive learning experience for students preparing for driving exams  

---

### 🎯 Career Goals
- Develop strong skills in data analytics and data engineering  
- Gain hands-on experience with real-world data systems  
- Build projects that generate meaningful insights  
- Continue growing towards a career in the data field  

---

### 📫 Contact
- Email: wetcheong@gmail.com  
- LinkedIn: https://linkedin.com/in/your-link  

---
