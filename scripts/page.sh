#!/bin/bash

# ==========================================
# 📄 New Page Creation Script
# ==========================================

GREEN='\033[32m'
CYAN='\033[36m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

echo -e "${CYAN}📄 [Page] Creating a new page.${RESET}"
echo "Enter the title of the page to create."
echo -e "${YELLOW}(e.g., About, Contact, My Project)${RESET}"

# 1. Get title input
echo -n "Title > "
read TITLE

if [ -z "$TITLE" ]; then
    echo "Cancelled."
    exit 0
fi

# 2. Execute Jekyll Compose Page
echo -e "---------------------------------------"
echo -e "🚀 Creating page '$TITLE'..."

# bundle exec jekyll page "Title"
if bundle exec jekyll page "$TITLE"; then
    echo -e "${GREEN}✅ Creation complete!${RESET}"
    echo -e "   Check the root directory (or configured path)."
else
    echo -e "${RED}❌ Failed.${RESET}"
    exit 1
fi