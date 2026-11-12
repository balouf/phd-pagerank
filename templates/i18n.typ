// =============================================================================
// Internationalisation et configuration partagée
// =============================================================================
//
// Usage: typst compile --input lang=fr main.typ   (default)
//        typst compile --input lang=en main.typ
//
// In template files:
//   #import "i18n.typ": lang, t, _appendix-state, reset-chapter-counters
//
// In main.typ:
//   #import "templates/i18n.typ": lang, t
//   #if lang == "en" { include "chapters/ch1.en.typ" }
//   #else { include "chapters/ch1.typ" }
// =============================================================================

#let lang = sys.inputs.at("lang", default: "fr")

/// Pick the right value based on the current language.
/// t(french-value, english-value) → value for current lang
#let t(fr, en) = if lang == "en" { en } else { fr }

// -----------------------------------------------------------------------------
// Configuration partagée (utilisée par thesis-style.typ, environments.typ, etc.)
// -----------------------------------------------------------------------------

/// État pour distinguer chapitres et annexes dans les références et la numérotation
#let _appendix-state = state("appendix", false)

/// Réinitialise les compteurs au début de chaque chapitre/annexe. Les théorèmes
/// (ctheorems) suivent d'eux-mêmes le numéro de chapitre.
#let reset-chapter-counters() = {
  counter(footnote).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: "algorithm")).update(0)
  counter(math.equation).update(0)
}
