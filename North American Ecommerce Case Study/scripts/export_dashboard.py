#!/usr/bin/env python3
"""Export an interactive HTML dashboard from ecommerce revenue marts."""

from __future__ import annotations

from pathlib import Path

import duckdb
import plotly.express as px


ROOT = Path(__file__).resolve().parent.parent
DB_PATH = ROOT / "data" / "ecommerce.duckdb"
REPORTS = ROOT / "reports"
REPORTS.mkdir(parents=True, exist_ok=True)


def money(value: float) -> str:
    return f"${value:,.2f}"


def main() -> None:
    con = duckdb.connect(str(DB_PATH), read_only=True)
    kpis = con.execute("select * from main.mart_revenue_kpis").df()
    reconciliation = con.execute("select * from main.mart_revenue_reconciliation").df()
    finance = con.execute("select * from main.mart_finance_monthly_revenue").df()
    marketing = con.execute("select * from main.mart_marketing_attribution").df()
    channel = con.execute("select * from main.mart_ecommerce_channel_performance").df()
    quality = con.execute("select * from main.mart_data_quality_issues").df()
    con.close()

    kpi = kpis.iloc[0]
    fig_bridge = px.bar(
        reconciliation[reconciliation["step_order"] < 6],
        x="reconciliation_step",
        y="revenue_adjustment",
        color="root_cause_layer",
        title="Raw-to-Governed Revenue Bridge",
        labels={"revenue_adjustment": "Revenue Adjustment", "reconciliation_step": "Step"},
    )
    fig_finance = px.line(
        finance,
        x="revenue_month",
        y="recognized_net_revenue",
        markers=True,
        title="Finance View: Recognized Net Revenue by Payment Month",
        labels={"recognized_net_revenue": "Recognized Net Revenue", "revenue_month": "Month"},
    )
    fig_marketing = px.bar(
        marketing,
        x="marketing_source",
        y="net_revenue",
        color="is_promo_attributed",
        title="Marketing View: Net Revenue by Attribution Source",
        labels={"marketing_source": "Marketing Source", "net_revenue": "Net Revenue"},
    )
    fig_channel = px.bar(
        channel.head(12),
        x="channel_name",
        y="net_revenue",
        color="product_category",
        title="Ecommerce View: Net Revenue by Channel and Product Category",
        labels={"channel_name": "Channel", "net_revenue": "Net Revenue"},
    )
    fig_quality = px.bar(
        quality,
        x="issue_type",
        y="affected_rows",
        title="Data Quality Issues Found in Raw Source",
        labels={"issue_type": "Issue Type", "affected_rows": "Affected Rows"},
    )

    html = f"""
<!doctype html>
<html>
<head>
  <meta charset="utf-8" />
  <title>North American Ecommerce Revenue Dashboard</title>
  <style>
    body {{ font-family: Arial, sans-serif; margin: 32px; color: #172033; }}
    .kpis {{ display: grid; grid-template-columns: repeat(4, minmax(160px, 1fr)); gap: 12px; }}
    .kpi {{ border: 1px solid #d7dce5; padding: 14px; border-radius: 6px; }}
    .label {{ color: #687386; font-size: 12px; text-transform: uppercase; }}
    .value {{ font-size: 24px; font-weight: 700; margin-top: 6px; }}
  </style>
</head>
<body>
  <h1>North American Ecommerce Revenue Dashboard</h1>
  <p>Governed revenue view generated from dbt marts.</p>
  <section class="kpis">
    <div class="kpi"><div class="label">Raw Gross Revenue</div><div class="value">{money(kpi.raw_gross_revenue)}</div></div>
    <div class="kpi"><div class="label">Governed Net Revenue</div><div class="value">{money(kpi.governed_net_revenue)}</div></div>
    <div class="kpi"><div class="label">Revenue Gap</div><div class="value">{money(kpi.raw_to_governed_revenue_gap)}</div></div>
    <div class="kpi"><div class="label">Governed Orders</div><div class="value">{int(kpi.governed_orders)}</div></div>
  </section>
  {fig_bridge.to_html(full_html=False, include_plotlyjs="cdn")}
  {fig_finance.to_html(full_html=False, include_plotlyjs=False)}
  {fig_marketing.to_html(full_html=False, include_plotlyjs=False)}
  {fig_channel.to_html(full_html=False, include_plotlyjs=False)}
  {fig_quality.to_html(full_html=False, include_plotlyjs=False)}
</body>
</html>
"""
    output_path = REPORTS / "north_american_ecommerce_dashboard.html"
    output_path.write_text(html, encoding="utf-8")
    print(f"Dashboard exported to {output_path}")


if __name__ == "__main__":
    main()
