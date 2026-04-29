@echo off
REM Start Flutter web server and open Chrome in one single tab.
cd /d "%~dp0"
start "Flutter Web Server" cmd /k "flutter run -d web-server --web-hostname=localhost --web-port=5000"
timeout /t 4 /nobreak >nul
start "Chrome Notes App" "C:\Program Files\Google\Chrome\Application\chrome.exe" "http://localhost:5000"
