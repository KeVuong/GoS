--Icesythe7
function file_exists(path)
  assert(type(path) == "string", "file_exists: wrong argument types (<string> expected for path)")
  local file = io.open(path, "r")
  if file then file:close() return true else return false end
end
 
if not file_exists(COMMON_PATH.. "GoSWalk.lua") then
  DownloadFileAsync("https://raw.githubusercontent.com/KeVuong/GoS/master/GoSWalk.lua", COMMON_PATH .. "GoSWalk.lua", function() PrintChat("Downloaded GoSWalk, please 2x F6!") return end)
else
  require "GoSWalk"
end
-- end Icesythe7
local Walk = Orbwalking()
Walk:LoadMenu()
