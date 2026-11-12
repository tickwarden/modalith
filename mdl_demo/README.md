# Modalith optional demo datapack

Requires the matching Modalith core (currently 2.1.0) and Minecraft Java 1.21.6.

Install `modalith-demo-2.1.0-mc1.21.6.zip` alongside `modalith-2.1.0-mc1.21.6.zip` in the world datapacks directory and reload. Alternatively copy this directory as its own datapack; pack.mcmeta must be at its root. Do not merge its data directory into core.

Run `/trigger mdl.open` as a player. Administrator shortcut: `/execute as <player> at @s run function mdl_demo:demo/home`.

Only this optional pack creates/handles mdl.open and the demo scoreboard. Removing it and reloading removes the active public opener without disabling the core library. Old scoreboard objectives may remain in the world; the library does not automatically delete persistent scores.

Core has no dependency on this pack. This demo is intentionally public; omit it from private deployments. Closing open demo sessions before removing it avoids callbacks that reference removed demo functions. Build both archives with `python tools/build.py` from the repository root. The core source datapack is the sibling `mdl/` directory.

Static/layout validation covers this extraction; the vanilla integration suite has not yet been rerun with the separate pack layout.
