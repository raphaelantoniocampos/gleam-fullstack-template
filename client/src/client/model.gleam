import client/router

pub type Model {
  Model(route: router.Route)
}

pub fn init() -> Model {
  Model(route: router.get_route())
}

pub fn update_all(first: Model, _second: Model) -> Model {
  first
}

pub fn update_route(model: Model, route: router.Route) -> Model {
  Model(..model, route: route)
}
