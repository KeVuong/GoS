if myHero.charName ~= "Cassiopeia" then return end

local path = SCRIPT_PATH.."Loader.lua"

if FileExist(path) then
	_G.Enable_Ext_Lib = true
	loadfile(path)()
else
	
end	

local Ts = TargetSelector
local Pred = Prediction
local ENEMY = 1
local JUNGLE = 2
local ALLY = 3
local Q = {Range = 850,Delay = 0.65, Radius = 40, Speed = math.huge,Type = "Circle"}
local W = {Range = 800,Delay = 0.5, Radius = 90, Speed = 1500,Type = "Circle"}
local E = {Range = 700}
local R = {Range = 825,Delay = 0.6, Radius = 80, Speed = math.huge, Angle = 40}


class "Cassiopeia"

function Cassiopeia:__init()
	Ts:PresetMode("LESS_CAST")
	self.Allies = {}
	self.Enemies = {}
	for i = 1,Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isAlly then
			table.insert(self.Allies,hero)
		else
			table.insert(self.Enemies,hero)
		end	
	end	
	self:LoadMenu()
	OnActiveMode(function(...) self:OnActiveMode(...) end)
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Draw",function() self:Draw() end)
	--OnUnkillableMinion(function(x) self:OnUnkillableMinion(x) end)
end

function Cassiopeia:LoadMenu()
	self.Menu = MenuElement({type = MENU,id = "Addon"..myHero.charName,name = myHero.charName})
	
	self.Menu:MenuElement({type = MENU,id = "Combo",name = "Combo Settings"})
	self.Menu.Combo:MenuElement({id = "UseQ",name = "Use Q",value = true})
	self.Menu.Combo:MenuElement({id = "UseW",name = "Use W",value = true})
	self.Menu.Combo:MenuElement({id = "UseE",name = "Use E",value = true})
	self.Menu.Combo:MenuElement({id = "UseR",name = "Use R",value = true})
	self.Menu.Combo:MenuElement({id = "AutoR",name = "Use R if hit x enemies",value = 2, min = 1, max = 5, step = 1})
	
	self.Menu:MenuElement({type = MENU,id = "Harass",name = "Harass Settings"})
	self.Menu.Harass:MenuElement({id = "UseQ",name = "Use Q",value = true})
	self.Menu.Harass:MenuElement({id = "UseW",name = "Use W",value = false})
	self.Menu.Harass:MenuElement({id = "UseE",name = "Use E",value = true})
	self.Menu.Harass:MenuElement({id = "ELastHit",name = "Use E LastHit",value = true})
	self.Menu.Harass:MenuElement({id = "MinMana",name = "Don't use spells if mana is lower than",value = 70,min = 0,max = 100, step = 1})
	
	self.Menu:MenuElement({type = MENU,id = "LastHit",name = "LastHit Settings"})
	self.Menu.LastHit:MenuElement({id = "UseQ",name = "Use Q",value = true})
	self.Menu.LastHit:MenuElement({id = "UseE",name = "Use E",value = true})
	
	self.Menu:MenuElement({type = MENU,id = "LaneClear",name = "LaneClear Settings"})
	self.Menu.LaneClear:MenuElement({id = "Enable",name = "Enable",value = true,key = string.byte("T"), toggle = true})
	self.Menu.LaneClear:MenuElement({id = "UseQ",name = "Use Q",value = true})
	self.Menu.LaneClear:MenuElement({id = "UseW",name = "Use W",value = false})
	self.Menu.LaneClear:MenuElement({id = "UseE",name = "Use E",value = true})
	self.Menu.LaneClear:MenuElement({id = "MinMana",name = "Don't use spells if mana is lower than",value = 30,min = 0,max = 100, step = 1})
	
	self.Menu:MenuElement({type = MENU,id = "Drawing",name = "Drawing Settings"})
	self.Menu.Drawing:MenuElement({id = "DrawQ",name = "Draw Q Range",value = true})
	self.Menu.Drawing:MenuElement({id = "DrawW",name = "Draw W Range",value = false})
	self.Menu.Drawing:MenuElement({id = "DrawE",name = "Draw E Range",value = true})
	self.Menu.Drawing:MenuElement({id = "DrawR",name = "Draw R Range",value = true})
	--self.Menu.Drawing:MenuElement({id = "Target",name = "Mark Poisoned Enemies",value = true})
