if myHero.charName ~= "Kalista" then return end


require "DamageLib"
-- Spell Data
local Q = {Range = 1150,Delay = 0.25, Radius = 50, Speed = 1200}
local W = {Range = 5000}
local E = {Range = 950}
local R = {Range = 1100}
local EDamages = {}
local Oathsworn = nil
local RES = Game.Resolution()


-- Menu
local KalistaMenu = MenuElement({type = MENU, id = "KalistaMenu", name = "Kalista", leftIcon = "http://ddragon.leagueoflegends.com/cdn/7.1.1/img/champion/Kalista.png"})
--[[Key]]
KalistaMenu:MenuElement({type = MENU, id = "Key", name = "Key Settings"})
KalistaMenu.Key:MenuElement({id = "ComboKey", name = "Combo Key",key = 32 })
KalistaMenu.Key:MenuElement({id = "HarassKey", name = "Harass Key",key = string.byte("C") })
KalistaMenu.Key:MenuElement({id = "ClearKey", name = "Clear Key",key = string.byte("V") })
--[[Combo]]
KalistaMenu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
KalistaMenu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true})
KalistaMenu.Combo:MenuElement({id = "UseE", name = "Use E", value = true})

KalistaMenu:MenuElement({type = MENU, id = "Harass", name = "Harass Settings"})
KalistaMenu.Harass:MenuElement({id = "UseQ", name = "Use Q", value = true})
KalistaMenu.Harass:MenuElement({id = "UseE", name = "Use E On Killable Minion", value = true})
KalistaMenu.Harass:MenuElement({id = "Mana", name = "Min Mana (%)", value = 60,min = 0, max = 100, step = 1})

KalistaMenu:MenuElement({type = MENU, id = "Clear", name = "Clear Settings"})
KalistaMenu.Clear:MenuElement({id = "EMob", name = "Use E On Jungle Mobs", key = string.byte("T"),toggle = true})
KalistaMenu.Clear:MenuElement({id = "ESiege", name = "Use E On Siege", value = false})
KalistaMenu.Clear:MenuElement({id = "EKillMinion", name = "Use E kills X minions", value = 5,min = 1, max = 10, step = 1})

KalistaMenu:MenuElement({type = MENU, id = "Misc", name = "Misc Settings"})
KalistaMenu.Misc:MenuElement({id = "SaveAlly", name = "Use Ult to Save Ally", value = true})
KalistaMenu.Misc:MenuElement({id = "AllyHP", name = "Min Ally Health %", value = 20,min = 0, max = 100, step = 1})
KalistaMenu.Misc:MenuElement({id = "EBeforeDeath", name = "E Before Death", value = true})
KalistaMenu.Misc:MenuElement({id = "HPToEBeforeDeath", name = "Min Health % to use", value = 5,min = 0, max = 100, step = 1})

KalistaMenu:MenuElement({type = MENU, id = "Drawing", name = "Draw Settings"})
KalistaMenu.Drawing:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true})
KalistaMenu.Drawing:MenuElement({id = "DrawW", name = "Draw W Range (MiniMap)", value = true})
KalistaMenu.Drawing:MenuElement({id = "DrawE", name = "Draw E Range", value = true})
KalistaMenu.Drawing:MenuElement({id = "DrawR", name = "Draw R Range", value = true})
KalistaMenu.Drawing:MenuElement({id = "DrawEDmg", name = "Draw E Dmg", value = true})

function isReady(slot)
	return Game.CanUseSpell(slot) == 0
end

function isValidTarget(obj,range)
	range = range and range or math.huge
	return obj ~= nil and obj.valid and obj.visible and not obj.dead and obj.isTargetable and obj.distance <= range
end

function HasBuff(unit, buffname)
  for i = 0, unit.buffCount do
    local buff = unit:GetBuff(i)
    if buff.name == buffname and buff.count > 0 then 
      return true
    end
  end
  return false
end

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
		if isValidTarget(hero,range) and hero.isEnemy then
			N = N + 1
		end
	end
	return N	
end

function FindTheOath()
	if Oathsworn then return end
	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if not hero.isMe and hero.isAlly and HasBuff(hero,"kalistacoopstrikeally")  then
			--print("Found")
			Oathsworn = hero
		end
	end	
end

function AutoE()
	local hasE = false
	-- e KS
	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isEnemy and isValidTarget(hero,E.Range) then
			local stack = GetEStacks(hero)
			if stack > 0 then
				hasE = true
				EDamages[hero.networkID] = {Unit = hero, Damage = GetEDamage(hero,stack)}
			else
				EDamages[hero.networkID]  = nil
			end
			if stack > 0 and GetEDamage(hero,stack) > hero.health + hero.shieldAD then
				Control.CastSpell(HK_E)
				return
			end
		end
	end	
	if not hasE then return end
	-- e kills minions to harass
	for i = 1, Game.MinionCount() do	 
		local minion = Game.Minion(i)
		if minion.isEnemy and isValidTarget(minion,E.Range) then
			local stack = GetEStacks(minion)
			if stack > 0 and GetEDamage(minion,stack) > minion.health + minion.shieldAD and CountEnemy(myHero.pos,myHero.range+myHero.boundingRadius + 150) == 0 then
				Control.CastSpell(HK_E)
				return
			end
		end
	end	
	--e before death, 2 enemies around
	if KalistaMenu.Misc.EBeforeDeath:Value() and myHero.health/myHero.maxHealth < KalistaMenu.Misc.HPToEBeforeDeath:Value()/100 and CountEnemy(myHero.pos,550) > 1 then
		Control.CastSpell(HK_E)
	end
