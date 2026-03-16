// =============================================================================
// HTML Export Overrides
// Show rules et fonctions spécifiques à l'export HTML
// =============================================================================

#import "i18n.typ": lang, t

// -----------------------------------------------------------------------------
// Show rules pour l'export HTML
// -----------------------------------------------------------------------------

#let html-show-rules(doc) = {
  // --- Headings : produire des <h1>/<h2>/<h3> sémantiques ---
  // Les show rules de thesis-style.typ remplacent les headings par des blocks,
  // ce qui perd la sémantique HTML. On les override ici.
  show heading.where(level: 1): it => context {
    if target() == "html" {
      let num-display = if it.numbering != none {
        t([Chapitre ], [Chapter ]) + counter(heading).display() + [ — ]
      }
      let label-id = if it.has("label") { str(it.label) } else { none }
      if label-id != none {
        html.elem("h1", attrs: (id: label-id), [#num-display#it.body])
      } else {
        html.elem("h1", [#num-display#it.body])
      }
      counter(footnote).update(0)
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(figure.where(kind: "algorithm")).update(0)
      counter(math.equation).update(0)
      // Reset des compteurs HTML des environnements (théorèmes, lemmes, etc.)
      for id in ("theoreme", "lemme", "proposition", "corollaire", "definition",
                  "thdef", "conjecture", "invariant", "remarque", "qo") {
        counter(figure.where(kind: "thm-" + id)).update(0)
      }
    } else {
      // Fallback to default (thesis-style.typ will handle it)
      it
    }
  }

  show heading.where(level: 2): it => context {
    if target() == "html" {
      let num-display = if it.numbering != none {
        counter(heading).display() + [ ]
      }
      let label-id = if it.has("label") { str(it.label) } else { none }
      if label-id != none {
        html.elem("h2", attrs: (id: label-id), [#num-display#it.body])
      } else {
        html.elem("h2", [#num-display#it.body])
      }
    } else {
      it
    }
  }

  show heading.where(level: 3): it => context {
    if target() == "html" {
      let num-display = if it.numbering != none {
        counter(heading).display() + [ ]
      }
      let label-id = if it.has("label") { str(it.label) } else { none }
      if label-id != none {
        html.elem("h3", attrs: (id: label-id), [#num-display#it.body])
      } else {
        html.elem("h3", [#num-display#it.body])
      }
    } else {
      it
    }
  }

  show heading.where(level: 4): it => context {
    if target() == "html" {
      let label-id = if it.has("label") { str(it.label) } else { none }
      if label-id != none {
        html.elem("h4", attrs: (id: label-id), it.body)
      } else {
        html.elem("h4", it.body)
      }
    } else {
      it
    }
  }

  // --- Équations inline : rendu SVG inline dans un box ---
  show math.equation.where(block: false): it => context {
    if target() == "html" {
      box(html.frame(it))
    } else {
      it
    }
  }

  // --- Équations block : rendu SVG ---
  show math.equation.where(block: true): it => context {
    if target() == "html" {
      html.frame(it)
    } else {
      it
    }
  }

  // --- Grilles de mise en page (ex: figures diagram côte à côte) ---
  // html.frame est nécessaire pour préserver les labels des figures internes.
  // On contraint la largeur pour éviter un SVG trop large.
  show grid: it => context {
    if target() == "html" {
      html.frame(block(width: 42em, it))
    } else {
      it
    }
  }

  // --- Théorèmes HTML : on garde le figure pour les labels, Typst le rend en <figure> ---
  // Pas de show rule nécessaire : le figure passe directement en HTML

  // --- Algorithmes : rendu SVG (trop complexe pour du HTML natif) ---
  // On contraint la largeur pour forcer le retour à la ligne dans le SVG,
  // sinon le texte est rendu à la largeur de la page PDF (~16cm) et l'image
  // est trop large pour la zone de contenu HTML (~800px).
  show figure.where(kind: "algorithm"): it => context {
    if target() == "html" {
      html.frame(block(width: 38em, it))
    } else {
      it
    }
  }

  doc
}

// -----------------------------------------------------------------------------
// Marqueur de section pour le découpage par le script build.py
// Chaque chapitre sera wrappé dans <section class="chapter" id="...">
// -----------------------------------------------------------------------------

#let chapter-section(id, body) = context {
  if target() == "html" {
    html.elem("section", attrs: (class: "chapter", id: id), body)
  } else {
    body
  }
}

// Marqueur pour les parties (Part I, Part II)
#let part-marker(id, title) = context {
  if target() == "html" {
    html.elem("section", attrs: (class: "part", id: id), {
      html.elem("h1", attrs: (class: "part-title"), title)
    })
  }
}
