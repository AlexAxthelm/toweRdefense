#' @include generics.R

mob <- S7::new_class("mob",
  properties = list(
    id = S7::new_property(
      S7::class_character,
      default = uuid::UUIDgenerate()
    ),
    position = S7::class_numeric,
    speed = S7::class_numeric,
    type = S7::class_character,
    level = S7::class_integer,
    health = S7::class_numeric,
    max_health = S7::class_numeric,
    reward = S7::class_numeric,
    waypoint = S7::class_numeric,
    waypoints = S7::class_list
  )
)

S7::method(update, mob) <- function(x) {
  log_debug("Updating mob: {x@id}.")
  if (all(x@position == x@waypoint)) {
    x@waypoint <- get_next_waypoint(x@position, x@waypoints)
    log_trace("Next waypoint: {x@waypoint}.")
  }
  x@position <- calculate_new_position(x@position, x@waypoint, x@speed)
  log_trace("Position: {x@position}.")
  invisible(x)
}

S7::method(render, mob) <- function(x) {
  log_trace("Rendering mob: {x@id}.")
  invisible(
    ggplot2::geom_point(
      data = data.frame(
        x = x@position[[1L]],
        y = x@position[[2L]],
        shape = x@type
      ),
      mapping = ggplot2::aes(x = x, y = y, shape = shape),
      inherit.aes = FALSE
    )
  )
}

calculate_new_position <- function(position, destination, speed) {
  distance <- sqrt(sum((destination - position) ^ 2L))
  if (distance < speed) {
    return(destination)
  }
  direction <- (destination - position) / distance
  return(position + (direction * speed))
}

get_next_waypoint <- function(position, waypoints) {
  log_trace("Reached waypoint at {position}.")
  wp_idx <- which(
    vapply(
      X = waypoints,
      FUN = function(wp) {
        all(position == wp)
      },
      FUN.VALUE = logical(1)
    )
  )
  return(waypoints[[wp_idx + 1L]])
}
