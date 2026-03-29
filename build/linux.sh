#!/usr/bin/env bash

COMPILED="../src"
DIST="../dist/linux"

# Create the love archive
cd $COMPILED
zip -9 -r ../build/Galvanic-Webinary.love . -x "./CLibraries/*"
cd ../build

# We need to make sure the appimage is executable
./love.AppImage --appimage-extract

SQUASH_ROOT="./squashfs-root"
LIBRARIES="$SQUASH_ROOT/lib/galvanic/"
EXTERNAL="$SQUASH_ROOT/share/galvanic/"

# Setup appimage
cp AppRun "$SQUASH_ROOT/AppRun"
cp love.desktop "$SQUASH_ROOT/love.desktop"
cp -r "./galvanic.png" "$SQUASH_ROOT/galvanic.png"

# Setup executable
cat "$SQUASH_ROOT/bin/love" Galvanic-Webinary.love > "$SQUASH_ROOT/bin/Galvanic-Webinary"
chmod +x "$SQUASH_ROOT/bin/Galvanic-Webinary"

# Setup dependencies
mkdir $LIBRARIES
cp -r "$COMPILED/CLibraries/linux/." $LIBRARIES

# Cleanup
rm "$SQUASH_ROOT/love.svg"
rm "Galvanic-Webinary.love"

# Build appimage
./appimagetool.AppImage $SQUASH_ROOT "$DIST/GalvanicWebinary.AppImage"