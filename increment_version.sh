#!/bin/bash

# Get the latest version from the repository
latest_version=$(git describe --abbrev=0 --tags)

# Extract the major, minor, and patch versions
IFS='.' read -r -a version_parts <<< "$latest_version"
major="${version_parts[0]}"
minor="${version_parts[1]}"
patch="${version_parts[2]}"

# Determine the commit message and increment version accordingly
commit_message=$(git log --format=%B -n 1 HEAD)
if [[ $commit_message == *"fix"* ]]; then
  patch=$((patch + 1))
elif [[ $commit_message == *"feature"* ]]; then
  minor=$((minor + 1))
else
  echo "No keyword found, not incrementing version."
  exit 0
fi

# Construct the new version string
new_version="$major.$minor.$patch"

echo $new_version
