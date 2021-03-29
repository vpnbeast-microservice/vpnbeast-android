#!/bin/bash

function gradlew() {
    ./gradlew "$1"
}

function post_release() {
    ./gradlew postRelease
}

function git_global_settings() {
    git config --global user.name "${USERNAME}"
    git config --global user.email "${EMAIL}"
}

function get_release_version() {
    local version_major, version_minor, version_patch
    version_minor=$(grep 'VERSION_MINOR' version.properties | awk -F '=' '{ print $2 }')
    version_major=$(grep 'VERSION_MAJOR' version.properties | awk -F '=' '{ print $2 }')
    version_patch=$(grep 'VERSION_PATCH' version.properties | awk -F '=' '{ print $2 }')
    echo "${version_major}.${version_minor}.${version_patch}"
}

function git_commit_and_push() {
    git --no-pager diff
    git add --all
    git commit -am "[ci-skip] version v${RELEASE_VERSION} released"
    git tag -a "v${RELEASE_VERSION}" -m "v${RELEASE_VERSION} tagged"
    git status
    git push --follow-tags "${PUSH_URL}" HEAD:"${BRANCH}"
}

PROJECT_NAME=vpnbeast-android
USERNAME=vpnbeast-ci
EMAIL=info@thevpnbeast.com
BRANCH=master
RELEASE_VERSION=$(get_release_version)
BUILD_METHOD=${1}
RELEASE_METHOD=${2}
GIT_ACCESS_TOKEN=${3}
PUSH_URL=https://${USERNAME}:${GIT_ACCESS_TOKEN}@github.com/vpnbeast/${PROJECT_NAME}.git

gradlew "${BUILD_METHOD}"
gradlew "${RELEASE_METHOD}"
post_release
git_global_settings
git_commit_and_push