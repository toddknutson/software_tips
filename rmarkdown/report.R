#!/usr/bin/env Rscript

library(rmarkdown)


# You may need some other R packages loaded, depending on what types 
# of functions you use in your .Rmd file. Below are some examples.
# library(tidyverse)
# library(knitr)
# library(kableExtra)
# library(DT)



proj_dir <- "/home/lmnp/knut0297/software/tips/rmarkdown"
report_name <- "output_project"


# ---------------------------------------------------------------------
# Generate report
# ---------------------------------------------------------------------

# File paths
my_input_rmd <- paste0(proj_dir, "/", "report.Rmd")
my_output_html <- paste0(proj_dir, "/", report_name, ".html")
my_output_pdf <- paste0(proj_dir, "/", report_name, ".pdf")

# Create HTML file
rmarkdown::render(my_input_rmd, output_file = my_output_html, output_format = "html_document")

# Create PDF file 
# (only if you included a pdf_document section in your Rmd header)
rmarkdown::render(my_input_rmd, output_file = my_output_pdf, output_format = "pdf_document")
