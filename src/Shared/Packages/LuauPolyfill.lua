--[[
	A polyfill for functions that are within luau that are not 
	within the version of lua Love2D uses.


	MIT LICENSE

	Copyright (c) 2025-2026 Bloctans,
	Copyright (c) 2019-2025 Roblox Corporation
	Copyright (c) 1994–2019 Lua.org, PUC-Rio.

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

	Version 1.3.1
]]

-- CHANGE THESE!!!
POLYFILL_FLAGS = {
	Verbose = FLAGS.Verbose, -- If verbose printing is enabled
	utf8 = true -- If you do not have a utf8 library, set this to false
}

---@diagnostic disable: param-type-mismatch
-- String --
do
	-- https://gist.github.com/jaredallard/ddb152179831dd23b230
	function string.split(str, delimiter)
		local result = { }
		local from  = 1
		local delim_from, delim_to = string.find( str, delimiter, from  )
		while delim_from do
			table.insert( result, string.sub( str, from , delim_from-1 ) )
			from  = delim_to + 1
			delim_from, delim_to = string.find( str, delimiter, from  )
		end
		table.insert( result, string.sub( str, from  ) )

		return result
	end

	-- Thx Emk530
	if POLYFILL_FLAGS.utf8 then
		function string.utfsub(s,i,j)
			if j == -1 then j=utf8.len(s) end
			local success,ret = pcall(function()
				local k=utf8.offset(s,i)
				local l=utf8.offset(s,j+1)-1
				return string.sub(s,k,l)
			end)
			if success then
				return ret
			else
				return string.sub(s,i,j)
			end
		end
	end
end

local DontPrint = {"package", "_G", "love", "Dream", "ImGUI", "_3DreamEngine"}

-- Table --
do
	-- REALLY GARBAGE table formatter, you are happy to contiribute and make it better
	function table.format(Table, _RecurseData)
		-- Optional Variables
		local Data = _RecurseData or {}
		Depth = Data.Depth or 0
		RecordedTables = Data.RecordedTables or {}

		-- Handle the chain of tabs first, for readability
		local BreakChain = ""
		for i = 0, Depth do BreakChain = BreakChain .. "\t" end

		Depth = Depth + 1

		-- Start Parsing Table
		local string = "{"

		for i,v in pairs(Table) do
			local Value

			-- Tables as indexes currently arent supported, skip
			if type(i) == "table" then
				i = "Indexed Table"
			end

			-- Handle the value side
			if type(v) == "table" then -- Parse Table
				local TableToString = v.__tostring
			
				if TableToString then
					Value = "\""..TableToString(v).."\""
				elseif table.find(DontPrint, i) or RecordedTables[v] then -- Tables that reference tables are a death sentence, so we skip em
					Value = "Table Skipped"
				elseif Depth < 10 then
					RecordedTables[v] = true
					Value = table.format(v, {Depth = Depth, RecordedTables = RecordedTables})
				else
					Value = "Too deep! Possible recursion?"
				end
			elseif type(v) == "function" then -- Parse function
				Value = "function("

				-- Get Function args
				local params = debug.getinfo(v).nparams

				for i = 1, params do
					local Arg = debug.getlocal(v, i)

					if Arg then
						Value = Value .. Arg

						if i < params then Value = Value .. ", " end
					end
				end

				Value = Value .. ")"
			elseif type(v) == "string" then -- Parse string
				Value = "\""..v.."\""
			elseif type(v) == "number" or type(v) == "boolean" then -- Parse booleans or numbers, they can use tostring
				Value = tostring(v)
			else -- any other type is unsupported
				Value = "\"Unsupported Type "..type(v).."\""
			end

			-- Handle Index side
			local Index

			if #Table == table.length(Table) then
				Index = ""
			elseif type(i) == "string" or type(i) == "number" then
				Index = "["..(string.find(i, "[%p%s]") and "\""..i.."\"" or i).."] = "
			else
				Index = "[\""..type(i).."\"] = "
			end
	
			-- Output table element
			string = string.."\n"..BreakChain..Index..Value..","
		end

		-- Closing Bracket needs to be on the previous depth
		Depth = Depth - 1

		-- Regenerate chain
		local BreakChain = ""
		for i = 1, Depth do BreakChain = BreakChain .. "\t" end

		-- Complete Table string
		string = string.."\n"..BreakChain.."}"
		return string
	end

	function table.length(Table)
		local i = 0
		for _, v in pairs(Table) do i = i + 1 end

		return i
	end

	-- Yes, Lua 5.1 doesnt have table.find (iirc)
	function table.find(table, value)
		for i,v in pairs(table) do
			if v == value then
				return i
			end
		end
	end

