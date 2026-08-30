#!/usr/bin/env bash
set -euo pipefail

# Defaults (override via flags or env)
REGISTRY="${REGISTRY:-docker.io/smartgic}"
TAG="${TAG:-alpha}"
LATEST_TAG="${LATEST_TAG:-latest}"
VERSION="${VERSION:-$TAG}"
CHANNEL="${CHANNEL:-alpha}"
UV_PRERELEASE="${UV_PRERELEASE:-allow}"
OVOS_RELEASES_REF="${OVOS_RELEASES_REF:-main}" # git ref of OpenVoiceOS/ovos-releases for constraints-${CHANNEL}.txt
CACHE_REPO="${CACHE_REPO:-ghcr.io/openvoiceos/ovos-docker-cache}" # build cache on GHCR (read anonymously)
CACHE_TO="${CACHE_TO:-}"           # "max" to also export the cache (needs GHCR write access; CI does this)
MIRROR_REGISTRY="${MIRROR_REGISTRY:-}" # optional second registry to push to (CI: ghcr.io/openvoiceos)
PLATFORMS="${PLATFORMS:-linux/amd64,linux/arm64}"
TARGETS="${TARGETS:-default}"   # can be "stack services skills guis" or individual targets
PUSH="${PUSH:-true}"            # true -> --push
LOAD="${LOAD:-false}"           # true -> --load (local), forces amd64
CACHE_FROM="${CACHE_FROM:-true}" # true -> use registry cache-from
ENSURE_BINFMT="${ENSURE_BINFMT:-auto}" # auto|true|false
BUILDER_SPECIFIED="false"
if [[ -n "${BUILDER+x}" ]]; then
  BUILDER_SPECIFIED="true"
fi
BUILDER="${BUILDER:-ovos-bake}" # buildx builder name to use for multi-arch builds
BUILDER_ARG=()

usage() {
  cat <<EOF
Usage: $0 [options]

Options:
  -r, --registry REGISTRY     Registry (default: $REGISTRY)
  -t, --tag TAG               Tag (default: $TAG)
  --latest-tag TAG            Additional tag (default: latest; only used when TAG=stable)
  -v, --version VERSION       Version label (default: $VERSION)
  -c, --channel CHANNEL       OVOS channel (default: $CHANNEL)
  --ovos-releases-ref REF     ovos-releases git ref for the constraints file (default: $OVOS_RELEASES_REF)
  --cache-to MODE             Export build cache to \$CACHE_REPO (min|max; default: off)
  -p, --platforms PLATFORMS   CSV platforms (default: $PLATFORMS)
  -T, --targets TARGETS       Bake targets: default|stack|services|skills|guis|<target> (default: $TARGETS)
  --no-cache-from             Disable cache-from (useful if registry cache is unavailable)
  --no-push                   Build without pushing
  --load                      Build for local use (loads into docker)
  --ensure-binfmt             Force binfmt/qemu installation for cross-arch builds
  --no-binfmt                 Skip binfmt/qemu installation
  --builder NAME              Buildx builder name (default: $BUILDER)
  -h, --help                  Show this help
EOF
}

# Parse flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--registry) REGISTRY="$2"; shift 2 ;;
    -t|--tag) TAG="$2"; shift 2 ;;
    --latest-tag) LATEST_TAG="$2"; shift 2 ;;
    -v|--version) VERSION="$2"; shift 2 ;;
    -c|--channel) CHANNEL="$2"; shift 2 ;;
    --ovos-releases-ref) OVOS_RELEASES_REF="$2"; shift 2 ;;
    --cache-to) CACHE_TO="$2"; shift 2 ;;
    -p|--platforms) PLATFORMS="$2"; shift 2 ;;
    -T|--targets) TARGETS="$2"; shift 2 ;;
    --no-cache-from) CACHE_FROM="false"; shift ;;
    --no-push) PUSH="false"; shift ;;
    --load) LOAD="true"; shift ;;
    --ensure-binfmt) ENSURE_BINFMT="true"; shift ;;
    --no-binfmt) ENSURE_BINFMT="false"; shift ;;
    --builder) BUILDER="$2"; BUILDER_SPECIFIED="true"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1"; usage; exit 1 ;;
  esac
done

# Preflight
command -v docker >/dev/null || { echo "docker not found"; exit 1; }
docker buildx version >/dev/null || { echo "docker buildx not available"; exit 1; }

normalize_arch() {
  case "$1" in
    x86_64|amd64) echo "amd64" ;;
    aarch64|arm64) echo "arm64" ;;
    armv7l|armv7|arm/v7) echo "arm/v7" ;;
    armv6l|armv6|arm/v6) echo "arm/v6" ;;
    *) echo "$1" ;;
  esac
}

