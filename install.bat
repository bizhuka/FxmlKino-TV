@echo off
rem FxmlKino: installs FxmlKino.wgt on a Samsung TV (Russian UI). Double-click.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
if errorlevel 1 pause
