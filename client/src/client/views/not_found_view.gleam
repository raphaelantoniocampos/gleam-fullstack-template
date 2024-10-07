import lustre/attribute.{class}
import lustre/element.{type Element}
import lustre/element/html.{div, text}

pub fn not_found_view() -> Element(a) {
  div([], [text("404 Not Found")])
}
