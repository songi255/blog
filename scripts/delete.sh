#!/bin/bash

# ==========================================
# 🗑️ Delete (Draft or Post)
# ==========================================

DRAFTS_DIR="_drafts"
POSTS_DIR="_posts"

# Color definitions (red is emphasized for deletion as it's dangerous)
GREEN='\033[32m'
CYAN='\033[36m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

echo -e "${RED}🗑️  [Delete] Permanently deleting files.${RESET}"
echo "Which folder's files do you want to delete?"

# 1. Select target folder
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

# 2. Show file list and select
echo -e "\n📂 Select a file to delete:"
shopt -s nullglob
files=("$TARGET_DIR"/*)
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠️  No files to delete.${RESET}"
    exit 0
fi

options=()
for file in "${files[@]}"; do
    options+=("$(basename "$file")")
done

TARGET_FILE=""
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

FULL_PATH="$TARGET_DIR/$TARGET_FILE"

# 3. 🚨 Final confirmation (most important!)
echo -e "---------------------------------------"
echo -e "🚨 ${RED}Warning: This operation cannot be undone!${RESET}"
echo -e "File: ${YELLOW}$FULL_PATH${RESET}"
echo -e "---------------------------------------"
echo -n "Do you really want to delete? (y/N) > "
read CONFIRM

if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
    # Actual delete command (rm)
    rm "$FULL_PATH"
    
    # Check if deletion was successful
    if [ ! -f "$FULL_PATH" ]; then
        echo -e "${GREEN}✅ Deleted.${RESET}"
    else
        echo -e "${RED}❌ Deletion failed. (Permission issue, etc.)${RESET}"
    fi
else
    echo -e "${GREEN}🛡️  Deletion cancelled.${RESET}"
fi