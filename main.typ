// =============================================================================
// Thèse : Graphes du Web - Mesures d'importance à la PageRank
// Fabien Mathieu - 2004
// Conversion LaTeX → Typst - 2026
// =============================================================================
//
// Compilation:
//   typst compile --input lang=fr main.typ thesis-fr.pdf
//   typst compile --input lang=en main.typ thesis-en.pdf
// =============================================================================

// -----------------------------------------------------------------------------
// Imports
// -----------------------------------------------------------------------------

#import "templates/i18n.typ": lang, t
#import "templates/thesis-style.typ": *
#import "templates/math-macros.typ": *
#import "templates/environments.typ": *
#import "templates/algorithms.typ": *
#import "templates/acronyms.typ": *

// Initialiser les acronymes
#init-acronyms(acronyms)

// Appliquer le style de thèse
#show: thesis-style

// Note: les refs aux algorithmes utilisent #algref() car @alg: cause des problèmes avec ctheorems

// Configurer les théorèmes
#show: thmrules

// -----------------------------------------------------------------------------
// Page de titre
// -----------------------------------------------------------------------------

#title-page()

// -----------------------------------------------------------------------------
// Table des matières
// -----------------------------------------------------------------------------

#outline(
  title: t([Table des matières], [Table of Contents]),
  depth: 3,
  indent: auto,
)

#pagebreak()

// -----------------------------------------------------------------------------
// Remerciements
// -----------------------------------------------------------------------------

#if lang == "en" {
  include "chapters/remerciements.en.typ"
} else {
  include "chapters/remerciements.typ"
}

// -----------------------------------------------------------------------------
// Introduction
// -----------------------------------------------------------------------------

#if lang == "en" {
  include "chapters/introduction.en.typ"
} else {
  include "chapters/introduction.typ"
}

// =============================================================================
// PARTIE I : Structures du Web
// =============================================================================

#partie(t([Structures du Web], [Structures of the Web]))

#if lang == "en" {
  include "chapters/ch1-taille.en.typ"
} else {
  include "chapters/ch1-taille.typ"
}

#if lang == "en" {
  include "chapters/ch2-graphe.en.typ"
} else {
  include "chapters/ch2-graphe.typ"
}

#if lang == "en" {
  include "chapters/ch3-local.en.typ"
} else {
  include "chapters/ch3-local.typ"
}

// =============================================================================
// PARTIE II : Algorithmes de classement de pages web : les « PageRank »
// =============================================================================

#partie(t(
  [Algorithmes de classement de pages web : \ les « PageRank »],
  [Web Page Ranking Algorithms: \ PageRank],
))

#if lang == "en" {
  include "chapters/ch4-markov.en.typ"
} else {
  include "chapters/ch4-markov.typ"
}

#if lang == "en" {
  include "chapters/ch5-pagerank.en.typ"
} else {
  include "chapters/ch5-pagerank.typ"
}

#if lang == "en" {
  include "chapters/ch6-back.en.typ"
} else {
  include "chapters/ch6-back.typ"
}

#if lang == "en" {
  include "chapters/ch7-dpr.en.typ"
} else {
  include "chapters/ch7-dpr.typ"
}

// -----------------------------------------------------------------------------
// Conclusion
// -----------------------------------------------------------------------------

#if lang == "en" {
  include "chapters/conclusion.en.typ"
} else {
  include "chapters/conclusion.typ"
}

// =============================================================================
// ANNEXES
// =============================================================================

#appendix[
  #if lang == "en" {
    include "appendices/annexeA-PF.en.typ"
  } else {
    include "appendices/annexeA-PF.typ"
  }
  #if lang == "en" {
    include "appendices/annexe-inria.en.typ"
  } else {
    include "appendices/annexe-inria.typ"
  }
  #if lang == "en" {
    include "appendices/p2p-missing.en.typ"
  } else {
    include "appendices/p2p-missing.typ"
  }
]

// -----------------------------------------------------------------------------
// Bibliographie
// -----------------------------------------------------------------------------

#pagebreak()
#set page(header: [
#align(left, text(size: 0.9em, style: "italic")[#t([Bibliographie], [Bibliography])])
#line(length: 100%, stroke: 0.5pt)])
#bibliography("bibliography.yml", style: "ieee")

// -----------------------------------------------------------------------------
// Quatrième de couverture
// -----------------------------------------------------------------------------

#back-cover()
