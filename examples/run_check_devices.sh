#!/bin/bash
#SBATCH --job-name=check_devices
#SBATCH --output=%x_%j.log
#SBATCH --partition=pvc9
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --time=00:10:00

# Script for checking devices seen by torch.
#
# It's assumed that the environment for using torch
# can be set up with:
# source ../envs/diffusion-models-setup.sh
#
# This script can be run interactively:
#     ./run_check_devices.sh
# or can be submitted to a Slurm batch system, substituting
# valid project account for <project_account>:
#     sbatch --acount=<project_account> check_devices.sh
T1=${SECONDS}
echo "Job start on $(hostname): $(date)"

# Exit at first failure.
set -e

# Perform environment setup.
WORKSHOP_HOME=$(cd $(dirname "${BASH_SOURCE[0]}")/..; pwd)
if [[ ${WORKSHOP_HOME} == "/var/spool/"* ]]; then
    WORKSHOP_HOME=$(dirname $(pwd))
fi
if [[ -z "${SLURM_NNODES}" ]]; then
    SLURM_NNODES=1
fi

if [ -z "${ENV_NAME}" ]; then
    export ENV_NAME="diffusion-models"
fi
source ${WORKSHOP_HOME}/envs/${ENV_NAME}-setup.sh;
if [[ -n "${SLURM_GPUS_ON_NODE}" ]] && [[ "${SLURM_GPUS_ON_NODE}" =~ ^[0-9]+$ ]] && [[ "${SLURM_GPUS_ON_NODE}" -gt 0 ]]; then
    GRES_OPT="--gres=gpu:${SLURM_GPUS_ON_NODE} "
else
    GRES_OPT=""
fi
PYTHON_LAUNCH="python ${WORKSHOP_HOME}/examples/check_devices.py"
SRUN_LAUNCH="srun --nodes=${SLURM_NNODES} --ntasks-per-node=1 ${GRES_OPT}"
if [[ ${SLURM_NNODES} -gt 1 ]]; then
    LAUNCH="${SRUN_LAUNCH} ${PYTHON_LAUNCH}"
else
    LAUNCH="${PYTHON_LAUNCH}"
fi
echo "${LAUNCH}"
${LAUNCH}

echo ""
echo "Torch device check completed: $(date)"
echo "Job time: $((${SECONDS}-${T1})) seconds"
