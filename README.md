lua-utf8
========

Lua UTF8 support in pure lua script

Current Status
==============

The module emulate the string capabilities

* ok      `string.byte`
* ok      `string.char`
* ok      `string.dump`
* missing `string.find`
* ok      `string.format`
* missing `string.gmatch`
* missing `string.gsub`
* ok      `string.len`
* ok      `string.lower` (*)
* missing `string.match`
* ok      `string.rep`
* ok      `string.reverse`
* ok      `string.sub`
* ok      `string.upper` (*)

(*) don't thread Unicode, only ascii upper/lower cases.


Sample of use
=============

```lua 
local u = require("utf8")

local data = "àbcdéêèf"
local udata = u(data)

print(type(data), data)   -- the orignal
print(type(udata), udata) -- automatic convertion to string

print(#data)  -- is not the good number of printed characters on screen
print(#udata) -- is the number of printed characters on screen

print(udata:sub(4,5)) -- be able to use the sub() like a string
```

# TODO

 * See all other utf8 implementation
 * Try to follow the lua5.3's utf8 API
 * ...

# License

My code is under MIT License
