local u = require("utf8string")

-- source: https://github.com/cloudwu/skynet/issues/341
local i341 = '这里只是释放了 uc 的内存, 但是 uc->pack.buffer 指向的数据并没有释放.'
--            1 2 3 4 5 6 78901 2 3 456 7 890123456789012345 6 7 8 9 0 1 2 3 4 56
--            1       5     10      15     20   15   30   35        40         46
assert( #u(i341) == 46 )
assert( u(i341):reverse():reverse():tostring() == i341 )
assert( #u(i341):sub(2,3) == 2 )

assert( u(i341):reverse():sub(-3,-2):tostring() == u(i341):sub(2,3):reverse():tostring() )

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

--for i,v in ipairs(uobj) do
--	print(i, v, uobj:byte(i,i))
--end


assert( tostring(uobj .. " " .. uobj) == ustr.." "..ustr)
assert( type(uobj) == type(uobj .. "str") )

assert( uobj..1 )
assert( " "..uobj )

--print(uobj:upper())
print(uobj:byte(2,3))
print( string.char(      uobj:byte(1,2)))
print( string.char(("aaaaxE"):byte(1,2)))

-- clone test
if false then
	local a = uobj()
	assert( a ~= uobj )
	assert( tostring(a) == tostring(uobj) )
end

