local u = require("utf8")

local ustr = "aáâàbeéêèc-óôò€"

local uobj = u(ustr)

assert(#ustr == 26)
assert(#uobj == 15)
assert(type(uobj)  == "table")
assert(uobj:type() == "ustring")
assert(#u("a") == 1)
assert(#u("Ô") == 1)
assert(string.len(tostring(u("Ô"))) == #"Ô")

assert(uobj == u(uobj), "convert must detecte an already converted object")
print(u("à"):rep(3))

print(#ustr, "VS", #uobj)

-- print(uobj:sub(3,3)) -- get one UTF8 char

for i,v in ipairs(uobj) do
	print(i, v, uobj:byte(i,i))
end

print(#uobj)
print("===")
print(uobj:sub(2, 3))
local a = " "
print(uobj .. a .. uobj)
--print(uobj:upper())
print(uobj:byte(2,3))
print( string.char(      uobj:byte(1,2)))
print( string.char(("aaaaxE"):byte(1,2)))

