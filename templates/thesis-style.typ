// =============================================================================
// Thesis Style - Style de thèse Université Montpellier II
// =============================================================================

#import "i18n.typ": lang, t, _is-html, _appendix-state, reset-chapter-counters
#import "meta-data.typ": *

// -----------------------------------------------------------------------------
// Configuration de la page de titre
// -----------------------------------------------------------------------------

#let title-page() = {
  set page(numbering: none)
  set align(center)

  v(1fr)

  smallcaps[Académie de Montpellier]

  v(1fr)

  text(size: 1.9em, )[
    #smallcaps[#strong[U]niversité #strong[M]ontpellier *II*]
  ]

  v(1fr)


  smallcaps[--- #strong[S]ciences et #strong[T]echnique du #strong[L]anguedoc ---]

  v(1fr)

  text(size: 1.5em, weight: "bold")[#t([T H È S E], [D I S S E R T A T I O N])]

  v(1fr)

  t(
    [
      présentée à l'Université des Sciences et Techniques du Languedoc \
      pour obtenir le diplôme de doctorat
    ],
    [
      presented at the University of Sciences and Technology of Languedoc \
      in fulfillment of the requirements for the degree of Doctor of Philosophy
    ],
  )

  v(0.5em)

  table(
    columns: 2,
    align: (right, left),
    stroke: none,
    inset: 0.3em,
    [#smallcaps[#t([Spécialité], [Specialty])]], [: *#thesis-specialty*],
    [_#t([Formation Doctorale], [Doctoral Program])_], [: *#thesis-formation*],
    [_#t([École Doctorale], [Doctoral School])_], [: *#thesis-doctoral-school*],
  )

  v(1fr)

  text(size: 1.5em, weight: "bold")[
    #thesis-title
  ]

  v(1fr)

  text(size: 1.2em)[#t([par], [by]) #thesis-author]

  v(1fr)

  text(size: 0.9em)[
    #t(
      [Soutenue le #thesis-date devant le jury composé de :],
      [Defended on #thesis-date before a committee of:],
    )
  ]

  v(0.5em)

for member in thesis-jury {
    text(size: 0.85em)[#member.name, #member.position]
    box(width: 1fr, repeat[.])
    text(size: 0.85em)[#jury-role(member.role-key) \ ]
  }
  v(1fr)

  pagebreak()
}

// -----------------------------------------------------------------------------
// Configuration de la quatrième de couverture
// -----------------------------------------------------------------------------

#let back-cover() = {
  pagebreak()
  set align(center)
  set page(header: none, footer: none)

  v(1fr)

  strong[Résumé]
  v(.5fr)

  set align(left)
  text(size: 0.95em)[
    #french-abstract
  ]

  set align(center)
  v(1em)
  strong[Mots clés]
  v(.5fr)
  french-keywords

  v(2fr)

  strong[Abstract]
  v(.5fr)
  set align(left)
  text(size: 0.95em)[
    #english-abstract
  ]

  set align(center)
  v(1em)
  strong[Keywords]
  v(.5fr)
  english-keywords
  v(2fr)

  text(size: 0.85em, smallcaps[Lirmm] + [ --- 161 rue Ada --- 34392 Montpellier Cedex 5 --- France])

  v(1fr)
}

// -----------------------------------------------------------------------------
// Configuration générale du document
// -----------------------------------------------------------------------------

#let thesis-style(doc) = {
  // Configuration de la page
  set page(
    paper: "a4",
    margin: (
      top: 2.5cm,
      bottom: 2.5cm,
      inside: 3cm,
      outside: 2.5cm,
    ),
    numbering: "1",
    number-align: center,
    header: context {
      let page-num = counter(page).get().first()
      if page-num > 1 {
        if calc.odd(page-num) {
          // Page impaire : section à droite
          let sections = query(heading.where(level: 2))
          let current-section = sections.filter(h => h.location().page() <= page-num)
          if current-section.len() > 0 {
            let my-section = current-section.last()
            let num = counter(heading).at(my-section.location())
            align(right, text(size: 0.9em)[
            #numbering("1.1", ..num) --- #smallcaps(my-section.body)])
          }
        } else {
        // Page paire : chapitre à gauche
        let chapters = query(heading.where(level: 1))
        let current-chapter = chapters.filter(h => h.location().page() <= page-num).last()
          if current-chapter != none {
            let num = counter(heading).at(current-chapter.location())
            let chapt-prefix = if num.at(0) == 0 {""} else [#t([Chap.], [Ch.]) #numbering("1", ..num)  ---]
          align(left, text(size: 0.9em, style: "italic")[
            #chapt-prefix #current-chapter.body
          ])}
        }
        line(length: 100%, stroke: 0.5pt)
      }
    },
  )

  // Configuration du texte
  set text(
    font: "New Computer Modern",
    size: 12pt,
    lang: t("fr", "en"),
    region: t("FR", "US"),
  )

  // Configuration des paragraphes
  set par(
    justify: true,
    leading: 0.65em,
    first-line-indent: 1.5em,
  )

  // Configuration des titres
  set heading(numbering: "1.1", supplement: [Section])

  // Références vers headings level 1 : "Chapitre X" ou "Annexe A" selon le contexte
  // On ne touche pas aux refs avec form: "page" (utilisées par fref pour "page YY")
  show ref: it => context {
    if it.form == "page" { return it }
    let els = query(it.target)
    if els.len() > 0 {
      let el = els.first()
      if el.func() == heading and el.level == 1 and el.numbering != none {
        let loc = el.location()
        let nums = counter(heading).at(loc)
        let is-appendix = _appendix-state.at(loc)
        let supp = if is-appendix { t([Annexe], [Appendix]) } else { t([Chapitre], [Chapter]) }
        let num-fmt = if is-appendix { "A" } else { "1" }
        link(loc, [#supp #numbering(num-fmt, nums.first())])
      } else {
        it
      }
    } else {
      it
    }
  }


  // Style des titres (tous niveaux)
  show heading: it => context {
    if it.level == 1 {
      // Chapitres et annexes
      pagebreak(weak: true)
      v(2cm)
      set text(size: 1.8em, weight: "bold")
      let prefix = if _appendix-state.get() { t([Annexe], [Appendix]) } else { t([Chapitre], [Chapter]) }
      block[
        #if it.numbering != none {
          [#prefix #counter(heading).display() \ ]
        }
        #it.body
      ]
      v(1cm)
      reset-chapter-counters()
    } else if it.level <= 3 {
      // Sections et sous-sections
      let (size, v-before, v-after) = if it.level == 2 {
        (1.4em, 1.5em, 0.8em)
      } else {
        (1.2em, 1em, 0.5em)
      }
      v(v-before)
      set text(size: size, weight: "bold")
      block[
        #if it.numbering != none {
          counter(heading).display()
          h(0.5em)
        }
        #it.body
      ]
      v(v-after)
    } else {
      block(it.body)
    }
  }

  // Configuration des figures
  set figure(
    placement: auto,
    gap: 1em,
    numbering: (..args) => [#counter(heading).get().at(0).#args.at(0)]
  )

  // Différencier les suppléments selon le type de contenu
  show figure.where(kind: image): set figure(supplement: [Figure])
  show figure.where(kind: table): set figure(supplement: t([Tableau], [Table]))

  show figure.caption: it => {
    set text(size: 0.9em)
    set align(left)
    set par(justify: true)
    it
  }

  // Configuration des équations
  set math.equation(numbering: (..args) => [(#counter(heading).get().at(0).#args.at(0))])

  // Citations bibliographiques
  set cite(style: "alphanumeric")

  // Guillemets français
  set smartquote(enabled: true)

  doc
}

// -----------------------------------------------------------------------------
// Partie (Part)
// -----------------------------------------------------------------------------

// Compteur de parties
#let partie-counter = counter("partie")

#let partie(title) = {
  pagebreak()
  partie-counter.step()
  page(numbering: none)[
    #align(center + horizon)[
      #text(size: 1.5em)[#t([Partie], [Part]) #context partie-counter.display("I")]
      #v(1em)
      #text(size: 2em, weight: "bold")[#title]
    ]
  ]
}

// --------------------------------------------------------------------------------
// Appendices
// --------------------------------------------------------------------------------

#let appendix(body) = {
  pagebreak()
  set heading(numbering: (..nums) => {
    let n = nums.pos().len()
    if n > 1 {
      numbering("1.1", ..nums.pos().slice(1))
    } else {
      numbering("A", ..nums.pos())
    }
  })
  _appendix-state.update(true)
  counter(heading).update(0)

  let to-letter(n, upper: true) = {
    let letters = if upper {
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    } else {
      "abcdefghijklmnopqrstuvwxyz"
    }
    letters.at(calc.rem(n - 1, 26))
  }

  set math.equation(numbering: (..args) => [(#to-letter(counter(heading).get().at(0)).#args.at(0))])

  // Configuration de la page (header annexes)
  set page(
    header: context {
      let page-num = counter(page).get().first()
      if page-num > 1 {
        if calc.odd(page-num) {
        } else {
          // Page paire : annexe à gauche
          let chapters = query(heading.where(level: 1))
          let current-chapter = chapters.filter(h => h.location().page() <= page-num).last()
          if current-chapter != none {
            let num = counter(heading).at(current-chapter.location())
            let chapt-prefix = if num.at(0) == 0 { "" } else [#t([Annexe.], [App.]) #numbering("A", ..num)  ---]
            align(left, text(size: 0.9em, style: "italic")[
              #chapt-prefix #current-chapter.body
            ])
          }
        }
        line(length: 100%, stroke: 0.5pt)
      }
    },
  )

  body
}
