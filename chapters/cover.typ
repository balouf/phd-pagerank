// Page de couverture HTML (version française)

#import "../templates/thesis-style.typ": french-abstract

#html.elem("header", attrs: (class: "thesis-header"))[
  #html.elem("p", attrs: (class: "institution"))[Université Montpellier II]
  #html.elem("h1", attrs: (class: "thesis-title"))[
    Graphes du Web — Mesures d'importance à la PageRank
  ]
  #html.elem("p", attrs: (class: "author"))[Fabien Mathieu]
  #html.elem("p", attrs: (class: "date"))[8 décembre 2004]
  #html.elem("p", attrs: (class: "abstract"))[
    #french-abstract
  ]
  #html.elem("p", attrs: (class: "pdf-download"))[
    #html.elem("a", attrs: (href: "../pdf/thesis-fr.pdf", class: "btn-pdf"))[
      📄 Télécharger le PDF
    ]
  ]
]
