#!/bin/sh
set -e

xctool -project "APING iOS SDK.xcodeproj" -scheme "APING iOS SDK" -sdk iphonesimulator test
