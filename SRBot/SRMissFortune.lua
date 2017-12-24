PrintChat("MissFortune Loaded!")

local Q = {key = _Q,delay = 0.25, range = 650, bounceRange = 500, speed = 2400, radius = 50, mana = 0,type = 'line',LastTime = 0}
local E = {key = _E,delay = 0.25, range = 1000, radius = 80, speed = 4000, type = "circular",mana = 0}
local Exhaust = nil
local Ignite = nil
local Flash = nil
local Heal = nil
local Barrier = nil
local lastTick = 0 

function GetManaCost(spell)
	return myHero:GetSpellData(spell).mana
end


function _CustomHarass()
	if os.clock() - lastTick < 1 then return end
	lastTick = os.clock()
	local qtarget = heroCache:GetTarget(Q.range,1)
	if myHero:CanUseSpell(_Q) == READY and qtarget then
		CastTargetSpell(qtarget,_Q)
	end
	if myHero.mana/myHero.maxMana > 0.8 and Ready(_E) then
		local target = heroCache:GetTarget(E.range,1)
		if target then
			CastSkillShot(_E,target.pos)
		end
	end
	--return true
end

function _CustomCombo()
	local qtarget = heroCache:GetTarget(Q.range,1)
	if Ready(_Q) and qtarget then
		CastTargetSpell(qtarget,_Q)
	end
	if myHero.mana > 3*GetManaCost(_Q) + GetManaCost(_W) + GetManaCost(_E) and Ready(_E) then
		local target = heroCache:GetTarget(E.range,1)
		if target then
			CastSkillShot(_E,target.pos)
		end
	end
	if Ready(_W) then
		local target = heroCache:GetTarget(myHero.range + myHero.boundingRadius,1)
		if target then
			CastSpell(_W)
		end
	end
	return true
end


function _CustomKillSteal()
	
end
