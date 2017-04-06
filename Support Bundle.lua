--[[

   _   _   _   _   _   _   _     _   _   _   _   _   _  
  / \ / \ / \ / \ / \ / \ / \   / \ / \ / \ / \ / \ / \ 
 ( S | u | p | p | o | r | t ) ( B | u | n | d | l | e )
  \_/ \_/ \_/ \_/ \_/ \_/ \_/   \_/ \_/ \_/ \_/ \_/ \_/ 

]]


local SupportHeroes = {
	Janna = true,
	Karma = true,
	Morgana = true,
	Nautilus = true,
	Nami = true,
	Zilean = true,
	Braum = true,
	Volibear = true,
	--Thresh = true,
	Blitzcrank = true,
	--Alistar = true,
	--Bard = true,
	--Lulu = true,
	--Zyra = true,
	--Leona = true,
	--Malzahar = true,
}


if not SupportHeroes[myHero.charName] then return end

local ver = "20170406001"

require "DamageLib"



require "GoSWalk"



local GPred = _G.gPred

if not GoSWalk.Version or GoSWalk.Version < 0.36 then
	PrintChat("GoSWalk is outdated. Please update it before using script")
	
	return
end

	function CountAllyNearPos(pos, range)
		if pos == nil or not range then return 0 end
		local c = 0
		if not myHero.dead then
			if GetDistance(pos) <= range then
				c = c+ 1
			end
		end
		
		for k,v in pairs(GetAllyHeroes()) do 
		if v and GetOrigin(v) ~= nil and not IsDead(v) and GetDistanceSqr(pos,GetOrigin(v)) < range*range then
			c = c + 1
		end
		end
		return c
	end
	
local Spells = {}

class "Janna"

function Janna:__init()
	Spells[_Q] = {ready = false, range = 850,maxrange = 1700, radius = 120 , speed = 900, delay = 0.25, type = "line"}
	Spells[_W] = {ready = false, range = 600}
	Spells[_E] = {ready = false,range = 800}
	Spells[_R] = {ready = false,range = 725}
	self.SecondQ = false
	self.SelectedTarget = nil
	self.lastTick = 0
	self:LoadMenu()
	Callback.Add("ProcessSpell",function(u,s) self:ProcessSpell(u,s) end)
	Callback.Add("CreateObj",function(o) self:CreateObj(o) end)
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Draw",function() self:Draw() end)
	Callback.Add("WndMsg",function(Msg, Key) self:WndMsg(Msg, Key) end)
end

function Janna:LoadMenu()
	self.Menu = Menu( "SB"..myHero.charName, "Janna - The Storm's Fury")
	self.Menu:SubMenu("Key", "> Key Settings")
	self.Menu.Key:KeyBinding("Combo","Combo",32)
	self.Menu.Key:KeyBinding("Harass","Harass",string.byte("C"))
	--self.Menu.Key:KeyBinding("LaneClear","LaneClear",string.byte("V"))
	self.Menu:SubMenu("Qset", "> Q Settings")
	self.Menu.Qset:Boolean("Combo","Use in Combo", true)
	self.Menu.Qset:Boolean("Harass","Use in Harass", false)
	self.Menu.Qset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	--self.Menu.Qset:Boolean("AG","Anti-Gapclose", true)

	self.Menu:SubMenu("Wset", "> W Settings")
	self.Menu.Wset:Boolean("Combo","Use in Combo", true)
	self.Menu.Wset:Boolean("Harass","Use in Harass", true)
	self.Menu:SubMenu("Eset", "> E Settings")
	self.Menu.Eset:Boolean("Combo","Use in Combo", true)
	self.Menu.Eset:Boolean("Turret","Shield Against Turrets", true)
	self.Menu.Eset:Boolean("Me","Shield Me", true)
	self.Menu.Eset:Boolean("Spell","Shield Ally", true)
	self.Menu:SubMenu("Rset", "> R Settings")
	self.Menu.Rset:Slider("Heal","Heal Ally if %HP < ", 15,1,100)
	self.Menu.Rset:Slider("HealMe","Heal Me if %HP < ", 10,1,100)
	self.Menu.Rset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	--self.Menu.Rset:Boolean("AG","Anti-Gapclose", true)
	self.Menu:SubMenu("Insec", "> Insec Settings")
	self.Menu.Insec:KeyBinding("Enable","Enable (Toggle)",string.byte("M"),true)
	self.Menu.Insec:Boolean("Ally","Insec to Ally",true)
	self.Menu.Insec:Boolean("Turret","Insec to Turret",true)
	self.Menu.Insec:Boolean("Text","Draw Text",true)
	self.Menu.Insec:Boolean("Draw","Draw Insec Position",true)
	self.Menu:SubMenu("AG", "> AntiGapcloser")
	AddGapcloseEvent(_Q,Spells[_Q].range,false,self.Menu.AG)
	
	self.Menu:SubMenu("KS", "> KS Settings")
	self.Menu.KS:Boolean("W","Use W",true)
	
	self.Menu:SubMenu("Draw", "> Draw Settings")
	self.Menu.Draw:Boolean("Q","Draw Q Range", true)
	self.Menu.Draw:Boolean("W","Draw W Range", true)
	self.Menu.Draw:Boolean("E","Draw E Range", true)
	self.Menu.Draw:Boolean("R","Draw R Range", true)
	PrintChat("Support Series Loaded")
end

function Janna:Check()
	Spells[_Q].ready = myHero:GetSpellData(_Q).level > 0 and myHero:CanUseSpell(_Q) == READY and true or false
	Spells[_W].ready = myHero:GetSpellData(_W).level > 0 and myHero:CanUseSpell(_W) == READY and true or false
	Spells[_E].ready = myHero:GetSpellData(_E).level > 0 and myHero:CanUseSpell(_E) == READY and true or false
	Spells[_R].ready = myHero:GetSpellData(_R).level > 0 and myHero:CanUseSpell(_R) == READY and true or false
end

function Janna:CreateObj(obj)
	
end

function Janna:ProcessSpell(unit,spell)
	
	if unit and unit.team ~= myHero.team and unit.type == "obj_AI_Turret" and spell.target and GetDistance(spell.target) < Spells[_E].range and spell.target.type == myHero.type then
		if self.Menu.Eset.Turret:Value() and Spells[_E].ready then
			myHero:CastSpell(_E,spell.target)
		end
	end
	
	if unit and unit.team ~= myHero.team and unit.type == myHero.type and spell.target and spell.target.type == myHero.type and GetDistance(spell.target) < Spells[_E].range then
		if Spells[_E].ready then 
			myHero:CastSpell(_E,spell.target)
		end
	end
	
	if unit and unit ~= myHero and unit.type == myHero.type and unit.team == myHero.team and GetDistance(unit) < Spells[_E].range and spell.name and spell.name:lower():find("attack") and spell.target and spell.target.type == myHero.type then
		if self.Menu.Eset.Combo:Value() and Spells[_E].ready then 
			myHero:CastSpell(_E,spell.target)
		end
	end
end

function Janna:GetClosestAlly()
	local hero = nil
	local minD = math.huge
	for i,ally in pairs(GetAllyHeroes()) do
		if ally and not ally.dead and GetDistance(ally) < 1050 + ally.range and GetDistance(ally) < minD then
			hero = ally
			minD = GetDistance(ally)
		end
	end
	return hero
end

function Janna:GetBestTarget(Range, Ignore)
	local LessToKill = 100
	local LessToKilli = 0
	local target = nil
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if ValidTarget(enemy, Range) then
			DamageToHero = myHero:CalcMagicDamage(enemy, 200)
			ToKill = GetCurrentHP(enemy) / DamageToHero
			if ((ToKill < LessToKill) or (LessToKilli == 0)) and (Ignore == nil or (GetNetworkID(Ignore) ~= GetNetworkID(enemy))) then
				LessToKill = ToKill
				LessToKilli = i
				target = enemy
			end
		end
	end
	if ValidTarget(self.SelectedTarget,Range+65) then
		return self.SelectedTarget
	end
  
	return target
end


function Janna:Combo()
	local qtarget = self:GetBestTarget(Spells[_Q].range)
	local wtarget = self:GetBestTarget(Spells[_W].range)
	if qtarget and wtarget and qtarget.networkID ~= wtarget.networkID then
		qtarget = wtarget
	end
	
	if qtarget and Spells[_Q].ready and self.Menu.Qset.Combo:Value() then
		if GPred then
		local qPred = GPred:GetPrediction(qtarget,myHero,Spells[_Q])
		if qPred.HitChance >= 3 then
			myHero:CastSpell(_Q,qPred.CastPosition.x,qPred.CastPosition.z)
		end
		else
			local qPred = GetPrediction(qtarget,Spells[_Q])
			if qPred and qPred.hitChance > 0.1 then
				myHero:CastSpell(_Q,qPred.castPos.x,qPred.castPos.z)
			end
		end		
	end
	if ValidTarget(wtarget,Spells[_W].range) and Spells[_W].ready and self.Menu.Wset.Combo:Value() then
		myHero:CastSpell(_W,wtarget)
	end
end

function Janna:Harass()
	local wtarget = self:GetBestTarget(Spells[_W].range)
	if ValidTarget(wtarget,Spells[_W].range) and Spells[_W].ready and self.Menu.Wset.Harass:Value() then
		myHero:CastSpell(_W,wtarget)
	end
end

function Janna:Tick()

	if os.clock()*1000 < self.lastTick then
		return 
	end
	self.lastTick = os.clock()*1000 + 1
	self:Check()
	if self.SelectedTarget and self.SelectedTarget.dead then 
		self.SelectedTarget = nil
	end
	if self.Menu.KS.W:Value() and Spells[_W].ready then
		self:KillSteal()
	end
	if Spells[_R].ready then
		self:HealAlly()
	end

	if self.Menu.Key.Combo:Value() then
		self:Combo()
	end
	if self.Menu.Key.Harass:Value() then
		self:Harass()
	end
	if self.Menu.Insec.Enable:Value() and Spells[_R].ready then
		for _,enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy,Spells[_R].range) then
				local insecpos = Vector(myHero) + (Vector(enemy)-Vector(myHero)):normalized()*875
				if insecpos then
					if self.Menu.Insec.Turret:Value() and UnderTurret(insecpos,false) then
						myHero:CastSpell(_R)
					elseif self.Menu.Insec.Ally:Value() then	
						local ally = self:GetClosestAlly()
						if ally ~= nil and not ally.dead then 
							local angle = Vector(myHero.pos):angleBetween(Vector(ally.pos),Vector(insecpos))--2CirclesIntersect
							if angle < 20  then
								myHero:CastSpell(_R)
							end
						end
					end
						
				end
			end
		end
	end
	if Spells[_E].ready and self.Menu.Eset.Spell:Value() and _G.GoSEvade ~= nil then
		for i,ally in pairs(GetAllyHeroes()) do
			if GetDistance(ally) < Spells[_E].range and not ally.dead and _G.GoSEvade:IsInSkillShots(ally,ally.pos,0,2) then
				myHero:CastSpell(_E,ally)
			end
		end
	end
	if Spells[_E].ready and self.Menu.Eset.Me:Value() and _G.GoSEvade ~= nil then
		if  not myHero.dead and _G.GoSEvade:IsInSkillShots(myHero,myHero.pos,0,2) then
				myHero:CastSpell(_E,myHero)
		end
	end
end

function Janna:KillSteal()
	for i, enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy,Spells[_W].range) and getdmg("W",enemy) > enemy.health then
			myHero:CastSpell(_W,enemy)
		end
	end
end

function Janna:HealAlly()
	if not Spells[_R].ready then return end
	for _,ally in pairs(GetAllyHeroes()) do
		if not ally.dead and GetDistance(ally) < Spells[_R].range - 150 and GetPercentHP(ally) <= self.Menu.Rset.Heal:Value() and EnemiesAround(ally.pos,300) >= 1 then
			myHero:CastSpell(_R)
		end
	end
	if GetPercentHP(myHero) <= self.Menu.Rset.HealMe:Value() and EnemiesAround(myHero.pos,300) >= 1 then
		myHero:CastSpell(_R)
	end
end

function Janna:WndMsg(msg,key)

	if msg == 513 then
		local minD = math.huge
		local starget = nil
		for i, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				if GetDistance(enemy, GetMousePos()) <= minD or starget == nil then
					minD = GetDistance(enemy, GetMousePos())
					starget = enemy
				end
			end
		end
		
		if starget and minD < 200 then
			if self.SelectedTarget and starget.charName == self.SelectedTarget.charName then
				self.SelectedTarget = nil
				PrintChat("<font color=\"#FF0000\">Deselected target: "..starget.charName.."</font>")
			else
				self.SelectedTarget = starget
				PrintChat("<font color=\"#ff8c00\">New target selected: "..starget.charName.."</font>")
			end
		end
	
	end
end

function Janna:Draw()
	
	if myHero.dead then return end
	if self.Menu.Insec.Text:Value() then
		if not self.Menu.Insec.Enable:Value() then
			DrawText("Insec: OFF",14,WINDOW_W/2,30,GoS.Red)
		else
			if Spells[_R].ready then
				DrawText("Insec: ON",14,WINDOW_W/2,30,GoS.White)
			else
				DrawText("R not READY",14,WINDOW_W/2,30,GoS.White)
			end
		end
	end
	if self.Menu.Insec.Enable:Value() and self.Menu.Insec.Draw:Value() then
		if Spells[_R].ready then
			for _,enemy in pairs(GetEnemyHeroes()) do
				if ValidTarget(enemy,Spells[_R].range) then
					local insecpos = Vector(myHero) + (Vector(enemy)-Vector(myHero)):normalized()*900
					if insecpos then
						local heroPos = WorldToScreen(1,insecpos)
						DrawText(enemy.charName,20, heroPos.x, heroPos.y,GoS.White)
						DrawCircle3D(insecpos.x,insecpos.y,insecpos.z,enemy.boundingRadius,1,qcolor,10)
					end
				end
			end
		end
	end
	if self.Menu.Draw.Q:Value() then
		local qcolor = Spells[_Q].ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,Spells[_Q].range,1,qcolor,20)
	end
	if self.Menu.Draw.W:Value() then
		local wcolor = Spells[_W].ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,Spells[_W].range,1,wcolor,20)
	end
	if self.Menu.Draw.E:Value() then
		local ecolor = Spells[_E].ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,Spells[_E].range,1,ecolor,20)
	end
	if self.Menu.Draw.R:Value() then
		local rcolor = Spells[_R].ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,Spells[_R].range,1,rcolor,20)
	end
