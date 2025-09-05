#!/bin/bash
### uv
echo "install uv"
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "create path uv"
# 追加したい行
LINE='. "$HOME/.local/bin/env"'
BASHRC="$HOME/.bashrc"

# ~/.bashrc に既に存在するか確認
if ! grep -Fxq "$LINE" "$BASHRC"; then
    echo "$LINE" >> "$BASHRC"
    echo "追記しました: $LINE"
else
    echo "すでに存在しています: $LINE"
fi

# .bashrc を再読み込み
# login shell / non-login shell 両方で動作
if [ -f "$BASHRC" ]; then
    # bash が対話的に走っている場合は source
    if [ -n "$BASH_VERSION" ]; then
        # 現行シェルに反映
        # （子プロセスでの source は意味がないので注意）
        echo ".bashrc を再読み込みします..."
        source "$BASHRC"
    fi
fi

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