end

function GetEStacks(unit)
	if not unit then return 0 end
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff.name and buff.name:lower() == "kalistaexpungemarker"and  buff.count > 0 then
			return buff.count
		end
	end
	return 0
end

function GetEDamage(unit,stacks)
	local level = myHero:GetSpellData(_E).level
	local basedmg = ({20, 30, 40, 50, 60})[level] + 0.6* (myHero.totalDamage)
	local stacksdmg = (stacks - 1)*(({10, 14, 19, 25, 32})[level]+({0.2, 0.225, 0.25, 0.275, 0.3})[level] * myHero.totalDamage)
	return CalcPhysicalDamage(myHero,unit,basedmg + stacksdmg)
end


Callback.Add('Tick',function() 
	FindTheOath()
	if isReady(2) then
		AutoE()
	end
	if (KalistaMenu.Key.ComboKey:Value() and KalistaMenu.Combo.UseQ:Value()) or (KalistaMenu.Harass.UseQ:Value() and KalistaMenu.Key.HarassKey:Value() and myHero.mana/myHero.maxMana > KalistaMenu.Harass.Mana:Value()/100)	then
		if isReady(_Q) then
			local qTarget = GetUglyTarget(Q.Range)
			if qTarget and myHero.attackData.state ~= 2 and qTarget:GetCollision(Q.Radius,Q.Speed,Q.Delay) == 0 then
				local pos = qTarget:GetPrediction(Q.Speed,Q.Delay)
				Control.CastSpell(HK_Q,pos)
			end
		end
	end
	
	if isReady(2) then
		-- E kill mob
		local eminions = 0
		for i = 1, Game.MinionCount() do	 
			local minion = Game.Minion(i)
			if isValidTarget(minion,E.Range) and not minion.isAlly then
				local stacks  = GetEStacks(minion)
				local eDmg = 0
				if stacks > 0 then
					eDmg = GetEDamage(minion,stacks)
					EDamages[minion.networkID] = {Unit = minion,Damage = eDmg}
				elseif EDamages[minion.networkID] then
					EDamages[minion.networkID] = nil
				end
				if stacks > 0 and eDmg > minion.health then
					if (minion.team == 300 and KalistaMenu.Clear.EMob:Value()) or (minion.charName:find("Siege") and KalistaMenu.Clear.ESiege:Value())then	
						Control.CastSpell(HK_E)
					else
						eminions = eminions + 1	
					end
				end
				
			end	
		end
		if KalistaMenu.Key.ClearKey:Value() and eminions >= KalistaMenu.Clear.EKillMinion:Value() then
			Control.CastSpell(HK_E)
		end
	end
	
	if isReady(3) and Oathsworn and KalistaMenu.Misc.SaveAlly:Value() then
		if isValidTarget(Oathsworn,R.Range) then
			if Oathsworn.health/Oathsworn.maxHealth <= KalistaMenu.Misc.AllyHP:Value()/100 and CountEnemy(Oathsworn.pos,500) > 0 then
				Control.CastSpell(HK_R)
			end
		end	
	end
end)

Callback.Add("Draw", function()
	if myHero.dead then return end
	if KalistaMenu.Drawing.DrawQ:Value() and myHero:GetSpellData(0).level > 0 then
		local qcolor = isReady(0) and  Draw.Color(189, 183, 107, 255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),Q.Range,1,qcolor)
	end
	if KalistaMenu.Drawing.DrawR:Value() and myHero:GetSpellData(3).level > 0  then
		local rcolor = isReady(3) and  Draw.Color(240,30,144,255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),R.Range,1,rcolor)
	end
	if KalistaMenu.Drawing.DrawE:Value() and myHero:GetSpellData(2).level > 0 then
		local ecolor = isReady(2) and  Draw.Color(233, 150, 122, 255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),E.Range,1,ecolor)
	end
	if KalistaMenu.Drawing.DrawW:Value() and myHero:GetSpellData(1).level > 0 then
		local wcolor = isReady(1) and  Draw.Color(189, 183, 107, 255) or Draw.Color(240,255,0,0)
		Draw.CircleMinimap(Vector(myHero.pos),W.Range,1,wcolor)
	end
	if KalistaMenu.Drawing.DrawEDmg:Value() and isReady(2) then
		for i,info in pairs(EDamages) do
			local unit = info.Unit
			if unit and isValidTarget(unit) then
				local percentage = tostring(0.1*math.floor(1000*info.Damage/(unit.health))).."%"
				Draw.Text(percentage,20,unit.pos:To2D())
			elseif unit then	
				EDamages[unit.networkID] = nil
			end
		end
	end
	local text = KalistaMenu.Clear.EMob:Value() and "ON" or "OFF"
	local color = KalistaMenu.Clear.EMob:Value() and Draw.Color(150, 0, 255, 0) or Draw.Color(150,255,0,0)
	text = "KS Mob: "..text
	local rec = Draw.FontRect(text,20)
	Draw.Text(text,20,RES.x/2 - rec.x,RES.y*0.75,color)
	text = "E Kills "..tostring(KalistaMenu.Clear.EKillMinion:Value()).." Minions"
	Draw.Text(text,20,RES.x/2 - rec.x,RES.y*0.75 + rec.y,Draw.Color(150, 0, 255, 0))
end)
