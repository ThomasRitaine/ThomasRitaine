# Custom Bash Config

My personal bash config that loads my bash aliases, and starts Starship.

## Installation

1. Clone the repository to your local machine. (To install on a VPS, clone it inside `/usr/share`)

```sh
git clone https://github.com/ThomasRitaine/ThomasRitaine
```

2. Install Starship

```sh
curl -sS https://starship.rs/install.sh | sh
```

3. Install JQ

```sh
sudo apt install jq -y
```

4. Add the setup script of that config inside your `.bashrc`

```sh
echo '
#====================================
#======== LOAD CUSTOM CONFIG ========
#====================================

# Load bash_aliases and Starship from my personal config repo
CONFIG_REPO_DIR=~/dev-projects/ThomasRitaine
if [ -d "$CONFIG_REPO_DIR" ]; then
    source "$CONFIG_REPO_DIR/bash_custom/init.sh"
fi
' >> ~/.bashrc
```

Don't forget to change `~/dev-projects` to the directory you copied the repo in.
