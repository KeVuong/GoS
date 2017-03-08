

if myHero.charName ~= "Karthus" then return end
--require "DamageLib"


function CalcMagicalDamage(source, target, amount)
  local mr = target.magicResist
  local value = 100 / (100 + (mr * source.magicPenPercent) - source.magicPen)

  if mr < 0 then
    value = 2 - 100 / (100 - mr)
  elseif (mr * source.magicPenPercent) - source.magicPen < 0 then
    value = 1
  end
  return value * amount
end


local Version = '0.21'

local Q = {Delay = 0.15,Radius = 135,Range = 890,Speed = math.huge}
local W = {Delay = 0.5,Radius = 60,Range = 1000,Speed = math.huge}--20.000
local E = {Delay = 0.75,Radius = 60 ,Range = 520,Speed = math.huge}
local R = {Delay = 0.6,Radius = 100,Range = 25000,Speed = math.huge}
local Exhaust = myHero:GetSpellData(SUMMONER_1).name:find("Exhaust") and HK_SUMMONER_1 or myHero:GetSpellData(SUMMONER_2).name:find("Exhaust") and HK_SUMMONER_2 or nil
local ExhaustSlot = Exhaust == HK_SUMMONER_1 and SUMMONER_1 or Exhaust == HK_SUMMONER_2 and SUMMONER_2 or nil

local Buffs = {}
local SelectedTarget = nil
local QCastT = 0
local QStartT = 0
local QFarmT = 0
local LastW= 0 
local LastE =  0
local LastR = 0
local LastDmg = 0
local RDamages = {}
-- Menu
local KarthusMenu = MenuElement({type = MENU, id = "KarthusMenu", name = "ExtLib: Karthus", leftIcon = "http://ddragon.leagueoflegends.com/cdn/6.1.1/img/champion/Karthus.png"})

--[[Key]]
KarthusMenu:MenuElement({type = MENU, id = "Key", name = "Key Settings"})
KarthusMenu.Key:MenuElement({id = "Combo", name = "Combo Key",key = 32 })
KarthusMenu.Key:MenuElement({id = "Harass", name = "Harass Key",key = string.byte("C") })
KarthusMenu.Key:MenuElement({id = "LastHit", name = "LastHit Key",key = string.byte("X") })
KarthusMenu.Key:MenuElement({id = "LaneClear", name = "LaneClear Key",key = string.byte("V") })

--[[Combo]]
KarthusMenu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
KarthusMenu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true})
KarthusMenu.Combo:MenuElement({id = "UseW", name = "Use W", value = true})
KarthusMenu.Combo:MenuElement({id = "UseE", name = "Use E", value = true})
if Exhaust then
	KarthusMenu.Combo:MenuElement({id = "Exhaust", name = "Use Exhaust", value = true})
end
	
--[[]]
KarthusMenu:MenuElement({type = MENU, id = "Harass", name = "Harass Settings"})
KarthusMenu.Harass:MenuElement({id = "UseQ", name = "Use Q", value = true})
KarthusMenu.Harass:MenuElement({id = "Mana", name = "Min Mana (%) to Harass", value = 60, min = 1, max = 100, step = 1})
KarthusMenu.Harass:MenuElement({id = "LastHitQ", name = "LastHit Q", value = true})

KarthusMenu:MenuElement({type = MENU, id = "LaneClear", name = "LaneClear Settings"})
KarthusMenu.LaneClear:MenuElement({id = "UseQ", name = "Use Q", value = true})
KarthusMenu.LaneClear:MenuElement({id = "UseE", name = "Use E", value = true})
KarthusMenu.LaneClear:MenuElement({id = "MinionQ", name = "Min Minions to Use Q", value = 1, min = 1, max = 10, step = 1})
KarthusMenu.LaneClear:MenuElement({id = "MinionE", name = "Min Minions to Use E", value = 5, min = 1, max = 10, step = 1})
KarthusMenu.LaneClear:MenuElement({id = "Mana", name = "Min Mana (%) to Clear", value = 30, min = 1, max = 100, step = 1})

