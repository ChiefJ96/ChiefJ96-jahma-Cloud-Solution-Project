@echo off
echo Generating Terraform Documentation...

REM Check if terraform-docs is installed
terraform-docs --version >nul 2>&1
if %errorlevel% neq 0 (
    echo terraform-docs is not installed or not in PATH
    echo Please install terraform-docs first:
    echo.
    echo Option 1: Download from https://github.com/terraform-docs/terraform-docs/releases
    echo Option 2: choco install terraform-docs
    echo Option 3: go install github.com/terraform-docs/terraform-docs@latest
    echo.
    pause
    exit /b 1
)

echo Generating main project documentation...
terraform-docs .

echo Generating S3 module documentation...
terraform-docs modules/s3

echo Generating ALB module documentation...
terraform-docs modules/alb

echo.
echo Documentation generated successfully!
echo.
echo Files created/updated:
echo - TERRAFORM-DOCS.md (main project)
echo - modules/s3/README.md
echo - modules/alb/README.md
echo.
pause
