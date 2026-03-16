// =============================================================================
// Thesis Style - Style de thèse Université Montpellier II
// =============================================================================

#import "i18n.typ": lang, t

// Détection du mode HTML (passé via --input html=true)
#let _is-html = sys.inputs.at("html", default: "false") == "true"

// État pour distinguer chapitres et annexes dans les références
#let _appendix-state = state("appendix", false)

// -----------------------------------------------------------------------------
// Données de la thèse
// -----------------------------------------------------------------------------

#let french-abstract = [
L'application des mesures d'importance de type PageRank aux graphes du Web est le sujet de cette thèse, qui est divisée en deux parties. La première introduit une famille particulière de grands graphes, les graphes du Web. Elle commence par définir la notion de Web indexable, puis donne quelques considérations sur les tailles des portions de Web effectivement indexées. Pour finir, elle donne et utilise quelques constatations sur les structures que l'on peut observer sur les graphes induits par ces portions de Web.

Ensuite, la seconde partie étudie en profondeur les mesures d'importance _à la_ PageRank. Après un rappel sur la théorie des chaînes de Markov est présentée une classification originale des algorithmes de PageRank, qui part du modèle le plus simple jusqu'à prendre en compte toutes les spécificités liées aux graphes du Web. Enfin, de nouveaux algorithmes sont proposés. L'algorithme _BackRank_ utilise un modèle alternatif de parcours du graphe du Web pour un calcul de PageRank plus rapide. La structure fortement clusterisée des graphes du Web permet quant à elle de décomposer le PageRank sur les sites Web, ce qui est réalisé par les algorithmes _FlowRank_ et _BlowRank_.
]

#let french-keywords = [
  Graphes --- Web --- Arbre de décomposition --- Matrices sous-stochastiques \ PageRank --- Surfeur aléatoire --- Algorithmes --- Retour arrière -- Flots d'importance
]

#let english-abstract = [
  The purpose of this thesis is to apply PageRank-like measures to Web graphs. The first part introduces the Web graphs. First we define the notion of indexable Web, then we give an insight on how big the effective crawls really are. Finally, we notice and use some of the structures that exist on the portions of the Web known as Web graphs.

  Then, the second part study deeply the PageRank algorithms. After a remainder on Markov chains theory is given an original classification of PageRank algorithms. From a basic model, we incorporate all the specificities needed to cope with real Web graphs. Lastly, new algorithms are proposed. BackRank uses an alternative random surfer modeling leading to a faster computation. The highly clustered structure of Web graphs allows a PageRank decomposition according to Web sites, and is the reason for introducing the algorithms FlowRank and BlowRank.
]

#let english-keywords = [
  Graphs --- WWW --- Decomposition tree --- Substochastic matrix \ PageRank --- Random walk --- Algorithms --- Backoff process --- Importance flows
]


