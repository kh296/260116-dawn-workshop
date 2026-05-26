#!/bin/bash -l
#SBATCH --job-name=install_for_user  # short name for job
#SBATCH --output=%x.log                  # job output file
#SBATCH --nodes=1                        # number of nodes
#SBATCH --gres=gpu:1                     # number of allocated gpus per node
#SBATCH --time=02:00:00                  # total run time limit (HH:MM:SS)

# Script to perform user installation of workshop software.
#
# This script may be run interactively on a compute node
# bash ./miniforge3_install.sh
# or it may be run on a Slurm batch system:
# sbatch --account=<account> --partition=<partition> ./miniforge3_install.sh

# Exit at first failure.
set -e

echo "Software installation on $(hostname) started: $(date)"
T0=${SECONDS}

# Ensure values set for locating or installing conda,
# and for  environment to be used.
if [ -z "${CONDA_DELETE}" ]; then
    export CONDA_DELETE="false"
fi
if [ -z "${CONDA_ENV}" ]; then
    export CONDA_ENV="Miniforge3"
fi
if [ -z "${CONDA_ENV_LC}" ]; then
    export CONDA_ENV_LC="$(echo ${CONDA_ENV} | tr [:upper:] [:lower:])"
fi
if [ -z "${CONDA_HOME}" ]; then
    CONDA_HOME="${HOME}/${CONDA_ENV_LC}"
fi
if [ -d ~/rds/hpc-work/ ]; then
    if [ -z "${CONDA_INSTALL}" ]; then
        export CONDA_INSTALL=~/rds/hpc-work/${CONDA_ENV_LC}
    fi
    if [ -z "${CONDA_LINK}" ]; then
        export CONDA_LINK=${CONDA_HOME}
    fi
else
    if [ -z "${CONDA_INSTALL}" ]; then
        export CONDA_INSTALL=${CONDA_HOME}
    fi
fi
export CONDA_HOME=${CONDA_INSTALL}
if [ -z "${ENV_NAME}" ]; then
    export ENV_NAME="diffusion-models"
fi

# Define directory containing installation scripts, and scripts to be run.
# See: https://tldp.org/LDP/abs/html/comparison-ops.html
WORKSHOP_HOME=$(cd $(dirname "$0")/..; pwd)
if [[ ${WORKSHOP_HOME} == /var/spool/* ]]; then
    WORKSHOP_HOME=$(dirname $(pwd))
fi
SCRIPTS_HOME=${WORKSHOP_HOME}/scripts
INSTALL_SCRIPTS="diffusion-models_install.sh user_setup.sh"
if [[ "true" == "${CONDA_DELETE}" ]]; then
    INSTALL_SCRIPTS="miniforge3_install.sh ${INSTALL_SCRIPTS}"
fi

# Delete any pre-existing kernels associated with conda environment.
JUPYTER_KERNELS_HOME="${HOME}/.local/share/jupyter/kernels"
rm -rf ${JUPYTER_KERNELS_HOME}/${ENV_NAME}

# Run installation scripts.
cd ${SCRIPTS_HOME}
for INSTALL_SCRIPT in ${INSTALL_SCRIPTS}; do
    echo ""
    echo ""./${INSTALL_SCRIPT}
    ./${INSTALL_SCRIPT}
done

echo ""
echo "Software installation on $(hostname) completed: $(date)"
echo "Installation time: $((${SECONDS}-${T0})) seconds"
