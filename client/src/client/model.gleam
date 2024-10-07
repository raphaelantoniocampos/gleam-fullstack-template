import client/router
import common.{type User, User}

pub type Model {
  Model(route: router.Route, user: User)
}

pub fn init() -> Model {
  Model(route: router.get_route(), user: User(0))
}

pub fn update_all(first: Model, _second: Model) -> Model {
  first
}

pub fn update_route(model: Model, route: router.Route) -> Model {
  Model(..model, route: route)
}

pub fn update_user(model: Model, user: User) -> Model {
  Model(..model, user: user)
}
