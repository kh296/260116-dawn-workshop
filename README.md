# Dawn Workshop

## 1. Introduction
This material was developed for the Dawn Workshop held at
the [Accelerate Science Winter School for AI](https://github.com/acceleratescience/winter-school), Cambridge, 14-16 January 2026.  It is licensed under the
[Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0).

## 2. Dawn

[Dawn](https://docs.hpc.cam.ac.uk/hpc/user-guide/pvc.html#hardware)
is a supercomputer hosted at the University of Cambridge, and is part
of the [AI Resource Research (AIRR)](https://www.gov.uk/government/publications/ai-research-resource/airr-advanced-supercomputers-for-the-uk).  It has
256 nodes, in the form of [Dell PowerEdge XE9640](https://www.delltechnologies.com/asset/en-us/products/servers/technical-support/poweredge-xe9640-spec-sheet.pdf) servers.  Each node consists of:
2 CPUs ([Intel Xeon Platinum 8468](https://www.intel.com/content/www/us/en/products/sku/231735/intel-xeon-platinum-8468-processor-105m-cache-2-10-ghz/specifications.html)), each with 48 cores and 512 GiB RAM;
4GPUs ([Intel Data Centre GPU Max 1550](https://www.intel.com/content/www/us/en/products/sku/232873/intel-data-center-gpu-max-1550/specifications.html)),
each with two stacks, 1024 compute units, and 128 GiB RAM.

To install and run software from this workshop on Dawn, you
will need to have an account set up.  For further information, see:
[Access to Dawn](https://www.csd3.cam.ac.uk/index.php/access-dawn).

## 3. Software installation

If you're been allocated a training account for this workshop, you
don't need to perform any software installation.  Otherwise, follow
the linked instructions:
- [software installation by an individual user](docs/individual_user.md).

## 4. Open Jupyter notebook on Dawn

Login at:
[https://login-web.hpc.cam.ac.uk/](https://login-web.hpc.cam.ac.uk/).  If
asked to enable multi-factor authentication, follow the instructions for
doing this.

At the top of the dashboard page presented after login, select:
```
Interactive Apps -> Jupyter Notebook
```

On the Jupyter Notebook form, enter as project account `training-dawn-gpu`
if you're using a training account, or otherwise the project name of
your Dawn allocation.  Enter other values as follows:
```
- Partition: pvc9
- Reservation: [leave blank]:
- Number of hours: 4
- Number of cores: 1
- Number of GPUs: 2
- Modules: rhel9/default-dawn jupyterlab/4.3.6
- Number of nodes: 1
```
The above request the resources needed for this workshop, for a period of
4 hours.  The number of hours  and number of GPUs (1 to 4) may be decreased
or increased as needed.

Click the __Launch__ button.

Your request for a Jupyter Notebook will progress through the states:
__Queued__, __Starting__, __Running__.  Once the __Running__ state is reached,
click the __Connect to Jupyter__ button.

Once connected to the Jupyter server, you will initially be shown the
__File Browser__, in the Jupyter Home tab.

It's possible to continue with the [Jupyter Notebook](https://jupyter-notebook.readthedocs.io/en/latest/) view, but it's suggested to move to the
[JupyterLab](https://jupyterlab.readthedocs.io/en/latest/) view.

Open a Terminal session in the JupyterLab view by selecting:
```
View -> JupyterLab
File -> New -> Terminal
```
The Terminal session is initially in the home directory of your
account on Dawn.  The JupyterLab view includes a file browser to the
left, initially showing the home directory of your account on Dawn.

You can switch between Terminal and notebooks, once opened, using the tabs
at the top of the main JupyterLab window.

## 5. Download examples and set up environment

If you're not using a training account, meaning that you performed your
own software installation, no further download or set up is needed.  Otherwise,
continue in the Terminal session, working from your home directory.

Clone the workshop repository to your home directory:
```
git clone https://github.com/kh296/260116-dawn-workshop
```
Set up the environement:
```
source ~/260116-dawn-workshop/scripts/workshop_setup.sh
```
The setup clones another repository with examples
(`diffusion-models`) to your home directory, creates
account-specific setup files in `~/260116-dawn-workshop/envs`,
and creates kernel-definition files, which make available the
Python software needed in workshop notebooks,
in `~/.local/shared/jupyter/kernels`.

## 5. Check setup

To check the setup, run an example script that imports `torch` and determines
the number of `xpu` devices (Intel GPUs) available:
```
~/260116-dawn-workshop/examples/run_check_xpu.sh
```
Note that the initial import of `torch` can take a while.

Is the number of GPUs reported what you expect from the number of GPUs
requested when launching the Jupyter Notebook?

## 6. Submit batch job

Resource allocation and non-interative tasks (batch jobs) are managed on Dawn
using a system called [Slurm](https://slurm.schedmd.com/overview.html).

As batch jobs may take a while to complete, it's suggested to submit
now a batch job that users multiple Dawn nodes, and all GPUs per node,
to train a diffusion model.  The job outputs are considered in step 11.

In the Terminal session, move to the examples directory of the
`diffusion-models` project, and submit example job:
```
cd ~/260116-dawn-workshop/projects/diffusion-models/examples
sbatch --account=training-dawn-gpu run_5_diffusion_part2.sh
```

## 7. Exploring Slurm

As seen above, jobs can be submitted to Slurm using:
- [sbatch](https://slurm.schedmd.com/sinfo.html) `<path_to_job_script>`
The way in which a job is treated can be defined using command-line options,
environment variables, and directives as the beginning of the job script.

In the example, the only command-line option used was to define the account
under which the job is to be run.

To see the Slurm environment variables pre-set in your environment, try:
```
env | grep SLURM
```
Check the meanings of these in the [sbatch documentation](https://slurm.schedmd.com/sinfo.html)

Using your favourite editor, or by navigtating to it in the side bar of the
JupyterLab window, open the job script run_5_diffusion_part2.sh,
and check the directives that are used.  Close without making any changes.

Slurm also provides a number of commands that show information about system
resources and job queues, for examples:

- [sinfo](https://slurm.schedmd.com/sinfo.html) : show information
  about all system workspaces (partitions).
- `sinfo -p pvc9` : show information about the Dawn partition (`pvc9`)
- [squeue](https://slurm.schedmd.com/squeue.html) : show information
   about all jobs in the system queues.
- `squeue -p pvc9` : show information about all jobs in the Dawn queues.
- `squeue -u z300` : show information about all jobs of user `z300`.
- `squeue --me` : show information about all jobs of current user.
- [scontrol show reservation](https://slurm.schedmd.com/scontrol.html#OPT_reservation)

Try some of these, to check the system resources and usage, and to check the
status of the job you submitted.

A reservation makes a set of nodes available only to selected users.  How
many nodes have been reserved for the account under which you submitted your
job?

When jobs are listed using `squeue`, the first number shown for each job
is its identifier.  If you want to cancel a job that you've submitted,
for example because you realise it's not doing what you intended, you can
do so with:
- [scancel](https://slurm.schedmd.com/scancel.html) `<job_identifier>`

## 8. Run Jupyter notebook to check available devices

In the JupyterLab window, in the left panel, navigate to
`260116-dawn-workshop/examples`.  Open, and experiment with:
`check_devices.ipynb`.  Before running the notebook, check that the kernel,
indicated towards the top right of the session window, is set to
`diffusion-models`.  If it isn't, change the kernel with:
```
Kernel -> Change Kernel... -> diffusion-models
```
This notebook is intended to provide gives insight into the devices seen
by `torch`, and into the variations in times taken for matrix multiplication
by different devices.

### 9. Run Jupyter notebook for training a diffusion model

In the JupyterLab window, in the left panel, navigate to
`260116-dawn-workshop/projects/diffusion-models/notebooks`.
Except for `introduction_to_stablediffusion.ipynb`, which relies on
`google.colab`, all of the notebooks run on Dawn, although some don't
take advantage of GPUs.

Open, and run, `5_diffusion_part2.ipynb`,
which trains a diffusion model to generate images of hand-written
digits, of the type collected in the
[MNIST database](https://en.wikipedia.org/wiki/MNIST_database).
Before running, ensure that the kernel is set to `diffusion-models`.

The notebook is initially set up so that `torch` uses `"cpu"` as device.
Let the notebook complete at least a few training epochs, and check
the time taken for each.  If the time seems a bit slow, interrupt
the notebook, and comment out the line forcing use of "`cpu`".  This
should result in "`xpu`" being chosen automatically, and a significant
reduction in time taken per epoch.

Let the notebook run to completion, and check the example images
generated.

## 10. Perform model training interactively on multiple GPUs

In the Terminal session, move to the examples directory of the
`diffusion-models` project, and make a copy of the job script:
```
cd ~/260116-dawn-workshop/projects/diffusion-models/examples
cp run_5_diffusion_part2.sh my_run_5_diffusion_part2.sh
```
Open this copy, and search for `PYTHON_OPTS`.  Among the options listed
here, make changes so as to have:
```
 --epochs 20\
 --checkpoint-in checkpoint.pt\
 --checkpoint-out checkpoint.pt\
```

Save the modified copy, and run interactively from the Terminal window:
```
./my_run_5_diffusion_part2.sh
```
How many devices are being used?  What is the time per epoch?

To check the resulting model, return to the notebook `5_diffusion_part2.ipynb`,
in the section **Train for a few epochs**, set `epochs=0`, and run the notebook again.  The resulting generated images should look similar to those
generated previously.

Run `my_run_5_diffusion_part2.sh` a second time.  What happens to the
count of number of epochs?  When this completes, rerun the notebook.
Has there been a improvement in the generated images?

## 11. Examine completed batch jobs

Check the log file for the job submitted in step 11.  The log file should
be in the directory from which you submitted the job, with a name of the
form `diffusion400_<timestamp>.log`.

To check the model resulting from the batch job, return to the notebook
`5_diffusion_part2.ipynb`, in the section **Define the scheduler**,
 set `checkpoint_in='../examples/checkpoint.pt'`.  Rerun the notebook,
and check the new generated images.
