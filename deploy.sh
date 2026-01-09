#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🚀 Starting deployment..."

# 1. Clean up old build and run a fresh build
echo "🔨 Building the site..."
rm -rf _site
bundle exec jekyll build

# 2. Navigate into the output directory
cd _site

# 3. Initialize a temporary git repo and commit the results
echo "📦 Preparing the gh-pages branch..."
git init
git add .
git commit -m "Deploy update: $(date)"

# 4. Push to the gh-pages branch
# This automatically gets your remote URL from the parent directory
REMOTE_REPO=$(git -C .. remote get-url origin)
echo "📤 Pushing to GitHub..."
git push -f "$REMOTE_REPO" main:gh-pages

echo "✅ Deployment complete! Your site should be live in a few minutes."