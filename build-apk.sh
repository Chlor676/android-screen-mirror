#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Android - APK Builder${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "settings.gradle.kts" ]; then
    echo -e "${RED}❌ Error: Not in project root directory${NC}"
    exit 1
fi

# Check Java installation
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Java is not installed${NC}"
    exit 1
fi

echo -e "${BLUE}Select build type:${NC}"
echo "1) Debug APK (faster, for testing)"
echo "2) Release APK (optimized, signed)"
read -p "Enter choice (1 or 2): " choice

case $choice in
    1)
        echo -e "${BLUE}🔨 Building Debug APK...${NC}"
        chmod +x ./gradlew
        ./gradlew clean assembleDebug
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
            echo -e "${YELLOW}Trying alternative approach...${NC}"
            echo "Run: java -cp gradle/wrapper/gradle-wrapper.jar org.gradle.wrapper.GradleWrapperMain assembleDebug"
            exit 1
        fi
        ;;
    2)
        echo -e "${BLUE}🔨 Building Release APK...${NC}"
        chmod +x ./gradlew
        ./gradlew clean assembleRelease
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
