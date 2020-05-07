# How to use R Markdown on MSI systems

Todd Knutson  
2020-05-05  



## Introduction

You will need to create three files: (1) `report.pbs`, (2) `report.R`, and (3) `report.Rmd` located in a project directory (e.g. `/my/working/dir`).


## (1) Create a PBS job file: `report.pbs`

This file sets up an environment for running R and other software required for generating various R Markdown outputs (HTML, PDF, Word, etc.). Then it simply runs the `report.R` file using the `Rscript` command.



	#!/bin/bash
	#PBS -l nodes=1:ppn=1,mem=12GB,walltime=0:30:00
	#PBS -m a
	#PBS -M $USER@umn.edu
	#PBS -A $MYGROUP 
	#PBS -W group_list=$MYGROUP
	#PBS -q amdsmall
	
	echo "["$(date)"] Script start."
	
	PROJ_DIR=/my/working/dir
	cd $PROJ_DIR
	
	
	# Load software (some modules were built by Todd)
	module load R/3.6.3  
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
    
    
    
    proj_dir <- "/my/working/dir"
    report_name <- paste0("report_", "project_title")
    
    
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
                toc: true
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
    
    
    
    
    
## Launch the PBS job

Finally, to create the output files (see examples), run the PBS job.

```
qsub report.pbs

# Or run it on the command line:
# bash report.pbs
```

