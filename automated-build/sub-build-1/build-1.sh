#!/usr/bin/env bash
set -eux


WORK_DIR="/root/cling-build"
SRC_DIR="${WORK_DIR}/src"
BUILD_DIR="${WORK_DIR}/build"

INSTALL_DIR="/opt/cling"
COMMIT_SHA1="/opt/cling/CLING_COMMIT_SHA1"


function install_dependencies() {
    apt-get -qq  update
    apt-get -qqy install build-essential git cmake python
}

function clone_fast() {  # clone <repo_name> <branch> <dir>
    git clone --depth 1 "http://root.cern.ch/git/${1}.git" --branch "${2}" "${3}" >/dev/null
}

function get_sources() {
    clone_fast llvm  cling-patches "${SRC_DIR}"
    clone_fast clang cling-patches "${SRC_DIR}/tools/clang"
    clone_fast cling master        "${SRC_DIR}/tools/cling"
}

function build() {
    mkdir -p "${BUILD_DIR}"
    cd "${BUILD_DIR}"
    cmake -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" -DPYTHON_EXECUTABLE=$(which python) "${SRC_DIR}"

    make --jobs=$(nproc) llvm-lto
}

function main() {
    mkdir -p "${WORK_DIR}"

    install_dependencies
    get_sources
    build
}


main
