#!/usr/bin/env python3
"""Write an interactive HTML dashboard from OpenFlights analytic models."""

import pathlib

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
    "select airline_name, route_count from main.mart_airline_route_coverage limit 20"
).df()
hub_airports = con.execute(
    "select name, city, country, total_routes from main.mart_top_hub_airports limit 20"
).df()
country_pairs = con.execute(
    "select source_country, destination_country, route_count from main.mart_top_country_pairs limit 40"
).df()
route_summary = con.execute(
    """
    select domestic_routes, international_routes
    from main.mart_route_network_summary
    """
).df()
country_mix = con.execute(
    """
    select country, outbound_routes, pct_domestic_routes, pct_international_routes
    from main.mart_country_route_mix
    limit 15
    """
).df()
hub_dependency = con.execute(
    """
    select country, airport_name, pct_country_connectivity, total_routes
    from main.mart_hub_country_dependency
    limit 15
    """
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
    x='airline_name',
    y='route_count',
    title='Top 20 Airlines by Route Count',
    labels={'route_count': 'Route Count', 'airline_name': 'Airline'}
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
fig_route_mix = px.pie(
    route_summary.melt(var_name='route_type', value_name='routes'),
    names='route_type',
    values='routes',
    title='Domestic vs. International Route Mix'
)
fig_country_mix = px.bar(
    country_mix,
    x='country',
    y=['pct_domestic_routes', 'pct_international_routes'],
    title='Country Route Mix: Domestic vs. International',
    labels={'value': 'Share of Outbound Routes', 'country': 'Country', 'variable': 'Route Type'},
    barmode='stack'
)
fig_hub_dependency = px.bar(
    hub_dependency,
    x='airport_name',
    y='pct_country_connectivity',
    color='country',
    hover_data=['total_routes'],
    title='Hub Dependency by Country',
    labels={'airport_name': 'Airport', 'pct_country_connectivity': 'Share of Country Connectivity'}
)

html = f"""
<html>
<head>
  <meta charset='utf-8'>
  <title>OpenFlights Analytics Dashboard</title>
</head>
<body>
  <h1>OpenFlights Analytics Dashboard</h1>
  {fig_route_mix.to_html(full_html=False, include_plotlyjs='cdn')}
  {fig_country_mix.to_html(full_html=False, include_plotlyjs='cdn')}
  {fig_airports.to_html(full_html=False, include_plotlyjs='cdn')}
  {fig_routes.to_html(full_html=False, include_plotlyjs='cdn')}
  {fig_hubs.to_html(full_html=False, include_plotlyjs='cdn')}
  {fig_hub_dependency.to_html(full_html=False, include_plotlyjs='cdn')}
  {fig_pairs.to_html(full_html=False, include_plotlyjs='cdn')}
</body>
</html>
"""

output_path = REPORTS / "openflights_dashboard.html"
output_path.write_text(html, encoding='utf-8')
print(f"Dashboard exported to {output_path}")