---@diagnostic disable-next-line: duplicate-set-field
	function table.pack(...)
		return {n = select("#", ...), ...}
	end

	function table.deepcopy(original)
		local copy = {}
		for k, v in pairs(original) do
			if k ~= "Parent" then
				if type(v) == "table" then
					v = table.deepcopy(v)
				end
				copy[k] = v
			end
		end
		return copy
	end

	function table.combine(t1, t2)
		for _, v in pairs(t2) do
			table.insert(t1, v)
		end
	end

	-- https://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value
	function table:clone()
		local t2 = {}
		for k,v in pairs(self) do
			t2[k] = v
		end
		return t2
	end
end

-- Math --
do
	function math.round(number)
		if number % 1 > 0.5 then
			return math.ceil(number)
		else
			return math.floor(number)
		end
	end

	function math.sign(number)
		if number > 0 then
			return 1
		elseif number < 0 then
			return -1
		else
			return 0
		end
	end

	function math.lerp(a,b,alpha)
		return a + (b-a) * alpha
	end

	function math.clamp(a, min, max)
		return math.max(math.min(a, max), min)
	end
end

-- Vector2 -- 
do
	-- Clonable constants for vector2
	local Constant = {
		xAxis = {1,0},
		yAxis = {0,1},
		zero = {0,0},
		one = {1,1}
	}

	_G.Vector2 = setmetatable({}, {
		__index = function (t, k)
			local PossibleConstant = Constant[k]

			if PossibleConstant then
				return Vector2.new(PossibleConstant[1], PossibleConstant[2])
			else
				return rawget(t,k)
			end
		end
	})

	function Vector2.FromSimple(Simple)
		if Simple.Simple then
			return Vector2.new(Simple.X, Simple.Y)
		else
			return Simple
		end
	end

	function Vector2.new(x,y)
		if (not y) then
			local ExistingVector = x

			if ExistingVector.Simple then
				return Vector2.new(ExistingVector.X, ExistingVector.Y)
			else
				return ExistingVector
			end
		end

		local Object = setmetatable({
			X = x,
			Y = y,
			Type = "Vector2"
		}, { -- I have no idea how to organize this mess
			__unm = function (t)
				return Vector2.new(-t.X,-t.Y)
			end,
			__eq = function (t1, t2)
				print(t1, t2)
				return (t1.X == t2.X) and (t1.Y == t2.Y)
			end,
			__add = function (t1, t2)
				if type(t1) == "number" then
					return Vector2.new(t1 + t2.X, t1 + t2.Y)
				elseif type(t2) == "number" then
					return Vector2.new(t1.X + t2, t1.Y + t2)
				else
					return Vector2.new(t1.X + t2.X, t1.Y + t2.Y)
				end
			end,
			__sub = function (t1, t2)
				if type(t2) == "number" then
					return Vector2.new(t1.X - t2, t1.Y - t2)
				elseif type(t1) == "number" then
					return Vector2.new(t1 - t2.X, t1 - t2.Y)
				else
					return Vector2.new(t1.X - t2.X, t1.Y - t2.Y)
				end
			end,
			__tostring = function (t)
				return t.X..", "..t.Y
			end,
			__mul = function (t1, t2)
				if type(t2) == "number" then
					return Vector2.new(t1.X * t2, t1.Y * t2)
				elseif type(t1) == "number" then
					return Vector2.new(t2.X * t1, t2.Y * t1)
				else
					return Vector2.new(t1.X * t2.X, t1.Y * t2.Y)
				end
			end,
			__div = function (t1, t2)
				if type(t2) == "number" then
					return Vector2.new(t1.X / t2, t1.Y / t2)
				else
					return Vector2.new(t1.X / t2.X, t1.Y / t2.Y)
				end
			end
		})

		function Object.Lerp(SecondVector, Alpha)
			return Vector2.new(math.lerp(Object.X, SecondVector.X, Alpha),math.lerp(Object.Y, SecondVector.Y, Alpha))
		end
		
		function Object.Copy()
			return Vector2.new(Object.X,Object.Y)
		end

		function Object.Dot(SecondVector)
			return (Object.X * SecondVector.X) + (Object.Y * SecondVector.Y)
		end

		-- Return the simple version of the vector2, Useful for serialization
		function Object.Simple()
			return {
				X = Object.X, 
				Y = Object.Y,
				Type = "SimpleVector2",
				Simple = true
			}
		end

		-- for some reason __eq isnt working
		function Object.Is(SecondVector)
			return (Object.X == SecondVector.X) and (Object.Y == SecondVector.Y)
		end

		function Object.Magnitude()
			return math.sqrt(Object.X*Object.X + Object.Y*Object.Y)
		end

		function Object.Unit()
			return Vector2.new(Object.X/Object.Magnitude(),Object.Y/Object.Magnitude())
		end

		function Object.Round()
			return Vector2.new(math.round(Object.X),math.round(Object.Y))
		end

		function Object.Abs()
			return Vector2.new(math.abs(Object.X),math.abs(Object.Y))
		end

		return Object
	end
