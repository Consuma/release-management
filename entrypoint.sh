#!/bin/bash

set -e
echo "Starting release management"
TYPE_OF_RELEASE=$INPUT_TYPEOFRELEASE

git config --global --add safe.directory /github/workspace
git config --global user.email "github-actions[bot]@users.noreply.github.com"
git config --global user.name "github-actions[bot]"

# Collect version if type of release is custom
if [ "$TYPE_OF_RELEASE" = "custom" ]; then
    VERSION=$INPUT_VERSION
else
    LATEST_VERSION=$(git describe --abbrev=0 --tags)
    IFS='.' read -ra VERSION_ARRAY <<< "$LATEST_VERSION"
    if [ "$TYPE_OF_RELEASE" = "major" ]; then
        VERSION_ARRAY[0]=$((${VERSION_ARRAY[0]}+1))
        VERSION_ARRAY[1]=0
        VERSION_ARRAY[2]=0
    elif [ "$TYPE_OF_RELEASE" = "minor" ]; then
        VERSION_ARRAY[1]=$((${VERSION_ARRAY[1]}+1))
        VERSION_ARRAY[2]=0
    elif [ "$TYPE_OF_RELEASE" = "patch" ]; then
        VERSION_ARRAY[2]=$((${VERSION_ARRAY[2]}+1))
    fi
    VERSION=$(IFS=. ; echo "${VERSION_ARRAY[*]}")
fi
echo "Version: $VERSION"
git tag -a $VERSION -m "Release $INPUT_RELEASENOTES"
git push origin $VERSION

curl -sS \
    -X POST \
    -H "Authorization:Bearer $INPUT_GITHUBTOKEN" \
    -H "Accept:application/vnd.github.v3+json" \
    https://api.github.com/repos/$GITHUB_REPOSITORY/releases \
    -d '{
        "tag_name": "'"$VERSION"'",
        "name": "v'"$VERSION"'",
        "body": "'"$INPUT_RELEASENOTES"'",
        "draft": '$INPUT_RELEASEDRAFT',
        "prerelease": '$INPUT_PRERELEASE',
        "target_commitish": "'"$INPUT_TARGETCOMMITISH"'",
        "generate_release_notes": '$INPUT_GENERATERELEASENOTES'
    }'

echo "Release management completed"
