function nv() {
  local dir="$1"
  if [[ -z "$dir" ]]; then
	nvim
	return 1
  fi

  if [[ -d "$dir" ]]; then
    cd "$dir" && nvim
  else
    echo "❌ Error: el directorio './$dir' no existe en $(pwd)"
    return 1
  fi
}

function newproject() {
  local project="$1"
  if [[ -z "$project" ]]; then
    echo "Has utilizado mal el comando, ejemplo de uso: newp <nombre_del_proyecto>"
    return 1
  fi

  if [[ -d "~/Development/$project" ]]; then
    echo "❌ Error: el proyecto '$project' ya existe, utiliza otro nombre o revisa el proyecto existente"
    return 1
  else
    mkdir ~/Development/"$project" && cd ~/Development/"$project" && nvim
  fi
}
