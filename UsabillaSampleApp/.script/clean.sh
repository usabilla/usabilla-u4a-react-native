#!/bin/bash

# Usabilla React Native Sample App - Clean Script
# Removes all generated files and caches

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  Usabilla React Native Sample App - Clean"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Function to safely remove directories
safe_remove() {
    local dir="$1"
    if [ -d "$dir" ] || [ -f "$dir" ]; then
        echo -e "${YELLOW}  Removing: $dir${NC}"
        rm -rf "$dir"
    fi
}

echo -e "${YELLOW}🧹 Cleaning all generated files and caches...${NC}"
echo ""

# npm dependencies and lock files
echo -e "${YELLOW}📦 Removing node_modules and lock files...${NC}"
safe_remove "node_modules"
safe_remove "package-lock.json"
safe_remove "yarn.lock"
safe_remove "package.json.bak"

# Metro bundler cache
echo ""
echo -e "${YELLOW}🚇 Clearing Metro bundler cache...${NC}"
rm -rf $TMPDIR/react-* $TMPDIR/metro-* $TMPDIR/haste-map-* 2>/dev/null || true
if command -v watchman &> /dev/null; then
    watchman watch-del-all 2>/dev/null || true
    echo -e "${GREEN}  ✓ Watchman cache cleared${NC}"
else
    echo -e "${YELLOW}  ⚠ Watchman not installed (skipping)${NC}"
fi

# Android
echo ""
echo -e "${YELLOW}🤖 Removing Android project and caches...${NC}"
safe_remove "android"
safe_remove "android/.gradle"
safe_remove "android/app/build"
safe_remove "android/build"
safe_remove "$HOME/.gradle/caches" 2>/dev/null || true

# iOS
echo ""
echo -e "${YELLOW}🍎 Removing iOS project, Pods, and derived data...${NC}"
safe_remove "ios"
safe_remove "Gemfile"
safe_remove "Gemfile.lock"
rm -rf ~/Library/Developer/Xcode/DerivedData/RNUsabilla-* 2>/dev/null || true
echo -e "${GREEN}  ✓ Xcode derived data cleared${NC}"
rm -rf ~/Library/Caches/CocoaPods 2>/dev/null || true
echo -e "${GREEN}  ✓ CocoaPods cache cleared${NC}"

# Build artifacts
echo ""
echo -e "${YELLOW}🔨 Removing build artifacts...${NC}"
safe_remove ".metro-health-check*"

echo ""
echo "═══════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ Clean completed successfully!${NC}"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "All generated files have been removed. The repository is now clean."
echo "Run './.script/build-sample.sh' to regenerate and build the app."
echo ""
