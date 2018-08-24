#! /bin/sh

# Install ZSH
curl -L https://sourceforge.net/projects/zsh/files/latest/download > zsh.tar.gz
tar -xvzf zsh.tar.gz
cd zsh*/ || exit 1
./configure --prefix="${HOME}/.local"
make
make install
cd - || exit 1
rm -fr zsh*
export PATH="${HOME}/.local/bin:${PATH}"

# Install GodBlessGit and source
curl -L https://github.com/AlexisBRENON/god-bless-git/archive/master.tar.gz > gbg.tar.gz
tar -xvzf gbg.tar.gz
# shellcheck disable=1091
. ./god-bless-git-master/god_bless_git.sh

case $1 in
    posix)
        sh -x
        ;;
    bash)
        bash -x
        ;;
    zsh)
        zsh -yx
        ;;
    *)
        exit -1
        ;;
esac


