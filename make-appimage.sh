#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q quickgui | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/quickgui.png
export DESKTOP=/usr/share/applications/quickgui.desktop

# Deploy dependencies
quick-sharun \
	/usr/share/quickgui/quickgui \
	/usr/bin/quickemu            \
	/usr/bin/quickget            \
	/usr/bin/quickreport         \
	/usr/bin/bash

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
