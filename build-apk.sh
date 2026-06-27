#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Android Screen Mirror - APK Builder${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "settings.gradle.kts" ]; then
    echo -e "${RED}❌ Error: settings.gradle.kts not found${NC}"
    echo -e "${YELLOW}Please run this script from the project root directory${NC}"
    exit 1
fi

# Download gradle wrapper if not exists
if [ ! -f "gradle/wrapper/gradle-wrapper.jar" ]; then
    echo -e "${BLUE}📥 Downloading Gradle wrapper...${NC}"
    mkdir -p gradle/wrapper
    cd gradle/wrapper
    curl -L -o gradle-wrapper.jar https://github.com/gradle/gradle/releases/download/v8.0.0/gradle-8.0-wrapper.jar
    cd ../..
    if [ ! -f "gradle/wrapper/gradle-wrapper.jar" ]; then
        echo -e "${RED}❌ Failed to download gradle-wrapper.jar${NC}"
        exit 1
    fi
fi

echo -e "${BLUE}Select build type:${NC}"
echo "1) Debug APK (faster, for testing)"
echo "2) Release APK (optimized, signed)"
read -p "Enter choice (1 or 2): " choice

case $choice in
    1)
        echo -e "${BLUE}🔨 Building Debug APK...${NC}"
        chmod +x ./gradlew
        ./gradlew clean assembleDebug --build-cache
        if [ $? -eq 0 ]; then
            echo ""
            echo -e "${GREEN}✅ Debug APK built successfully!${NC}"
            echo -e "${GREEN}📍 Location: app/build/outputs/apk/debug/app-debug.apk${NC}"
            echo ""
            echo -e "${YELLOW}💡 Install with:${NC}"
            echo "   adb install app/build/outputs/apk/debug/app-debug.apk"
            echo ""
        else
            echo -e "${RED}❌ Build failed${NC}"
            exit 1
        fi
        ;;
    2)
        echo -e "${BLUE}🔨 Building Release APK...${NC}"
        echo -e "${YELLOW}⚠️  Note: Release builds require a keystore${NC}"
        echo ""
        chmod +x ./gradlew
        ./gradlew clean assembleRelease --build-cache
        if [ $? -eq 0 ]; then
            echo ""
            echo -e "${GREEN}✅ Release APK built successfully!${NC}"
            echo -e "${GREEN}📍 Location: app/build/outputs/apk/release/app-release.apk${NC}"
            echo ""
        else
            echo -e "${RED}❌ Build failed${NC}"
            exit 1
        fi
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}✨ Done!${NC}"
