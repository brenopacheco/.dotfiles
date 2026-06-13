# Redirect to the real config when XDG_CONFIG_HOME is overridden
set -gx XDG_CONFIG_HOME $HOME/.config
source $HOME/.config/fish/config.fish
