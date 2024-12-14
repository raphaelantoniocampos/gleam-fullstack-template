import lustre/attribute.{class, href, target}
import lustre/element.{type Element, text}
import lustre/element/html.{a, div, footer, i, p}

pub fn footer_view() -> Element(a) {
  todo as "Edit footer"
  footer([], [
    div([], [
      div([], [
        a([href("https://github.com/raphaelantoniocampos"), target("_blank")], [
          i([class("fab fa-github ")], []),
          text("Github"),
        ]),
        a(
          [
            href("https://www.linkedin.com/in/raphael-antonio-campos/"),
            target("_blank"),
          ],
          [i([class("fab fa-linkedin ")], []), text("Linkedin")],
        ),
      ]),
      p([], [text("© 2024 Raphael Campos. Todos os direitos reservados.")]),
    ]),
  ])
}
