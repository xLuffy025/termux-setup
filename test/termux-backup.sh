#!/data/data/com.termux/files/usr/bin/bash

cd $HOME

dirs=".config .termux .ssh scripts"

repo="$HOME/.termux-backup"

if [ ! -d "$repo" ]; then
    git clone git@github.com:xLuffy025/termux-setup.git "$repo"
fi

cd "$repo"

for d in $dirs; do
    [ -d "$HOME/$d" ] && cp -r "$HOME/$d" "$repo/"
done

git add .
git commit -m "Backup $(date)"
git push
