
if myHero.charName ~= "Zilean" then return end

local Q = {Delay = 0.45,Radius = 180,Range = 900,Speed = 2000}
local W = {Delay = 0.25, Speed = math.huge}
local E = {Delay = 0.25 ,Range = 800}
local R = {Delay = 0.25, Range = 900,Speed = math.huge}

local InitiatorsList  = {
	["Aatrox"] = {Name = "aatroxq", Type = "endPos" },
	["Akali"] = {Name = "akalishadowdance", Type = "target" },
	["Amumu"] = {Name = "bandagetoss", Type = "endPos" },
	["Ekko"] = {Name = "ekkoe", Type = "target" },
	["FiddleSticks"] = {Name = "crowstorm", Type = "endPos" },
	["Fiora"] = {Name = "fioraq", Type = "endPos" },
	["Gnar"] = {Name = "gnare", Type = "endPos" },
	["Gnar"] = {Name = "gnarbige", Type = "endPos" },
	["Gragas"] = {Name = "gragase", Type = "endPos" },
	["JarvanIV"] = {Name = "jarvanivdragonstrike", Type = "endPos" },
	["Jax"] = {Name = "jaxleapstrike", Type = "endPos" },
	["Katarina"] = {Name = "katarinae", Type = "target" },
	["Kassadin"] = {Name = "riftwalk", Type = "endPos" },
	["KhaZix"] = {Name = "khazixe", Type = "endPos" },
	["KhaZix"] = {Name = "khazixelong", Type = "endPos" },
	["LeeSin"] = {Name = "blindmonkqtwo", Type = "target" },
	["Shyvana"] = {Name = "shyvanatransformcast", Type = "target" },
	["Leona"] = {Name = "leonazenithblademissle", Type = "endPos" },
	["Shyvana"] = {Name = "shyvanatransformleap", Type = "endPos" },
}

local Attack = true
local Move = true
local LastMove = 0
local State = 1

local function CastSpell(hk,pos,delay)
	if State == 2 then return false end
	State = 2
	Attack = false
	Move = false
	delay = delay or 0.25
	if _G.GOS then
		_G.GOS.BlockMovement = true
		_G.GOS.BlockAttack  = true
	end
	Control.CastSpell(hk,pos)
	DelayAction(function()
		if _G.GOS then
			_G.GOS.BlockMovement = false
			_G.GOS.BlockAttack  = false
		end
		Attack = true
		Move = true
		State = 1
	end, delay)
end

