local socket = require("socket")


local dir = require("Modules.Std.StdDir")

local str = require("Modules.String.Str")
local parse = require("Modules.String.Parse")

local log = require("Modules.Std.Log")
local cfg = require("Modules.Std.Cfg")
--[[ TODO:
	1): Needs to be able to receive and send files

	2): Needs to be able to log all connections and actions

	3): Needs to be able to have a white list for allowed connections

	4): Needs to be able to have a secure connection between the server and client

	5): Add plugin system to execute custom lua code for the server
]]


---@class Server
---@type tablelib
local server = {

--	Used to make a white list to only accept wanted connections
---@type table
	whitelist ={

	},

---@type table
-- Used to store a hash map of functions to be used at run time
	plugs = {

	},
---@type number
	port = 0,

	directory = "",

	Init = function (self)
		-- Loads Config
		local config = cfg:Load("./config.cfg")

		-- Loads whitelist from ./config.cfg
		local whitelist = str.Replace(config["whitelist"], ",%s+", "\n")
		whitelist = whitelist .. "\n"
		for i = 1, #str.Match(whitelist, "\n") do
			local credential =  parse.GetBlock(whitelist, "^", "\n")
			self.whitelist[tostring(credential)] = true
			whitelist = parse.GetBlock(whitelist, "\n", "$")
		end

		-- Loads port from ./config.cfg default is 8888
		if config["port"] ~= nil then
			self.port = config["port"]
			log:Add("Loaded Port: " ..config["port"])
			else
			log:Error("Failed to Load 'port' from 'config.cfg'")
			return nil
		end

		-- Loads directory from ./config.cfg default is nil
		if config["directory"] ~= "" then
			self.directory = config["directory"]
			log:Add("Loaded Directory: " ..config["directory"])
		else
			log:Error("Failed to Load 'directory' from 'config.cfg'")
			return nil
		end

	end,

---@param self Server
	run = function (self)
		if self:Init() == nil then
			return nil
		end

	end,

}

return server
