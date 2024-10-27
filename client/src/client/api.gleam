import client/model
import client/msg.{type Msg}
import env.{get_api_url}
import gleam/dynamic
import gleam/json
import lustre/effect
import lustre_http

pub fn api_call(model: model.Model) -> effect.Effect(Msg) {
  lustre_http.post(
    get_api_url() <> "/api/call",
    json.object([#("api", json.string("string")), #("call", json.int(0))]),
    lustre_http.expect_json(msg.message_error_decoder(), msg.ApiCallResponded),
  )
}
