# A function that will write a data frame to CSV, and also produce a matching ".csvt" file specifying column types 
# This will enable the open-source GIS program QGIS to import the CSV with correct column types
# Use this just like you would write_csv; the only difference is it will also create a ".csvt" file
# Requires readr
# Written by David H. Montgomery, released under MIT License

require(readr)
write_csv_qgis <- function(x, path, ...) {
	readr::write_csv(x = x, path = path, ...)
	tmp <- map(x, class) %>% 
		unlist() %>% 
		as.data.frame() %>% 
		set_names("class") %>%
		mutate(class = as.character(class)) %>%
		left_join(data_frame("QGIS_type" = c("Integer", "Real", "String", "Date", "Time", "DateTime"), 
							 "R_type" = c("integer", "numeric", "character", "Date", "POSIXct", "POSIXct")),
				  by = c("class" = "R_type")) %>%
		pull(QGIS_type)
	paste(shQuote(tmp, type = "cmd"), collapse = ",") %>%
		writeLines(con = paste0(path, "t"))
}