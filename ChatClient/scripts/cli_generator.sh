#!/bin/bash

if ! command -v dialog &> /dev/null; then
    echo "Устанавливаем dialog..."
    brew install dialog
fi

if [ ! -f "targets.json" ]; then 
    chmod +x ./target_generation.sh
    ./target_generation.sh
fi

schemes=()
while IFS= read -r line; do
    schemes+=("$line")
done < <(jq -r '.[]' targets.json)

echo "Загружено ${#schemes[@]} схем из targets.json"

while true; do
    dialog_items=()
    for i in "${!schemes[@]}"; do
        dialog_items+=("$((i+1))" "${schemes[i]}" "off")
    done

    CHOICES=$(dialog \
        --title "Для генерации всех таргетов ничего не выбирайте" \
        --checklist "Пробел - выбор схем, \"esc\" - обновления схем. Периодически обновляйте cache" 20 80 15 \
        "${dialog_items[@]}" 3>&1 1>&2 2>&3
    )

    dialog_return=$?
    if [ $dialog_return -eq 1 ]; then
        clear
        exit 0
    elif [[ $dialog_return -eq 255 ]]; then
        clear
        chmod +x ./target_generation.sh
        ./target_generation.sh
        exec "$0"
    fi

    read -r -a selected_indices <<< "$CHOICES"

    selected_projects=""
    for index in "${selected_indices[@]}"; do
        target_index=$((index - 1))
        selected_projects+=" ${schemes[$target_index]}Tests"
    done

    selected_projects="${selected_projects# }"
    selected_projects="${selected_projects% }"

    generation_cmd="make generate"
    if [[ -n "$selected_projects" ]]; then
        generation_cmd+=" projects=\"$selected_projects\""
    else
        generation_cmd+=" projects=ALL"
    fi
    [[ -n "$dynamic_arg" ]] && generation_cmd+=" $dynamic_arg"
    [[ -n "$no_open_arg" ]] && generation_cmd+=" $no_open_arg"
    clear
    eval "$generation_cmd"
    exit 0
done