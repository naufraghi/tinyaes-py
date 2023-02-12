# create ~/.local/bin
mkdir -p ~/.local/bin

# download and extract just to ~/.local/bin/just
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/.local/bin

# add `~/.local/bin` to the paths that your shell searches for executables
# this line should be added to your shells initialization file,
# e.g. `~/.bashrc` or `~/.zshrc`
export PATH="$PATH:$HOME/.local/bin"

# just should now be executable
just --help