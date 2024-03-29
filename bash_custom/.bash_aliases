#   Directories
alias ..="cd .."
alias ....="cd ../.."
alias ll="ls -la"

cd() {
    if [[ $1 = "c" ]]; then
        builtin cd /mnt/c
    elif [[ $1 = "c~" ]]; then
        builtin cd /mnt/c/Users/Thomas
    else
        builtin cd $@
    fi
}

#   Docker Compose
dc () {
  if [[ $1 == "dev" || $1 == "prod" ]]; then
    command docker compose -f docker-compose.yml -f docker-compose."$1".yml ${@:2}
  else
    command docker compose $@
  fi
}

#   Docker Exec
de () {
    if [[ $2 == "bash" || $2 == "sh"  ]]; then
        command docker exec -it $1 /bin/$2
    else
        command docker exec $@
    fi
}

#   Miscellaneous
alias update="sudo apt-get update && sudo apt-get upgrade"

#   Background image
BASH_ALIASES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
bg () {
    command bash "$BASH_ALIASES_DIR/../windows_terminal/background/bg.sh" $@
}
