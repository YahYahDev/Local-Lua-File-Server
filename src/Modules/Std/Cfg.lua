local str = require("Modules.String.Str")
local parse = require("Modules.String.Parse")
local log = require("Modules.Std.Log")

---@class Cfg
local cfg = {

---@param self Cfg
---@param path string
---@return table
	Load = function (self, path)
		local file = io.open(path,"r")
		if file == nil then
			log:Error("Failed to Load Config Path is: "..path)
			return nil
		end

		local config = file:read("a")
		file:close()
		local lines = parse.GetAllBlock(config, "", "\n")

		local cfg = {}
		for i = 1 , #lines do
			local chunk = lines[i]
			local key = parse.GetBlock(chunk, "%s*%[","%]%s*")
			local value = parse.GetBlock(chunk, "=%s*%[", "%]$")
			cfg[key] = value
		end

		return cfg
	end,
}

return cfg
