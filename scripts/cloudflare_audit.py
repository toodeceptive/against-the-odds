import json
import os
import sys
from urllib.parse import urlencode
from urllib.request import Request, urlopen

API_BASE = "https://api.cloudflare.com/client/v4"


def fail(message):
    print(f"ERROR: {message}")
    sys.exit(1)


def api_get(path, token, params=None):
    url = f"{API_BASE}/{path}"
    if params:
        url = f"{url}?{urlencode(params)}"
    req = Request(
        url,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
    )
    with urlopen(req) as response:
        data = json.load(response)
    if not data.get("success"):
        errors = data.get("errors") or []
        fail(f"Cloudflare API error: {errors}")
    return data.get("result", [])


def normalize_target(value):
    return value.rstrip(".").lower()


def main():
    token = os.environ.get("CF_API_TOKEN")
    zone_name = os.environ.get("CF_ZONE_NAME", "aodrop.com")
    expected_a = os.environ.get("EXPECTED_A_RECORD", "23.227.38.65")
    expected_cname = os.environ.get("EXPECTED_WWW_CNAME", "shops.myshopify.com")

    if not token:
        fail("CF_API_TOKEN is required.")

    zones = api_get("zones", token, {"name": zone_name})
    if not zones:
        fail(f"No zone found for {zone_name}.")

    zone_id = zones[0]["id"]
    root_name = zone_name
    www_name = f"www.{zone_name}"

    a_records = api_get(
        f"zones/{zone_id}/dns_records", token, {"type": "A", "name": root_name}
    )
    aaaa_records = api_get(
        f"zones/{zone_id}/dns_records", token, {"type": "AAAA", "name": root_name}
    )
    cname_records = api_get(
        f"zones/{zone_id}/dns_records", token, {"type": "CNAME", "name": www_name}
    )

    print(f"Cloudflare DNS audit for {zone_name}")
    print("-" * 40)

    if not a_records:
        fail(f"Missing A record for {root_name}.")

    a_values = {record["content"] for record in a_records}
    print(f"A record values: {', '.join(sorted(a_values))}")

    if expected_a not in a_values:
        fail(f"A record should point to {expected_a}.")

    a_proxied = [record.get("proxied") for record in a_records]
    if any(a_proxied):
        fail("A record is proxied. Shopify requires DNS-only for @.")

    if cname_records:
        cname_targets = {normalize_target(record["content"]) for record in cname_records}
        print(f"CNAME www values: {', '.join(sorted(cname_targets))}")
        if normalize_target(expected_cname) not in cname_targets:
            fail(f"CNAME www should point to {expected_cname}.")
        if any(record.get("proxied") for record in cname_records):
            fail("CNAME www is proxied. Shopify requires DNS-only for www.")
    else:
        fail(f"Missing CNAME record for {www_name}.")

    if aaaa_records:
        aaaa_values = {record["content"] for record in aaaa_records}
        print(f"AAAA record values: {', '.join(sorted(aaaa_values))}")
        print("Note: AAAA record present. Keep unless Shopify reports issues.")
    else:
        print("AAAA record not present.")

    print("DNS records match Shopify requirements.")


if __name__ == "__main__":
    main()
