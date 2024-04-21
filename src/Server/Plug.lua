
local dir = require("Modules.Std.StdDir")

-- Modules for string manipulation and parsing
local str = require("Modules.String.Str")
local parse = require("Modules.String.Parse")

-- Module for loging
local log = require("Modules.Std.Log")

---@class Plug
local plug = {

	Unpack = function (self, PlugPath)



	end,
---@param self Plug
---@param PlugDir string
	Load = function (self, PlugDir)
		-- Get all plugin files and put them into a chunk array
		local pluglist = dir.Ls(PlugDir)
		if pluglist == nil then
			log:Error("Failed to Load Plugins from: "..PlugDir)
		else
			log:Add("Loaded Plugins from: "..PlugDir)
		end
		pluglist = parse.GetAllBlock(pluglist, "", "\n")

		-- Plug:Unpack() all the plugin files
		for i = 1, #pluglist do



		end

	end,
}

return plug
