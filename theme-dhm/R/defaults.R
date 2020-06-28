#' Set graphic defaults
#'
#' Change the default font to Avenir Next, and the default graphical element color to green
#'
#' @family addlogo, theme_citylab theme_citylab_fb theme_citylab_map citylab_colors
#'
#' @import ggplot2
#'
#' @return None
#'
#' @export
.onLoad <- function(libname, pkgname) {
    update_geom_defaults("text", list(family = "Avenir Next"))
    update_geom_defaults("col", list(fill = "#3E6549"))
    update_geom_defaults("line", list(color = "#3E6549"))
    update_geom_defaults("point", list(color = "#3E6549"))
}

#' @export
.onUnload <- function(libname, pkgname) {
    update_geom_defaults("col", list(fill = "grey35"))
    update_geom_defaults("bar", list(fill = "grey35"))
    update_geom_defaults("line", list(color = "black"))
    update_geom_defaults("point", list(color = "black"))
    update_geom_defaults("text", list(family = "", color = "black", size = 4))
}
