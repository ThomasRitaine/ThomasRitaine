#   Directories
alias ..="cd .."
alias ....="cd ../.."

cd() {
    if [[ $1 = "proj" ]]; then
        builtin cd ~/dev-projects
    elif [[ $1 = "etuutt" ]]; then
        builtin cd ~/dev-projects/etuutt-api
    elif [[ $1 = "c" ]]; then
        builtin cd /mnt/c
    elif [[ $1 = "c~" ]]; then
        builtin cd /mnt/c/Users/Thomas
    else
        builtin cd "$@"
    fi
}

#   Docker Compose
dc () {
  if [[ $1 == "dev" || $1 == "prod" ]]; then
    command docker compose -f docker-compose.yml -f docker-compose."$1".yml "${@:2}"
  else
    command docker compose "$@"
  fi
}

#   Docker Container Exec
de () {
  if [[ $1 == "app" ]]; then
    command docker exec -it application /bin/bash
  else
    command docker exec -it "$1" /bin/bash
  fi
}

#   Miscellaneous
alias update="sudo apt-get update && sudo apt-get upgrade"
