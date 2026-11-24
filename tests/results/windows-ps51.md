# Test results - Generate-M3U8.bat

- Date (UTC): 2026-11-24 23:20
- Environment: Windows 10.0.20348.0; test host PowerShell 5.1.20348.5773; generator run through cmd.exe by the BAT via powershell.exe (Windows PowerShell 5.1)
- Totals: PASS=22, PASS*=5

| # | Test | Mode | Result | Time (s) | Notes |
|---|---|---|---|---|---|
| 01 | Empty library | Executed | PASS | 1.38 |  |
| 02 | Single album: exact output format | Executed | PASS | 0.35 |  |
| 03 | Nested album folders | Executed | PASS | 0.38 |  |
| 04 | Unicode file and folder names | Executed | PASS | 0.35 |  |
| 05 | Natural sorting | Executed | PASS | 0.35 |  |
| 06 | Duplicate file names in different folders | Executed | PASS | 0.38 |  |
| 07 | Existing generated playlist: update and no-op rerun | Executed | PASS | 2.1 |  |
| 07b | Pre-1.0.0 playlist is upgraded | Executed | PASS | 0.35 |  |
| 08 | Manually created playlists are never modified | Executed | PASS | 0.46 |  |
| 09 | Empty-folder and renamed-folder reconciliation | Executed | PASS | 0.75 |  |
| 10 | Deleted and moved audio files | Executed | PASS | 0.73 |  |
| 11 | Hidden files and macOS ._ files excluded | Executed | PASS | 0.38 |  |
| 12 | System files excluded | Executed | PASS | 0.39 |  |
| 13 | Hidden and system folders skipped | Executed | PASS | 0.34 |  |
| 14 | Symbolic links and junctions not followed | Executed | PASS | 0.37 | Tested: junction, symlink |
| 15 | Read-only playlists are left alone | Executed | PASS | 0.69 |  |
| 16a | Failed write (folder not writable) keeps old playlist | Executed | PASS | 0.74 |  |
| 16b | Interrupted after work file written | Fault-injected | PASS* | 0.7 |  |
| 16c | Replace fails after old file moved aside: old playlist restored | Fault-injected | PASS* | 1.06 |  |
| 16d | Leftovers from a killed run are cleaned up safely | Executed | PASS | 0.69 |  |
| 16e | Inaccessible folder is reported and left unchanged | Executed | PASS | 0.73 |  |
| 16f | Listing fails part-way: folder left unchanged | Fault-injected | PASS* | 0.65 |  |
| 17 | Large library (10000 files) | Executed | PASS | 19.11 | 10000 files / 1001 folders: first run 6.1s, unchanged rerun 0.7s |
| 18 | Names starting with '#' or a space stay playable | Executed | PASS | 0.67 |  |
| 19 | Name that cannot be encoded as UTF-8 is reported, not mangled | Executed | PASS | 0.36 |  |
| 20 | Sorting fallback when the helper cannot be built | Fault-injected | PASS* | 0.31 |  |
| 21 | Fatal start-up errors exit with code 2 | Fault-injected | PASS* | 0.2 |  |
