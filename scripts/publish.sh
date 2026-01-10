#!/bin/bash

# ==========================================
# ⚙️ Configuration
# ==========================================
DRAFTS_DIR="_drafts"

# Color codes
GREEN='\033[32m'
CYAN='\033[36m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'
# ==========================================

# 1. Check if Jekyll Compose is installed (recommended)
if ! bundle info jekyll-compose &> /dev/null; then
    echo -e "${RED}❌ Error: 'jekyll-compose' gem is not installed.${RESET}"
    echo "Add 'gem \"jekyll-compose\"' to Gemfile and run 'bundle install'."
    exit 1
fi

# 2. Check _drafts folder
if [ ! -d "$DRAFTS_DIR" ]; then
    echo -e "${RED}❌ Error: '$DRAFTS_DIR' folder does not exist.${RESET}"
    exit 1
fi

TARGET_FILE=""

# 3. Argument processing logic
if [ -n "$1" ]; then
    # User directly entered filename
    if [ -f "$DRAFTS_DIR/$1" ]; then
        TARGET_FILE="$1"
    elif [ -f "$DRAFTS_DIR/$1.md" ]; then
        TARGET_FILE="$1.md"
    elif [ -f "$DRAFTS_DIR/$1.markdown" ]; then
        TARGET_FILE="$1.markdown"
    else
        echo -e "${RED}❌ File does not exist: $1${RESET}"
        exit 1
    fi
else
    # 4. If no argument, run interactive menu (Select)
    echo -e "${CYAN}💎 [Jekyll Compose] Select a Draft to Publish:${RESET}"
    
    shopt -s nullglob
    draft_files=("$DRAFTS_DIR"/*)
    shopt -u nullglob

    if [ ${#draft_files[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No Draft files found.${RESET}"
        exit 0
    fi

    options=()
    for file in "${draft_files[@]}"; do
        options+=("$(basename "$file")")
    done

    PS3="Select a number (cancel: q): "
    select opt in "${options[@]}"; do
        if [[ "$REPLY" == "q" || "$REPLY" == "Q" ]]; then
            echo "Cancelled."
            exit 0
        elif [ -n "$opt" ]; then
            TARGET_FILE="$opt"
            break
        else
            echo "Invalid selection."
        fi
    done
fi

# ==========================================
# 5. Execute Jekyll Compose
# ==========================================

echo -e "---------------------------------------"
echo -e "📄 Selected file: ${YELLOW}$TARGET_FILE${RESET}"
echo -e "🚀 Running Jekyll Compose Publish..."
echo -e "---------------------------------------"

# Execute command (bundle exec jekyll publish "_drafts/filename")
# jekyll-compose takes filename with path as argument
if bundle exec jekyll publish "$DRAFTS_DIR/$TARGET_FILE"; then
    echo -e ""
    echo -e "${GREEN}✅ Successfully published!${RESET}"
    echo -e "   Check: Verify the _posts folder."
else
    echo -e ""
    echo -e "${RED}❌ Publish failed. Check the logs.${RESET}"
    exit 1
fi