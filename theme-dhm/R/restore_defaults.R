#' Reset graphic defaults
#'
#' Restore graphic defaults to the ggplot settings
#'
#' @return None
#'
#' @export
theme_reset <- function() {
    update_geom_defaults("col", list(fill = "grey35"))
    update_geom_defaults("bar", list(fill = "grey35"))
    update_geom_defaults("line", list(color = "black"))
    update_geom_defaults("point", list(color = "black"))
    update_geom_defaults("text", list(family = "", color = "black", size = 4))
}
