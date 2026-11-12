# Graphes du Web — Mesures d'importance à la PageRank

PhD thesis by Fabien Mathieu (2004), originally written in LaTeX, converted to [Typst](https://typst.app/) in 2026.

Available as a bilingual (French/English) website with search, dark mode, and PDF downloads.

**[Read online](https://balouf.github.io/phd-pagerank/)**

## Build locally

### Prerequisites

- [Typst](https://typst.app/) >= 0.15.1 (the web edition uses its experimental HTML and bundle exports; the deployment pins 0.15.1)
- Python >= 3.11
- [uv](https://docs.astral.sh/uv/)

### Build the site

```bash
uv run web/build.py
```

This compiles both language versions (HTML + PDF), generates the static site in `web/dist/`, and builds the search index.

Options:
- `--lang fr` — build one language only (repeatable)
- `--skip-pdf` — skip PDF compilation
- `--skip-search` — skip Pagefind indexing

The web edition relies on the layer in `templates/web/`, a vendored copy from [typst-thesis-web](https://github.com/balouf/typst-thesis-web), where the method is documented.

### Serve locally

```bash
python -m http.server -d web/dist
```

Then open http://localhost:8000.

## License

This work is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