KarthusMenu:MenuElement({type = MENU, id = "Ultimate", name = "Ult Settings"})
KarthusMenu.Ultimate:MenuElement({id = "AutoR", name = "Auto R", value = false})


KarthusMenu:MenuElement({type = MENU, id = "Drawing", name = "Drawing Settings"})
KarthusMenu.Drawing:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true})
KarthusMenu.Drawing:MenuElement({id = "DrawW", name = "Draw W Range", value = true})
KarthusMenu.Drawing:MenuElement({id = "DrawE", name = "Draw E Range", value = true})
KarthusMenu.Drawing:MenuElement({id = "DrawText", name = "Draw Kill Text", value = true})

KarthusMenu:MenuElement({type = SPACE, id = "Version", name = "Version: "..Version})

function isReady(slot)
	return Game.CanUseSpell(slot) == READY
end

function GetTarget(range)
	local result = nil
	local N = 0
	for i = 1,Game.HeroCount()  do
		local hero = Game.Hero(i)	
		if ValidTarget(hero,range) and hero.team ~= myHero.team then
			local dmgtohero = CalcMagicalDamage(myHero,hero,100)
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
		if ValidTarget(hero,range) and hero.isEnemy then
			N = N + 1
		end
	end
	return N	
end

function ValidTarget(unit,range,from)
	from = from or myHero.pos
	range = range or math.huge
	return unit and unit.valid and not unit.dead and unit.visible and unit.isTargetable and GetDistanceSqr(unit.pos,from) <= range*range
end

function GetDistanceSqr(p1, p2)
    assert(p1, "GetDistance: invalid argument: cannot calculate distance to "..type(p1))
    p2 = p2 or myHero.pos
    return (p1.x - p2.x) ^ 2 + ((p1.z or p1.y) - (p2.z or p2.y)) ^ 2
end

function GetDistance(p1, p2)
    return math.sqrt(GetDistanceSqr(p1, p2))
end

function GetBestCircularFarmPosition(range, radius, objects)

    local BestPos 
    local BestHit = 0
    for i, object in pairs(objects) do
        local hit = CountObjectsNearPos(object.pos, range, radius, objects)
        if hit > BestHit then
            BestHit = hit
            BestPos = object.pos
            if BestHit == #objects then
               break
            end
         end
    end

    return BestPos, BestHit

end

function CountObjectsNearPos(pos, range, radius, objects)

    local n = 0
    for i, object in pairs(objects) do
        if GetDistanceSqr(pos, object.pos) <= radius * radius then
            n = n + 1
        end
    end

    return n

end

-- Main

function OnTick()
	if CountEnemy(myHero.pos,E.Range) >= 3 then
		local slot = GetItemSlot(myHero,3157)
		if slot > 0 and Game.CanUseSpell(slot) == READY then
			if myHero:GetSpellData(_E).toggleState == 1 and Game.CanUseSpell(_E) == READY then
				Control.CastSpell(HK_E)	
			end
			DelayAction(function() Control.CastSpell(slot) end, 0.1)
		end
	end
	if isReady(_R) and os.clock() - LastDmg > 0.5 then -- wood pc
		LastDmg = os.clock()
		for i = 1,Game.HeroCount()  do
			local hero = Game.Hero(i)
			if hero.isEnemy and ValidTarget(hero) then
				RDamages[hero.networkID] = GetDamage(_R,hero,myHero)
			end
		end	
	end
	if KarthusMenu.Key.Combo:Value() then
		Combo()
	elseif KarthusMenu.Key.Harass:Value() then
		Harass()
	elseif KarthusMenu.Key.LaneClear:Value() then
		LaneClear()
	elseif KarthusMenu.Key.LastHit:Value() then
		LastHit()
	end
end


function DisableOrb(OW)
	OW.enableAttack = false
	OW.enableMove = false
end

function EnableOrb(OW)
	OW.enableAttack = true
	OW.enableMove = true
end


