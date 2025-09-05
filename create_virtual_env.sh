#!/bin/bash
### uv
echo "install uv"
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "create path uv"
source $HOME/.local/bin/env

### tmux
# できなかった

echo "create workspace"
mkdir workspace/axolotl
cd workspace/axolotl

echo "create virtual env"
uv init --python 3.11
uv venv
source .venv/bin/activate

echo "finish"

