#!/bin/bash

echo "install troch 2.6"
uv pip install -U packaging setuptools wheel ninja
uv pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu124
# cudaは下位互換？古いバージョンを選択すればいい？

echo "install axolotl flash-attn deepspeed"
uv pip install --no-build-isolation "axolotl[flash-attn,deepspeed]"
uv pip install -U --no-build-isolation flash-attn

echo "isntall vim"
apt update && apt upgrade -y
apt install vim

echo "finish installing"

