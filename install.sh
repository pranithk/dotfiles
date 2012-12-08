#!/bin/bash -x

dir=~/dotfiles
olddir=~/dotfiles_old
top_files="bashrc vim bash_alias bash_dirs"
vim_files="vimrc gvimrc"

mkdir -p $olddir

cd $dir
function install_file {
	file=$1
	srcdir=$2
	backupdir=$3
	mv ~/.$file $backupdir
	ln -s $srcdir/$file ~/.$file
}

for file in $top_files; do
	install_file $file $dir $olddir
done

for file in $vim_files; do
	install_file $file $dir/vim $olddir
done

#Vim dirs
mkdir ~/.vimbackup
mkdir ~/.vimtmp
mkdir ~/.vimundo
