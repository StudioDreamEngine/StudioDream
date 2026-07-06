#!/usr/bin/env bash

COMPILED="./compiled"
DIST="../dist"

python3 compile.py

chmod +x appimagetool.AppImage

# Create the love archive
echo Creating build...
cd $COMPILED
zip -9 -r ../StudioDream.love . -x "./CLibraries/*"
cd $OLDPWD

# We need to make sure the appimage is executable
./love.AppImage --appimage-extract

SQUASH_ROOT="./squashfs-root"
LIBRARIES="$SQUASH_ROOT/lib/studio-dream/"
EXTERNAL="$SQUASH_ROOT/share/studio-dream/"

# Setup appimage
cp AppRun "$SQUASH_ROOT/AppRun"
cp love.desktop "$SQUASH_ROOT/love.desktop"
cp -r "./Studio.png" "$SQUASH_ROOT/Studio.png"

# Setup executable
cat "$SQUASH_ROOT/bin/love" StudioDream.love > "$SQUASH_ROOT/bin/StudioDream"
chmod +x "$SQUASH_ROOT/bin/StudioDream"

# Setup dependencies
mkdir $LIBRARIES
cp -r "$COMPILED/CLibraries/linux/." $LIBRARIES

# Cleanup
rm "$SQUASH_ROOT/love.svg"
rm "StudioDream.love"

# Build appimage
echo Building AppImage..
./appimagetool.AppImage $SQUASH_ROOT "$DIST/StudioDream-Linux.AppImage"

echo
echo Done! Built AppImage is within dist