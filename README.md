# Data and Analytics Engineering Projects

This repo highlights a set of data and analytics engineering projects across SQL, Python, web scraping, data cleaning, visualization, and an end-to-end ETL workflow with DuckDB and dbt. Each project reflects the kind of work I enjoy most: turning raw data into structured, reliable, and useful analysis.

## Projects

### ETL Python, dbt, DuckDB

This is the most complete analytics engineering project in the repo. I used OpenFlights airport, airline, and route data to build an end-to-end workflow: Python ingestion, DuckDB storage, dbt staging and mart models, dbt tests, notebook analysis, and an exported HTML dashboard. The project focuses on turning raw transportation data into clean, modeled datasets for questions like airport connectivity, top airlines by route coverage, and country-to-country route flows.

Tools used: Python, DuckDB, dbt, Jupyter, Plotly.

### Python Global Data Cleanse and Plot

In this notebook I cleaned and analyzed a global country dataset from Kaggle. I focused on fields like birth rate, fertility rate, infant mortality, life expectancy, physicians per thousand, and population. The work includes data type cleanup, missing value handling, correlation analysis, heatmaps, pair plots, and grouped comparisons across countries.

Tools used: Python, pandas, seaborn, matplotlib, Jupyter.

### Python Sales Analysis

This project is an exploratory analysis of supermarket sales data from Kaggle. I used Python to clean the dataset, validate data quality, calculate KPIs, and analyze sales patterns by branch, payment method, product line, customer type, gender, and hour of day. One of the main takeaways was identifying peak sales hours that could support staffing and store planning decisions.

Tools used: Python, pandas, numpy, seaborn, matplotlib, Jupyter.

### WebScraping Python

This notebook shows a lightweight web scraping workflow using a Wikipedia table of the largest U.S. companies by revenue. I used requests and BeautifulSoup to pull the page, locate the target table, extract the headers and rows, load the results into a pandas DataFrame, and prepare the data for export.

Tools used: Python, requests, BeautifulSoup, pandas, Jupyter.

### SQL AdventureWorks Exploration

This project uses Microsoft's AdventureWorks sample SQL Server database. I wrote SQL queries to analyze sales, customers, products, product categories, yearly sales totals, order values, and frequent customers. The queries cover common business questions using joins, grouping, aggregation, filtering, and subqueries.

Tools used: SQL Server, T-SQL.

### SQL Wide World Data Exploration

This project uses Microsoft's Wide World Importers sample SQL Server database. I analyzed customer sales, order details, product performance, revenue by category, weekday versus weekend order value, customer ranking, running totals, inactive customers, and date-based sales questions. The queries use CTEs, window functions, joins, ranking, and analytical SQL patterns.

Tools used: SQL Server, T-SQL.

## Overall

Across these projects, I demonstrate the full data workflow: sourcing data, cleaning it, modeling it, analyzing it, and presenting results in a way that answers business questions. The repo includes focused analysis projects as well as a more production-style analytics engineering workflow with dbt and DuckDB.
