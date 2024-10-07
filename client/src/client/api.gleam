import client/model
import client/msg
import common.{User}
import env.{get_api_url}
import gleam/dynamic
import gleam/json
import lustre/effect
import lustre_http

pub fn validate_default(
  _model: model.Model,
  api_data: data,
) -> Result(#(data, List(a)), error) {
  #(api_data, [])
  |> Ok
}

pub fn validate_api_call(
  model: model.Model,
  data: msg.MessageErrorResponse,
) -> Result(
  #(model.Model, List(effect.Effect(msg.Msg))),
  List(effect.Effect(msg.Msg)),
) {
  todo
}

pub fn get_user() -> effect.Effect(msg.Msg) {
  let url = get_api_url() <> "/api/user"

  let decoder = dynamic.decode1(User, dynamic.field("id", dynamic.int))

  lustre_http.get(url, lustre_http.expect_json(decoder, msg.UserRecieved))
}

pub fn call(model: model.Model) -> effect.Effect(msg.Msg) {
  lustre_http.post(
    get_api_url() <> "/api/call",
    json.object([#("id", json.int(model.user.id))]),
    lustre_http.expect_json(msg.message_error_decoder(), msg.ApiCallResponded),
  )
}
