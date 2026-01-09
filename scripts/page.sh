#!/bin/bash

# ==========================================
# 📄 새 페이지(Page) 생성 스크립트
# ==========================================

GREEN='\033[32m'
CYAN='\033[36m'
YELLOW='\033[33m'
RESET='\033[0m'

echo -e "${CYAN}📄 [Page] 새 페이지를 생성합니다.${RESET}"
echo "생성할 페이지의 제목(Title)을 입력하세요."
echo -e "${YELLOW}(예: About, Contact, My Project)${RESET}"

# 1. 제목 입력
echo -n "Title > "
read TITLE

if [ -z "$TITLE" ]; then
    echo "취소되었습니다."
    exit 0
fi

# 2. Jekyll Compose Page 실행
echo -e "---------------------------------------"
echo -e "🚀 '$TITLE' 페이지 생성 중..."

# bundle exec jekyll page "제목"
if bundle exec jekyll page "$TITLE"; then
    echo -e "${GREEN}✅ 생성 완료!${RESET}"
    echo -e "   루트 디렉토리(또는 설정된 경로)를 확인하세요."
else
    echo -e "${RED}❌ 실패했습니다.${RESET}"
    exit 1
fi