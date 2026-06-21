# OpenFlights Analytics Summary

This project demonstrates an end-to-end data engineering workflow for route network analysis using Python, DuckDB, dbt, Jupyter, and Plotly.

## Executive Snapshot

- Loaded OpenFlights airport, airline, and route CSVs into DuckDB.
- Built dbt staging models and marts for route coverage, airport connectivity, country route mix, and hub concentration.
- Added dbt tests and documentation for the modeled layer.
- Delivered notebook analysis, static GitHub chart fallbacks, and an exportable HTML dashboard.

## Key Results

- Modeled 67,663 routes across 7,698 airports and 237 countries.
- Classified 66,934 routes with enough country context for domestic versus international analysis.
- Found a near-even route mix: 48.1% domestic and 51.9% international.
- Identified domestic-heavy markets such as the United States and China.
- Identified international-heavy European markets suited for corridor and partnership analysis.

## Recommendation

Use the modeled route network as a foundation for deeper commercial analysis. Domestic-heavy markets should be evaluated through hub coverage and internal network density, while international-heavy markets are better suited for corridor, partnership, and cross-border connectivity analysis.
