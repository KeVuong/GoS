
if myHero.charName ~= "Karthus" then return end
local path = SCRIPT_PATH.."ExtLib.lua"

if FileExist(path) then
	_G.Enable_Ext_Lib = true
	loadfile(path)()
else
	print("ExtLib Not Found. You need to install ExtLib before using this script")
	return
end	
local Q = {Delay = 0.75,Radius = 135,Range = 890,Speed = math.huge}
local W = {Delay = 0.5,Radius = 60,Range = 1000,Speed = math.huge}--20.000
local E = {Delay = 0.75,Radius = 60 ,Range = 520,Speed = math.huge}
local R = {Delay = 0.6,Radius = 100,Range = 25000,Speed = math.huge}
local Exhaust = myHero:GetSpellData(SUMMONER_1).name:find("Exhaust") and HK_SUMMONER_1 or myHero:GetSpellData(SUMMONER_2).name:find("Exhaust") and HK_SUMMONER_2 or nil
local Ts = TargetSelector
local Pred = Prediction

local Buffs = {}

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
KarthusMenu.Ultimate:MenuElement({id = "AutoR", name = "Auto R", value = true})


KarthusMenu:MenuElement({type = MENU, id = "Drawing", name = "Drawing Settings"})
KarthusMenu.Drawing:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true})
KarthusMenu.Drawing:MenuElement({id = "DrawW", name = "Draw W Range", value = true})
KarthusMenu.Drawing:MenuElement({id = "DrawE", name = "Draw E Range", value = true})
KarthusMenu.Drawing:MenuElement({id = "DrawText", name = "Draw Kill Text", value = true})


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
	
	if isReady(_R) and os.clock() - LastDmg > 0.5 then -- wood pc
		LastDmg = os.clock()
		for i = 1,Game.HeroCount()  do
			local hero = Game.Hero(i)
			if hero.isEnemy and ValidTarget(hero) then
				RDamages[hero.networkID] = GetDamage(_R,hero,myHero)
			end
		end	
	end
	
end

OnActiveMode(function(OW,Minions)
	if OW.Mode == "Combo" then
		Combo(OW)
	elseif OW.Mode == "Harass" then	 
		Harass(OW,Minions)
	elseif OW.Mode == "LaneClear" then	
		LaneClear(OW,Minions)
	elseif OW.Mode == "LastHit" then	
		LastHit(OW,Minions)
	end
	--EnableOrb(OW)
end)

function DisableOrb(OW)
	OW.enableAttack = false
	OW.enableMove = false
end

function EnableOrb(OW)
	OW.enableAttack = true
	OW.enableMove = true
end


function Combo(OW)
	local qtarget = Ts:GetTarget(Q.Range)	
	local wtarget = Ts:GetTarget(W.Range)
	local etarget = Ts:GetTarget(E.Range)
	local disable = false
	if qtarget and Game.CanUseSpell(_Q) == READY then
		local CastPosition,Hitchance = Pred:GetPrediction(qtarget,Q)
		if  Hitchance == "High" then
			LastQPos = CastPosition
			SpellCast:CastSpell(HK_Q,CastPosition)
		end
	end
	
	if Game.CanUseSpell(_W) == READY and wtarget  then
		local CastPosition,Hitchance  = Pred:GetPrediction(wtarget,W)
		if Hitchance == "High" then	
			disable = true
			SpellCast:CastSpell(HK_W,CastPosition)
		end
	end
	
	if Game.CanUseSpell(_E) == READY and etarget and myHero:GetSpellData(_E).toggleState == 1 and myHero.mana > GetManaCost(_R) + GetManaCost(_E) + 2*GetManaCost(_Q) then 
		Control.CastSpell(HK_E)	
	elseif 	Game.CanUseSpell(_E) == READY and myHero:GetSpellData(_E).toggleState == 2 and (not etarget or myHero.mana < GetManaCost(_R) + 2*GetManaCost(_Q)) then 
		Control.CastSpell(HK_E)	
	end
	if qtarget and myHero.totalDamage < qtarget.health then
		OW.enableAttack = false
		return
	end
	OW.enableAttack = true
end

function LaneClear(OW,Minions)
	if myHero.mana < KarthusMenu.LaneClear.Mana:Value()*myHero.maxMana*0.01 then return end
	local qminions = {}
	local eminions = {}
	for i,minion in pairs(Minions[1]) do
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
		local wPos,wHit = GetBestCircularFarmPosition(Q.Range,Q.Radius + 40,qminions)
		if wHit >= KarthusMenu.LaneClear.MinionQ:Value() then
			--OW.enableAttack = false
			SpellCast:CastSpell(HK_Q,wPos)
			return
		end
	end
	
end

function Harass(OW,Minions)
	OW.enableAttack = false
	local qtarget = Ts:GetTarget(Q.Range)
	if qtarget and Game.CanUseSpell(_Q) == READY  then--and os.clock() < QCastT + 5 then
		
		local CastPosition,Hitchance = Pred:GetPrediction(qtarget,Q)
		if  Hitchance == "High" then
			LastQPos = CastPosition
			SpellCast:CastSpell(HK_Q,CastPosition)
			return
		end
	end

	for i, minion in pairs(Minions[1]) do
		if Game.CanUseSpell(_Q) == READY and ValidTarget(minion,Q.Range) and (not OW:CanOrbwalkTarget(minion) or myHero:GetSpellData(_Q).level > 4) and GetDamage(_Q,minion,myHero) > OW:GetHealthPrediction(minion,0.7,Minions[3]) and OW:CanMove() then
			SpellCast:CastSpell(HK_Q,minion.pos)
			return
		end
	end
	OW.enableAttack = true
end

function LastHit(OW,Minions)
	if not OW:CanMove() then return end
	for i, minion in pairs(Minions[1]) do
		if Game.CanUseSpell(_Q) == READY and ValidTarget(minion,Q.Range) and (not OW:CanOrbwalkTarget(minion)  or myHero:GetSpellData(_Q).level > 2) and GetDamage(_Q,minion,myHero) > OW:GetHealthPrediction(minion,0.7,Minions[3]) then--q dmg > attack dmg
			SpellCast:CastSpell(HK_Q,minion.pos,0.15)
			return
		end
	end
	OW.enableAttack = true
end

function OnDraw()
	if myHero.dead then return end
	if LastQPos then 
		--Draw.Circle(LastQPos,200,1,Draw.Color(255, 228, 196, 255))
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

function GetDamage(slot,unit)
	if slot == _Q then
		local dmg = ({40, 60, 80, 100, 120})[myHero:GetSpellData(_Q).level] + 0.3 * myHero.ap
		return CalcMagicalDamage(myHero,unit,dmg)
	end
	if slot == _R then
		local dmg = ({250, 400, 550})[myHero:GetSpellData(_R).level] + 0.6 * myHero.ap 
		return CalcMagicalDamage(myHero,unit,dmg)
	end
end
