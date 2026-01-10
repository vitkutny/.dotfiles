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

https://github.com/philocalyst/infat
```sh
infat --config ~/.config/infat/config.toml
```

