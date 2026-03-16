#import "@preview/algo:0.3.6": algo, i, d, no-emph, comment
#import "i18n.typ": lang, t

#let keywords = t(
  ("Données", "début", "Résultat", "si", "tant que", "faire", "alors", "retourner", "pour"),
  ("Input", "begin", "Output", "if", "while", "do", "then", "return", "for", "Result", "Data"),
)


#let alg(..args, body) = {
figure(
  algo(
    comment-prefix: [#sym.triangle.stroked.r ],
    comment-styles: (fill: rgb(100%, 0%, 0%)),
    line-numbers: false, keywords: keywords,
    indent-size: 15pt, indent-guides: 1pt+gray,
  )[#body],
  supplement: t("Algorithme", "Algorithm"),
  kind: "algorithm",
  ..args
)
}
