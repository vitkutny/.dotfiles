# .dotfiles

```sh
cd ~
git clone --recurse-submodules git@github.com:vitkutny/.dotfiles.git
cd .dotfiles
```

https://brew.sh
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ln -s "${PWD##*/}/brew/.Brewfile" ../.Brewfile
brew bundle --global
```

https://www.gnu.org/software/stow/manual/stow.html
```sh
stow -R --no-folding */ --simulate -v
stow -R --no-folding */
```

## infat

https://github.com/philocalyst/infat
```sh
infat --config ~/.config/infat/config.toml
```

## osxphotos

https://github.com/RhetTbull/osxphotos
```sh
uv tool install osxphotos
```

## bugwarrior

https://github.com/GothenburgBitFactory/bugwarrior
```sh
# --with setuptools until https://github.com/ralphbean/taskw stop using distutils.version removed from python3.12
uv tool install 'bugwarrior[keyring]' --with setuptools
```
