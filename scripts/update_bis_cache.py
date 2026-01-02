#!/usr/bin/env python3
import argparse
import json
import os
import re
import time
import urllib.request
from typing import Dict, List, Optional

CACHE_PATH = os.path.join("cache", "bis_cache.json")
CONFIG_PATH = os.path.join("scripts", "bis_config.json")

SKILL_SOURCES = {
    "skill=165": "Leatherworking",
    "skill=164": "Blacksmithing",
    "skill=773": "Inscription",
}

SOURCE_REPLACEMENTS = {
    "Catalyst | Raid | Vault": "Tier",
    "11.2 Campaign": "Patch 11.2 Questline",
    "Patch 11.2 Questline": "Patch 11.2 Questline",
}

TIER_BOSS_BY_SLOT = {
    "Head": "Forgeweaver Araz",
    "Shoulders": "The Soul Hunters",
    "Legs": "Loom'ithar",
    "Gloves": "Soulbinder Naazindhri",
    "Hands": "Soulbinder Naazindhri",
    "Chest": "Fractillus",
}

ITEM_SOURCE_OVERRIDES = {
    222815: "Tailoring",
}

RAID_PATTERNS = [
  r"\[tab name=\"Raid\".*?\](.*?)\[/tab\]",
  r"\[tab name=\"Raid BiS\".*?\](.*?)\[/tab\]",
  r"\[tab name=\"Raid BiS Gear\".*?\](.*?)\[/tab\]",
  r"\[tab name=\"Raid Gear\".*?\](.*?)\[/tab\]",
  r"\[tab name=\"Gear from Raid\".*?\](.*?)\[/tab\]",
  r"\[tab name=\"Best in Slot Raid\".*?\](.*?)\[/tab\]",
]

MYTHIC_PLUS_PATTERNS = [
  r"\[tab name=\"Mythic\+\".*?\](.*?)\[/tab\]",
  r"\[tab name=\"Mythic \+\".*?\](.*?)\[/tab\]",
  r"\[tab name=\"Mythic Plus\".*?\](.*?)\[/tab\]",
  r"\[tab name=\"Mythic\+ BiS\".*?\](.*?)\[/tab\]",
  r"\[tab name=\"Mythic\+ BiS Gear\".*?\](.*?)\[/tab\]",
  r"\[tab name=\"Gear from Mythic\+\".*?\](.*?)\[/tab\]",
  r"\[tab name=\"Best in Slot Mythic\+\".*?\](.*?)\[/tab\]",
]


def fetch(url: str) -> str:
    with urllib.request.urlopen(url) as resp:
        return resp.read().decode("utf-8", errors="ignore")


def extract_markup(html: str) -> Optional[str]:
    m = re.search(r'WH\.markup\.printHtml\("(.*?)",\s*"guide-body"', html, re.S)
    if not m:
        return None
    raw = m.group(1)
    # Unescape Wowhead markup string.
    raw = raw.replace("\\r", "\r").replace("\\n", "\n").replace("\\/", "/")
    raw = raw.replace("\\\"", '"')
    return raw


def strip_markup(text: str) -> str:
    text = re.sub(r"\[/?[^\]]+\]", "", text)
    text = re.sub(r"<[^>]+>", "", text)
    text = text.replace("\r", " ").replace("\n", " ")
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def split_lines(cell: str) -> List[str]:
    if not cell:
        return []
    cell = cell.replace("<br>", "\n")
    parts = [part.strip() for part in cell.splitlines() if part.strip()]
    return parts


def find_trinket_tier_section(markup: str) -> Optional[str]:
    headings = []
    for match in re.finditer(r"\[h\d[^\]]*\](.*?)\[/h\d\]", markup, re.S):
        heading = strip_markup(match.group(1))
        headings.append((match.start(), match.end(), heading))
    preferred = None
    fallback = None
    for index, (_, end, heading) in enumerate(headings):
        lower = heading.lower()
        if "trinket tier" in lower:
            preferred = (index, end)
            break
        if "trinket" in lower and fallback is None:
            fallback = (index, end)
    target = preferred or fallback
    if not target:
        return None
    index, end = target
    next_start = headings[index + 1][0] if index + 1 < len(headings) else len(markup)
    return markup[end:next_start]
    return None


