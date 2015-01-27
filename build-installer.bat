@echo off
@rem Copyright (c) 2013 Greenhost VOF
@rem https://greenhost.nl -\- https://greenhost.io
@rem
@rem This program is free software: you can redistribute it and/or modify
@rem it under the terms of the GNU Affero General Public License as
@rem published by the Free Software Foundation, either version 3 of the
@rem License, or (at your option) any later version.
@rem
@rem This program is distributed in the hope that it will be useful,
@rem but WITHOUT ANY WARRANTY; without even the implied warranty of
@rem MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@rem GNU Affero General Public License for more details.
@rem
@rem You should have received a copy of the GNU Affero General Public License
@rem along with this program. If not, see <http://www.gnu.org/licenses/>.

:build_all

:build_service
echo.
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Building the Viper service...
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd viper
call build.bat

echo test123
:build_client
echo.
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Building the Viper client...
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
cd ..\viper-reference-gui
MSBuild.exe viper-reference-client.sln /p:Configuration=Release

echo.
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Building the Viper client...
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
xcopy systray\bin\Release\* ..\viper\dist\client /s /e /i /y


:build_installer
echo.
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Compiling windows installer...
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd ..
set FOUND=
for %%i in (makensis.exe) do (set FOUND=%%~PATH:i)
IF NOT DEFINED FOUND  (
	echo "!!! NSIS doesn't seem to be installed in your system. I cannot build the Windows installer without it."
) else (
	makensis viper-installer.nsi
)

:end
REM EXIT 0
