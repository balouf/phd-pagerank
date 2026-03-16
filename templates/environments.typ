// =============================================================================
// Environments - Théorèmes, définitions, preuves, etc.
// =============================================================================

#import "@preview/ctheorems:1.1.3": *
#import "@preview/droplet:0.3.1": dropcap
#import "@preview/subpar:0.2.2"
#import "i18n.typ": lang, t

// Détection du mode HTML (passé via --input html=true)
#let _is-html = sys.inputs.at("html", default: "false") == "true"

// État partagé avec thesis-style.typ (même state par nom)
#let _appendix-state = state("appendix", false)

// -----------------------------------------------------------------------------
// Helpers HTML pour les environnements
// -----------------------------------------------------------------------------

// Produit une <div class="thm-box thm-xxx"> wrappée dans un figure (pour les labels)
// Chaque type d'environnement utilise un figure kind distinct ("thm-theoreme", "thm-lemme", etc.)
// pour avoir des compteurs indépendants. Le numbering utilise le pattern lazy-content
// (sans bloc context explicite) pour éviter le bug "cannot reference sequence" en HTML.
#let _html-thm(identifier, head, css-class) = {
  let thm-kind = "thm-" + identifier
  // Helper pour afficher le numéro chapitre.n dans le body HTML
  let fmt-num() = context {
    let chap = counter(heading).get().at(0)
    let n = counter(figure.where(kind: thm-kind)).get().first()
    let is-app = _appendix-state.at(here())
    if is-app {
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ".at(calc.rem(chap - 1, 26)) + "." + str(n)
    } else {
      str(chap) + "." + str(n)
    }
  }
  (..args, body) => {
    let name = if args.pos().len() > 0 { args.pos().first() } else { none }
    figure(
      kind: thm-kind,
      supplement: head,
      outlined: false,
      // Lazy content pattern — works in HTML export (no explicit context block)
      numbering: (..nums) => [#counter(heading).get().at(0).#nums.at(0)],
      html.elem("div", attrs: (class: "thm-box " + css-class), {
        html.elem("p", attrs: (class: "thm-head"), {
          html.elem("strong", [#head #fmt-num()])
          if name != none [ (#name)]
          [.]
        })
        body
      })
    )
  }
}

// Produit une <div class="thm-proof">
#let _html-proof(head) = {
  (..args, body) => {
    html.elem("div", attrs: (class: "thm-proof"), {
      html.elem("p", attrs: (class: "proof-head"), html.elem("em", [#head.]))
      body
      html.elem("p", attrs: (class: "qed"), [□])
    })
  }
}

// -----------------------------------------------------------------------------
// Configuration des théorèmes avec ctheorems
// -----------------------------------------------------------------------------

#let theorem-rules = thmrules.with(qed-symbol: $square$)

// Théorème
#let theoreme = if _is-html {
  _html-thm("theoreme", t("Théorème", "Theorem"), "thm-theoreme")
} else {
  thmbox("theoreme", t("Théorème", "Theorem"),
    fill: rgb("#e8f4f8"), stroke: rgb("#2196F3"), inset: 1em, radius: 4pt, base_level: 1)
}

// Théorème en annexe (en HTML, même fonction — le numéro A.x est géré par _appendix-state)
#let annexe_theoreme = if _is-html {
  _html-thm("theoreme", t("Théorème", "Theorem"), "thm-theoreme")
} else {
  thmbox("theoreme", t("Théorème", "Theorem"),
    fill: rgb("#e8f4f8"), stroke: rgb("#2196F3"), inset: 1em, radius: 4pt, base_level: 1,
  ).with(numbering: "A.1")
}

// Alias
#let Th = theoreme
#let Thm = theoreme

// Lemme
#let lemme = if _is-html {
  _html-thm("lemme", t("Lemme", "Lemma"), "thm-lemme")
} else {
  thmbox("lemme", t("Lemme", "Lemma"),
    fill: rgb("#f0f8e8"), stroke: rgb("#4CAF50"), inset: 1em, radius: 4pt, base_level: 1)
}

#let annexe_lemme = if _is-html {
  _html-thm("lemme", t("Lemme", "Lemma"), "thm-lemme")
} else {
  thmbox("lemme", t("Lemme", "Lemma"),
    fill: rgb("#f0f8e8"), stroke: rgb("#4CAF50"), inset: 1em, radius: 4pt, base_level: 1,
  ).with(numbering: "A.1")
}

#let lemmebreak = lemme

// Proposition
#let proposition = if _is-html {
  _html-thm("proposition", "Proposition", "thm-proposition")
} else {
  thmbox("proposition", "Proposition",
    fill: rgb("#fff8e8"), stroke: rgb("#FF9800"), inset: 1em, radius: 4pt, base_level: 1)
}

// Corollaire
#let corollaire = if _is-html {
  _html-thm("corollaire", t("Corollaire", "Corollary"), "thm-corollaire")
} else {
  thmbox("corollaire", t("Corollaire", "Corollary"),
    fill: rgb("#f8f0f8"), stroke: rgb("#9C27B0"), inset: 1em, radius: 4pt, base_level: 1)
}

