#!/usr/bin/env bash
# slurm template for serial jobs

# Set SLURM options
#SBATCH --job-name=easel-index                  # Job name
#SBATCH --output=easel-index-%j.out             # Standard output and error log
#SBATCH --mail-user=mbrockley@middlebury.edu     # Where to send mail	
#SBATCH --mail-type=ALL                        # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mem=250gb                        # Job memory request
#SBATCH --partition=himem-long                    # Partition (queue) 
#SBATCH --time=48:00:00                         # Time limit hrs:min:sec

# print SLURM envirionment variables
echo "Job ID: ${SLURM_JOB_ID}"
echo "Node: ${SLURMD_NODENAME}"
echo "Starting: "`date +"%D %T"`

# Your calculations here


for metagenome in Amp_sq_frMetaG.index.proteins.faa Clalk_MetG.index.proteins.faa Kinlk_MetG.index.proteins.faa Kor_freMetG.index.proteins.faa LN_VirMetaG_4pW.index.proteins.faa Rim_Cz_frMetG1.index.proteins.faa Roblk_MetG.index.proteins.faa VirL_MetaG.index.proteins.faa WA102_MetaG.index.proteins.faa
do
	esl-sfetch --index /storage/eggleston-research/metagenomes/${metagenome}
done

# End of job info
echo "Ending:   "`date +"%D %T"`