function Combo(OW)
	local qtarget = GetTarget(Q.Range)	
	local wtarget = GetTarget(W.Range)
	local etarget = GetTarget(E.Range)
	local disable = false
	if Exhaust and Game.CanUseSpell(ExhaustSlot) == READY and KarthusMenu.Combo.Exhaust:Value() then
		if etarget and etarget.health < GetComboDamage(etarget) and etarget.health > GetComboDamage2(etarget) then
			--SpellCast:CastSpell(Exhaust,etarget)
			Control.CastSpell(Exhaust,etarget)
		end
	end
	
	if qtarget and Game.CanUseSpell(_Q) == READY then
		CastQ(qtarget)
	end
	
	if Game.CanUseSpell(_W) == READY and wtarget  then
		CastW(wtarget)
	end
	
	if Game.CanUseSpell(_E) == READY and etarget and myHero:GetSpellData(_E).toggleState == 1 and myHero.mana > GetManaCost(_R) + GetManaCost(_E) + 2*GetManaCost(_Q) then 
		Control.CastSpell(HK_E)	
	elseif 	Game.CanUseSpell(_E) == READY and myHero:GetSpellData(_E).toggleState == 2 and (not etarget or myHero.mana < GetManaCost(_R) + 2*GetManaCost(_Q)) then 
		Control.CastSpell(HK_E)	
	end
end

function LaneClear()
	if myHero.mana < KarthusMenu.LaneClear.Mana:Value()*myHero.maxMana*0.01 then return end
	if myHero.attackData.state == 2 then return end
	local qminions = {}
	local eminions = {}
	for i = 1, Game.MinionCount() do
		local minion = Game.Minion(i)
		if ValidTarget(minion,E.Range) then
			table.insert(eminions,minion)
		end
		if ValidTarget(minion,Q.Range) then
			table.insert(qminions,minion)
		end
	end

	if Game.CanUseSpell(_E) == READY and myHero:GetSpellData(_E).toggleState == 1 and myHero.mana > KarthusMenu.LaneClear.Mana:Value()*myHero.maxMana*0.01 and #eminions >= KarthusMenu.LaneClear.MinionE:Value() then 
		Control.CastSpell(HK_E)
	elseif 	Game.CanUseSpell(_E) == READY and myHero:GetSpellData(_E).toggleState == 2 and #eminions < KarthusMenu.LaneClear.MinionE:Value() then
		Control.CastSpell(HK_E)
	end
	if Game.CanUseSpell(_Q) == READY and OW:CanMove() then
		local qPos,qHit = GetBestCircularFarmPosition(Q.Range,Q.Radius + 40,qminions)
		if qHit >= KarthusMenu.LaneClear.MinionQ:Value() then
			--SpellCast:CastSpell(HK_Q,qPos)
			Control.CastSpell(HK_Q,qPos)
			return
		end
	end
	
end

function Harass()
--	OW.enableAttack = false
	if myHero.attackData.state ~= 1 then return end
	local qtarget = GetTarget(Q.Range)
	if qtarget and Game.CanUseSpell(_Q) == READY  then
		CastQ(qtarget)
	end

	for i = 1, Game.MinionCount() do
		local minion = Game.Minion(i)
		if Game.CanUseSpell(_Q) == READY and ValidTarget(minion,Q.Range) and (GetDistanceSqr(minion.pos,myHero.pos) > myHero.range + myHero.boundingRadius + minion.boundingRadius or myHero:GetSpellData(_Q).level > 4) and GetDamage(_Q,minion,myHero) > minion.health and myHero.attackData.state ~= 2 then
			CastQ(minion)
			return
		end
	end
	--OW.enableAttack = true
end

function LastHit()
	if myHero.attackData.state ~= 1 then return end
	for i = 1, Game.MinionCount() do
		local minion = Game.Minion(i)
		if Game.CanUseSpell(_Q) == READY and ValidTarget(minion,Q.Range) and (GetDistanceSqr(minion.pos,myHero.pos) > myHero.range + myHero.boundingRadius + minion.boundingRadius  or myHero:GetSpellData(_Q).level > 4) and GetDamage(_Q,minion,myHero) > minion.health then--q dmg > attack dmg
			CastQ(minion)
			return
		end
	end
	
