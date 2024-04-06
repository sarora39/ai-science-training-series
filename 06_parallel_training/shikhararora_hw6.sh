#!/bin/bash

qsub -A ALCFAITP -q debug -l select=2 -l walltime=01:00:00,filesystems=eagle:home -I

module load conda/2023-10-04 ; conda activate base

git clone https://github.com/saforem2/wordplay

cd wordplay

mkdir -p venvs/polaris/2023-10-04
python3 -m venv venvs/polaris/2023-10-04 --system-site-packages
source venvs/polaris/2023-10-04/bin/activate

python3 -m pip install -e "."

git clone https://github.com/saforem2/ezpz

python3 -m pip install -e "ezpz[dev]"
source ezpz/src/ezpz/bin/savejobenv
source ezpz/src/ezpz/bin/getjobenv

python3 data/shakespeare_char/prepare.py

cd src/wordplay
launch python3 __main__.py +experiment=shakespeare data=shakespeare train.backend=DDP train.max_iters=100 train.log_interval=5 train.compile=false

# ---------------------------------------------------------------- HOMEWORK 6 ---------------------------------------------------------------------

#    Link to W&B run:

#        ```bash
#        wandb: 🚀 View run borg-dukat-1 at: https://wandb.ai/shikhararora/WordPlay/runs/8wfqokuu
#        ```
# -------------------------------------------------------------------------------------------------------------------------------------------------