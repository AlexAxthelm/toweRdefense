#' @include map.R
#' @include mob.R
#' @include map_01.R
game <- S7::new_class("game",
  properties = list(
    id = S7::new_property(
      S7::class_character,
      default = uuid::UUIDgenerate()
    ),
    map = S7::new_property(
      map,
      default = map_01
      ),
    mobs = S7::class_list,
    towers = S7::class_list,
    health = S7::class_integer,
    max_health = S7::class_integer,
    gold = S7::class_integer,
    level = S7::new_property(
      S7::class_integer,
      default = 1L
    )
  )
)

S7::method(update, game) <- function(x) {
  log_debug("Updating game: {x@id}.")
  log_trace("Updating mobs.")
  x@mobs <- lapply(x@mobs, update)
  invisible(x)
}

add_mob <- S7::new_generic("add_mob", "x")
S7::method(add_mob, game) <- function(x, mob) {
  log_debug("Adding mob to game: {x@id}.")
  new_mob <- mob(
    level = x@level,
    waypoints = x@map@waypoints
  )
  x@mobs <- append(x@mobs, new_mob)
  log_trace("Added mob {new_mob@id} to game.")
  invisible(x)
}

render <- S7::new_generic("render", "x")
S7::method(render, game) <- function(x) {
  log_debug("Rendering game: {x@id}.")
  x@map@plot
}
