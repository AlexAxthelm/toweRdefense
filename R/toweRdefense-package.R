#' @keywords internal
"_PACKAGE"

.onLoad <- function(lib, pkg) {
  S7::methods_register()
}

# Supress lintr warnings about functions re-exported from logger
utils::globalVariables(
  c(
    "log_debug",
    "log_error",
    "log_info",
    "log_trace",
    "log_warn"
  )
)
# enable usage of <S7_object>@name in package code
#' @rawNamespace if (getRversion() < "4.3.0") importFrom("S7", "@")
NULL

## usethis namespace: start
#' @importFrom logger log_debug
#' @importFrom logger log_fatal
#' @importFrom logger log_info
#' @importFrom logger log_trace
#' @importFrom logger log_warn
## usethis namespace: end
NULL
