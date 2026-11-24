# M3U8 Playlist Generator v1.0.1

A maintenance release that makes the generator safe to run again and again on a living library. It is still one BAT file with no dependencies.

**Download:** `Generate-M3U8.bat` (attached below). Put it in the root of your music library and double-click it.

## Highlights

- **Playlists follow your library.** When a folder loses all its audio or is renamed, its old generated playlist is now removed. Previously it stayed behind.
- **Your own playlists are safe.** The tool only changes a playlist if every line matches exactly what it writes. Edited, hand-made, empty or non-UTF-8 playlists are never touched. Read-only playlists are respected.
- **No more missing tracks.** Files whose names start with `#` used to vanish from playlists, because players read them as comments. They now play.
- **Safer writes.** New content is flushed to disk first, and the old playlist is kept as a backup until the swap succeeds. A failed write leaves the old playlist exactly as it was. Leftovers from an interrupted run are cleaned up next time.
- **Hidden and system folders are skipped consistently.**
- **Clear exit codes:** `0` success, `1` completed with errors, `2` stopped before making changes. Set `M3U8_NO_PAUSE=1` for scheduled runs.

## Upgrading

Replace your old BAT file with this one and run it. Playlists from earlier versions are recognised and updated in place. Each one is rewritten once, to add a one-line comment that marks it as generated. Hand-made playlists are left alone.

## Compatibility

Windows 10/11 with the built-in Windows PowerShell 5.1. No installation, no administrator rights.

## Testing

27 automated scenarios (`tests/Run-Tests.ps1`), including a 10,000-file library, protection of hand-made playlists and interrupted writes. See `docs/TEST-REPORT.md` for exactly what was executed, simulated and still unverified on Windows.

## Known limitations

Paths over 260 characters are skipped and reported. Hidden music folders are skipped. Titles come from file names, not tags. See the README for the full list.

Full changelog: `CHANGELOG.md`.
