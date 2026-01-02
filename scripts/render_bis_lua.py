#!/usr/bin/env python3
import json
import os
from typing import Dict

CACHE_PATH = os.path.join("cache", "bis_cache.json")
OUTPUT_PATH = os.path.join("data_bis.lua")


def load_cache() -> Dict[str, object]:
    with open(CACHE_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def lua_string(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', "\\\"")


def build_sources(items):
    sources = []
    for item in items or []:
        if not item.get("slot"):
            continue
        sources.append({
            "slot": item.get("slot"),
            "itemId": item.get("itemId"),
            "source": item.get("source"),
            "heroSymbol": item.get("heroSymbol"),
        })
    return sources


def build_trinket_tiers(tiers):
    result = []
    for tier in tiers or []:
        label = tier.get("tier")
        items = tier.get("items", [])
        if not label or not items:
            continue
        result.append({
            "tier": label,
            "items": items,
        })
    return result


def main() -> int:
    cache = load_cache()
    specs = []
    for spec_id, entry in cache.get("specs", {}).items():
        overall = build_sources(entry.get("overall", []))
        raid = build_sources(entry.get("raid", []))
        mythic_plus = build_sources(entry.get("mythic_plus", []))
        trinket_tiers = build_trinket_tiers(entry.get("trinket_tiers", []))
        specs.append({
            "id": spec_id,
            "bisSource": {
                "name": "Wowhead",
                "url": entry.get("url"),
                "label": "Overall BiS gear",
            },
            "bisNote": "Multiple overall lists available; showing the first list." if entry.get("overall_has_multiple") else None,
            "bisSources": overall,
            "bisSourceRaid": {
                "name": "Wowhead",
                "url": entry.get("url"),
                "label": "Raid BiS gear",
            } if raid else None,
            "bisNoteRaid": "Multiple raid lists available; showing the first list." if entry.get("raid_has_multiple") else None,
            "bisSourcesRaid": raid if raid else None,
            "bisSourceMythicPlus": {
                "name": "Wowhead",
                "url": entry.get("url"),
                "label": "Mythic+ BiS gear",
            } if mythic_plus else None,
            "bisNoteMythicPlus": "Multiple Mythic+ lists available; showing the first list." if entry.get("mythic_plus_has_multiple") else None,
            "bisSourcesMythicPlus": mythic_plus if mythic_plus else None,
            "trinketTiers": trinket_tiers if trinket_tiers else None,
        })

    lines = []
    lines.append("DeegoBisData = {")
    lines.append("  specs = {")
    for spec in specs:
        lines.append("    {")
        lines.append(f"      id = \"{lua_string(spec['id'])}\",")
        bis_source = spec.get("bisSource")
        if bis_source:
            lines.append("      bisSource = {")
            lines.append(f"        name = \"{lua_string(bis_source.get('name',''))}\",")
            lines.append(f"        url = \"{lua_string(bis_source.get('url',''))}\",")
            lines.append(f"        label = \"{lua_string(bis_source.get('label',''))}\",")
            lines.append("      },")
        if spec.get("bisNote"):
            lines.append(f"      bisNote = \"{lua_string(spec.get('bisNote'))}\",")
        if spec.get("bisSourceRaid"):
            bis_source = spec.get("bisSourceRaid")
            lines.append("      bisSourceRaid = {")
            lines.append(f"        name = \"{lua_string(bis_source.get('name',''))}\",")
            lines.append(f"        url = \"{lua_string(bis_source.get('url',''))}\",")
            lines.append(f"        label = \"{lua_string(bis_source.get('label',''))}\",")
            lines.append("      },")
        if spec.get("bisNoteRaid"):
            lines.append(f"      bisNoteRaid = \"{lua_string(spec.get('bisNoteRaid'))}\",")
        if spec.get("bisSourcesRaid"):
            lines.append("      bisSourcesRaid = {")
            for item in spec.get("bisSourcesRaid", []):
                slot = lua_string(item.get("slot", ""))
                source = lua_string(item.get("source", ""))
                item_id = item.get("itemId")
                hero_symbol = item.get("heroSymbol")
                if item_id:
                    if hero_symbol:
                        lines.append(
                            f"        {{ slot = \"{slot}\", itemId = {int(item_id)}, source = \"{source}\", heroSymbol = \"{lua_string(hero_symbol)}\" }},"
                        )
                    else:
                        lines.append(f"        {{ slot = \"{slot}\", itemId = {int(item_id)}, source = \"{source}\" }},")
                else:
                    if hero_symbol:
                        lines.append(f"        {{ slot = \"{slot}\", source = \"{source}\", heroSymbol = \"{lua_string(hero_symbol)}\" }},")
                    else:
                        lines.append(f"        {{ slot = \"{slot}\", source = \"{source}\" }},")
            lines.append("      },")
        if spec.get("bisSourceMythicPlus"):
            bis_source = spec.get("bisSourceMythicPlus")
            lines.append("      bisSourceMythicPlus = {")
            lines.append(f"        name = \"{lua_string(bis_source.get('name',''))}\",")
            lines.append(f"        url = \"{lua_string(bis_source.get('url',''))}\",")
            lines.append(f"        label = \"{lua_string(bis_source.get('label',''))}\",")
            lines.append("      },")
        if spec.get("bisNoteMythicPlus"):
            lines.append(f"      bisNoteMythicPlus = \"{lua_string(spec.get('bisNoteMythicPlus'))}\",")
        if spec.get("bisSourcesMythicPlus"):
            lines.append("      bisSourcesMythicPlus = {")
            for item in spec.get("bisSourcesMythicPlus", []):
                slot = lua_string(item.get("slot", ""))
                source = lua_string(item.get("source", ""))
                item_id = item.get("itemId")
                hero_symbol = item.get("heroSymbol")
                if item_id:
                    if hero_symbol:
                        lines.append(
                            f"        {{ slot = \"{slot}\", itemId = {int(item_id)}, source = \"{source}\", heroSymbol = \"{lua_string(hero_symbol)}\" }},"
                        )
                    else:
                        lines.append(f"        {{ slot = \"{slot}\", itemId = {int(item_id)}, source = \"{source}\" }},")
                else:
                    if hero_symbol:
                        lines.append(f"        {{ slot = \"{slot}\", source = \"{source}\", heroSymbol = \"{lua_string(hero_symbol)}\" }},")
                    else:
                        lines.append(f"        {{ slot = \"{slot}\", source = \"{source}\" }},")
            lines.append("      },")
        if spec.get("trinketTiers"):
            lines.append("      trinketTiers = {")
            for tier in spec.get("trinketTiers", []):
                tier_label = lua_string(tier.get("tier", ""))
                lines.append(f"        {{ tier = \"{tier_label}\", items = {{")
                for item_id in tier.get("items", []):
                    lines.append(f"          {int(item_id)},")
                lines.append("        }, },")
            lines.append("      },")
        lines.append("      bisSources = {")
        for item in spec.get("bisSources", []):
            slot = lua_string(item.get("slot", ""))
            source = lua_string(item.get("source", ""))
            item_id = item.get("itemId")
            hero_symbol = item.get("heroSymbol")
            if item_id:
                if hero_symbol:
                    lines.append(
                        f"        {{ slot = \"{slot}\", itemId = {int(item_id)}, source = \"{source}\", heroSymbol = \"{lua_string(hero_symbol)}\" }},"
                    )
                else:
                    lines.append(f"        {{ slot = \"{slot}\", itemId = {int(item_id)}, source = \"{source}\" }},")
            else:
                if hero_symbol:
                    lines.append(f"        {{ slot = \"{slot}\", source = \"{source}\", heroSymbol = \"{lua_string(hero_symbol)}\" }},")
                else:
                    lines.append(f"        {{ slot = \"{slot}\", source = \"{source}\" }},")
        lines.append("      },")
        lines.append("    },")
    lines.append("  },")
    lines.append("}")

    with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
