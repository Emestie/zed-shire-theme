param(
    [string]$ThemeFile = (Join-Path $PSScriptRoot "..\themes\shire.json")
)

$ErrorActionPreference = "Stop"
$failed = $false

function Fail([string]$message) {
    Write-Host "  FAIL $message" -ForegroundColor Red
    $script:failed = $true
}

Write-Host "Checking $ThemeFile"

# 1. Valid JSON
try {
    $theme = Get-Content $ThemeFile -Raw | ConvertFrom-Json
} catch {
    Fail "not valid JSON: $($_.Exception.Message)"
    exit 1
}

# 2. Required family keys
foreach ($key in @("name", "author", "themes")) {
    if (-not $theme.PSObject.Properties.Name.Contains($key)) { Fail "missing family key '$key'" }
}

# 3. Every color string must be #RGB, #RRGGBB or #RRGGBBAA
$hexColors = [regex]'^#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$'
$colorProps = @()
foreach ($entry in $theme.themes) {
    if (-not $entry.name) { Fail "a theme has no name" }
    if ($entry.appearance -notin @("dark", "light")) { Fail "theme '$($entry.name)' has appearance '$($entry.appearance)'" }
    foreach ($prop in $entry.style.PSObject.Properties) {
        if ($prop.Name -eq "syntax" -or $prop.Name -eq "background.appearance") { continue }
        if ($prop.Value -is [string]) {
            $colorProps += [pscustomobject]@{ Where = $prop.Name; Value = $prop.Value }
        } elseif ($prop.Name -eq "accents") {
            foreach ($accent in $prop.Value) {
                $colorProps += [pscustomobject]@{ Where = "accents[]"; Value = $accent }
            }
        } elseif ($prop.Name -eq "players") {
            foreach ($player in $prop.Value) {
                foreach ($slot in @("background", "cursor", "selection")) {
                    $colorProps += [pscustomobject]@{ Where = "players[].$slot"; Value = $player.$slot }
                }
            }
        }
    }
    foreach ($syntaxProp in $entry.style.syntax.PSObject.Properties) {
        $colorProps += [pscustomobject]@{ Where = "syntax.$($syntaxProp.Name)"; Value = $syntaxProp.Value.color }
    }
}
foreach ($c in $colorProps) {
    if ($c.Value -isnot [string] -or $c.Value -notmatch $hexColors) {
        Fail "$($c.Where) = '$($c.Value)' is not a hex color"
    }
}

# 4. Report
if ($failed) { exit 1 }
$count = ($colorProps | Measure-Object).Count
Write-Host "  OK  $($theme.themes.Count) theme(s), $count color values, all valid hex." -ForegroundColor Green
