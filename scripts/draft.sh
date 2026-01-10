#!/bin/bash

# ==========================================
# 📝 New Draft Creation Script
# ==========================================

GREEN='\033[32m'
RESET='\033[0m'

# Get title input (prompts if no argument provided)
if [ -z "$1" ]; then
    echo -n "📝 Enter the title of the new post: "
    read TITLE
else
    TITLE="$*"
fi

if [ -z "$TITLE" ]; then
    echo "Cancelled."
    exit 0
fi

echo "🚀 Creating draft '$TITLE'..."

# Execute Jekyll Compose
bundle exec jekyll draft "$TITLE"

echo -e "${GREEN}✅ Creation complete! Check the _drafts folder.${RESET}"