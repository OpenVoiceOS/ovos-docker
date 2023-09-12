# Glossary

Use our Glossary to learn more about the specialist terms that we use in natural language processing generally, and more specifically with Open Voice OS software.

## Fallback

A [skill](#skill) that is designated to be a 'catch-all' when Open Voice OS cannot interpret the [intent](#intent) from an [utterance](#utterance).

## HiveMind

[HiveMind](https://github.com/JarbasHiveMind/HiveMind-core) is a community-developed superset or extension of Open Voice OS the open-source voice operating system.

With HiveMind, you can extend an instance of Open Voice OS to as many devices as you want, including devices that can't ordinarily run Open Voice OS! :rocket:

HiveMind could be considered as an external Open Voice OS component leaving its "own" life under its "own" lifecycle.

## Hotword

See [wake word](#wake-word).

## Intent

When a user speaks an [utterance](#utterance) to Open Voice OS, Open Voice OS tries to interpret the intent of the [utterance](#utterance), and match the intent with a [skill](#skill).

## Playback

Playback is the [audio](./components.md/#ovos-audio) output going through the speakers, for example when asking `What's the temperature?`, OVOS will speaks to you using the playback capability.

## Plugin

A plugin allows you to install "small bricks" of functionnalities using [OVOS Plugin Manager](./components.md/#ovos-plugin-manager) in order to make your voice assistant more capable.

Open Voice OS uses many plugins in many different areas:

- [Wake word](#wake-word) plugin
- [VAD](#vad) plugins
- Microphone plugins
- [PHAL](./components.md/#ovos-phal) plugins
- [TTS](#text-to-speech-tts) plugins
- [STT](#speech-to-text-stt) plugins
- *etc...*

## Skill

When Open Voice OS hears the [wake word](#wake-word), then an [utterance](#utterance), Open Voice OS will try to find a skill that matches the [utterance](#utterance). The skill might fetch some data, or play some audio, or speak, or display some information.

If Open Voice OS can't find a skill that matches the utterance, he will tell you he doesn't understand and [fallback](#fallback) *(when configured)*.

## Speech-To-Text (STT)

Speech-To-Text is what converts your voice into a text which becomes a commands that OVOS recognizes, then converts to an [intent](#intent) that is used to activate [skills](#skill).

Several options are available each with different attributes and supported languages. Some can be run on device, others need an internet connection to work.

## Text-To-Speech (TTS)

Text-To-Speech is responsible for converting text into audio for playback *(verbal response from OVOS)*.

Several options are available each with different attributes and supported languages. Some can be run on device, others need an internet connection to work.

## Utterance

An utterance is how you interact with Open Voice OS. An utterance is a command or question - like `What's the weather like in Kansas City?` or `Tell me about the Pembroke Welsh Corgi`.

## VAD

Voice Activity Detection is used by the [listener](./components.md/#ovos-listener) to determine when a user stopped speaking, this indicates the voice command is ready to be executed.

## Wake Word

The wake word is the phrase or word you use to *(wake up)* tell Open Voice OS you're about to issue a command.