#let thesis-title = t(
  [#smallcaps[Graphes du Web] \ #smallcaps[Mesures d'importance à la PageRank]],
  [#smallcaps[Web Graphs] \ #smallcaps[PageRank-like Importance Measures]],
)

#let thesis-author = [Fabien #smallcaps[Mathieu]]
#let thesis-date = t([8 décembre 2004], [December 8, 2004])
#let thesis-specialty = [Informatique]
#let thesis-doctoral-school = [Information, Structures, Systèmes]
#let thesis-formation = [Informatique]

#let thesis-jury = (
  (
    name: [M. Serge #smallcaps[Abiteboul]],
    position: [Directeur de recherche, INRIA],
    role-key: "reviewer",
  ),
  (
    name: [M. Vincent #smallcaps[Blondel]],
    position: t([Professeur, UCL (Belgique)], [Professor, UCL (Belgium)]),
    role-key: "guest",
  ),
  (
    name: [M. Pierre #smallcaps[Fraigniaud]],
    position: [Directeur de recherche, CNRS],
    role-key: "reviewer",
  ),
  (
    name: [M. Michel #smallcaps[Habib]],
    position: t([Professeur, LIRMM, Montpellier], [Professor, LIRMM, Montpellier]),
    role-key: "advisor",
  ),
  (
    name: [M. Alain #smallcaps[Jean-Marie]],
    position: [Directeur de recherche, INRIA],
    role-key: "chair",
  ),
  (
    name: [M. Laurent #smallcaps[Viennot]],
    position: t([Chargé de recherche, INRIA], [Research Scientist, INRIA]),
    role-key: "coadvisor",
  ),
)

#let jury-role(key) = {
  let roles = (
    reviewer: t("rapporteur", "reviewer"),
    guest: t("invité", "guest"),
    advisor: t("directeur de thèse", "thesis advisor"),
    chair: t("président", "chair"),
    coadvisor: t("co-encadrant", "co-advisor"),
  )
  roles.at(key)
}

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


  // Style des titres de niveau 1 (chapitres)
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(2cm)
    set text(size: 1.8em, weight: "bold")
    block[
      #if it.numbering != none {
        [#t([Chapitre], [Chapter]) #counter(heading).display() \ ]
      }
      #it.body
    ]
    v(1cm)
    counter(footnote).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: "algorithm")).update(0)
    counter(math.equation).update(0)
  }

  // Style des titres de niveau 2 (sections)
  show heading.where(level: 2): it => {
    v(1.5em)
    set text(size: 1.4em, weight: "bold")
    block[
      #if it.numbering != none {
        counter(heading).display()
        h(0.5em)
      }
      #it.body
    ]
    v(0.8em)
  }

  // Style des titres de niveau 3 (sous-sections)
  show heading.where(level: 3): it => {
    v(1em)
    set text(size: 1.2em, weight: "bold")
    block[
      #if it.numbering != none {
        counter(heading).display()
        h(0.5em)
      }
      #it.body
    ]
    v(0.5em)
  }

  // Configuration des titres de niveau 4 et plus (sous-sous-sections, etc.)
  show heading: it => {
    if it.level > 3 {block(it.body)} else {it}}

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
    }
  else {
    numbering("A", ..nums.pos())
    }
})
_appendix-state.update(true)
counter(heading).update(0)


let to-letter(n, upper: true) = {
let letters = if upper {
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
  else { "abcdefghijklmnopqrstuvwxyz" }
  letters.at(calc.rem(n - 1, 26))
}

set math.equation(numbering: (..args) => [(#to-letter(counter(heading).get().at(0)).#args.at(0))])


// Style des titres de niveau 1 (Appendices)
show heading.where(level: 1): it => context {
  if _is-html {
    let num-display = if it.numbering != none {
      t([Annexe ], [Appendix ]) + counter(heading).display() + [ — ]
    }
    let label-id = if it.has("label") { str(it.label) } else { none }
    let content = [#num-display#it.body]
    if label-id != none {
      html.elem("h1", attrs: (id: label-id), content)
    } else {
      html.elem("h1", content)
    }
    counter(footnote).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: "algorithm")).update(0)
    counter(math.equation).update(0)
    for id in ("theoreme", "lemme", "proposition", "corollaire", "definition",
                "thdef", "conjecture", "invariant", "remarque", "qo") {
      counter(figure.where(kind: "thm-" + id)).update(0)
    }
  } else {
    pagebreak(weak: true)
    v(2cm)
    set text(size: 1.8em, weight: "bold")
    block[
      #if it.numbering != none {
        [#t([Annexe], [Appendix]) #counter(heading).display() \ ]
      }
      #it.body
    ]
    v(1cm)
    counter(footnote).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: "algorithm")).update(0)
    counter(math.equation).update(0)
  }
}



  // Configuration de la page
  set page(
    header: context {
      let page-num = counter(page).get().first()
      if page-num > 1 {
        if calc.odd(page-num) {
        } else {
        // Page paire : chapitre à gauche
        let chapters = query(heading.where(level: 1))
        let current-chapter = chapters.filter(h => h.location().page() <= page-num).last()
          if current-chapter != none {
            let num = counter(heading).at(current-chapter.location())
            let chapt-prefix = if num.at(0) == 0 {""} else [#t([Annexe.], [App.]) #numbering("A", ..num)  ---]
          align(left, text(size: 0.9em, style: "italic")[
            #chapt-prefix #current-chapter.body
          ])}
        }
        line(length: 100%, stroke: 0.5pt)
      }
    },
  )

  body
}
