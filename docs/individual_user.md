# Dawn workshop: software installation by an individual user

The following are instructions for setting up a conda environment for
running the examples of the Dawn workshop held at the [Accelerate Science Winter School for AI](https://github.com/acceleratescience/winter-school),
Cambridge, 14-16 January 2026:

1. Clone this repository, and move to the scripts directory:
   ```
   git clone https://github.com/kh296/260116-dawn-workshop
   cd 260116-dawn-workshop/scripts
   ```
2. Optionally perform your own installation of conda, for example following
   the instructions for [Miniforge](https://conda-forge.org/download/).
   You don't need to perform an installation if you have an existing
   conda installation, or if you're happy for the Miniforge3 flavour
   of conda to be installed automatically in the next step.

3. Perform installation either by submitting a Slurm job, or by running
   interactively on a compute node.  The installation script can take
   over an hour to complete.
   - Installation by submitting a Slurm job:
     ```
     # Substitute for <project_account> a valid project account.
     # Substitute for <partition> a valid partition.
     # Set CONDA_INSTALL to the path of an existing conda installation,
     #     or to the path of a directory that is to be created for
     #     conda installation. 
     sbatch --account=<project_account> --partition=<partition> --export=CONDA_INSTALL="~/miniforge3" ./install_for_user.sh
     ```
   - Installation by running interactively on a compute node.
     ```
     # Set CONDA_INSTALL to the path of an existing conda installation,
     #     or to the path of a directory that is to be created for
     #     conda installation. 
     CONDA_INSTALL="~/miniforge3" ./install_for_user.sh 1>install_for_user.log 2>&
     ```

4. Check the installation log file, `install_for_user.log`.

5. Once installation has completed successfully, the environment for
   using the workshop software can be set up with:
   ```
   source ../envs/diffusion-models-setup.sh
   ```
   
6. Continue with the workshop instructions, starting from: [6. Check setup](../README.md#6-check-setup).

The instructions above, and the workshop examples, have been tested on
[Dawn](https://docs.hpc.cam.ac.uk/hpc/user-guide/pvc.html#hardware)
(`xpu` devices), on the [AMD Accelerator Cloud](https://aac.amd.com/help/)
(`cuda` devices), and, ommitting
[Slurm](https://slurm.schedmd.com/overview.html) tasks, on MacBook
(`mps` devices).
