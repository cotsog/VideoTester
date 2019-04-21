
#!/bin/bash
security list-keychains -s ios-build.keychain
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles/
cp profile.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/93XCQ4NWB8 
xcrun xcodebuild -workspace VideoTester.xcworkspace -scheme VideoTester  -archivePath VideoTester.xcarchive archive
xcrun xcodebuild -exportArchive -archivePath VideoTester.xcarchive  -exportPath  -exportOptionsPlist ExportOptions.plist
