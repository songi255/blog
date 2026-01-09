#!/bin/bash

# ==========================================
# 📝 새 초안(Draft) 생성 스크립트
# ==========================================

GREEN='\033[32m'
RESET='\033[0m'

# 제목 입력 받기 (인자가 없으면 물어봄)
if [ -z "$1" ]; then
    echo -n "📝 새 글의 제목을 입력하세요: "
    read TITLE
else
    TITLE="$*"
fi

if [ -z "$TITLE" ]; then
    echo "취소되었습니다."
    exit 0
fi

echo "🚀 '$TITLE' 초안 생성 중..."

# Jekyll Compose 실행
bundle exec jekyll draft "$TITLE"

echo -e "${GREEN}✅ 생성 완료! _drafts 폴더를 확인하세요.${RESET}"