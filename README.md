# Auth with github
```
brew install gh
gh auth login
```

# config
## Personal Dotfile Management
https://www.atlassian.com/git/tutorials/dotfiles


## Alacritty Post-Install

Official docs on installing extra terminfo:
https://github.com/alacritty/alacritty/blob/master/INSTALL.md#terminfo

Helpful guide on quick way to do that
https://unix.stackexchange.com/a/678901


## Nerd Fonts Setup (OSX)

1. Download font (assuming "Hack Nerd Font"): https://www.nerdfonts.com/font-downloads
1. Open `Font Book` in `Applications`
1. `File` > `Add Fonts To Current User` to install them to `~/Library/Fonts`
1. Run the following to get them into where Alacritty needs them


```
mkdir ~/.local/share/fonts
cd ~/.local/share/fonts
cp ~/Library/Fonts/HackNerdFont-* ./
```
