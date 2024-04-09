#!/bin/bash

ssh username@gc-login-01.ai.alcf.anl.gov
# ssh usernameID@gc-login-02.ai.alcf.anl.gov

ssh gc-poplar-02.ai.alcf.anl.gov
# ssh gc-poplar-03.ai.alcf.anl.gov
# ssh gc-poplar-04.ai.alcf.anl.gov

mkdir -p ~/venvs/graphcore
virtualenv ~/venvs/graphcore/poptorch33_env
source ~/venvs/graphcore/poptorch33_env/bin/activate

POPLAR_SDK_ROOT=/software/graphcore/poplar_sdk/3.3.0
export POPLAR_SDK_ROOT=$POPLAR_SDK_ROOT
pip install $POPLAR_SDK_ROOT/poptorch-3.3.0+113432_960e9c294b_ubuntu_20_04-cp38-cp38-linux_x86_64.whl

mkdir ~/tmp
export TF_POPLAR_FLAGS=--executable_cache_path=~/tmp
export POPTORCH_CACHE_DIR=~/tmp

export POPART_LOG_LEVEL=WARN
export POPLAR_LOG_LEVEL=WARN
export POPLIBS_LOG_LEVEL=WARN

export PYTHONPATH=/software/graphcore/poplar_sdk/3.3.0/poplar-ubuntu_20_04-3.3.0+7857-b67b751185/python:$PYTHONPATH

mkdir ~/graphcore
cd ~/graphcore
git clone https://github.com/graphcore/examples.git
cd examples
git tag
git checkout v3.3.0

cd ~/graphcore/examples/tutorials/simple_applications/pytorch/mnist
source ~/venvs/graphcore/poptorch33_env/bin/activate
python -m pip install -r requirements.txt

/opt/slurm/bin/srun --ipus=1 python mnist_poptorch.py

# /opt/slurm/bin/srun --ipus=1 python mnist_poptorch.py --batch-size 4 --lr 0.03 --epochs 20 > ~/logs_gc/logs_b4_l03_e_20.out 2>&1
# /opt/slurm/bin/srun --ipus=1 python mnist_poptorch.py --batch-size 8 --lr 0.003 --epochs 20 > ~/logs_gc/logs_b8_l003_e_20.out 2>&1
# /opt/slurm/bin/srun --ipus=1 python mnist_poptorch.py --batch-size 8 --lr 0.03 --epochs 20 > ~/logs_gc/logs_b8_l03_e_20.out 2>&1
# /opt/slurm/bin/srun --ipus=1 python mnist_poptorch.py --batch-size 8 --lr 0.3 --epochs 20 > ~/logs_gc/logs_b8_l3_e_20.out 2>&1
# /opt/slurm/bin/srun --ipus=1 python mnist_poptorch.py --batch-size 16 --lr 0.03 --epochs 20 > ~/logs_gc/logs_b16_l03_e_20.out 2>&1
