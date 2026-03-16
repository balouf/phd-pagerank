// Cover page HTML (English version)

#import "../templates/thesis-style.typ": english-abstract

#html.elem("header", attrs: (class: "thesis-header"))[
  #html.elem("p", attrs: (class: "institution"))[Université Montpellier II]
  #html.elem("h1", attrs: (class: "thesis-title"))[
    Web Graphs — PageRank-like Importance Measures
  ]
  #html.elem("p", attrs: (class: "author"))[Fabien Mathieu]
  #html.elem("p", attrs: (class: "date"))[December 8, 2004]
  #html.elem("p", attrs: (class: "abstract"))[
    #english-abstract
  ]
  #html.elem("p", attrs: (class: "pdf-download"))[
    #html.elem("a", attrs: (href: "../pdf/thesis-en.pdf", class: "btn-pdf"))[
      📄 Download PDF
    ]
  ]
]