local ZileanMenu = MenuElement({ id = "ZileanMenu", name = "Zilean - The Master of Time",type = MENU, leftIcon = "http://ddragon.leagueoflegends.com/cdn/7.1.1/img/champion/Zilean.png"})
function LoadMenu()
	ZileanMenu:MenuElement({id = "Key", name = "> Key Settings",type = MENU})
	ZileanMenu.Key:MenuElement({id = "Combo", name = "Combo",key = 32})
	ZileanMenu.Key:MenuElement({ id = "Harass", name = "Harass", key = string.byte("C")})
	ZileanMenu.Key:MenuElement({id = "LaneClear", name = "LaneClear", key = string.byte("V")})
	ZileanMenu.Key:MenuElement({id = "Flee", name = "Flee", key = string.byte("T")})
	
	ZileanMenu:MenuElement({id = "Qset", name ="> Q Settings",type = MENU})
	ZileanMenu.Qset:MenuElement({id = "Combo", name = "Use in Combo", value = true})
	ZileanMenu.Qset:MenuElement({id = "ComboAlly", name = "Use on allies", value = true})
	ZileanMenu.Qset:MenuElement({ id = "Harass", name = "Use in Harass", value = true})
	ZileanMenu.Qset:MenuElement({id = "Immobile", name = "Use on Immobile", value= true})
	ZileanMenu.Qset:MenuElement({id = "Interrupt", name = "Interrupt Enemy Spells", value = true})
	ZileanMenu.Qset:MenuElement({id = "JungleClear", name = "Use in JungleClear", value = true})
	

	ZileanMenu:MenuElement({id = "Wset", name = "> W Settings", type = MENU})
	ZileanMenu.Wset:MenuElement({id = "Combo", name = "Use in Combo", value = true})
	ZileanMenu.Wset:MenuElement({id = "Harass",name = "Use in Harass", value = true})
	
	
	ZileanMenu:MenuElement({id = "Eset", name = "> E Settings", type = MENU})
	ZileanMenu.Eset:MenuElement({ id = "Combo", name = "Use in Combo",value= true})
	ZileanMenu.Eset:MenuElement({id = "Speed", name = "Use on Ally", value =true})
	ZileanMenu.Eset:MenuElement({id = "Harass", name = "Use in Harass", value = true})

	
	ZileanMenu:MenuElement({ id = "Rset", name = "> R Settings", type = MENU})
	
	ZileanMenu.Rset:MenuElement( {id = "AutoR", name ="Auto R to Save Life", value = true})
	ZileanMenu.Rset:MenuElement({id="Me",name = "Save Me",value = true})
	ZileanMenu.Rset:MenuElement({id = "MyHp", name = "My %hp < ", value = 30, min = 1,max = 100, step = 1})
	ZileanMenu.Rset:MenuElement({id = "Ally", name = "Save Ally",value = true})
	ZileanMenu.Rset:MenuElement({id = "AllyHp", name = "Ally's %hp < ", value= 30, min = 1, max = 100})
	
	
	ZileanMenu:MenuElement({id = "Mana", name = "> Mana Settings", type = MENU})
	ZileanMenu.Mana:MenuElement({id = "Harass", name = "Dont Harass if Mana is lower than ", value= 50, min = 1, max = 100})
	
	ZileanMenu:MenuElement({id = "KS", name = "> KillSteal Settings", type = MENU})
	ZileanMenu.KS:MenuElement({id = "Q", name = "Use Q",value = true})
	ZileanMenu.KS:MenuElement({id = "E", name = "Use E",value = true})
	ZileanMenu.KS:MenuElement({id = "Ignite", name = "Use Ignite",value = true})
	
	ZileanMenu:MenuElement({id = "Draw", name = "> Draw Settings", type = MENU})
	ZileanMenu.Draw:MenuElement({id = "Q", name = "Draw Q Range", value = true})
	ZileanMenu.Draw:MenuElement({id = "E",name = "Draw E Range", value = true})
	ZileanMenu.Draw:MenuElement({id = "R", name ="Draw R Range", value = true})
end	
	
LoadMenu()

local function Ready(slot)
	return Game.CanUseSpell(slot) == 0
end

local function ValidTarget(obj,range)
	range = range and range or math.huge
	return obj ~= nil and obj.valid and obj.visible and not obj.dead and obj.isTargetable and not obj.isImmortal and obj.distance <= range
end

local function GetManaCost(slot)
	if slot == _R and Game.CanUseSpell(slot) ~= READY then
		return 0
	end
	return myHero:GetSpellData(slot).mana
end

local function GetClosetTarget()
	local dist = 0
	local target = nil
	for i = 1,Game.HeroCount()  do
		local hero = Game.Hero(i)	
		if ValidTarget(hero,range) and hero.isEnemy and dist < hero.distance and hero.distance < 2000 then
			dist = hero.distance
			target = hero
		end
	end
	return target	
end

local function CountEnemiesInRange(pos,range)
	local N = 0
	for i = 1,Game.HeroCount()  do
		local hero = Game.Hero(i)	
		if ValidTarget(hero,range) and hero.isEnemy then
			N = N + 1
		end
	end
	return N	
end

local function CountAlliesInRange(pos,range)
	local N = 0
	for i = 1,Game.HeroCount()  do
		local hero = Game.Hero(i)	
		if ValidTarget(hero,range) and hero.isAlly  then
			N = N + 1
		end
	end
	return N	
end