end



class "Karma"
--so lazy
local Q,W,E,R = nil,nil,nil,nil

function Karma:__init()
	Q = {ready = false, range = 950, radius = 70, speed = 1700, delay = 0.25, type = "line"}
	W = {ready = false, range = 700 }
	E = {ready = false, range = 800 }
	R = {ready = false}
	self.HasMantra = false
	self.lastTick = 0
	self.SelectedTarget = nil
	self.RootBuff = nil
	self:LoadMenu()
	Callback.Add("UpdateBuff", function(u,s) self:UpdateBuff(u,s) end)
	Callback.Add("RemoveBuff", function(u,s) self:RemoveBuff(u,s) end)
	Callback.Add("ProcessSpell",function(u,s) self:ProcessSpell(u,s) end)
	--Callback.Add("CreateObj",function(o) self:CreateObj(o) end)
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Draw",function() self:Draw() end)
	Callback.Add("WndMsg",function(Msg, Key) self:WndMsg(Msg, Key) end)
end

function Karma:LoadMenu()
	self.Menu = Menu( "SB"..myHero.charName, "Karma - The Guardian Angel")
	self.Menu:SubMenu("Key", "> Key Settings")
	self.Menu.Key:KeyBinding("Combo","Combo",32)
	self.Menu.Key:KeyBinding("Harass","Harass",string.byte("C"))
	self.Menu.Key:KeyBinding("LaneClear","Lane Clear",string.byte("V"))
	self.Menu.Key:KeyBinding("JungleClear","Jungle Clear",string.byte("G"))
	
	self.Menu:SubMenu("Qset", "> Q Settings")
	self.Menu.Qset:Boolean("Combo","Use in Combo", true)
	self.Menu.Qset:Boolean("Harass","Use in Harass", true)
	self.Menu.Qset:Boolean("LaneClear","Use in LaneClear", true)
	self.Menu.Qset:Boolean("JungleClear","Use in JungleClear", true)
	

	self.Menu:SubMenu("Wset", "> W Settings")
	self.Menu.Wset:Boolean("Combo","Use in Combo", true)
	self.Menu.Wset:Boolean("Harass","Use in Harass", false)
	self.Menu.Wset:Boolean("JungleClear","Use in JungleClear", true)
	
	self.Menu:SubMenu("Eset", "> E Settings")
	self.Menu.Eset:Boolean("Combo","Use in Combo", true)
	self.Menu.Eset:Slider("nAlly","Min Allies Around",3,1,5)
	self.Menu.Eset:Boolean("JungleClear","Use in JungleClear", true)
	--self.Menu.Eset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	self.Menu.Eset:Boolean("Turret","Shield Against Turrets", true)
	self.Menu.Eset:Boolean("Spell","Shield Against Spells", true)
	
	
	self.Menu:SubMenu("Rset", "> R Settings")
	self.Menu.Rset:Boolean("Combo","Use in Combo", true)
	self.Menu.Rset:Boolean("LaneClear","Use in LaneClear", true)
	self.Menu.Rset:Boolean("JungleClear","Use in JungleClear", true)
	
	--self.Menu.Rset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	
	
	self.Menu:SubMenu("AG", "> AntiGapcloser")
	AddGapcloseEvent(_W,W.range,true,self.Menu.AG)
	
	self.Menu:SubMenu("KS", "> KillSteal Settings")
	self.Menu.KS:Boolean("Q","Use Q",true)
	self.Menu.KS:Boolean("W","Use W",true)
	
		self.Menu:SubMenu("Draw", "> Draw Settings")
	self.Menu.Draw:Boolean("Q","Draw Q Range", true)
	self.Menu.Draw:Boolean("W","Draw W Range", true)
	self.Menu.Draw:Boolean("E","Draw E Range", true)
	self.Menu.Draw:Boolean("Root","Draw Root Time", true)
	
	PrintChat("Support Series:"..myHero.charName.." Loaded")

end

function Karma:Check()
	Q.ready = myHero:GetSpellData(_Q).level > 0 and myHero:CanUseSpell(_Q) == READY and true or false
	W.ready = myHero:GetSpellData(_W).level > 0 and myHero:CanUseSpell(_W) == READY and true or false
	E.ready = myHero:GetSpellData(_E).level > 0 and myHero:CanUseSpell(_E) == READY and true or false
	R.ready = myHero:GetSpellData(_R).level > 0 and myHero:CanUseSpell(_R) == READY and true or false
end

function Karma:GetTarget()
	if self.SelectedTarget then
		return self.SelectedTarget
	end	
	return GetCurrentTarget()
end

function Karma:ProcessSpell(unit,spell)
	if unit and unit.team ~= myHero.team and unit.type == "obj_AI_Turret" and spell.target and GetDistance(spell.target) < E.range and spell.target.type == myHero.type and spell.target.health/spell.target.maxHealth < 0.8 then
		if self.Menu.Eset.Turret:Value() and E.ready then
			myHero:CastSpell(_E,spell.target)
		end
	end
	
	if unit and unit.team ~= myHero.team and unit.type == myHero.type and spell.target and spell.target.type == myHero.type and GetDistance(spell.target) < E.range and spell.target.health/spell.target.maxHealth < 0.8  then
		if E.ready and not self.HasMantra then 
			myHero:CastSpell(_E,spell.target)
		end
	end
	

	if unit.team == 300 and spell.target and spell.target.team == myHero.team and  GetDistance(spell.target) < E.range and not self.HasMantra then
		if E.ready and self.Menu.Eset.JungleClear:Value() and not self.HasMantra then
			myHero:CastSpell(_E,spell.target)
		end	
	end
end

function Karma:UpdateBuff(unit,buff)
	if unit.isMe then
		--print(buff.Name)
	end
	if unit.team ~= myHero.team and buff.Name:lower():find("karma") then
		--print(buff.Name)
	end
	if unit.isMe and buff.Name:lower() == "karmamantra" then
		self.HasMantra = true
	end
	if unit.team ~= myHero.team and buff.Name:lower() == "karmaspiritbind" then
		
		self.RootBuff = {time = GetGameTimer() + 2, unit = unit }
	end
end

function Karma:RemoveBuff(unit,buff)
	if unit.isMe and buff.Name:lower() == "karmamantra" then
		self.HasMantra = false
	end
	if unit.team ~= myHero.team and buff.Name:lower() == "karmaspiritbind" then
		self.RootBuff[unit.networkID] = nil
	end
end


function Karma:Tick()
	if os.clock()*1000 < self.lastTick then
		return 
	end
	self.lastTick = os.clock()*1000 + 1
	self:Check()
	if self.SelectedTarget and self.SelectedTarget.dead then 
		self.SelectedTarget = nil
	end
	--self:
	if self.Menu.KS.W:Value() and W.ready then
		self:KillSteal()
	end
	if self.HasMantra then
		Q.range = 1150
	else
		Q.range = 950
	end

	if self.Menu.Key.Combo:Value() then
		self:Combo()
	end
	if self.Menu.Key.Harass:Value() then
		self:Harass()
	end
	if self.Menu.Key.LaneClear:Value() then
		self:LaneClear()
	end
	if self.Menu.Key.JungleClear:Value() then
		self:JungleClear()
	end
	if E.ready and self.Menu.Eset.Spell:Value() and _G.GoSEvade ~= nil then
		for i,ally in pairs(GetAllyHeroes()) do
			if GetDistance(ally) < E.range and not ally.dead and _G.GoSEvade:IsInSkillShots(ally,ally.pos,0,2) then
				myHero:CastSpell(_E,ally)
			end
		end
	end	

end

function Karma:GetShieldTarget()
	local result = myHero
	local total = CountAllyNearPos(myHero.pos,660)
	for i, ally in pairs(GetAllyHeroes()) do
		if ally and not ally.dead and ally.charName ~= myHero.charName and GetDistance(ally) <= E.range then
			local count = CountAllyNearPos(ally.pos,660)
			if count > total then
				total = count
				result = ally
			end
		end
	end
	if total >= self.Menu.Eset.nAlly:Value() then
		return result
	else
		return nil
	end	
end

function Karma:CollisitionCheck(pos)
	local objects = {}
	for _,minion in pairs(minionManager.objects) do
		if minion.team ~= myHero.team and ValidTarget(minion,1200) then
			local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(myHero.pos, pos, Vector(minion))
			if isOnSegment and GetDistance(pointSegment,minion) < Q.radius + minion.boundingRadius then
				table.insert(objects,minion)
			end
		end
	end
	return #objects > 0, objects
end

function Karma:Combo()
	
	local target = self:GetTarget()
	if ValidTarget(target) then
		if GetDistance(target) < W.range then
			myHero:CastSpell(_W,target)
		end
		if GetDistance(target) < Q.range + 150 then
			if R.ready and self.Menu.Rset.Combo:Value() then
				--print("use R")
				myHero:CastSpell(_R,myHero)
			end
			if Q.ready and GPred then
				local qPred = GPred:GetPrediction(target,myHero,Q)
				if qPred.HitChance >= 3  then
					local col,obj = self:CollisitionCheck(qPred.CastPosition)
					if not col then
						myHero:CastSpell(_Q,qPred.CastPosition.x,qPred.CastPosition.z)
					else
						table.sort(obj,function(x,y) return GetDistance(x) < GetDistance(y) end)
			
							if GetDistance(target) <= GetDistance(obj[1]) or (self.HasMantra and GetDistance(target,obj[1]) < 200) then
								myHero:CastSpell(_Q,qPred.CastPosition.x,qPred.CastPosition.z)
							end
						
					end
				end
			elseif Q.ready then
				local qPred = GetPrediction(target,Q)
				if qPred.hitChance > 0.1 then
					local col,obj = self:CollisitionCheck(qPred.castPos)
					if not col then
						myHero:CastSpell(_Q,qPred.castPos.x,qPred.castPos.z)
					else
						table.sort(obj,function(x,y) return GetDistance(x) < GetDistance(y) end)
			
							if GetDistance(target) <= GetDistance(obj[1]) or (self.HasMantra and GetDistance(target,obj[1]) < 200) then
								myHero:CastSpell(_Q,qPred.castPos.x,qPred.castPos.z)
							end
						
					end
				end
			end	
		end
	end
	if E.ready and self.Menu.Eset.Combo:Value() then
		local ally = self:GetShieldTarget()
		if ally and R.ready then
			myHero:CastSpell(_R,myHero)
		end
		if self.HasMantra then	
			myHero:CastSpell(_E,ally)
		end
	end
end

function Karma:KillSteal()

end

function Karma:Harass()

end

function Karma:LaneClear()
	local pos,hit = GetFarmPosition(Q.range,2*Q.radius,300-myHero.team)
	if pos and hit >= 1 then
		if hit > 1 and R.ready and self.Menu.Rset.LaneClear:Value() then
			myHero:CastSpell(_R,myHero)
		end
		--if hit > 1 and self.HasMantra then
		if self.Menu.Qset.LaneClear:Value() then
			myHero:CastSpell(_Q,pos.x,pos.z)
		end
	end
end

function Karma:JungleClear()
	local mobs = {}
	for _,mob in pairs(minionManager.objects) do
		if mob and not mob.dead and mob.team == 300 and ValidTarget(mob,Q.range) then
			table.insert(mobs,mob)
		end
	end
	if #mobs < 1 then return end
	table.sort(mobs,function(a,b) return a.maxHealth > b.maxHealth end)
	local mob = mobs[1]
	if mob then
		
		if Q.ready and GetDistance(mob) < Q.range and self.Menu.Qset.JungleClear:Value() then
			if R.ready and self.Menu.Rset.JungleClear:Value() then
				myHero:CastSpell(_R,myHero)
			end	
			myHero:CastSpell(_Q,mob.x,mob.z)
		end
		if W.ready and GetDistance(mob) < W.range and self.Menu.Wset.JungleClear:Value() then
			myHero:CastSpell(_W,mob)
		end
		if E.ready and not self.HasMantra then
			local eTarget = myHero
			--for i,ally in pa
			--myHero:CastSpell(_E,)
		end
	end
	
end


function Karma:Draw()
	if myHero.dead then return end
	if self.Menu.Draw.Root:Value() and self.RootBuff then
		local info = self.RootBuff
			if info and ValidTarget(info.unit) and info.time > GetGameTimer() then
				local dif = info.time - GetGameTimer()
				DrawText3D(tostring(string.format("%.1f", dif)), info.unit.x, info.unit.y, info.unit.z, 30, ARGB(240, 255, 255, 255), true)	
			end
		
	end
	if self.Menu.Draw.Q:Value() then
		local qcolor = Q.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,Q.range,1,qcolor,20)
	end
	if self.Menu.Draw.W:Value() then
		local wcolor = W.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,W.range,1,wcolor,20)
	end
	if self.Menu.Draw.E:Value() then
		local ecolor = E.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,E.range,1,ecolor,20)
	end
end

function Karma:WndMsg(msg,key)
	if msg == 513 then
		local minD = math.huge
		local starget = nil
		for i, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				if GetDistance(enemy, GetMousePos()) <= minD or starget == nil then
					minD = GetDistance(enemy, GetMousePos())
					starget = enemy
				end
			end
		end
		
		if starget and minD < 200 then
			if self.SelectedTarget and starget.charName == self.SelectedTarget.charName then
				self.SelectedTarget = nil
				PrintChat("<font color=\"#FF0000\">Deselected target: "..starget.charName.."</font>")
			else
				self.SelectedTarget = starget
				PrintChat("<font color=\"#ff8c00\">New target selected: "..starget.charName.."</font>")
			end
		end
	
	end

end

class "Morgana"

