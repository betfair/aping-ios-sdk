#!/bin/sh
set -e

xctool -project "BNGAPI/BNGAPI.xcodeproj" -scheme "BNGAPI" -sdk iphonesimulator test
