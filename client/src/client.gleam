// import client/api
// import client/model
// import client/msg
// import client/router
// import client/update
//
// import client/views/components/footer.{footer_view}
// import client/views/home_view.{home_view}
// import client/views/not_found_view.{not_found_view}
// import gleam/uri.{type Uri}
// import lustre
// import lustre/attribute.{id}
// import lustre/effect.{type Effect}
// import lustre/element.{type Element}
// import lustre/element/html.{body}
// import lustre_http
// import modem
//
// pub fn main() {
//   lustre.application(init, update, view)
//   |> lustre.start("#app", Nil)
// }
//
// pub fn init(_) -> #(model.Model, Effect(msg.Msg)) {
//   model.init()
//   |> update.effects([modem.init(on_url_change), api.get_user()])
// }
//
// fn on_url_change(_uri: Uri) -> msg.Msg {
//   msg.OnRouteChange(router.get_route())
// }
//
// fn update(model: model.Model, msg: msg.Msg) -> #(model.Model, Effect(msg.Msg)) {
//   case msg {
//     msg.OnRouteChange(route) -> model.update_route(model, route) |> update.none
//
//     msg.UserRecieved(user_result) ->
//       handle_api_response(
//         model,
//         user_result,
//         api.validate_default,
//         model.update_user,
//         [effect.none()],
//       )
//
//     msg.UserRequestedApiCall -> {
//       model
//       |> update.effect(api.call(model))
//     }
//
//     msg.ApiCallResponded(_resp_result) -> model |> update.none
//   }
// }
//
// pub fn view(model: model.Model) -> Element(msg.Msg) {
//   body([id("app")], [
//     case model.route {
//       router.Home -> home_view(model)
//       router.NotFound -> not_found_view()
//     },
//     footer_view(),
//   ])
// }
//
// fn handle_api_response(
//   model: model.Model,
//   response: Result(data, lustre_http.HttpError),
//   validate_data: fn(model.Model, data) ->
//     Result(
//       #(model_data, List(effect.Effect(msg.Msg))),
//       List(effect.Effect(msg.Msg)),
//     ),
//   apply_update: fn(model.Model, model_data) -> model.Model,
//   error_effects: List(Effect(msg.Msg)),
// ) -> #(model.Model, effect.Effect(msg.Msg)) {
//   case response {
//     Ok(api_data) -> {
//       case model |> validate_data(api_data) {
//         Ok(return) -> {
//           apply_update(model, return.0) |> update.effects(return.1)
//         }
//         Error(returned_effects) -> model |> update.effects(returned_effects)
//       }
//     }
//     Error(_) -> model |> update.effects(error_effects)
//   }
// }

import gleam/dynamic
import gleam/option.{Some}
import gleam/result
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import transition.{type State}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
}

type Model {
  Model(panel_state: transition.State)
}

pub opaque type Msg {
  UserClickedButton
  TransitionStarted
  TransitionEnded(String)
}

fn init(_flags) -> #(Model, Effect(Msg)) {
  #(Model(transition.Init), effect.none())
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    UserClickedButton -> #(
      Model(panel_state: transition.toggle(Some(model.panel_state))),
      transition.start(TransitionStarted),
    )
    TransitionStarted -> #(
      Model(panel_state: transition.next(Some(model.panel_state))),
      effect.none(),
    )
    TransitionEnded(_) -> #(
      Model(panel_state: transition.end(Some(model.panel_state))),
      effect.none(),
    )
  }
}

fn view(model: Model) -> Element(Msg) {
  html.div([attribute.class("p-4")], [
    html.button(
      [
        event.on_click(UserClickedButton),
        attribute.class(
          "rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focusivisible:outline-2 focus-visible:outline-indigo-600",
        ),
      ],
      [element.text("Click Me!")],
    ),
    panel(model.panel_state),
  ])
}

fn panel(state: State) {
  // "hidden" - we need to add this here so that tailwind doesn't strip out this class
  let classes =
    transition.Classes(
      enter: #(
        "transition ease-out duration-300",
        "opacity-0 scale-90",
        "opacity-100 scale-100",
      ),
      leave: #(
        "transition ease-in duration-300",
        "opacity-100 scale-100",
        "opacity-0 scale-90",
      ),
    )
    |> transition.apply(state)
  html.div(
    [
      attribute.class(classes),
      attribute.id("hello"),
      event.on("transitionend", handle_transition_end),
    ],
    [element.text("Hello World!")],
  )
}

fn handle_transition_end(event) -> Result(Msg, List(dynamic.DecodeError)) {
  use target <- result.try(dynamic.field("target", dynamic.dynamic)(event))
  use id <- result.try(dynamic.field("id", dynamic.string)(target))
  Ok(TransitionEnded(id))
}
