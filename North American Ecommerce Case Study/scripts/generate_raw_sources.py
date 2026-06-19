#!/usr/bin/env python3
"""Generate related raw source CSVs from the redacted order extract."""

from __future__ import annotations

import csv
import hashlib
from datetime import date, datetime
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
RAW_DIR = ROOT / "data" / "raw"
ORDERS_PATH = RAW_DIR / "orders.csv"

PROMO_SOURCES = {"email", "paid_search", "affiliate"}
CHANNEL_IDS = {
    "Direct Web": "CHN-001",
    "B2B": "CHN-002",
    "Retail": "CHN-003",
    "Wholesale": "CHN-004",
    "Amazon": "CHN-005",
    "UNKNOWN": "CHN-999",
    "": "CHN-998",
}
STATE_BY_CHANNEL = {
    "Direct Web": ["CA", "CO", "NY", "WA", "OR"],
    "B2B": ["TX", "IL", "GA", "NC", "OH"],
    "Retail": ["CA", "FL", "NV", "AZ", "MA"],
    "Wholesale": ["UT", "ID", "MN", "PA", "TN"],
    "Amazon": ["WA", "CA", "NJ", "TX", "FL"],
    "UNKNOWN": ["UNKNOWN"],
    "": ["UNKNOWN"],
}
CATEGORY_NAMES = {
    "Footwear": "Trail Running Shoe",
    "Apparel": "Performance Layer",
    "Equipment": "Outdoor Equipment",
    "Accessories": "Trail Accessory",
    "": "Unknown Product",
}


def stable_int(value: str, modulo: int) -> int:
    digest = hashlib.sha256(value.encode("utf-8")).hexdigest()
    return int(digest[:8], 16) % modulo


def read_orders() -> list[dict[str, str]]:
    with ORDERS_PATH.open(newline="", encoding="utf-8") as file:
        return list(csv.DictReader(file))


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def campaign_id(order: dict[str, str]) -> str:
    source = order["marketing_source"]
    if source not in PROMO_SOURCES:
        return ""
    order_month = order["order_date"][:7].replace("-", "")
    source_code = source.replace("_", "-").upper()
    return f"CAM-{order_month}-{source_code}"


def product_id(sku: str) -> str:
    return f"PRD-{sku.split('-')[-1]}" if sku else "PRD-UNKNOWN"


def generate_customers(orders: list[dict[str, str]]) -> list[dict[str, object]]:
    customers = {}
    for order in orders:
        customer_id = order["customer_id"]
        if not customer_id:
            continue
        states = STATE_BY_CHANNEL.get(order["channel"], ["UNKNOWN"])
        state = states[stable_int(customer_id, len(states))]
        customers[customer_id] = {
            "customer_id": customer_id,
            "customer_segment": "Wholesale" if order["channel"] in {"B2B", "Wholesale"} else "Consumer",
            "state": state,
            "country": "United States" if state != "UNKNOWN" else "UNKNOWN",
            "acquisition_source": order["marketing_source"] or "unknown",
        }
    return sorted(customers.values(), key=lambda row: row["customer_id"])


def generate_products(orders: list[dict[str, str]]) -> list[dict[str, object]]:
    products = {}
    for order in orders:
        sku = order["product_sku"]
        if not sku:
            continue
        category = order["product_category"] or "Unknown"
        products[sku] = {
            "product_id": product_id(sku),
            "product_sku": sku,
            "product_category": category,
            "product_name": f"{CATEGORY_NAMES.get(category, 'Product')} {sku.split('-')[-1]}",
            "list_price": order["gross_revenue"] or "0",
            "is_active": "true",
        }
    return sorted(products.values(), key=lambda row: row["product_sku"])


def generate_channels(orders: list[dict[str, str]]) -> list[dict[str, object]]:
    channels = {}
    for order in orders:
        channel = order["channel"]
        channel_id = CHANNEL_IDS.get(channel, "CHN-997")
        channels[channel_id] = {
            "channel_id": channel_id,
            "channel_name": channel or "Missing Channel",
            "channel_group": "Owned" if channel == "Direct Web" else "Partner" if channel in {"Amazon", "Wholesale", "Retail", "B2B"} else "Unknown",
            "is_known_channel": "false" if channel in {"", "UNKNOWN"} else "true",
        }
    return sorted(channels.values(), key=lambda row: row["channel_id"])


def generate_campaigns(orders: list[dict[str, str]]) -> list[dict[str, object]]:
    campaigns = {}
    for order in orders:
        cid = campaign_id(order)
        if not cid:
            continue
        source = order["marketing_source"]
        campaigns[cid] = {
            "campaign_id": cid,
            "marketing_source": source,
            "campaign_name": f"{source.replace('_', ' ').title()} {order['order_date'][:7]}",
            "campaign_type": "Paid" if source in {"paid_search", "affiliate"} else "Owned",
            "is_promo_attributed": "true",
        }
    return sorted(campaigns.values(), key=lambda row: row["campaign_id"])


