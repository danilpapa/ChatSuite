#!/bin/bash

tuist generate --no-open

if ! command -v jq &> /dev/null; then
    echo "Устанавливаем jq для парсинга json"
    brew install jq
fi

PROJECT_WORKSPACE="ChatClient.xcworkspace"
workspace_path="$(cd "$(pwd)" && realpath "$PROJECT_WORKSPACE")"
schemes_output=$(xcodebuild -list -workspace "$workspace_path" 2>&1)

schemes=()
while IFS= read -r line; do 
    line="${line#"${line%%[![:space:]]*}"}"
    if [[ -n "$line" ]]; then
        schemes+=("$line")
    fi
done < <(echo "$schemes_output" | awk '/Schemes:/ {flag=1; next} flag')

WORKSPACE_NAME=$(echo $PROJECT_WORKSPACE | cut -d"." -f1)"-Workspace"

for i in "${!schemes[@]}"; do 
  if [[ "${schemes[$i]}" == "$WORKSPACE_NAME" ]]; then 
    unset 'schemes[$i]'
  fi
done

printf '%s\n' "${schemes[@]}" | jq -R . | jq -s '
  map(
    select((. | test(".*_.*")) | not)
    | select((. | test(".*Tests")) | not)
    | select((. | test("Alamofire")) | not)
  )
' > targets.json