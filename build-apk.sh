#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Android Screen Mirror - APK Builder${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if gradlew exists
if [ ! -f "gradlew" ]; then
    echo -e "${YELLOW}⚠️  Gradle wrapper not found. Creating...${NC}"
    chmod +x gradlew
fi

echo -e "${BLUE}Select build type:${NC}"
echo "1) Debug APK (faster, for testing)"
echo "2) Release APK (optimized, signed)"
read -p "Enter choice (1 or 2): " choice

case $choice in
    1)
        echo -e "${BLUE}Building Debug APK...${NC}"
        chmod +x ./gradlew
        ./gradlew clean assembleDebug
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Debug APK built successfully!${NC}"
            echo -e "${GREEN}📍 Location: app/build/outputs/apk/debug/app-debug.apk${NC}"
            echo -e "${YELLOW}💡 Install with: adb install app/build/outputs/apk/debug/app-debug.apk${NC}"
        else
            echo -e "${YELLOW}❌ Build failed. Check errors above.${NC}"
            exit 1
        fi
        ;;
    2)
        echo -e "${BLUE}Building Release APK...${NC}"
        echo -e "${YELLOW}⚠️  Ensure keystore.jks exists in project root${NC}"
        chmod +x ./gradlew
        ./gradlew clean assembleRelease
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Release APK built successfully!${NC}"
            echo -e "${GREEN}📍 Location: app/build/outputs/apk/release/app-release.apk${NC}"
        else
            echo -e "${YELLOW}❌ Build failed. Check errors above.${NC}"
            exit 1
        fi
        ;;
    *)
        echo -e "${YELLOW}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✨ Done!${NC}"
