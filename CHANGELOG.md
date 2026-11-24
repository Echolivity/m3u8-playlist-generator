# Changelog

All notable changes to this project are documented here. The project uses [Semantic Versioning](https://semver.org/).

## [1.0.1] — 2026-11-25

Maintenance release: reliability, safe cleanup of stale playlists, and an automated test suite. Same single BAT file and the same playlist format as 1.0.0, so existing playlists upgrade without changes.

### Fixed
- **Tracks whose file name starts with `#` were missing from playlists.** Players read such lines as comments. These names, and names starting with a space, are now written as `.\name`.
- **Playlists for emptied or renamed folders were never removed.** Stale generated playlists are now cleaned up under a strict policy (see README → Stale playlist cleanup).
- **Edited playlists could be overwritten.** Any file containing the generator tag was treated as generated, even after a user edited it. Ownership now requires every line to match the generator's exact format.
- **Empty or non-UTF-8 playlists were treated as generated**, or decoded with replacement characters. Both are now treated as user files and left alone.
- **Hidden folders were scanned** unless they were also system folders. Files and folders are now skipped if *either* Hidden or System is set.
- **A failed swap could lose the old playlist.** The old version is now kept as a backup during replacement and restored if the swap fails part-way.
- **Power loss could leave an empty playlist.** New content is flushed to disk before it replaces the old file.
- **Read-only playlists caused an error on every run.** They are now left alone and reported as *Kept (read-only)*.
- **Work files from an interrupted run were never removed.** Leftovers older than 10 minutes are cleaned up on the next run.
- **The run stopped if the Explorer sorting helper compiled but could not be called.** It now falls back to the built-in natural sort.
- **File names that can't be encoded as UTF-8 were silently mangled.** They are now left out and reported.
- **Writing near the 260-character limit failed sooner than necessary.** The temporary file name no longer depends on the playlist name's length.
- **A folder that could not be fully read could be changed based on a partial listing.** Such folders are now left untouched.

### Changed
- Each folder is listed once, not twice, and file attributes come from that listing, with no extra call per file.
- Exit code `2` now signals a fatal start-up error; `1` still means "completed with errors".
- Setting `M3U8_NO_PAUSE=1` skips the final key press, for scheduled runs.
- The summary has new lines: *Stale removed*, *Kept (read-only)*, *Work files cleaned* and *Hidden/system skipped*.

### Added
- `tests/Run-Tests.ps1`: an automated test suite (27 scenarios, including a 10,000-file library).
- `docs/TEST-REPORT.md`, `docs/RELEASE-NOTES-v1.0.1.md`.

## [1.0.0] — not released

Prepared in pull request #1 and included in 1.0.1. It was never tagged.

- Fixed: updating an existing playlist always failed (`File.Replace` was given an empty backup path).
- Hand-made playlists are no longer overwritten; generated playlists carry a tag line.
- OneDrive Files On-Demand folders are scanned; only junctions and symbolic links are skipped.
- Hidden/system files and macOS `._` files are ignored.
- Added a natural-sort fallback; renamed the script to `Generate-M3U8.bat`; added `.gitattributes` to keep CRLF line endings.

## [0.x] — 2026-11-20

Initial upload as `Generate-M3U8-FIXED.bat`.
