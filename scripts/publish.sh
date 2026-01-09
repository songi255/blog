#!/bin/bash

# ==========================================
# ⚙️ 설정
# ==========================================
DRAFTS_DIR="_drafts"

# 색상 코드
GREEN='\033[32m'
CYAN='\033[36m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'
# ==========================================

# 1. Jekyll Compose 설치 여부 확인 (권장)
if ! bundle info jekyll-compose &> /dev/null; then
    echo -e "${RED}❌ Error: 'jekyll-compose' 젬이 설치되어 있지 않습니다.${RESET}"
    echo "Gemfile에 'gem \"jekyll-compose\"'를 추가하고 'bundle install'을 실행하세요."
    exit 1
fi

# 2. _drafts 폴더 확인
if [ ! -d "$DRAFTS_DIR" ]; then
    echo -e "${RED}❌ Error: '$DRAFTS_DIR' 폴더가 없습니다.${RESET}"
    exit 1
fi

TARGET_FILE=""

# 3. 인자 처리 로직
if [ -n "$1" ]; then
    # 사용자가 파일명을 직접 입력한 경우
    if [ -f "$DRAFTS_DIR/$1" ]; then
        TARGET_FILE="$1"
    elif [ -f "$DRAFTS_DIR/$1.md" ]; then
        TARGET_FILE="$1.md"
    elif [ -f "$DRAFTS_DIR/$1.markdown" ]; then
        TARGET_FILE="$1.markdown"
    else
        echo -e "${RED}❌ 파일이 존재하지 않습니다: $1${RESET}"
        exit 1
    fi
else
    # 4. 인자가 없으면 대화형 메뉴(Select) 실행
    echo -e "${CYAN}💎 [Jekyll Compose] Publish 할 Draft를 선택하세요:${RESET}"
    
    shopt -s nullglob
    draft_files=("$DRAFTS_DIR"/*)
    shopt -u nullglob

    if [ ${#draft_files[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠️  작성된 Draft 파일이 없습니다.${RESET}"
        exit 0
    fi

    options=()
    for file in "${draft_files[@]}"; do
        options+=("$(basename "$file")")
    done

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
fi

# ==========================================
# 5. Jekyll Compose 실행
# ==========================================

echo -e "---------------------------------------"
echo -e "📄 선택된 파일: ${YELLOW}$TARGET_FILE${RESET}"
echo -e "🚀 Jekyll Compose Publish 실행 중..."
echo -e "---------------------------------------"

# 실제 명령어 실행 (bundle exec jekyll publish "_drafts/파일명")
# jekyll-compose는 경로를 포함한 파일명을 인자로 받습니다.
if bundle exec jekyll publish "$DRAFTS_DIR/$TARGET_FILE"; then
    echo -e ""
    echo -e "${GREEN}✅ 성공적으로 Publish 되었습니다!${RESET}"
    echo -e "   확인: _posts 폴더를 확인하세요."
else
    echo -e ""
    echo -e "${RED}❌ Publish 실패. 로그를 확인하세요.${RESET}"
    exit 1
fi