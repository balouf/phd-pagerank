// =============================================================================
// Gestion des acronymes - Package Acrostiche
// =============================================================================

#import "@preview/acrostiche:0.7.0": *
#import "i18n.typ": lang, t

#let acronyms = (
  // ---------------------------------------------------------------------------
  // Théorie des graphes et structure du Web
  // ---------------------------------------------------------------------------
  "AUP": ("Acceptable Use Policy", "Acceptable Use Policies"),
  "CERN": ("Centre Européen pour la Recherche Nucléaire",),
  "SCC": ("Strongly Connected Component", "Strongly Connected Components"),
  "DAG": ("Directed Acyclic Graph", "Directed Acyclic Graphs"),

  // ---------------------------------------------------------------------------
  // Algorithmes - Seulement les vrais acronymes
  // ---------------------------------------------------------------------------

  "HITS": ("Hyperlink-Induced Topic Search",),
  "PRMI": ("PageRank Minimal d'Insertion",),

  // ---------------------------------------------------------------------------
  // Algorithme spécifique à la thèse
  // ---------------------------------------------------------------------------

  "plf": (t("Parcours en Largeur Filtré", "Filtered Breadth-First Search"),),

  // ---------------------------------------------------------------------------
  // Protocoles et technologies Web fondamentaux
  // ---------------------------------------------------------------------------
  
  "IMDB": ("Internet Movie Database",),
  "HTTP": ("HyperText Transfer Protocol",),
  "WWW": ("World Wide Web",),
  "P2P": (t("pair-à-pair", "peer-to-peer"),),
  "HTML": ("HyperText Markup Language",),
  "URL": ("Uniform Resource Locator", "Uniform Resource Locators"),
  "DNS": ("Domain Name System",),
  "FTP": ("File Transfer Protocol",),
  "XML": ("eXtensible Markup Language",),
  "WML": ("Wireless Markup Language",),
  "PDF": ("Portable Document Format",),
  "TCP/IP": ("Transmission Control Protocol/Internet Protocol",),
  "IP": ("Internet Protocol",),

  // ---------------------------------------------------------------------------
  // Termes Internet spécifiques au domaine
  // ---------------------------------------------------------------------------

  "TLD": ("Top Level Domain", "Top Level Domains"),
  "gTLD": ("generic Top Level Domain", "generic Top Level Domains"),
  "ccTLD": ("country code Top Level Domain", "country code Top Level Domains"),
  "IANA": ("Internet Assigned Numbers Authority",),
  "ISP": ("Internet Service Provider", "Internet Service Providers"),
  "RFC": ("Request for Comments",),
)

// Note: L'initialisation d'acrostiche doit être faite dans main.typ
// après l'import de ce fichier, avec: #init-acronyms(acronyms)

// Helper pour forme longue seule
#let acrl(key) = {
  let entry = acronyms.at(key)
  entry.at(0)  // premier élément = forme longue
}

// =============================================================================
// NOTES DE MAINTENANCE
// =============================================================================
//
// AJOUT D'ACRONYMES :
// - Ajouter dans la section appropriée du dictionnaire `acronyms`
// - Format : "KEY": ("Forme longue", "Forme longue pluriel"),
// - Si pas de pluriel : "KEY": ("Forme longue",),
//
// UTILISATION DANS LES CHAPITRES :
// - Acronyme standard : #acr("SCC")
// - Pluriel : #acrpl("URL")
//
// NE PAS INCLURE COMME ACRONYMES :
// - Noms propres d'organisations : INRIA, CNRS, LIRMM → utiliser #smallcaps[INRIA]
//
// EXEMPLES D'UTILISATION :
//
// #acr("SCC")        // Première fois: "Strongly Connected Component (SCC)"
//                    // Ensuite: "SCC"
//
// #acrpl("URL")      // Première fois: "Uniform Resource Locators (URLs)"
//                    // Ensuite: "URLs"
//
