#!/bin/bash

# Get the latest tag if available
latest_tag=$(git describe --tags --abbrev=0 2>/dev/null)
if [ -z "$latest_tag" ]; then
    latest_tag="0.0.0"
fi

# Parse the version
major=$(echo $latest_tag | cut -d. -f1)
minor=$(echo $latest_tag | cut -d. -f2)
patch=$(echo $latest_tag | cut -d. -f3)

# Parse commit messages and determine the type of change
while read -r line; do
    case $line in
        *major*) ((major++)); minor=0; patch=0 ;;
        *minor*) ((minor++)); patch=0 ;;
        *patch*) ((patch++)) ;;
    esac
done < <(git log --pretty=%s origin/master..HEAD)

# If no specific version bump is indicated, default to patch
if [[ $major == $latest_tag && $minor == $latest_tag && $patch == $latest_tag ]]; then
    ((patch++))
fi

# Update the version number
new_version="$major.$minor.$patch"

# Create a new tag on GitHub
git tag -a "$new_version" -m "Version $new_version"
git push origin "$new_version"
