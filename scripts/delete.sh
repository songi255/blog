#!/bin/bash

# ==========================================
# 🗑️ Delete (Draft or Post)
# ==========================================

DRAFTS_DIR="_drafts"
POSTS_DIR="_posts"

# 색상 정의 (삭제는 위험하므로 빨간색을 강조)
GREEN='\033[32m'
CYAN='\033[36m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

echo -e "${RED}🗑️  [Delete] 파일을 영구적으로 삭제합니다.${RESET}"
echo "어떤 폴더의 파일을 삭제하시겠습니까?"

# 1. 대상 폴더 선택
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

# 2. 파일 목록 보여주기 및 선택
echo -e "\n📂 삭제할 파일을 선택하세요:"
shopt -s nullglob
files=("$TARGET_DIR"/*)
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠️  삭제할 파일이 없습니다.${RESET}"
    exit 0
fi

options=()
for file in "${files[@]}"; do
    options+=("$(basename "$file")")
done

TARGET_FILE=""
select opt in "${options[@]}"; do
    if [[ "$REPLY" == "q" || "$REPLY" == "Q" ]]; then
        echo "취소되었습니다."
        exit 0
    elif [ -n "$opt" ]; then
        TARGET_FILE="$opt"
        break
    else
        echo "잘못된 선택입니다."
    fi
done

FULL_PATH="$TARGET_DIR/$TARGET_FILE"

# 3. 🚨 최종 확인 (가장 중요!)
echo -e "---------------------------------------"
echo -e "🚨 ${RED}경고: 이 작업은 되돌릴 수 없습니다!${RESET}"
echo -e "파일: ${YELLOW}$FULL_PATH${RESET}"
echo -e "---------------------------------------"
echo -n "정말 삭제하시겠습니까? (y/N) > "
read CONFIRM

if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
    # 실제 삭제 명령 (rm)
    rm "$FULL_PATH"
    
    # 삭제 성공 확인
    if [ ! -f "$FULL_PATH" ]; then
        echo -e "${GREEN}✅ 삭제되었습니다.${RESET}"
    else
        echo -e "${RED}❌ 삭제에 실패했습니다. (권한 문제 등)${RESET}"
    fi
else
    echo -e "${GREEN}🛡️  삭제를 취소했습니다.${RESET}"
fi