#/bin/bash
# Script for cloning repository with examples.

WORKSHOP_HOME=$(cd $(dirname "${BASH_SOURCE[0]}")/..; pwd)
if [[ ${WORKSHOP_HOME} == /var/spool/* ]]; then
    WORKSHOP_HOME=$(dirname $(pwd))
fi
DIFFUSION_MODELS_HOME=${WORKSHOP_HOME}/projects/diffusion-models
if [ ! -d ${DIFFUSION_MODELS_HOME} ]; then
  mkdir -p ${DIFFUSION_MODELS_HOME}
  git clone https://github.com/kh296/diffusion-models ${DIFFUSION_MODELS_HOME}
  git -C ${DIFFUSION_MODELS_HOME} checkout xpu
  cp -rp ${WORKSHOP_HOME}/envs ${DIFFUSION_MODELS_HOME}/envs
fi
