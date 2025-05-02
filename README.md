# .dotfiles

These are my dotfiles. There are many like them, but these are mine.

## installation.

The `.dotfiles` project assumes it is:

* in a user's `$HOME` (e.g., `/home/jcleese/.dotfiles`)
* on an Ubuntu 24.04 system

There are two approaches to installation:

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

### git-based.

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

### archive-based.

When needing to perform deeper analysis or exploration on a remote system, I
want to be able to bootstrap it with familiar tooling quickly and easily. For
convenience, the [install.sh](./install.sh) file who's contents fetches this
project as an archive is returned by [dots.mgb.nyc](http://dots.mgb.nyc).
Enabling a quick installation by piping this easy to remember URL to bash:

```
curl -L dots.mgb.nyc | bash
```

The script is quite simple, it will:

- check for `curl` and `unzip` and install them as needed
- download an archive of the latest version of the `.dotfiles` repo
- unpack it to `/tmp/dotfiles`

From there you can move the `dotfiles` directory to the appropriate home folder
and then run `make`.
