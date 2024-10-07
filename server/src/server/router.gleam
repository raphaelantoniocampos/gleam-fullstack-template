import cors_builder as cors
import gleam/http.{Get, Post}
import lustre/element
import server/config.{type Context}
import server/scaffold.{page_scaffold}
import server/web
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) {
  use req <- cors.wisp_middleware(
    req,
    cors.new()
      |> cors.allow_origin(ctx.url)
      |> cors.allow_method(http.Get)
      |> cors.allow_method(http.Post)
      |> cors.allow_header("Content-Type")
      |> cors.max_age(86_400),
  )
  use req <- web.middleware(req, ctx)

  case wisp.path_segments(req) {
    ["api", ..] -> handle_api_request(req)
    _ -> page_routes()
  }
}

pub fn handle_get(req: Request) {
  case wisp.path_segments(req) {
    ["api", "users"] -> wisp.not_found()
    _ -> wisp.not_found()
  }
}

pub fn handle_post(req: Request) {
  use body <- wisp.require_json(req)
  case wisp.path_segments(req) {
    ["api", "users"] -> wisp.not_found()
    _ -> wisp.not_found()
  }
}

fn handle_api_request(req: Request) -> Response {
  case req.method {
    Get -> handle_get(req)
    Post -> handle_post(req)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

fn page_routes() -> Response {
  wisp.response(200)
  |> wisp.set_header("Content-Type", "text/html")
  |> wisp.html_body(
    page_scaffold()
    |> element.to_document_string_builder(),
  )
}
