
# M3U8 Playlist Generator

A lightweight, standalone Windows batch tool that generates M3U8 playlists for local audio libraries.

## Features

- Recursively scans the folder containing the script.
- Creates one playlist per folder containing supported audio files.
- Supports MP3, FLAC, WAV, AAC, M4A, OGG, OPUS, WMA, AIFF and AIF.
- Sorts tracks naturally by filename.
- Uses relative filenames in playlists.
- Writes UTF-8 without BOM.
- Skips unchanged playlists.
- Does not follow directory junctions or symbolic links.
- Requires no external PowerShell script.

## Usage

1. Download `Generate-M3U8.bat`.
2. Place it in the root of your music library.
3. Double-click the BAT file.
4. Play the generated `.m3u8` playlists in a compatible player.

## Requirements

- Windows
- Built-in Windows PowerShell

## License

License not yet specified.
