#' @include mob.R
mob_basic <- S7::new_class("mob_basic",
  parent = mob,
  constructor = function(level, waypoints) {
    max_health <- 10L ^ (level / 10L)
    S7::new_object(
      mob(),
      position = waypoints[[1]],
      speed = 1L / 30L,
      type = "basic",
      level = level,
      health = max_health,
      max_health = max_health,
      reward = max_health,
      waypoint = waypoints[[1]],
      waypoints = waypoints
    )
  }
)
