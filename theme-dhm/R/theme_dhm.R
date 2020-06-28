#' David H. Montgomery's ggplot theme
#'
#' Applies David's graphical styles to a ggplot object.
#'
#' @family theme_reset defaults.R
#'
#' @import ggplot2
#' @import dplyr
#'
#' @param base_size Sets the base font size for the plot. Default is 12.
#' @param base_family Sets the base font for the plot. Default is Avenir Next.
#'
#' @return None
#'
#' @examples
#' \dontrun{
#' ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_dhm() + labs(title = "Title", caption = "Caption")}
#'
#' @export
theme_dhm <- function (base_size = 10, base_family = "Avenir Next") # Set a base size and font family
{
	half_line <- base_size # Define a unit of spacing for later use
	theme_minimal(base_size = base_size, base_family = base_family) %+replace% # Use theme_minimal() as our default
		theme(
			plot.title = element_text(
				family = "Avenir Next Bold", # Define the font family
				size = rel(7/3), # Define the size relative to the base size
				hjust = 0, # Define horizontal justification (left)
				vjust = 1, # Define vertical justification (bottom)
				margin = margin(b = half_line * 1.5)), # Add a bottom margin
			# Format subtitles
			plot.subtitle = element_text(
				family = "Avenir Next Demi Bold",
				size = rel(4/3),
				hjust = 0,
				vjust = 1,
				margin = margin(b = half_line * 0.9)),
			# Format captions
			plot.caption = element_text(
				family = "Avenir Next Medium Italic",
				hjust = 1,
				vjust = 1,
				margin = margin(t = half_line * 0.9)),
			# Format axis labels
			axis.text = element_text(
				family = "Avenir Next Medium",
				size = rel(11/9)
			),
			# Format axis titles
			axis.title = element_text(
				family = "Avenir Next Demi Bold",
				size = rel(4/3),
				hjust = .5,
				vjust = .5),
			legend.title = element_text(
				family = "Avenir Next Demi Bold",
				size = rel(4/3)),
			legend.text = element_text(
				family = "Avenir Next Medium",
				size = rel(4/3)),
			strip.text = element_text(
				family = "Avenir Next Demi Bold",
				size = rel(4/3),
				margin = margin(3, 0, 3, 0, "pt")),
			panel.border = element_rect(size = 1, fill = NA),
			plot.background = element_rect(fill = NA, size = 2),
			plot.margin = margin(c(10, 15, 10, 10)),
			legend.position = "top",
			complete = TRUE)
}