function Morgana:__init()
	Q = {ready = false, range = 1175, radius = 65, speed = 1200, delay = 0.25, type = "line",col = {"minion","champion"}}
	W = {ready = false, range = 900,radius = 225, speed = 2200, delay = 0.5, type = "circular" }
	E = {ready = false, range = 750 }
	R = {ready = false,range = 600}
	self.HasMantra = false
	self.lastTick = 0
	self.SelectedTarget = nil
	self.RootBuff = nil
	self.TargetsImmobile = {}
	self.TargetsSlowed  = {}
	self:LoadMenu()
	Callback.Add("UpdateBuff", function(u,s) self:UpdateBuff(u,s) end)
	--Callback.Add("RemoveBuff", function(u,s) self:RemoveBuff(u,s) end)
	Callback.Add("ProcessSpell",function(u,s) self:ProcessSpell(u,s) end)
	--Callback.Add("CreateObj",function(o) self:CreateObj(o) end)
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Draw",function() self:Draw() end)
	Callback.Add("WndMsg",function(Msg, Key) self:WndMsg(Msg, Key) end)
end

function Morgana:LoadMenu()
	self.Menu = Menu( "SB"..myHero.charName, "Morgana - The Fallen Angel")
	self.Menu:SubMenu("Key", "> Key Settings")
	self.Menu.Key:KeyBinding("Combo","Combo",32)
	self.Menu.Key:KeyBinding("Harass","Harass",string.byte("C"))

	
	self.Menu:SubMenu("Qset", "> Q Settings")
	self.Menu.Qset:Boolean("Combo","Use in Combo", true)
	self.Menu.Qset:Boolean("Harass","Use in Harass", true)
	self.Menu.Qset:Boolean("Immobile","Use on Immobile", true)
	--self.Menu.Qset:Boolean("JungleClear","Use in JungleClear", true)
	

	self.Menu:SubMenu("Wset", "> W Settings")
	self.Menu.Wset:Boolean("Combo","Use in Combo", true)
	self.Menu.Wset:Boolean("Harass","Use in Harass", true)
	
	self.Menu.Wset:Boolean("Immobile","Use on Immobile",true)
	
	self.Menu:SubMenu("Eset", "> E Settings")
	--self.Menu.Eset:Boolean("Combo","Use in Combo", true)
	--self.Menu.Eset:Slider("nAlly","Min Allies Around",3,1,5)
	--self.Menu.Eset:Boolean("JungleClear","Use in JungleClear", true)
	--self.Menu.Eset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	--self.Menu.Eset:Boolean("Turret","Shield Against Turrets", true)
	self.Menu.Eset:Boolean("Spell","Use Against Spells", true)
	
	
	self.Menu:SubMenu("Rset", "> R Settings")
	self.Menu.Rset:Boolean("AutoR","AutoR", true)
	self.Menu.Rset:Slider("Min","x Enemies Around", 2,1,5)
	
	
	--self.Menu.Rset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	
	
	self.Menu:SubMenu("AG", "> AntiGapcloser")
	AddGapcloseEvent(_Q,Q.range,true,self.Menu.AG)
	
	self.Menu:SubMenu("KS", "> KillSteal Settings")
	self.Menu.KS:Boolean("Q","Use Q",true)
	self.Menu.KS:Boolean("W","Use W",true)
	
		self.Menu:SubMenu("Draw", "> Draw Settings")
	self.Menu.Draw:Boolean("Q","Draw Q Range", true)
	self.Menu.Draw:Boolean("W","Draw W Range", true)
	self.Menu.Draw:Boolean("E","Draw E Range", true)
	self.Menu.Draw:Boolean("R","Draw R Range", true)
	self.Menu.Draw:Boolean("Root","Draw Root Time", true)
	
	PrintChat("Support Series:"..myHero.charName.." Loaded")

end

function Morgana:Check()
	Q.ready = myHero:GetSpellData(_Q).level > 0 and myHero:CanUseSpell(_Q) == READY and true or false
	W.ready = myHero:GetSpellData(_W).level > 0 and myHero:CanUseSpell(_W) == READY and true or false
	E.ready = myHero:GetSpellData(_E).level > 0 and myHero:CanUseSpell(_E) == READY and true or false
	R.ready = myHero:GetSpellData(_R).level > 0 and myHero:CanUseSpell(_R) == READY and true or false
end


function Morgana:GetTarget()
	if self.SelectedTarget then
		return self.SelectedTarget
	end	
	return GetCurrentTarget()
end

function Morgana:ProcessSpell(unit,spell)
	--if true then return end

	
	if unit and unit.team ~= myHero.team and unit.type == myHero.type and spell.target and spell.target.type == myHero.type and spell.target.team == myHero.team and GetDistance(spell.target) < E.range and spell.name and not spell.name:lower():find('attack') and not spell.name:lower():find('crit') then
		if E.ready and self.Menu.Eset.Spell:Value() then 
			myHero:CastSpell(_E,spell.target)
		end
	end


	
end

function Morgana:UpdateBuff(unit,buff)
	 if not unit or not buff or unit.type ~= myHero.type then return end
    
    if (buff.Type == 5 or buff.Type == 11 or buff.Type == 29 or buff.Type == 24) then
        self.TargetsImmobile[unit.networkID] = GetGameTimer() + (buff.ExpireTime - buff.StartTime)
        return
    end
    
    if (buff.Type == 10 or buff.Type == 22 or buff.Type == 21 or buff.Type == 8) then
        self.TargetsSlowed[unit.networkID] = GetGameTimer() + (buff.ExpireTime - buff.StartTime)
        return
    end

end



function Morgana:Tick()
	if os.clock()*1000 < self.lastTick then
		return 
	end
	self.lastTick = os.clock()*1000 + 2
	self:Check()
	if self.SelectedTarget and self.SelectedTarget.dead then 
		self.SelectedTarget = nil
	end
	--self:
	if Q.ready or W.ready then
		self:AutoCC()
	end
	if self.Menu.Key.Combo:Value() then
		self:Combo()
	end
	if self.Menu.Key.Harass:Value() then
		self:Harass()
	end
	if R.ready then
		self:AutoR()
	end
	if E.ready and self.Menu.Eset.Spell:Value() and _G.GoSEvade ~= nil then
		for i,ally in pairs(GetAllyHeroes()) do
			if GetDistance(ally) < E.range and not ally.dead and _G.GoSEvade:IsInSkillShots(ally,ally.pos,0,2) then
				myHero:CastSpell(_E,ally)
			end
		end
	end
end

function Morgana:CastQ(unit)
	if not ValidTarget(unit) then return end
	if GPred then
		
		local qPred = GPred:GetPrediction(unit,myHero,Q,false,true)
		if  qPred.HitChance >= 3 then
			myHero:CastSpell(_Q,qPred.CastPosition.x,qPred.CastPosition.z)
		end
		return
	end
	local qPred = GetPrediction(unit,Q)
	if qPred.hitChance > 0.1 and not qPred:mCollision(1) then
		myHero:CastSpell(_Q,qPred.castPos.x,qPred.castPos.z)
	end
end

function Morgana:CastW(unit)
	if not ValidTarget(unit) then return end
	if GPred then
		local qPred = GPred:GetPrediction(unit,myHero,W)
		if  qPred.HitChance >= 3 then
			myHero:CastSpell(_W,qPred.CastPosition.x,qPred.CastPosition.z)
		end
		return
	end
	local wPred = GetCircularAOEPrediction(unit,W)
	if wPred.hitChance > 0.1 then
		myHero:CastSpell(_W,wPred.x,wPred.z)
	end
end

function Morgana:Combo()
	local target = self:GetTarget()
	if ValidTarget(target) then
		if Q.ready and GetDistance(target) <= Q.range + target.boundingRadius and self.Menu.Qset.Combo:Value() then
			self:CastQ(target)
		end
		if W.ready and GetDistance(target) <= W.range + target.boundingRadius and self.Menu.Wset.Combo:Value() and (not Q.ready or myHero.mana > 200 ) then
			self:CastW(target)
		end
	end
end

function Morgana:Harass()
	local target = self:GetTarget()
	if ValidTarget(target) then
		if Q.ready and GetDistance(target) <= Q.range + target.boundingRadius and self.Menu.Qset.Harass:Value() then
			self:CastQ(target)
		end
		if W.ready and GetDistance(target) <= W.range + target.boundingRadius and self.Menu.Wset.Harass:Value() and (not Q.ready or myHero.mana > 200 ) then
			self:CastW(target)
		end
	end
end

function Morgana:AutoR()
	if self.Menu.Rset.AutoR:Value() then
		if EnemiesAround(myHero.pos,R.range - 100) >= self.Menu.Rset.Min:Value() then
			myHero:CastSpell(_R,myHero)
		end
	end
end

function Morgana:AutoCC()
	for _,enemy in pairs(GetEnemyHeroes()) do
		if Q.ready and ValidTarget(enemy,Q.range) and self.TargetsImmobile[enemy.networkID] and self.TargetsImmobile[enemy.networkID] > GetGameTimer() and self.Menu.Qset.Immobile:Value() then
			myHero:CastSpell(_Q,enemy.x,enemy.z)
		end
		if W.ready and ValidTarget(enemy,W.range) and self.TargetsImmobile[enemy.networkID] and self.TargetsImmobile[enemy.networkID] > GetGameTimer() and self.Menu.Wset.Immobile:Value() then
			myHero:CastSpell(_W,enemy.x,enemy.z)
		end
	end
	

end

function Morgana:Draw()
	if myHero.dead then return end

	if self.Menu.Draw.Q:Value() then
		local qcolor = Q.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,Q.range,1,qcolor,20)
	end
	if self.Menu.Draw.W:Value() then
		local wcolor = W.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,W.range,1,wcolor,20)
	end
	if self.Menu.Draw.E:Value() then
		local ecolor = E.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,E.range,1,ecolor,20)
	end
end

function Morgana:WndMsg(msg,key)
	if msg == 513 then
		local minD = math.huge
		local starget = nil
		for i, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				if GetDistance(enemy, GetMousePos()) <= minD or starget == nil then
					minD = GetDistance(enemy, GetMousePos())
					starget = enemy
				end
			end
		end
		
		if starget and minD < 200 then
			if self.SelectedTarget and starget.charName == self.SelectedTarget.charName then
				self.SelectedTarget = nil
				PrintChat("<font color=\"#FF0000\">Deselected target: "..starget.charName.."</font>")
			else
				self.SelectedTarget = starget
				PrintChat("<font color=\"#ff8c00\">New target selected: "..starget.charName.."</font>")
			end
		end
	
	end

end

class "Nautilus"


function Nautilus:__init()
	Q = {ready = false, range = 1100, radius = 90, speed = 2000, delay = 0.25, type = "line",col = {"champion","minion"}}
	W = {ready = false, range = 175 }
	E = {ready = false, range = 550 }
	R = {ready = false,range = 825}
	
	self.lastTick = 0
	self.SelectedTarget = nil
	self.RootBuff = nil
	self.InterruptableSpells = {}
	self:LoadMenu()
	Callback.Add("UpdateBuff", function(u,s) self:UpdateBuff(u,s) end)
	Callback.Add("RemoveBuff", function(u,s) self:RemoveBuff(u,s) end)
	Callback.Add("ProcessSpell",function(u,s) self:ProcessSpell(u,s) end)
	--Callback.Add("CreateObj",function(o) self:CreateObj(o) end)
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Draw",function() self:Draw() end)
	Callback.Add("WndMsg",function(Msg, Key) self:WndMsg(Msg, Key) end)
end

	
function Nautilus:LoadMenu()
	self.Menu = Menu( "SB"..myHero.charName, "Nautilus")
	self.Menu:SubMenu("Key", "> Key Settings")
	self.Menu.Key:KeyBinding("Combo","Combo",32)
	self.Menu.Key:KeyBinding("Harass","Harass",string.byte("C"))
	self.Menu.Key:KeyBinding("LaneClear","Lane Clear",string.byte("V"))
	self.Menu.Key:KeyBinding("JungleClear","Jungle Clear",string.byte("G"))
	self.Menu.Key:KeyBinding("Flee","Flee",string.byte("T"))
	
	self.Menu:SubMenu("Qset", "> Q Settings")
	self.Menu.Qset:Boolean("Combo","Use in Combo", true)
	self.Menu.Qset:Boolean("Harass","Use in Harass", true)
	
	self.Menu.Qset:Boolean("JungleClear","Use in JungleClear", true)
	

	self.Menu:SubMenu("Wset", "> W Settings")
	self.Menu.Wset:Boolean("Combo","Use in Combo", true)
	self.Menu.Wset:Boolean("Harass","Use in Harass", true)
	self.Menu.Wset:Boolean("JungleClear","Use in JungleClear", true)
	self.Menu.Wset:Boolean("Turret","Shield Against Turrets", true)
	self.Menu.Wset:Boolean("Spell","Shield Against Spells", true)
	
	self.Menu:SubMenu("Eset", "> E Settings")
	self.Menu.Eset:Boolean("Combo","Use in Combo", true)
	self.Menu.Eset:Boolean("LaneClear","Use in LaneClear", true)
	self.Menu.Eset:Slider("Min","Min Minions Around",3,1,5)
	self.Menu.Eset:Boolean("JungleClear","Use in JungleClear", true)
	--self.Menu.Eset:Boolean("Interrupt","Interrupt Enemy Spells", true)

	
	
	self.Menu:SubMenu("Rset", "> R Settings")
	self.Menu.Rset:Slider("Combo","Use R if hit x enemies", 2,1,5)
	self.Menu.Rset:KeyBinding("Semi","Semi-Cast", string.byte("R"))
	self.Menu.Rset:SubMenu("UseR","Use R On")
	--for i,enemy in pairs(GetEnemyHeroes()) do
	--	print(enemy.charName)
	--	self.Menu.Rset.UseR:Boolean(enemy.charName,enemy.charName,false)
	--end
	--self.Menu.Rset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	
	
	self.Menu:SubMenu("Fset", "> Flee Settings")
	self.Menu.Fset:Boolean("Q","Use Q",true)
	
	self.Menu:SubMenu("KS", "> KillSteal Settings")
	self.Menu.KS:Boolean("Q","Use Q",true)
	self.Menu.KS:Boolean("E","Use E",true)
	
		self.Menu:SubMenu("Draw", "> Draw Settings")
	self.Menu.Draw:Boolean("Q","Draw Q Range", true)
	
	self.Menu.Draw:Boolean("E","Draw E Range", true)
	self.Menu.Draw:Boolean("R","Draw R Range", true)
	--self.Menu.Draw:Boolean("Root","Draw Root Time", true)
	
	PrintChat("Support Series:"..myHero.charName.." Loaded")