// Définition
#let definition = if _is-html {
  _html-thm("definition", t("Définition", "Definition"), "thm-definition")
} else {
  thmbox("definition", t("Définition", "Definition"),
    fill: rgb("#f5f5f5"), stroke: rgb("#607D8B"), inset: 1em, radius: 4pt, base_level: 1)
}

// Théorème et définition
#let ThDef = if _is-html {
  _html-thm("thdef", t("Théorème et définition", "Theorem and Definition"), "thm-thdef")
} else {
  thmbox("thdef", t("Théorème et définition", "Theorem and Definition"),
    fill: rgb("#f0f0ff"), stroke: rgb("#3F51B5"), inset: 1em, radius: 4pt, base_level: 1)
}

// Conjecture
#let conjecture = if _is-html {
  _html-thm("conjecture", "Conjecture", "thm-conjecture")
} else {
  thmbox("conjecture", "Conjecture",
    fill: rgb("#fff0f0"), stroke: rgb("#f44336"), inset: 1em, radius: 4pt, base_level: 1)
}

// Invariant
#let invariant = if _is-html {
  _html-thm("invariant", t("Invariant", "Invariant"), "thm-invariant")
} else {
  thmbox("invariant", t("Invariant", "Invariant"),
    fill: rgb("#e8f8f8"), stroke: rgb("#00BCD4"), inset: 1em, radius: 4pt, base_level: 1)
}

// Remarque
#let remarque = if _is-html {
  _html-thm("remarque", t("Remarque", "Remark"), "thm-remarque")
} else {
  thmbox("remarque", t("Remarque", "Remark"),
    fill: rgb("#f8f7e8"), stroke: rgb("#d4b400"), inset: 1em, radius: 4pt, base_level: 1)
}

// Question ouverte
#let questionouverte = if _is-html {
  _html-thm("qo", t("Question ouverte", "Open Question"), "thm-qo")
} else {
  thmbox("qo", t("Question ouverte", "Open Question"),
    fill: rgb("#fffde8"), stroke: rgb("#FFC107"), inset: 1em, radius: 4pt, base_level: 1)
}

// -----------------------------------------------------------------------------
// Démonstration / Preuve
// -----------------------------------------------------------------------------

#let demo = if _is-html {
  _html-proof(t("Démonstration", "Proof"))
} else {
  thmproof("demo", t("Démonstration", "Proof"), base: "theoreme")
}

#let preuve = if _is-html {
  _html-proof(t("Preuve", "Proof"))
} else {
  thmproof("preuve", t("Preuve", "Proof"), base: "theoreme")
}

#let Preuve = preuve

// Démonstration triviale
#let demotriv = if _is-html {
  html.elem("div", attrs: (class: "thm-proof"), {
    html.elem("p", [
      #html.elem("em", t([Démonstration :], [Proof:]))
      #[ trivial.]
      #html.elem("span", attrs: (class: "qed"), [□])
    ])
  })
} else {
  t(
    [*Démonstration :* trivial. #h(1fr) $square$],
    [*Proof:* trivial. #h(1fr) $square$],
  )
}

// -----------------------------------------------------------------------------
// Citation de début de chapitre
// -----------------------------------------------------------------------------

#let citation(width: 55%, author, body) = {
  if _is-html {
    html.elem("blockquote", attrs: (class: "epigraph"), {
      html.elem("p", body)
      html.elem("footer", author)
    })
  } else {
    align(right, block(width: width, inset: 0em)[
      #set text(style: "italic", size: 0.95em)
      #align(left, body)
      #align(right, author)
    ])
  }
}

// -----------------------------------------------------------------------------
// Lettrine pour début chapitre
// -----------------------------------------------------------------------------

#let lettrine(word, body) = {
  if _is-html {
    html.elem("p", attrs: (class: "lettrine"), [#smallcaps(word) #body])
  } else {
    dropcap(height: 2, gap: 2pt, overhang: 4pt)[#smallcaps(word) #body]
  }
}

//-----------------------------------------------------------------------------
// Référence avec page si lointaine (fref)
// - En Typst, on utilise simplement @label qui gère automatiquement
// -----------------------------------------------------------------------------

// Raccourci pour <ref>, page <pageref>
// En HTML, pas de pagination → on utilise seulement ref(lab)
#let fref(lab) = if _is-html { ref(lab) } else { [#ref(lab), #ref(lab, form: "page")] }


//-----------------------------------------------------------------------------
// Wrapper pour subpar.grid avec numérotation par chapitre
// -----------------------------------------------------------------------------

#let subfig(..args) = {
  let grid = subpar.grid(
    ..args.named(),
    ..args.pos(),
    numbering: (..num-args) => [#counter(heading).get().at(0).#num-args.at(0)],
    numbering-sub-ref: (..nums, it) => [#counter(heading).get().at(0).#nums.at(0)#numbering("a", it)],
    supplement: [Figure],
    show-sub-caption: (it, body) => {
      set par(justify: true)
      text(size: 10pt, align(left, body))},
    grid-styles: (align),
    gutter: 0.2cm,
  )
  // En HTML, html.frame est nécessaire pour préserver les labels des sous-figures.
  // On contraint la largeur pour éviter un SVG trop large (rendu à la largeur PDF).
  if _is-html {
    html.frame(block(width: 42em, grid))
  } else {
    grid
  }
}
