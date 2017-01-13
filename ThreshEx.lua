if myHero.charName ~= "Thresh" then return end

require "DamageLib"
-- Spell Data
local Q = {delay = 0.5,radius = 80,range = 1050,speed = 1900}
local W = {delay = 0.25,radius = 80,range = 950,speed = 1900}
local E = {delay = 0.250,radius = 200,range = 450,speed = 2000}
local R = {delay = 0.35,radius = 80,range = 400,speed = 1900}

-- Menu
local ThreshMenu = MenuElement({type = MENU, id = "ThreshMenu", name = "Thresh (Alpha)", leftIcon = "http://puu.sh/tkApW/5b630c1ecc.png"})
--[[Key]]
ThreshMenu:MenuElement({type = MENU, id = "Key", name = "Key Settings"})
ThreshMenu.Key:MenuElement({id = "ComboKey", name = "Combo Key",key = 32 })
ThreshMenu.Key:MenuElement({id = "PullKey", name = "Pull Key",key = string.byte("T") })
ThreshMenu.Key:MenuElement({id = "PushKey", name = "Push Key",key = string.byte("G") })
--[[Combo]]
ThreshMenu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
ThreshMenu.Combo:MenuElement({id = "UseQ", name = "Use Q1", value = true})
--ThreshMenu.Combo:MenuElement({id = "UseE", name = "Use E", value = true})

ThreshMenu:MenuElement({type = MENU, id = "Ultimate", name = "Auto Ult Settings"})
ThreshMenu.Ultimate:MenuElement({id = "Min", name = "Min enemies around", value = 3,min = 1, max = 5, step = 1})

ThreshMenu:MenuElement({type = MENU, id = "AutoLantern", name = "AutoLantern Settings"})
ThreshMenu.AutoLantern:MenuElement({id = "MinHealth", name = "Min Ally Health %", value = 20,min = 0, max = 100, step = 5})




function GetUglyTarget(range)
	local result = nil
	local N = 0
	for i = 1,Game.HeroCount()  do
		local hero = Game.Hero(i)	
		if isValidTarget(hero,range) and hero.team ~= myHero.team then
			local dmgtohero = getdmg("AA",hero,myHero)
			local tokill = hero.health/dmgtohero
			if tokill > N or result == nil then
				result = hero
			end
		end
	end
	return result
end

function CountEnemy(pos,range)
	local N = 0
	for i = 1,Game.HeroCount()  do
		local hero = Game.Hero(i)	
		if isValidTarget(hero,range) and hero.team ~= myHero.team then
			N = N + 1
		end
	end
	return N	
end
-- Main

Callback.Add('Tick',function() 

	if ThreshMenu.Key.ComboKey:Value()	then
		if isReady(_Q) and isQ1() then
			local target = GetUglyTarget(Q.range - 90)
			if target and target:GetCollision(Q.radius,Q.speed,Q.delay) == 0 and (not isReady(_E) or target.distance > 400) then
				local pos = target:GetPrediction(Q.speed,Q.delay)
				local v1 = Vector(pos) - Vector(myHero.pos)
				local v2 = Vector(target.pos) - Vector(myHero.pos)
				if v1:Angle(v2) < 90 then
					Control.CastSpell("Q",pos)
				end	
			end
		end
		local etarget = GetUglyTarget(E.range)
		
		if etarget then
			CastEPull(etarget)
		end
	end
	if ThreshMenu.Key.PushKey:Value()	then
		local etarget = GetUglyTarget(E.range)
		if etarget then 
			CastEPush(etarget)
		end
	elseif ThreshMenu.Key.PullKey:Value()	then
	
		local etarget = GetUglyTarget(E.range)
		
		if etarget then 
			CastEPull(etarget)
		end
	end
	if isReady(_R) and CountEnemy(myHero.pos,R.range) >= ThreshMenu.Ultimate.Min:Value() then
		Control.CastSpell("R")
	end
	if isReady(_W) then
		for i = 1,Game.HeroCount()  do
			local hero = Game.Hero(i)	
			if isValidTarget(hero,W.range) and hero.team == myHero.team then
				if hero.health/hero.maxHealth <= ThreshMenu.AutoLantern.MinHealth:Value()/100 and CountEnemy(hero.pos,500) > 0 then
					Control.CastSpell("W",hero.pos)
				end
			end
		end	
	end
end)

function CastQ(target)
	
end

function CastQ2(target)

end


function CastEPush(target)
	if not isReady(_E) then return end
	local pos = target:GetPrediction(E.speed, E.delay)
	Control.CastSpell("E",pos)
end

function CastEPull(target)
	if not isReady(_E) then return end
	local pos = target:GetPrediction(E.speed, E.delay)
	pos = Vector(myHero.pos) + (Vector(myHero.pos) - Vector(pos)):Normalized()*400
	Control.CastSpell("E",pos)
end


function OnDraw()
	if myHero.dead then return end
	Draw.Circle(myHero.pos,Q.range,1,Draw.Color(255, 228, 196, 255))
end


--Some useful stuffs

function isQ1()
	return myHero:GetSpellData(_Q).name == "ThreshQ"
end

function isQ2()
	return myHero:GetSpellData(_Q).name == "ThreshQLeap"
end

function isReady(slot)
	return myHero:GetSpellData(_Q).currentCd < 0.099
end

function isValidTarget(obj,range)
	return obj ~= nil and obj.valid and obj.visible and not obj.dead and obj.isTargetable and obj.distance <= range
end
