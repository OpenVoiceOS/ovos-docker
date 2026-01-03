group "default" {
  targets = [
    "base",
    "sound-base",
    "skill-base",
    "core",
    "audio",
    "cli",
    "gui-websocket",
    "listener",
    "messagebus",
    "phal",
    "phal-admin",
    "plugin-ggwave",
    "gui-original",
    "gui-shell",
    "skill-alerts",
    "skill-camera",
    "skill-date-time",
    "skill-duckduckgo",
    "skill-easter-eggs",
    "skill-fallback-unknown",
    "skill-ggwave",
    "skill-hello-world",
    "skill-homescreen",
    "skill-jokes",
    "skill-parrot",
    "skill-personal",
    "skill-randomness",
    "skill-tunein",
    "skill-volume",
    "skill-weather",
    "skill-wikihow",
    "skill-wikipedia",
    "skill-wolfie",
    "skill-wordnet",
  ]
}

group "stack" {
  targets = ["base", "sound-base", "core"]
}

group "services" {
  targets = [
    "audio",
    "cli",
    "core",
    "gui-websocket",
    "listener",
    "messagebus",
    "phal",
    "phal-admin",
    "plugin-ggwave",
  ]
}

group "guis" {
  targets = ["gui-original", "gui-shell"]
}

group "skills" {
  targets = [
    "skill-base",
    "skill-alerts",
    "skill-camera",
    "skill-date-time",
    "skill-duckduckgo",
    "skill-easter-eggs",
    "skill-fallback-unknown",
    "skill-ggwave",
    "skill-hello-world",
    "skill-homescreen",
    "skill-jokes",
    "skill-parrot",
    "skill-personal",
    "skill-randomness",
    "skill-tunein",
    "skill-volume",
    "skill-weather",
    "skill-wikihow",
    "skill-wikipedia",
    "skill-wolfie",
    "skill-wordnet",
  ]
}

# ---------- Variables (override via env or scripts/bake.sh) ----------
variable "REGISTRY"   { default = "oci.uoi.io/ovos" }
variable "TAG"        { default = "alpha" }
variable "CHANNEL"    { default = "alpha" }
variable "UV_PRERELEASE" { default = "allow" }
variable "VERSION"    { default = "alpha" }
variable "BUILD_DATE" { default = "1970-01-01T00:00:00Z" }
variable "GIT_SHA"    { default = "unknown" }

# ---------- Common settings ----------
target "common" {
  platforms = ["linux/amd64","linux/arm64"]

  args = {
    BUILD_DATE   = "${BUILD_DATE}"
    VERSION      = "${VERSION}"
    CHANNEL      = "${CHANNEL}"
    TAG          = "${TAG}"
    REGISTRY     = "${REGISTRY}"
    GIT_SHA      = "${GIT_SHA}"
    OVOS_CHANNEL = "${CHANNEL}"
    UV_PRERELEASE = "${UV_PRERELEASE}"
  }

  # SBOM + provenance
  attest = [
    { type = "provenance", mode = "max", inline = true },
    { type = "sbom", inline = true }
  ]
}

