#!/bin/bash

ssh username@groq.ai.alcf.anl.gov

ssh groq-r01-gn-01.ai.alcf.anl.gov
# groq-r01-gn-0[1-9].ai.alcf.anl.gov

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
# exit and reopen shell after conda installation

export PYTHON_VERSION=3.10.12
conda create -n groqflow python=$PYTHON_VERSION -y
conda activate groqflow

git clone https://github.com/groq/groqflow.git
cd groqflow

if [ -d "groqflow.egg-info" ]; then rm -r groqflow.egg-info; fi
pip install --upgrade pip
pip list --format=freeze > frozen.txt
pip install -r frozen.txt -e .
pushd . 
cd demo_helpers
if [ -d "groqflow_demo_helpers.egg-info" ]; then rm -r groqflow_demo_helpers.egg-info; fi
pip install -e .
popd
pip install soundfile
conda activate groqflow

qsub -I -l walltime=1:00:00
# qstat qdel

cd ~/ groqflow/proof_points/natural_language_processing/bert
conda activate groqflow
pip install -r requirements.txt

python bert_tiny.py > ~/logs_groq/dummy.out 2>&1

## Homework 7

cp ~/skhw7/groq/bert_tiny_custom.py ./bert_tiny_custom.py
# cd
# git clone --no-checkout https://github.com/sarora39/ai-science-training-series.git
# cd ai-science-training-series
# git config core.sparseCheckout true
# echo "07_AITestbeds/shikhararora_hw7/*" >> .git/info/sparse-checkout
# git pull origin main
# cp 07_AITestbeds/shikhararora_hw7/groq/bert_tiny_custom.py ~/groqflow/proof_points/natural_language_processing/bert/bert_tiny_custom.py

python bert_tiny_custom.py --batch_size 10 --max_seq_length 256 > ~/logs_groq/custom.out 2>&1
