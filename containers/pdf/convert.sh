FILE_NAME=A2-7-n
MOVE_TO_FOLDER=/home/atle/dev/books/books/amorc

set -euo pipefail

echo "FILE IS: $FILE_NAME"
echo "FOLDER IS: $MOVE_TO_FOLDER"

FULL_PATH="${MOVE_TO_FOLDER}/${FILE_NAME}"

echo "FULL PARG : $FULL_PATH"

mkdir -p "$FULL_PATH"

PAYLOAD=$(jq -cn --arg filepath "/data/${FILE_NAME}.pdf" '{filepath: $filepath, output_format: "markdown"}')
echo "$PAYLOAD"

curl --fail-with-body -s -X POST http://127.0.0.1:8008/marker \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" | tee response.json

echo "response got"


jq -r '.markdown' response.json > "${FULL_PATH}/index.md"

jq -r '.images | to_entries[] | "\(.key)\t\(.value)"' response.json \
  | while IFS=$'\t' read -r name b64; do
      printf '%s' "$b64" | base64 -d > "$FULL_PATH/$name"
    done

echo "DONE!"