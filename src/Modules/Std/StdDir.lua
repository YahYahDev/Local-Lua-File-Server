
--[[
    Module for directory operations

    any functions used only have the same permission as person executing the script
    so if you are trying to accese administrator files you need to run the script as administrator

]]
---@class StdDir
local stddir = {
--[[

    Makes a Dir at DirName

    stdos.MkDir("Log")

]]
---@param DirName string
    MkDir = function (DirName)
        os.execute("mkdir " .. DirName)
    end,
--[[
    Deletes a directory recursivly

]]
---@param DirName string
    RmDir = function (DirName)
        os.execute("r -r " .. DirName)
    end,
--[[

]]
---@param Directory string
---@return string
    LsDir = function (Directory)
        if Directory == nil then
            local handle = io.popen("ls -d */ .*/")
            local content = handle:read("a")
            handle:close()
            return content
        else
            local handle = io.popen("ls -d */ .*/" .. Directory)
            local content = handle:read("a")
            handle:close()
            return content
        end
    end,
--[[
    Lists a Directory basicly "ls Args"
]]
---@param Args string
---@return string
    Ls = function (Args)
        if Args ~= nil then
            local handle = io.popen("ls "..Args)
            local content = handle:read("a")
            handle:close()
            return content
        else
            local handle = io.popen("ls")
            local content = handle:read("a")
            handle:close()
            return content
        end
    end,


}

return stddir
