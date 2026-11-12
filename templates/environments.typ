// =============================================================================
// Environments - Théorèmes, définitions, preuves, etc.
// =============================================================================

#import "@preview/ctheorems:1.1.3": *
#import "@preview/droplet:0.3.1": dropcap
#import "@preview/subpar:0.2.2"
#import "i18n.typ": lang, t

// -----------------------------------------------------------------------------
// Configuration des théorèmes avec ctheorems
// -----------------------------------------------------------------------------

#let theorem-rules = thmrules.with(qed-symbol: $square$)

// Théorème
#let theoreme = thmbox("theoreme", t("Théorème", "Theorem"),
  fill: rgb("#e8f4f8"), stroke: rgb("#2196F3"), inset: 1em, radius: 4pt, base_level: 1)

// Théorème en annexe
#let annexe_theoreme = thmbox("theoreme", t("Théorème", "Theorem"),
  fill: rgb("#e8f4f8"), stroke: rgb("#2196F3"), inset: 1em, radius: 4pt, base_level: 1,
).with(numbering: "A.1")

// Alias
#let Th = theoreme
#let Thm = theoreme

// Lemme
#let lemme = thmbox("lemme", t("Lemme", "Lemma"),
  fill: rgb("#f0f8e8"), stroke: rgb("#4CAF50"), inset: 1em, radius: 4pt, base_level: 1)

#let annexe_lemme = thmbox("lemme", t("Lemme", "Lemma"),
  fill: rgb("#f0f8e8"), stroke: rgb("#4CAF50"), inset: 1em, radius: 4pt, base_level: 1,
).with(numbering: "A.1")

#let lemmebreak = lemme

// Proposition
#let proposition = thmbox("proposition", "Proposition",
  fill: rgb("#fff8e8"), stroke: rgb("#FF9800"), inset: 1em, radius: 4pt, base_level: 1)

// Corollaire
#let corollaire = thmbox("corollaire", t("Corollaire", "Corollary"),
  fill: rgb("#f8f0f8"), stroke: rgb("#9C27B0"), inset: 1em, radius: 4pt, base_level: 1)

// Définition
#let definition = thmbox("definition", t("Définition", "Definition"),
  fill: rgb("#f5f5f5"), stroke: rgb("#607D8B"), inset: 1em, radius: 4pt, base_level: 1)

// Théorème et définition
#let ThDef = thmbox("thdef", t("Théorème et définition", "Theorem and Definition"),
  fill: rgb("#f0f0ff"), stroke: rgb("#3F51B5"), inset: 1em, radius: 4pt, base_level: 1)

// Conjecture
#let conjecture = thmbox("conjecture", "Conjecture",
  fill: rgb("#fff0f0"), stroke: rgb("#f44336"), inset: 1em, radius: 4pt, base_level: 1)

// Invariant
#let invariant = thmbox("invariant", t("Invariant", "Invariant"),
  fill: rgb("#e8f8f8"), stroke: rgb("#00BCD4"), inset: 1em, radius: 4pt, base_level: 1)

// Remarque
#let remarque = thmbox("remarque", t("Remarque", "Remark"),
  fill: rgb("#f8f7e8"), stroke: rgb("#d4b400"), inset: 1em, radius: 4pt, base_level: 1)

// Question ouverte
#let questionouverte = thmbox("qo", t("Question ouverte", "Open Question"),
  fill: rgb("#fffde8"), stroke: rgb("#FFC107"), inset: 1em, radius: 4pt, base_level: 1)

// -----------------------------------------------------------------------------
// Démonstration / Preuve
// -----------------------------------------------------------------------------

#let demo = thmproof("demo", t("Démonstration", "Proof"), base: "theoreme")

#let preuve = thmproof("preuve", t("Preuve", "Proof"), base: "theoreme")

#let Preuve = preuve

// Démonstration triviale
#let demotriv = t(
  [*Démonstration :* trivial. #h(1fr) $square$],
  [*Proof:* trivial. #h(1fr) $square$],
)

// -----------------------------------------------------------------------------
// Citation de début de chapitre
// -----------------------------------------------------------------------------

#let citation(width: 55%, author, body) = context {
  if target() == "paged" {
    align(right, block(width: width, inset: 0em)[
      #set text(style: "italic", size: 0.95em)
      #align(left, body)
      #align(right, author)
    ])
  } else {
    html.elem("blockquote", attrs: (class: "epigraph"), {
      html.elem("p", body)
      html.elem("footer", attrs: (class: "epigraph-author"), author)
    })
  }
}

// -----------------------------------------------------------------------------
// Lettrine pour début chapitre
// -----------------------------------------------------------------------------

#let lettrine(word, body) = context {
  if target() == "paged" {
    dropcap(height: 2, gap: 2pt, overhang: 4pt)[#smallcaps(word) #body]
  } else {
    html.elem("p", attrs: (class: "lettrine"), [#smallcaps(word) #body])
  }
}

//-----------------------------------------------------------------------------
// Référence avec page si lointaine (fref)
// - En Typst, on utilise simplement @label qui gère automatiquement
// -----------------------------------------------------------------------------

// Raccourci pour <ref>, page <pageref>
// En HTML, pas de pagination → on utilise seulement ref(lab)
#let fref(lab) = context if target() == "paged" { [#ref(lab), #ref(lab, form: "page")] } else { ref(lab) }


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
  // Rendu tel quel dans les deux éditions : en HTML, la couche web encadre la
  // grille en SVG et garde la légende principale en texte. La fonction doit
  // renvoyer la figure elle-même (pas un bloc `context`) pour que le label posé
  // à l'appel s'y attache.
  grid
}
