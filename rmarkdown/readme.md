# How to use R Markdown on MSI systems

Todd Knutson  



## Introduction

You will need to create three files: (1) `report.slurm`, (2) `report.R`, and (3) `report.Rmd` located in a project directory (e.g. `/my/working/dir`).


## (1) Create a SLURM job file: `report.slurm`

This file sets up an environment for running R and other software required for generating various R Markdown outputs (HTML, PDF, Word, etc.). Then it simply runs the `report.R` file using the `Rscript` command.


	#!/bin/bash
	#SBATCH --nodes=1
	#SBATCH --ntasks-per-node=1
	#SBATCH --cpus-per-task=1
	#SBATCH --time=0:30:00
	#SBATCH --mem=12gb
	#SBATCH --error=%x.e%j 
	#SBATCH --output=%x.o%j
	#SBATCH --partition=amdsmall

    echo "["$(date)"] Script start."

    PROJ_DIR=/home/lmnp/knut0297/software/tips/rmarkdown
    cd $PROJ_DIR


    # Load software (some modules were built by Todd)
    module load R/3.6.1_mkl
    module load texinfo/6.5  
    module load texlive/20131202
    module load /home/lmnp/knut0297/software/modulesfiles/magick/7.0.8-23
    module load /home/lmnp/knut0297/software/modulesfiles/tree/1.7.0
    module load /home/lmnp/knut0297/software/modulesfiles/pandoc/2.9.1.1


    Rscript --vanilla ${PROJ_DIR}/report.R



## (2) Create an R script that will render the R markdown file: `report.R`

This file will use the `rmarkdown` R package to generate (knit) the `.Rmd` file into Markdown and other outputs using `pandoc` in the background.


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

    
    
    





## (3) Create an R markdown file that contains your analysis: `report.Rmd`

This is your data analysis file, written in R Markdown. 


	---
	title: "Project Title"
	output:
		html_document:
			keep_md: no
			highlight: default
			smart: false
			theme: cerulean #cerulean flatly
			toc: true
			toc_depth: 3
			toc_float: 
				collapsed: true
			number_sections: true
			df_print: paged
		pdf_document:
			toc: true

	---

	```{r setup, include = FALSE}
	knitr::opts_chunk$set(echo = TRUE)
	library(base)
	```





	Project Started: 2020-05-06  
	Project Last Updated: `r format(Sys.time(), '%Y-%m-%d, %T')`



	# Introduction  

	My goal is to create a plot.


	# My Analysis

	Create a plot!  


	## My plot

	Create data:

	```{r}
	x <- 1:100
	y <- x^2
	```

	Make a plot:

	```{r}
	plot(x, y)
	```
    
    
    
    
## Launch the SLURM job

Finally, to create the output files (see examples), run the SLURM job.

```
sbatch report.slurm

# Or run it on the command line:
# bash report.slurm
```

