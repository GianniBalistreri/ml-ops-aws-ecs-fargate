#!/bin/bash

set -e

# Setting the timeout (in seconds) for how long the SageMaker notebook can run idly before being auto-stopped
IDLE_TIME=300

# Getting the autostop.py script from GitHub
echo "Fetching the autostop script..."
wget https://raw.githubusercontent.com/GianniBalistreri/d-day/ml_ops/scripts/aws_sagemaker_notebook_auto_stop.py

# Using crontab to autostop the notebook when idle time is breached
echo "Starting the SageMaker auto stop script in cron."
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/bin/python $PWD/aws_sagemaker_notebook_auto_stop.py --time $IDLE_TIME --ignore-connections") | crontab -

# Setting the proper user credentials
sudo -u ec2-user -i <<'EOF'
unset SUDO_UID
# Setting the source for the custom conda kernel
WORKING_DIR=/home/ec2-user/SageMaker/custom-miniconda
source "$WORKING_DIR/miniconda/bin/activate"
# Loading all the custom kernels
for env in $WORKING_DIR/miniconda/envs/*; do
    BASENAME=$(basename "$env")
    source activate "$BASENAME"
    python -m ipykernel install --user --name "$BASENAME" --display-name "Custom ($BASENAME)"
done