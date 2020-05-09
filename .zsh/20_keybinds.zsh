
# ctrl-a, ctrl-e
bindkey -e

# ヒストリをpecoで選択し実行する (ctrl + r)
function _peco-select-history() {
    # historyを番号なし、逆順、最初から表示。
    # 順番を保持して重複を削除。
    # カーソルの左側の文字列をクエリにしてpecoを起動
    # \nを改行に変換
    BUFFER="$(history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER" | sed 's/\\n/\n/')"
    CURSOR=$#BUFFER             # カーソルを文末に移動
    zle -R -c                   # refresh
}
zle -N _peco-select-history
bindkey '^R' _peco-select-history

# tmuxの起動・停止 (ctrl + ])
_start_tmux_if_stopped() {
    if [[ -n $TMUX ]]; then
        # tmux is running
        tmux detach
    else
        # tmux is not running
        BUFFER="tmux attach"

        # カーソルの位置情報、「0」は行頭､「$」は行末｡
        # つまり、「カーソルの位置は､BUFFERの行末に」というもの｡
        CURSOR=$#BUFFER
        zle accept-line
    fi
}
zle -N _start_tmux_if_stopped
bindkey '^]' _start_tmux_if_stopped

# gitのトップディレクトリに移動 (ctrl + t)
_cd_top() {
    # git grepが使えるかどうか調べる
    if is_in_git; then
        # git内なので使える
        builtin cd `git rev-parse --show-toplevel`
    else
        # git外なので使えない
        # その場合はホームに移動
        builtin cd ~/
    fi
    zle accept-line
}
zle -N _cd_top
bindkey '^T' _cd_top

