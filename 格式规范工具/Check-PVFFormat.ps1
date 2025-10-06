# PVF File Format Checker (PowerShell Version)
# Check if PVF files conform to strict formatting requirements

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,
    
    [switch]$Recursive,
    
    [switch]$ShowDetails
)

function Test-PVFFormat {
    param(
        [string]$FilePath
    )
    
    $errors = @()
    $warnings = @()
    
    try {
        $lines = Get-Content $FilePath -Encoding UTF8 -ErrorAction Stop
    }
    catch {
        try {
            $lines = Get-Content $FilePath -Encoding Default -ErrorAction Stop
            $warnings += "File may not be UTF-8 encoded"
        }
        catch {
            $errors += "Cannot read file: $($_.Exception.Message)"
            return @{
                Errors = $errors
                Warnings = $warnings
            }
        }
    }
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $lineNumber = $i + 1
        $line = $lines[$i]
        
        # Skip empty lines and comments
        if ([string]::IsNullOrWhiteSpace($line) -or $line.Trim().StartsWith('#')) {
            continue
        }
        
        # Check 1: Space indentation
        if ($line -match '^[ ]+[^[ ]') {
            $errors += "Line $lineNumber : Uses space indentation, should use TAB"
            $errors += "  Content: $line"
        }
        
        # Check 2: Wrong quotes
        if ($line -match '"[^"]*"' -or $line -match "'[^']*'") {
            $errors += "Line $lineNumber : Uses wrong quotes, should use backticks"
            $errors += "  Content: $line"
        }
        
        # Check 3: Backtick pairing
        if ($line.Contains('`')) {
            $backtickCount = ($line.ToCharArray() | Where-Object { $_ -eq '`' }).Count
            if ($backtickCount % 2 -ne 0) {
                $errors += "Line $lineNumber : Unpaired backticks"
                $errors += "  Content: $line"
            }
        }
        
        # Check 4: Tag format
        if ($line.Trim().StartsWith('[') -and $line.Trim().EndsWith(']')) {
            $tagContent = $line.Trim().Substring(1, $line.Trim().Length - 2)
            if ($tagContent.StartsWith(' ') -or $tagContent.EndsWith(' ')) {
                $errors += "Line $lineNumber : Tag has extra spaces"
                $errors += "  Content: $line"
            }
        }
        
        # Check 5: Parameter separation
        if ($line.Contains("`t") -and -not $line.Trim().StartsWith('[')) {
            # Check for mixed space and TAB
            if ($line -match "`t.*[ ]+.*`t" -or $line -match "[ ]+.*`t") {
                $warnings += "Line $lineNumber : May mix spaces and TABs"
                $warnings += "  Content: $line"
            }
        }
        
        # Check 6: Number format
        if ($line -match '`\d+`') {
            $warnings += "Line $lineNumber : Number wrapped in quotes, may be incorrect"
            $warnings += "  Content: $line"
        }
    }
    
    return @{
        Errors = $errors
        Warnings = $warnings
    }
}

function Get-PVFFiles {
    param(
        [string]$Path,
        [bool]$Recursive
    )
    
    $extensions = @('*.stk', '*.equ', '*.pvf')
    $files = @()
    
    if (Test-Path $Path -PathType Leaf) {
        # Single file
        if ($Path -match '\.(stk|equ|pvf)$') {
            $files += $Path
        }
    }
    elseif (Test-Path $Path -PathType Container) {
        # Directory
        foreach ($ext in $extensions) {
            if ($Recursive) {
                $files += Get-ChildItem -Path $Path -Filter $ext -Recurse | Select-Object -ExpandProperty FullName
            }
            else {
                $files += Get-ChildItem -Path $Path -Filter $ext | Select-Object -ExpandProperty FullName
            }
        }
    }
    
    return $files
}

function Write-Results {
    param(
        [hashtable]$Results
    )
    
    $totalFiles = $Results.Count
    $filesWithErrors = 0
    $filesWithWarnings = 0
    $totalErrors = 0
    $totalWarnings = 0
    
    foreach ($file in $Results.Keys) {
        $result = $Results[$file]
        $errors = $result.Errors
        $warnings = $result.Warnings
        
        if ($errors.Count -gt 0) {
            $filesWithErrors++
            $totalErrors += $errors.Count
        }
        
        if ($warnings.Count -gt 0) {
            $filesWithWarnings++
            $totalWarnings += $warnings.Count
        }
        
        if ($errors.Count -gt 0 -or $warnings.Count -gt 0) {
            Write-Host "`nFile: $file" -ForegroundColor Cyan
            Write-Host ("=" * 80) -ForegroundColor Gray
            
            if ($errors.Count -gt 0) {
                Write-Host "ERRORS:" -ForegroundColor Red
                foreach ($error in $errors) {
                    Write-Host "  $error" -ForegroundColor Red
                }
            }
            
            if ($warnings.Count -gt 0) {
                Write-Host "WARNINGS:" -ForegroundColor Yellow
                foreach ($warning in $warnings) {
                    Write-Host "  $warning" -ForegroundColor Yellow
                }
            }
        }
    }
    
    # Print summary
    Write-Host "`n$("=" * 80)" -ForegroundColor Gray
    Write-Host "CHECK SUMMARY" -ForegroundColor Cyan
    Write-Host ("=" * 80) -ForegroundColor Gray
    Write-Host "Total files: $totalFiles"
    Write-Host "Files with errors: $filesWithErrors" -ForegroundColor $(if ($filesWithErrors -gt 0) { "Red" } else { "Green" })
    Write-Host "Files with warnings: $filesWithWarnings" -ForegroundColor $(if ($filesWithWarnings -gt 0) { "Yellow" } else { "Green" })
    Write-Host "Total errors: $totalErrors" -ForegroundColor $(if ($totalErrors -gt 0) { "Red" } else { "Green" })
    Write-Host "Total warnings: $totalWarnings" -ForegroundColor $(if ($totalWarnings -gt 0) { "Yellow" } else { "Green" })
    
    if ($totalErrors -eq 0) {
        Write-Host "All files passed format check!" -ForegroundColor Green
    }
    else {
        Write-Host "Format errors found, please fix and recheck" -ForegroundColor Red
    }
}

# Main program
Write-Host "PVF File Format Checker" -ForegroundColor Cyan
Write-Host ("=" * 80) -ForegroundColor Gray

if (-not (Test-Path $Path)) {
    Write-Host "Path does not exist: $Path" -ForegroundColor Red
    exit 1
}

$files = Get-PVFFiles -Path $Path -Recursive $Recursive

if ($files.Count -eq 0) {
    Write-Host "No PVF files found (.stk, .equ, .pvf)" -ForegroundColor Red
    exit 1
}

$results = @{}

foreach ($file in $files) {
    if ($ShowDetails) {
        Write-Host "Checking file: $file" -ForegroundColor Gray
    }
    $results[$file] = Test-PVFFormat -FilePath $file
}

Write-Results -Results $results