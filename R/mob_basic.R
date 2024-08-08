mob_basic <- S7::new_class("mob_basic",
  parent = mob,
  constructor = function(position, level) {
    max_health <- 10L ^ (level / 10L)
    S7::new_object(
      mob(),
      position = position,
      speed = 1L / 30L,
      type = "basic",
      level = level,
      health = max_health,
      max_health = max_health,
      reward = max_health,
      waypoint = map_01@waypoints[[1]],
      waypoints = map_01@waypoints
    )
  }
)
