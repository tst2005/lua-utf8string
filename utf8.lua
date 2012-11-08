local m = {} -- the module
local ustring = {} -- table to index equivalent string.* functions

-- TsT <tst2005 gmail com> 20121108 (v0.2.1)
-- License: same to the Lua one
-- TODO: copy the LICENSE file

-------------------------------------------------------------------------------
-- begin of the idea : http://lua-users.org/wiki/LuaUnicode
--
-- for uchar in sgmatch(unicode_string, "([%z\1-\127\194-\244][\128-\191]*)") do
--
--local function utf8_strlen(unicode_string)
--	local _, count = string.gsub(unicode_string, "[^\128-\193]", "")
--	return count
--end

-- http://www.unicode.org/reports/tr29/#Grapheme_Cluster_Boundaries

-- my custom type for Unicode String
local utf8type = "ustring"

local typeof = assert(type)

local string = require("string")
local sgmatch = assert(string.gmatch or string.gfind) -- lua 5.1+ or 5.0
local string_byte = assert(string.byte)

local table = require("table")
local table_concat = assert(table.concat)

local function table_sub(t, i, j)
	local len = #t
	if not i or i == 0 then
		i = 1
	elseif i < 0 then -- support negative index
		i = len+i+1
	end
	if not j then
		j = i
	elseif j < 0 then
		j = len+j+1
	end
	local r = {}
	for k=i,j,1 do
		r[#r+1] = t[k]
	end
	return r
end
local function utf8_range(uobj, i, j)
	local t = table_sub(uobj, i, j)
	return setmetatable(t, getmetatable(uobj)) -- or utf8_object() 
end

local function utf8_typeof(obj)
	local mt = getmetatable(obj)
	return mt and mt.__type or typeof(obj)
end

local function utf8_is_object(obj)
	return not not (utf8_typeof(obj) == utf8type)
end

local function utf8_tostring(obj)
	if utf8_is_object(obj) then
		return table_concat(obj, "")
	end
	return tostring(obj)
end

local function utf8_sub(uobj, i, j)
        assert(i, "sub: i must exists")
	return utf8_range(uobj, i, j)
end

local function utf8_op_concat(op1, op2)
	local op1 = utf8_is_object(op1) and utf8_tostring(op1) or op1
	local op2 = utf8_is_object(op2) and utf8_tostring(op2) or op2
	if (typeof(op1) == "string" or typeof(op1) == "number") and
	   (typeof(op2) == "string" or typeof(op2) == "number") then
		return op1 .. op2  -- primitive string concatenation
	end
	local h = getmetatable(op1).__concat or getmetatable(op2).__concat
	if h then
		return h(op1, op2)
	end
	error("concat error")
end

--local function utf8_is_uchar(uchar)
--	return (uchar:len() > 1) -- len() = string.len()
--end



local function utf8_object(uobj)
	local uobj = uobj or {}
-- IDEA: create __index to return function without to be indexe directly as a key
	for k,v in pairs(ustring) do
		uobj[k] = v
	end
	local mt = getmetatable(uobj) or {}
	mt.__concat   = utf8_op_concat
	mt.__tostring = utf8_tostring
	mt.__type     = utf8type
	return setmetatable(uobj, mt)
end

--        %z = 0x00 (\0 not allowed)
--        \1 = 0x01
--      \127 = 0x7F
--      \128 = 0x80
--      \191 = 0xBF

-- parse a lua string to split each UTF-8 sequence to separated table item
local function private_string2ustring(unicode_string)
	assert(typeof(unicode_string) == "string", "unicode_string is not a string?!")

	local uobj = utf8_object()
	local cnt = 1
-- FIXME: invalid sequence dropped ?!
	for uchar in sgmatch(unicode_string, "([%z\1-\127\194-\244][\128-\191]*)") do
		uobj[cnt] = uchar
		cnt = cnt + 1
	end
	return uobj
end

local function private_contains_unicode(str)
	return not not str:find("[\128-\193]+")
end

local function utf8_auto_convert(unicode_string, i, j)
	local obj
	assert(typeof(unicode_string) == "string", "unicode_string is not a string: ", typeof(unicode_string))
	if private_contains_unicode(unicode_string) then
		obj = private_string2ustring(unicode_string)
	else
		obj = unicode_string
	end
	return (i and obj:sub(i,j)) or obj
end

local function utf8_byte(obj, i, j)
	local i = i or 1
	local j = j or i
	local uobj
	assert(utf8_is_object(obj), "ask utf8_byte() for a non utf8 object?!")
--	if not utf8_is_object(obj) then
--		uobj = utf8_auto_convert(obj, i, j)
--	else
	uobj = obj:sub(i, j)
--	end
	return string_byte(tostring(uobj), 1, -1)
end

-- FIXME: what is the lower/upper case of Unicode ?!
local function utf8_lower(uobj) return utf8_auto_convert( tostring(uobj):lower() ) end
local function utf8_upper(uobj) return utf8_auto_convert( tostring(uobj):upper() ) end

local function utf8_reverse(uobj)
	local t = {}
	for i=#uobj,1,-1 do
		t[#t+1] = uobj[i]
	end
	return utf8_object(t)
end
local function utf8_rep(uobj, n)
	return utf8_auto_convert(tostring(uobj):rep(n)) -- :rep() is the string.rep()
end

---- Standard Lua 5.1 string.* ----
ustring.byte	= assert(utf8_byte)
ustring.char	= assert(string.char)
ustring.dump	= assert(string.dump)
--ustring.find
ustring.format	= assert(string.format)
--ustring.gmatch
--ustring.gsub
ustring.len	= function(uobj) return #uobj end
ustring.lower	= assert(utf8_lower)
--ustring.match
ustring.rep	= assert(utf8_rep)
ustring.reverse	= assert(utf8_reverse)
ustring.sub	= assert(utf8_sub)
ustring.upper	= assert(utf8_upper)

---- custome add-on ----
ustring.type	= assert(utf8_typeof)

-- Add fonctions to the module
for k,v in pairs(ustring) do m[k] = v end

-- Allow to use the module directly to convert strings
local mt = {
	__call = function(self, obj, i, j)
		if utf8_is_object(obj) then
			return (i and obj:sub(i,j)) or obj
		end
		local str = obj
		if typeof(str) ~= "string" then
			str = tostring(str)
		end
		return utf8_auto_convert(str, i, j)
	end
}

return setmetatable(m,mt)
