#!/bin/bash

# ==========================================
# 🔙 Unpublish (Post -> Draft)
# ==========================================

POSTS_DIR="_posts"
GREEN='\033[32m'
CYAN='\033[36m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

if [ ! -d "$POSTS_DIR" ]; then
    echo -e "${RED}❌ Error: '$POSTS_DIR' folder does not exist.${RESET}"
    exit 1
fi

echo -e "${CYAN}🔙 [Unpublish] Select a post to revert to Draft:${RESET}"

# 1. Get Post list (sorted by date)
# Can adjust with ls -r (reverse) to show newest posts at the end (or beginning),
# but by default it's sorted by date filename, so just read as is.
shopt -s nullglob
post_files=("$POSTS_DIR"/*)
shopt -u nullglob

if [ ${#post_files[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠️  No published posts found.${RESET}"
    exit 0
fi

# 2. Extract filenames to create selection options
options=()
for file in "${post_files[@]}"; do
    options+=("$(basename "$file")")
done

TARGET_FILE=""
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

# 3. Execute Jekyll Unpublish
echo -e "---------------------------------------"
echo -e "📄 Selected file: ${YELLOW}$TARGET_FILE${RESET}"
echo -e "🔙 Moving to Draft..."
echo -e "---------------------------------------"

if bundle exec jekyll unpublish "$POSTS_DIR/$TARGET_FILE"; then
    echo -e "${GREEN}✅ Unpublish complete! Check the _drafts folder.${RESET}"
else
    echo -e "${RED}❌ Failed.${RESET}"
    exit 1
fi