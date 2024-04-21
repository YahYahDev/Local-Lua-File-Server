local socket = require("socket")

-- Module for oop like tables
local struct = require("Modules.Utils.Struct")

-- Module for io like "ls, mkdir, rm, rm -r"
local dir = require("Modules.Std.StdDir")

-- Modules for string manipulation and parsing
local str = require("Modules.String.Str")
local parse = require("Modules.String.Parse")

-- Module for loading Plugs
---@class Plug
local plug = require("Server.Plug")

-- Modules for loging and config loading
local log = require("Modules.Std.Log")
local cfg = require("Modules.Std.Cfg")
--[[ TODO:
	1): Needs to be able to receive and send files

	2): Needs to be able to log all connections and actions

	3): Needs to be able to have a white list for allowed connections

	4): Needs to be able to have a secure connection between the server and client

	5): Add plugin system to execute custom lua code for the server
]]


plug.new = struct.new()

---@class Server
---@type tablelib
local server = {

--	Used to make a white list to only accept wanted connections
---@type table
	whitelist ={

	},


-- Used to store a hash map of functions to be used at run time
---@type Plug
	plug = plug:new(),

---@type number
	port = 0,
---@type string
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

		-- Loads Plug

		self.plug:Load(config["plugdir"])

		return true
	end,

---@param self Server
	Run = function (self)
		::Reboot::
		if self:Init() == nil then
			log:Error("Failed to Init")
			return nil
		end

		local Server = socket.bind("*", self.port)

		while true do

			local Client = Server:accept()
			Client:settimeout(5)
			local ip, port = client:getsockname()

			if self.whitelist[ip] == true then
				log:Add("Connection: ip: "..ip.." port: "..port.."  Autherized")
				Client:send("Accepted: Autherized User")
			else
				log:Add("Connnection: ip: "..ip.." port: "..port.."  Rejected")
				Client:send("Rejected: Not Autherized User")
				Client:close()
			end

			-- Reboot server to refresh any config or plugins
			if Client:receive() == "reboot" then
				goto Reboot
			end

		end
	end,

}

return server
