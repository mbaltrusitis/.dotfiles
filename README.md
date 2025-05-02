# .dotfiles

## installation.

The `.dotfiles` repo assumes that it is in a user's `$HOME`. Two approaches are
can be used for installation:

1. **git-based installation** // the most typical installation to be used on a
   a system that is frequently used and will want to submit and fetch updates to
   this project.
1. **archive-based installation** // intended for use on systems that are more
   ephemeral and are unlikely to push or pull updates from the project (e.g., a
   VPS).

The installation procedure aims to be idempotent and is safe to run repeatedly.

### dependencies.

First install these dependencies. If you do not intend on using NeoVim, only
curl will be needed.

- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)
- [curl](https://curl.se/)

### instructions.

Having moved away from macOS, Linux is now the solely supported platform.

```
apt-get install fd-find ripgrep curl
```

If the system is running the GNOME desktop environment, it will target both the
`headless` and `desktop` goals. Otherwise, only `headless` will be targeted.

```
git clone https://github.com/mbaltrusitis/.dotfiles "$HOME"
cd ~/.dotfiles
make
```

You may manually target `headless` or `desktop` with these convenience targets:

```
make headless
make desktop
```
