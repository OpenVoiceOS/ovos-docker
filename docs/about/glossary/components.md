# Components

Open Voice OS is very modular which means instead of a big monolith block of code, multiple projects exist around the OVOS ecosystem with each of them having their own role to play in order to deliver the best and fastest experience.

## :material-volume-high: ovos-audio

The audio service is responsible for loading [Text-To-Speech](./terms.md/#text-to-speech-tts) and audio plugins.

All audio playback *(sounds played on the speakers)* is handled by this service by leveraging the sound server/service from the system where its running.

## :material-play-circle-outline: ovos-common-play

OVOS Common Play *(OCP)* is a full-fledged voice media player packaged as an audio plugin.

OCP handles the whole voice integration and playback functionality, it also integrates with external players via Media Player Remote Interfacing Specification *(MPRIS)*.

## :material-tune: ovos-config

Helper package to interact with OVOS configuration. A small tool is included to quickly show, get or set config values.

## :material-brain: ovos-core

The skills service is responsible for loading skills and [intent](./terms.md/#intent) parsers, all user queries are handled by the skills service.

This is the **brains** of the device. Without it, you would have some cool software that does not work together. It controls the skills service and directs intents to the right skill.

## :material-file-tree-outline: ovos-classifiers

Base implementations for [Natural language processing](https://en.wikipedia.org/wiki/Natural_language_processing) *(NPL)* tasks, from baseline heuristics to classic machine learning models that run everywhere.

## :material-monitor-star: ovos-gui

OVOS uses the standard Mycroft GUI framework, you can find the official documentation [here](https://mycroft-ai.gitbook.io/docs/skill-development/displaying-information/mycroft-gui).

The GUI is an open source visual and display framework running on top of KDE Plasma Technology and built using Kirigami a lightweight user interface framework for convergent applications which are empowered by QT.

!!! warning "Component dependency"

    This component depends on  [ovos-gui-messagebus](./components.md#ovos-gui-messagebus).

## :material-message-processing: ovos-gui-messagebus

GUI messagebus service, manages GUI state and implements the GUI protocol.

The GUI service provides a websocket for gui clients to connect to, it is responsible for implementing the gui protocol under ovos-core.

GUI clients *(the application that actually draws the GUI)* connect to this service.

## :material-microphone-message: ovos-listener

The listener *(also known as speech)* is responsible for loading STT, VAD and wake word plugins. Speech is transcribed into text *([intent](terms.md#intent))* and forwarded to the core service.

*The newest listener that OVOS uses is `ovos-dinkum-listener`. It is a version of the listener from the Mycroft Dinkum software for the Mark 2 modified for use with OVOS.*

## :material-forum: ovos-messagebus

The message bus service provides a websocket where all internal events travel, you can think of the bus service as Open Voice OS's nervous system.

!!! danger "Internal usage only"

    The bus is considered as an internal and private websocket, external clients should not connect directly to it. Please check [HiveMind](terms.md#hivemind) for more information. For more detail please go to the [System Hardening](../../getting-started/docker/security/hardening.md) section

## :material-memory: ovos-phal

Plugin based Hardware Abstraction Layer is a wrapper for software system level abstraction, where based on the environment either through known configuration or via fingerprinting, only specific plugins load to interface with the system and specific hardware.

A PHAL plugin can provide anything from hardware integrations *(ReSpeaker, Mark1, Mark2, etc...)* or system integrations *(Network-Manager, OVOS Shell, etc...).*

Any number of plugins providing functionality can be loaded and validated at runtime, plugins can be system integrations to handle things like reboot and shutdown, or hardware drivers such as Mycroft Mark2 plugin.

!!! tip "PHAL admin variant"

    In addition of the initial PHAL service, PHAL admin is running as `root` or as a priviledged user. This variant allows PHAL admin to perform actions which require more privileges such as `reboot` for example.

## :material-connection: ovos-plugin-manager

OPM is the OVOS Plugin Manager, this base package provides arbitrary plugins to the OVOS ecosystem. OPM plugins import their base classes from OPM making them portable and independent of `ovos-core`, plugins can be used in a standalone projects.

By using OPM you can ensure a standard interface to plugins and easily make them configurable in your project.

## :material-layers-outline: ovos-shell

OVOS Shell is the Open Voice OS client implementation of the [ovos-gui](./components.md#ovos-gui) library, basically it represents the OVOS graphical layer on top of Mycroft GUI.

!!! warning "Component dependency"

    This component depends on  [ovos-gui](./components.md#ovos-gui).

## :material-virus-outline: ovos-utils

Just a collection of simple utilities and functions for use across the components from the OVOS ecosystem.

## :material-shovel: ovos-workshop

Workshop contains skill base classes and supporting tools to build skills and applications for Open Voice OS systems.

## :material-select-compare: padacioso

A lightweight, dead-simple intent parser which aim to replace the current intent parser; [Padatious](https://mycroft-ai.gitbook.io/docs/mycroft-technologies/padatious).
