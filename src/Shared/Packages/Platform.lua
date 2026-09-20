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

	Version 1.3
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

local IsStupid = (love.system.getOS() == 'Windows')

local exec

if IsStupid then
	print("Defining stupid mode headers")

	-- Sorry and thank you https://github.com/NoxiousPluK/obs-call-webhook/blob/main/call_webhook.lua, I REALLY dont wanna touch ffi so i just had to steal this
	ffi.cdef [[
		typedef void* HANDLE;
		typedef int    BOOL;
		typedef struct {
			unsigned long  cb;
			char          *lpReserved, *lpDesktop, *lpTitle;
			unsigned long  dwX, dwY, dwXSize, dwYSize;
			unsigned long  dwXCountChars, dwYCountChars, dwFillAttribute, dwFlags;
			unsigned short wShowWindow, cbReserved2;
			unsigned char *lpReserved2;
			HANDLE         hStdInput, hStdOutput, hStdError;
		} STARTUPINFOA;
		typedef struct {
			HANDLE hProcess, hThread;
			unsigned long dwProcessId, dwThreadId;
		} PROCESS_INFORMATION;
		BOOL CreateProcessA(
			const char *lpApplicationName, char *lpCommandLine,
			void *lpProcessAttributes, void *lpThreadAttributes,
			BOOL bInheritHandles, unsigned long dwCreationFlags,
			void *lpEnvironment, const char *lpCurrentDirectory,
			STARTUPINFOA *lpStartupInfo, PROCESS_INFORMATION *lpProcessInformation
		);
		BOOL CloseHandle(HANDLE hObject);
	]]
	
	exec = function(cmd)
		local si = ffi.new("STARTUPINFOA")
		si.cb = ffi.sizeof("STARTUPINFOA")
		local pi = ffi.new("PROCESS_INFORMATION")
		local buf = ffi.new("char[?]", #cmd + 1, cmd)
		local ok = ffi.C.CreateProcessA(nil, buf, nil, nil, false, 0, nil, nil, si, pi)
		if ok ~= 0 then
			ffi.C.CloseHandle(pi.hProcess)
			ffi.C.CloseHandle(pi.hThread)
		end
	end
else
	-- POSIX standard functions that should work on all OS'es (Android, Linux, MacOS, Stupid) assuming stupid decides to not be different for once
	-- (Microsoft was different GOD FUCKING DAMNNIT, FUCK YOU MICROSOFT)
	ffi.cdef([[
		int execv(const char *path, char *const argv[]);
		int fork();
		int getpid();
	]])

	exec = function(cmd)
		local a = C.execv(cmd, nil)
	end
end


local Platform = {}
Platform.Identity = "Unnamed"

-- Get the user/home folder
function Platform.GetHome()
	return love.filesystem.getUserDirectory()
end

-- TODO: Use windows registry and linux xdg entries
function Platform.GetDocuments()
	return Platform.GetHome().."/Documents/"..Platform.Identity
end

--[[
	Linux:
		MIME types to globs: $XDG_DATA_DIRS/mime/globs2
		MIME file associations: https://specifications.freedesktop.org/mime-apps/latest/file.html

	
]]
function Platform.GetAssociation()
	
end

-- Start a new process and destroy the current one
-- bloctans is stupid he says
function Platform.ExecuteAndReplace(Path)
	exec(Path)
	love.event.quit()
end

function Platform.PathFriendly(Name)
	local Replaced = string.gsub(Name, "[!%.,\\/]", "")

	if Replaced == "" then
		return "InvalidName"
	else
		return Replaced
	end
end

-- Given a path, return its absolute path which can then be used in file operations across platforms
function Platform.ParsePath(Path)
	local FullPath = NativeFS.getFullPath(Path) or Path
	FullPath = string.gsub(FullPath, "\\", "/") -- Fix stupid paths

	local Info = NativeFS.getInfo(FullPath)

	-- If we havent gotten a file from the initial one, try without the proceeding slash
	if (not Info) and string.sub(FullPath, -1, -1) == "/" then
		FullPath = string.sub(FullPath, 1, -2)
		Info = NativeFS.getInfo(FullPath)
	end

	-- Now check if the file is a symlink
	-- TODO: Idk if this is the best idea
	if Info and Info.type == "symlink" then
		local InfoDir = NativeFS.getInfo(FullPath.."/")

		-- if we get a directory by including the proceeding slash, then that is our file
		if InfoDir then
			Info = InfoDir
		else -- otherwise, this symlink is most likely a file
			Info.type = "file"
		end
	end

	if Info and Info.type ~= "file" then
		local LastChar = string.sub(FullPath, -1, -1)
		print("Parsing path, Non-formatted full path: "..FullPath)

		if LastChar ~= "/" then
			FullPath = FullPath.."/"
		end
	else
		print("Skipped Parsing Path "..FullPath)
	end

	print("Formatted Path: "..FullPath)

	return FullPath
end

function Platform.Init(Identity)
	Platform.IsWindows = IsStupid
	Platform.Identity = Identity

	love.filesystem.setSymlinksEnabled(true)

	if (not NativeFS) then error("Platform requires NativeFS Package!") end

	local DocumentsFolder = Platform.GetDocuments()

	if (not NativeFS.getInfo(DocumentsFolder)) then
		print("Attempt to create documents folder")
		NativeFS.createDirectory(DocumentsFolder)
	end
end

-- Start a new process (may freeze current process)
function Platform.Execute(File, ...)
	-- we REALLY shouldnt be doing this, but exec force closes the program
	
	if IsStupid then
		exec(table.concat({...}, " "))
	else
		local ProcessID = C.fork()
		print("Forked with Process ID "..ProcessID)

		if ProcessID == 0 then
			local Args = {File, ...}

			print("Executing")

			-- Stolen from https://github.com/bryanthaboi/gen1recomp/blob/dev/src/core/HostShell.lua cuz im lazy
			local argv = ffi.new("const char *[" .. (#Args + 1) .. "]")
			for i, p in ipairs(Args) do
				argv[i - 1] = p
			end
			argv[#Args] = nil

			local a = C.execv(File, ffi.cast("char *const *", argv))

			print("Failed to execute editor - Failed with exit code "..a)
			os.exit()
		end
	end
end

local OpenFuncs = {
	-- Open a file on a users drive
	OpenFileDialog = function(Title)
		print("Open file dialog")
		local ReturnPathC = tinyfiledialog.tinyfd_openFileDialog(Title, nil, 2, nil, nil, 0) 

		-- I love ffi so much, i love when it crashes on me with no error!
		return (ReturnPathC ~= nil) and ffi.string(ReturnPathC)
	end,

	-- Open a folder on a users drive
	OpenFolderDialog = function(Title)
		print("Open folder dialog")
		local ReturnPathC = tinyfiledialog.tinyfd_selectFolderDialog(Title, nil)

		-- I love ffi so much, i love when it crashes on me with no error!
		return (ReturnPathC ~= nil) and ffi.string(ReturnPathC)
	end
}

-- Open a file or folder on a users and ONLY call Callback IF the user doesnt cancel the prompt
function Platform.OpenWithCallback(Title, Type, Callback)
	local Path = OpenFuncs[Type](Title)

	if Path then
		Path = Platform.ParsePath(Path)
		return Callback(Path), Path
	else
		return
	end
end

return Platform