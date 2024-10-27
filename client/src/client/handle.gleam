import client/model.{type Model}
import client/msg.{type Msg}
import client/update
import gleam/option.{None, Some}
import lustre/effect.{type Effect}
import lustre_http

pub fn default(_model: Model, api_data: data) -> Result(#(data, List(a)), error) {
  #(api_data, [])
  |> Ok
}

pub fn api_response(
  model: Model,
  response: Result(data, lustre_http.HttpError),
  handle_data: fn(Model, data) ->
    Result(#(model_data, List(effect.Effect(Msg))), List(effect.Effect(Msg))),
  apply_update: fn(Model, model_data) -> Model,
  error_effects: List(Effect(Msg)),
) -> #(Model, effect.Effect(Msg)) {
  case response {
    Ok(api_data) -> {
      case model |> handle_data(api_data) {
        Ok(return) -> {
          model |> apply_update(return.0) |> update.effects(return.1)
        }
        Error(returned_effects) -> model |> update.effects(returned_effects)
      }
    }
    Error(_) -> model |> update.effects(error_effects)
  }
}

pub fn api_call(
  model: Model,
  data: msg.MessageErrorResponse,
) -> Result(#(Model, List(effect.Effect(Msg))), List(effect.Effect(Msg))) {
  case data {
    msg.MessageErrorResponse(Some(_response), None) -> {
      let updated_model = model.init()
      let effects = [effect.none()]
      Ok(#(updated_model, effects))
    }

    msg.MessageErrorResponse(_, Some(error)) -> {
      let effects = [effect.none()]
      Error(effects)
    }

    msg.MessageErrorResponse(None, None) -> {
      let effects = [effect.none()]
      Error(effects)
    }
  }
}
