mob <- S7::new_class("mob",
  properties = list(
    id = S7::class_character,
    position = S7::class_numeric,
    speed = S7::class_numeric,
    type = S7::class_character,
    level = S7::class_integer,
    health = S7::class_numeric,
    max_health = S7::class_numeric,
    reward = S7::class_numeric,
    waypoint = S7::class_numeric,
    plot = S7::new_property(
      getter = function(self) {
        log_debug("Creating map plot.")
        ggplot2::geom_point(
          data = data.frame(
            x = self@position[[1]],
            y = self@position[[2]],
            shape = self@type
            ),
          mapping = ggplot2::aes(x = x, y = y, shape = shape),
          inherit.aes = FALSE
        )
      }
    )
  )
)
