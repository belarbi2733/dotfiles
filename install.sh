#!/bin/bash

current_dir=$PWD;
homeconfig="$(ls -F | grep -v / | egrep -iv \(bin\|install\|readme\|profile\))";

# Create symbolic links for configuration files to the
# content of this folder

for fichier in $homeconfig; do
    if [ ! -f $HOME/.$fichier ] ; then
	ln -s $current_dir/$fichier $HOME/.$fichier
	echo "~/.$fichier has been created"
    else
	echo "~/.$fichier already exists"
    fi
done

# Make sure the $HOME/.profile file is not a symlink
# If it is, replace it with the system template

if [ -h $HOME/.profile ];then
    rm $HOME/.profile;
    cp /etc/skel/.profile $HOME;
fi



# The $HOME/.local/bin folder is used by python-pip
# Ensure it is in the PATH variable

if `grep "HOME/.local/bin" $HOME/.profile >/dev/null 2>&1`; then
    echo "$HOME/.local/bin is already in the path";
else
    if [ ! -d $HOME/.local/bin ]; then
	echo "Creating and adding ~/.local/bin to the path";
	mkdir -p $HOME/.local/bin ;
    else
	echo "The ~/.local/bin folder already exists. It will be added to the path";
    fi
    cat >> $HOME/.profile <<'EOF'

# set PATH so it includes user's .local/bin folder
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

EOF
fi

if ( ! `grep "fire_tmux.bash" $HOME/.profile >/dev/null 2>&1` ); then
    cat >> $HOME/.profile <<EOF
if [ -f $current_dir/fire_tmux.bash ]; then
    source $current_dir/fire_tmux.bash
fi

EOF
fi
echo "if [ -f ~/.fire_tmux.bash ]; then
        . ~/.fire_tmux.bash
     fi" >> $HOME/.bashrc
echo "source "$HOME/.bashrc" " >> $HOME/.bash_profile


git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# Load aliases
source ~/.bash_aliases

# Create a template dir for git hooks

git config --global init.templateDir $current_dir/gitemplates