end

-- Vector3 --
do
	-- Clonable constants for vector2
	local Constant = {
		xAxis = {1,0,0},
		yAxis = {0,1,0},
		zAxis = {0,0,1},
		plane = {1,0,1},
		zero = {0,0,0},
		one = {1,1,1}
	}

	_G.Vector3 = setmetatable({}, {
		__index = function (t, k)
			local PossibleConstant = Constant[k]

			if PossibleConstant then
				return Vector3.new(PossibleConstant[1], PossibleConstant[2], PossibleConstant[3])
			else
				return rawget(t,k)
			end
		end
	})

	---@param Vector DreamVec3
	function Vector3.FromDream(Vector)
		return Vector3.new(Vector.x, Vector.y, Vector.z)
	end
	
	function Vector3.new(x,y,z,w)
		local Object = setmetatable({
			X = x,
			Y = y,
			Z = z,
			W = w or 1, -- Optional distance component, any operator (aside from multiplication) will remove the w component as of currently
			Type = "Vector3"
		}, { -- I have no idea how to organize this mess
			__unm = function (t)
				return Vector3.new(-t.X,-t.Y,-t.Z)
			end,
			__add = function (t1, t2)
				if type(t1) == "number" then
					return Vector3.new(t1 + t2.X, t1 + t2.Y, t1 + t2.Z, t2.W)
				elseif type(t2) == "number" then
					return Vector3.new(t1.X + t2, t1.Y + t2, t1.Z + t2, t1.W)
				else
					return Vector3.new(t1.X + t2.X, t1.Y + t2.Y, t1.Z + t2.Z, t1.W)
				end
			end,
			__sub = function (t1, t2)
				if type(t2) == "number" then
					return Vector3.new(t1.X - t2, t1.Y - t2, t1.Z - t2, t2.W)
				else
					return Vector3.new(t1.X - t2.X, t1.Y - t2.Y, t1.Z - t2.Z, t1.W)
				end
			end,
			__tostring = function (t)
				return t.X..", "..t.Y..", "..t.Z
			end,
			__mul = function (t1, t2)
				if type(t2) == "number" then
					return Vector3.new(t1.X * t2, t1.Y * t2, t1.Z * t2, t1.W)
				elseif type(t1) == "number" then
					return Vector3.new(t2.X * t1, t2.Y * t1, t2.Z * t1, t2.W)
				else
					return Vector3.new(t1.X * t2.X, t1.Y * t2.Y, t1.Z * t2.Z, t1.W)
				end
			end,
			__div = function (t1, t2)
				if type(t2) == "number" then
					return Vector3.new(t1.X / t2, t1.Y / t2, t1.Z / t2)
				elseif type(t1) == "number" then
					return Vector3.new(t2.X / t1, t2.Y / t1, t2.Z / t1)
				else
					return Vector3.new(t1.X / t2.X, t1.Y / t2.Y, t1.Z / t2.Z)
				end
			end
		})

		function Object.Copy()
			return Vector3.new(Object.X,Object.Y,Object.Z)
		end

		function Object.Lerp(SecondVector, Alpha)
			return Vector3.new(math.lerp(Object.X, SecondVector.X, Alpha),math.lerp(Object.Y, SecondVector.Y, Alpha),math.lerp(Object.Z, SecondVector.Z, Alpha))
		end

		function Object.ToDream()
			return Dream.vec3(Object.X, Object.Y, Object.Z)
		end

		function Object.Unit()
			local Unit = Vector3.new(Object.X/Object.Magnitude(),Object.Y/Object.Magnitude(),Object.Z/Object.Magnitude())

			return (Object.Magnitude() > 0) and Unit or Vector3.zero
		end

		function Object.Cross(SecondVector)
			return Vector3.new(Object.Y * SecondVector.Z - Object.Z * SecondVector.Y, Object.Z * SecondVector.X - Object.X * SecondVector.Z, Object.X * SecondVector.Y - Object.Y * SecondVector.X)
		end

		function Object.Dot(SecondVector)
			return (Object.X * SecondVector.X) + (Object.Y * SecondVector.Y) + (Object.Z * SecondVector.Z)
		end

		-- Return the simple version of the vector2, Useful for serialization
		function Object.Simple()
			return {
				X = Object.X, 
				Y = Object.Y,
				Z = Object.Z,
				Simple = true
			}
		end

		-- for some reason __eq isnt working
		function Object.Is(SecondVector)
			return (Object.X == SecondVector.X) and (Object.Y == SecondVector.Y) and (Object.Z == SecondVector.Z)
		end

		function Object.Magnitude()
			return (Object.X*Object.X + Object.Y*Object.Y + Object.Z*Object.Z) ^ 1/3
		end

		function Object.Axis()
			return (Object.X + Object.Y + Object.Z)
		end
		
		function Object.Round()
			return Vector3.new(math.round(Object.X),math.round(Object.Y),math.round(Object.Z))
		end

		function Object.Abs()
			return Vector3.new(math.abs(Object.X),math.abs(Object.Y),math.abs(Object.Z))
		end

		return Object
	end