end

function CastQ(target)
	if Pred then
		local CastPosition,Hitchance = Pred:GetPrediction(qtarget,Q)
		if  Hitchance == "High" then
			LastQPos = CastPosition
			SpellCast:CastSpell(HK_Q,CastPosition)
		end
		return
	end	
	local pos = target:GetPrediction(Q.Speed,Q.Delay)
	Control.CastSpell(HK_Q,pos)
end

function CastW(target)
	if Pred then
		local CastPosition,Hitchance  = Pred:GetPrediction(wtarget,W)
		if Hitchance == "High" then	
			disable = true
			SpellCast:CastSpell(HK_W,CastPosition)
		end
		return
	end
	local pos = target:GetPrediction(W.Speed,W.Delay)
	Control.CastSpell(HK_W,pos)	
end


function OnDraw()
	if myHero.dead then return end
	if LastQPos then 
		Draw.Circle(LastQPos,135,1,Draw.Color(255, 228, 196, 255))
	end
	if KarthusMenu.Drawing.DrawQ:Value() and myHero:GetSpellData(_Q).level > 0 then
		Draw.Circle(myHero.pos,Q.Range,1,Draw.Color(200, 228, 196, 255))
	end	
	if KarthusMenu.Drawing.DrawE:Value() and myHero:GetSpellData(_E).level > 0 then
		Draw.Circle(myHero.pos,E.Range,1,Draw.Color(200, 255, 255, 255))
	end
	if KarthusMenu.Drawing.DrawText:Value() and isReady(_R) then
		local rkills = {}
		for i = 1,Game.HeroCount()  do
			local hero = Game.Hero(i)
			if hero.isEnemy and ValidTarget(hero) and RDamages[hero.networkID] then
				if RDamages[hero.networkID] > hero.health then
					table.insert(rkills,hero)
					if hero.pos:To2D().onScreen then
						Draw.Text("R Killable!",20,Vector(hero.pos):To2D())
					else
						--PrintChat("Enemy "..hero.charName.." Is Killable")
					end					
				end
			end
		end	
		if #rkills > 0 then
			Draw.Text("R Will Kill "..tostring(#rkills).." enemies" ,20,Vector(myHero.pos):To2D())--kappa
		end
	end
end


function isE2()
	return myHero:GetSpellData(_E).toggleState == 2
end

function GetManaCost(slot)
	if slot == _R and Game.CanUseSpell(slot) ~= READY then
		return 0
	end
	return myHero:GetSpellData(slot).mana
end

function GetComboDamage(unit)
	local dmg = GetDamage(_Q,unit)*4
	if myHero:GetSpellData(_E).level > 0 then
		dmg = dmg + 2*GetDamage(_E,unit)
	end
	if Game.CanUseSpell(_R) == READY then
		dmg = dmg + GetDamage(_R)
	end
	return CalcMagicalDamage(myHero,unit,dmg)
end

function GetComboDamage2(unit)
	local dmg = GetDamage(_Q,unit)*2
	if myHero:GetSpellData(_E).level > 0 then
		dmg = dmg + GetDamage(_E,unit)
	end
	if Game.CanUseSpell(_R) == READY then
		dmg = dmg + GetDamage(_R)
	end
	return CalcMagicalDamage(myHero,unit,dmg)
end

function GetDamage(slot,unit)
	if slot == _Q then
		local dmg = ({40, 60, 80, 100, 120})[myHero:GetSpellData(_Q).level] + 0.3 * myHero.ap
		return CalcMagicalDamage(myHero,unit,dmg)
	end
	if slot == _R then
		local dmg = ({250, 400, 550})[myHero:GetSpellData(_R).level] + 0.6 * myHero.ap 
		return CalcMagicalDamage(myHero,unit,dmg)
	end
	if slot == _E then
		local dmg = ({30, 50, 70, 90, 110})[myHero:GetSpellData(_E).level] + 0.2 * myHero.ap
		return CalcMagicalDamage(myHero,unit,dmg)
	end
end
