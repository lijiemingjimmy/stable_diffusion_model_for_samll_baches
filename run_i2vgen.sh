#!/bin/bash
# Clone VGen (I2VGen‑XL) repository
# Ensure git is installed. This script will clone the repo and prepare the environment.

# exit if any command fails
set -e

# Step 1: Clone VGen repository if it doesn't already exist
if [ ! -d "VGen" ]; then
  git clone https://github.com/ali-vilab/VGen.git
fi
cd VGen

# Step 2: Create Python virtual environment (optional but recommended)
# Uncomment the next two lines if you want to create a venv with Python 3.9+
# python3 -m venv venv
# source venv/bin/activate

# Step 3: Install required packages using a Chinese mirror
# It is strongly recommended to install packages with a domestic mirror to avoid network issues.
# This installs general dependencies for VGen and ModelScope.
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install modelscope -i https://pypi.tuna.tsinghua.edu.cn/simple

# Step 4: Download the pre‑trained I2VGen‑XL model from ModelScope
# The snapshot_download API will place all model files in the 'models' directory.
python - <<'PY'
from modelscope.hub.snapshot_download import snapshot_download
# download the I2VGen‑XL model (revision v1.0.0) to the models directory
snapshot_download('damo/I2VGen-XL', cache_dir='models', revision='v1.0.0')
PY

# Step 5: Run inference on the demo dataset
# Use the provided test_list_for_i2vgen.txt as input. The script will read
# images and captions from data/test_list_for_i2vgen.txt and save output videos
# in workspace/experiments/test_list_for_i2vgen.
python inference.py \
  --cfg configs/i2vgen_xl_infer.yaml \
  test_list_path data/test_list_for_i2vgen.txt \
  test_model models/i2vgen_xl_00854500.pth

echo "\nInference complete. Generated videos can be found in workspace/experiments/test_list_for_i2vgen directory."
