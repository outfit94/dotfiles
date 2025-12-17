#!/bin/bash

# 0.実行手順
# chmod +x setup_tmux.sh
# ./setup_tmux.sh

# 1. tpm (Tmux Plugin Manager) のインストール
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo "Installing tpm..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "tpm is already installed."
fi

# 2. .tmux.conf のバックアップと更新
if [ -f "$HOME/.tmux.conf" ]; then
    cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
    echo "Backup of .tmux.conf created at ~/.tmux.conf.bak"
fi

# 3. 必要なプラグイン設定を .tmux.conf に追記
# すでに設定がある場合はスキップする判定を入れています
if ! grep -q "tmux-plugins/tpm" "$HOME/.tmux.conf"; then
    echo "Adding plugin configurations to .tmux.conf..."
    cat << 'EOF' >> "$HOME/.tmux.conf"

# =======================================================
# Tpm Plugins
# =======================================================
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-yank'

# continuum restore
set -g @continuum-restore 'on'

# Initialize TMUX plugin manager (keep this at the very bottom)
run '~/.tmux/plugins/tpm/tpm'
EOF
fi

# 4. プラグインの自動インストール実行
echo "Installing tmux plugins..."
# tmuxが起動していればリロード、していなければ環境変数を与えてヘッドレスインストール
if [ -n "$TMUX" ]; then
    tmux source ~/.tmux.conf
fi
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

echo "Setup complete!"