end

function Nautilus:Check()
	Q.ready = myHero:GetSpellData(_Q).level > 0 and myHero:CanUseSpell(_Q) == READY and true or false
	W.ready = myHero:GetSpellData(_W).level > 0 and myHero:CanUseSpell(_W) == READY and true or false
	E.ready = myHero:GetSpellData(_E).level > 0 and myHero:CanUseSpell(_E) == READY and true or false
	R.ready = myHero:GetSpellData(_R).level > 0 and myHero:CanUseSpell(_R) == READY and true or false
end

function Nautilus:GetTarget()
	if self.SelectedTarget then
		return self.SelectedTarget
	end	
	return GetCurrentTarget()
end

function Nautilus:ProcessSpell(unit,spell)
	if unit and unit.team ~= myHero.team and unit.type == "obj_AI_Turret" and spell.target and spell.target.networkID == myHero.networkID then
		if self.Menu.Wset.Turret:Value() and W.ready then
			myHero:CastSpell(_W,myHero)
		end
	end
	
	if unit and unit.team ~= myHero.team and (unit.type == myHero.type or unit.team == 300 ) and spell.target and spell.target.networkID == myHero.networkID then
		if W.ready and self.Menu.Wset.Spell:Value() then 
			myHero:CastSpell(_W,myHero)
		end
	end

	
end

function Nautilus:UpdateBuff(unit,buff)
	if unit.isMe then
		--print(buff.Name)
	end
	if unit.team ~= myHero.team and buff.Name:lower():find("karma") then
		--print(buff.Name)
	end
	if unit.isMe and buff.Name:lower() == "karmamantra" then
		self.HasMantra = true
	end
	if unit.team ~= myHero.team and buff.Name:lower() == "karmaspiritbind" then
		
		self.RootBuff = {time = GetGameTimer() + 2, unit = unit }
	end
end

function Nautilus:RemoveBuff(unit,buff)
	if unit.isMe and buff.Name:lower() == "karmamantra" then
		self.HasMantra = false
	end
	if unit.team ~= myHero.team and buff.Name:lower() == "karmaspiritbind" then
		self.RootBuff[unit.networkID] = nil
	end
end


function Nautilus:Tick()
	for i, enemy in pairs(GetEnemyHeroes()) do
		if not self.Menu.Rset.UseR[enemy.charName] then
			self.Menu.Rset.UseR:Boolean(enemy.charName,enemy.charName,false)
		end
	end
	if os.clock()*1000 < self.lastTick then
		return 
	end
	self.lastTick = os.clock()*1000 + 1
	self:Check()
	if self.SelectedTarget and self.SelectedTarget.dead then 
		self.SelectedTarget = nil
	end
	--self:
	--if self.Menu.KS.W:Value() and W.ready then
		self:KillSteal()
	--end

	if self.Menu.Rset.Semi:Value()	then
		self:SemiR()
	end	
	if self.Menu.Key.Combo:Value() then
		self:Combo()
		return
	end
	if self.Menu.Key.Harass:Value() then
		self:Harass()
		return
	end
	if self.Menu.Key.LaneClear:Value() then
		self:LaneClear()
	end
	if self.Menu.Key.JungleClear:Value() then
		self:JungleClear()
	end
	if self.Menu.Key.Flee:Value() then
		self:Flee()
	end


end

function Nautilus:SemiR()
	if not R.ready then return end
	local target = self:GetTarget()
	if ValidTarget(target,R.range) and self.Menu.Rset.UseR[target.charName]:Value() then
		myHero:CastSpell(_R,target)
	end
end

function Nautilus:GetShieldTarget()
	local result = myHero
	local total = CountAllyNearPos(myHero.pos,660)
	for i, ally in pairs(GetAllyHeroes()) do
		if ally and not ally.dead and ally.charName ~= myHero.charName and GetDistance(ally) <= E.range then
			local count = CountAllyNearPos(ally.pos,660)
			if count > total then
				total = count
				result = ally
			end
		end
	end
	if total >= self.Menu.Eset.nAlly:Value() then
		return result
	else
		return nil
	end	
end

function Nautilus:WallCheck(pos)
	local distance = GetDistance(pos)
	local direction = (Vector(pos) - Vector(myHero)):normalized()
	for i = 50,distance,50 do
		local poscheck = Vector(myHero) + direction*i
		if MapPosition:inWall(poscheck) then
			return true
		end
	end
	return false	
end

function Nautilus:Flee()
	myHero:Move(GetMousePos().x,GetMousePos().z)
	if not Q.ready then return end
	for i = 0,600,50 do
		local direction = (Vector(GetMousePos()) - Vector(myHero)):normalized()
		local poscheck = Vector(myHero) + direction*(500+i - 15)
		if MapPosition:inWall(poscheck) and self.Menu.Fset.Q:Value() then
			myHero:CastSpell(_Q,poscheck.x,poscheck.z)
		end
	end

end


function Nautilus:Combo()
	local target = self:GetTarget()
	if ValidTarget(target) then
		if GetDistance(target) <= W.range then
			myHero:CastSpell(_W,myHero)
		end
		if GetDistance(target) < Q.range + 150 then
	
			if Q.ready and GPred then
				local qPred = GPred:GetPrediction(target,myHero,Q,false,true)
				if qPred.HitChance >= 3 and not self:WallCheck(qPred.CastPosition) then
					myHero:CastSpell(_Q,qPred.CastPosition.x,qPred.CastPosition.z)
				end
			elseif Q.ready then
				local qPred = GetPrediction(target,Q)
				if qPred.hitChance >= 0.2 and not qPred:mCollision(1) and not self:WallCheck(qPred.castPos) then
					myHero:CastSpell(_Q,qPred.castPos.x,qPred.castPos.z)
				end
			end	
		end
		if R.ready and self.Menu.Rset.Combo:Value() then
			self:AutoR()
		end
		if E.ready and self.Menu.Eset.Combo:Value() and GetDistance(target) <= E.range - 250 then
			myHero:CastSpell(_E,myHero)
		end
	end
	
end

function Nautilus:AutoR()
	for i, enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy,R.range) and EnemiesAround(enemy.pos,400) >= self.Menu.Rset.Combo:Value() then
			myHero:CastSpell(_R,enemy)
		end
	end
end

function Nautilus:KillSteal()

end

function Nautilus:Harass()

end

function Nautilus:LaneClear()

	if E.ready and self.Menu.Eset.LaneClear:Value() and MinionsAround(myHero.pos,E.range - 100,300 - myHero.team) >= self.Menu.Eset.Min:Value() then
		
		myHero:CastSpell(_E,myHero)
	end
	
end

function Nautilus:JungleClear()
	local mobs = {}
	for _,mob in pairs(minionManager.objects) do
		if mob and not mob.dead and mob.team == 300 and ValidTarget(mob,Q.range) then
			table.insert(mobs,mob)
		end
	end
	if #mobs < 1 then return end
	table.sort(mobs,function(a,b) return a.maxHealth > b.maxHealth end)
	local mob = mobs[1]
	if mob then
		
		if Q.ready and GetDistance(mob) < Q.range and self.Menu.Qset.JungleClear:Value() then
			myHero:CastSpell(_Q,mob.x,mob.z)
		end
		if W.ready and GetDistance(mob) < W.range and self.Menu.Wset.JungleClear:Value() then
			myHero:CastSpell(_W,myHero)
		end
		if E.ready and GetDistance(mob) < E.range  - 200 and self.Menu.Eset.JungleClear:Value()  then
			--print('EE')
			myHero:CastSpell(_E,myHero)
		end
	end
	
end


function Nautilus:Draw()
	if myHero.dead then return end

	if self.Menu.Draw.Q:Value() then
		local qcolor = Q.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,Q.range,1,qcolor,20)
	end
	if self.Menu.Draw.R:Value() then
		local wcolor = R.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,R.range,1,wcolor,20)
	end
	if self.Menu.Draw.E:Value() then
		local ecolor = E.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,E.range,1,ecolor,20)
	end
	
	

end

function Nautilus:WndMsg(msg,key)
	if msg == 513 then
		local minD = math.huge
		local starget = nil
		for i, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				if GetDistance(enemy, GetMousePos()) <= minD or starget == nil then
					minD = GetDistance(enemy, GetMousePos())
					starget = enemy
				end
			end
		end
		
		if starget and minD < 200 then
			if self.SelectedTarget and starget.charName == self.SelectedTarget.charName then
				self.SelectedTarget = nil
				PrintChat("<font color=\"#FF0000\">Deselected target: "..starget.charName.."</font>")
			else
				self.SelectedTarget = starget
				PrintChat("<font color=\"#ff8c00\">New target selected: "..starget.charName.."</font>")
			end
		end
	
	end

end

class "Nami"

function Nami:__init()
	Q = {ready = false, range = 875, radius = 150, speed = math.huge, delay = 0.9, type = "circular"}
	W = {ready = false, range = 725,radius = 225, speed = 2200, delay = 0.5, type = "circular" }
	E = {ready = false, range = 800 }
	R = {ready = false, range = 2750,radius = 260, speed = 850, delay = 0.5, type = "line" }
	self.HasMantra = false
	self.lastTick = 0
	self.SelectedTarget = nil
	self.RootBuff = nil
	self.TargetsImmobile = {}
	self.TargetsSlowed  = {}
	self:LoadMenu()
	Callback.Add("UpdateBuff", function(u,s) self:UpdateBuff(u,s) end)
	--Callback.Add("RemoveBuff", function(u,s) self:RemoveBuff(u,s) end)
	Callback.Add("ProcessSpell",function(u,s) self:ProcessSpell(u,s) end)
	--Callback.Add("CreateObj",function(o) self:CreateObj(o) end)
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Draw",function() self:Draw() end)
	Callback.Add("WndMsg",function(Msg, Key) self:WndMsg(Msg, Key) end)
end

function Nami:LoadMenu()
	self.Menu = Menu( "SB"..myHero.charName, "Nami - The Little Mermaid")
	
	self.Menu:SubMenu("Predict", "> Prediction Settings")
	self.Menu.Predict:Slider("Hc","HitChance (%)",20,1,100)
	
	self.Menu:SubMenu("Key", "> Key Settings")
	self.Menu.Key:KeyBinding("Combo","Combo",32)
	self.Menu.Key:KeyBinding("Harass","Harass",string.byte("C"))

	
	self.Menu:SubMenu("Qset", "> Q Settings")
	self.Menu.Qset:Boolean("Combo","Use in Combo", true)
	self.Menu.Qset:Boolean("Harass","Use in Harass", true)
	self.Menu.Qset:Boolean("Immobile","Use on Immobile", true)
	self.Menu.Qset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	--self.Menu.Qset:Boolean("JungleClear","Use in JungleClear", true)
	

	self.Menu:SubMenu("Wset", "> W Settings")
	self.Menu.Wset:Boolean("Combo","Use in Combo", true)
	self.Menu.Wset:Boolean("Harass","Use in Harass", true)
	
	--self.Menu.Wset:Boolean("Immobile","Use on Immobile",true)
	
	self.Menu:SubMenu("Eset", "> E Settings")
	self.Menu.Eset:Boolean("Combo","Use in Combo", true)
	self.Menu.Eset:Boolean("Harass","Use in Harass", true)
	--self.Menu.Eset:Slider("nAlly","Min Allies Around",3,1,5)
	--self.Menu.Eset:Boolean("JungleClear","Use in JungleClear", true)
	--self.Menu.Eset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	--self.Menu.Eset:Boolean("Turret","Shield Against Turrets", true)
	--self.Menu.Eset:Boolean("Spell","Use Against Spells", true)
	
	
	self.Menu:SubMenu("Rset", "> R Settings")
	self.Menu.Rset:KeyBinding("Semi","Semi-R", string.byte("T"))
	self.Menu.Rset:Slider("Auto R","Auto if hit x Enemies",4,1,5)
	self.Menu.Rset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	
	self.Menu:SubMenu("Heal", "> Heal Settings")
	self.Menu.Heal:Boolean("Me","Heal Me",true)
	self.Menu.Heal:Slider("MyHp","My %hp < ",50,1,100)
	self.Menu.Heal:Boolean("Ally","Heal Ally",true)
	self.Menu.Heal:Slider("AllyHp","Ally's %hp < ",50,1,100)
	self.Menu.Heal:Slider("Mana","Min %mana ",50,1,100)
	
	self.Menu:SubMenu("AG", "> AntiGapcloser")
	AddGapcloseEvent(_Q,Q.range,false,self.Menu.AG)
	
	self.Menu:SubMenu("KS", "> KillSteal Settings")
	self.Menu.KS:Boolean("Q","Use Q",true)
	self.Menu.KS:Boolean("W","Use W",true)
	
	self.Menu:SubMenu("Draw", "> Draw Settings")
	self.Menu.Draw:Boolean("Q","Draw Q Range", true)
	self.Menu.Draw:Boolean("W","Draw W Range", true)
	self.Menu.Draw:Boolean("E","Draw E Range", true)
	self.Menu.Draw:Boolean("R","Draw R Range", true)
	
	
	PrintChat("Support Series:"..myHero.charName.." Loaded")

end

function Nami:Check()
	Q.ready = myHero:GetSpellData(_Q).level > 0 and myHero:CanUseSpell(_Q) == READY and true or false
	W.ready = myHero:GetSpellData(_W).level > 0 and myHero:CanUseSpell(_W) == READY and true or false
	E.ready = myHero:GetSpellData(_E).level > 0 and myHero:CanUseSpell(_E) == READY and true or false
	R.ready = myHero:GetSpellData(_R).level > 0 and myHero:CanUseSpell(_R) == READY and true or false
