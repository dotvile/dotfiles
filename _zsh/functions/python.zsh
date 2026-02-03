function py-nm() {
  mkdir -p "$1"
  echo "# Paquete $1" > "./$1/__init__.py"
  echo "# Módulo $1" > "./$1/$1.py"
  echo "✅ Módulo '$1' creado."
}
