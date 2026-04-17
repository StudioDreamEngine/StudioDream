local FileDialog = {}
local ffi = require("ffi")

local tinyfiledialog = ffi.load(package.searchpath("tinyfiledialogs64", package.cpath))

ffi.cdef[[
    char * tinyfd_openFileDialog(
	char const * aTitle, /* NULL or "" */
	char const * aDefaultPathAndOrFile, /* NULL or "" , ends with / to set only a directory */
	int aNumOfFilterPatterns , /* 0 (2 in the following example) */
	char const * const * aFilterPatterns, /* NULL or char const * lFilterPatterns[2]={"*.png","*.jpg"}; */
	char const * aSingleFilterDescription, /* NULL or "image files" */
	int aAllowMultipleSelects ) ;
]]

function FileDialog.OpenFileDialog(Title)
    local ReturnPathC = tinyfiledialog.tinyfd_openFileDialog(Title, nil, 2, nil, nil, 0) 

	-- I love ffi so much, i love when it crashes on me with no error!
	return (ReturnPathC ~= nil) and ffi.string(ReturnPathC)
end

return FileDialog