end


function Nami:GetTarget()
	if self.SelectedTarget then
		--return self.SelectedTarget
	end	
	return GetCurrentTarget()
end

function Nami:ProcessSpell(unit,spell)
	
	if unit and unit.team ~= myHero.team and unit.type == "obj_AI_Turret" and spell.target and GetDistance(spell.target) < W.range and spell.target.type == myHero.type then
		if W.ready and spell.target.health/spell.target.maxHealth < 0.6  then
			myHero:CastSpell(_W,spell.target)
		end
	end
	
	if unit and unit.team == myHero.team and GetDistance(unit) < E.range and unit.type == myHero.type and spell.target and spell.target.type == myHero.type and  spell.name and (spell.name:lower():find("attac") or spell.name:lower():find("crit")) then
		if E.ready  then 
			myHero:CastSpell(_E,unit)
		end
	end
	

	
end

function Nami:UpdateBuff(unit,buff)
	 if not unit or not buff or unit.type ~= myHero.type then return end
    
    if (buff.Type == 5 or buff.Type == 11 or buff.Type == 29 or buff.Type == 24) then
        self.TargetsImmobile[unit.networkID] = GetGameTimer() + (buff.ExpireTime - buff.StartTime) - 0.05
        return
    end
    
    if (buff.Type == 10 or buff.Type == 22 or buff.Type == 21 or buff.Type == 8) then
        self.TargetsSlowed[unit.networkID] = GetGameTimer() + (buff.ExpireTime - buff.StartTime) - 0.05
        return
    end

end

function Nami:RemoveBuff(unit,buff)
	if unit.isMe and buff.Name:lower() == "karmamantra" then
		self.HasMantra = false
	end
	if unit.team ~= myHero.team and buff.Name:lower() == "karmaspiritbind" then
		self.RootBuff[unit.networkID] = nil
	end
end


function Nami:Tick()
	if os.clock()*1000 < self.lastTick then
		return 
	end
	self.lastTick = os.clock()*1000 + 2
	self:Check()
	if self.SelectedTarget and self.SelectedTarget.dead then 
		self.SelectedTarget = nil
	end
	--self:
	if Q.ready  then
		self:AutoCC()
	end
	if self.Menu.Key.Combo:Value() then
		self:Combo()
	end
	if self.Menu.Key.Harass:Value() then
		self:Harass()
	end
	if R.ready  then
		self:AutoR()
	end
	if W.ready then
		self:Heal()
	end
	if self.Menu.Rset.Semi:Value() then
		self:CastR()
	end
end

function Nami:Heal()
	if myHero.mana/myHero.maxMana < self.Menu.Heal.Mana:Value()/100 then return end
	if myHero.isRecalling then return end
	if self.Menu.Heal.Me:Value() and myHero.health/myHero.maxHealth < self.Menu.Heal.MyHp:Value()/100 then
		myHero:CastSpell(_W,myHero)
	end
	if self.Menu.Heal.Ally:Value() then
		for i,ally in pairs(GetAllyHeroes()) do
			if not ally.dead and GetDistance(ally) <= W.range and ally.health/ally.maxHealth < self.Menu.Heal.AllyHp:Value()/100 then
				myHero:CastSpell(_W,ally)
			end
		end
	end
end

function Nami:CastQ(unit)
	if GPred then
		local qPred = GPred:GetPrediction(unit,myHero,Q)
		if  qPred.HitChance >= 3 then
			myHero:CastSpell(_Q,qPred.CastPosition.x,qPred.CastPosition.z)
		end
		return
	end
	local qPred = GetPrediction(unit,Q)
	if qPred.hitChance >= self.Menu.Predict.Hc:Value()/100 then
		myHero:CastSpell(_Q,qPred.castPos.x,qPred.castPos.z)
	end
end

function Nami:CastR()
	local target = self:GetTarget()
	if ValidTarget(target,R.range) then
		local rPred = GetPrediction(target,R)	
		if rPred.hitChance >= self.Menu.Predict.Hc:Value()/100 then
			myHero:CastSpell(_R,rPred.x,rPred.z)
		end
	end
end

function Nami:Combo()
	local target = self:GetTarget()
	if ValidTarget(target) then
		if Q.ready and GetDistance(target) <= Q.range + target.boundingRadius and self.Menu.Qset.Combo:Value() then
			self:CastQ(target)
		end
		if W.ready and GetDistance(target) <= W.range  and self.Menu.Wset.Combo:Value() then
			myHero:CastSpell(_W,target)
		end
		if E.ready and AlliesAround(myHero.pos,E.range) < 1 and self.Menu.Eset.Combo:Value() then
			myHero:CastSpell(_E,target)
		end
	end
	
end

function Nami:Harass()
	local target = self:GetTarget()
	if ValidTarget(target) then
		if Q.ready and GetDistance(target) <= Q.range + target.boundingRadius and self.Menu.Qset.Harass:Value() then
			self:CastQ(target)
		end
		if W.ready and GetDistance(target) <= W.range  and self.Menu.Wset.Harass:Value() then
			myHero:CastSpell(_W,target)
		end
	end
end

function Nami:AutoR()
	local target = self:GetTarget()
	if ValidTarget(target,1800) and EnemiesAround(target.pos,1000) >= self.Menu.Rset.AutoR:Value() then
		local rPred = GPred:GetPrediction(target,myHero,R,true)
		if rPred.HitChance >=3 and rPred.MaxHit >= self.Menu.Rset.AutoR:Value() then
			myHero:CastSpell(_R,rPred.CastPosition.x,rPred.CastPosition.z)
		end
	end
end

function Nami:AutoCC()
	for _,enemy in pairs(GetEnemyHeroes()) do
		if Q.ready and GetDistance(enemy) <= Q.range and self.TargetsImmobile[enemy.networkID] and self.TargetsImmobile[enemy.networkID] > GetGameTimer() and self.Menu.Qset.Immobile:Value() then
			myHero:CastSpell(_Q,enemy.x,enemy.z)
		end
		
	end
	

end

function Nami:Draw()
	if myHero.dead then return end
	
	if self.Menu.Draw.Q:Value() then
		local qcolor = Q.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,Q.range,1,qcolor,20)
	end
	if self.Menu.Draw.W:Value() then
		local wcolor = W.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,W.range,1,wcolor,20)
	end
	if self.Menu.Draw.E:Value() then
		local ecolor = E.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,E.range,1,ecolor,20)
	end
	if self.Menu.Draw.R:Value() then
		local rcolor = R.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,R.range,1,rcolor,20)
	end
end

function Nami:WndMsg(msg,key)
	if msg == 513 then
		local minD = math.huge
		local starget = nil
		for i, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				if GetDistance(enemy, GetMousePos()) <= minD or starget == nil then
					minD = GetDistance(enemy, GetMousePos())
					starget = enemy
				end
			end
		end
		
		if starget and minD < 200 then
			if self.SelectedTarget and starget.charName == self.SelectedTarget.charName then
				self.SelectedTarget = nil
				PrintChat("<font color=\"#FF0000\">Deselected target: "..starget.charName.."</font>")
			else
				self.SelectedTarget = starget
				PrintChat("<font color=\"#ff8c00\">New target selected: "..starget.charName.."</font>")
			end
		end
	
	end

end

class "Zilean"

function Zilean:__init()
	Q = {ready = false, range = 900, radius = 180, speed = 2000, delay = 0.25, type = "circular", mana = function() return myHero:GetSpellData(_Q).level > 0 and ({60,65,70,75,80})[myHero:GetSpellData(_Q).level] or 0 end}
	W = {ready = false, range = 725,mana = 35 }
	E = {ready = false, range = 800,mana = 50 }
	R = {ready = false, range = 900, mana = function() return myHero:GetSpellData(_R).level > 0 and ({125,150,175})[myHero:GetSpellData(_R).level] or 0 end }
	
	self.lastTick = 0
	self.SelectedTarget = nil
	self.HasBuffSpeed = false
	self.InitiatorsList  = {
	["Aatrox"] = {name = "aatroxq", type = "endPos" },
	["Akali"] = {name = "akalishadowdance", type = "target" },
	["Amumu"] = {name = "bandagetoss", type = "endPos" },
	["Ekko"] = {name = "ekkoe", type = "target" },
	["FiddleSticks"] = {name = "crowstorm", type = "endPos" },
	["Fiora"] = {name = "fioraq", type = "endPos" },
	["Gnar"] = {name = "gnare", type = "endPos" },
	["Gnar"] = {name = "gnarbige", type = "endPos" },
	["Gragas"] = {name = "gragase", type = "endPos" },
	["JarvanIV"] = {name = "jarvanivdragonstrike", type = "endPos" },
	["Jax"] = {name = "jaxleapstrike", type = "endPos" },
	["Katarina"] = {name = "katarinae", type = "target" },
	["Kassadin"] = {name = "riftwalk", type = "endPos" },
	["KhaZix"] = {name = "khazixe", type = "endPos" },
	["KhaZix"] = {name = "khazixelong", type = "endPos" },
	["LeeSin"] = {name = "blindmonkqtwo", type = "target" },
	["Shyvana"] = {name = "shyvanatransformcast", type = "target" },
	["Leona"] = {name = "leonazenithblademissle", type = "endPos" },
	["Shyvana"] = {name = "shyvanatransformleap", type = "endPos" },
	}
	self.TargetsImmobile = {}
	self.TargetsSlowed  = {}
	self:LoadMenu()
	Callback.Add("UpdateBuff", function(u,s) self:UpdateBuff(u,s) end)
	Callback.Add("RemoveBuff", function(u,s) self:RemoveBuff(u,s) end)
	Callback.Add("ProcessSpell",function(u,s) self:ProcessSpell(u,s) end)
	
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Draw",function() self:Draw() end)
	--Callback.Add("WndMsg",function(Msg, Key) self:WndMsg(Msg, Key) end)
end

function Zilean:LoadMenu()
	self.Menu = Menu( "SB"..myHero.charName, "Zilean - The Master of Time")
	
	self.Menu:SubMenu("Predict", "> Prediction Settings")
	self.Menu.Predict:Slider("Hc","HitChance",2,2,5)
	self.Menu.Predict:Info("info1","2 - Normal")
	self.Menu.Predict:Info("info2","3 - High (rarely cast)")
	self.Menu.Predict:Info("info1","4 - Dash")
	self.Menu.Predict:Info("info1","5 - Immobile")
	
	self.Menu:SubMenu("Key", "> Key Settings")
	self.Menu.Key:KeyBinding("Combo","Combo",32)
	self.Menu.Key:KeyBinding("Harass","Harass",string.byte("C"))
	self.Menu.Key:KeyBinding("LaneClear","LaneClear",string.byte("V"))
	self.Menu.Key:KeyBinding("Flee","Flee",string.byte("T"))
	
	self.Menu:SubMenu("Qset", "> Q Settings")
	self.Menu.Qset:Boolean("Combo","Use in Combo", true)
	--self.Menu.Qset:Boolean("ComboEQ","Use EQ Combo", true)
	self.Menu.Qset:Boolean("Harass","Use in Harass", true)
	self.Menu.Qset:Boolean("Immobile","Use on Immobile", true)
	self.Menu.Qset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	--self.Menu.Qset:Boolean("JungleClear","Use in JungleClear", true)
	

	self.Menu:SubMenu("Wset", "> W Settings")
	self.Menu.Wset:Boolean("Combo","Use in Combo", true)
	self.Menu.Wset:Boolean("Harass","Use in Harass", true)
	
	--self.Menu.Wset:Boolean("Immobile","Use on Immobile",true)
	
	self.Menu:SubMenu("Eset", "> E Settings")
	self.Menu.Eset:Boolean("Combo","Use in Combo", true)
	self.Menu.Eset:Boolean("Speed","Buff Speed for Ally", true)
	self.Menu.Eset:Boolean("Harass","Use in Harass", true)

	
	self.Menu:SubMenu("Rset", "> R Settings")
	
	self.Menu.Rset:Boolean("AutoR","Auto R to Save Life",true)
	self.Menu.Rset:Boolean("Me","Save Me",true)
	self.Menu.Rset:Slider("MyHp","My %hp < ",30,1,100)
	self.Menu.Rset:Boolean("Ally","Save Ally",true)
	self.Menu.Rset:Slider("AllyHp","Ally's %hp < ",30,1,100)
	
	
	
	self.Menu:SubMenu("AG", "> AntiGapcloser")
	AddGapcloseEvent(_Q,Q.range,false,self.Menu.AG)
	
	self.Menu:SubMenu("KS", "> KillSteal Settings")
	self.Menu.KS:Boolean("Q","Use Q",true)
	self.Menu.KS:Boolean("E","Use E",true)
	self.Menu.KS:Boolean("Ignite","Use Ignite",true)
	
	self.Menu:SubMenu("Draw", "> Draw Settings")
	self.Menu.Draw:Boolean("Q","Draw Q Range", true)
	--self.Menu.Draw:Boolean("W","Draw W Range", true)
	self.Menu.Draw:Boolean("E","Draw E Range", true)
	self.Menu.Draw:Boolean("R","Draw R Range", true)
	
	
	PrintChat("Support Series:"..myHero.charName.." Loaded")

end

function Zilean:Check()
	Q.ready = myHero:GetSpellData(_Q).level > 0 and myHero:CanUseSpell(_Q) == READY and true or false
	W.ready = myHero:GetSpellData(_W).level > 0 and myHero:CanUseSpell(_W) == READY and true or false
	E.ready = myHero:GetSpellData(_E).level > 0 and myHero:CanUseSpell(_E) == READY and true or false
	R.ready = myHero:GetSpellData(_R).level > 0 and myHero:CanUseSpell(_R) == READY and true or false
end


function Zilean:GetTarget()

	return GetCurrentTarget()
end

