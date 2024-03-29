#!/bin/bash

#SBATCH --job-name=LTT_NC
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=80GB
#SBATCH --time=48:00:00
#SBATCH --gres=gpu
#SBATCH --partition=a100_1,a100_2,v100,rtx8000

# job info
EPSILON=$1
AUG=$2
ALPHA=$3


# MIXUP=$3
# CUTOUTHOLES=$4
# CUTOUTLENGTH=$5


# Singularity path
ext3_path=/scratch/$USER/overlay-25GB-500K.ext3
sif_path=/scratch/$USER/cuda11.4.2-cudnn8.2.4-devel-ubuntu20.04.3.sif
# start running
singularity exec --nv \
--overlay ${ext3_path}:ro \
${sif_path} /bin/bash -c "
source /ext3/env.sh
cd /scratch/hy2611/GLMC-LYGeng/
python main_wb.py --dataset cifar100 -a resnet32 --imbanlance_rate 1 --lr 0.01 --epochs 200 --loss ls --eps ${EPSILON} --resample_weighting 0 --mixup 0 --mixup_alpha ${ALPHA} --cutoutholes 1 --cutoutlength 16 --aug ${AUG} --store_name ls${EPSILON}_aug${AUG}_alpha${ALPHA}
"