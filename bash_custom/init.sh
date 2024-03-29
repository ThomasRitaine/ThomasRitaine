#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Load bash_aliases
. "$SCRIPT_DIR/.bash_aliases"

source "$SCRIPT_DIR/utils/distro.sh"

# Add Starship
export STARSHIP_CONFIG="$SCRIPT_DIR/../.config/starship.toml"
eval "$(starship init bash)"
