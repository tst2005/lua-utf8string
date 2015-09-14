local u = require("utf8")

local ustr = "aáâàbeéêèc-óôò€"

local uobj = u(ustr)
assert( tostring(uobj:sub(1, 2)) =="aá" )
assert( tostring(uobj:sub(2, 3)) =="áâ" )
assert( tostring(uobj:sub(-1,-1))=="€" )

assert( uobj:sub(1, 2):tostring() =="aá" )
assert( uobj:sub(2, 3):tostring() =="áâ" )
assert( uobj:sub(-1,-1):tostring()=="€" )

assert(#ustr == 26)
assert(#uobj == 15)
assert(type(uobj)  == "table")
assert(uobj:type() == "ustring")
assert(#u("a") == 1)
assert(#u("Ô") == 1)
assert(string.len(tostring(u("Ô"))) == #"Ô")

assert(uobj == u(uobj), "convert must detecte an already converted object")
assert( tostring( u("áà"):rep(3) ) == "áàáàáà")

--assert( tostring( u("àeïôú"):reverse() ) == "úôïeà")
print(  u("àeïôú"):reverse() )
assert(#ustr == 26)
assert(#uobj == 15)

-- print(uobj:sub(3,3)) -- get one UTF8 char

for i,v in ipairs(uobj) do
	print(i, v, uobj:byte(i,i))
end

print("===")
local a = " "
print(uobj .. a .. uobj)
--print(uobj:upper())
print(uobj:byte(2,3))
print( string.char(      uobj:byte(1,2)))
print( string.char(("aaaaxE"):byte(1,2)))