def parse_trinket_tiers(markup: str):
    section = find_trinket_tier_section(markup)
    if not section:
        return []
    tiers = []
    tier_blocks = re.findall(r"\[tier\](.*?)\[/tier\]", section, re.S)
    for block in tier_blocks:
        label_match = re.search(r"\[tier-label[^\]]*\](.*?)\[/tier-label\]", block, re.S)
        if not label_match:
            continue
        label = strip_markup(label_match.group(1))
        if not label:
            continue
        item_ids = []
        for item_id in re.findall(r"item=(\d+)", block):
            if item_id not in item_ids:
                item_ids.append(item_id)
        if item_ids:
            tiers.append({"tier": label.strip(), "items": [int(i) for i in item_ids]})
    if tiers:
        return tiers
    pattern = re.compile(r"\[center\]\[b\]\[color=q\d\](.*?) Tier\[/color\]\[/b\]\[/center\]\s*\[ul\](.*?)\[/ul\]", re.S)
    for tier_label, block in pattern.findall(section):
        item_ids = []
        for item_id in re.findall(r"item=(\d+)", block):
            if item_id not in item_ids:
                item_ids.append(item_id)
        if item_ids:
            tiers.append({"tier": tier_label.strip(), "items": [int(i) for i in item_ids]})
    return tiers


def parse_table_rows(section: str):
    rows = re.findall(r"\[tr\](.*?)\[/tr\]", section, re.S)
    items = []
    ring_count = 0
    trinket_count = 0
    has_main = False
    has_off = False
    for row in rows:
        cells = re.findall(r"\[td[^\]]*\](.*?)\[/td\]", row, re.S)
        if len(cells) < 3:
            continue
        base_slot = strip_markup(cells[0])
        if not base_slot or base_slot.lower() == "slot":
            continue
        item_lines = split_lines(cells[1])
        source_lines = split_lines(cells[2])
        if not item_lines:
            item_lines = [cells[1]]
        if not source_lines:
            source_lines = [cells[2]]
        for index, item_line in enumerate(item_lines):
            slot = base_slot
            if slot == "Ring":
                ring_count += 1
                slot = f"Ring {ring_count}"
            if slot == "Trinket":
                trinket_count += 1
                slot = f"Trinket {trinket_count}"
            if slot in ("Offhand", "Offhand/Shield", "Shield", "Shield/Offhand"):
                slot = "Off Hand"
            if slot in ("Weapon", "Weapons", "Weapon(s)"):
                slot = "Main Hand"
            if slot == "Main Hand":
                has_main = True
            if slot == "Off Hand":
                has_off = True
            item_id = None
            m_item = re.search(r"item=(\d+)", item_line)
            if m_item:
                item_id = int(m_item.group(1))
            hero_symbol = None
            m_symbol = re.search(r"symbol=([\w\-]+)", item_line)
            if m_symbol:
                hero_symbol = m_symbol.group(1)
            source_line = source_lines[index] if index < len(source_lines) else source_lines[-1]
            source = strip_markup(source_line)
            if not source:
                for key, name in SKILL_SOURCES.items():
                    if key in item_line or key in row:
                        source = name
                        break
            source = SOURCE_REPLACEMENTS.get(source, source)
            if source == "Tier" and slot in TIER_BOSS_BY_SLOT:
                source = f"Tier ({TIER_BOSS_BY_SLOT[slot]})"
            if not source and item_id in ITEM_SOURCE_OVERRIDES:
                source = ITEM_SOURCE_OVERRIDES[item_id]
            item = {"slot": slot, "itemId": item_id, "source": source}
            if hero_symbol:
                item["heroSymbol"] = hero_symbol
            items.append(item)

    if not has_main and not has_off:
        for item in items:
            if item["slot"] in ("Weapon", "Weapons", "Weapon(s)"):
                item["slot"] = "Main Hand"
                break
    return items


