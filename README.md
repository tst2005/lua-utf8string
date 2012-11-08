lua-utf8
========

Lua UTF8 support in pure lua script

sample of use
=============

local data = "àbcdéêèf"

local u = require("utf8")

local udata = u(data)

print(type(data), data)   -- the orignal
print(type(udata), udata) -- automatic convertion to string

print(#data)  -- is not the good number of printed characters on screen
print(#udata) -- is the number of printed characters on screen

print(udata:sub(4,5)) -- be able to use the sub() like a string

