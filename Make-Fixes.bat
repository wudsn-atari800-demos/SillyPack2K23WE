setlocal
echo off
call Make-Settings.bat
cd %BASE_DIR%

echo Creating and copying fixes

rem SAPRTOOLS have been fixed in the original repo.
set SAPRTOOLS_DIR=C:\jac\system\Atari800\Programming\Repositories\Tools\saprtools\xex
set WILD_DIR=atr\files\WILD
call :cpy %SAPRTOOLS_DIR%\vgm2sapr\stereo\pce-snatcher-cold-sleep.xex %WILD_DIR%\SAPR01.xex
call :cpy %SAPRTOOLS_DIR%\ym2sapr\stereo\7gates-level11.xex %WILD_DIR%\SAPR02.xex
call :cpy %SAPRTOOLS_DIR%\ym2sapr\softbass\enchanted-l1.xex %WILD_DIR%\SAPR03.xex
call :cpy %SAPRTOOLS_DIR%\ym2sapr\softbass\missile-ground0.xex %WILD_DIR%\SAPR04.xex
call :cpy %SAPRTOOLS_DIR%\ym2sapr\mono\burnin.xex %WILD_DIR%\SAPR05.xex
call :cpy %SAPRTOOLS_DIR%\ym2sapr\softbass\xak-dragon.xex %WILD_DIR%\SAPR06.xex
call :cpy %SAPRTOOLS_DIR%\sid2sapr\stereo\huelsbeck-rtype.xex %WILD_DIR%\SAPR07.xex
call :cpy %SAPRTOOLS_DIR%\sid2sapr\softbass\tel-cybernoid.xex %WILD_DIR%\SAPR08.xex
call :cpy %SAPRTOOLS_DIR%\vgm2sapr\stereo\bbc-crazeerider.xex %WILD_DIR%\SAPR09.xex
call :cpy %SAPRTOOLS_DIR%\vgm2sapr\stereo\sg1k-hero.xex %WILD_DIR%\SAPR10.xex
call :cpy %SAPRTOOLS_DIR%\vgm2sapr\stereo\sms-sonic-ghz.xex %WILD_DIR%\SAPR11.xex
call :cpy %SAPRTOOLS_DIR%\vgm2sapr\stereo\gg-hulk.xex %WILD_DIR%\SAPR12.xex
call :cpy %SAPRTOOLS_DIR%\vgm2sapr\stereo\pico-sonicgw.xex %WILD_DIR%\SAPR13.xex
call :cpy %SAPRTOOLS_DIR%\vgm2sapr\stereo\tandy-zeliard.xex %WILD_DIR%\SAPR14.xex
call :cpy %SAPRTOOLS_DIR%\vgm2sapr\stereo\ibmpcjr-crossfire.xex %WILD_DIR%\SAPR15.xex
call :cpy %SAPRTOOLS_DIR%\vgm2sapr\stereo\gb-megaman4-title.xex %WILD_DIR%\SAPR16.xex
call :cpy %SAPRTOOLS_DIR%\vgm2sapr\stereo\gbc-beatmania-hunting.xex %WILD_DIR%\SAPR17.xex
call :cpy %SAPRTOOLS_DIR%\vgm2sapr\stereo\pce-after-burner2.xex %WILD_DIR%\SAPR18.xex

call :cpy       menu\README.txt atr\files\BONUS\README.txt
call :fix       BONUS       README    $2000
call :fix       DEMO        BEEPEMVI
call :fix       DEMO        BONUS
call :fix       GAME        ZDENDADD
call :fix       GAME256     MORSE
call :fix       INTRO16k    WINTERBY
call :fix       INTRO256    RETURNBS
call :fix       INTRO256    ZELAX30
call :fix       INTRO256    SW256
call :fix       MSX         KAMINRO
call :fix       WILD        SAPRTOOL


goto :eof

rem =========
rem Subroutines
rem ==========

:fix_xbios
call :fix %1 %2
%MADS% -s %SOURCE_DIR%\ROOT.asm -o:atr\files\%2.xex
if ERRORLEVEL 1 goto :mads_error
goto :eof

rem Compile fix, clear directory and copy fix
:fix

set SOURCE_DIR=atr\fixes\%1\%2
set ENTRY=%2
set SOURCE_FILE=%2.asm
set SOURCE_LOADER=%2_LOADER.asm
set TARGET_FILE=%2.xex
set TARGET_LOADER=%2_LOADER.xex
set TARGET_DIR=atr\files\%1
set COMPRESS_ADDRESS=%3

echo Fixing %SOURCE_DIR% to %TARGET_DIR%\%TARGET_FILE%
if exist %SOURCE_DIR% goto :fix_dir_exists
echo ERROR: Folder %SOURCE_DIR% does not exist
exit

:fix_dir_exists 
pushd %SOURCE_DIR%
%MADS% -s %SOURCE_FILE% -o:%TARGET_FILE%
if exist %SOURCE_LOADER% (
  %MADS% -s %SOURCE_LOADER% -o:%TARGET_LOADER%
  if ERRORLEVEL 1 goto :mads_error
)
if ERRORLEVEL 1 goto :mads_error
del /S/Q *.lab   2> NUL
del /S/Q *.lst   2> NUL
del /S/Q *.atdbg 2> NUL
popd

rem If a start address is specified, file is packed instead of being copied.
if x==x%COMPRESS_ADDRESS% (
  call :cpy %SOURCE_DIR%\%TARGET_FILE% %TARGET_DIR%\%TARGET_FILE%
) else (
  %EXOMIZER% sfx %COMPRESS_ADDRESS% %SOURCE_DIR%\%TARGET_FILE% -t 168 -o %TARGET_DIR%\%TARGET_FILE% -q
  if ERRORLEVEL 1 goto :exomizer_error
  if NOT ERRORLEVEL 0 goto :exomizer_error
  if exist %SOURCE_DIR%\%TARGET_LOADER% (
    echo Inserting loader %SOURCE_DIR%\%TARGET_LOADER% to %TARGET_FILE%
    ren %TARGET_DIR%\%TARGET_FILE% %TARGET_FILE%.tmp
    copy /b %SOURCE_DIR%\%TARGET_LOADER%+%TARGET_DIR%\%TARGET_FILE%.tmp %TARGET_DIR%\%TARGET_FILE%
    del %TARGET_DIR%\%TARGET_FILE%.tmp
  )
)

rem If there is a matching .txt file, it is copied as well
if exist %SOURCE_DIR%\%ENTRY%.txt call :cpy %SOURCE_DIR%\%ENTRY%.txt %TARGET_DIR%\%ENTRY%.txt
goto :eof

rem Copy single file. The echo commands creates the file, so XCOPY does not ask if file or directory
:cpy
echo Copying %1 to %2
echo Nothing >%2
xcopy /I /Y /Q %1 %2
if ERRORLEVEL 1 goto :copy_error
goto :eof

:mads_error
echo ERROR: MADS compilation errors occurred. Check error messages above.
exit

:exomizer_error
echo ERROR: Exomizer errors occurred. Check error messages above.
exit

:copy_error
echo ERROR: Copy errors occurred. Check error messages above.
exit
