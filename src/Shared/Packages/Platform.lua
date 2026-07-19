--[[
	General cross-platform functions as used in StudioDream

	
	MIT LICENSE

	Copyright (c) 2026 Bloctans,

	Permission is hereby granted, free of charge, to any person obtaining a copy of
	this software and associated documentation files (the "Software"), to deal in
	the Software without restriction, including without limitation the rights to
	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
	the Software, and to permit persons to whom the Software is furnished to do so,
	subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	Version 1.2
]]
local ffi = require('ffi')

local C = ffi.C
local tinyfiledialog = ffi.load(package.searchpath("tinyfiledialogs64", package.cpath))

ffi.cdef[[
    char * tinyfd_openFileDialog(
	char const * aTitle, /* NULL or "" */
	char const * aDefaultPathAndOrFile, /* NULL or "" , ends with / to set only a directory */
	int aNumOfFilterPatterns , /* 0 (2 in the following example) */
	char const * const * aFilterPatterns, /* NULL or char const * lFilterPatterns[2]={"*.png","*.jpg"}; */
	char const * aSingleFilterDescription, /* NULL or "image files" */
	int aAllowMultipleSelects ) ;

	char const * tinyfd_selectFolderDialog (
	char const * const aTitle ,
	char const * const aDefaultPath ) ;
]]

-- POSIX standard functions that should work on all OS'es (Android, Linux, MacOS, Windows) assuming microsoft decides to not be different for once
ffi.cdef([[
    int execvp(char const* path, const char* argv[]);
]])

local Platform = {}
Platform.Identity = "Unnamed"

-- Get the user/home folder
function Platform.GetHome()
	return love.filesystem.getUserDirectory()
end

function Platform.GetDocuments()
	return Platform.GetHome().."/Documents/"..Platform.Identity
end

-- Given a path, return its absolute path which can then be used in file operations across platforms, ONLY USE FOR FOLDERS!!!!!!
function Platform.ParsePath(Path)
	local FullPath = NativeFS.getFullPath(Path)
	local Info = NativeFS.getInfo(Path)
    
	if Info and Info.type ~= "file" then
		local LastChar = string.sub(FullPath, -1, -1)
		print("Parsing path, Non-formatted full path: "..FullPath)

		if LastChar ~= "/" and LastChar ~= "\\" then
			if love.system.getOS() == "Windows" then
				FullPath = FullPath.."\\"
			else
				FullPath = FullPath.."/"
			end

			printVerbose("FullPath Doesnt have a trailing slash")
			printVerbose("Formatted Mount Point: "..FullPath)
		end
	else
		print("Skipped Parsing Path "..FullPath)
	end

	return FullPath
end

function Platform.Init(Identity)
	Platform.IsWindows = (love.system.getOS() == "Windows")
	Platform.Identity = Identity

	if (not NativeFS) then error("Platform requires NativeFS Package!") end

	local DocumentsFolder = Platform.GetDocuments()

	if (not NativeFS.getInfo(DocumentsFolder)) then
		print("Attempt to create documents folder")
		NativeFS.createDirectory(DocumentsFolder)
	end
end

-- Start a new process and destroy the current one
function Platform.ExecuteAndReplace(...)
	local a = C.execv(Path, nil)
	print(a)
end

-- Start a new process (may freeze current process)
function Platform.Execute(...)
	local Args = table.pack(...)
	local ToExec = table.concat(Args, " ")

	-- we REALLY shouldnt be doing this, but exec force closes the program
	os.execute(ToExec)

	--[[local Args = table.pack(...)
	local ArgsProcessed = {}

	for i, v in pairs(Args) do
		if i ~= "n" then
			table.insert(ArgsProcessed, tostring(v))
		end
	end

	local ArgsC = ffi.new("const char*["..(Args.n+1).."]", ArgsProcessed)
	local a = C.execvp(ArgsC[0], ArgsC)]]
end

-- Open a file or folder on a users and ONLY call Callback IF the user doesnt cancel the prompt
function Platform.OpenWithCallback(Title, Type, Callback)
	local Path = Platform[Type](Title)

	if Path then
		return Callback(Path), Path
	else
		return
	end
end

-- Open a file on a users drive
function Platform.OpenFileDialog(Title)
    local ReturnPathC = tinyfiledialog.tinyfd_openFileDialog(Title, nil, 2, nil, nil, 0) 

	-- I love ffi so much, i love when it crashes on me with no error!
	return (ReturnPathC ~= nil) and ffi.string(ReturnPathC)
end

-- Open a folder on a users drive
function Platform.OpenFolderDialog(Title)
    local ReturnPathC = tinyfiledialog.tinyfd_selectFolderDialog(Title, nil)

	-- I love ffi so much, i love when it crashes on me with no error!
	return (ReturnPathC ~= nil) and ffi.string(ReturnPathC)
end

return Platform