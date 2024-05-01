local socket = require("socket")

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

		return true
	end,

	HandleConnection = function (self, client)

		-- Set Lable
		::RETRY::

		-- Get user input
		io.write(" >> ")
		local command = io.read()

		-- Attempt to send command
		client:send(command.. " \n")

		-- Attempt to receive callback from server
		local msg, err = client:receive("*a")

		if msg == nil then
			log:Error(err)
			if err == "closed" then
				return
			end
			goto RETRY
		end

		-- Handle invalid command inputs
		if msg == "Invalid Command" then
			-- Log invalid command then retry
			log:Error("Invalid Command: \""..command.."\"")
			print("Invalid Command Please Try Again!")
			goto RETRY
		else
			-- Handle output from server
			print(msg)

		end

		client:close()

	end,

---@param self Client
	Run = function (self)
		if self:Init() == nil then
			log:Error("Failed to run Client:Init() for Client:Run()")
			return nil
		end

		local Client = socket.tcp()

		-- Set timeout for connections
		Client:settimeout(10)

		-- Event loop
		while true do
			::RETRY::
			-- Try to connect to server?
			local err, errmsg = Client:connect(self.ip, self.port)

			-- If failed to connect retry
			if err == nil then
				log:Error("Error: "..errmsg)
				goto RETRY
			end

			-- Handle connection
			self:HandleConnection(Client)

		end

			-- Close socket
			Client:close()
	end
}

return client
