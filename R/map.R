map <- S7::new_class("map",
  properties = list(
    width = S7::class_integer,
    height = S7::class_integer,
    cells = S7::class_data.frame,
    waypoints = S7::class_list,
    plot = S7::new_property(
      getter = function(self) {
        log_debug("Creating map plot.")
        ggplot2::ggplot(
          data = self@cells,
          mapping = ggplot2::aes(
            x = .data[["x"]],
            y = .data[["y"]],
          )
        ) +
          ggplot2::geom_tile(mapping = ggplot2::aes(fill = .data[["type"]]))
      }
    )
  ),
  constructor = function(
    cells,
    emitter,
    target,
    waypoints
  ) {
    log_trace("Casting length and height to integer.")
    width <- as.integer(max(cells[["x"]]))
    height <- as.integer(max(cells[["y"]]))
    waypoints <- c(
      list(emitter),
      waypoints,
      list(target)
    )
    logger::log_trace("Creating S7 map object.")
    S7::new_object(
      S7::S7_object(),
      width = width,
      height = height,
      cells = cells,
      waypoints = waypoints
    )
  }
)
