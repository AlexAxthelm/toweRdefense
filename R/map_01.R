#' @include map.R
map_01 <- map(
  cells = data.frame(
    x = rep(1L:10L, 10L),
    y = rep(1L:10L, each = 10L),
    type = "open",
    stringsAsFactors = TRUE
  ) |>
    dplyr::mutate(
      type = dplyr::case_when(
        x == 10L & y == 7L ~ "base",
        y %in% c(3L, 5L, 7L) ~ "road",
        y == 4L & x == 10L ~ "road",
        y == 6L & x == 1L ~ "road",
        TRUE ~ "open"
      )
    ),
  waypoints = list(
    c(1L, 3L),
    c(10L, 3L),
    c(10L, 5L),
    c(1L, 5L),
    c(1L, 7L),
    c(10L, 7L)
  )
)
