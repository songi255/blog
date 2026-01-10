#!/bin/bash

# ==========================================
# 🏷️ Rename (Title & Filename)
# ==========================================

DRAFTS_DIR="_drafts"
POSTS_DIR="_posts"

GREEN='\033[32m'
CYAN='\033[36m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

echo -e "${CYAN}🏷️  [Rename] Renaming files.${RESET}"
echo "Which folder's files do you want to rename?"

# 1. Select target folder (Draft vs Post)
TARGET_DIR=""
PS3="Select a number (cancel: q): "
select type in "Drafts (_drafts)" "Posts (_posts)"; do
    case $REPLY in
        1) TARGET_DIR="$DRAFTS_DIR"; break ;;
        2) TARGET_DIR="$POSTS_DIR"; break ;;
        q|Q) echo "Cancelled."; exit 0 ;;
        *) echo "Invalid selection." ;;
    esac
done

# 2. Select file
echo -e "\n📂 Select a file to rename:"
shopt -s nullglob
files=("$TARGET_DIR"/*)
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠️  No files found.${RESET}"
    exit 0
fi

options=()
for file in "${files[@]}"; do
    options+=("$(basename "$file")")
done

TARGET_FILE=""
select opt in "${options[@]}"; do
    if [[ "$REPLY" == "q" || "$REPLY" == "Q" ]]; then
        exit 0
    elif [ -n "$opt" ]; then
        TARGET_FILE="$opt"
        break
    else
        echo "Invalid selection."
    fi
done

# 3. Enter new title
echo -e "\n✏️  Enter the new title."
echo -e "${YELLOW}(Note: Both filename and Front Matter title will be changed)${RESET}"
echo -n "New Title > "
read NEW_TITLE

if [ -z "$NEW_TITLE" ]; then
    echo "Cancelled due to empty title."
    exit 0
fi

# 4. Execute Jekyll Rename
echo -e "---------------------------------------"
echo -e "🔄 Renaming..."
echo -e "   From: $TARGET_FILE"
echo -e "   To  : $NEW_TITLE"
echo -e "---------------------------------------"

# jekyll rename "current_path" "new_title"
if bundle exec jekyll rename "$TARGET_DIR/$TARGET_FILE" "$NEW_TITLE"; then
    echo -e "${GREEN}✅ Rename complete!${RESET}"
else
    echo -e "${RED}❌ Rename failed.${RESET}"
    exit 1
fi