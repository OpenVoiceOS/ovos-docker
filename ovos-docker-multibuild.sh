#!/usr/bin/env bash
# -------------------------------------------------------------------------------
# ovos-docker-multibuild.sh
#
# Description:
#   This script builds and pushes multi-architecture Docker images for multiple
#   OVOS (Open Voice OS) containers, GUIs and skills across three channels: stable,
#   testing, and alpha. It uses Docker Buildx to target both amd64 and arm64
#   platforms, tags each image with both the channel and 'latest', and pushes them
#   to the specified container registry.
#
#   The list of containers and skills is managed via Bash arrays.
#
# Usage:
#   ./ovos-docker-multibuild.sh
#
# Requirements:
#   - Docker with Buildx support
#   - Network connectivity to the target container registry
#
# Author:      Gaëtan Trellu
# -------------------------------------------------------------------------------

set -Eeuo pipefail

readonly REGISTRY="docker.io/smartgic"
readonly PLATFORM="linux/amd64,linux/arm64"
readonly CONTAINERS=(
  base sound-base audio cli core gui-websocket listener messagebus phal phal-admin plugin-ggwave 
)
readonly GUIS=(
  gui-original gui-shell
)
readonly SKILLS=(
  skill-date-time skill-duckduckgo skill-easter-eggs
  skill-fallback-unknown skill-ggwave skill-hello-world skill-homescreen
  skill-jokes skill-parrot skill-personal skill-randomness skill-volume skill-weather
  skill-wikihow skill-wikipedia skill-wolfie skill-wordnet
)

build_image() {
  local path="$1"
  local name="$2"
  local tag="$3"
  local channel="$4"
  local version="$5"
  local build_date="$6"

  echo "Building: ${REGISTRY}/ovos-${name}:${tag}" >&2
  docker buildx build \
    --network host \
    "$path" \
    -t "${REGISTRY}/ovos-${name}:${tag}" \
    -t "${REGISTRY}/ovos-${name}:latest" \
    --platform="${PLATFORM}" \
    --build-arg "TAG=${tag}" \
    --build-arg "CHANNEL=${channel}" \
    --build-arg "BUILD_DATE=${build_date}" \
    --build-arg "VERSION=${version}" \
    --no-cache \
    --push
}

main() {
  for channel in stable testing alpha; do
    local tag="${channel}"
    local version="${channel}"
    local build_date
    build_date="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"

    for container in "${CONTAINERS[@]}"; do
      build_image "$container" "$container" "$tag" "$channel" "$version" "$build_date"
    done
  
    for gui in "${GUIS[@]}"; do
      build_image "gui/${gui}" "$gui" "$tag" "$channel" "$version" "$build_date"
    done

    for skill in "${SKILLS[@]}"; do
      build_image "skills/${skill}" "$skill" "$tag" "$channel" "$version" "$build_date"
    done
  done
}

main "$@"

