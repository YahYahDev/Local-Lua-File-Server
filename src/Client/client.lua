local socket = require("socket")

local file = io.open("example.png","rb")
local content = file:read("*all")
file:close()

local client = socket.connect("192.168.1.201", 8888)

if client == nil then
	print("Failed Connection")
	return
end


local suc, errmsg = client:send(content)

if suc ~= nil then
	print("Success")
else
	print("ERROR: "..errmsg)
end
