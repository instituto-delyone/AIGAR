
@echo off
REM ==== Copia o arquivo de alinhamento para a inbox (Windows) ====
setlocal
cd /d "%~dp0"

set STACK=AIGAR_STACK
set SRC="%~dp0AIGAR_alignment_boot.jsonl"
set DEST="%STACK%\io\inbox\AIGAR_alignment_boot.jsonl"

if not exist "%STACK%\io\inbox" (
  echo [ERRO] Nao encontrei a pasta "%STACK%\io\inbox"
  pause
  exit /b 1
)

if not exist %SRC% (
  echo [ERRO] Nao encontrei %SRC%
  pause
  exit /b 1
)

copy /Y %SRC% %DEST%
echo [OK] Arquivo copiado para a inbox.
endlocal
