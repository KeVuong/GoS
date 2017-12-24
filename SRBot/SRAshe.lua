PrintChat(myHero.charName.." Custom Spell Loaded!!!")

local	Q = {delay = 0.25, range = 1300, speed = 1500, radius = 20, ready = false, type = "line", mana = 50 }
local	W = {delay = 0.25, range = 1250 }
local	E = {key = _E,range = 1200, ready = false,mana = 90}
local	R = {delay = 0.25, range = 2500, speed = 1600, radius = 80, ready = false, type = "line",col = {"champion"},mana = 100 }
	
function _CustomHarass()
	if myHero:CanUseSpell(_Q) == READY then
		local target = heroCache:GetTarget(myHero.range + myHero.boundingRadius,1)
		if target then
			CastSpell(_Q)
		end
	end
	if Ready(_W) then
		local target = heroCache:GetTarget(W.range,1)
		if target then
			CastSkillShot(_W,target.pos)
		end
	end
	
	if Ready(_R) then
		local target = heroCache:GetTarget(W.range,1)
		if target and target.health/target.maxHealth < 0.45 then
			CastSkillShot(_R,target.pos)
		end
	
	end
end

function _CustomCombo()
	if myHero:CanUseSpell(_Q) == READY then
		local target = heroCache:GetTarget(myHero.range + myHero.boundingRadius,1)
		if target then
			CastSpell(_Q)
		end
	end
	if Ready(_W) then
		local target = heroCache:GetTarget(W.range,1)
		if target then
			CastSkillShot(_W,target.pos)
		end
	end
	
	if Ready(_R) then
		local target = heroCache:GetTarget(W.range,1)
		if target and target.health/target.maxHealth < 0.45 then
			CastSkillShot(_R,target.pos)
		end
	
	end
end

function _CustomKillSteal()
	if Ready(_W)  then
	
	end
end
