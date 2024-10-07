import client/model
import client/msg
import lustre/element.{type Element, text}
import lustre/element/html.{h1, main}

pub fn home_view(model: model.Model) -> Element(msg.Msg) {
  main([], [h1([], [text("Home Page")])])
}
