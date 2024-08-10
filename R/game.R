#' @include generics.R
#' @include map.R
#' @include map_01.R
#' @include mob.R
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
    health = S7::new_property(
      S7::class_integer,
      default = 30L
    ),
    max_health = S7::new_property(
      S7::class_integer,
      default = 30L
    ),
    coins = S7::new_property(
      S7::class_integer,
      default = 60L
    ),
    level = S7::new_property(
      S7::class_integer,
      default = 1L
    ),
    tick = S7::new_property(
      S7::class_integer,
      default = 1L
    )
  )
)

S7::method(update, game) <- function(x) {
  log_debug("Updating game: {x@id}.")
  x@tick <- x@tick + 1L
  log_trace("tick: {x@tick}.")
  log_trace("Updating mobs.")
  x@mobs <- lapply(x@mobs, update)
  for (mob in x@mobs) {
    if (all(mob@position == x@map@base)) {
      log_info("Mob {mob@id} reached base.")
      x@health <- x@health - mob@damage
      log_debug("Health: {x@health} (-{mob@damage}).")
      x@mobs[[mob@id]] <- NULL
    } else if (mob@health <= 0L) {
      log_info("Mob {mob@id} died.")
      x@coins <- x@coins + mob@reward
      log_debug("Coins: {x@coins} (+{mob@reward}).")
      x@mobs[[mob@id]] <- NULL
    }
  }

  invisible(x)
}

add_mob <- S7::new_generic("add_mob", "x")
S7::method(add_mob, game) <- function(x, mob) {
  log_debug("Adding mob to game: {x@id}.")
  new_mob <- mob(
    level = x@level,
    waypoints = x@map@waypoints
  )
  x@mobs[[new_mob@id]] <- new_mob
  log_trace("Added mob {new_mob@id} to game.")
  invisible(x)
}

S7::method(render, game) <- function(x) {
  log_debug("Rendering game: {x@id}.")
  map_layer <- render(x@map)
  mob_layer <- lapply(x@mobs, render)
  plot <- map_layer +
    mob_layer +
    ggplot2::labs(
      caption = paste(
        "Health: ", x@health,
        "Coins: ", x@coins,
        "Level: ", x@level,
        "Tick: ", x@tick
      )
    )
    if (x@health <= 0L) {
      plot <- plot +
        ggplot2::geom_label(
          data = data.frame(
            x = x@map@width / 2L,
            y = x@map@height / 2L
          ),
          mapping = ggplot2::aes(
            x = .data[["x"]],
            y = .data[["y"]],
            label = "Game Over!"
          ),
          inherit.aes = FALSE
        )
    }
    return(plot)
}
