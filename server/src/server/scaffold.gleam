import lustre/attribute.{attribute, href, id, name, rel, src, type_}
import lustre/element.{type Element}
import lustre/element/html.{body, div, head, html, link, meta, script, title}

pub fn page_scaffold() -> Element(a) {
  html([], [
    head([], [
      meta([attribute("charset", "UTF-8")]),
      meta([
        attribute("content", "width=device-width, initial-scale=1.0"),
        name("viewport"),
      ]),
      todo as "Edit Title",
      title([], "Your Title"),
      meta([attribute("content", "Your Description"), name("description")]),
      todo as "Edit Locale",
      meta([attribute("content", "pt_BR"), attribute("property", "og:locale")]),
      meta([
        attribute("content", "Your Title"),
        attribute("property", "og:site_name"),
      ]),
      meta([attribute("content", "website"), attribute("property", "og:type")]),
      meta([
        attribute("content", " Your Title"),
        attribute("property", "og:title"),
      ]),
      meta([
        attribute("content", "Your Description"),
        attribute("property", "og:description"),
      ]),
      link([href("/static/favicon.ico"), type_("image/x-icon"), rel("icon")]),
      link([
        href("/static/client.min.css"),
        type_("text/css"),
        rel("stylesheet"),
      ]),
      script([src("/static/client.min.mjs"), type_("module")], ""),
    ]),
    body([], [div([id("app")], [])]),
  ])
}
