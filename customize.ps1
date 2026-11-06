param(
  [string]$ConfigFile = "profile-config.json"
)

$baseDir = $PSScriptRoot
if (-not $baseDir) { $baseDir = Get-Location }

$configPath = Join-Path $baseDir $ConfigFile
if (-not (Test-Path $configPath)) {
  Write-Error "Config file not found: $configPath"
  exit 1
}

$cfg = Get-Content $configPath -Raw -Encoding UTF8 | ConvertFrom-Json
Write-Host "Applying profile settings for: $($cfg.full_name) (@$($cfg.github_username))" -ForegroundColor Cyan

# 1. Update README.md
$readmePath = Join-Path $baseDir "README.md"
if (Test-Path $readmePath) {
  $readme = Get-Content $readmePath -Raw -Encoding UTF8
  # Replace usernames and URLs
  $readme = $readme -replace 'Sandeepa-git', $cfg.github_username
  $readme = $readme -replace 'sandeepa-git', $cfg.github_username.ToLower()
  $readme = $readme -replace 'Sandeepa Wimalasiri', $cfg.full_name
  $readme = $readme -replace 'sandeepa\.online', $cfg.domain
  $readme = $readme -replace 'https://sandeepa\.online', $cfg.website_url
  $readme = $readme -replace 'https://www.linkedin.com/in/sandeepa-wimalasiri/', $cfg.linkedin_url
  [System.IO.File]::WriteAllText($readmePath, $readme, [System.Text.Encoding]::UTF8)
  Write-Host "✓ Updated README.md" -ForegroundColor Green
}

# 2. Update assets/hero.svg
$heroPath = Join-Path $baseDir "assets\hero.svg"
if (Test-Path $heroPath) {
  $hero = Get-Content $heroPath -Raw -Encoding UTF8
  $hero = $hero -replace 'Sandeepa Wimalasiri — Cloud and Full-Stack Engineer', "$($cfg.full_name) — $($cfg.role_title)"
  $hero = $hero -replace 'SANDEEPA\.ONLINE', $cfg.domain.ToUpper()
  $hero = $hero -replace 'LK · UTC\+05:30 · OPEN FOR FREELANCE', "$($cfg.location) · $($cfg.timezone) · $($cfg.status_text)"
  $hero = $hero -replace '>Sandeepa<', ">$($cfg.first_name)<"
  $hero = $hero -replace '>Wimalasiri<', ">$($cfg.last_name)<"
  $hero = $hero -replace '>Cloud &amp; Full-Stack Engineer<', ">$($cfg.role_title)<"
  $hero = $hero -replace '>Web apps · AI chatbots · DevOps · Online stores<', ">$($cfg.role_subtitle)<"
  $hero = $hero -replace '>Microsoft Student Amb\.<', ">$($cfg.badge_1)<"
  $hero = $hero -replace '>Azure · AWS<', ">$($cfg.badge_2)<"
  $hero = $hero -replace '>Next\.js<', ">$($cfg.badge_3)<"
  $hero = $hero -replace '10\+ real-world projects shipped', $cfg.highlight_1
  $hero = $hero -replace 'Writing at sandeepa\.online/blog', $cfg.highlight_2
  $hero = $hero -replace '~/sandeepa — zsh', "~/$(($cfg.terminal_user).ToLower()) — zsh"
  $hero = $hero -replace 'sandeepa — builds things for the web &amp; cloud', $cfg.terminal_whoami
  $hero = $hero -replace 'ready to build · sandeepa\.online/#contact', "ready to build · $($cfg.hire_link)"
  [System.IO.File]::WriteAllText($heroPath, $hero, [System.Text.Encoding]::UTF8)
  Write-Host "✓ Updated assets/hero.svg" -ForegroundColor Green
}

# 3. Update assets/connect.svg
$connectPath = Join-Path $baseDir "assets\connect.svg"
if (Test-Path $connectPath) {
  $connect = Get-Content $connectPath -Raw -Encoding UTF8
  $connect = $connect -replace 'sandeepa\.online', $cfg.domain
  [System.IO.File]::WriteAllText($connectPath, $connect, [System.Text.Encoding]::UTF8)
  Write-Host "✓ Updated assets/connect.svg" -ForegroundColor Green
}

Write-Host "`nCustomization complete! Open preview.html to view your changes." -ForegroundColor Yellow

