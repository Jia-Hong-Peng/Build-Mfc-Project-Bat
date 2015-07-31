@Echo OFF

REM **************set Variable**********************


set PROGRAM_VER=V1.0.0.0
set BUILD_MKDIR=Build
set LOG_MKDIR=Log
set BUILD_PATH="\MSBuild\12.0\Bin"
set ZIP_PATH="\7-Zip"

@IF EXIST "%ProgramFiles%%BUILD_PATH%" (
  SET MSBuildPath="%ProgramFiles%%BUILD_PATH%"
  SET zipPath="%ProgramFiles%%ZIP_PATH%"
) ELSE IF EXIST "%ProgramFiles(x86)%%BUILD_PATH%" (
  SET MSBuildPath="%ProgramFiles(x86)%%BUILD_PATH%"
  SET zipPath="%ProgramFiles(x86)%%ZIP_PATH%"
)

FOR  %%i in (*.sln) DO (SET SolutionOrProjectPath=%~dp0%%~ni.sln)

set FULLDATE=%date:~0,4%-%date:~5,2%-%date:~8,2%
set FULLTIME=%time:~0,2%%time:~3,2%%time:~6,2%

set hour=%time:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%
set min=%time:~3,2%
if "%min:~0,1%" == " " set min=0%min:~1,1%
set BUILDCODE=%date:~5,2%%date:~8,2%%hour%%min%
Echo "Build code:%BUILDCODE%"


REM **************start build**********************
Echo "Building project using batch file"
Echo Start Time - %Time%

@IF NOT EXIST "%~dp0%BUILD_MKDIR%" (
  MKDIR "%BUILD_MKDIR%"
) 

cd "%BUILD_MKDIR%"
@IF NOT EXIST "%~dp0%BUILD_MKDIR%\%LOG_MKDIR%" (
  MKDIR "%LOG_MKDIR%"
) 

%MSBuildPath%\MSBuild.exe "%SolutionOrProjectPath%" /t:rebuild /p:configuration="Release" >>"%~dp0%BUILD_MKDIR%\%LOG_MKDIR%\Release_%FULLDATE%_%FULLTIME%.txt"

FOR  %%i in ("%~dp0Release\*.exe") DO (SET PROGRAM_NEME=%%~ni)

set PROGRAM_DIR=%PROGRAM_NEME%_%PROGRAM_VER%" "(Build" "%BUILDCODE%)
MKDIR %PROGRAM_DIR%
cd "%~dp0"

copy "%~dp0Release\*.exe" %BUILD_MKDIR%\%PROGRAM_DIR%


%zipPath%\7z.exe a %BUILD_MKDIR%\%PROGRAM_DIR%.7z "%~dp0"%BUILD_MKDIR%\%PROGRAM_DIR%

Echo End Time - %Time%
@pause
exit