def generate_order_lines(orders: list[dict[str, str]]) -> list[dict[str, object]]:
    lines = []
    for index, order in enumerate(orders, start=1):
        sku = order["product_sku"]
        if not sku:
            continue
        lines.append(
            {
                "line_id": f"LINE-{index:05d}",
                "order_id": order["order_id"],
                "product_sku": sku,
                "quantity": 1,
                "unit_price": order["gross_revenue"] or "0",
                "discount_amount": "0",
                "line_gross_revenue": order["gross_revenue"] or "0",
            }
        )
    return lines


def generate_payments(orders: list[dict[str, str]]) -> list[dict[str, object]]:
    payments = []
    for index, order in enumerate(orders, start=1):
        payment_status = "captured"
        if order["order_status"] == "CANCELLED":
            payment_status = "voided"
        elif order["order_status"] == "UNKNOWN":
            payment_status = "unknown"
        payments.append(
            {
                "payment_id": f"PAY-{index:05d}",
                "order_id": order["order_id"],
                "payment_date": order["payment_date"],
                "payment_status": payment_status,
                "payment_amount": order["gross_revenue"] or "0",
                "payment_method": ["card", "paypal", "gift_card"][stable_int(order["order_id"], 3)],
            }
        )
    return payments


def generate_returns(orders: list[dict[str, str]]) -> list[dict[str, object]]:
    returns = []
    reasons = ["size_fit", "damaged", "buyer_remorse", "late_delivery"]
    for order in orders:
        has_return = order["return_flag"].lower() == "true" or order["return_amount"] not in {"", "0"}
        if not has_return:
            continue
        returns.append(
            {
                "return_id": f"RET-{len(returns) + 1:05d}",
                "order_id": order["order_id"],
                "return_date": order["return_date"],
                "return_amount": order["return_amount"] or "0",
                "return_reason": reasons[stable_int(order["order_id"], len(reasons))],
                "return_status": "processed" if order["return_date"] else "pending_review",
            }
        )
    return returns


def generate_date_spine(orders: list[dict[str, str]]) -> list[dict[str, object]]:
    dates = set()
    for order in orders:
        for column in ["order_date", "payment_date", "return_date"]:
            if order[column]:
                dates.add(order[column])
    rows = []
    for value in sorted(dates):
        parsed = datetime.strptime(value, "%Y-%m-%d").date()
        rows.append(
            {
                "date_day": parsed.isoformat(),
                "date_key": parsed.strftime("%Y%m%d"),
                "year": parsed.year,
                "month": parsed.month,
                "month_name": parsed.strftime("%B"),
                "quarter": f"Q{((parsed.month - 1) // 3) + 1}",
                "week_start_date": (parsed.fromordinal(parsed.toordinal() - parsed.weekday())).isoformat(),
            }
        )
    return rows


def main() -> None:
    orders = read_orders()
    write_csv(
        RAW_DIR / "customers.csv",
        generate_customers(orders),
        ["customer_id", "customer_segment", "state", "country", "acquisition_source"],
    )
    write_csv(
        RAW_DIR / "products.csv",
        generate_products(orders),
        ["product_id", "product_sku", "product_category", "product_name", "list_price", "is_active"],
    )
    write_csv(
        RAW_DIR / "channels.csv",
        generate_channels(orders),
        ["channel_id", "channel_name", "channel_group", "is_known_channel"],
    )
    write_csv(
        RAW_DIR / "campaigns.csv",
        generate_campaigns(orders),
        ["campaign_id", "marketing_source", "campaign_name", "campaign_type", "is_promo_attributed"],
    )
    write_csv(
        RAW_DIR / "order_lines.csv",
        generate_order_lines(orders),
        ["line_id", "order_id", "product_sku", "quantity", "unit_price", "discount_amount", "line_gross_revenue"],
    )
    write_csv(
        RAW_DIR / "payments.csv",
        generate_payments(orders),
        ["payment_id", "order_id", "payment_date", "payment_status", "payment_amount", "payment_method"],
    )
    write_csv(
        RAW_DIR / "returns.csv",
        generate_returns(orders),
        ["return_id", "order_id", "return_date", "return_amount", "return_reason", "return_status"],
    )
    write_csv(
        RAW_DIR / "date_spine.csv",
        generate_date_spine(orders),
        ["date_day", "date_key", "year", "month", "month_name", "quarter", "week_start_date"],
    )
    print("Generated expanded raw source tables.")


if __name__ == "__main__":
    main()
