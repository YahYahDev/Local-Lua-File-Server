local socket = require("socket")

local str = require("Modules.String.Str")
local parse = require("Modules.String.Parse")

local cfg = require("Modules.Std.Cfg")

local log = require("Modules.Std.Log")
---@class Client
client = {

	port = "",

	ip = "",

	directory = "",

---@param self Client
---@return nil
	Init = function (self)
		log:Add("Starting Client")
		-- Loads config from ./config.cfg
		local config = cfg:Load("./config.cfg")

		-- Loads port from ./config.cfg default is 8888
		if config["port"] ~= nil then
			self.port = config["port"]
			log:Add("Loaded Port: " ..config["port"])
		else
			log:Error("Failed to Load 'port' from 'config.cfg'")
			return nil
		end

		-- Loads ip from ./config.cfg default is localhost
		if config["ip"] ~= nil then
			self.ip = config["ip"]
			log:Add("Loaded Ip: "..config["ip"])
		else
			log:Error("Failed to Load 'ip' from 'config.cfg'")
		end

		-- Loads directory from ./config.cfg default is nil
		if config["directory"] ~= "" then
			self.directory = config["directory"] .. "/Client/Directory"
			log:Add("Loaded Directory: " ..config["directory"])
		else
			log:Error("Failed to Load 'directory' from 'config.cfg'")
			return nil
		end


	end,

---@param self Client
	Run = function (self)
		if self:Init() == nil then
			log:Error("Failed to run Client:Init() for Client:Run()")
		end

		-- Event loop
		while true do

			-- Try to connect to server?
			local Client = socket.connect(self.ip, self.port)

			-- Set timeout for connections
			Client:settimeout(5)

			Client:send("Hello from client!")


		end
	end
}

return client
