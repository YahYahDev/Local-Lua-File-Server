---@class log
local log = {

---@param msg string
	Add = function (self, msg)
		local file = io.open("Log", "w")
		if file == nil then
			print("Failed to Log")
			return
		end
		file:write("Log: " .. msg, file:seek("end"))
		file:close()
	end,

	Error = function (self, msg)
		local file = io.open("Log", "w")
		if file == nil then
			print("Error: Failed to Log Message <<"..msg..">>")
			return
		end
		file:write("Error: ["..msg.."]", file:seek("end"))
		file:close()
	end,

}

return log
