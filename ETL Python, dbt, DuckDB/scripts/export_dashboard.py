#!/usr/bin/env python3
"""Write an interactive HTML dashboard from OpenFlights analytic models."""import pathlib
import duckdb
import plotly.express as px

ROOT = pathlib.Path(__file__).resolve().parent.parent
DB_PATH = ROOT / "data" / "analytics.duckdb"
REPORTS = ROOT / "reports"
REPORTS.mkdir(parents=True, exist_ok=True)

con = duckdb.connect(str(DB_PATH))

airport_counts = con.execute(
    "select country, airport_count from main.mart_top_countries_by_airports limit 20"
).df()
route_counts = con.execute(
    "select airline, route_count from main.mart_top_airlines_by_routes limit 20"
).df()
hub_airports = con.execute(
    "select name, city, country, total_routes from main.mart_top_hub_airports limit 20"
).df()
country_pairs = con.execute(
    "select source_country, destination_country, route_count from main.mart_top_country_pairs limit 40"
).df()

con.close()

fig_airports = px.bar(
    airport_counts,
    x='country',
    y='airport_count',
    title='Top 20 Countries by Airport Count',
    labels={'airport_count': 'Airport Count', 'country': 'Country'}
)
fig_routes = px.bar(
    route_counts,
    x='airline',
    y='route_count',
    title='Top 20 Airlines by Route Count',
    labels={'route_count': 'Route Count', 'airline': 'Airline'}
)
fig_hubs = px.bar(
    hub_airports,
    x='name',
    y='total_routes',
    color='country',
    title='Top 20 Hub Airports by Total Route Activity',
    labels={'total_routes': 'Total Routes', 'name': 'Airport'}
)
fig_pairs = px.sunburst(
    country_pairs,
    path=['source_country', 'destination_country'],
    values='route_count',
    title='Top Country-to-Country Route Flows'
)

html = f"""
<html>
<head>
  <meta charset='utf-8'>
  <title>OpenFlights Analytics Dashboard</title>
</head>
<body>
  <h1>OpenFlights Analytics Dashboard</h1>
  {fig_airports.to_html(full_html=False, include_plotlyjs='cdn')}
  {fig_routes.to_html(full_html=False, include_plotlyjs='cdn')}
  {fig_hubs.to_html(full_html=False, include_plotlyjs='cdn')}
  {fig_pairs.to_html(full_html=False, include_plotlyjs='cdn')}
</body>
</html>
"""

output_path = REPORTS / "openflights_dashboard.html"
output_path.write_text(html, encoding='utf-8')
print(f"Dashboard exported to {output_path}")
