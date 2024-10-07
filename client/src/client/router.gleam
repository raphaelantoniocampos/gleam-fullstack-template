import gleam/uri

pub type Route {
  Home
  NotFound
}

@external(javascript, "../ffi.mjs", "get_route")
fn do_get_route() -> String

pub fn get_route() -> Route {
  let uri = case do_get_route() |> uri.parse {
    Ok(uri) -> uri
    _ -> panic as "Invalid uri"
  }

  case uri.path |> uri.path_segments {
    [] -> Home
    _ -> NotFound
  }
}