end

function Cassiopeia:IsPoisonedTarget(unit)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff.count > 0 and (buff.name == "cassiopeiaqdebuff" or buff.name == "cassiopeiawpoison")  then 
			return true
		end
	end
	return false
end

function Cassiopeia:GetETarget()
	local target = nil
	local N = 1000
	for i, enemy in pairs(self.Enemies) do
		if ValidTarget(enemy,E.Range) and not IsInvulnerableTarget(enemy) and self:IsPoisonedTarget(enemy) then
			local tokill = enemy.health/CalcMagicalDamage(myHero,enemy,100)
			if tokill < N then
				N = tokill
				target = enemy
			end
		end
	end
	return target
end

function Cassiopeia:GetDamage(spell,unit,poison)
	if spell == "E" then
		local base = 48 + myHero.levelData.lvl*4
		if poison or self:IsPoisonedTarget(unit)  then	
			local bonus = ({10, 40, 70, 100, 130})[myHero:GetSpellData(_E).level] + myHero.ap*0.35
			return CalcMagicalDamage(myHero,unit, base + bonus)	
		else
			return CalcMagicalDamage(myHero,unit, base)	
		end
	elseif spell == "Q"	 then
		return getdmg("Q",unit,myHero)
	end	
end

function Cassiopeia:CastQ(target)
	local CastPosition, Hitchance = Pred:GetPrediction(target,Q)
	if Hitchance == "High" then
		--LastPos = CastPosition
		SpellCast:Add("Q",CastPosition,0.7)
	end
end

function Cassiopeia:CastW(target)
	local CastPosition, Hitchance = Pred:GetPrediction(target,W)
	if Hitchance == "High" and GetDistanceSqr(CastPosition,myHero.pos) > 400*400 then
		SpellCast:Add("W",CastPosition)
	end
end

function Cassiopeia:CastE(target)
	SpellCast:AddTarget("E",target)
end

function Cassiopeia:CastR(target)
	local CastPosition, Hitchance = Pred:GetPrediction(target,R)
	if Hitchance == "High" then
		SpellCast:Add("R",CastPosition)
	end
end

function Cassiopeia:CanR(target)
	local p1 = (target.pos - myHero.pos):Normalized()
	p1 = Point2(p1.x,p1.z)
	local p2 = target.dir
	p2 = Point2(p2.x,p2.z)
	if p1:angleBetween(p2) > 100 then
		return true
	end
	return false
end

function Cassiopeia:IsKillable(target)
	local totalDmg = 0
	local qDmg = getdmg("Q",target)
	local eDmg = self:GetDamage("E",target,true)
	local rDmg  = getdmg("R",target,target)
	if isReady(0) then
		totalDmg  = totalDmg + qDmg
	end
	--if isReady(2) then
		totalDmg = totalDmg + eDmg*3
	--end
	if totalDmg < target.health and totalDmg + rDmg + 1.5*eDmg > target.health then 
		return true
	end
	return false
end

function Cassiopeia:OnActiveMode(OW,Minions)
	if OW.Mode == "Combo" then
		self:Combo(OW,Minions)
		OW.enableAttack = true
	elseif 	OW.Mode == "LastHit" then
		OW.enableAttack = true
		self:LastHit(OW,Minions)
	elseif 	OW.Mode == "LaneClear" then	
		OW.enableAttack = true
		self:LaneClear(OW,Minions)
		self:JungleClear(OW,Minions)
	elseif OW.Mode == "Harass" then		
		OW.enableAttack = true
		self:Harass(OW,Minions)
	end
	OW.enableAttack = true
end