function Zilean:ProcessSpell(unit,spell)
	if Q.ready and unit.type == myHero.type and unit.team == myHero.team then
		local info = self.InitiatorsList[unit.charName]
		if info and info.name == spell.name:lower() and GetDistance(unit) < Q.range then
			if info.type == "target" then
				myHero:CastSpell(_Q,unit.x,unit.z)
			elseif (spell.target and spell.target.type == myHero.type) or (spell.endPos and EnemiesAround(spell.endPos,300) > 0)  then	
				myHero:CastSpell(_Q,unit.x,unit.z)
			end
		end
	end
	if not R.ready then return end
	if unit and unit.team ~= myHero.team and unit.type == "obj_AI_Turret" and spell.target  and spell.target.type == myHero.type and GetDistance(spell.target) < R.range then
		if R.ready and spell.target.health < unit.totalDamage  then
			myHero:CastSpell(_R,spell.target)
		end
	end
	--ignite dmg
	if unit and unit.team ~= myHero.team and unit.type == myHero.type and spell.target  and spell.name:lower():find("summonerdot") and GetDistance(spell.target) < R.range then
		if 50+20*GetLevel(unit) - 20 > spell.target.health then
			myHero:CastSpell(_R,spell.target)
		end
	end
end

function Zilean:UpdateBuff(unit,buff)
	 if not unit or not buff or unit.type ~= myHero.type then return end
    if unit.isMe and buff.Name:lower():find("timewarp") then
		self.HasBuffSpeed = true
	end
    if (buff.Type == 5 or buff.Type == 11 or buff.Type == 29 or buff.Type == 24) then
        self.TargetsImmobile[unit.networkID] = GetGameTimer() + (buff.ExpireTime - buff.StartTime) - 0.05
        return
    end
    
    if (buff.Type == 10 or buff.Type == 22 or buff.Type == 21 or buff.Type == 8) then
        self.TargetsSlowed[unit.networkID] = GetGameTimer() + (buff.ExpireTime - buff.StartTime) - 0.05
        return
    end

end

function Zilean:RemoveBuff(unit,buff)
	 if unit.isMe and buff.Name:lower():find("timewarp") then
		self.HasBuffSpeed = false
	end
end


function Zilean:Tick()
	--print(Q.mana())
	if os.clock()*1000 < self.lastTick then
		return 
	end
	self.lastTick = os.clock()*1000 + 2
	self:Check()
	if self.SelectedTarget and self.SelectedTarget.dead then 
		self.SelectedTarget = nil
	end
	--self:
	if Q.ready  then
		self:AutoCC()
	end
	if E.ready and self.Menu.Eset.Speed:Value() then
		self:BuffSpeed()
	end
	if self.Menu.Key.Combo:Value() then
		self:Combo()
	end
	if self.Menu.Key.Harass:Value() then
		self:Harass()
	end
	
	if self.Menu.Key.Flee:Value() then
		self:Flee()
	end
	
	if R.ready then
		self:AutoR()
	end

	
end

function Zilean:AutoR()
	
	if myHero.isRecalling then return end
	if self.Menu.Rset.Me:Value() and myHero.health/myHero.maxHealth < self.Menu.Rset.MyHp:Value()/100 and EnemiesAround(myHero,650) > 0 then
		myHero:CastSpell(_R,myHero)
	end
	if self.Menu.Rset.Ally:Value() then
		for i,ally in pairs(GetAllyHeroes()) do
			if not ally.dead and GetDistance(ally) <= R.range and ally.health/ally.maxHealth < self.Menu.Rset.AllyHp:Value()/100  and EnemiesAround(ally.pos,650) > 0 then
				myHero:CastSpell(_R,ally)
			end
		end
	end
end

function Zilean:BuffSpeed()
	local target = GetCurrentTarget()
	if ValidTarget(target,2500) then
		local distance = GetDistance(target)
		local eally = nil
		for i,ally in pairs(GetAllyHeroes()) do
			if GetDistance(ally) <= E.range and GetDistance(target,ally) < distance then
				eally = ally
				distance = GetDistance(target,ally)
			end
		end
		if eally ~= nil and distance < 500 then
			myHero:CastSpell(_E,eally)
		end
	end
end

function Zilean:CastQ(unit)
	if GPred then
		local qPred = GPred:GetPrediction(unit,myHero,Q)
		if qPred.HitChance >= 3 then
			myHero:CastSpell(_Q,qPred.CastPosition.x,qPred.CastPosition.z)
		end
		return
	end
	local qPred = GetPrediction(unit,Q)
	if qPred.hitChance >= self.Menu.Predict.Hc:Value()/100 then
		myHero:CastSpell(_Q,qPred.castPos.x,qPred.castPos.z)
	end
end


function Zilean:Combo()
	local target = self:GetTarget()
	if ValidTarget(target) then
		if Q.ready and GetDistance(target) <= Q.range + target.boundingRadius and self.Menu.Qset.Combo:Value() then
			self:CastQ(target)
		end
		if W.ready and (not Q.ready )  and self.Menu.Wset.Combo:Value() and myHero.mana > W.mana + E.mana + Q.mana()*2 + R.mana() then
			myHero:CastSpell(_W,myHero)
		end
		if E.ready  and self.Menu.Eset.Combo:Value() then
			if GetDistance(target) <= E.range + target.boundingRadius then
				myHero:CastSpell(_E,target)
			else
				if GetDistance(target) < E.range + ((({40 , 55 , 70 , 85 , 99})[myHero:GetSpellData(_E).level]/100 + 1)*myHero.ms - target.ms)*2.5 then
					myHero:CastSpell(_E,myHero)
				end	
			end
			
		end
	end
	
end

function Zilean:Harass()
	local target = self:GetTarget()
	if ValidTarget(target) then
		if Q.ready and GetDistance(target) <= Q.range + target.boundingRadius and self.Menu.Qset.Harass:Value() then
			self:CastQ(target)
		end
		if W.ready and GetDistance(target) <= W.range  and self.Menu.Wset.Harass:Value() then
			myHero:CastSpell(_W,target)
		end
		if E.ready and GetDistance(target) <= E.range + target.boundingRadius and self.Menu.Eset.Combo:Value() then
			myHero:CastSpell(_E,target)
		end
	end
end

function Zilean:Flee()
	
	myHero:Move(GetMousePos().x,GetMousePos().z)
	if E.ready and not self.HasBuffSpeed then
		myHero:CastSpell(_E,myHero)
	end
	if W.ready and (not Q.ready or not E.ready or not R.ready) then
		myHero:CastSpell(_W,myHero)
	end

end

function Zilean:AutoCC()
	for _,enemy in pairs(GetEnemyHeroes()) do
		if Q.ready and ValidTarget(enemy,Q.range) and self.TargetsImmobile[enemy.networkID] and self.TargetsImmobile[enemy.networkID] > GetGameTimer() + 0.15 and self.Menu.Qset.Immobile:Value() then
			myHero:CastSpell(_Q,enemy.x,enemy.z)
			DelayAction(function() if W.ready then CastSpell(_W) end end,0.25)
		end
		if Q.ready and ValidTarget(enemy,Q.range) and self.TargetsSlowed[enemy.networkID] and self.TargetsSlowed[enemy.networkID] > GetGameTimer() + 0.15 and self.Menu.Qset.Immobile:Value() then
			self:CastQ(enemy)
			DelayAction(function() if W.ready then CastSpell(_W) end end,0.25)
		end
	end
	if not E.ready then return end
	for i,ally in pairs(GetAllyHeroes()) do
		if E.ready and self.TargetsSlowed[ally.networkID] and self.TargetsSlowed[ally.networkID] >= GetGameTimer() + 0.25 and GetDistance(ally) <= E.range then
			myHero:CastSpell(_E,ally)
		end
	end
end

function Zilean:Draw()
	if myHero.dead then return end
	
	if self.Menu.Draw.Q:Value() then
		local qcolor = Q.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,Q.range,1,qcolor,20)
	end

	if self.Menu.Draw.E:Value() then
		local ecolor = E.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,E.range,1,ecolor,20)
	end
	if self.Menu.Draw.R:Value() then
		local rcolor = R.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,R.range,1,rcolor,20)
	end
end

function Zilean:WndMsg(msg,key)
	if msg == 513 then
		local minD = math.huge
		local starget = nil
		for i, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				if GetDistance(enemy, GetMousePos()) <= minD or starget == nil then
					minD = GetDistance(enemy, GetMousePos())
					starget = enemy
				end
			end
		end
		
		if starget and minD < 200 then
			if self.SelectedTarget and starget.charName == self.SelectedTarget.charName then
				self.SelectedTarget = nil
				PrintChat("<font color=\"#FF0000\">Deselected target: "..starget.charName.."</font>")
			else
				self.SelectedTarget = starget
				PrintChat("<font color=\"#ff8c00\">New target selected: "..starget.charName.."</font>")
			end
		end
	
	end

end


---Braum


class "Braum"

function Braum:__init()
	Q = {ready = false, range = 1000, radius = 70, speed = 1700, delay = 0.2, type = "line",col = {"minion","champion"}}
	W = {ready = false, range = 650,radius = 225, speed = 2200, delay = 0.5, type = "circular" }
	E = {ready = false, range = 0 }
	R = {ready = false, range = 1250, radius = 115, speed = 1400, delay = 0.5, type = "line"}
	self.HasMantra = false
	self.lastTick = 0
	self.SelectedTarget = nil
	self.RootBuff = nil
	self.TargetsImmobile = {}
	self.TargetsSlowed  = {}
	self:LoadMenu()
	Callback.Add("UpdateBuff", function(u,s) self:UpdateBuff(u,s) end)
	Callback.Add("RemoveBuff", function(u,s) self:RemoveBuff(u,s) end)
	Callback.Add("ProcessSpell",function(u,s) self:ProcessSpell(u,s) end)
	Callback.Add("CreateObj",function(o) self:CreateObj(o) end)
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Draw",function() self:Draw() end)
	Callback.Add("WndMsg",function(Msg, Key) self:WndMsg(Msg, Key) end)
end

function Braum:LoadMenu()
	self.Menu = Menu( "SB"..myHero.charName, "Braum - The Poro Savior")
	self.Menu:SubMenu("Key", "> Key Settings")
	self.Menu.Key:KeyBinding("Combo","Combo",32)
	self.Menu.Key:KeyBinding("Harass","Harass",string.byte("C"))

	
	self.Menu:SubMenu("Qset", "> Q Settings")
	self.Menu.Qset:Boolean("AutoQ","Auto Q", true)
	self.Menu.Qset:Boolean("Combo","Use in Combo", true)
	self.Menu.Qset:Boolean("Harass","Use in Harass", true)
	self.Menu.Qset:Boolean("Immobile","Use on Immobile", true)
	--self.Menu.Qset:Boolean("JungleClear","Use in JungleClear", true)
	

	self.Menu:SubMenu("Wset", "> W Settings")
	self.Menu.Wset:Boolean("Spell","Shield Allies", true)
	self.Menu.Wset:Slider("Min","Min Danger Level", 1,1,5)
	--self.Menu.Wset:Boolean("Harass","Use in Harass", true)
	
	--self.Menu.Wset:Boolean("Immobile","Use on Immobile",true)
	
	self.Menu:SubMenu("Eset", "> E Settings")
	--self.Menu.Eset:Boolean("Combo","Use in Combo", true)
	--self.Menu.Eset:Slider("nAlly","Min Allies Around",3,1,5)
	--self.Menu.Eset:Boolean("JungleClear","Use in JungleClear", true)
	--self.Menu.Eset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	--self.Menu.Eset:Boolean("Turret","Shield Against Turrets", true)
	self.Menu.Eset:Boolean("Spell","Use Against Spells", true)
	
	
	self.Menu:SubMenu("Rset", "> R Settings")
	self.Menu.Rset:KeyBinding("SemiR","Semi-R Key", string.byte("T"))
	self.Menu.Rset:Boolean("AutoR","AutoR", true)
	self.Menu.Rset:Slider("Min","Min enemies hit", 3,1,5)
	self.Menu.Rset:Boolean("SmartR","SmartR ",true)
	
	--self.Menu.Rset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	
	
	self.Menu:SubMenu("AG", "> AntiGapcloser")
	AddGapcloseEvent(_Q,Q.range,false,self.Menu.AG)
	
	--self.Menu:SubMenu("KS", "> KillSteal Settings")
	--self.Menu.KS:Boolean("Q","Use Q",true)
	--self.Menu.KS:Boolean("W","Use W",true)
	
		self.Menu:SubMenu("Draw", "> Draw Settings")
	self.Menu.Draw:Boolean("Q","Draw Q Range", true)
	self.Menu.Draw:Boolean("W","Draw W Range", true)
	--self.Menu.Draw:Boolean("E","Draw E Range", true)
	self.Menu.Draw:Boolean("R","Draw R Range", true)
	
	
	PrintChat("Support Series:"..myHero.charName.." Loaded")

end

function Braum:Check()
	Q.ready = myHero:GetSpellData(_Q).level > 0 and myHero:CanUseSpell(_Q) == READY and true or false
	W.ready = myHero:GetSpellData(_W).level > 0 and myHero:CanUseSpell(_W) == READY and true or false
	E.ready = myHero:GetSpellData(_E).level > 0 and myHero:CanUseSpell(_E) == READY and true or false
	R.ready = myHero:GetSpellData(_R).level > 0 and myHero:CanUseSpell(_R) == READY and true or false
end


function Braum:GetTarget(range)
	range = range or math.huge
	if ValidTarget(self.SelectedTarget,range) then
		return self.SelectedTarget
	end	
	return GetCurrentTarget()
end

function Braum:ProcessSpell(unit,spell)
	--if true then return end

	
	if unit and unit.team ~= myHero.team and unit.type == myHero.type and spell.target == myHero and  spell.name and (spell.name:lower():find('attack') or spell.name:lower():find('crit') or spell.name:lower():find('card')) and myHero.health/myHero.maxHealth < 0.4 then
		if E.ready and self.Menu.Eset.Spell:Value() then 
			myHero:CastSpell(_E,unit.x,unit.z)
		end
	end
	
end

