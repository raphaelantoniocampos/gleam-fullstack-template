import client/api
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
import lustre_http
import modem

pub fn main() {
  lustre.application(init, update, view)
  |> lustre.start("#app", Nil)
}

pub fn init(_) -> #(model.Model, Effect(msg.Msg)) {
  model.init()
  |> update.effects([modem.init(on_url_change), api.get_user()])
}

fn on_url_change(_uri: Uri) -> msg.Msg {
  msg.OnRouteChange(router.get_route())
}

fn update(model: model.Model, msg: msg.Msg) -> #(model.Model, Effect(msg.Msg)) {
  case msg {
    msg.OnRouteChange(route) -> model.update_route(model, route) |> update.none

    msg.UserRecieved(user_result) ->
      handle_api_response(
        model,
        user_result,
        api.validate_default,
        model.update_user,
        [effect.none()],
      )

    msg.UserRequestedApiCall -> {
      model
      |> update.effect(api.call(model))
    }

    msg.ApiCallResponded(_resp_result) -> model |> update.none
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

fn handle_api_response(
  model: model.Model,
  response: Result(data, lustre_http.HttpError),
  validate_data: fn(model.Model, data) ->
    Result(
      #(model_data, List(effect.Effect(msg.Msg))),
      List(effect.Effect(msg.Msg)),
    ),
  apply_update: fn(model.Model, model_data) -> model.Model,
  error_effects: List(Effect(msg.Msg)),
) -> #(model.Model, effect.Effect(msg.Msg)) {
  case response {
    Ok(api_data) -> {
      case model |> validate_data(api_data) {
        Ok(return) -> {
          apply_update(model, return.0) |> update.effects(return.1)
        }
        Error(returned_effects) -> model |> update.effects(returned_effects)
      }
    }
    Error(_) -> model |> update.effects(error_effects)
  }
}