function Cassiopeia:Combo(OW,Minions)
	local useq = self.Menu.Combo.UseQ:Value()
	local usew = self.Menu.Combo.UseW:Value()
	local usee = self.Menu.Combo.UseE:Value()
	local user = self.Menu.Combo.UseR:Value()
	for i,enemy in pairs(self.Enemies) do
		if ValidTarget(enemy,Q.Range) and getdmg("Q",enemy) > enemy.health and isReady(0) then
			self:CastQ(enemy)
			return
		end
		if ValidTarget(enemy,E.Range) and isReady(2) and 2*self:GetDamage("E",enemy) > enemy.health and not isReady(0) then
			self:CastE(enemy)
			return
		end
	end
	if user and isReady(3) then
		local rTarget = Ts:GetTarget(650)
		if rTarget and not self:IsKillable(rTarget) and self:CanR(rTarget) then
			
			self:CastR(rTarget)
	
		end
	end
	
	local etarget = self:GetETarget()
	if etarget then
		if getdmg("AA",etarget,myHero)*3.5 < etarget.health then
			OW.enableAttack = false
		else
			OW.enableAttack = true
		end
		if isReady(2) then
			self:CastE(etarget)
			return
		end	
	end	
	local qTarget = Ts:GetTarget(Q.Range)
	if qTarget then
		if isReady(0) and useq then
			self:CastQ(qTarget)
			return
		end
		if not isReady(0) and isReady(1) and usew and not self:IsPoisonedTarget(qTarget) then
			self:CastW(qTarget)
			return
		end
	end

end

function Cassiopeia:Harass(OW,Minions)
	
	local elasthit = self.Menu.Harass.ELastHit:Value()
	local useq = self.Menu.Harass.UseQ:Value()
	local usee = self.Menu.Harass.UseE:Value()
	if isReady(2) and elasthit then
	for i,minion in pairs(Minions[ENEMY]) do
		if ValidTarget(minion,E.Range) then
			if self:IsPoisonedTarget(minion) then
				local distance =  GetDistance(myHero.pos,minion.pos)
				local time = 0.025 + distance/2500
				if distance < E.Range and OW:GetHealthPrediction(minion,time,Minions[3]) < self:GetDamage("E",minion,true) then
					SpellCast:AddTarget("E",minion)
					return
				end
			end
		end
	end
	end
	if myHero.mana/myHero.maxMana < self.Menu.Harass.MinMana:Value()/100 then return end
	local etarget = self:GetETarget()
	if isReady(2) and usee and etarget then
		self:CastE(etarget)	
		return
	end
	local qTarget = Ts:GetTarget(Q.Range)
	if qTarget and isReady(0) and useq and not self:IsPoisonedTarget(qTarget) then
		self:CastQ(qTarget)
	end
end

--2500
function Cassiopeia:LaneClear(OW,Minions)
	
	local minions = {}
	local minions2 = {}
	for i,minion in pairs(Minions[ENEMY]) do
		if ValidTarget(minion,Q.Range + Q.Radius) then
			table.insert(minions,minion)	
			if self:IsPoisonedTarget(minion) then
				table.insert(minions2,minion)
			end
		end
	end
	if #minions2 > 0 then
		if not isReady(3) then return end
		for i,minion in pairs(minions2) do
			local distance =  GetDistance(myHero.pos,minion.pos)
			local time = 0.025 + distance/2500 
			if distance < E.Range and OW:GetHealthPrediction(minion,time,Minions[3]) < self:GetDamage("E",minion,true) then
				SpellCast:AddTarget("E",minion)
				return
			end
		end
	elseif #minions > 0 then
		if myHero.mana/myHero.maxMana < self.Menu.LaneClear.MinMana:Value()/100 then return end
		if not isReady(0) then return end
		if #minions == 1 and minions[1].health < myHero.totalDamage then
			return
		end
		local bestPos, bestHit = GetBestCircularFarmPosition(Q.Range,Q.Radius + 40, minions)
		if bestHit > 0 then
			SpellCast:Add("Q",bestPos,0.6)
		end
	end	
	
