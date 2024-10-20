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
