@echo off
setlocal
title M3U8 Playlist Generator

rem The BAT file's own directory is the library root.
set "M3U8_ROOT=%~dp0"
set "M3U8_BATCH=%~f0"

echo ========================================
echo       M3U8 PLAYLIST GENERATOR
echo ========================================
echo.

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$text = [System.IO.File]::ReadAllText($env:M3U8_BATCH); $marker = '#<POWERSHELL>'; $index = $text.LastIndexOf($marker); if ($index -lt 0) { throw 'Embedded PowerShell section not found.' }; $code = $text.Substring($index + $marker.Length); & ([scriptblock]::Create($code))"
set "RESULT=%ERRORLEVEL%"

echo.
if not "%RESULT%"=="0" (
    echo Completed with errors. Check the warnings above.
) else (
    echo Completed successfully.
)
echo.
pause
exit /b %RESULT%
#<POWERSHELL>
$ErrorActionPreference = 'Stop'

$Root = [System.IO.Path]::GetFullPath($env:M3U8_ROOT)
if (-not [System.IO.Directory]::Exists($Root)) {
    throw "Root folder does not exist: $Root"
}

$Extensions = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
@('.mp3','.flac','.wav','.aac','.m4a','.ogg','.opus','.wma','.aiff','.aif') | ForEach-Object { [void]$Extensions.Add($_) }

if (-not ('M3U8NaturalFileSorter' -as [type])) {
    $source = @'
using System;
using System.IO;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public sealed class M3U8NaturalFileSorter : IComparer<string>
{
    [DllImport("shlwapi.dll", CharSet = CharSet.Unicode)]
    private static extern int StrCmpLogicalW(string x, string y);
    public int Compare(string x, string y)
    {
        return StrCmpLogicalW(Path.GetFileName(x), Path.GetFileName(y));
    }
}
'@
    Add-Type -TypeDefinition $source -ErrorAction Stop
}

$Sorter = [M3U8NaturalFileSorter]::new()
$Directories = [System.Collections.Generic.Stack[string]]::new()
$Directories.Push($Root)
$Utf8 = [System.Text.UTF8Encoding]::new($false)

$Folders = 0
$Tracks = 0
$Created = 0
$Updated = 0
$Unchanged = 0
$Errors = 0

Write-Host "Root: $Root" -ForegroundColor Cyan

while ($Directories.Count -gt 0) {
    $Folder = $Directories.Pop()
    $Folders++

    # Discover child directories; do not follow junctions or symbolic links.
    try {
        $DirEnum = [System.IO.Directory]::EnumerateDirectories($Folder).GetEnumerator()
        try {
            while ($DirEnum.MoveNext()) {
                $Child = $DirEnum.Current
                try {
                    $Attributes = [System.IO.File]::GetAttributes($Child)
                    if (($Attributes -band [System.IO.FileAttributes]::ReparsePoint) -eq 0) {
                        $Directories.Push($Child)
                    }
                }
                catch {
                    $Errors++
                    Write-Warning "Cannot inspect directory: $Child : $_"
                }
            }
        }
        catch {
            $Errors++
            Write-Warning "Directory enumeration failed: $Folder : $_"
        }
        finally { $DirEnum.Dispose() }
    }
    catch {
        $Errors++
        Write-Warning "Cannot access directories in: $Folder : $_"
    }

    # Collect files. If enumeration fails part-way through, skip this folder
    # rather than writing an incomplete playlist.
    $Files = [System.Collections.Generic.List[string]]::new()
    $FileScanOK = $true
    try {
        $FileEnum = [System.IO.Directory]::EnumerateFiles($Folder).GetEnumerator()
        try {
            while ($FileEnum.MoveNext()) {
                $File = $FileEnum.Current
                $Extension = [System.IO.Path]::GetExtension($File)
                if ($Extensions.Contains($Extension)) {
                    $Files.Add($File)
                }
            }
        }
        catch {
            $FileScanOK = $false
            $Errors++
            Write-Warning "File enumeration failed; folder skipped: $Folder : $_"
        }
        finally { $FileEnum.Dispose() }
    }
    catch {
        $FileScanOK = $false
        $Errors++
        Write-Warning "Cannot access files in: $Folder : $_"
    }

    if (-not $FileScanOK -or $Files.Count -eq 0) { continue }

    $FileArray = $Files.ToArray()
    [Array]::Sort($FileArray, $Sorter)

    $Lines = [System.Collections.Generic.List[string]]::new()
    [void]$Lines.Add('#EXTM3U')
    foreach ($File in $FileArray) {
        $Name = [System.IO.Path]::GetFileName($File)
        $Title = [System.IO.Path]::GetFileNameWithoutExtension($File)
        [void]$Lines.Add("#EXTINF:-1,$Title")
        [void]$Lines.Add($Name)
    }

    $Leaf = [System.IO.Path]::GetFileName($Folder.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar))
    if ([string]::IsNullOrWhiteSpace($Leaf)) { $Leaf = 'playlist' }
    $Output = [System.IO.Path]::Combine($Folder, "$Leaf.m3u8")
    $Content = [string]::Join([Environment]::NewLine, $Lines) + [Environment]::NewLine
    $Temp = "$Output.$([guid]::NewGuid().ToString('N')).tmp"

    try {
        if ([System.IO.File]::Exists($Output)) {
            $Existing = [System.IO.File]::ReadAllText($Output)
            if ($Existing -ceq $Content) {
                $Unchanged++
                $Tracks += $FileArray.Count
                continue
            }

            [System.IO.File]::WriteAllText($Temp, $Content, $Utf8)
            [System.IO.File]::Replace($Temp, $Output, $null)
            $Updated++
        }
        else {
            [System.IO.File]::WriteAllText($Temp, $Content, $Utf8)
            [System.IO.File]::Move($Temp, $Output)
            $Created++
        }

        $Tracks += $FileArray.Count
        Write-Host "Written: $Output ($($FileArray.Count) tracks)" -ForegroundColor Green
    }
    catch {
        $Errors++
        Write-Warning "Playlist write failed: $Output : $_"
    }
    finally {
        if ([System.IO.File]::Exists($Temp)) {
            try { [System.IO.File]::Delete($Temp) }
            catch { $Errors++; Write-Warning "Could not remove temporary file: $Temp" }
        }
    }
}

Write-Host ''
Write-Host '========================================' -ForegroundColor Cyan
Write-Host '       GENERATION COMPLETE' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host "Folders scanned : $Folders"
Write-Host "Tracks indexed  : $Tracks"
Write-Host "Created         : $Created"
Write-Host "Updated         : $Updated"
Write-Host "Unchanged       : $Unchanged"
Write-Host "Errors          : $Errors"
Write-Host '========================================' -ForegroundColor Cyan

if ($Errors -gt 0) { exit 1 } else { exit 0 }
