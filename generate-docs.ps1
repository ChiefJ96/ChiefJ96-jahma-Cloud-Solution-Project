# Generate Terraform Documentation
Write-Host "Generating Terraform Documentation..." -ForegroundColor Green

# Check if terraform-docs is installed
try {
    $version = & ".\terraform-docs.exe" --version 2>$null
    Write-Host "terraform-docs version: $version" -ForegroundColor Yellow
} catch {
    Write-Host "terraform-docs.exe not found in current directory" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please ensure terraform-docs.exe is in the current directory" -ForegroundColor Yellow
    Write-Host "Download from: https://github.com/terraform-docs/terraform-docs/releases"
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Generating main project documentation..." -ForegroundColor Cyan
& ".\terraform-docs.exe" .

Write-Host "Generating S3 module documentation..." -ForegroundColor Cyan
& ".\terraform-docs.exe" modules/s3

Write-Host "Generating ALB module documentation..." -ForegroundColor Cyan
& ".\terraform-docs.exe" modules/alb

Write-Host "Generating VPC module documentation..." -ForegroundColor Cyan
& ".\terraform-docs.exe" modules/vpc

Write-Host "Generating IAM module documentation..." -ForegroundColor Cyan
& ".\terraform-docs.exe" modules/iam

Write-Host "Generating Auto Scaling module documentation..." -ForegroundColor Cyan
& ".\terraform-docs.exe" modules/auto_scaling

Write-Host ""
Write-Host "Documentation generated successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Files created/updated:" -ForegroundColor Yellow
Write-Host "- TERRAFORM-DOCS.md (main project)"
Write-Host "- modules/s3/README.md"
Write-Host "- modules/alb/README.md"
Write-Host "- modules/vpc/TERRAFORM-DOCS.md"
Write-Host "- modules/iam/TERRAFORM-DOCS.md"
Write-Host "- modules/auto_scaling/TERRAFORM-DOCS.md"
Write-Host ""
Read-Host "Press Enter to continue"
