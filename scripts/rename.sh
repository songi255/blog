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

echo -e "${CYAN}🏷️  [Rename] 파일 이름을 변경합니다.${RESET}"
echo "어떤 폴더의 파일을 변경하시겠습니까?"

# 1. 대상 폴더 선택 (Draft vs Post)
TARGET_DIR=""
PS3="번호를 선택하세요 (취소: q): "
select type in "Drafts (_drafts)" "Posts (_posts)"; do
    case $REPLY in
        1) TARGET_DIR="$DRAFTS_DIR"; break ;;
        2) TARGET_DIR="$POSTS_DIR"; break ;;
        q|Q) echo "취소되었습니다."; exit 0 ;;
        *) echo "잘못된 선택입니다." ;;
    esac
done

# 2. 파일 선택
echo -e "\n📂 변경할 파일을 선택하세요:"
shopt -s nullglob
files=("$TARGET_DIR"/*)
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠️  파일이 없습니다.${RESET}"
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
        echo "잘못된 선택입니다."
    fi
done

# 3. 새 제목 입력
echo -e "\n✏️  새로운 제목(Title)을 입력하세요."
echo -e "${YELLOW}(주의: 파일명과 Front Matter의 title이 모두 변경됩니다)${RESET}"
echo -n "New Title > "
read NEW_TITLE

if [ -z "$NEW_TITLE" ]; then
    echo "제목이 입력되지 않아 취소합니다."
    exit 0
fi

# 4. Jekyll Rename 실행
echo -e "---------------------------------------"
echo -e "🔄 변경 중..."
echo -e "   From: $TARGET_FILE"
echo -e "   To  : $NEW_TITLE"
echo -e "---------------------------------------"

# jekyll rename "현재경로" "새로운제목"
if bundle exec jekyll rename "$TARGET_DIR/$TARGET_FILE" "$NEW_TITLE"; then
    echo -e "${GREEN}✅ 이름 변경 완료!${RESET}"
else
    echo -e "${RED}❌ 변경 실패.${RESET}"
    exit 1
fi