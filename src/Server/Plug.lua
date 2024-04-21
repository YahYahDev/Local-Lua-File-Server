
local dir = require("Modules.Std.StdDir")

-- Modules for string manipulation and parsing
local str = require("Modules.String.Str")
local parse = require("Modules.String.Parse")

-- Module for loging
local log = require("Modules.Std.Log")

---@class Plug
local plug = {
---
---@param self Plug
---@param PlugPath string
---@return nil Failed
	Unpack = function (self, PlugPath)

		local file = io.open(PlugPath,"r")
		if file == nil then
			log:Error("Failed to Load Plugin from: "..PlugPath)
			file:close()
			return nil
		end
		local content = file:read("a")
		file:close()
		-- Parse all blocks of code in a plugin
		local chunks = parse.GetAllBlock(content, "start:", "end:")

		-- Sets func names to key in plug
		log:Add("Loading Plugin: "..PlugPath)
		for i = 1, #chunks do
			local key = parse.GetBlock(chunks[1], "", "\n")
			local func = parse.GetBlock(chunks[1], "\n", "\n$")
			self[key] = load(func)
			log:Add("   Loaded: "..key)
		end
	end,
---@param self Plug
---@param PlugDir string
	Load = function (self, PlugDir)
		-- Get all plugin files and put them into a chunk array
		local pluglist = dir.Ls(PlugDir)
		if pluglist == nil then
			log:Error("Failed to Load Plugins from: "..PlugDir)
		else
			log:Add("Loading Plugins from: "..PlugDir)
		end
		pluglist = parse.GetAllBlock(pluglist, "", "\n")

		-- Plug:Unpack() all the plugin files
		for i = 1, #pluglist do
			self:Unpack(PlugDir.."/"..pluglist[i])
		end

	end,
}

return plug
