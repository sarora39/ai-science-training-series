#!/bin/bash

ssh username@sambanova.alcf.anl.gov

ssh sn30-r1-h1
# sn30-r1-h2, sn30-r2-h1, sn30-r2-h2, sn30-r3-h1, sn30-r3-h2, sn30-r4-h1, sn30-r4-h2

cp -rv /opt/sambaflow/apps/ ~

git clone https://github.com/sarora39/skhw7.git
cd skhw7/sambanova/
# git clone --no-checkout https://github.com/sarora39/ai-science-training-series.git
# cd ai-science-training-series
# git config core.sparseCheckout true
# echo "07_AITestbeds/shikhararora_hw7/*" >> .git/info/sparse-checkout
# git pull origin main
# cd 07_AITestbeds/shikhararora_hw7/sambanova/


chmod +x BertLarge.sh
chmod +x BertLarge_run.sh

./BertLarge.sh logs_16 16
./BertLarge.sh logs_8 8
./BertLarge.sh logs_4 4

# chmod +x ~/slurm-<id>.out
# cat slurm-<id>.out
# squeue
