@ECHO off
echo Only use this for BUILDING A VERSION TO DISTRIBUTE! DO NOT USE IT FOR TESTING!
pause
cls

cd ..

xcopy ..\src ToCompile /s /e /h

::cd ToCompile
:: Do we need to cd here?
::cd ..

::lovec .

::cd ToCompile
::cd ..\..

:: powershell "$YourDirToCompress='compiled/ToCompile'; $ZipFileResult='Love2D.zip'; $DirToExclude=@('External','CLibraries'); Get-ChildItem $YourDirToCompress  |  where { $_.Name -notin $DirToExclude} | Compress-Archive -DestinationPath $ZipFileResult -Update"

powershell "$YourDirToCompress='src/'; $ZipFileResult='Love2D.zip'; $DirToExclude=@('External','CLibraries'); Get-ChildItem $YourDirToCompress  |  where { $_.Name -notin $DirToExclude} | Compress-Archive -DestinationPath $ZipFileResult -Update"

xcopy src\External dist /s /e /h

rename Love2D.zip Galvanic_Dist.love

copy /b "C:\Program Files\LOVE\love.exe"+Galvanic_Dist.love "dist/win/Galvanic.exe"

del Galvanic_Dist.love

:: cls
echo Make sure to include the DLL's within your love installation directory!
echo Note: Game Icons need to be set via something like Resource hacker!