end

-- Task? General functions for easy acess
-- SCRAPPED
-- Love Extension: Vector2 based transforms
do
	if love and love.graphics then
		love.transform = {
			rotate = love.graphics.rotate,
			translate = function(Translation)
				love.graphics.translate(Translation.X, Translation.Y)
			end
		}
	end
end

-- UUID --
function _G.CreateUUID()
	local UUID = ""

	for i = 1,4 do
		for _ = 1,4 do
			UUID = UUID..string.format("%x",math.random(0, 0xf))
		end

		if i < 4 then UUID = UUID.."-" end
	end

	return UUID
end

-- Print --
PrintOG = _G.print

-- Edit of the print function that supports printing tables
local function InternalPrint(IsVerbose, ...)
	local PrintTable = {...}
	local FormattedPrintTable = {}

	local PrintedFrom = string.split(string.split(debug.traceback("",3), "\n")[3],":") -- Get the path, no line number

	local Path = string.sub(PrintedFrom[1], 2)
	local LineNumber = PrintedFrom[2]

	for _, Arg in pairs(PrintTable) do
		-- This feels fucking cursed for some reason
		-- Check if a table should be formatted or should simply be passed to print, depends on if it has a tostring function or not.
		local HasToString = getmetatable(Arg) and getmetatable(Arg).__tostring
		local ShouldFormat = (type(Arg) == "table" and (not HasToString))

		if ShouldFormat then
			table.insert(FormattedPrintTable, table.format(Arg))
		else
			table.insert(FormattedPrintTable, tostring(Arg)) -- I believe every other case should be able to use tostring
		end
	end

	local FinalString = (IsVerbose and "[VERBOSE] " or "[REGULAR] ")..Path..":"..(LineNumber)..":"

	for _, v in pairs(FormattedPrintTable) do
		FinalString = FinalString.." "..v
	end

	PrintOG(FinalString)
end

function _G.printVerbose(...)
	if (not POLYFILL_FLAGS.Verbose) then
		return
	end

	InternalPrint(true, ...)
end

function _G.print(...)
	InternalPrint(false, ...)
end