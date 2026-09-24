
@echo off
REM ==== Start Karma (Windows) ====
setlocal
cd /d "%~dp0"
REM Ajuste o caminho abaixo se necessário:
set STACK=AIGAR_STACK\karma

if not exist "%STACK%\karma_core.py" (
  echo [ERRO] Nao encontrei %STACK%\karma_core.py
  pause
  exit /b 1
)

echo Iniciando Karma...
pushd "%STACK%"
py .\karma_core.py
popd
endlocal
