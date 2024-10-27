import client/handle
import client/model
import client/msg
import client/router
import client/update

import client/views/components/footer.{footer_view}
import client/views/home_view.{home_view}
import client/views/not_found_view.{not_found_view}
import gleam/uri.{type Uri}
import lustre
import lustre/attribute.{id}
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html.{body}
import modem

pub fn main() {
  lustre.application(init, update, view)
  |> lustre.start("#app", Nil)
}

pub fn init(_) -> #(model.Model, Effect(msg.Msg)) {
  model.init()
  |> update.effects([modem.init(on_url_change)])
}

fn on_url_change(_uri: Uri) -> msg.Msg {
  msg.OnRouteChange(router.get_route())
}

fn update(model: model.Model, msg: msg.Msg) -> #(model.Model, Effect(msg.Msg)) {
  case msg {
    msg.OnRouteChange(route) -> model.update_route(model, route) |> update.none
    msg.ApiCallResponded(resp_result) ->
      handle.api_response(
        model,
        resp_result,
        handle.api_call,
        model.update_all,
        [effect.none()],
      )
  }
}

pub fn view(model: model.Model) -> Element(msg.Msg) {
  body([id("app")], [
    case model.route {
      router.Home -> home_view(model)
      router.NotFound -> not_found_view()
    },
    footer_view(),
  ])
}
