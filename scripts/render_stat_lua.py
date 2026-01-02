#!/usr/bin/env python3
import json
import os

CACHE_PATH = os.path.join("cache", "stat_cache.json")
OUTPUT_PATH = os.path.join("data_stats.lua")


def load_cache():
    with open(CACHE_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def lua_string(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', "\\\"")


def main() -> int:
    cache = load_cache()
    specs = []
    for spec_id, entry in cache.get("specs", {}).items():
        best_stats = entry.get("bestStats", [])
        if best_stats:
            specs.append({
                "id": spec_id,
                "bestStats": best_stats,
            })

    lines = []
    lines.append("DeegoStatData = {")
    lines.append("  specs = {")
    for spec in specs:
        lines.append("    {")
        lines.append(f"      id = \"{lua_string(spec['id'])}\",")
        lines.append("      bestStats = {")
        for stat in spec.get("bestStats", []):
            lines.append(f"        \"{lua_string(stat)}\",")
        lines.append("      },")
        lines.append("    },")
    lines.append("  },")
    lines.append("}")

    with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
