echo off
set BIOUTPUT=1

if exist a3 (
  rmdir a3
)
mklink /j a3 include\a3

mkdir z
mkdir z\acp
if exist z\acp\addons (
  rmdir z\acp\addons
)
mklink /j z\acp\addons addons

hemtt.exe release
set BUILD_STATUS=%errorlevel%

rmdir a3
rmdir z\acp\addons
rmdir z\acp
rmdir z

if %BUILD_STATUS% neq 0 (
  echo Build failed
  exit /b %errorlevel%
) else (
  echo Build successful
  EXIT
)
