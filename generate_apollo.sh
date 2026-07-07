#!/bin/bash

# ==============================================================================
# Apollo GraphQL Code Generation Script
# ==============================================================================
# This script wraps the apollo-ios-cli generate command to prevent failures
# caused by Xcode's newer Package.resolved (v3) format. Apollo CLI v1.0.7 
# does not support v3, which causes the "Package.resolve file version unsupported!" error.
# 
# This script temporarily hides the Xcode Package.resolved file, runs the 
# generator, and restores the file to ensure a clean build environment for all
# team members regardless of their Xcode version.
# ==============================================================================

# Define paths
XCODE_SHARED_DATA="TrueFit.xcodeproj/project.xcworkspace/xcshareddata"
BACKUP_DIR="xcshareddata_bak"

echo "🚀 Starting Apollo Code Generation..."

# 1. Hide the Xcode Package.resolved if it exists
if [ -d "$XCODE_SHARED_DATA" ]; then
    echo "📦 Temporarily hiding Xcode Package.resolved to avoid version conflicts..."
    mv "$XCODE_SHARED_DATA" "$BACKUP_DIR"
fi

# 2. Run the Apollo CLI generator
echo "⚙️ Running apollo-ios-cli generate..."
./apollo-ios-cli generate

# Capture the exit code of the generator
GENERATE_RESULT=$?

# 3. Restore the Xcode Package.resolved
if [ -d "$BACKUP_DIR" ]; then
    echo "📦 Restoring Xcode Package.resolved..."
    mv "$BACKUP_DIR" "$XCODE_SHARED_DATA"
fi

# 4. Handle success/failure
if [ $GENERATE_RESULT -eq 0 ]; then
    echo "✅ Apollo GraphQL generation completed successfully!"
else
    echo "❌ Apollo GraphQL generation failed with exit code $GENERATE_RESULT."
    exit $GENERATE_RESULT
fi