local function CalcMagicalDamage(source, target, amount)
  local mr = target.magicResist
  local value = 100 / (100 + (mr * source.magicPenPercent) - source.magicPen)

  if mr <= 0 then
    value = 2 - 100 / (100 - mr)
  elseif (mr * source.magicPenPercent) - source.magicPen < 0 then
    value = 100/(100 + mr * source.magicPenPercent)
  end
  return value * amount
end


local function GetTarget(range)
	local result = nil
	local N = 0
	for i = 1,Game.HeroCount()  do
		local hero = Game.Hero(i)	
		if ValidTarget(hero,range) and hero.isEnemy then
			local dmgtohero = CalcMagicalDamage(myHero,hero,100)
			local tokill = hero.health/dmgtohero
			if tokill > N or result == nil then
				result = hero
			end
		end
	end
	return result
end

local function HasBuff(unit, buffname)
  for i = 0, unit.buffCount do
    local buff = unit:GetBuff(i)
    if buff and buff.count > 0 and buff.name:lower():find(buffname)  then 
      return true
    end
  end
  return false
end

local function IsImmobile(unit)
	assert(unit, "IsImmobileTarget: invalid argument: unit expected got "..type(unit))
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and buff.name and buff.count > 0 and buff.expireTime > Game.Timer() and (buff.type == 5 or buff.type == 11 or buff.type == 29 or buff.type == 24 or buff.type == 10 or buff.name == "recall") then
			return true
		end
	end
	return false	
end

function CastQ(target)
	local pos = target:GetPrediction(Q.Speed,Q.Delay)
	CastSpell(HK_Q,pos)
end

function AutoQ()
	for i = 1,Game.HeroCount()  do
		local hero = Game.Hero(i)	
		if ValidTarget(hero,Q.Range) and hero.isEnemy and IsImmobile(hero) then
			if Ready(_Q) then
				CastSpell(HK_Q,hero.pos)
				if Ready(_W) then
					DelayAction(function() Control.CastSpell(HK_W) end)
				end
			end
		end
	end
end

function AutoR()
	if ZileanMenu.Rset.Me:Value() and myHero.health/myHero.maxHealth < ZileanMenu.Rset.MyHp:Value()/100 and CountEnemiesInRange(myHero.pos,500) > 0 then
		CastSpell(HK_R,myHero)
		return
	end
	if ZileanMenu.Rset.Ally:Value() then
		for i = 1,Game.HeroCount()  do
			local ally = Game.Hero(i)
			if not ally.dead and ally.distance <= R.Range and ally.health/ally.maxHealth < ZileanMenu.Rset.AllyHp:Value()/100  and CountEnemiesInRange(ally.pos,500) > 0 then
				CastSpell(HK_R,ally)
				return
			end
		end
	end
end

function ProcessSpell()
	if Ready(_Q) then
		for i = 1, Game.HeroCount() do
			local ally = Game.Hero(i) 
			if not ally.isMe and not ally.dead and ally.isAlly and ally.distance < Q.Range + 80 and InitiatorsList[ally.charName] then
				local spell =  ally.activeSpell
				local info = InitiatorsList[ally.charName]
				if spell.valid and spell.name:lower() == info.Name then
					if CountEnemiesInRange(spell.endPos, 500)  > 0 then
						CastSpell(HK_Q,ally)
					end
				end
			end
		end	
	end
	if Ready(_R) then
		for i = 1, Game.HeroCount() do
			local enemy = Game.Hero(i) 
			if enemy.isEnemy and enemy.activeSpell.valid and enemy.activeSpell.name:lower() == "summonerdot" and enemy.activeSpell.target > 0 then
				local ally = Game.GetObjectByNetID(enemy.activeSpell.target)	
				if ally and ally.health < 50+20*enemy.levelData.lvl then
					CastSpell(HK_R,ally)
				end
			end
		end
	end	
end

