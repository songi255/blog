#!/bin/bash

# ==========================================
# ⚙️ 설정 구간
# ==========================================
SCRIPT_FOLDER="./scripts"
EXCLUDE_LIST=("utils" "config" "common" "lib")
# ==========================================

CURRENT_DIR=$(pwd)
TARGET_DIR="$CURRENT_DIR/${SCRIPT_FOLDER}"

# 도움말 메시지를 저장할 변수
HELP_MSG=""
# 자동 완성을 위한 명령어 목록 배열 (Autocomplete용)
CMD_LIST=()

if [ ! -d "$TARGET_DIR" ]; then
    echo "⚠️  경고: '$SCRIPT_FOLDER' 폴더가 없습니다."
    return
fi

# ------------------------------------------
# 1. 스크립트 스캔 (도움말 및 목록 생성용)
# ------------------------------------------
for file in "$TARGET_DIR"/*; do
    [ -e "$file" ] || continue
    
    filename=$(basename "$file")
    cmd_name="${filename%.*}"

    # 제외 목록 확인
    skip=false
    for exclude in "${EXCLUDE_LIST[@]}"; do
        if [ "$cmd_name" == "$exclude" ]; then
            skip=true; break
        fi
    done
    if [ "$skip" == true ]; then continue; fi

    # 이제 alias를 등록하지 않고, 목록에만 추가합니다.
    CMD_LIST+=("$cmd_name")
    HELP_MSG+="\n  🔹 run $cmd_name \t : $filename 실행"
done

# ------------------------------------------
# 2. 메인 'run' 함수 정의
# ------------------------------------------
function run() {
    local cmd=$1
    local script_path="$TARGET_DIR/$cmd.sh"

    # 1) 입력이 없거나 'help'인 경우 도움말 출력
    if [[ -z "$cmd" || "$cmd" == "help" ]]; then
        echo "---------------------------------------"
        echo "🛠️  [Project] 실행 가능한 명령어 ('run <명령어>')"
        echo "---------------------------------------"
        echo -e "$HELP_MSG"
        echo ""
        return
    fi

    # 2) 제외 목록에 있는지 재확인 (보안/실수 방지)
    for exclude in "${EXCLUDE_LIST[@]}"; do
        if [ "$cmd" == "$exclude" ]; then
            echo "🚫 '$cmd'는 직접 실행할 수 없는 스크립트입니다."
            return 1
        fi
    done

    # 3) 실제 스크립트 파일 존재 여부 확인 및 실행
    if [ -f "$script_path" ]; then
        # $cmd를 제외한 나머지 인자("${@:2}")를 그대로 전달
        sh "$script_path" "${@:2}"
    else
        echo "❌ 알 수 없는 명령어입니다: $cmd"
        echo "ℹ️  'run help'를 입력하여 목록을 확인하세요."
    fi
}

# ------------------------------------------
# 3. 자동 완성 (Tab 키) 기능 추가 (꿀팁!)
# ------------------------------------------
# 사용자가 'run b' 치고 탭 누르면 'run build'가 되게 함
if command -v complete &> /dev/null; then
    complete -W "${CMD_LIST[*]}" run
fi

echo "🚀 환경 설정 로드 완료! 이제 'run <명령어>' 형태로 사용하세요."
# 로드 시 도움말 보여주기 (원하면 주석 해제)
# run help