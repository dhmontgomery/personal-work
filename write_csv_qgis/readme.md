# write_csv_qgis()

An R function that will write a data frame to CSV, and also produce a matching ".csvt" file specifying column types. This will enable the open-source GIS program QGIS to import the CSV with correct column types.

Use this just like you would write_csv; the only difference is it will also create a ".csvt" file. Requires readr.

Load the script into R by running the following:

`source("https://raw.githubusercontent.com/dhmontgomery/personal-work/master/write_csv_qgis/write_csv_qgis.R")`

Written by David H. Montgomery, released under MIT License.
