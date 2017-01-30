local loaded = false
if not (Game.Timer() > 30 or Game.HeroCount() > 1) then
	print("Please wait a few seconds before script is loaded")
end

Callback.Add("Tick",function()
	if not loaded and (Game.Timer() > 30 or Game.HeroCount() > 1) then
		loaded = true
		  require "ExternalLib"
	end
end)
