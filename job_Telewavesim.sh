#!/bin/bash

#SBATCH -J Telewavesim
#SBATCH -t 01:00:00
#SBATCH -p urseismo 
#SBATCH -n 1 
#SBATCH --mail-type=ALL
#SBATCH --mail-user="zzhang90@ur.rochester.edu"

##number of jobs
#SBATCH -a 1-896

module purge
module load anaconda3/2019.10
source /software/anaconda3/2019.10/etc/profile.d/conda.sh
conda activate urseismo

moduleID=$SLURM_ARRAY_TASK_ID
echo "running $moduleID on $(hostname).."

python ./run_telewavesim.py $1 $2 $3 $4 $5 $6 $SLURM_ARRAY_TASK_ID

