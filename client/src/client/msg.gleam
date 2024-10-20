import client/router
import common.{type User}
import gleam/dynamic
import gleam/option.{type Option}
import lustre_http

pub type Msg {
  OnRouteChange(router.Route)
}

pub type MessageErrorResponse {
  MessageErrorResponse(message: Option(String), error: Option(String))
}

pub fn message_error_decoder() {
  dynamic.decode2(
    MessageErrorResponse,
    dynamic.optional_field("message", dynamic.string),
    dynamic.optional_field("error", dynamic.string),
  )
}
