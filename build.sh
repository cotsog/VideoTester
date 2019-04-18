#!/bin/bash
security list-keychains -s ios-build.keychain
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles/
cp profile.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles
xcrun xcodebuild -workspace VideoTester.xcworkspace -scheme VideoTester  archive
xcrun xcodebuild -exportArchive -archivePath VideoTester.xcarchive \ -exportPath VideoTester.xcarchiven -exportOptionsPlist ExportOptions.plist


