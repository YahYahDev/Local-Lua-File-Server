local socket = require("socket")

local server = socket.bind("*a", 8888)

while true do

	local client = server:accept()

	client:settimeout(10)

	local content, err = client:receive("*a")

	if content == nil then

		print("ERROR: "..err)
		return
	else
		-- print("DATA: "..content)
		local file = io.open("received.png","wb")

		if content ~= nil then

			file:write(content)
		else
			print("Content is Nil Unable to Write to File")
		end

		file:close()
		return
	end

client:close()
end
