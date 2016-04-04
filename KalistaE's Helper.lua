if GetObjectName(GetMyHero()) ~= "Kalista" then return end
	


local menu = MenuConfig("Helper","KalistaE's Helper")
menu:Boolean("Enable", "Lasthit helper", true)


-- 
GoSWalk:RegisterOnNonKillableMinion(function(minion) KalistaOnNonKillableMinion(minion) end)

local eStacks = {}
OnUpdateBuff(function(unit,buff) 
	if unit.team ~= myHero.team and buff.Name == "kalistaexpungemarker" then
		eStacks[unit.networkID] = buff.Count
	end
end)

OnRemoveBuff(function(unit,buff) 
	if unit.team ~= myHero.team and buff.Name == "kalistaexpungemarker" then
		
		eStacks[unit.networkID] = nil
	end
end)

function KalistaOnNonKillableMinion(minion)
	if eStacks[minion.networkID] and myHero:CanUseSpell(_E) == READY and menu.Enable:Value() then
		print("Cast E")
		CastSpell(_E)-- need to calc E dmg 
	
	end

end
