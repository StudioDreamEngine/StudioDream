-- General cross-platform functions for random stuff
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

function Platform.Init()
	Platform.IsWindows = (love.system.getOS() == Enum.Platform.Windows)
end

function Platform.GetHome()
	return love.filesystem.getUserDirectory()
end

function Platform.GetDocuments()
	return Platform.GetHome().."/Documents"
end

function Platform.Execute(...)
	local Args = table.pack(...)

	-- we REALLY shouldnt be doing this, but exec force closes the program
	os.execute(table.concat(Args, " "))

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

--[[
	Open a file or folder with a callback function

	Returns Callback result and path if sucessful, otherwise nothing
]]
function Platform.OpenWithCallback(Title, Type, Callback)
	local Path = Platform[Type](Title)

	if Path then
		return Callback(Path), Path
	else
		return
	end
end

function Platform.OpenFileDialog(Title)
    local ReturnPathC = tinyfiledialog.tinyfd_openFileDialog(Title, nil, 2, nil, nil, 0) 

	-- I love ffi so much, i love when it crashes on me with no error!
	return (ReturnPathC ~= nil) and ffi.string(ReturnPathC)
end

function Platform.OpenFolderDialog(Title)
    local ReturnPathC = tinyfiledialog.tinyfd_selectFolderDialog(Title, nil)

	-- I love ffi so much, i love when it crashes on me with no error!
	return (ReturnPathC ~= nil) and ffi.string(ReturnPathC)
end

return Platform