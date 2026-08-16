#!/usr/bin/env bash
# Genera previews .webp de todas las imagenes en caja-*/ y grafica-*/,
# preservando la misma ruta relativa dentro de webp/.
# Uso: scripts/generar-webp.sh
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v cwebp &> /dev/null; then
  echo "cwebp no esta instalado. En macOS: brew install webp" >&2
  exit 1
fi

ANCHO=600
CALIDAD=80

for dir in caja-*/ grafica-*/; do
  [ -d "$dir" ] || continue
  dir="${dir%/}"
  find "$dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | while read -r archivo; do
    nombre="$(basename "$archivo")"
    nombre_webp="${nombre%.*}.webp"
    destino="webp/$dir/$nombre_webp"
    mkdir -p "webp/$dir"
    if [ -f "$destino" ] && [ "$destino" -nt "$archivo" ]; then
      continue
    fi
    cwebp -quiet -q "$CALIDAD" -resize "$ANCHO" 0 "$archivo" -o "$destino"
  done
done

echo "Listo."
