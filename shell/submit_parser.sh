#!/usr/bin/env bash
# slurm template for serial jobs

# Set SLURM options
#SBATCH --job-name=HMMER_parser                  # Job name
#SBATCH --output=HMMER_parser-%j.out             # Standard output and error log
#SBATCH --mail-user=mbrockley@middlebury.edu     # Where to send mail	
#SBATCH --mail-type=ALL                        # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mem=200gb                        # Job memory request
#SBATCH --partition=himem-standard                    # Partition (queue) 
#SBATCH --time=12:00:00                         # Time limit hrs:min:sec

# print SLURM envirionment variables
echo "Job ID: ${SLURM_JOB_ID}"
echo "Node: ${SLURMD_NODENAME}"
echo "Starting: "`date +"%D %T"`

# Your calculations here
python3 ../scripts/index_metagenome.py

# End of job info
echo "Ending:   "`date +"%D %T"`
