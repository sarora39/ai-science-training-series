#!/bin/bash

ssh username@cerebras.ai.alcf.anl.gov

chmod a+xr ~/
mkdir ~/R_2.1.1
chmod a+x ~/R_2.1.1/
cd ~/R_2.1.1

# deactivate
# rm -r venv_cerebras_pt

/software/cerebras/python3.8/bin/python3.8 -m venv venv_cerebras_pt
source venv_cerebras_pt/bin/activate
pip install --upgrade pip
pip install cerebras_pytorch==2.1.1

git clone https://github.com/Cerebras/modelzoo.git
cd modelzoo
git tag
git checkout Release_2.1.1  

cd ~/R_2.1.1/modelzoo
pip install -r requirements.txt 

# csctl get jobs
# csctl cancel job wsjob-eyjapwgnycahq9tus4w7id

cd ~/R_2.1.1/modelzoo/modelzoo/transformers/pytorch/bert
source ~/R_2.1.1/venv_cerebras_pt/bin/activate
cp /software/cerebras/dataset/bert_large/bert_large_MSL128_sampleds.yaml configs/bert_large_MSL128_sampleds.yaml

# export USERNAME="username"
# vim configs/bert_large_MSL128_sampleds.yaml
# -i vocab_file = "/home/$(whoami)/R_2.1.1/modelzoo/modelzoo/transformers/vocab/google_research_uncased_L-12_H-768_A-12.txt" -esc -:wq -enter

# vim configs/bert_large_MSL128_sampleds.yaml
# -i "batch_size = <batch_size>" -esc -:wq -enter

export MODEL_DIR=model_dir_bert_large_pytorch
if [ -d "$MODEL_DIR" ]; then rm -rf $MODEL_DIR; fi

python run.py CSX --job_labels name=bert_pt --params configs/bert_large_MSL128_sampleds.yaml --num_workers_per_csx=1 --mode train --model_dir $MODEL_DIR --mount_dirs /home/ /software --python_paths ~/R_2.1.1/modelzoo/ --compile_dir $(whoami) |& tee ~/mytest.log
