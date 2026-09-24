
@echo off
REM ==== Criptografar/descriptografar arquivo (Windows) ====
REM Preferencia: 7-Zip (AES-256). Se nao houver, avisa.
REM Uso:
REM   encrypt_alignment_windows.bat encrypt AIGAR_alignment_boot.jsonl
REM   encrypt_alignment_windows.bat decrypt AIGAR_alignment_boot.jsonl.7z

setlocal
if "%~1"=="" (
  echo Uso: %~nx0 ^<encrypt|decrypt^> ^<arquivo^>
  exit /b 1
)

set OP=%~1
set FILE=%~2
if "%FILE%"=="" (
  echo [ERRO] informe o arquivo.
  exit /b 1
)

where 7z >nul 2>&1
if errorlevel 1 (
  echo [ERRO] Nao encontrei '7z' no PATH.
  echo Instale o 7-Zip e tente novamente, ou use a versao Linux/macOS com OpenSSL.
  exit /b 1
)

set /p CPF="Digite a SENHA (seu CPF, somente numeros): "

if /I "%OP%"=="encrypt" (
  7z a -p%CPF% -mhe=on "%FILE%.7z" "%FILE%"
  if errorlevel 1 ( echo [ERRO] Falha ao criptografar & exit /b 1 )
  echo [OK] Criado: %FILE%.7z (AES-256) com senha.
  goto :EOF
)

if /I "%OP%"=="decrypt" (
  7z x -p%CPF% "%FILE%"
  if errorlevel 1 ( echo [ERRO] Senha incorreta ou falha ao descriptografar & exit /b 1 )
  echo [OK] Descriptografia concluida.
  goto :EOF
)

echo [ERRO] Operacao invalida. Use encrypt ou decrypt.
endlocal
