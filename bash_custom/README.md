# Custom Bash Config

My personal bash config that loads my bash aliases, and starts Starship.

## Installation

1. Clone the repository to your local machine.
```sh
git clone https://github.com/ThomasRitaine/ThomasRitaine
```

2. Add the setup script of that config inside your `.bashrc`
```sh
echo '
#====================================
#======== LOAD CUSTOM CONFIG ========
#====================================

# Load bash_aliases and Starship from my personal config repo
if [ -d ~/dev-projects/ThomasRitaine ]; then
    source ~/dev-projects/ThomasRitaine/bash_custom/init.sh
fi
' >> ~/.bashrc
```
Don't forget to change `~/dev-projects` to the directory you copied the repo in.
