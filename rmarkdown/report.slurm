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
