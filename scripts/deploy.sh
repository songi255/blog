#!/bin/bash
set -e

# 1. 빌드 실행
echo "🔨 Building site..."
bundle exec jekyll build

# 2. _site 폴더가 git 저장소가 아니라면 초기 설정 (처음 한 번만 실행됨)
if [ ! -d "_site/.git" ]; then
    echo "⚙️ Initializing _site as a tracking branch..."
    cd _site
    git init
    git remote add origin $(git -C .. remote get-url origin)
    git checkout -b gh-pages
    cd ..
fi

# 3. 배포 진행
cd _site
git fetch origin gh-pages
git reset --soft origin/gh-pages # 원격 상태와 동기화

git add -A
# 변경사항이 있을 때만 커밋 및 푸시
if ! git diff-index --quiet HEAD; then
    echo "📤 Pushing changes..."
    git commit -m "Update content: $(date)"
    git push origin gh-pages
else
    echo "✨ No changes to deploy."
fi

cd ..