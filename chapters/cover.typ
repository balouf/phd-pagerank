// Page de couverture HTML (bilingue)

#import "../templates/meta-data.typ": thesis-title, thesis-author, thesis-type, thesis-date, thesis-jury, jury-role, french-abstract, english-abstract
#import "../templates/i18n.typ": t

#html.elem("header", attrs: (class: "thesis-header"))[
  #html.elem("p", attrs: (class: "institution"))[Université Montpellier II]
  #html.elem("p", attrs: (class: "thesis-type"))[#thesis-type]
  #html.elem("h1", attrs: (class: "thesis-title"))[
    #thesis-title
  ]
  #html.elem("p", attrs: (class: "author"))[#thesis-author]
  #html.elem("div", attrs: (class: "defense"))[
    #html.elem("p")[
      #t(
        [Soutenue le #thesis-date devant le jury composé de :],
        [Defended on #thesis-date before a committee of:],
      )
    ]
    #if thesis-jury.len() > 0 {
      html.elem("ul", attrs: (class: "jury"), {
        for member in thesis-jury {
          html.elem("li")[
            #member.name, #member.position — _#jury-role(member.role-key)_
          ]
        }
      })
    }
  ]
  #html.elem("div", attrs: (class: "abstract"))[
    #t(french-abstract, english-abstract)
  ]
  #html.elem("p", attrs: (class: "pdf-download"))[
    #html.elem("a", attrs: (href: t("../pdf/thesis-fr.pdf", "../pdf/thesis-en.pdf"), class: "btn-pdf"))[
      #t([📄 Télécharger le PDF], [📄 Download PDF])
    ]
  ]
]
