#!/bin/bash

set -e

# Setting the timeout (in seconds) for how long the SageMaker notebook can run idly before being auto-stopped
IDLE_TIME=3600

# Getting the autostop.py script from GitHub
echo "Fetching the autostop script ..."
wget https://raw.githubusercontent.com/GianniBalistreri/d-day/master/ml_ops/scripts/aws_sagemaker_notebook_auto_stop.py

# Using crontab to auto stop the notebook when idle time is breached
echo "Starting the SageMaker auto stop script in cron ..."
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/bin/python $PWD/aws_sagemaker_notebook_auto_stop.py --time $IDLE_TIME --ignore-connections") | crontab -

# Setting the proper user credentials
sudo -u ec2-user -i <<'EOF'
unset SUDO_UID

# Installing a separate conda installation via Miniconda
#WORKING_DIR=/home/ec2-user/SageMaker/custom-miniconda
#mkdir -p "$WORKING_DIR"
#wget https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O "$WORKING_DIR/miniconda.sh"
#bash "$WORKING_DIR/miniconda.sh" -b -u -p "$WORKING_DIR/miniconda" 
#rm -rf "$WORKING_DIR/miniconda.sh"

# Instantiating variables used to create the custom kernel
#source "$WORKING_DIR/miniconda/bin/activate"
KERNEL_NAME="custom_python"
#PYTHON="3.8"

# Creating the custom kernel
#conda create --yes --name "$KERNEL_NAME" python="$PYTHON"
#conda activate "$KERNEL_NAME"

echo "Installing python3.8 ..."
yum install -y python38 python38-devel
python3 -m venv --without-pip test_env
#python3.8 -m venv dev3.8/
echo "Activating python3.8 venv ..."
source test_env/bin/activate
#source dev3.8/bin/activate

# Installing the default ipykernel required from SageMaker
pip install --quiet ipykernel

ipython kernel install --user --name="$KERNEL_NAME"

# Downloading the requirements.txt script from GitHub
wget https://raw.githubusercontent.com/GianniBalistreri/d-day/master/ml_ops/scripts/pyproject.toml

# Installing the Python libraries listed in the requirements.txt script
echo "Installing requirements ..."
pip install --quiet poetry
poetry add fast_gsdmm
pip install --quiet -r requirements.txt
EOF
echo "Starting sagemaker jupyter notebook ..."