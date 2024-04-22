---@class log
local log = {

---@param msg string
	Add = function (self, msg)
		local file = io.open("Log.log", "a+")
		if file == nil then
			print("Failed to Log Message <<"..msg..">>")
			return
		end
		file:write("[Log]:     " .. msg .. "\n")
		file:close()
	end,

	Error = function (self, msg)
		local file = io.open("Log.log", "a+")
		if file == nil then
			print("Error: Failed to Log Message <<"..msg..">>")
			return
		end
		file:write("[Error]:   " .. msg.. "\n")
		file:close()
	end,

}

return log