function Braum:CreateObj(o)
	if not o or o.name ~= "missile" then return end
	DelayAction(function(obj) 
	if obj.spellName == "CaitlynAceintheHoleMissile" and GetObjectSpellOwner(obj).team ~= myHero.team then 
		if obj.target == myHero  then
			myHero:CastSpell(_E,obj.x,obj.z)
		end
		if obj.target.team == myHero.team then
			myHero:CastSpell(_W,obj.target)
			DelayAction(function() myHero:CastSpell(_E,obj.x,obj.z) end,0.25)
		end
	end	
	end,0, {o})

end

function Braum:UpdateBuff(unit,buff)
	 if not unit or not buff or unit.type ~= myHero.type then return end
    
    if (buff.Type == 5 or buff.Type == 11 or buff.Type == 29 or buff.Type == 24) then
        self.TargetsImmobile[unit.networkID] = GetGameTimer() + (buff.ExpireTime - buff.StartTime)
        return
    end
    
    if (buff.Type == 10 or buff.Type == 22 or buff.Type == 21 or buff.Type == 8) then
        self.TargetsSlowed[unit.networkID] = GetGameTimer() + (buff.ExpireTime - buff.StartTime)
        return
    end
	
end


function Braum:Tick()
	if os.clock()*1000 < self.lastTick then
		return 
	end
	self.lastTick = os.clock()*1000 + 2
	self:Check()
	if self.SelectedTarget and self.SelectedTarget.dead then 
		self.SelectedTarget = nil
	end
	--self:
	if Q.ready then
		self:AutoCC()
	end
	if self.Menu.Key.Combo:Value() or self.Menu.Key.Harass:Value() or self.Menu.Qset.AutoQ:Value() then
		self:CastQ()
	end
	
	if R.ready then
		
		self:AutoR()
		if self.Menu.Rset.SemiR:Value() then
			self:CastR()
		end
	end
	if W.ready and self.Menu.Wset.Spell:Value() and _G.GoSEvade ~= nil and myHero.health/myHero.maxHealth > 0.25 then
		for i,ally in pairs(GetAllyHeroes()) do
			if GetDistance(ally) <= W.range and not ally.dead and _G.GoSEvade:IsInSkillShots(ally,ally.pos,6,self.Menu.Wset.Min:Value()) then
				myHero:CastSpell(_W,ally)
				
			end
		end
	end
	if E.ready and spellDetector then
		for i, spell in pairs(spellDetector.spells) do
			if spell.info.collisionObjects then
				local spellPos = spell.currentSpellPosition;
				local spellEndPos = spell.endPos
				local  proj, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(Vector(spellPos), Vector(spellEndPos),Vector(myHero.pos))
				if isOnSegment and GetDistance(proj) <= spell.radius + myHero.boundingRadius + 15 then
					myHero:CastSpell(_E,spell.owner.x,spell.owner.z)
				end
			end
		end
	end
end

function Braum:CastQ(unit)
	unit = unit or self:GetTarget(Q.range+100)
	if not ValidTarget(unit,Q.range + 100) then return end
	if GPred then
		local qPred = GPred:GetPrediction(unit,myHero,Q,false,true)
		if qPred.HitChance >= 3 then
			myHero:CastSpell(_Q,qPred.CastPosition.x,qPred.CastPosition.z)
		end
		return
	end
	local qPred = GetPrediction(unit,Q)
	if qPred.hitChance > 0.1 and not qPred:mCollision(1) then
		myHero:CastSpell(_Q,qPred.castPos.x,qPred.castPos.z)
	end
end

function Braum:CastR()
	local target = self:GetTarget(R.range)
	if ValidTarget(target,R.range) then
		local rPred = GPred:GetPrediction(target,myHero,R)
		if rPred.HitChance>= 3 then
			myHero:CastSpell(_R,rPred.CastPosition.x,rPred.CastPosition.z)
		end
	end
end

function Braum:AutoR()
	if self.Menu.Rset.AutoR:Value() then
		if EnemiesAround(myHero.pos,R.range + 100) >= self.Menu.Rset.Min:Value() then
			local target = self:GetTarget(R.range + 100)
			if not ValidTarget(target,R.range + 100) then return end
			local rPred = GPred:GetPrediction(target,myHero,R,true)
			if rPred.HitChance>= 2 and rPred.MaxHit >= self.Menu.Rset.Min:Value() then
				myHero:CastSpell(_R,rPred.CastPosition.x,rPred.CastPosition.z)
			end
		end
		
		for _,enemy in pairs(GetEnemyHeroes()) do
			if R.ready and ValidTarget(enemy,R.range) and self.TargetsImmobile[enemy.networkID] and self.TargetsImmobile[enemy.networkID] > GetGameTimer() and self.Menu.Rset.SmartR:Value() and enemy.health/enemy.maxHealth < 0.22*(AlliesAround(myHero.pos,R.range)+1) then
				myHero:CastSpell(_R,enemy.x,enemy.z)
			end
		end
	end
end

function Braum:AutoCC()
	for _,enemy in pairs(GetEnemyHeroes()) do
		if Q.ready and ValidTarget(enemy,Q.range) and self.TargetsImmobile[enemy.networkID] and self.TargetsImmobile[enemy.networkID] > GetGameTimer() and self.Menu.Qset.Immobile:Value() then
			self:CastQ(enemy)
		end
		
	end
end

function Braum:Draw()
	if myHero.dead then return end

	if self.Menu.Draw.Q:Value() then
		local qcolor = Q.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,Q.range,1,qcolor,20)
	end
	if self.Menu.Draw.W:Value() then
		local wcolor = W.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,W.range,1,wcolor,20)
	end
	if self.Menu.Draw.R:Value() then
		local rcolor = R.ready and  ARGB(240,30,144,255) or ARGB(240,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,R.range,1,rcolor,20)
	end
end

function Braum:WndMsg(msg,key)
	if msg == 513 then
		local minD = math.huge
		local starget = nil
		for i, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				if GetDistance(enemy, GetMousePos()) <= minD or starget == nil then
					minD = GetDistance(enemy, GetMousePos())
					starget = enemy
				end
			end
		end
		
		if starget and minD < 200 then
			if self.SelectedTarget and starget.charName == self.SelectedTarget.charName then
				self.SelectedTarget = nil
				PrintChat("<font color=\"#FF0000\">Deselected target: "..starget.charName.."</font>")
			else
				self.SelectedTarget = starget
				PrintChat("<font color=\"#ff8c00\">New target selected: "..starget.charName.."</font>")
			end
		end
	
	end

end

class "Volibear"


function Volibear:__init()
	Q = {ready = false, range = 950, radius = 70, speed = 1700, delay = 0.25, type = "line",mana = 40}
	W = {ready = false, range = 400,mana = 35 }
	E = {ready = false, range = 425,mana = 80 }
	R = {ready = false,range = 500, mana = 100}
	
	self.lastTick = 0
	self.OverKill = 0
	self.SelectedTarget = nil
	self.RootBuff = nil
	self.LastTarget = nil
	self.PassiveT = 0
	self:LoadMenu()
	Callback.Add("UpdateBuff", function(u,s) self:UpdateBuff(u,s) end)
	Callback.Add("RemoveBuff", function(u,s) self:RemoveBuff(u,s) end)
	Callback.Add("ProcessSpell",function(u,s) self:ProcessSpell(u,s) end)
	Callback.Add("ProcessSpellAttack",function(u,s) self:ProcessSpellAttack(u,s) end)
	--Callback.Add("CreateObj",function(o) self:CreateObj(o) end)
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Draw",function() self:Draw() end)
	Callback.Add("WndMsg",function(Msg, Key) self:WndMsg(Msg, Key) end)
end

function Volibear:LoadMenu()
	self.Menu = Menu("SB"..myHero.charName, "VoliGod")
	self.Menu:SubMenu("Key", "> Key Settings")
	self.Menu.Key:KeyBinding("Combo","Combo",32)
	self.Menu.Key:KeyBinding("Harass","Harass",string.byte("C"))
	self.Menu.Key:KeyBinding("LaneClear","Lane Clear",string.byte("V"))
	
	self.Menu.Key:KeyBinding("JungleClear","Jungle Clear",string.byte("V"))
	self.Menu.Key:KeyBinding("Flee","Flee",string.byte("T"))
	
	self.Menu:SubMenu("Qset", "> Q Settings")
	self.Menu.Qset:Boolean("Combo","Use in Combo", true)
	self.Menu.Qset:Boolean("Harass","Use in Harass", true)
	
	self.Menu.Qset:Boolean("JungleClear","Use in JungleClear", true)
	

	self.Menu:SubMenu("Wset", "> W Settings")
	self.Menu.Wset:Boolean("Combo","Use in Combo", true)
	self.Menu.Wset:Boolean("Harass","Use in Harass", false)
	self.Menu.Wset:Slider("HP","Target's HP % < ", 85,1,100)
	self.Menu.Wset:Boolean("LaneClear","Use in LaneClear", true)
	self.Menu.Wset:Boolean("JungleClear","Use in JungleClear", true)
	
	self.Menu:SubMenu("Eset", "> E Settings")
	self.Menu.Eset:Boolean("Combo","Use in Combo", true)
	self.Menu.Eset:Boolean("Harass","Use in Harass", true)
	self.Menu.Eset:Slider("nEnemies","Min Enemies Around",1,1,5)
	self.Menu.Eset:Boolean("LaneClear","Use in LaneClear", true)
	
	self.Menu.Eset:Slider("Minions","Min Minions Around",3,1,5)
	self.Menu.Eset:Boolean("JungleClear","Use in JungleClear", true)
	
	
	
	self.Menu:SubMenu("Rset", "> R Settings")
	self.Menu.Rset:Boolean("Combo","Use in Combo", true)
	--self.Menu.Rset:Boolean("LaneClear","Use in LaneClear", true)
	--self.Menu.Rset:Boolean("JungleClear","Use in JungleClear", true)
	
	--self.Menu.Rset:Boolean("Interrupt","Interrupt Enemy Spells", true)
	
	self.Menu:SubMenu("Mana", "> Mana Settings")
	self.Menu.Mana:Slider("Harass","Harass (%)",60,1,100)
	self.Menu.Mana:Slider("LaneClear","LaneClear (%)",30,1,100)
	--self.Menu:SubMenu("AG", "> AntiGapcloser")
	--AddGapcloseEvent(_E,E.range,true,self.Menu.AG)
	
	self.Menu:SubMenu("KS", "> KillSteal Settings")
	self.Menu.KS:Boolean("E","Use E",true)
	self.Menu.KS:Boolean("W","Use W",true)
	
		self.Menu:SubMenu("Draw", "> Draw Settings")
	self.Menu.Draw:Boolean("R","Draw R Range", true)
	self.Menu.Draw:Boolean("W","Draw W Range", true)
	self.Menu.Draw:Boolean("E","Draw E Range", true)
	self.Menu.Draw:Boolean("Passive","Draw Passive Timer", true)
	
	PrintChat("Support Series:"..myHero.charName.." Loaded")

end

function Volibear:Check()
	Q.ready = myHero:GetSpellData(_Q).level > 0 and myHero:CanUseSpell(_Q) == READY and true or false
	W.ready = myHero:GetSpellData(_W).level > 0 and myHero:CanUseSpell(_W) == READY and true or false
	E.ready = myHero:GetSpellData(_E).level > 0 and myHero:CanUseSpell(_E) == READY and true or false
	R.ready = myHero:GetSpellData(_R).level > 0 and myHero:CanUseSpell(_R) == READY and true or false
end

function Volibear:GetTarget()
	if self.SelectedTarget then
		--return self.SelectedTarget
	end	
	return GetCurrentTarget()
end

function Volibear:ProcessSpellAttack(unit,spell)
	if unit.isMe and spell.target then
		self.LastTarget = spell.target
	end
end

function Volibear:ProcessSpell(unit,spell)
	if unit and unit.team ~= myHero.team and unit.type == "obj_AI_Turret" and spell.target == myHero then
		if Q.ready and myHero.health/myHero.maxHealth < 0.3 then
			myHero:CastSpell(_Q)
		end
	end

end

function Volibear:UpdateBuff(unit,buff)
	if unit.isMe and buff.Name == "VolibearPassiveCD" then
		self.PassiveT = GetGameTimer() + 6
	end
	
end

function Volibear:RemoveBuff(unit,buff)
	if unit.isMe and buff.Name == "VolibearPassiveCD" then
		self.PassiveT = 0
	end
	
end


function Volibear:Tick()

	self:Check()
	if self.SelectedTarget and self.SelectedTarget.dead then 
		self.SelectedTarget = nil
	end
	--self:
	--if self.Menu.KS.W:Value() and W.ready then
		self:KillSteal()
	--end


	if self.Menu.Key.Combo:Value() then
		self:Combo()
	end
	if self.Menu.Key.Harass:Value() then
		self:Harass()
	end
	if self.Menu.Key.LaneClear:Value() then
		self:LaneClear()
	end
	if self.Menu.Key.JungleClear:Value() then
		self:JungleClear()
	end
	if self.Menu.Key.Flee:Value() then
		self:Flee()
	end
end


function Volibear:Combo()
	
	local target = self:GetTarget()
	if ValidTarget(target) then
		self:UseItems(target)
	end
	if Q.ready and self.Menu.Qset.Combo:Value() and ValidTarget(target) and GetDistance(target) > myHero.range + myHero.boundingRadius + 35 and GetDistance(target) < myHero.range + myHero.boundingRadius + 4*(myHero.ms*(1+(40+5*myHero:GetSpellData(_Q).level)/100) - target.ms) then
		myHero:CastSpell(_Q)
	end
	if Q.read and self.Menu.Qset.Combo:Value() and ValidTarget(target,myHero.range + myHero.boundingRadius) and myHero:CalcDamage(target,myHero.totalDamage) *3.5 > target.health then
		myHero:CastSpell(_Q)--resetAA
	end
	if W.ready and self.Menu.Wset.Combo:Value() and ValidTarget(target,W.range) and target.health/target.maxHealth < self.Menu.Wset.HP:Value()/100 then
		myHero:CastSpell(_W,target)
	end
	if E.ready and self.Menu.Eset.Combo:Value() and ValidTarget(target,E.range) then
		myHero:CastSpell(_E)
	end
	if R.ready and ValidTarget(target,myHero.range + myHero.boundingRadius) and self:CheckOverKill(target) < target.health and (self:CheckOverKill(target) + getdmg("R",target,myHero) > target.health or myHero.health/myHero.maxHealth < 0.35) then
		myHero:CastSpell(_R)
	end
