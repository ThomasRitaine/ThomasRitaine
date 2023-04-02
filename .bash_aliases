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

#   Docker Exec, interactive
de () {
    command docker exec -it $1 /bin/bash
}

#   Docker Exec, simple command
dec () {
    command docker exec $1
}

#   Miscellaneous
alias update="sudo apt-get update && sudo apt-get upgrade"
