if myHero.charName ~= "Thresh" then return end

local path = SCRIPT_PATH.."Loader.lua"

if FileExist(path) then
	_G.Enable_Ext_Lib = true
	loadfile(path)()
end	

-- Spell Data
local Q = {Delay = 0.5,Radius = 80,Range = 1050,Speed = 1900,CollisionObjects = {"Hero","Minion"}}

local W = {delay = 0.25,radius = 80,range = 950,speed = 1900}
local E = {delay = 0.250,radius = 80,range = 460,speed = 2000}
local R = {delay = 0.35,radius = 80,range = 400,speed = 1900}
local Ts = TargetSelector
local Pred = Prediction
local lastq = 0
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
ThreshMenu.Combo:MenuElement({id = "UseQ2", name = "Use Q2", value = true})
ThreshMenu.Combo:MenuElement({id = "DelayQ", name = "Delay Q1 and Q2 (s)", value = 0.5,min = 0.1,max = 0.9,step = 0.01})
ThreshMenu.Combo:MenuElement({id = "MinQ", name = "Min Distance to Q", value = 150,min = 0,max = 1050,step = 1})


ThreshMenu:MenuElement({type = MENU, id = "Ultimate", name = "Auto Ult Settings"})
ThreshMenu.Ultimate:MenuElement({id = "Min", name = "Min enemies around", value = 2,min = 1, max = 5, step = 1})

ThreshMenu:MenuElement({type = MENU, id = "AutoLantern", name = "AutoLantern Settings"})
ThreshMenu.AutoLantern:MenuElement({id = "savehp", name = "Save Allies When HP below ", value = 20,min = 0, max = 100, step = 5})
ThreshMenu.AutoLantern:MenuElement({id = "shieldhp", name = "Shield Allies on CC", value = 60 ,min = 0, max = 100, step = 5})

ThreshMenu:MenuElement({type = MENU, id = "Drawing", name = "Drawing Settings"})
ThreshMenu.Drawing:MenuElement({id = "QRange", name = "Q Range", value = true})
ThreshMenu.Drawing:MenuElement({id = "ERange", name = "E Range", value = true})

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

function UltHit(pos,range)
	local N = 0
	for i = 1,Game.HeroCount()  do
		local hero = Game.Hero(i)	
		if isValidTarget(hero,range + hero.boundingRadius) and hero.isEnemy and hero.distance > 150 then
			N = N + 1
		end
	end
	return N	
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

function OnTick() 
	if ThreshMenu.Key.ComboKey:Value()	then
		if isReady(_Q) and isQ2() and ThreshMenu.Combo.UseQ2:Value() and Game.Timer() - myHero:GetSpellData(_Q).castTime > ThreshMenu.Combo.DelayQ:Value() then
			Control.CastSpell("Q")
		end
		if isReady(_Q) and isQ1() and ThreshMenu.Combo.UseQ:Value() then
			local target = Ts:GetTarget(Q.Range)
			if target and GetDistance(target.pos,myHero.pos) >= ThreshMenu.Combo.MinQ:Value() then
				local CastPosition, HitChance =  Pred:GetPrediction(target,Q)
				--LastPos = CastPosition
				if HitChance == "High" then
					SpellCast:Add("Q",CastPosition)
					--Control.CastSpell("Q",CastPosition)
				end
			end
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
	if isReady(_R) and UltHit(myHero.pos,R.range) >= ThreshMenu.Ultimate.Min:Value() then
		Control.CastSpell("R")
	end
	if isReady(_W) then
		for i = 1,Game.HeroCount()  do
			local hero = Game.Hero(i)	
			if isValidTarget(hero,W.range) and hero.isAlly then
				if hero.health/hero.maxHealth <= ThreshMenu.AutoLantern.shieldhp:Value()/100 and IsImmobileTarget(hero) then
					Control.CastSpell("W",hero.pos)--hero:GetPrediction(W.speed,W.delay)
				end
				if hero.health/hero.maxHealth <= ThreshMenu.AutoLantern.savehp:Value()/100 and CountEnemy(hero.pos,500) > 0 then
					Control.CastSpell("W",hero.pos)
				end
			end
		end	
	end
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
	if ThreshMenu.Drawing.QRange:Value() then
		Draw.Circle(myHero.pos,Q.Range,1,Draw.Color(255, 228, 196, 255))
	end	
	if ThreshMenu.Drawing.ERange:Value() then
		Draw.Circle(myHero.pos,E.range,1,Draw.Color(255, 228, 196, 255))
	end	
	if LastPos then 
		Draw.Circle(LastPos,80,2,Draw.Color(255, 228, 196, 255))
	end
end


--Some useful stuffs

function isQ1()
	return myHero:GetSpellData(_Q).name == "ThreshQ"
end

function isQ2()
	return myHero:GetSpellData(_Q).name == "ThreshQLeap"
end

function isReady(slot)
	return myHero:GetSpellData(slot).level > 0 and myHero:GetSpellData(slot).currentCd == 0 and (myHero.mana >= myHero:GetSpellData(slot).mana)
end

function isValidTarget(obj,range)
	range = range or math.huge
	return obj ~= nil and obj.valid and obj.visible and not obj.dead and obj.isTargetable and obj.distance <= range
end

function IsImmobileTarget(unit)
	assert(unit, "IsImmobileTarget: invalid argument: unit expected got "..type(unit))
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and (buff.type == 5 or buff.type == 11 or buff.type == 29 or buff.type == 24 ) and buff.count > 0 then
			return true
		end
	end
	return false	
end
