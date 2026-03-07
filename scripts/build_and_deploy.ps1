# Build Flutter web and deploy to Vercel.
# Run from project root: .\scripts\build_and_deploy.ps1
# Or use VS Code task "Build and Deploy".

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $projectRoot

Write-Host "Cleaning Flutter project..." -ForegroundColor Cyan
flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "Flutter clean failed." -ForegroundColor Red
    exit $LASTEXITCODE
}
Write-Host "Building Flutter web..." -ForegroundColor Cyan
flutter build web
if ($LASTEXITCODE -ne 0) {
    Write-Host "Flutter build failed." -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Deploying to Vercel Preview..." -ForegroundColor Cyan
vercel
if ($LASTEXITCODE -ne 0) {
    Write-Host "Vercel deploy failed." -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Deploying to Vercel Prod..." -ForegroundColor Cyan
vercel --prod
if ($LASTEXITCODE -ne 0) {
    Write-Host "Vercel deploy failed." -ForegroundColor Red
    exit $LASTEXITCODE
}
Write-Host "Build and deploy completed." -ForegroundColor Green
