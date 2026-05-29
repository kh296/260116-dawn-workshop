# Dawn workshop: running examples on the AMD Accelerator Cluster

## 1. Introduction
The PyTorch examples of the Dawn Workshop held at
the [Accelerate Science Winter School for AI](https://github.com/acceleratescience/winter-school), Cambridge, 14-16 January 2026, can be run on the
[AMD Accelerator Cluster](https://aac.amd.com/help/).  Information for
doing this, including installating the software needed in a `conda`
environment is given below.  Instructions are aimed at a user who has
an account on AAC6, and who has ssh keys set up for enabling
authentication. For more information about AAC login, see:
[AAC login info](https://github.com/amd/HPCTrainingExamples/tree/main/login_info/AAC).

## 2. Installation

1. From a terminal window on your local machine, connect to an AAC6 login node:
   ```
   # Substitute for <path_to_ssh_private_key> the path to your ssh private key.
   ssh aac6.amd.com -i <path_to_ssh_private_key>
   ```
2. Clone this repository, and move to the `scripts` subdirectory.
   ```
   cd ~
   git clone https://github.com/kh296/260116-dawn-workshop
   cd ~/260116-dawn-workshop/scripts
   ```
4. Submit a Slurm job to perform software installation, making use
   of default account and partition:
   ```
   # Set CONDA_INSTALL to the path to an existing conda instllation,
   #     or to the path of a directory that doesn't exist.
   #     In the latter case, the directory will be created, and
   #     the Miniforge3 flavour of conda will be installed there.
   sbatch --gres:gpu:1 --cpus-per-gpu=1 --export=CONDA_INSTALL="~/miniforge3 ./install_for_user.sh
   ```
   Installation can take over an hour, with progress written to the
   file `./install_for_user.log`.  For more information about the installation,
   see: [install_for_user.md](./install_for_user.md).

### 3 Environment set up
1. On an AAC login node, move to the top-level directory of the cloned
   version of this repository:
   ```
   cd ~/260116-dawn-workshop
   ```
2. Obtain interactive access to a compute node:
   ```
   # The request here is for 2 GPUs for 2 hours,
   #     using the default account and partition.
   # Optionally modify the request to have a different allocation.
   salloc --gres=gpu:2 --cpus-per-gpu=4 --time=02:00:00
   ```
3. On the allocated compute name, perform the environment setup:
   ```
   source envs/diffusion-models-setup.sh
   ```
4. Start a `jupyter` server in the background:
   ```
   jupyter lab --no-browser --port=8080 1>jupyter.log 2>&1 &
   ```
5. Check the `jupyter` log file until the connection URLs are shown:
   ```
   # Repeat as needed.
   cat jupyter.log
   ```
   The information about connection URLs will be similar to:
   ```
    To access the server, open this file in a browser:
        file:///<file_path>
    Or copy and paste one of these URLs:
        http://localhost:8080/lab?token=3e13ae92571f0fdfb66f877ead7a8136ae3b58291f8cc6ba
        http://127.0.0.1:8080/lab?token=3e13ae92571f0fdfb66f877ead7a8136ae3b58291f8cc6ba
   ```
6. Open a new terminal window on your local machine.  In this window, open an
   ssh tunnel to the AAC6 compute node:
   ```
   # Substitute for <path_to_ssh_private_key> the path to your ssh private key.
   # Substitute for <aac6_compute_node> the name of the compute node
   #     from which the jupyter server was started (step 4).  The name
   #     can be checked on the compute node, using the command: hostname.
   ssh aac6.amd.com -i <path_to_ssh_private_key>  -f -L 8080:localhost:8080 ssh <aac6_compute_node> -N -L 8080:localhost:8080
   ```
7. From the ternminal window opened in step 6, optionally check that
   the ssh tunnel is open:
   ```
   lsof -iTCP -sTCP:LISTEN -P -n  
   ```
   The items listed should include TCP nodes listening on port 8080.
8. On your local machine, open a web browser, and enter
   the URL from step 5 starting `http:localhost`, including all
   token characters.  This should open a `jupyter lab` session, where the
   top-level directory is the directory from which the `jupyter` server was
   started on the compute node (step 4).

## 4. Running workshop examples

1. You should be able to run the workshop examples, starting from
   [exercise 6](../README.md#6-check-setup).
2. Terminal commands can be entered either in the window from which
   the `jupyter` server was started (step 4 of section 3), of in
   a terminal started inside the `jupyter lab` session:
   ```
   File -> New -> Terminal
   ```
3. In [exercise 7](../README.md#7-submit-batch-job), the batch job submitted
   has Slurm directives that request a Dawn partition.  To submit on AAC6, use:
   ```
   sbatch --partition=1CN192C4G1H_MI300A_Ubuntu22 --exclusive run_5_diffusion_part2.sh
   ```
4. Some parts of the examples are designed to highlight features of Dawn's
   Intel GPUs.  The examples run on other types of GPU, but without
   demonstrating these features.  For example, the two modes of device
   visibility considered in the notebook of
   [exercise 9](../README.md#9-run-jupyter-notebook-to-check-available-devices),
   aren't relvant to AMD GPUs.
