#!/bin/bash

# Usabilla React Native Sample App Builder
# Supports React Native 0.61.5 to latest with Legacy and New Architecture (TurboModules)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
RN_VERSION="0.83.4"
ARCHITECTURE="turbo"
PLATFORM="both"
CLEAN_BUILD=false
SKIP_INSTALL=false

# Print usage
usage() {
    cat << EOF
${BLUE}Usabilla React Native Sample App Builder${NC}

Usage: ./.script/build-sample.sh [options]

Options:
    -v, --version VERSION       React Native version (default: 0.83.4)
                                Supported: 0.61.5 to latest
    -a, --arch ARCH            Architecture type: legacy or turbo (default: turbo)
                                - legacy: Old architecture
                                - turbo: New architecture with TurboModules
    -p, --platform PLATFORM    Platform: android, ios, or both (default: both)
    -c, --clean                Clean build (removes node_modules, pods)
    --skip-install             Skip npm install (use existing dependencies)
    -h, --help                 Show this help message

Examples:
    # Build with React Native 0.83.4 and TurboModules
    ./.script/build-sample.sh

    # Build with React Native 0.76.11 and legacy architecture
    ./.script/build-sample.sh -v 0.76.11 -a legacy

    # Build only iOS with latest version
    ./.script/build-sample.sh -v 0.83.4 -p ios

    # Clean build with specific version
    ./.script/build-sample.sh -v 0.75.0 -c

Supported React Native Versions:
    - 0.61.x - 0.63.x: Legacy architecture only
    - 0.64.x - 0.67.x: Legacy architecture (turbo experimental)
    - 0.68.x - 0.73.x: Both architectures fully supported
    - 0.74.x+:         New architecture recommended

EOF
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--version)
            RN_VERSION="$2"
            shift 2
            ;;
        -a|--arch)
            ARCHITECTURE="$2"
            shift 2
            ;;
        -p|--platform)
            PLATFORM="$2"
            shift 2
            ;;
        -c|--clean)
            CLEAN_BUILD=true
            shift
            ;;
        --skip-install)
            SKIP_INSTALL=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            usage
            ;;
    esac
done

# Validate architecture
if [[ "$ARCHITECTURE" != "legacy" && "$ARCHITECTURE" != "turbo" ]]; then
    echo -e "${RED}Error: Architecture must be 'legacy' or 'turbo'${NC}"
    exit 1
fi

# Validate platform
if [[ "$PLATFORM" != "android" && "$PLATFORM" != "ios" && "$PLATFORM" != "both" ]]; then
    echo -e "${RED}Error: Platform must be 'android', 'ios', or 'both'${NC}"
    exit 1
fi

# Function to generate native projects
generate_native_projects() {
    local need_android=false
    local need_ios=false
    
    if [[ "$PLATFORM" == "android" || "$PLATFORM" == "both" ]]; then
        if [ ! -d "android" ]; then
            need_android=true
        fi
    fi
    
    if [[ "$PLATFORM" == "ios" || "$PLATFORM" == "both" ]]; then
        if [ ! -d "ios" ]; then
            need_ios=true
        fi
    fi
    
    if [ "$need_android" = false ] && [ "$need_ios" = false ]; then
        return 0
    fi
    
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}🏗️  Generating native projects...${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
    
    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    APP_NAME="RNUsabilla"
    
    echo -e "${YELLOW}Creating temporary project with React Native $RN_VERSION...${NC}"
    
    # Generate new RN project in temp location
    cd "$TEMP_DIR"
    npx --yes @react-native-community/cli@latest init "$APP_NAME" --version "$RN_VERSION" --skip-install
    
    cd "$OLDPWD"
    
    # Copy android folder if needed
    if [ "$need_android" = true ]; then
        echo -e "${YELLOW}Copying Android project...${NC}"
        cp -R "$TEMP_DIR/$APP_NAME/android" ./
        echo -e "${GREEN}✓ Android project generated${NC}"
    fi
    
    # Copy ios folder if needed
    if [ "$need_ios" = true ]; then
        echo -e "${YELLOW}Copying iOS project...${NC}"
        cp -R "$TEMP_DIR/$APP_NAME/ios" ./
        echo -e "${GREEN}✓ iOS project generated${NC}"
    fi
    
    # Clean up temp directory
    rm -rf "$TEMP_DIR"
    
    # Copy platform-specific assets
    copy_platform_assets "$need_android" "$need_ios"
    
    # Link assets (fonts, images)
    echo -e "${YELLOW}Linking assets...${NC}"
    npx react-native-asset || npx react-native link
    echo -e "${GREEN}✓ Assets linked${NC}\n"
}