needs_binfmt() {
  local native_arch="${1:-}"
  local platforms_csv="${2:-}"
  local platform arch

  if [[ -z "$platforms_csv" ]]; then
    return 1
  fi

  IFS=',' read -r -a platforms <<< "$platforms_csv"
  for platform in "${platforms[@]}"; do
    arch="${platform#*/}"
    arch="$(normalize_arch "$arch")"
    if [[ "$arch" != "$native_arch" ]]; then
      return 0
    fi
  done
  return 1
}

ensure_binfmt() {
  if [[ "$ENSURE_BINFMT" == "false" ]]; then
    return 0
  fi

  local native_arch
  native_arch="$(docker info --format '{{.Architecture}}' 2>/dev/null || uname -m)"
  native_arch="$(normalize_arch "$native_arch")"

  local effective_platforms="$PLATFORMS"
  if [[ "$LOAD" == "true" ]]; then
    effective_platforms="linux/amd64"
  fi

  if [[ "$ENSURE_BINFMT" == "true" ]] || needs_binfmt "$native_arch" "$effective_platforms"; then
    echo "==> Ensuring binfmt/qemu is installed (tonistiigi/binfmt)"
    docker run --privileged --rm tonistiigi/binfmt --install all >/dev/null || {
      echo "Failed to install binfmt/qemu. Run:" >&2
      echo "  docker run --privileged --rm tonistiigi/binfmt --install all" >&2
      exit 1
    }
  fi
}

ensure_builder() {
  local native_arch effective_platforms
  native_arch="$(docker info --format '{{.Architecture}}' 2>/dev/null || uname -m)"
  native_arch="$(normalize_arch "$native_arch")"

  effective_platforms="$PLATFORMS"
  if [[ "$LOAD" == "true" ]]; then
    effective_platforms="linux/amd64"
  fi

  if [[ "$BUILDER_SPECIFIED" == "true" ]] || needs_binfmt "$native_arch" "$effective_platforms"; then
    local current_driver
    current_driver="$(docker buildx inspect --format '{{.Driver}}' 2>/dev/null || true)"
    if [[ "$current_driver" != "docker-container" ]]; then
      if docker buildx inspect "$BUILDER" >/dev/null 2>&1; then
        docker buildx use "$BUILDER" >/dev/null
      else
        docker buildx create --name "$BUILDER" --driver docker-container --use >/dev/null
      fi
    fi
    docker buildx inspect --bootstrap >/dev/null
    BUILDER_ARG=(--builder "$BUILDER")
  fi
}

# Metadata
export BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
export GIT_SHA="$(git rev-parse HEAD 2>/dev/null || echo unknown)"
export REGISTRY TAG LATEST_TAG VERSION CHANNEL UV_PRERELEASE OVOS_RELEASES_REF CACHE_REPO CACHE_TO MIRROR_REGISTRY

echo "==> REGISTRY=$REGISTRY TAG=$TAG LATEST_TAG=$LATEST_TAG VERSION=$VERSION CHANNEL=$CHANNEL UV_PRERELEASE=$UV_PRERELEASE OVOS_RELEASES_REF=$OVOS_RELEASES_REF"
echo "==> BUILD_DATE=$BUILD_DATE GIT_SHA=$GIT_SHA"
echo "==> TARGETS=$TARGETS PLATFORMS=$PLATFORMS PUSH=$PUSH LOAD=$LOAD CACHE_FROM=$CACHE_FROM"

# Assemble bake args
BAKE_ARGS=()
if [[ "$PUSH" == "true" && "$LOAD" == "true" ]]; then
  echo "Choose either --load or --push, not both"; exit 1
fi
[[ "$PUSH" == "true" ]] && BAKE_ARGS+=(--push)
[[ "$LOAD" == "true" ]] && BAKE_ARGS+=(--load --set '*.platform=linux/amd64')
[[ "$CACHE_FROM" != "true" ]] && BAKE_ARGS+=(--set "*.cache-from=" --set "*.cache-to=")

# Set multi-arch platforms unless loading locally
[[ "$LOAD" != "true" ]] && BAKE_ARGS+=(--set "*.platform=${PLATFORMS}")

# Split targets on whitespace for buildx bake.
read -r -a TARGETS_ARR <<< "$TARGETS"

# Ensure binfmt/qemu for cross-arch builds.
ensure_binfmt
ensure_builder

# Run bake from repo root (where docker-bake.hcl lives)
exec docker buildx bake "${BUILDER_ARG[@]}" "${TARGETS_ARR[@]}" "${BAKE_ARGS[@]}"
