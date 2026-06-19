# OpenFlights Case Study

## Project summary
This project shows end-to-end analytics engineering with the OpenFlights dataset.

## Problem
OpenFlights provides raw airport, airline, and route data. I turned that data into clean analytics models and reports that highlight network structure and route connectivity.

## Approach
1. Ingest raw CSVs into DuckDB using Python.
2. Model the data with dbt sources and staging tables.
3. Build analytics marts for:
   - airport counts by country
   - airline route coverage
   - airport connectivity
   - country-to-country route flows
4. Validate the pipeline with dbt tests.
5. Share findings in notebooks and a dashboard.

## Insights
- which countries have the most airports
- which airlines have the broadest route networks
- which airports act as major hubs
- which country pairs have the busiest routes

## Portfolio highlights
- `README.md` shows the workflow
- `scripts/ingest_openflights.py` loads raw data
- dbt models in `models/openflights/`
- tests in `models/openflights/schema.yml`
- notebooks in `notebooks/`
- dashboard in `reports/openflights_dashboard.html`
- docs from `dbt docs`
