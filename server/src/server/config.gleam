import dot_env as dot
import dot_env/env
import gleam/result

pub type Context {
  Context(static_directory: String, url: String)
}

pub type Environment {
  Development
  Production
}

pub type Config {
  Config(secret_key_base: String, port: Int, env: Environment)
}

pub fn read_config() {
  dot.new()
  |> dot.set_path(".env")
  |> dot.load

  let assert Ok(secret_key_base) = env.get_string("SECRET_KEY_BASE")
  let env = case result.unwrap(env.get_string("GLEAM_ENV"), "") {
    "development" -> Development
    _ -> Production
  }
  let assert Ok(port) = env.get_int("PORT")
  Config(secret_key_base, port, env)
}

pub fn is_dev() {
  read_config().env == Development
}