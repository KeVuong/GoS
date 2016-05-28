if myHero.charName ~= "Janna" then return end

local ver = "20170528000"

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat("New version found! " .. data)
        PrintChat("Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/KeVuong/GoS/master/Janna - The Storm's Fury.lua", SCRIPT_PATH .. "Janna - The Storm's Fury.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
    else
        PrintChat("No updates found. Janna - The Storm's Fury  v" .. ver .. " Loaded!")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/KeVuong/GoS/master/Support.version", AutoUpdate)


local GPred = nil
if  FileExist(COMMON_PATH.."\\GPrediction.lua") then
	require "GPrediction"
	GPred = GPrediction()
else	
	require "OpenPredict"
end
require "DamageLib"

local InterruptSpells = {}  
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
	
end

function Janna:LoadMenu()
	self.Menu = Menu( "SB"..myHero.charName, "Janna - The Storm's Fury")
	
	self.Menu:SubMenu("Key", "> Key Settings")
	self.Menu.Key:KeyBinding("Combo","Combo",32)
	self.Menu.Key:KeyBinding("Harass","Harass",string.byte("C"))
	
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
	self.Menu.Eset:Boolean("Spell","Shield Ally", true)
	
	self.Menu:SubMenu("Rset", "> R Settings")
	self.Menu.Rset:Boolean("Heal","Heal Ally", true)
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
	if unit ~= myHero and unit.team == myHero.team and GetDistance(unit) < Spells[_E].range and spell.name:lower():find("attack") and spell.target and spell.target.type == myHero.type then
		if self.Menu.Eset.Combo:Value() and Spells[_E].ready then 
			myHero:CastSpell(_E,spell.target)
		end
	end
end

function Janna:GetBestTarget()
	return	GetCurrentTarget()
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
		if qPred and qPred.HitChance >= 2 then
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
	
	self:KillSteal()
	if Spells[_R].ready and self.Menu.Rset.Heal:Value() then
		self:HealAlly()
	end

	if self.Menu.Key.Combo:Value() then
		self:Combo()
	end
	if self.Menu.Key.Harass:Value() then
		self:Harass()
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
		if not ally.dead and GetDistance(ally) < Spells[_R].range - 150 and GetPercentHP(ally) < 15 and EnemiesAround(ally.pos,500) >= 1 then
			myHero:CastSpell(_R)
		end
	end
	if GetPercentHP(myHero) < 15 and EnemiesAround(myHero.pos,300) >= 1 then
		myHero:CastSpell(_R)
	end
end



function Janna:Draw()
	
	if myHero.dead then return end
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

Janna()