function Combo()
	if Ready(_Q) and ZileanMenu.Qset.Combo:Value() then
		local target = GetTarget(Q.Range)
		if target then
			CastQ(target)
			return
		else
			for i = 1, Game.HeroCount() do
				local ally = Game.Hero(i)
				if not ally.dead and ally.distance < Q.Range + 60 and CountEnemiesInRange(ally.pos,400) > 0 then
					CastQ(ally)
					break
				end
			end	
		end
	end
	if Ready(_W) and ZileanMenu.Wset.Combo:Value() and not Ready(_Q) and myHero.mana > GetManaCost(_Q) + GetManaCost(_W) + GetManaCost(_R) then
		Control.CastSpell(HK_W)
		return
	end
	if Ready(_E) and ZileanMenu.Eset.Combo:Value() then
		local eTarget = GetTarget(E.Range)
		if eTarget then
			CastSpell(HK_E,eTarget)
			return
		else
			local target = GetClosetTarget(myHero.pos)
			if target and target.distance <  E.Range + ((({40 , 55 , 70 , 85 , 99})[myHero:GetSpellData(_E).level]/100 + 1)*myHero.ms - target.ms)*2.5 then
				CastSpell(HK_E,myHero)
				return
			elseif target then
				for i = 1, Game.HeroCount() do
					local ally = Game.Hero(i)
					if not ally.dead and ally.distance < E.Range and CountEnemiesInRange(ally.pos,600) > 0 then
						CastSpell(HK_E,ally)
					end
				end	
			end
		end
	end
end

function Harass()
	if myHero.mana/myHero.maxMana < ZileanMenu.Mana.Harass:Value()/100 then return end
	if Ready(_Q) and ZileanMenu.Qset.Harass:Value() then
		local target = GetTarget(Q.Range)
		if target then
			CastQ(target)
		end
	end
	if Ready(_W) and ZileanMenu.Wset.Harass:Value() and not Ready(_Q) and myHero.mana > GetManaCost(_Q) + GetManaCost(_W) + GetManaCost(_R) then
		Control.CastSpell(HK_W)
	end
	if Ready(_E) and ZileanMenu.Eset.Harass:Value() then
		local eTarget = GetTarget(E.Range)
		if eTarget then
			CastSpell(HK_E,eTarget)
		end
	end
end

function Flee()
	if Ready(_E) and not HasBuff(myHero,"timewarp") then
		CastSpell(HK_E,myHero)
	end
	if Ready(_W) and (not Ready(_Q) or not Ready(_E) or not Ready(_R)) then
		Control.CastSpell(HK_W)
	end
	if Game.Timer() - LastMove < 0.3 then return end
	LastMove = Game.Timer()
	Control.Move()
end

Callback.Add("Tick",function()
	
	if ZileanMenu.Key.Combo:Value() then
		Combo()
	elseif ZileanMenu.Key.Harass:Value() then
		Harass()
	elseif ZileanMenu.Key.Flee:Value() then	
		Flee()
	end
	if Ready(_R) then
		AutoR()
	end
	if Ready(_Q) then
		AutoQ()
	end
	ProcessSpell()
end)


Callback.Add("Draw", function()
	if myHero.dead then return end
	if ZileanMenu.Draw.Q:Value() and myHero:GetSpellData(0).level > 0 then
		local qcolor = Ready(0) and  Draw.Color(189, 183, 107, 255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),Q.Range,1,qcolor)
	end
	if ZileanMenu.Draw.R:Value() and myHero:GetSpellData(3).level > 0  then
		local rcolor = Ready(3) and  Draw.Color(240,30,144,255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),R.Range,1,rcolor)
	end
	if ZileanMenu.Draw.E:Value() and myHero:GetSpellData(2).level > 0 then
		local ecolor = Ready(2) and  Draw.Color(233, 150, 122, 255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),E.Range,1,ecolor)
	end

end)	

Callback.Add("Load",function() 
	if _G.SDK  then
		_G.SDK.Orbwalker:OnPreMovement(function(arg) 
			if not Move then
				arg.Process = false
			end
		end)
		_G.SDK.Orbwalker:OnPreAttack(function(arg)
			if not Attack then
				arg.Process = false
			end
		end)
	end

end)
