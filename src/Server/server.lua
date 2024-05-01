local socket = require("socket")

-- Module for oop like tables
local struct = require("Modules.Utils.Struct")

-- Module for io like "ls, mkdir, rm, rm -r"
local dir = require("Modules.Std.StdDir")

-- Modules for string manipulation and parsing
local parse = require("Modules.String.Parse")

-- Module for loading Plugs
---@class Plug
local plug = require("Server.Plug")

-- Modules for loging and config loading
local log = require("Modules.Std.Log")
local cfg = require("Modules.Std.Cfg")


plug.new = struct.new()









---@class Server
server = {

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
		log.path = "Server/"
		log:Add("Starting Server")
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
			self.directory = config["directory"] .. "/Server/Directory"
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
---@param client table
---@return boolean
	VerifyClient = function (self, client)
		-- If client is on the whitelist will return true
		local ip, port = client:getsockname()

		if self.whitelist[ip] == true then
			-- Accepts authorized client connection
			log:Add("Connection: ip: "..ip.." port: "..port.."  Autherized")
			return true
		else
			-- Cleans up unauthorized client from connecting
			log:Add("Connnection: ip: "..ip.." port: "..port.."  Rejected")
			client:close()
			return false
		end

	end,


	HandleClient = function (self, client)

		local msg, err = client:receive("*l")
		local ip, port = client:getsockname()
		-- Failed to receive message from client clost connection
		if msg == nil then
			log:Error(err)
			client:close()
			return
		end
		-- Get base command
		local command = parse.GetBlock(msg, "^", " ")

		-- Handle command
		if self.plug[command] ~= nil then
			-- Execute command if it exists
			-- and return it to client
			log:Add("Executing Command \""..command.."\" for ip: ".. ip .. " port: "..port)
			client:send(self.plug[command]()())

		else
			-- Handle invalid command
			client:send("Invalid Command\n")
		end

		client:close()
		return
	end,

---@param self Server
	Run = function (self)
		::Reboot::

		if self:Init() == nil then
			log:Error("Failed to Init")
			return nil
		end
		log:Add("Init Complete: ")


		-- Reference for how to call plugin functions
		-- print(self.plug["ls"]()())

		-- Bind server socket
		local Server, err = socket.bind("*", self.port)

		-- Checks for error from accepting incoming connection
		if Server == nil then
			log:Error("Error socket.bind(\"*\") Failed: "..err)
			goto Reboot
		end

		-- Set timeout for clients to connect
		Server:settimeout(10)



		-- Server event loop
		while true do
			::RETRY::
			-- Trys to accept connections
			local Client, err = Server:accept()
			if Client == nil then
				log:Error(err)
				goto RETRY
			end

			-- Checks to see if the client is on the whitelist
			if self:VerifyClient(Client) == true then
				-- Handles client
				self:HandleClient(Client)

			end

		end
		-- Close connection to client
		Server:close()
	end,

}

return server
