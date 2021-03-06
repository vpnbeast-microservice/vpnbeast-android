#!/bin/bash

function gradlew() {
    ./gradlew "$1"
}

function post_release() {
    ./gradlew postRelease
}

function git_global_settings() {
    git config --global user.userName "${USERNAME}"
    git config --global user.email "${EMAIL}"
}

function set_release_version() {
    local version_minor
    version_minor=$(grep 'VERSION_MINOR' version.properties | awk -F '=' '{ print $2 }')
    local version_major
    version_major=$(grep 'VERSION_MAJOR' version.properties | awk -F '=' '{ print $2 }')
    local version_patch
    version_patch=$(grep 'VERSION_PATCH' version.properties | awk -F '=' '{ print $2 }')
    echo "${version_major}.${version_minor}.${version_patch}"
}

function git_commit_and_push() {
    git --no-pager diff
    git add --all
    git commit -am "[ci-skip] version ${RELEASE_VERSION}.RELEASE"
    git tag -a "${RELEASE_VERSION}.RELEASE" -m "v${RELEASE_VERSION} tagged"
    git status
    git push --follow-tags http://"${USERNAME}":"${GIT_ACCESS_TOKEN}"@gitlab.com/vpnbeast/android/vpnbeast-android.git HEAD:"${BRANCH}"
}

BRANCH=master
RELEASE_VERSION=$(set_release_version)
BUILD_METHOD=${1}
RELEASE_METHOD=${2}

gradlew "${BUILD_METHOD}"
gradlew "${RELEASE_METHOD}"
post_release
git_global_settings
git_commit_and_push