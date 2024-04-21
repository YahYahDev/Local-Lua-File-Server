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


	Init = function (self)

		self.config = cfg:Load("./config.cfg")
		print(self.config["test"])
	end,

---@param self Server
	run = function (self)
		self:Init()
	end,

}

return server
