#!/bin/bash

# Exit on any error
set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status messages
log() {
    echo -e "${BLUE}🧹 $1${NC}"
}

# Function to print success messages
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to print error messages and exit
error() {
    echo -e "${RED}❌ Error: $1${NC}"
    exit 1
}

# Function to clean build artifacts
clean_build() {
    log "Cleaning build artifacts..."
    rm -rf .build/ || error "Failed to remove .build directory"
    rm -rf WaterTracker.app/ || error "Failed to remove WaterTracker.app"
    rm -rf *.xcodeproj/ || true  # xcodeproj might not exist
    rm -rf .swiftpm/ || true     # .swiftpm might not exist
    success "Build artifacts cleaned"
}

# Function to clean system files
clean_system_files() {
    log "Cleaning system files..."
    find . -name ".DS_Store" -delete 2>/dev/null || true
    find . -name "*.swp" -delete 2>/dev/null || true
    success "System files cleaned"
}

# Function to clean project-specific module cache
clean_module_cache() {
    log "Cleaning Swift module cache..."
    if [ -d ".build" ]; then
        rm -rf .build/*/debug/ModuleCache || true
        rm -rf .build/*/release/ModuleCache || true
    fi
    success "Module cache cleaned"
}

# Parse arguments
CLEAN_ALL=0
CLEAN_BUILD=0
CLEAN_TEMP=0
CLEAN_DERIVED=0

while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            CLEAN_ALL=1
            shift
            ;;
        --build)
            CLEAN_BUILD=1
            shift
            ;;
        --temp)
            CLEAN_TEMP=1
            shift
            ;;
        --derived)
            CLEAN_DERIVED=1
            shift
            ;;
        --help)
            echo "Usage: $0 [--all] [--build] [--temp] [--derived] [--help]"
            echo "  --all      Clean everything"
            echo "  --build    Clean build artifacts"
            echo "  --temp     Clean temporary files"
            echo "  --derived  Clean derived data"
            echo "  --help     Show this help message"
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            ;;
    esac
done

# If no specific option is provided, clean everything
if [ $CLEAN_ALL -eq 0 ] && [ $CLEAN_BUILD -eq 0 ] && [ $CLEAN_TEMP -eq 0 ] && [ $CLEAN_DERIVED -eq 0 ]; then
    CLEAN_ALL=1
fi

log "Starting cleanup process..."

# Perform cleaning based on options
if [ $CLEAN_ALL -eq 1 ] || [ $CLEAN_BUILD -eq 1 ]; then
    clean_build
fi

if [ $CLEAN_ALL -eq 1 ] || [ $CLEAN_TEMP -eq 1 ]; then
    clean_system_files
fi

if [ $CLEAN_ALL -eq 1 ] || [ $CLEAN_DERIVED -eq 1 ]; then
    clean_module_cache
fi

success "Project cleaned successfully! ✨" 