end

function Cassiopeia:JungleClear(OW,Minions)
	local mobs = {}
	for i, minion in pairs(Minions[JUNGLE]) do
		if ValidTarget(minion,Q.Range) then
			table.insert(mobs,minion)
		end	
	end
	table.sort(mobs,function(a,b) return a.maxHealth > b.maxHealth end)
	local mob = mobs[1]
	if mob then
		if isReady(2) and self:IsPoisonedTarget(mob)and GetDistanceSqr(mob.pos) < E.Range*E.Range then	
			self:CastE(mob)
			return
		end
		if isReady(0) then
			SpellCast:Add("Q", mob.pos,0.6)
		end
	end
end

function Cassiopeia:LastHit(OW,Minions)
	local elasthit = self.Menu.LastHit.UseE:Value()
	local qlasthit = self.Menu.LastHit.UseQ:Value()
	
	if isReady(2) and elasthit then
	for i,minion in pairs(Minions[ENEMY]) do
		if ValidTarget(minion,E.Range) then
			if self:IsPoisonedTarget(minion) then
				local distance =  GetDistance(myHero.pos,minion.pos)
				local time = 0.025 + distance/2500
				if distance < E.Range and OW:GetHealthPrediction(minion,time,Minions[3]) < self:GetDamage("E",minion,true) then
					SpellCast:AddTarget("E",minion)
					return
				end
			end
		end
	end
	end
	
	if isReady(0) and qlasthit then
		for i,minion in pairs(Minions[ENEMY]) do
			if ValidTarget(minion,Q.Range) and getdmg("Q",minion) > minion.health and minion.health > myHero.totalDamage then
				SpellCast:Add("Q", minion.pos,0.6)
			end
		end		
	end
end

function Cassiopeia:OnUnkillableMinion(minion)
	if not isReady(2) then return end
	local distance =  GetDistance(myHero.pos,minion.pos)
	local time = 0.025 + distance/2500 
	if distance < E.Range and OW:GetHealthPrediction(minion,time,Minions[3]) < self:GetDamage("E",minion) then
		SpellCast:AddTarget("E",minion)
		return
	end
end

function Cassiopeia:Tick()
	if isReady(3) then
		local enemies = {}
		for i,enemy in pairs(self.Enemies) do
			if ValidTarget(enemy,R.Range) and self:CanR(enemy) then
				if enemy.range < 350 and GetDistanceSqr(enemy.pos,myHero.pos) < 200*200 and myHero.health/myHero.maxHealth < 0.5 then
					self:CastR(enemy)
					return
				end
				table.insert(enemies,enemy)
			end
		end
		if #enemies >= 2 then
			local rTarget = Ts:GetTarget(650)--need better logic
			if rTarget then
				self:CastR(rTarget)
			end
		end
	end
end

function Cassiopeia:Draw()
	if myHero.dead then return end
	if self.Menu.Drawing.DrawQ:Value() and myHero:GetSpellData(0).level > 0 then
		local qcolor = isReady(0) and  Draw.Color(189, 183, 107, 255) or Draw.Color(150,255,0,0)
		Draw.Circle(Vector(myHero.pos),Q.Range,1,qcolor)
	end
	if self.Menu.Drawing.DrawR:Value() and myHero:GetSpellData(3).level > 0  then
		local rcolor = isReady(3) and  Draw.Color(240,30,144,255) or Draw.Color(150,255,0,0)
		Draw.Circle(Vector(myHero.pos),R.Range,1,rcolor)
	end
	if self.Menu.Drawing.DrawE:Value() and myHero:GetSpellData(2).level > 0 then
		local ecolor = isReady(2) and  Draw.Color(233, 150, 122, 255) or Draw.Color(150,255,0,0)
		Draw.Circle(Vector(myHero.pos),E.Range,1,ecolor)
	end
	if LastPos then 
		Draw.Circle(LastPos,80,2,Draw.Color(255, 228, 196, 255))
	end
end

Cassiopeia()


