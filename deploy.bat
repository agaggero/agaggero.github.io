@echo off
REM ============================================================
REM   One-click deploy for agaggero.github.io
REM   Double-click this file (or run from terminal) to:
REM     1. Render the Quarto site to docs/
REM     2. Commit any changes with a timestamped message
REM     3. Push to GitHub (site updates live in ~60s)
REM ============================================================

setlocal enabledelayedexpansion

cd /d "%~dp0"
set "PATH=C:\Program Files\Quarto\bin;%PATH%"

echo.
echo ============================================================
echo   Step 1/3: Rendering site with Quarto...
echo ============================================================
quarto render
if errorlevel 1 (
  echo.
  echo *** RENDER FAILED ***
  echo Fix the error above, then run this script again.
  echo.
  pause
  exit /b 1
)

echo.
echo ============================================================
echo   Step 2/3: Committing changes to git...
echo ============================================================
git add -A
git diff --cached --quiet
if errorlevel 1 (
  for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd HH:mm'"`) do set "TIMESTAMP=%%i"
  git commit -m "Update !TIMESTAMP!"
  if errorlevel 1 (
    echo.
    echo *** COMMIT FAILED ***
    pause
    exit /b 1
  )
) else (
  echo No changes since last deploy. Nothing to commit.
  echo.
  pause
  exit /b 0
)

echo.
echo ============================================================
echo   Step 3/3: Pushing to GitHub...
echo ============================================================
git push origin main
if errorlevel 1 (
  echo.
  echo *** PUSH FAILED ***
  echo Check your internet connection and GitHub credentials.
  pause
  exit /b 1
)

echo.
echo ============================================================
echo   SUCCESS! Site will be live in ~60 seconds.
echo   URL: https://agaggero.github.io
echo ============================================================
echo.
pause
