#!/bin/bash
set -e

# 1. Build site
echo "🔨 Building site..."
JEKYLL_ENV=production bundle exec jekyll build

# 2. Initialize _site as git repository if it's not (runs only once)
if [ ! -d "_site/.git" ]; then
    echo "⚙️ Initializing _site as a tracking branch..."
    cd _site
    git init
    git remote add origin $(git -C .. remote get-url origin)
    git checkout -b gh-pages
    cd ..
fi

# 3. Deploy
cd _site
git fetch origin gh-pages
git reset --soft origin/gh-pages # Synchronize with remote state

git add -A
# Commit and push only if there are changes
if ! git diff-index --quiet HEAD; then
    echo "📤 Pushing changes..."
    git commit -m "Update content: $(date)"
    git push origin gh-pages
else
    echo "✨ No changes to deploy."
fi

cd ..