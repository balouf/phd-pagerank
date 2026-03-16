# Graphes du Web — Mesures d'importance a la PageRank

PhD thesis by Fabien Mathieu (2004), originally written in LaTeX, converted to [Typst](https://typst.app/) in 2026.

Available as a bilingual (French/English) website with search, dark mode, and PDF downloads.

**[Read online](https://balouf.github.io/phd-pagerank/)**

## Build locally

### Prerequisites

- [Typst](https://typst.app/) >= 0.14.2
- Python >= 3.11
- [uv](https://docs.astral.sh/uv/)

### Build the site

```bash
uv run web/build.py
```

This compiles both language versions (HTML + PDF), generates the static site in `web/dist/`, and builds the search index.

Options:
- `--skip-lang en` — build French only
- `--skip-pdf` — skip PDF compilation
- `--skip-compile` — reuse previously compiled HTML
- `--skip-search` — skip Pagefind indexing
- `--base-url /prefix/` — set base URL for deployment under a subpath

### Serve locally

```bash
python -m http.server -d web/dist
```

Then open http://localhost:8000.

## License

This work is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
