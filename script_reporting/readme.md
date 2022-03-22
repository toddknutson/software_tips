# Script reporting


Todd Knutson  



## Introduction

The Slurm job scheduler is used by MSI systems to coordinate job submissions. These job scripts are simply shell scripts that include special header information, called slurm declaratives, that specify the resources needed for the job. In addition, we can include a couple `trap` (see `man bash` for details) commands that run certain commands if any errors occur during our script or when the script ends. 


## Example shell script header

Note a few things:

* This job is requesting 1 core, 4 threads, 32 GB of memory, for 1 hour, on the `amdsmall` partition (`mangi` cluster).
* This job will not inherit any bash variables present when the job was submitted (i.e. `#SBATCH --export=NONE`).
* This job will receive all email communication at the default address (submitter's email).
* A `THREADS` variable is created that holds the number of threads the slurm job requested (i.e. `SLURM_CPUS_PER_TASK`), or if it's not currently running a slurm job, `THREADS` is set to `1`. This allows for easy and uniform access (whether running a job or not) to the number of threads available for the script. 
* If an error occurs, a `trap` function will run, reporting the last bash command run and it's exit code.
* When the script ends (for any reason, error or success), a `trap` function will run, reporting the date/time, print the current env variables, and print slurm job details (if running a slurm job)


```
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --time=1:00:00
#SBATCH --mem=32gb
#SBATCH --tmp=16gb
#SBATCH --error=%x.e%j
#SBATCH --output=%x.o%j
#SBATCH --export=NONE
#SBATCH --mail-type=ALL
#SBATCH --partition=amdsmall


#######################################################################
# Script preliminaries
#######################################################################

# Exit script immediately upon error
set -e


function trap_my_error {
    >&2 echo "ERROR: \"${BASH_COMMAND}\" command failed with exit code $? [$(date)]"
}

function trap_my_exit {
    echo "[$(date)] Script exit."
    # Print env variables
    declare -p
    # Print slurm job details
    if [ ! -z ${SLURM_JOB_ID+x} ]; then
        scontrol show job "${SLURM_JOB_ID}"
        sstat -j "${SLURM_JOB_ID}" --format=JobID,MaxRSS,MaxVMSize,NTasks,MaxDiskWrite,MaxDiskRead
    fi
}
# Execute these functions after any error (i.e. nonzero exit code) or 
# when exiting the script (i.e. with zero or nonzero exit code).
trap trap_my_error ERR
trap trap_my_exit EXIT



# If not a slurm job, set THREADS to 1
export THREADS=$([ ! -z ${SLURM_CPUS_PER_TASK+x} ] && echo ${SLURM_CPUS_PER_TASK} || echo 1)

echo "[$(date)] Script start."

#######################################################################
# Script
#######################################################################




# write your specific tasks here...

```