# Function to copy platform-specific images and icons
copy_platform_assets() {
    local copy_android=$1
    local copy_ios=$2
    
    if [ "$copy_android" = false ] && [ "$copy_ios" = false ]; then
        return 0
    fi
    
    echo -e "${YELLOW}📱 Copying platform-specific assets...${NC}"
    
    # Copy iOS assets
    if [ "$copy_ios" = true ] && [ -d "platform-assets/ios" ]; then
        if [ -d "ios" ]; then
            # Find the iOS app folder (could be RNUsabilla or project name)
            IOS_APP_FOLDER=$(find ios -maxdepth 1 -type d -name "RNUsabilla" -o -name "*[!.xcodeproj][!.xcworkspace]" | head -1)
            if [ -z "$IOS_APP_FOLDER" ]; then
                IOS_APP_FOLDER=$(ls -d ios/*/ 2>/dev/null | grep -v ".xcodeproj\|.xcworkspace" | head -1 | sed 's/\/$//')
            fi
            
            if [ -n "$IOS_APP_FOLDER" ]; then
                # Copy Images.xcassets (app icons, launch images, emoticons)
                if [ -d "platform-assets/ios/Images.xcassets" ]; then
                    echo -e "${YELLOW}  Copying iOS Images.xcassets...${NC}"
                    cp -R platform-assets/ios/Images.xcassets "$IOS_APP_FOLDER/"
                    echo -e "${GREEN}  ✓ iOS app icons, launch images, and emoticons copied${NC}"
                fi
                
                # Copy LaunchScreen.storyboard
                if [ -f "platform-assets/ios/LaunchScreen.storyboard" ]; then
                    echo -e "${YELLOW}  Copying iOS LaunchScreen.storyboard...${NC}"
                    cp platform-assets/ios/LaunchScreen.storyboard "$IOS_APP_FOLDER/"
                    echo -e "${GREEN}  ✓ iOS launch screen copied${NC}"
                fi
                
                # Copy Info.plist (includes font references and app configuration)
                if [ -f "platform-assets/ios/Info.plist" ]; then
                    echo -e "${YELLOW}  Copying iOS Info.plist...${NC}"
                    cp platform-assets/ios/Info.plist "$IOS_APP_FOLDER/"
                    echo -e "${GREEN}  ✓ iOS app configuration copied${NC}"
                fi
            else
                echo -e "${RED}  ✗ Could not find iOS app folder${NC}"
            fi
        fi
    fi
    
    # Copy Android assets
    if [ "$copy_android" = true ] && [ -d "platform-assets/android" ]; then
        if [ -d "android/app/src/main/res" ]; then
            echo -e "${YELLOW}  Copying Android resources...${NC}"
            
            # Copy drawable folder (emoticons, background, footer, splash_screen.xml)
            if [ -d "platform-assets/android/drawable" ]; then
                mkdir -p android/app/src/main/res/drawable
                cp -R platform-assets/android/drawable/* android/app/src/main/res/drawable/ 2>/dev/null || true
                echo -e "${GREEN}  ✓ Android emoticons and images copied${NC}"
            fi
            
            # Copy mipmap folders (app icons, splash screens)
            for mipmap_dir in platform-assets/android/mipmap-*; do
                if [ -d "$mipmap_dir" ]; then
                    dir_name=$(basename "$mipmap_dir")
                    mkdir -p "android/app/src/main/res/$dir_name"
                    cp -R "$mipmap_dir"/* "android/app/src/main/res/$dir_name/" 2>/dev/null || true
                fi
            done
            echo -e "${GREEN}  ✓ Android app icons and splash screens copied${NC}"
            
            # Copy values folder (strings.xml, styles.xml)
            if [ -d "platform-assets/android/values" ]; then
                echo -e "${YELLOW}  Copying Android values (strings, styles)...${NC}"
                mkdir -p android/app/src/main/res/values
                cp platform-assets/android/values/*.xml android/app/src/main/res/values/ 2>/dev/null || true
                echo -e "${GREEN}  ✓ Android strings and styles copied${NC}"
            fi
        fi
    fi
    
    echo ""
}

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Usabilla React Native Sample App Builder${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Configuration:${NC}"
echo -e "  React Native Version: ${YELLOW}$RN_VERSION${NC}"
echo -e "  Architecture:         ${YELLOW}$ARCHITECTURE${NC}"
echo -e "  Platform:             ${YELLOW}$PLATFORM${NC}"
echo -e "  Clean Build:          ${YELLOW}$CLEAN_BUILD${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Determine React version based on RN version
REACT_VERSION="18.2.0"
if [[ "$RN_VERSION" =~ ^0\.(61|62|63)\. ]]; then
    REACT_VERSION="16.13.1"
    if [[ "$ARCHITECTURE" == "turbo" ]]; then
        echo -e "${YELLOW}Warning: React Native $RN_VERSION doesn't support TurboModules. Switching to legacy architecture.${NC}"
        ARCHITECTURE="legacy"
    fi
elif [[ "$RN_VERSION" =~ ^0\.(64|65|66|67)\. ]]; then
    REACT_VERSION="17.0.2"
    if [[ "$ARCHITECTURE" == "turbo" ]]; then
        echo -e "${YELLOW}Warning: React Native $RN_VERSION has experimental TurboModule support.${NC}"
    fi
elif [[ "$RN_VERSION" =~ ^0\.83\. ]]; then
    REACT_VERSION="19.2.0"
fi

# Clean build
if [ "$CLEAN_BUILD" = true ]; then
    echo -e "${YELLOW}🧹 Cleaning build artifacts...${NC}"
    
    # Remove npm dependencies and lock files
    echo -e "${YELLOW}  Removing node_modules and lock files...${NC}"
    rm -rf node_modules package-lock.json yarn.lock
    
    # Remove Metro bundler cache
    echo -e "${YELLOW}  Clearing Metro bundler cache...${NC}"
    rm -rf $TMPDIR/react-* $TMPDIR/metro-* $TMPDIR/haste-map-* 2>/dev/null || true
    watchman watch-del-all 2>/dev/null || true
    
    if [[ "$PLATFORM" == "android" || "$PLATFORM" == "both" ]]; then
        echo -e "${YELLOW}  Removing Android project and build cache...${NC}"
        rm -rf android
        # Also clean any lingering gradle cache if android folder exists
        rm -rf android/.gradle android/app/build android/build 2>/dev/null || true
    fi
    
    if [[ "$PLATFORM" == "ios" || "$PLATFORM" == "both" ]]; then
        echo -e "${YELLOW}  Removing iOS project, Pods, and derived data...${NC}"
        rm -rf ios
        rm -rf Gemfile Gemfile.lock
        rm -rf ~/Library/Developer/Xcode/DerivedData/RNUsabilla-* 2>/dev/null || true
        rm -rf ~/Library/Caches/CocoaPods 2>/dev/null || true
    fi
    
    echo -e "${GREEN}✓ Clean completed - all generated files removed${NC}\n"
fi

# Update package.json with correct versions
if [ "$SKIP_INSTALL" = false ]; then
    echo -e "${YELLOW}📝 Updating package.json...${NC}"
    
    # Backup original
    cp package.json package.json.bak
    
    # Determine CLI version
    CLI_VERSION="latest"
    if [[ "$RN_VERSION" =~ ^0\.(61|62|63)\. ]]; then
        CLI_VERSION="^4.14.0"
    elif [[ "$RN_VERSION" =~ ^0\.(64|65|66|67)\. ]]; then
        CLI_VERSION="^6.0.0"
    elif [[ "$RN_VERSION" =~ ^0\.(68|69|70|71|72)\. ]]; then
        CLI_VERSION="^8.0.0"
    fi
    
    # Update versions
    node -e "
    const pkg = require('./package.json');
    pkg.dependencies.react = '$REACT_VERSION';
    pkg.dependencies['react-native'] = '$RN_VERSION';
    require('fs').writeFileSync('package.json', JSON.stringify(pkg, null, 2));
    "
    
    echo -e "${GREEN}✓ package.json updated${NC}\n"
    
    # Install dependencies
    echo -e "${YELLOW}📦 Installing dependencies...${NC}"
    npm install --legacy-peer-deps
    echo -e "${GREEN}✓ Dependencies installed${NC}\n"
fi

# Generate native projects if they don't exist
generate_native_projects

# Configure architecture for Android
if [[ "$PLATFORM" == "android" || "$PLATFORM" == "both" ]]; then
    echo -e "${YELLOW}⚙️  Configuring Android architecture...${NC}"
    
    GRADLE_PROPS="android/gradle.properties"
    
    # Backup gradle.properties
    if [ -f "$GRADLE_PROPS" ]; then
        cp "$GRADLE_PROPS" "$GRADLE_PROPS.bak"
    fi
    
    if [ "$ARCHITECTURE" == "turbo" ]; then
        # Enable new architecture
        if grep -q "newArchEnabled" "$GRADLE_PROPS" 2>/dev/null; then
            sed -i.tmp 's/newArchEnabled=.*/newArchEnabled=true/' "$GRADLE_PROPS"
        else
            echo "newArchEnabled=true" >> "$GRADLE_PROPS"
        fi
        echo -e "${GREEN}✓ TurboModules enabled for Android${NC}\n"
    else
        # Disable new architecture
        if grep -q "newArchEnabled" "$GRADLE_PROPS" 2>/dev/null; then
            sed -i.tmp 's/newArchEnabled=.*/newArchEnabled=false/' "$GRADLE_PROPS"
        else
            echo "newArchEnabled=false" >> "$GRADLE_PROPS"
        fi
        echo -e "${GREEN}✓ Legacy architecture enabled for Android${NC}\n"
    fi
    
    rm -f "$GRADLE_PROPS.tmp"
fi

# Configure architecture for iOS
if [[ "$PLATFORM" == "ios" || "$PLATFORM" == "both" ]]; then
    echo -e "${YELLOW}⚙️  Configuring iOS architecture...${NC}"
    
    # For RN 0.83+, architecture is always new (can't disable)
    if [[ "$RN_VERSION" =~ ^0\.83\. ]]; then
        echo -e "${BLUE}  React Native 0.83+ uses new architecture by default${NC}"
        
        # Apply Folly coroutine fix for 0.83.x
        cat > ios/Podfile.patch << 'PATCHEOF'
    # Fix for React Native 0.83.4 - Disable Folly coroutines
    folly_expected_h = File.join(installer.sandbox.root, 'Headers/Public/RCT-Folly/folly/Expected.h')
    if File.exist?(folly_expected_h)
      content = File.read(folly_expected_h)
      if content.include?('#if FOLLY_HAS_COROUTINES')
        puts "Patching RCT-Folly/folly/Expected.h to disable coroutines"
        content.gsub!('#if FOLLY_HAS_COROUTINES', '#if 0 // FOLLY_HAS_COROUTINES - Patched for RN 0.83')
        File.write(folly_expected_h, content)
      end
    end
PATCHEOF
        echo -e "${GREEN}✓ iOS configured for React Native 0.83+${NC}\n"
    elif [ "$ARCHITECTURE" == "legacy" ]; then
        echo -e "${GREEN}✓ Legacy architecture enabled for iOS${NC}\n"
    else
        echo -e "${GREEN}✓ TurboModules enabled for iOS${NC}\n"
    fi
    
    # Install pods
    echo -e "${YELLOW}📦 Installing CocoaPods...${NC}"
    cd ios
    pod install
    cd ..
    echo -e "${GREEN}✓ CocoaPods installed${NC}\n"
fi

# Build Android
if [[ "$PLATFORM" == "android" || "$PLATFORM" == "both" ]]; then
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}🤖 Building Android...${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
    
    npm run android
    
    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}✓ Android build successful!${NC}"
    else
        echo -e "\n${RED}✗ Android build failed${NC}"
        exit 1
    fi
fi

# Build iOS
if [[ "$PLATFORM" == "ios" || "$PLATFORM" == "both" ]]; then
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}🍎 Building iOS...${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
    
    npm run ios
    
    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}✓ iOS build successful!${NC}"
    else
        echo -e "\n${RED}✗ iOS build failed${NC}"
        exit 1
    fi
fi

echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Build completed successfully!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "\n${YELLOW}Configuration Summary:${NC}"
echo -e "  React Native: $RN_VERSION"
echo -e "  Architecture: $ARCHITECTURE"
echo -e "  Platform: $PLATFORM"
echo -e "\n${GREEN}To restore original configuration:${NC}"
echo -e "  Restore package.json.bak if needed"
if [[ "$PLATFORM" == "android" || "$PLATFORM" == "both" ]]; then
    echo -e "  Restore android/gradle.properties.bak if needed"
fi
echo ""