end

function Volibear:UseItems(target)
	local randuin = GetItemSlot(myHero,3143)
	if randuin > 0 and myHero:CanUseSpell(randuin) == READY and GetDistance(target) < 450 then
		myHero:CastSpell(randuin)
	end
		local hydra = GetItemSlot(myHero,3074)
	if hydra > 0 and myHero:CanUseSpell(hydra) == READY and GetDistance(target) < 400 then
		myHero:CastSpell(hydra)
	end

	local tiamat = GetItemSlot(myHero,3748)
	if tiamat > 0 and myHero:CanUseSpell(tiamat) == READY and GetDistance(target) < 400 then
		myHero:CastSpell(tiamat)
	end

end

function Volibear:KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if W.ready and ValidTarget(enemy,W.range) and getdmg("W",enemy,myHero) > enemy.health and GetGameTimer() - self.OverKill > 1 then
			myHero:CastSpell(_W,enemy)
			self.OverKill = GetGameTimer()
		end
		if E.ready and ValidTarget(enemy,E.range) and getdmg("E",enemy,myHero) > enemy.health and GetGameTimer() - self.OverKill > 1 then
			myHero:CastSpell(_E)
			self.OverKill = GetGameTimer()
		end
	end
end

function Volibear:Harass()
	if myHero.mana/myHero.maxMana < self.Menu.Mana.Harass:Value()/100 then return end
	local target = self:GetTarget()
	
	if W.ready and self.Menu.Wset.Harass:Value() and ValidTarget(target,W.range) and target.health/target.maxHealth < self.Menu.Wset.HP:Value()/100 then
		myHero:CastSpell(_W,target)
	end
	if E.ready and self.Menu.Eset.Harass:Value() and ValidTarget(target,E.range) then
		myHero:CastSpell(_E)
	end
	self:LastHit()
end

function Volibear:LastHit()
	for i,minion in pairs(minionManager.objects) do
		if ValidTarget(minion) and minion.team == 300- myHero.team then
			if E.ready and GetDistance(minion) < E.range and getdmg("E",minion,myHero) > minion.health and (minion.health > myHero.totalDamage or (not self.LastTarget or self.LastTarget.valid and self.LastTarget.networkID ~= minion.networkID)) then
				myHero:CastSpell(_E)
			end			
			if W.ready and GetDistance(minion) < W.range and getdmg("W",minion,myHero) > minion.health and (minion.health > myHero.totalDamage or (not self.LastTarget or self.LastTarget.valid and self.LastTarget.networkID ~= minion.networkID)) then
				myHero:CastSpell(_W,minion)
			end
		end
	end
end

function Volibear:LaneClear()
	self:LastHit()
	if myHero.mana/myHero.maxMana < self.Menu.Mana.LaneClear:Value()/100 then return end
	if E.ready and self.Menu.Eset.LaneClear:Value() and MinionsAround(myHero.pos,E.range+50) >= self.Menu.Eset.Minions:Value() then
		myHero:CastSpell(_E)
	end
	if W.ready and self.Menu.Wset.LaneClear:Value()  and self.LastTarget and ValidTarget(self.LastTarget,W.range) and self.LastTarget.type == "obj_AI_Minion" and getdmg("W",minion,myHero) + 20 < minion.health then
		myHero:CastSpell(_W,minion)
	end
end

function Volibear:JungleClear()
	local mobs = {}
	for _,mob in pairs(minionManager.objects) do
		if mob and not mob.dead and mob.team == 300 and ValidTarget(mob,E.range) then
			table.insert(mobs,mob)
		end
	end
	if #mobs < 1 then return end
	table.sort(mobs,function(a,b) return a.maxHealth > b.maxHealth end)
	local mob = mobs[1]
	if ValidTarget(mob) then
		

		if W.ready and GetDistance(mob) < W.range and self.Menu.Wset.JungleClear:Value() then
			myHero:CastSpell(_W,mob)
		end
		if E.ready and self.Menu.Eset.JungleClear:Value() and GetDistance(mob) < W.range  then
			myHero:CastSpell(_E)	
		end
		if Q.ready and GetDistance(mob) < myHero.range and self.Menu.Qset.JungleClear:Value() and myHero.mana > W.mana + E.mana then
			
			myHero:CastSpell(_Q)
		end
	end
	
end

function Volibear:Flee()
	if GetTickCount() > self.lastTick then
		myHero:Move(GetMousePos().x,GetMousePos().z)
		self.lastTick = GetTickCount() + 200
	end
	if Q.ready then myHero:CastSpell(_Q) end
	if E.ready and EnemiesAround(myHero.pos,E.range) > 0 then
		myHero:CastSpell(_E)
	end
end

function Volibear:CheckOverKill(target)
	local dmg = 0
	if Q.ready then
		dmg = dmg + getdmg("Q",target,myHero)
	end
	if W.ready then
		dmg = dmg + getdmg("W",target,myHero)
	end
	if E.ready then
		dmg = dmg + getdmg("E",target,myHero)
	end
	dmg = dmg + myHero:CalcDamage(target,3*myHero.totalDamage)
	return dmg
end

function Volibear:Draw()
	if myHero.dead then return end
	if self.Menu.Draw.Passive:Value() and self.PassiveT > 0 then
		local dif = self.PassiveT - GetGameTimer()
		DrawText3D(tostring(string.format("%.1f", math.max(0,dif))), myHero.x, myHero.y, myHero.z, 30, ARGB(150, 255, 255, 255), true)	
		
		
	end
	if self.Menu.Draw.R:Value() then
		local qcolor = R.ready and  ARGB(100,30,144,255) or ARGB(100,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,R.range,1,qcolor,20)
	end
	if self.Menu.Draw.W:Value() then
		local wcolor = W.ready and  ARGB(100,30,144,255) or ARGB(100,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,W.range,1,wcolor,20)
	end
	if self.Menu.Draw.E:Value() then
		local ecolor = E.ready and  ARGB(100,30,144,255) or ARGB(100,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,E.range,1,ecolor,20)
	end
end

function Volibear:WndMsg(msg,key)
	if msg == 513 then
		local minD = math.huge
		local starget = nil
		for i, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				if GetDistance(enemy, GetMousePos()) <= minD or starget == nil then
					minD = GetDistance(enemy, GetMousePos())
					starget = enemy
				end
			end
		end
		
		if starget and minD < 200 then
			if self.SelectedTarget and starget.charName == self.SelectedTarget.charName then
				self.SelectedTarget = nil
				PrintChat("<font color=\"#FF0000\">Deselected target: "..starget.charName.."</font>")
			else
				self.SelectedTarget = starget
				PrintChat("<font color=\"#ff8c00\">New target selected: "..starget.charName.."</font>")
			end
		end
	
	end

end

class "Blitzcrank"

function Blitzcrank:__init()
	Q = {ready = false, range = 925, attemptT = 0, radius = 70 , speed = 1800, delay = 0.25, type = "line", col = {"minion","champion"},mana = 100}
	W = {ready = false, mana = 75  }
	E = {ready = false, range = 300,mana = 25 }
	R = {ready = false, range = 600, radius = 600, speed = math.huge, delay = 0.25, type = "circular",mana = 100}
	self.rekt = 0
	self.CanCount = false
	self.total = 0
	self.ready = function(x) return myHero:CanUseSpell(x) == READY  end
	self.pos = nil
	self:LoadMenu()
	Callback.Add("UpdateBuff", function(u,s) self:UpdateBuff(u,s) end)
	--Callback.Add("RemoveBuff", function(u,s) self:RemoveBuff(u,s) end)
	--Callback.Add("ProcessSpell",function(u,s) self:ProcessSpell(u,s) end)
	Callback.Add("ProcessSpellComplete",function(u,s) self:ProcessSpell(u,s) end)
	
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Draw",function() self:Draw() end)
	
end

function Blitzcrank:Check()
	Q.ready = myHero:GetSpellData(_Q).level > 0 and myHero:CanUseSpell(_Q) == READY and true or false
	W.ready = myHero:GetSpellData(_W).level > 0 and myHero:CanUseSpell(_W) == READY and true or false
	E.ready = myHero:GetSpellData(_E).level > 0 and myHero:CanUseSpell(_E) == READY and true or false
	R.ready = myHero:GetSpellData(_R).level > 0 and myHero:CanUseSpell(_R) == READY and true or false
end

function Blitzcrank:LoadMenu()
	self.Menu = Menu("SB"..myHero.charName, "SupportBundle: Blitzcrank")
	
	self.Menu:SubMenu("Gset","> Grab Settings")
	self.Menu.Gset:Boolean("Dash","AutoGrab Dashing Target",true)
	self.Menu.Gset:Slider("Min","Min Distance",300,100,Q.range)
	self.Menu.Gset:Slider("Max","Max Distance",Q.range,100,Q.range)
	
	self.Menu:SubMenu("Tset","> Extra Target Settings")
	for i,enemy in pairs(GetEnemyHeroes()) do
		self.Menu.Tset:DropDown(enemy.charName,enemy.charName,2,{"Don't Grab","Normal Grab","Auto Grab"})
	end
	self.Menu:SubMenu("Rset","> Auto R Settings")
	self.Menu.Rset:Boolean("KS","KillSteal",true)
	self.Menu.Rset:Slider("Min","x enemies around",2,1,5,1)
	
	self.Menu:SubMenu("Draw","> Draw Settings")
	self.Menu.Draw:Boolean("Q","Draw Q Range",true)
	self.Menu.Draw:Boolean("Stat","Show My Stats",true)
	self.Menu.Draw:Boolean("Pos","Draw Predicted Pos",false)
	
	self.Menu:Info("nil","       --[Key Settings]--      ")
	self.Menu:KeyBinding("Active","Combo ",32)
	self.Menu:KeyBinding("Grab","Grab Them All !!!",string.byte("C"))
end

function Blitzcrank:UpdateBuff(unit,buff)

	if unit.isMe and buff.Type == 10 and W.ready then
		CastSpell(_W)
	end
	if unit.team ~= myHero.team and unit.type == myHero.type and buff.Name:lower() == "rocketgrab2" and self.CanCount then
		self.rekt = self.rekt + 1
	end	
	if unit.team ~= myHero.team and unit.type == myHero.type and buff.Name:lower() == "powerfistslow" then
		DelayAction(function() 
			if R.ready then CastSpell(_R) end
		end,0.25)
		return
	end

end

function Blitzcrank:ProcessSpell(unit,spell)
	if unit.isMe and self.CanCount and spell.name == "RocketGrab" then
		self.total = self.total + 1
	end
end

function Blitzcrank:Tick()
	if myHero.dead then return end
	self:Check()
	if R.ready then
		self:AutoR()
	end
	if Q.ready then
		self:AutoQ()
	else	
		if self.CanCount and myHero:GetSpellData(_Q).currentCd < 8 then
			self.CanCount = false
		end
	end
	if self.Menu.Active:Value() then
		self:CastQ()
		self:CastE()
	end
	if self.Menu.Grab:Value() then
		self:CastQ(true)
	end
	
end

function Blitzcrank:AutoQ()
	for i,enemy in ipairs(GetEnemyHeroes()) do
		if ValidTarget(enemy,1500) then
			if self.Menu.Tset[enemy.charName]:Value() == 3 then
				self:CastQ2(enemy)
			end
			self:CastQ2(enemy,4)
		end
	end
end

function Blitzcrank:CastQ(ignore)
	if not Q.ready then return end
	local t = heroCache:GetTarget(Q.range,DAMAGE_PHYSIC)
	if t and (ignore or (GetDistance(t) > self.Menu.Gset.Min:Value() and self.Menu.Tset[t.charName]:Value() > 1)) then
		self:CastQ2(t)
	end
end

function Blitzcrank:CastQ2(target,minHit)
	
		local qPred = gPred:GetPrediction(target,myHero,Q,false,true)
		self.pos = qPred.CastPosition
		if (minHit and qPred.HitChance == minHit ) or (not minHit and qPred.HitChance >= 3) then
			self.CanCount = true
			CastSkillShot(_Q,qPred.CastPosition)
		end
end

function Blitzcrank:CastE()
	if not E.ready then return end
	if not GoSWalk:CanMove(40) then return end
	local cane = false
	for i,enemy in ipairs(GetEnemyHeroes())do
		if ValidTarget(enemy,E.range) then
			cane = true
			break
		end
	end
	if cane then CastSpell(_E) end
end

function Blitzcrank:AutoR()
	--ks
	for i,enemy in ipairs(GetEnemyHeroes()) do
		if ValidTarget(enemy,590) and getdmg("R",enemy,myHero) > enemy.health and self.Menu.Rset.KS:Value() and AlliesAround(enemy.pos,500) < 1 then
			CastSpell(_R)		
		end
	end
	if EnemiesAround(myHero.pos,600) >= self.Menu.Rset.Min:Value() then
		CastSpell(_R)		
	end	
end

function Blitzcrank:Draw()
	if self.Menu.Draw.Stat:Value() then
		DrawText("Grab Stats: "..self.rekt.."/"..self.total,20,WINDOW_W/2,30,GoS.White)
		
	end
	if self.Menu.Draw.Q:Value() then
		local qcolor = Q.ready and  ARGB(222,30,144,255) or ARGB(222,255,0,0)
		DrawCircle3D(myHero.x,myHero.y,myHero.z,Q.range,1,qcolor,20)
	end
	if self.Menu.Draw.Pos:Value() and self.pos then
		DrawCircle3D(self.pos.x,self.pos.y,self.pos.z,65,2,ARGB(222,20,90,255),20)
	end
end


DelayAction(function()
_G[myHero.charName]()
end,0.5)

if AutoUpdateScript then
AutoUpdateScript("Support Bundle",ver,"raw.githubusercontent.com","/KeVuong/GoS/master/Support.version","/KeVuong/GoS/master/Support%20Bundle.lua", SCRIPT_PATH.."Support Bundle.lua")
end
