# docker-bake.hcl — Open Voice OS container images
#
#   ./scripts/bake.sh                       multi-arch build + push of the "default" group
#   ./scripts/bake.sh -T listener --load    local single-arch build of one target
#   docker buildx bake --print skills       show the resolved configuration of a group
#
# Image graph:
#   base ─┬─ sound-base ─┬─ core
#         │              ├─ audio, listener, phal ─ phal-admin, plugin-ggwave
#         ├─ cli, gui-websocket, messagebus
#         └─ skill-base ─ skill-<name>  (see SKILLS)
#   gui-original, gui-shell    (standalone, Debian based)

# ---------- Variables (override via env or scripts/bake.sh) ----------
variable "REGISTRY"          { default = "docker.io/smartgic" }
variable "TAG"               { default = "alpha" }
variable "LATEST_TAG"        { default = "latest" }
variable "CHANNEL"           { default = "alpha" }
variable "UV_PRERELEASE"     { default = "allow" }
variable "VERSION"           { default = "alpha" }
variable "BUILD_DATE"        { default = "1970-01-01T00:00:00Z" }
variable "GIT_SHA"           { default = "unknown" }
# Git ref (branch, tag or commit SHA) of OpenVoiceOS/ovos-releases to take constraints-${CHANNEL}.txt from.
# Passing a commit SHA makes the build reproducible and busts the layer cache when the constraints change.
variable "OVOS_RELEASES_REF" { default = "main" }

# Build cache. Lives on GHCR (no pull-rate limits, free for public repositories) as one tag per
# image and TAG, so channels and architectures never share cache entries. CACHE_TO="max" exports
# the cache after the build (CI); leave it empty for local builds without GHCR write access —
# cache-from still works anonymously because the cache package is public.
variable "CACHE_REPO" { default = "ghcr.io/openvoiceos/ovos-docker-cache" }
variable "CACHE_TO"   { default = "" }

# Optional second registry every image is also pushed to (CI uses ghcr.io/openvoiceos). The pipeline
# reads manifests, labels and SBOMs from there, which has no pull-rate limit; users keep pulling
# from REGISTRY. Empty = single registry (local builds).
variable "MIRROR_REGISTRY" { default = "" }

# Skills built from skills/skill-<name>/Dockerfile on top of skill-base. Adding a skill = one entry here.
variable "SKILLS" {
  default = [
    "alerts",
    "camera",
    "date-time",
    "duckduckgo",
    "easter-eggs",
    "fallback-unknown",
    "ggwave",
    "hello-world",
    "homeassistant",
    "homescreen",
    "jokes",
    "parrot",
    "personal",
    "randomness",
    "tunein",
    "volume",
    "weather",
    "wikihow",
    "wikipedia",
    "wolfie",
    "wordnet",
  ]
}

# ---------- Helpers ----------
# stable is additionally tagged LATEST_TAG; every other TAG is published as-is.
# With MIRROR_REGISTRY set, the same tags are also produced for the mirror.
function "tags" {
  params = [image]
  result = compact(concat(
    TAG == "stable" ? [
      "${REGISTRY}/${image}:${TAG}",
      "${REGISTRY}/${image}:${LATEST_TAG}",
    ] : [
      "${REGISTRY}/${image}:${TAG}",
    ],
    MIRROR_REGISTRY == "" ? [""] : (TAG == "stable" ? [
      "${MIRROR_REGISTRY}/${image}:${TAG}",
      "${MIRROR_REGISTRY}/${image}:${LATEST_TAG}",
    ] : [
      "${MIRROR_REGISTRY}/${image}:${TAG}",
    ]),
  ))
}

function "cache_from" {
  params = [image]
  result = ["type=registry,ref=${CACHE_REPO}:${image}-${TAG}"]
}

function "cache_to" {
  params = [image]
  result = compact([CACHE_TO == "" ? "" : "type=registry,ref=${CACHE_REPO}:${image}-${TAG},mode=${CACHE_TO}"])
}

# ---------- Groups ----------
group "default"  { targets = ["stack", "services", "skills", "guis"] }
group "stack"    { targets = ["base", "sound-base", "core"] }
group "services" { targets = ["audio", "cli", "core", "gui-websocket", "listener", "messagebus", "phal", "phal-admin", "plugin-ggwave"] }
group "guis"     { targets = ["gui-original", "gui-shell"] }
group "skills"   { targets = concat(["skill-base"], formatlist("skill-%s", SKILLS)) }

# ---------- Common settings ----------
target "common" {
  platforms = ["linux/amd64", "linux/arm64"]

  args = {
    BUILD_DATE        = "${BUILD_DATE}"
    VERSION           = "${VERSION}"
    CHANNEL           = "${CHANNEL}"
    TAG               = "${TAG}"
    REGISTRY          = "${REGISTRY}"
    GIT_SHA           = "${GIT_SHA}"
    OVOS_CHANNEL      = "${CHANNEL}"
    UV_PRERELEASE     = "${UV_PRERELEASE}"
    OVOS_RELEASES_REF = "${OVOS_RELEASES_REF}"
  }

  # SBOM + provenance, embedded in the image index
  attest = [
    { type = "provenance", mode = "max", inline = true },
    { type = "sbom", inline = true },
  ]
}

# ---------- Base images ----------
target "base" {
  inherits   = ["common"]
  context    = "base"
  tags       = tags("ovos-base")
  args       = { IMAGE_REF = "ovos-base:${TAG}" }
  cache-from = cache_from("ovos-base")
  cache-to   = cache_to("ovos-base")
}

