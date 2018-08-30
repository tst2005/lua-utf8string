lua-utf8string
==============

Simple UTF8 support in pure lua

Current Status
==============

The module emulate the string capabilities

* [x]      `string.byte`
* [x]      `string.char`
* [x]      `string.dump`
* [ ] `string.find`
* [x]      `string.format`
* [ ] `string.gmatch`
* [ ] `string.gsub`
* [x]      `string.len`
* [x]      `string.lower` (*)
* [ ] `string.match`
* [x]      `string.rep`
* [x]      `string.reverse`
* [x]      `string.sub`
* [x]      `string.upper` (*)

(*) don't thread Unicode, only ascii upper/lower cases.


Sample of use
=============

```lua 
local u = require("utf8string")

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
