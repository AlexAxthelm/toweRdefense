#' @include generics.R
map <- S7::new_class("map",
  properties = list(
    width = S7::class_integer,
    height = S7::class_integer,
    cells = S7::class_data.frame,
    waypoints = S7::class_list,
    base = S7::class_integer,
    plot = S7::new_property(
      getter = function(self) {
      }
    )
  ),
  constructor = function(
    cells,
    waypoints
  ) {
    width <- as.integer(max(cells[["x"]]))
    height <- as.integer(max(cells[["y"]]))
    logger::log_trace("Creating S7 map object.")
    S7::new_object(
      S7::S7_object(),
      width = width,
      height = height,
      cells = cells,
      waypoints = waypoints,
      base = waypoints[[length(waypoints)]]
    )
  }
)

S7::method(render, map) <- function(x) {
  log_trace("Creating map plot.")
  ggplot2::ggplot(
    data = x@cells,
    mapping = ggplot2::aes(
      x = .data[["x"]],
      y = .data[["y"]],
    )
    ) +
  ggplot2::geom_tile(mapping = ggplot2::aes(fill = .data[["type"]]))
}
