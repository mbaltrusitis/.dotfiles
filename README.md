# .dotfiles

## installation.

### dependencies.

- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)
- [wget](https://www.gnu.org/software/wget/)

### instructions.

### platforms.

##### macOS.

```
brew install fd ripgrep wget
```

##### linux.

```
apt-get install fd-find ripgrep wget
```

```
git clone https://github.com/mbaltrusitis/.dotfiles "$HOME"
cd ~/.dotfiles
make
```

#### nvchad

Link `nvchad_custom` to `nvim/lua/custom`.
