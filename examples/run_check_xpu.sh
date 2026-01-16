#/bin/bash
# Script for checking xpu devices (Intel GPUs) seen by torch.
WORKSHOP_HOME=$(cd $(dirname "${BASH_SOURCE[0]}")/..; pwd)
source ${WORKSHOP_HOME}/envs/diffusion-models-setup.sh

python ${WORKSHOP_HOME}/examples/check_xpu.py
