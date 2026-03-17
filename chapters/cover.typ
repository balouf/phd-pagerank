// Page de couverture HTML (bilingue)

#import "../templates/meta-data.typ": thesis-title, thesis-author, thesis-date, french-abstract, english-abstract
#import "../templates/i18n.typ": t

#html.elem("header", attrs: (class: "thesis-header"))[
  #html.elem("p", attrs: (class: "institution"))[Université Montpellier II]
  #html.elem("h1", attrs: (class: "thesis-title"))[
    #thesis-title
  ]
  #html.elem("p", attrs: (class: "author"))[#thesis-author]
  #html.elem("p", attrs: (class: "date"))[#thesis-date]
  #html.elem("p", attrs: (class: "abstract"))[
    #t(french-abstract, english-abstract)
  ]
  #html.elem("p", attrs: (class: "pdf-download"))[
    #html.elem("a", attrs: (href: t("../pdf/thesis-fr.pdf", "../pdf/thesis-en.pdf"), class: "btn-pdf"))[
      #t([📄 Télécharger le PDF], [📄 Download PDF])
    ]
  ]
]
