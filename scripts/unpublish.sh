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
    echo -e "${RED}❌ Error: '$POSTS_DIR' 폴더가 없습니다.${RESET}"
    exit 1
fi

echo -e "${CYAN}🔙 [Unpublish] Draft로 되돌릴 글을 선택하세요:${RESET}"

# 1. Post 목록 가져오기 (최신순 정렬)
# ls -r (reverse)로 최신 글이 목록의 맨 뒤(또는 앞)에 오도록 조정 가능하지만,
# 기본적으로 날짜 이름순이므로 그냥 읽어옵니다.
shopt -s nullglob
post_files=("$POSTS_DIR"/*)
shopt -u nullglob

if [ ${#post_files[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠️  발행된 글(Post)이 없습니다.${RESET}"
    exit 0
fi

# 2. 파일명만 추출하여 선택지 만들기
options=()
for file in "${post_files[@]}"; do
    options+=("$(basename "$file")")
done

TARGET_FILE=""
PS3="번호를 선택하세요 (취소: q): "

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

# 3. Jekyll Unpublish 실행
echo -e "---------------------------------------"
echo -e "📄 선택된 파일: ${YELLOW}$TARGET_FILE${RESET}"
echo -e "🔙 Draft로 이동 중..."
echo -e "---------------------------------------"

if bundle exec jekyll unpublish "$POSTS_DIR/$TARGET_FILE"; then
    echo -e "${GREEN}✅ Unpublish 완료! _drafts 폴더를 확인하세요.${RESET}"
else
    echo -e "${RED}❌ 실패했습니다.${RESET}"
    exit 1
fi