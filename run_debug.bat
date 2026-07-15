@echo off
setlocal
echo ====================================================================
echo   Pulse Share - Windows Path Space Workaround Runner (Debug)
echo ====================================================================
echo.
echo This utility resolves the known Windows/Dart SDK Native Assets bug
echo where path spaces (like "This pc") block compilation of iOS/macOS hooks.
echo.

:: 1. Map User Profile to space-free U: drive
set USER_DRIVE=U:
if exist %USER_DRIVE%\ (
    subst %USER_DRIVE% /d >nul
)
echo [1/4] Mapping User Profile directory to %USER_DRIVE%...
subst %USER_DRIVE% "C:\Users\This pc"

:: 2. Set PUB_CACHE to the space-free virtual path
set PUB_CACHE=%USER_DRIVE%\AppData\Local\Pub\Cache
echo [2/4] Redirecting PUB_CACHE path to %PUB_CACHE%...

:: 3. Map Project Workspace to space-free P: drive
set PROJECT_DRIVE=P:
if exist %PROJECT_DRIVE%\ (
    subst %PROJECT_DRIVE% /d >nul
)
echo [3/4] Mapping Project Workspace directory to %PROJECT_DRIVE%...
subst %PROJECT_DRIVE% "%~dp0"

:: 4. Switch to virtual workspace and run
echo [4/4] Switching current terminal focus to %PROJECT_DRIVE%...
%PROJECT_DRIVE%

echo.
echo ======================== STARTING FLUTTER DEBUG RUN ================
call flutter run
echo ======================== FLUTTER RUN FINISHED ======================
echo.

:: 5. Clean up drive mappings and return
echo Dismounting virtual drives %PROJECT_DRIVE% and %USER_DRIVE%...
cd /d "%~dp0"
subst %PROJECT_DRIVE% /d >nul
subst %USER_DRIVE% /d >nul

echo.
echo Runner complete!
echo ====================================================================
pause
