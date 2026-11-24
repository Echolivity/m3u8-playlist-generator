# Test results - Generate-M3U8.bat

- Date (UTC): 2026-11-24 23:06
- Environment: Ubuntu 24.04.5 LTS; PowerShell 7.5.4; user m3u8test
- Totals: PASS=19, PASS*=7, SKIP=1

| # | Test | Mode | Result | Time (s) | Notes |
|---|---|---|---|---|---|
| 01 | Empty library | Executed | PASS | 0.89 |  |
| 02 | Single album: exact output format | Executed | PASS | 0.89 |  |
| 03 | Nested album folders | Executed | PASS | 0.82 |  |
| 04 | Unicode file and folder names | Executed | PASS | 0.86 |  |
| 05 | Natural sorting | Executed | PASS | 0.77 | Linux: verified the built-in natural sort fallback (StrCmpLogicalW is Windows-only). |
| 06 | Duplicate file names in different folders | Executed | PASS | 0.73 |  |
| 07 | Existing generated playlist: update and no-op rerun | Executed | PASS | 3.02 |  |
| 07b | Pre-1.0.0 playlist is upgraded | Executed | PASS | 0.66 |  |
| 08 | Manually created playlists are never modified | Executed | PASS | 0.63 |  |
| 09 | Empty-folder and renamed-folder reconciliation | Executed | PASS | 1.19 |  |
| 10 | Deleted and moved audio files | Executed | PASS | 1.18 |  |
| 11 | Hidden files and macOS ._ files excluded | Executed | PASS | 0.56 |  |
| 12 | System files excluded | Simulated | PASS* | 0.62 | System attribute injected by patching the attribute read; the bitwise check itself ran unmodified. |
| 13 | Hidden and system folders skipped | Simulated | PASS* | 0.63 | Hidden folder: real (dot-folder). System folder: attribute simulated. |
| 14 | Symbolic links and junctions not followed | Executed | PASS | 0.61 | Tested: symlink |
| 15 | Read-only playlists are left alone | Executed | PASS | 1.25 |  |
| 16a | Failed write (folder not writable) keeps old playlist | Executed | PASS | 1.42 |  |
| 16b | Interrupted after work file written | Fault-injected | PASS* | 1.3 |  |
| 16c | Replace fails after old file moved aside: old playlist restored | Fault-injected | PASS* | 1.8 |  |
| 16d | Leftovers from a killed run are cleaned up safely | Executed | PASS | 1.27 |  |
| 16e | Inaccessible folder is reported and left unchanged | Executed | PASS | 1.24 |  |
| 16f | Listing fails part-way: folder left unchanged | Fault-injected | PASS* | 1.06 |  |
| 17 | Large library (10000 files) | Executed | PASS | 10.06 | 10000 files / 1001 folders: first run 4.9s, unchanged rerun 4.2s |
| 18 | Names starting with '#' or a space stay playable | Executed | PASS | 1.18 |  |
| 19 | Name that cannot be encoded as UTF-8 is reported, not mangled | Executed | SKIP | 0.01 | Needs an NTFS name with an unpaired UTF-16 surrogate; Linux file names cannot hold one. |
| 20 | Sorting fallback when the helper cannot be built | Fault-injected | PASS* | 0.49 |  |
| 21 | Fatal start-up errors exit with code 2 | Fault-injected | PASS* | 0.81 |  |
