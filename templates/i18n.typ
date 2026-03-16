// =============================================================================
// Internationalisation (i18n)
// =============================================================================
//
// Usage: typst compile --input lang=fr main.typ   (default)
//        typst compile --input lang=en main.typ
//
// In template files:
//   #import "i18n.typ": lang, t
//   #let name = t("Théorème", "Theorem")
//
// In main.typ:
//   #import "template/i18n.typ": lang, t
//   #if lang == "en" { include "chapters/ch1.en.typ" }
//   #else { include "chapters/ch1.typ" }
// =============================================================================

#let lang = sys.inputs.at("lang", default: "fr")

/// Pick the right value based on the current language.
/// t(french-value, english-value) → value for current lang
#let t(fr, en) = if lang == "en" { en } else { fr }
