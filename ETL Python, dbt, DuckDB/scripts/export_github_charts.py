#!/usr/bin/env python3
"""Export static Plotly images that render reliably on GitHub."""

from pathlib import Path

import duckdb
import plotly.express as px


ROOT = Path(__file__).resolve().parent.parent
DB_PATH = ROOT / "data" / "analytics.duckdb"
ASSET_DIR = ROOT / "assets" / "openflights"
ASSET_DIR.mkdir(parents=True, exist_ok=True)


def write_svg(fig, filename: str, width: int = 1100, height: int = 650) -> None:
    fig.update_layout(
        template="plotly_white",
        width=width,
        height=height,
        margin=dict(l=60, r=40, t=90, b=80),
    )
    fig.write_image(ASSET_DIR / filename)


def main() -> None:
    with duckdb.connect(str(DB_PATH)) as con:
        airport_counts = con.execute(
            """
            select country, airport_count
            from main.mart_top_countries_by_airports
            order by airport_count desc
            limit 10
            """
        ).df()
        route_counts = con.execute(
            """
            select airline, route_count
            from main.mart_top_airlines_by_routes
            order by route_count desc
            limit 20
            """
        ).df()
        hub_airports = con.execute(
            """
            select name, total_routes
            from main.mart_top_hub_airports
            order by total_routes desc
            limit 10
            """
        ).df()
        country_pairs = con.execute(
            """
            select source_country, destination_country, route_count
            from main.mart_top_country_pairs
            order by route_count desc
            limit 30
            """
        ).df()
        hub_airport_locations = con.execute(
            """
            select a.name as airport_name,
                   a.city,
                   a.country,
                   a.latitude,
                   a.longitude,
                   h.total_routes
            from main.mart_top_hub_airports h
            join main.stg_airports a on a.airport_id = h.airport_id
            where a.latitude is not null
              and a.longitude is not null
            order by h.total_routes desc
            limit 50
            """
        ).df()

    fig = px.bar(
        airport_counts,
        x="country",
        y="airport_count",
        title="Top 10 Countries by Airport Count",
        labels={"country": "Country", "airport_count": "Airport Count"},
    )
    write_svg(fig, "top-countries-by-airport-count.svg")

    fig = px.bar(
        route_counts.head(10),
        x="airline",
        y="route_count",
        title="Top 10 Airlines by Route Count",
        labels={"airline": "Airline", "route_count": "Route Count"},
    )
    write_svg(fig, "top-airlines-by-route-count.svg")

    fig = px.bar(
        hub_airports,
        x="name",
        y="total_routes",
        title="Top 10 Hub Airports by Route Activity",
        labels={"name": "Airport", "total_routes": "Total Routes"},
    )
    write_svg(fig, "top-hub-airports-by-route-activity.svg")

    fig = px.sunburst(
        country_pairs,
        path=["source_country", "destination_country"],
        values="route_count",
        title="Top Country-to-Country Route Flows",
    )
    write_svg(fig, "top-country-route-flows.svg")

    fig = px.scatter_geo(
        hub_airport_locations,
        lat="latitude",
        lon="longitude",
        hover_name="airport_name",
        hover_data=["city", "country", "total_routes"],
        size="total_routes",
        projection="natural earth",
        title="Top Hub Airports by Route Activity",
    )
    write_svg(fig, "top-hub-airports-map.svg")

    fig = px.bar(
        route_counts,
        x="airline",
        y="route_count",
        title="Top 20 Airlines by Route Count",
        labels={"airline": "Airline", "route_count": "Route Count"},
    )
    write_svg(fig, "top-20-airlines-by-route-count.svg")

    print(f"Static Plotly chart images exported to {ASSET_DIR}")


if __name__ == "__main__":
    main()
