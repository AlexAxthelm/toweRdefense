library(shiny)
library(bslib)
library(logger)

# Define UI for app that draws a histogram ----
ui <- page_sidebar(
  # App title ----
  title = "Hello Shiny!",
  # Sidebar panel for inputs ----
  sidebar = sidebar(
    # Input: Slider for the number of bins ----
    sliderInput(
      inputId = "radius",
      label = "radius",
      min = 0.01,
      max = 1.0,
      value = 0.2
    ),
    sliderInput(
      inputId = "velocity",
      label = "velocity",
      min = 0.01,
      max = 2.0,
      value = 0.3
    )
  ),
  # Output: Histogram ----
  tags[["style"]](
    # type = "text/css", "#output_id.recalculating { opacity: 1.0; }"
    type = "text/css", "#distPlot.recalculating { opacity: 1.0; }"
  ),
  plotOutput(outputId = "distPlot")
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {

  fps <- 10L
  auto_invalidate <- reactiveTimer(1000L / fps)

  points <- reactiveValues(
    position = data.frame(
      xpos = 0.5,
      ypos = 0.5,
      waypoint = "A",
      stringsAsFactors = FALSE
    )
  )

  waypoints <- list(
    A = data.frame(xpos = 0.5, ypos = 9.5),
    B = data.frame(xpos = 19.5, ypos = 9.5),
    C = data.frame(xpos = 19.5, ypos = 0.5),
    D = data.frame(xpos = 0.5, ypos = 0.5)
  )

  calculate_velocity <- function(waypoint, position, velocity) {
    dx <- waypoint[["xpos"]] - position[["xpos"]]
    log_trace("dx: {dx}")
    dy <- waypoint[["ypos"]] - position[["ypos"]]
    log_trace("dy: {dy}")
    distance <- sqrt(dx^2L + dy^2L)
    log_trace("distance: {distance}")
    return(
      data.frame(
        x = dx / distance * velocity,
        y = dy / distance * velocity
      )
    )
  }

  observe({
    # Invalidate and re-execute this reactive expression every time the
    # timer fires.
    auto_invalidate()

    log_trace("Calculating velocity")
    point_waypoint <- isolate(points[["position"]][["waypoint"]])
    component_velocity <- calculate_velocity(
      waypoints[[point_waypoint]],
      isolate(points[["position"]]),
      input[["velocity"]]
    )
    # component_velocity <- data.frame(
    #   x = input[["velocity"]] / fps,
    #   y = input[["velocity"]] / fps
    # )
    log_trace("component velocity calculated")

    points[["position"]] <- isolate(
      data.frame(
        xpos = points[["position"]][["xpos"]] + component_velocity[["x"]],
        ypos = points[["position"]][["ypos"]] + component_velocity[["y"]]
      )
    )
    log_trace("{(as.list(isolate(points[['position']])))}")
  })


  output[["distPlot"]] <- renderPlot({
    ggplot2::ggplot(
      data = points[["position"]],
      ggplot2::aes(
        x = .data[["xpos"]],
        y = .data[["ypos"]]
      )
    ) +
      ggplot2::geom_point(size = 5L) +
      ggplot2::xlim(0L, 20L) +
      ggplot2::ylim(0L, 10L) +
      # ggplot2::theme_void() +
      ggplot2::theme(plot.margin = grid::unit(c(0L, 0L, 0L, 0L), "cm"))
  })

}

shinyApp(ui = ui, server = server)
