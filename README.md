
<div align="center">

# M3U8 Playlist Generator

### Your music library. Organized into playlists. Automatically.

A lightweight, standalone Windows utility that scans your music folders and creates clean, naturally sorted **M3U8 playlists** — one playlist for every folder containing audio.

[**Download the generator**](Generate-M3U8-FIXED.bat)

![Windows](https://img.shields.io/badge/platform-Windows-2675E8?style=flat-square&logo=windows)
![PowerShell](https://img.shields.io/badge/runtime-built--in%20PowerShell-5391FE?style=flat-square&logo=powershell)
![M3U8](https://img.shields.io/badge/output-M3U8-6C5CE7?style=flat-square)
![Dependencies](https://img.shields.io/badge/dependencies-none-16A085?style=flat-square)

</div>

---

## The idea

A simple utility for people with local music libraries.

Place the BAT file in your library, run it, and it recursively scans the folder structure. Every folder containing supported audio gets its own M3U8 playlist.

No database. No configuration. No separate script to install.

## How it works

```text
Your Music/
├── Artist A/
│   ├── Album One/
│   │   ├── 01 - Track One.flac
│   │   ├── 02 - Track Two.flac
│   │   └── Album One.m3u8
│   └── Album Two/
│       ├── 01 - Intro.mp3
│       ├── 02 - Main Theme.mp3
│       └── Album Two.m3u8
├── Artist B/
│   ├── Track 1.ogg
│   ├── Track 2.ogg
│   └── Artist B.m3u8
└── Your Music.m3u8
```

Each playlist contains files directly inside its folder. Subfolders are scanned independently.

## Features

- **Recursive scanning** — walks through the library and its subfolders.
- **Natural filename sorting** — `Track 2` comes before `Track 10`.
- **One playlist per folder** — folders containing supported audio get a playlist.
- **Relative filenames** — paths are relative to the playlist's own folder.
- **UTF-8 without BOM** — clean text output.
- **Smart updates** — unchanged playlists are left untouched.
- **Safer traversal** — skips directory junctions and symbolic links.
- **Standalone** — PowerShell is embedded in the BAT file.

## Supported formats

`MP3` · `FLAC` · `WAV` · `AAC` · `M4A` · `OGG` · `OPUS` · `WMA` · `AIFF` · `AIF`

## Get started

1. Download `Generate-M3U8-FIXED.bat`.
2. Place it in the root folder of your music library.
3. Double-click the BAT file.
4. Review the generation summary.
5. Open the generated playlists in a compatible music player.

## Requirements

- Windows
- Built-in Windows PowerShell

No third-party dependencies.

---

<div align="center">

**Echolivity**

*Tools for people who care about their libraries.*

</div>
