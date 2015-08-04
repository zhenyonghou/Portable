# xcode-build-bump.sh
# @desc Auto-increment Xcode target build number every time the project is archived
# @src stackoverflow.com/a/15483906
# @usage
# 1. Select: your Target in Xcode
# 2. Select: Build Phases Tab
# 3. Select: Add Build Phase -> Add Run Script
# 4. Paste code below in to new "Run Script" section
# 5. Drag the "Run Script" below "Link Binaries With Libraries"
# 6. Insure that your starting build number is set to a whole integer and not a float (e.g. 1, not 1.0)

if [ "Release" != "${CONFIGURATION}" ]
then
    exit 0
fi

buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
buildNumber=$(($buildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFOPLIST_FILE"