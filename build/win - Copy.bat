echo Only use this for BUILDING A VERSION TO DISTRIBUTE! DO NOT USE IT FOR TESTING!
pause

cd ..

powershell "$YourDirToCompress='src/'; $ZipFileResult='Love2D.zip'; $DirToExclude=@('External','CLibraries'); Get-ChildItem $YourDirToCompress  |  where { $_.Name -notin $DirToExclude} | Compress-Archive -DestinationPath $ZipFileResult -Update"

xcopy src\External dist /s /e /h
xcopy src\CLibraries\windows dist /s /e /h

rename Love2D.zip Galvanic_Dist.love

copy /b "C:\Program Files\LOVE\love.exe"+Galvanic_Dist.love "dist/Galvanic.exe"

del Galvanic_Dist.love

echo Make sure to include the DLL's within your love installation directory!
echo Note: Game Icons need to be set via something like Resource hacker!