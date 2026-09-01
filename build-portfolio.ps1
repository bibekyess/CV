# Builds portfolio.html and portfolio_bibek.pdf from portfolio.md.
#
#   .\build-portfolio.ps1
#
# portfolio.md is the only file to edit. The two outputs are generated - don't
# hand-edit them, your changes will be overwritten on the next build.
#
# Requires: pandoc (https://pandoc.org) and Google Chrome.
# Chrome does the PDF rendering, so no LaTeX install is needed.

$ErrorActionPreference = 'Stop'

$root = $PSScriptRoot
$src = Join-Path $root 'portfolio.md'
$html = Join-Path $root 'portfolio.html'
$pdf = Join-Path $root 'portfolio_bibek.pdf'

if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
  throw "pandoc not found on PATH. Install from https://pandoc.org/installing.html"
}

$chrome = @(
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
  "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $chrome) { throw "Could not find chrome.exe in any of the usual install locations." }

# 1. Markdown -> standalone HTML
Write-Host "Building portfolio.html ..." -ForegroundColor Cyan
pandoc $src `
  --standalone `
  --from gfm+yaml_metadata_block+smart `
  --to html5 `
  --css 'css/portfolio.css' `
  --toc --toc-depth=2 `
  --metadata lang=en `
  --output $html
if ($LASTEXITCODE -ne 0) { throw "pandoc failed with exit code $LASTEXITCODE" }

# 2. HTML -> PDF via headless Chrome
Write-Host "Building portfolio_bibek.pdf ..." -ForegroundColor Cyan
$uri = ([System.Uri]$html).AbsoluteUri
& $chrome `
  --headless `
  --disable-gpu `
  --no-first-run `
  --no-pdf-header-footer `
  --virtual-time-budget=5000 `
  "--print-to-pdf=$pdf" `
  $uri | Out-Null

if (-not (Test-Path $pdf)) { throw "Chrome did not produce $pdf" }

$pages = 'unknown'
if (Get-Command python -ErrorAction SilentlyContinue) {
  try {
    $pages = python -c "import pypdf,sys; print(len(pypdf.PdfReader(sys.argv[1]).pages))" $pdf 2>$null
  }
  catch { }
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
Write-Host ("  portfolio.html        {0,8:N0} bytes" -f (Get-Item $html).Length)
Write-Host ("  portfolio_bibek.pdf   {0,8:N0} bytes, {1} pages" -f (Get-Item $pdf).Length, $pages)
