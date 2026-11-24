# Test execution report — Generate-M3U8.bat v1.0.1

**Status: passed on real Windows (Windows PowerShell 5.1, .NET Framework 4.8.1): 0 failures, 27 of 27 scenarios run.** It also passed on Linux / PowerShell 7.

## 0. Windows release verification (2026-11-25)

| Item | Detail |
|---|---|
| Machine | GitHub-hosted runner `windows-2022`: Windows Server 2022, build 10.0.20348.5870, NTFS |
| Runtime | Windows PowerShell 5.1.20348.5773 (Desktop), CLR 4.0.30319.42000, .NET Framework release key 533509 (4.8.1) |
| Account | `runneradmin`, elevated. The NTFS deny-ACL tests (16a, 16e) still took effect. |
| Commit tested | `fda6bbf6ded75f2eadd950dc880cf7573d50c296` (`release/v1.0.1`) |
| Command | `powershell -NoProfile -ExecutionPolicy Bypass -File tests\Run-Tests.ps1 -Report tests\results\windows-ps51.md`, started from `cmd.exe` |
| Launcher | Each test copies the real BAT into its library and runs it through `cmd.exe /d /c`; the BAT starts `powershell.exe` 5.1 itself |
| Workflow run | [45508986480](https://github.com/Echolivity/m3u8-playlist-generator/actions/runs/45508986480) (workflow on branch `ci/windows-verify` only) |
| Result | **22 PASS (executed), 5 PASS\* (fault-injected), 0 SKIP, 0 FAIL**; job exit code 0 |
| Evidence files | [`tests/results/windows-ps51.md`](../tests/results/windows-ps51.md), [`windows-ps51-console.txt`](../tests/results/windows-ps51-console.txt), [`windows-ps51-environment.txt`](../tests/results/windows-ps51-environment.txt) |

Gate checks:

- Test 12 (System files) and 13 (Hidden and System folders): **Executed** with real NTFS attributes. No simulation.
- Test 14: **Executed**, with both a junction and a symbolic link.
- Test 19 (unpaired-surrogate file name): **Executed**.
- Test 05: Explorer sorting (`StrCmpLogicalW`) in use, with no fallback warning.
- `File.Replace` on NTFS: run for real by every update test (07, 07b, 10, 18), with no work files left behind.
- Backup restoration (16c): run on NTFS. The failure is injected (the old file is moved aside, then an exception is thrown); the restore code itself ran unmodified.
- Unicode names (04): accents, CJK and emoji on NTFS.
- NTFS permissions: read-only attribute (15) and deny ACLs set with `icacls` for writing (16a) and listing (16e).
- Large library (17): 10,000 files / 1,001 folders. First run 6.1 s; unchanged rerun 0.7 s.

The first Windows run (run 45508762740, commit `04a391b`) found one defect in the **test harness**, not the generator: Windows PowerShell 5.1 leaves `$PSScriptRoot` empty in `param()` defaults, so the suite stopped before any test ran. It was fixed in `fda6bbf`, and the complete suite was rerun (above).

The sections below are the earlier Linux run, kept for reference.

## 1. What was run, and where

| Item | Detail |
|---|---|
| Date | 2026-11-25 |
| Platform | Ubuntu 24.04.5 LTS, PowerShell 7.5.4 (.NET 9) |
| Account | Unprivileged user `m3u8test`, so file and folder permissions are enforced |
| How the generator was started | The BAT file's own `-Command` start-up line was run with `pwsh`. It loads the embedded script from the BAT exactly as `powershell.exe` does on Windows, so the loader, every line of generator code and the exit codes were exercised. `cmd.exe` and `powershell.exe` themselves were not. |
| Test suite | `tests/Run-Tests.ps1` (27 scenarios) |
| Raw results | [`tests/results/linux-pwsh7.md`](../tests/results/linux-pwsh7.md) |
| Windows PowerShell 5.1 | **Not executed** (no Windows machine available). Static compatibility analysis only; see §4. |

### Result labels

| Label | Meaning |
|---|---|
| **PASS** | Ran the unmodified generator for real and every assertion held. |
| **PASS\*** (fault-injected) | Ran the real generator with one line replaced by `throw` at a marked point, to simulate a crash or I/O failure there. Recovery code ran unmodified. |
| **PASS\*** (simulated) | A Windows-only file attribute was faked by patching the line that reads attributes. The generator's own checks ran unmodified. |
| **SKIP** | Not possible on this platform. |

Simulated and fault-injected results are **not** reported as plain execution passes.

## 2. Results (Linux, PowerShell 7.5.4)

Totals: **19 PASS, 7 PASS\*, 1 SKIP, 0 FAIL.**

| Brief # | Test ID | Scenario | Mode | Result |
|---|---|---|---|---|
| 1 | 01 | Empty library | Executed | PASS |
| 2 | 02 | Single album, exact byte-level output (header, tag, CRLF, no BOM) | Executed | PASS |
| 3 | 03 | Nested album folders | Executed | PASS |
| 4 | 04 | Unicode file and folder names (accents, CJK, emoji) | Executed | PASS |
| 5 | 05 | Natural sorting (1, 2, 3, 10, 21) | Executed | PASS (fallback sorter; see §5) |
| 6 | 06 | Duplicate file names in different folders | Executed | PASS |
| 7 | 07 | Generated playlist update; unchanged rerun does not rewrite | Executed | PASS |
| 7 | 07b | Pre-1.0.0 playlist recognised and upgraded | Executed | PASS |
| 8 | 08 | Seven kinds of hand-made playlist kept byte-identical, incl. empty and non-UTF-8 | Executed | PASS |
| 9 | 09 | Empty-folder and renamed-folder cleanup; untagged, copied, trimmed and reordered playlists kept | Executed | PASS |
| 10 | 10 | Deleted and moved audio files | Executed | PASS |
| 11 | 11 | Hidden files (dot-files) and macOS `._` files excluded | Executed | PASS |
| 12 | 12 | System files excluded | Simulated | PASS\* |
| 13 | 13 | Hidden folder (real) and system folder (simulated) skipped | Simulated | PASS\* |
| 14 | 14 | Symbolic link not followed | Executed | PASS (junctions: Windows only) |
| 15 | 15 | Read-only playlists neither updated nor removed; exit 0 | Executed | PASS |
| 16 | 16a | Folder not writable: old playlist byte-identical, no work files, exit 1 | Executed | PASS |
| 16 | 16b | Crash after work file written: old playlist intact, work file removed | Fault-injected | PASS\* |
| 16 | 16c | Swap fails after old file moved aside: old playlist restored | Fault-injected | PASS\* |
| 16 | 16d | Leftovers of a killed run: old ones removed; recent and unrecognised ones kept | Executed | PASS |
| 16 | 16e | Unreadable folder reported and untouched; other folders processed | Executed | PASS |
| 16 | 16f | Listing fails part-way: folder neither rewritten nor cleaned | Fault-injected | PASS\* |
| 17 | 17 | 10,000 files in 1,001 folders; second run changes nothing | Executed | PASS |
| — | 18 | Names starting with `#` or a space written as `.\name` | Executed | PASS |
| — | 19 | Name with an unpaired surrogate reported, not mangled | — | SKIP (NTFS only) |
| — | 20 | Sorting fallback when the helper can't be compiled | Fault-injected | PASS\* |
| — | 21 | Fatal start-up errors exit with code 2; missing root exits 2 | Fault-injected | PASS\* |

## 3. Do the tests detect bugs? (mutation check)

The suite was run against eight deliberately broken copies of v1.0.1. A test suite that passes on broken code proves nothing. All eight are caught.

| Mutation | Caught by |
|---|---|
| Folder hidden check back to "Hidden **and** System" | 13 |
| Old playlist not restored after a failed swap | 16c |
| Untagged (pre-1.0.0) playlists eligible for deletion | 09 |
| `#` names written without `.\` | 18 |
| Folder processed after a failed listing | 16f (this mutation was missed at first; 16f was added to catch it) |
| Read-only check removed | 15 |
| Title/file-name consistency check removed from ownership detection | 08 |
| Earlier draft of the renamed-folder rule ("all listed tracks still present"), which would delete a user's trimmed copy | 09 (the review found it; test extended, rule tightened) |

The earlier v1.0.0 script fails 23 of the 27 tests on Linux. Most of those failures come from one fixed defect: v1.0.0 stops completely when Explorer's sorting function can't be called, which is always the case off Windows.

## 4. Windows PowerShell 5.1 compatibility (static)

PSScriptAnalyzer 1.24.0 checked the code against its bundled **Windows PowerShell 5.1.17763 / .NET Framework 4.8** profile. The rules used were `PSUseCompatibleSyntax`, `PSUseCompatibleCommands` and `PSUseCompatibleTypes`.

| File | Findings |
|---|---|
| Embedded generator script | **0** |
| BAT start-up command | **0** |
| `tests/Run-Tests.ps1` | 1, in the Linux-only reporting branch (`RuntimeInformation.OSDescription`), which never runs on Windows |

This confirms the syntax, commands and .NET members exist in 5.1. It does **not** confirm runtime behaviour.

## 5. Not executed on Linux, and why

All of the following have since run on Windows (§0), except OneDrive, paths over 260 characters and .NET Framework memory measurement:

| What | Why not run here | How it's covered for now |
|---|---|---|
| The BAT run through `cmd.exe` and `powershell.exe` 5.1 | No Windows machine | The same start-up line ran under `pwsh`; static 5.1 analysis passed |
| Explorer sorting (`StrCmpLogicalW`) | Windows-only API; on Linux the fallback ran | The fallback was tested; the Explorer path is unchanged from 1.0.0 apart from a startup self-test |
| Real System attribute (tests 12, 13) | No System attribute on Linux | Simulated |
| NTFS Hidden attribute | Linux treats dot-files as hidden | The same bitwise check, run on real "hidden" items |
| Junctions (test 14) | NTFS only | Symbolic links tested |
| `ReplaceFile` behaviour on NTFS (incl. read-only and hidden targets) | .NET on Linux implements `File.Replace` differently | Partial-failure path fault-injected (16c) |
| Unpaired-surrogate file name (test 19) | Linux names cannot hold one | Code path reviewed only |
| Long paths (> 260 chars) | Windows-specific limit | Documented limitation; failures are reported, not destructive |
| OneDrive Files On-Demand folders | Needs OneDrive | Not covered by automated tests |
| Windows ACL-based permission tests (16a, 16e via `icacls`) | No Windows machine | Same scenarios ran with Unix permissions |
| Memory use under .NET Framework | Different runtime | See §6 for PowerShell 7 |

### How to run the Windows tests

From the repository folder, in **Windows PowerShell 5.1** (no administrator rights needed; symbolic-link tests need Developer Mode or admin and are otherwise reported):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests\Run-Tests.ps1 -Report tests\results\windows-ps51.md
```

The release can be called production-ready when this run shows **0 FAIL** and the result file is committed.

## 6. Performance (Linux, PowerShell 7.5.4, 10,000 empty audio files in 500 album folders)

| Measure | Result |
|---|---|
| First run (500 playlists created) | 4.6–5.1 s |
| Second run (nothing changed, nothing written) | 4.4–5.0 s |
| PowerShell start-up alone | 0.2 s |
| Managed heap after GC, sampled every 100 folders | 4–6 MB, flat, so nothing accumulates |
| Peak process memory | 435 MB (PowerShell 7 runtime; 125 MB on an empty library). This is runtime overhead the .NET GC hasn't handed back, not retained data (see heap row). |

Design points relevant to the brief: each folder is listed once, attributes come from the listing, audio files are never opened, an existing playlist is read once, and unchanged playlists are not rewritten. Sorting happens once per folder. Parallel processing was not added. Runtime is dominated by per-folder PowerShell overhead, not disk I/O, and parallel writes would complicate the safety guarantees.

No baseline comparison with v1.0.0 was possible on Linux, because v1.0.0 stops at the sort step there.