target "sound-base" {
  inherits   = ["common"]
  context    = "sound-base"
  contexts   = { "ovos-base" = "target:base" }
  tags       = tags("ovos-sound-base")
  args       = { BASE_IMAGE = "ovos-base", IMAGE_REF = "ovos-sound-base:${TAG}" }
  cache-from = cache_from("ovos-sound-base")
  cache-to   = cache_to("ovos-sound-base")
}

target "skill-base" {
  inherits   = ["common"]
  context    = "skills/skill-base"
  contexts   = { "ovos-base" = "target:base" }
  args       = { BASE_IMAGE = "ovos-base" }
  tags       = tags("ovos-skill-base")
  cache-from = cache_from("ovos-skill-base")
  cache-to   = cache_to("ovos-skill-base")
}

# ---------- Services on top of base ----------
target "cli" {
  inherits   = ["common"]
  context    = "cli"
  contexts   = { "ovos-base" = "target:base" }
  tags       = tags("ovos-cli")
  args       = { BASE_IMAGE = "ovos-base" }
  cache-from = cache_from("ovos-cli")
  cache-to   = cache_to("ovos-cli")
}

target "gui-websocket" {
  inherits   = ["common"]
  context    = "gui-websocket"
  contexts   = { "ovos-base" = "target:base" }
  tags       = tags("ovos-gui-websocket")
  args       = { BASE_IMAGE = "ovos-base" }
  cache-from = cache_from("ovos-gui-websocket")
  cache-to   = cache_to("ovos-gui-websocket")
}

target "messagebus" {
  inherits   = ["common"]
  context    = "messagebus"
  contexts   = { "ovos-base" = "target:base" }
  tags       = tags("ovos-messagebus")
  args       = { BASE_IMAGE = "ovos-base" }
  cache-from = cache_from("ovos-messagebus")
  cache-to   = cache_to("ovos-messagebus")
}

# ---------- Services on top of sound-base ----------
target "core" {
  inherits   = ["common"]
  context    = "core"
  contexts   = { "ovos-sound-base" = "target:sound-base" }
  tags       = tags("ovos-core")
  args       = { SOUND_BASE_IMAGE = "ovos-sound-base", IMAGE_REF = "ovos-core:${TAG}" }
  cache-from = cache_from("ovos-core")
  cache-to   = cache_to("ovos-core")
}

target "audio" {
  inherits   = ["common"]
  context    = "audio"
  contexts   = { "ovos-sound-base" = "target:sound-base" }
  tags       = tags("ovos-audio")
  args       = { SOUND_BASE_IMAGE = "ovos-sound-base" }
  cache-from = cache_from("ovos-audio")
  cache-to   = cache_to("ovos-audio")
}

target "listener" {
  inherits   = ["common"]
  context    = "listener"
  contexts   = { "ovos-sound-base" = "target:sound-base" }
  tags       = tags("ovos-listener")
  args       = { SOUND_BASE_IMAGE = "ovos-sound-base" }
  cache-from = cache_from("ovos-listener")
  cache-to   = cache_to("ovos-listener")
}

target "phal" {
  inherits   = ["common"]
  context    = "phal"
  contexts   = { "ovos-sound-base" = "target:sound-base" }
  tags       = tags("ovos-phal")
  args       = { SOUND_BASE_IMAGE = "ovos-sound-base" }
  cache-from = cache_from("ovos-phal")
  cache-to   = cache_to("ovos-phal")
}

target "phal-admin" {
  inherits   = ["common"]
  context    = "phal-admin"
  contexts   = { "ovos-phal" = "target:phal" }
  tags       = tags("ovos-phal-admin")
  args       = { PHAL_IMAGE = "ovos-phal" }
  cache-from = cache_from("ovos-phal-admin")
  cache-to   = cache_to("ovos-phal-admin")
}

target "plugin-ggwave" {
  inherits   = ["common"]
  context    = "plugin-ggwave"
  contexts   = { "ovos-sound-base" = "target:sound-base" }
  tags       = tags("ovos-plugin-ggwave")
  args       = { SOUND_BASE_IMAGE = "ovos-sound-base" }
  cache-from = cache_from("ovos-plugin-ggwave")
  cache-to   = cache_to("ovos-plugin-ggwave")
}

# ---------- GUIs (standalone) ----------
target "gui-original" {
  inherits   = ["common"]
  context    = "gui/gui-original"
  tags       = tags("ovos-gui-original")
  cache-from = cache_from("ovos-gui-original")
  cache-to   = cache_to("ovos-gui-original")
}

target "gui-shell" {
  inherits   = ["common"]
  context    = "gui/gui-shell"
  tags       = tags("ovos-gui-shell")
  cache-from = cache_from("ovos-gui-shell")
  cache-to   = cache_to("ovos-gui-shell")
}

# ---------- Skills (one target per SKILLS entry, named skill-<name>) ----------
target "skill" {
  matrix     = { skill = SKILLS }
  name       = "skill-${skill}"
  inherits   = ["common"]
  context    = "skills/skill-${skill}"
  contexts   = { "ovos-skill-base" = "target:skill-base" }
  tags       = tags("ovos-skill-${skill}")
  args       = { SKILL_BASE_IMAGE = "ovos-skill-base" }
  cache-from = cache_from("ovos-skill-${skill}")
  cache-to   = cache_to("ovos-skill-${skill}")
}
