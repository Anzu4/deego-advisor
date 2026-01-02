#!/usr/bin/env python3
import argparse
import json
import os
import re
import time
import urllib.request

CACHE_PATH = os.path.join("cache", "stat_cache.json")
CONFIG_PATH = os.path.join("scripts", "bis_config.json")

CLASS_SLUGS = {
    "DEATHKNIGHT": "death-knight",
    "DEMONHUNTER": "demon-hunter",
    "DRUID": "druid",
    "EVOKER": "evoker",
    "HUNTER": "hunter",
    "MAGE": "mage",
    "MONK": "monk",
    "PALADIN": "paladin",
    "PRIEST": "priest",
    "ROGUE": "rogue",
    "SHAMAN": "shaman",
    "WARLOCK": "warlock",
    "WARRIOR": "warrior",
}

CLASS_NAMES = {
    "DEATHKNIGHT": "Death Knight",
    "DEMONHUNTER": "Demon Hunter",
    "DRUID": "Druid",
    "EVOKER": "Evoker",
    "HUNTER": "Hunter",
    "MAGE": "Mage",
    "MONK": "Monk",
    "PALADIN": "Paladin",
    "PRIEST": "Priest",
    "ROGUE": "Rogue",
    "SHAMAN": "Shaman",
    "WARLOCK": "Warlock",
    "WARRIOR": "Warrior",
}

SPEC_SLUGS = {
    "Beast Mastery": "beast-mastery",
    "Marksmanship": "marksmanship",
    "Survival": "survival",
    "Brewmaster": "brewmaster",
    "Mistweaver": "mistweaver",
    "Windwalker": "windwalker",
    "Demonology": "demonology",
    "Destruction": "destruction",
    "Affliction": "affliction",
    "Restoration": "restoration",
    "Elemental": "elemental",
    "Enhancement": "enhancement",
    "Guardian": "guardian",
    "Feral": "feral",
    "Balance": "balance",
    "Holy": "holy",
    "Discipline": "discipline",
    "Shadow": "shadow",
    "Arms": "arms",
    "Fury": "fury",
    "Protection": "protection",
    "Blood": "blood",
    "Frost": "frost",
    "Unholy": "unholy",
    "Havoc": "havoc",
    "Vengeance": "vengeance",
    "Devastation": "devastation",
    "Preservation": "preservation",
    "Augmentation": "augmentation",
    "Assassination": "assassination",
    "Outlaw": "outlaw",
    "Subtlety": "subtlety",
    "Arcane": "arcane",
    "Fire": "fire",
}

STAT_ORDER = ["Mastery", "Haste", "Vers", "Crit"]


def load_config():
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def load_cache():
    if not os.path.exists(CACHE_PATH):
        return {"version": 1, "specs": {}}
    with open(CACHE_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def save_cache(cache):
    with open(CACHE_PATH, "w", encoding="utf-8") as f:
        json.dump(cache, f, indent=2, sort_keys=True)


def is_stale(entry, max_age_days):
    fetched_at = entry.get("fetched_at", 0)
    age_seconds = time.time() - fetched_at
    return age_seconds > max_age_days * 86400


def fetch(url: str) -> str:
    with urllib.request.urlopen(url) as resp:
        return resp.read().decode("utf-8", errors="ignore")


def archon_url(spec_name: str, class_tag: str) -> str:
    class_slug = CLASS_SLUGS.get(class_tag)
    if not class_slug:
        raise ValueError(f"Unknown class tag: {class_tag}")
    spec_short = spec_name
    class_name = CLASS_NAMES.get(class_tag)
    if class_name and spec_short.endswith(" " + class_name):
        spec_short = spec_short[: -len(" " + class_name)]
    spec_slug = SPEC_SLUGS.get(spec_short)
    if not spec_slug:
        spec_slug = spec_short.lower().replace(" ", "-")
    return f"https://www.archon.gg/wow/builds/{spec_slug}/{class_slug}/raid/overview/mythic/all-bosses"


def extract_stat_priority(html: str):
    m = re.search(r'__NEXT_DATA__" type="application/json">(.*?)</script>', html, re.S)
    if not m:
        return None
    data = json.loads(m.group(1))
    page = data.get("props", {}).get("pageProps", {}).get("page", {})
    for section in page.get("sections", []):
        if section.get("component") == "BuildsStatPrioritySection":
            stats = section.get("props", {}).get("stats", [])
            order = sorted(stats, key=lambda s: s.get("order", 999))
            names = [s.get("name") for s in order if s.get("name")]
            cleaned = []
            for name in names:
                if name == "Versatility":
                    name = "Vers"
                if name in STAT_ORDER and name not in cleaned:
                    cleaned.append(name)
            return cleaned
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description="Update cached stat priority data from Archon.")
    parser.add_argument("--max-age-days", type=int, default=90, help="Refresh cache older than this many days.")
    parser.add_argument("--force", action="store_true", help="Force refresh all entries.")
    args = parser.parse_args()

    config = load_config()
    cache = load_cache()
    cache.setdefault("version", 1)
    cache.setdefault("specs", {})

    for spec in config.get("specs", []):
        spec_id = spec.get("id")
        class_tag = spec.get("class")
        spec_name = spec.get("spec")
        if not spec_id or not class_tag or not spec_name:
            continue
        cached = cache["specs"].get(spec_id, {})
        if cached and not args.force and not is_stale(cached, args.max_age_days):
            continue
        url = archon_url(spec_name, class_tag)
        html = fetch(url)
        priority = extract_stat_priority(html)
        if not priority:
            raise RuntimeError(f"Failed to extract stat priority for {spec_id}")
        cache["specs"][spec_id] = {
            "id": spec_id,
            "class": class_tag,
            "spec": spec_name,
            "url": url,
            "fetched_at": int(time.time()),
            "bestStats": priority,
        }

    save_cache(cache)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
