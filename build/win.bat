echo Only use this for BUILDING A VERSION TO DISTRIBUTE! DO NOT USE IT FOR TESTING!
pause

cd ..

powershell "$YourDirToCompress='src/'; $ZipFileResult='Love2D.zip'; $DirToExclude=@('External','CLibraries'); Get-ChildItem $YourDirToCompress  |  where { $_.Name -notin $DirToExclude} | Compress-Archive -DestinationPath $ZipFileResult -Update"

xcopy src\CLibraries\windows dist\win /s /e /h

rename Love2D.zip StudioDream.love

copy /b "C:\Program Files\LOVE\love.exe"+StudioDream.love "dist/win/StudioDream.exe"

del StudioDream.love

echo Make sure to include the DLL's in your love installation directory within dist/win!
echo Note: Game Icons need to be set via something like Resource hacker!