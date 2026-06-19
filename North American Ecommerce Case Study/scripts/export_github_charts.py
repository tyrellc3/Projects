#!/usr/bin/env python3
"""Export static Plotly charts that render in GitHub notebook previews."""

from __future__ import annotations

from pathlib import Path

import duckdb
import plotly.express as px


ROOT = Path(__file__).resolve().parent.parent
DB_PATH = ROOT / "data" / "ecommerce.duckdb"
ASSET_DIR = ROOT / "assets" / "charts"
ASSET_DIR.mkdir(parents=True, exist_ok=True)


def write_svg(fig, filename: str, width: int = 1100, height: int = 650) -> None:
    fig.update_layout(
        template="plotly_white",
        width=width,
        height=height,
        margin=dict(l=70, r=40, t=90, b=120),
    )
    fig.write_image(ASSET_DIR / filename)


def main() -> None:
    con = duckdb.connect(str(DB_PATH), read_only=True)
    reconciliation = con.execute("select * from main.mart_revenue_reconciliation").df()
    finance = con.execute("select * from main.mart_finance_monthly_revenue").df()
    marketing = con.execute("select * from main.mart_marketing_attribution").df()
    channel = con.execute("select * from main.mart_ecommerce_channel_performance").df()
    quality = con.execute("select * from main.mart_data_quality_issues").df()
    con.close()

    fig = px.bar(
        reconciliation[reconciliation["step_order"] < 6],
        x="reconciliation_step",
        y="revenue_adjustment",
        color="root_cause_layer",
        title="Raw-to-Governed Revenue Bridge",
        labels={"revenue_adjustment": "Revenue Adjustment", "reconciliation_step": "Step"},
    )
    fig.update_layout(xaxis_tickangle=-25)
    write_svg(fig, "revenue-reconciliation-bridge.svg")

    fig = px.line(
        finance,
        x="revenue_month",
        y="recognized_net_revenue",
        markers=True,
        title="Recognized Net Revenue by Payment Month",
        labels={"revenue_month": "Month", "recognized_net_revenue": "Recognized Net Revenue"},
    )
    write_svg(fig, "finance-recognized-net-revenue.svg")

    fig = px.bar(
        marketing,
        x="marketing_source",
        y="net_revenue",
        color="is_promo_attributed",
        title="Net Revenue by Marketing Source",
        labels={"marketing_source": "Marketing Source", "net_revenue": "Net Revenue"},
    )
    write_svg(fig, "marketing-net-revenue-by-source.svg")

    fig = px.bar(
        channel.head(12),
        x="channel_name",
        y="net_revenue",
        color="product_category",
        title="Net Revenue by Channel and Product Category",
        labels={"channel_name": "Channel", "net_revenue": "Net Revenue"},
    )
    write_svg(fig, "ecommerce-channel-category-performance.svg")

    fig = px.bar(
        quality,
        x="issue_type",
        y="affected_rows",
        title="Data Quality Issues Found in Raw Source",
        labels={"issue_type": "Issue Type", "affected_rows": "Affected Rows"},
    )
    fig.update_layout(xaxis_tickangle=-25)
    write_svg(fig, "data-quality-issues.svg")

    print(f"Static Plotly chart images exported to {ASSET_DIR}")


if __name__ == "__main__":
    main()
