--[[
local path = SCRIPT_PATH.."ExtLib.lua"

if FileExist(path) then
	_G.Enable_Ext_Lib = true
	loadfile(path)()
else
	print("ExtLib Not Found")
end	
]]
