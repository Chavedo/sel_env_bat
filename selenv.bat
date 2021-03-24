@echo off

REM inicio setlocal
:inicio
setlocal enableDelayedExpansion
cd "%dir_ent%"
echo --------------------------------
echo Escribe el numero del entorno a activar:
REM listado de entornos, solo directorios
set /a ID=1
for /f "delims=" %%G in ('dir /A:D /b') do (
	set entorno[!ID!]=%%~G
	set /a ID+=1
)
set entorno

REM input id
set /a var= "null"
echo --------------------------------
echo.
set /p var= ^>

REM verifiacion existencia entorno
if %var% GTR 0 (
    if %var% LSS %ID% (
	   set sel_entorno=!entorno[%var%]!
    ) else (goto :create)
) else (goto :create)

REM guardo la variable local en la misma linea para que sea global
(
endlocal
set sel_ent=%sel_entorno%
goto :activate
)

REM seleccion ruta entornos
:select_dir_ent
echo Ingrese la ruta de la carpeta Entornos:
set /p dir_ent= ^>
if exist "%dir_ent%" (
	goto :inicio
) else (
	echo No exite esa direccion
	goto :select_dir_ent
)


REM choice crear nuevo entorno
:create
echo No existe el entorno %var%
choice /c YNC /n /m "Crear un nuevo entorno [Y/N]? - Cambiar de carpeta [C]"
if %ERRORLEVEL% EQU 1 (goto :add_env)
if %ERRORLEVEL% EQU 2 (goto :inicio)
if %ERRORLEVEL% EQU 3 (goto :select_dir_ent)

REM crear nuevo entorno
:add_env
setlocal
echo Ingrese el nombre del entorno a crear:
set /p new_env= ^>
cd "%dir_ent%"
virtualenv %new_env%
echo --ENTORNO %new_env% CREADO CORRECTAMENTE--
goto :inicio

REM activar entorno existente
:activate
cd "%dir_ent%%sel_ent%\Scripts"
call activate.bat
goto :eof

REM extra, carpeta django proyects
:ruta_django
rem cd "C:\Users\mariano\Documents\ProyectosDjango"
rem echo --Entorno %sel_ent% activado--
rem goto :eof