#!/bin/bash

# ==========================================
# ⚙️ Configuration Section
# ==========================================
SCRIPT_FOLDER="./scripts"
EXCLUDE_LIST=("utils" "config" "common" "lib")
# ==========================================

CURRENT_DIR=$(pwd)
TARGET_DIR="$CURRENT_DIR/${SCRIPT_FOLDER}"

# Variable to store help message
HELP_MSG=""
# Command list array for autocomplete
CMD_LIST=()

if [ ! -d "$TARGET_DIR" ]; then
    echo "⚠️  Warning: '$SCRIPT_FOLDER' folder does not exist."
    return
fi

# ------------------------------------------
# 1. Scan scripts (for help message and list generation)
# ------------------------------------------
for file in "$TARGET_DIR"/*; do
    [ -e "$file" ] || continue
    
    filename=$(basename "$file")
    cmd_name="${filename%.*}"

    # Check exclusion list
    skip=false
    for exclude in "${EXCLUDE_LIST[@]}"; do
        if [ "$cmd_name" == "$exclude" ]; then
            skip=true; break
        fi
    done
    if [ "$skip" == true ]; then continue; fi

    # Add to list only, do not register alias
    CMD_LIST+=("$cmd_name")
    HELP_MSG+="\n  🔹 run $cmd_name \t : Run $filename"
done

# ------------------------------------------
# 2. Main 'run' function definition
# ------------------------------------------
function run() {
    local cmd=$1
    local script_path="$TARGET_DIR/$cmd.sh"

    # 1) Print help if input is empty or 'help'
    if [[ -z "$cmd" || "$cmd" == "help" ]]; then
        echo "---------------------------------------"
        echo "🛠️  [Project] Available commands ('run <command>')"
        echo "---------------------------------------"
        echo -e "$HELP_MSG"
        echo ""
        return
    fi

    # 2) Recheck exclusion list (security/error prevention)
    for exclude in "${EXCLUDE_LIST[@]}"; do
        if [ "$cmd" == "$exclude" ]; then
            echo "🚫 '$cmd' cannot be executed directly."
            return 1
        fi
    done

    # 3) Check if script file exists and execute
    if [ -f "$script_path" ]; then
        # Pass remaining arguments ("${@:2}") excluding $cmd
        sh "$script_path" "${@:2}"
    else
        echo "❌ Unknown command: $cmd"
        echo "ℹ️  Enter 'run help' to see the list."
    fi
}

# ------------------------------------------
# 3. Add autocomplete (Tab key) functionality
# ------------------------------------------
# Enable autocomplete so typing 'run b' and pressing Tab becomes 'run build'
if command -v complete &> /dev/null; then
    complete -W "${CMD_LIST[*]}" run
fi

echo "🚀 Environment setup loaded! Use 'run <command>' to execute commands."
# Uncomment to show help message on load
# run help