def parse_overall(markup: str):
    patterns = [
        r"\[tab name=\"Overall\".*?\](.*?)\[/tab\]",
        r"\[tab name=\"Overall BiS\".*?\](.*?)\[/tab\]",
        r"\[tab name=\"Overall BiS Gear\".*?\](.*?)\[/tab\]",
    ]
    matches = []
    for pattern in patterns:
        for match in re.finditer(pattern, markup, re.S):
            matches.append(match)
    if not matches:
        tabs_start = markup.find("[tabs")
        if tabs_start == -1:
            return [], False
        tab_start = markup.find("[tab name=", tabs_start)
        if tab_start == -1:
            return [], False
        tab_end = markup.find("[/tab]", tab_start)
        if tab_end == -1:
            return [], False
        section = markup[tab_start:tab_end]
        tabs_end = markup.find("[/tabs]", tab_start)
        if tabs_end == -1:
            tabs_end = tab_end
        tab_count = len(re.findall(r"\[tab name=", markup[tabs_start:tabs_end]))
        has_multiple = tab_count > 1
    else:
        section = matches[0].group(1)
        has_multiple = len(matches) > 1
    items = parse_table_rows(section)
    return items, has_multiple


def parse_tab(markup: str, patterns):
    matches = []
    for pattern in patterns:
        for match in re.finditer(pattern, markup, re.S):
            matches.append(match)
    if not matches:
        return [], False
    section = matches[0].group(1)
    has_multiple = len(matches) > 1
    items = parse_table_rows(section)
    return items, has_multiple


def load_config() -> Dict[str, object]:
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def load_cache() -> Dict[str, object]:
    if not os.path.exists(CACHE_PATH):
        return {"version": 1, "specs": {}}
    with open(CACHE_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def save_cache(cache: Dict[str, object]) -> None:
    with open(CACHE_PATH, "w", encoding="utf-8") as f:
        json.dump(cache, f, indent=2, sort_keys=True)


def is_stale(entry: Dict[str, object], max_age_days: int) -> bool:
    fetched_at = entry.get("fetched_at", 0)
    age_seconds = time.time() - fetched_at
    return age_seconds > max_age_days * 86400


def main() -> int:
    parser = argparse.ArgumentParser(description="Update cached BiS data from Wowhead.")
    parser.add_argument("--max-age-days", type=int, default=90, help="Refresh cache older than this many days.")
    parser.add_argument("--force", action="store_true", help="Force refresh all entries.")
    args = parser.parse_args()

    config = load_config()
    cache = load_cache()
    cache.setdefault("version", 1)
    cache.setdefault("specs", {})

    for spec in config.get("specs", []):
        spec_id = spec.get("id")
        url = spec.get("url")
        if not spec_id or not url:
            continue
        cached = cache["specs"].get(spec_id, {})
        if cached and not args.force and not is_stale(cached, args.max_age_days):
            continue
        html = fetch(url)
        markup = extract_markup(html)
        if not markup:
            raise RuntimeError(f"Failed to extract markup for {spec_id}")
        overall, has_multiple = parse_overall(markup)
        raid, raid_has_multiple = parse_tab(markup, RAID_PATTERNS)
        mythic_plus, mythic_plus_has_multiple = parse_tab(markup, MYTHIC_PLUS_PATTERNS)
        trinket_tiers = parse_trinket_tiers(markup)
        cache["specs"][spec_id] = {
            "id": spec_id,
            "class": spec.get("class"),
            "spec": spec.get("spec"),
            "url": url,
            "fetched_at": int(time.time()),
            "overall": overall,
            "overall_has_multiple": has_multiple,
            "raid": raid,
            "raid_has_multiple": raid_has_multiple,
            "mythic_plus": mythic_plus,
            "mythic_plus_has_multiple": mythic_plus_has_multiple,
            "trinket_tiers": trinket_tiers,
        }

    save_cache(cache)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