# ---------- base (context = ./base) ----------
target "base" {
  inherits   = ["common"]
  context    = "base"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}/ovos-base:${TAG}"]

  args = {
    IMAGE_REF = "ovos-base:${TAG}"
  }

  # Inline cache works with any registry
  cache-from = ["type=registry,ref=${REGISTRY}/ovos-base:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- sound-base (context = ./sound-base) ----------
target "sound-base" {
  inherits   = ["common"]
  context    = "sound-base"
  dockerfile = "Dockerfile"
  depends_on = ["base"]
  tags       = ["${REGISTRY}/ovos-sound-base:${TAG}"]

  # Map Dockerfile's BASE_IMAGE name to locally-built base target
  contexts = {
    "ovos-base" = "target:base"
  }

  args = {
    BASE_IMAGE = "ovos-base"
    IMAGE_REF  = "ovos-sound-base:${TAG}"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-sound-base:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- skill-base (context = ./skills/skill-base) ----------
target "skill-base" {
  inherits   = ["common"]
  context    = "skills/skill-base"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}/ovos-skill-base:${TAG}"]

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-base:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- core (context = ./core) ----------
target "core" {
  inherits   = ["common"]
  context    = "core"
  dockerfile = "Dockerfile"
  depends_on = ["sound-base"]
  tags       = ["${REGISTRY}/ovos-core:${TAG}"]

  # Map Dockerfile's SOUND_BASE_IMAGE name to locally-built sound-base target
  contexts = {
    "ovos-sound-base" = "target:sound-base"
  }

  args = {
    SOUND_BASE_IMAGE = "ovos-sound-base"
    IMAGE_REF        = "ovos-core:${TAG}"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-core:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- audio (context = ./audio) ----------
target "audio" {
  inherits   = ["common"]
  context    = "audio"
  dockerfile = "Dockerfile"
  depends_on = ["sound-base"]
  tags       = ["${REGISTRY}/ovos-audio:${TAG}"]

  contexts = {
    "ovos-sound-base" = "target:sound-base"
  }

  args = {
    SOUND_BASE_IMAGE = "ovos-sound-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-audio:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- cli (context = ./cli) ----------
target "cli" {
  inherits   = ["common"]
  context    = "cli"
  dockerfile = "Dockerfile"
  depends_on = ["base"]
  tags       = ["${REGISTRY}/ovos-cli:${TAG}"]

  contexts = {
    "ovos-base" = "target:base"
  }

  args = {
    BASE_IMAGE = "ovos-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-cli:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- gui-websocket (context = ./gui-websocket) ----------
target "gui-websocket" {
  inherits   = ["common"]
  context    = "gui-websocket"
  dockerfile = "Dockerfile"
  depends_on = ["base"]
  tags       = ["${REGISTRY}/ovos-gui-websocket:${TAG}"]

  contexts = {
    "ovos-base" = "target:base"
  }

  args = {
    BASE_IMAGE = "ovos-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-gui-websocket:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- listener (context = ./listener) ----------
target "listener" {
  inherits   = ["common"]
  context    = "listener"
  dockerfile = "Dockerfile"
  depends_on = ["sound-base"]
  tags       = ["${REGISTRY}/ovos-listener:${TAG}"]

  contexts = {
    "ovos-sound-base" = "target:sound-base"
  }

  args = {
    SOUND_BASE_IMAGE = "ovos-sound-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-listener:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- messagebus (context = ./messagebus) ----------
target "messagebus" {
  inherits   = ["common"]
  context    = "messagebus"
  dockerfile = "Dockerfile"
  depends_on = ["base"]
  tags       = ["${REGISTRY}/ovos-messagebus:${TAG}"]

  contexts = {
    "ovos-base" = "target:base"
  }

  args = {
    BASE_IMAGE = "ovos-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-messagebus:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- phal (context = ./phal) ----------
target "phal" {
  inherits   = ["common"]
  context    = "phal"
  dockerfile = "Dockerfile"
  depends_on = ["sound-base"]
  tags       = ["${REGISTRY}/ovos-phal:${TAG}"]

  contexts = {
    "ovos-sound-base" = "target:sound-base"
  }

  args = {
    SOUND_BASE_IMAGE = "ovos-sound-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-phal:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- phal-admin (context = ./phal-admin) ----------
target "phal-admin" {
  inherits   = ["common"]
  context    = "phal-admin"
  dockerfile = "Dockerfile"
  depends_on = ["phal"]
  tags       = ["${REGISTRY}/ovos-phal-admin:${TAG}"]

  contexts = {
    "ovos-phal" = "target:phal"
  }

  args = {
    PHAL_IMAGE = "ovos-phal"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-phal-admin:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- plugin-ggwave (context = ./plugin-ggwave) ----------
target "plugin-ggwave" {
  inherits   = ["common"]
  context    = "plugin-ggwave"
  dockerfile = "Dockerfile"
  depends_on = ["sound-base"]
  tags       = ["${REGISTRY}/ovos-plugin-ggwave:${TAG}"]

  contexts = {
    "ovos-sound-base" = "target:sound-base"
  }

  args = {
    SOUND_BASE_IMAGE = "ovos-sound-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-plugin-ggwave:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- gui-original (context = ./gui/gui-original) ----------
target "gui-original" {
  inherits   = ["common"]
  context    = "gui/gui-original"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}/ovos-gui-original:${TAG}"]

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-gui-original:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- gui-shell (context = ./gui/gui-shell) ----------
target "gui-shell" {
  inherits   = ["common"]
  context    = "gui/gui-shell"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}/ovos-gui-shell:${TAG}"]

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-gui-shell:${TAG}"]
  cache-to   = ["type=inline"]
}

# ---------- skills (context = ./skills/*) ----------
target "skill-alerts" {
  inherits   = ["common"]
  context    = "skills/skill-alerts"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-alerts:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-alerts:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-camera" {
  inherits   = ["common"]
  context    = "skills/skill-camera"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-camera:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-camera:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-date-time" {
  inherits   = ["common"]
  context    = "skills/skill-date-time"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-date-time:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-date-time:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-duckduckgo" {
  inherits   = ["common"]
  context    = "skills/skill-duckduckgo"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-duckduckgo:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-duckduckgo:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-easter-eggs" {
  inherits   = ["common"]
  context    = "skills/skill-easter-eggs"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-easter-eggs:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-easter-eggs:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-fallback-unknown" {
  inherits   = ["common"]
  context    = "skills/skill-fallback-unknown"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-fallback-unknown:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-fallback-unknown:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-ggwave" {
  inherits   = ["common"]
  context    = "skills/skill-ggwave"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-ggwave:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-ggwave:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-hello-world" {
  inherits   = ["common"]
  context    = "skills/skill-hello-world"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-hello-world:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-hello-world:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-homescreen" {
  inherits   = ["common"]
  context    = "skills/skill-homescreen"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-homescreen:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-homescreen:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-jokes" {
  inherits   = ["common"]
  context    = "skills/skill-jokes"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-jokes:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-jokes:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-parrot" {
  inherits   = ["common"]
  context    = "skills/skill-parrot"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-parrot:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-parrot:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-personal" {
  inherits   = ["common"]
  context    = "skills/skill-personal"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-personal:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-personal:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-randomness" {
  inherits   = ["common"]
  context    = "skills/skill-randomness"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-randomness:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-randomness:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-tunein" {
  inherits   = ["common"]
  context    = "skills/skill-tunein"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-tunein:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-tunein:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-volume" {
  inherits   = ["common"]
  context    = "skills/skill-volume"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-volume:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-volume:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-weather" {
  inherits   = ["common"]
  context    = "skills/skill-weather"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-weather:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-weather:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-wikihow" {
  inherits   = ["common"]
  context    = "skills/skill-wikihow"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-wikihow:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-wikihow:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-wikipedia" {
  inherits   = ["common"]
  context    = "skills/skill-wikipedia"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-wikipedia:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-wikipedia:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-wolfie" {
  inherits   = ["common"]
  context    = "skills/skill-wolfie"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-wolfie:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-wolfie:${TAG}"]
  cache-to   = ["type=inline"]
}

target "skill-wordnet" {
  inherits   = ["common"]
  context    = "skills/skill-wordnet"
  dockerfile = "Dockerfile"
  depends_on = ["skill-base"]
  tags       = ["${REGISTRY}/ovos-skill-wordnet:${TAG}"]

  contexts = {
    "ovos-skill-base" = "target:skill-base"
  }

  args = {
    SKILL_BASE_IMAGE = "ovos-skill-base"
  }

  cache-from = ["type=registry,ref=${REGISTRY}/ovos-skill-wordnet:${TAG}"]
  cache-to   = ["type=inline"]
}
