# BiS + Stat Cache Workflow

This project uses cached scrapers to generate `data_bis.lua` and `data_stats.lua`.

## Update BiS cache

```bash
python scripts/update_bis_cache.py --max-age-days 90
```

- Use `--force` to refresh all entries.
- Cached data lives at `cache/bis_cache.json`.

## Render `data_bis.lua`

```bash
python scripts/render_bis_lua.py
```

`data_bis.lua` is loaded before `data.lua` via `DeegoAdvisor.toc`, and its entries override `bisSources` by `spec.id`.

## Update stat priority cache (Archon)

```bash
python scripts/update_stat_cache.py --max-age-days 30
```

## Render `data_stats.lua`

```bash
python scripts/render_stat_lua.py
```

`data_stats.lua` is loaded before `data.lua` via `DeegoAdvisor.toc`, and its entries override `bestStats` by `spec.id`.

## Scheduling (optional)

Example cron (runs monthly on the 1st at 6am):

```bash
0 6 1 * * cd /home/desiree/Dev/DeegoAdvisor && \
  python scripts/update_bis_cache.py --max-age-days 60 && \
  python scripts/render_bis_lua.py && \
  python scripts/update_stat_cache.py --max-age-days 30 && \
  python scripts/render_stat_lua.py
```
