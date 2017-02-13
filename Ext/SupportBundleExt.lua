local myHeroes = { Morgana = true, Janna = true, Nami = true, Soraka = true}

if not myHeroes[myHero.charName] then return end

require "DamageLib"

class "_AutoInterrupter"
function _AutoInterrupter:__init()
	self.Spells = {
		["Fiddlesticks"] = {{Key = _W, Duration = 5, KeyName = "W" },{Key = _R,Duration = 1,KeyName = "R"  }},
		["VelKoz"] = {{Key = _R, Duration = 1, KeyName = "R", Buff = "VelkozR" }},
		["Warwick"] = {{Key = _R, Duration = 1,KeyName = "R" , Buff = "warwickrsound"}},
		["MasterYi"] = {{Key = _W, Duration = 4,KeyName = "W", Buff = "Meditate" }},
		["Lux"] = {{Key = _R, Duration = 1,KeyName = "R" }},
		["Janna"] = {{Key = _R, Duration = 3,KeyName = "R",Buff = "ReapTheWhirlwind" }},
		["Jhin"] = {{Key = _R, Duration = 1,KeyName = "R" }},
		["Xerath"] = {{Key = _R, Duration = 3,KeyName = "R", SpellName = "XerathRMissileWrapper" }},
		["Karthus"] = {{Key = _R, Duration = 3,KeyName = "R", Buff = "karthusfallenonecastsound" }},
		["Ezreal"] = {{Key = _R, Duration = 1,KeyName = "R" }},
		["Galio"] = {{Key = _R, Duration = 2,KeyName = "R", Buff = "GalioIdolOfDurand" }},
		["Caitlyn"] = {{Key = _R, Duration = 2,KeyName = "R" , Buff = "CaitlynAceintheHole"}},
		["Malzahar"] = {{Key = _R, Duration = 2,KeyName = "R" }},
		["MissFortune"] = {{Key = _R, Duration = 2,KeyName = "R", Buff = "missfortunebulletsound" }},
		["Nunu"] = {{Key = _R, Duration = 2,KeyName = "R", Buff = "AbsoluteZero"  }},
		["TwistedFate"] = {{Key = _R, Duration = 2,KeyName = "R",Buff = "Destiny" }},
		["Shen"] = {{Key = _R, Duration = 2,KeyName = "R",Buff = "shenstandunitedlock" }},
	}
end

function _AutoInterrupter:IsChannelling(unit)
	if not self.Spells[unit.charName] then return false end
	local result = false
	for _, spell in pairs(self.Spells[unit.charName]) do
		if unit:GetSpellData(spell.Key).level > 0 and (unit:GetSpellData(spell.Key).name == spell.SpellName or unit:GetSpellData(spell.Key).currentCd > unit:GetSpellData(spell.Key).cd - spell.Duration or (spell.Buff and self:GotBuff(unit,spell.Buff) > 0)) then
				result = true
				break
			
		end
	end
	return result
end

function _AutoInterrupter:GotBuff(unit,name)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff.name and buff.name:lower() == name:lower() and buff.count > 0 then 
			return buff.count
		end
	end
	return 0
end

AutoInterrupter = AutoInterrupter or _AutoInterrupter()



local MissileSpells = {
["Sion"] = {"SionEMissile"},
["Velkoz"] = {"VelkozQMissile","VelkozQMissileSplit","VelkozWMissile","VelkozEMissile"},
["Ahri"] = {"AhriOrbMissile","AhriOrbReturn","AhriSeduceMissile"},
["Irelia"] = {"IreliaTranscendentBlades"},
["Sona"] = {"SonaR"},
["Illaoi"] = {"illaoiemis","illaoiemis",""},
["Jhin"] = {"JhinWMissile","JhinRShotMis"},
["Rengar"] = {"RengarEFinal"},
["Zyra"] = {"ZyraQ","ZyraE","zyrapassivedeathmanager"},
["TwistedFate"] = {"SealFateMissile"},
["Shen"] = {"ShenE"},
["Kennen"] = {"KennenShurikenHurlMissile1"},
["Nami"] = {"namiqmissile","NamiRMissile"},
["Xerath"] = {"xeratharcanopulse2","XerathArcaneBarrage2","XerathMageSpearMissile","xerathrmissilewrapper"},
["Nocturne"] = {"NocturneDuskbringer"},
["AurelionSol"] = {"AurelionSolQMissile","AurelionSolRBeamMissile"},
["Lucian"] = {"LucianQ","LucianWMissile","lucianrmissileoffhand"},
["Ivern"] = {"IvernQ"},
["Tristana"] = {"RocketJump"},
["Viktor"] = {"ViktorDeathRayMissile"},
["Malzahar"] = {"MalzaharQ"},
["Braum"] = {"BraumQMissile","braumrmissile"},
["Tryndamere"] = {"slashCast"},
["Malphite"] = {"UFSlash"},
["Amumu"] = {"SadMummyBandageToss",""},
["Janna"] = {"HowlingGaleSpell"},
["Morgana"] = {"DarkBindingMissile"},
["Ezreal"] = {"EzrealMysticShotMissile","EzrealEssenceFluxMissile","EzrealTrueshotBarrage"},
["Kalista"] = {"kalistamysticshotmis"},
["Blitzcrank"] = {"RocketGrabMissile",},
["Chogath"] = {"Rupture"},
["TahmKench"] = {"tahmkenchqmissile"},
["LeeSin"] = {"BlindMonkQOne"},
["Zilean"] = {"ZileanQMissile"},
["Darius"] = {"DariusCleave","DariusAxeGrabCone"},
["Ziggs"] = {"ZiggsQSpell","ZiggsQSpell2","ZiggsQSpell3","ZiggsW","ZiggsE","ZiggsR"},
["Zed"] = {"ZedQMissile"},
["Leblanc"] = {"LeblancSlide","LeblancSlideM","LeblancSoulShackle","LeblancSoulShackleM"},
["Zac"] = {"ZacQ"},
["Quinn"] = {"QuinnQ"},
["Urgot"] = {"UrgotHeatseekingLineMissile","UrgotPlasmaGrenadeBoom"},
["Cassiopeia"] = {"CassiopeiaQ","CassiopeiaR"},
["Sejuani"] = {"sejuaniglacialprison"},
["Vi"] = {"ViQMissile"},
["Leona"] = {"LeonaZenithBladeMissile","LeonaSolarFlare"},
["Veigar"] = {"VeigarBalefulStrikeMis"},
["Varus"] = {"VarusQMissile","VarusE","VarusRMissile"},
["Aatrox"] = {"","AatroxEConeMissile"},
["Twitch"] = {"TwitchVenomCaskMissile"},
["Thresh"] = {"ThreshQMissile","ThreshEMissile1"},
["Diana"] = {"DianaArcThrow"},
["Draven"] = {"DravenDoubleShotMissile","DravenR"},
["Talon"] = {"talonrakemissileone","talonrakemissiletwo"},
["JarvanIV"] = {"JarvanIVDemacianStandard"},
["Gragas"] = {"GragasQMissile","GragasE","GragasRBoom"},
["Lissandra"] = {"LissandraQMissile","lissandraqshards","LissandraEMissile"},
["Swain"] = {"SwainShadowGrasp"},
["Lux"] = {"LuxLightBindingMis","LuxLightStrikeKugel","LuxMaliceCannon"},
["Gnar"] = {"gnarqmissile","GnarQMissileReturn","GnarBigQMissile","GnarBigW","GnarE","GnarBigE",""},
["Bard"] = {"BardQMissile","BardR"},
["Riven"] = {"RivenLightsaberMissile"},
["Anivia"] = {"FlashFrostSpell"},
["Karma"] = {"KarmaQMissile","KarmaQMissileMantra"},
["Jayce"] = {"JayceShockBlastMis","JayceShockBlastWallMis"},
["RekSai"] = {"RekSaiQBurrowedMis"},
["Evelynn"] = {"EvelynnR"},
["Sivir"] = {"SivirQMissileReturn","SivirQMissile"},
["Shyvana"] = {"ShyvanaFireballMissile","ShyvanaTransformCast","ShyvanaFireballDragonFxMissile"},
["Yasuo"] = {"yasuoq2","yasuoq3w","yasuoq"},
["Corki"] = {"PhosphorusBombMissile","MissileBarrageMissile","MissileBarrageMissile2"},
["Ryze"] = {"RyzeQ"},
["Rumble"] = {"RumbleGrenade","RumbleCarpetBombMissile"},
["Syndra"] = {"SyndraQ","syndrawcast","syndrae5","SyndraE"},
["Khazix"] = {"KhazixWMissile","KhazixE"},
["Taric"] = {"TaricE"},
["Elise"] = {"EliseHumanE"},
["Nidalee"] = {"JavelinToss"},
["Olaf"] = {"olafaxethrow"},
["Nautilus"] = {"NautilusAnchorDragMissile"},
["Kled"] = {"KledQMissile","KledRiderQMissile"},
["Brand"] = {"BrandQMissile"},
["Ekko"] = {"ekkoqmis","EkkoW","EkkoR"},
["Fiora"] = {"FioraWMissile"},
["Graves"] = {"GravesQLineMis","GravesChargeShotShot"},
["Galio"] = {"GalioResoluteSmite","GalioRighteousGust",""},
["Ashe"] = {"VolleyAttack","EnchantedCrystalArrow"},
["Kogmaw"] = {"KogMawQ","KogMawVoidOozeMissile","KogMawLivingArtillery"},
["Skarner"] = {"SkarnerFractureMissile"},
["Taliyah"] = {"TaliyahQMis","TaliyahW"},
["Heimerdinger"] = {"HeimerdingerWAttack2","heimerdingerespell"},
["Lulu"] = {"LuluQMissile","LuluQMissileTwo"},
["DrMundo"] = {"InfectedCleaverMissile"},
["Poppy"] = {"PoppyQ","PoppyRMissile"},
["Caitlyn"] = {"CaitlynPiltoverPeacemaker","CaitlynEntrapmentMissile"},
["Jinx"] = {"JinxWMissile","JinxR"},
["Fizz"] = {"FizzRMissile"},
["Kassadin"] = {"RiftWalk"},
}

function isReady(slot)
	return Game.CanUseSpell(slot) == READY
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

function CountEnemies(pos,range)
	local N = 0
	for i = 1,Game.HeroCount()  do
		local hero = Game.Hero(i)	
		if isValidTarget(hero,range) and hero.team ~= myHero.team then
			N = N + 1
		end
	end
	return N	
end

function GetUglyTarget(range)
	local result = nil
	local N = math.huge
	for i = 1,Game.HeroCount()  do
		local hero = Game.Hero(i)	
		if isValidTarget(hero,range) and hero.isEnemy then
			local dmgtohero = getdmg("AA",hero,myHero) or 1
			local tokill = hero.health/dmgtohero
			if tokill < N or result == nil then
				N = tokill
				result = hero
			end
		end
	end
	return result
end

function VectorPointProjectionOnLineSegment(v1, v2, v)
    local cx, cy, ax, ay, bx, by = v.x, (v.z or v.y), v1.x, (v1.z or v1.y), v2.x, (v2.z or v2.y)
    local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) ^ 2 + (by - ay) ^ 2)
    local pointLine = { x = ax + rL * (bx - ax), y = ay + rL * (by - ay) }
    local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
    local isOnSegment = rS == rL
    local pointSegment = isOnSegment and pointLine or { x = ax + rS * (bx - ax), y = ay + rS * (by - ay) }
    return pointSegment, pointLine, isOnSegment
end

class "Morgana"

function Morgana:__init()
	Q = {ready = false, range = 1175, radius = 65, speed = 1200, delay = 0.25, type = "line",col = {"minion","champion"}}
	W = {ready = false, range = 900,radius = 225, speed = 2200, delay = 0.5, type = "circular" }
	E = {ready = false, range = 750 }
	R = {ready = false,range = 600}
	self.Enemies = {}
	self.Allies = {}
	for i = 1,Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isAlly then
			table.insert(self.Allies,hero)
		else
			table.insert(self.Enemies,hero)
		end	
	end	
	self.lastTick = 0
	self.SelectedTarget = nil
	self:LoadData()
	self:LoadMenu()
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Tick",function() self:ProcessMissile() end)
	Callback.Add("Draw",function() self:Draw() end)
	Callback.Add("WndMsg",function(Msg, Key) self:WndMsg(Msg, Key) end)
end

function Morgana:LoadMenu()
	self.Menu = MenuElement( {id =  "SB"..myHero.charName, name = "Morgana - The Fallen Angel", type = MENU})
	self.Menu:MenuElement({id = "Key", name = "> Key Settings", type = MENU})
	self.Menu.Key:MenuElement({id = "Combo",name = "Combo", key = 32})
	self.Menu.Key:MenuElement({id = "Harass",name = "Harass", key = string.byte("C")})

	
	self.Menu:MenuElement({type = MENU, id = "Qset", name = "> Q Settings"})
	self.Menu.Qset:MenuElement({id = "Combo",name = "Use in Combo", value = true })
	self.Menu.Qset:MenuElement({id = "Harass", name = "Use in Harass", value = true})
	self.Menu.Qset:MenuElement({id = "Immobile",name = "Auto on Immobile",value = true})

	self.Menu:MenuElement({type = MENU, id = "Wset", name = "> W Settings"})
	self.Menu.Wset:MenuElement({id = "Combo", name = "Use in Combo",value = true})
	self.Menu.Wset:MenuElement({ id = "Harass", name = "Use in Harass",value = true})
	self.Menu.Wset:MenuElement({ id = "Immobile",name = "Auto on Immobile",value = true})
	
	self.Menu:MenuElement({id = "Eset", name = "> E Settings", type = MENU})
	self.Menu.Eset:MenuElement({id = "Spell", name = "Use Against Spells",value = true})
	
	
	self.Menu:MenuElement({id = "Rset", name = "> R Settings",type = MENU})
	self.Menu.Rset:MenuElement({id = "AutoR",name ="AutoR", value = true})
	self.Menu.Rset:MenuElement({id = "Min", name = "x Enemies Around", value =  2, min = 1, max = 5, step =1})
	
	self.Menu:MenuElement({type = MENU, id = "Draw",name = "> Draw Settings"})
	self.Menu.Draw:MenuElement({id = "Q", name = "Draw Q Range", value = true})
	self.Menu.Draw:MenuElement({id = "W", name = "Draw W Range", value = true})
	self.Menu.Draw:MenuElement({id = "E", name = "Draw E Range", value = true})
	self.Menu.Draw:MenuElement({id = "Root",name = "Draw Root Time", value = true})
	
	PrintChat("SupportBundle: "..myHero.charName.." Loaded")

end

function Morgana:LoadData()
	self.MissileSpells = {}
	for i = 1,Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isEnemy then
			if MissileSpells[hero.charName] then
				for k,v in pairs(MissileSpells[hero.charName]) do
					if #v > 1 then
						self.MissileSpells[v] = true
					else
						--print(hero.charName)
					end	
				end
			end
		end
	end
end


function Morgana:GetTarget(range)
	if self.SelectedTarget and isValidTarget(self.SelectedTarget,range) then
		return self.SelectedTarget
	end	
	return GetUglyTarget(range)
end

function Morgana:ProcessMissile()
	if (not isReady(_E) or not self.Menu.Eset.Spell:Value())then return end
	local enemy = true
	local allies = {}
	for i = 1,Game.HeroCount() do
		local hero = Game.Hero(i)
		if isValidTarget(hero,2500) and hero.isAlly then
			table.insert(allies,hero)
		elseif isValidTarget(hero,2500) and hero.isEnemy then
			enemy = false
		end
	end
	if enemy then return end	
	for i = 1, Game.MissileCount() do
		local obj = Game.Missile(i)
		if obj and obj.isEnemy and obj.missileData and self.MissileSpells[obj.missileData.name] then
			local speed = obj.missileData.speed
			local width = obj.missileData.width
			local endPos = obj.missileData.endPos
			local pos = obj.pos
			if speed and width and endPos and pos then
				for k, hero in pairs(allies) do 
					if isValidTarget(hero,E.range) then
						local pointSegment,pointLine,isOnSegment = VectorPointProjectionOnLineSegment(pos,endPos,hero.pos)
						if isOnSegment and hero.pos:DistanceTo(Vector(pointSegment.x,myHero.pos.y,pointSegment.y)) < width+ hero.boundingRadius then
							Control.CastSpell(HK_E,hero)
						end
					end
				end
			elseif pos then
				for k,hero in pairs(allies)	 do
					if isValidTarget(hero,E.range) and pos:DistanceTo(hero.pos) < 80 then
						Control.CastSpell(HK_E,hero)
					end
				end
			end
		end
	end	
end

function Morgana:Tick()
	
	if self.SelectedTarget and self.SelectedTarget.dead then 
		self.SelectedTarget = nil
	end
	--self:
	
	self:AutoCC()
	
	if self.Menu.Key.Combo:Value() then
		self:Combo()
	end
	if self.Menu.Key.Harass:Value() then
		self:Harass()
	end
	if Game.CanUseSpell(_R) == READY then
		self:AutoR()
	end
	
end

function Morgana:CastQ(unit,pos)
	if unit:GetCollision(Q.radius,Q.speed,Q.delay) == 0  then
		pos = pos or unit:GetPrediction(Q.speed,Q.delay)
		if pos then
			Control.CastSpell(HK_Q,pos)
		end
	end
end

function Morgana:CastW(unit)
	local pos = unit:GetPrediction(W.speed,W.delay)
	if pos then
		Control.CastSpell(HK_W,pos)
	end
end

function Morgana:Combo()
	local qtarget = self:GetTarget(Q.range)
	local wtarget = self:GetTarget(W.range)
	
	if qtarget and isReady(_Q) and self.Menu.Qset.Combo:Value() then
		self:CastQ(qtarget)
	end
	if wtarget and isReady(_W) and self.Menu.Wset.Combo:Value() and (not isReady(_Q) or myHero.mana > 200 ) then
		self:CastW(wtarget)
	end
end

function Morgana:Harass()
	local qtarget = self:GetTarget(Q.range)
	local wtarget = self:GetTarget(W.range)
	
	if qtarget and isReady(_Q) and self.Menu.Qset.Harass:Value() then
		self:CastQ(qtarget)
	end
	if wtarget and Game.CanUseSpell(_W) == READY and self.Menu.Wset.Harass:Value() and (not isReady(_Q) or myHero.mana > 200 ) then
		self:CastW(wtarget)
	end
end

function Morgana:AutoR()
	if self.Menu.Rset.AutoR:Value() then
		if CountEnemies(myHero.pos,R.range - 50) >= self.Menu.Rset.Min:Value() then
			Control.CastSpell(HK_R)
		end
	end
end

function Morgana:AutoCC()
	for i = 1, Game.HeroCount() do
		local enemy  = Game.Hero(i)
 
		if enemy.isEnemy and isReady(_Q) and isValidTarget(enemy,Q.range) and IsImmobileTarget(enemy) and self.Menu.Qset.Immobile:Value() then
			self:CastQ(enemy,enemy.pos)
			return
		end
		if enemy.isEnemy and isReady(_W) and isValidTarget(enemy,W.range) and IsImmobileTarget(enemy) and self.Menu.Wset.Immobile:Value() then
			Control.CastSpell(HK_W,enemy.pos)
			return
		end
	end
end

function Morgana:Draw()
	if myHero.dead then return end

	if self.Menu.Draw.Q:Value() then
		local qcolor = isReady(_Q) and  Draw.Color(189, 183, 107, 255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),Q.range,1,qcolor)
	end
	if self.Menu.Draw.W:Value() then
		local wcolor = isReady(_W) and  Draw.Color(240,30,144,255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),W.range,1,wcolor)
	end
	if self.Menu.Draw.E:Value() then
		local ecolor = isReady(_E) and  Draw.Color(233, 150, 122, 255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),E.range,1,ecolor)
	end
	if self.Menu.Draw.Root:Value() then
	
	end
end

function Morgana:WndMsg(msg,key)
	if msg == 513 then
		local starget = nil
		for i  = 1,Game.HeroCount(i) do
			local enemy = Game.Hero(i)
			if isValidTarget(enemy) and enemy.isEnemy and enemy.pos:DistanceTo(mousePos) < 200 then
				starget = enemy
				break
			end
		end
		if starget then
			self.SelectedTarget = starget
			print("New target selected: "..starget.charName)
		else
			self.SelectedTarget = nil
		end
	end	
end


--[[Janna]]


class "Janna"

function Janna:__init()
	Q = {ready = false, range = 850,maxrange = 1700, radius = 120 , speed = 900, delay = 0.25, type = "line"}
	W = {ready = false, range = 600,radius = 225, speed = 2200, delay = 0.5, type = "circular" }
	E = {ready = false, range = 800 }
	R = {ready = false,range = 725}
	self.Enemies = {}
	self.Allies = {}
	for i = 1,Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isAlly then
			self.Allies[hero.handle] = hero
		else
			self.Enemies[hero.handle] = hero
		end	
	end	
	self.lastTick = 0
	self.LastSpellT = 0
	self.SelectedTarget = nil
	self:LoadData()
	self:LoadMenu()
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Tick",function() self:ProcessMissile() end)
	Callback.Add("Draw",function() self:Draw() end)
	Callback.Add("WndMsg",function(Msg, Key) self:WndMsg(Msg, Key) end)
end

function Janna:LoadMenu()
	self.Menu = MenuElement( {id =  "SB"..myHero.charName, name = "Victorious Janna", type = MENU})
	self.Menu:MenuElement({id = "Key", name = "> Key Settings", type = MENU})
	self.Menu.Key:MenuElement({id = "Combo",name = "Combo", key = 32})
	self.Menu.Key:MenuElement({id = "Harass",name = "Harass", key = string.byte("C")})

	
	self.Menu:MenuElement({type = MENU, id = "Qset", name = "> Q Settings"})
	self.Menu.Qset:MenuElement({id = "Combo",name = "Use in Combo", value = true })
	self.Menu.Qset:MenuElement({id = "Harass", name = "Use in Harass", value = true})
	self.Menu.Qset:MenuElement({id = "Interrupt",name = "Auto on Interrupt Spells",value = true})

	self.Menu:MenuElement({type = MENU, id = "Wset", name = "> W Settings"})
	self.Menu.Wset:MenuElement({id = "Combo", name = "Use in Combo",value = true})
	self.Menu.Wset:MenuElement({ id = "Harass", name = "Use in Harass",value = true})
	
	
	self.Menu:MenuElement({id = "Eset", name = "> E Settings", type = MENU})
	self.Menu.Eset:MenuElement({id = "Combo", name = "Use in Combo",value = true})
	self.Menu.Eset:MenuElement({id = "Spell", name = "Use Against Spells",value = true})
	self.Menu.Eset:MenuElement({id = "HP", name = "Shield if HP Percent below ",value = 80, min = 0, max = 100,step = 1})
	self.Menu.Eset:MenuElement({id = "Turret", name = "Use Against Turrets",value = true})
	self.Menu.Eset:MenuElement({id = "Attack", name = "Use Against Attacks",value = true})
	
	self.Menu:MenuElement({id = "Rset", name = "> R Settings",type = MENU})
	self.Menu.Rset:MenuElement({id = "AutoR",name ="AutoR", value = true})
	self.Menu.Rset:MenuElement({id = "HP", name = "Active if HP below (%)", value =  30, min = 0, max = 100, step =1})
	
	self.Menu:MenuElement({type = MENU, id = "Draw",name = "> Draw Settings"})
	self.Menu.Draw:MenuElement({id = "Q", name = "Draw Q Range", value = true})
	self.Menu.Draw:MenuElement({id = "W", name = "Draw W Range", value = true})
	self.Menu.Draw:MenuElement({id = "E", name = "Draw E Range", value = true})
	--self.Menu.Draw:MenuElement({id = "Root",name = "Draw Root Time", value = true})
	
	PrintChat("SupportBundle: "..myHero.charName.." Loaded")

end

function Janna:LoadData()
	self.MissileSpells = {}
	for i = 1,Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isEnemy then
			if MissileSpells[hero.charName] then
				for k,v in pairs(MissileSpells[hero.charName]) do
					if #v > 1 then
						self.MissileSpells[v] = true
					else
						--print(hero.charName)
					end	
				end
			end
		end
	end
end


function Janna:GetTarget(range)
	if self.SelectedTarget and isValidTarget(self.SelectedTarget,range) then
		return self.SelectedTarget
	end	
	return GetUglyTarget(range)
end

function Janna:ProcessMissile()
	if (not isReady(_E) or not self.Menu.Eset.Spell:Value())then return end
	local enemy = true
	local allies = {}
	for i = 1,Game.HeroCount() do
		local hero = Game.Hero(i)
		if isValidTarget(hero,2500) and hero.isAlly then
			table.insert(allies,hero)
		elseif isValidTarget(hero,2500) and hero.isEnemy then
			enemy = false
		end
	end
	if enemy then return end	
	for i = 1, Game.MissileCount() do
		local obj = Game.Missile(i)
		if obj and obj.isEnemy and obj.missileData and self.MissileSpells[obj.missileData.name] then
			local speed = obj.missileData.speed
			local width = obj.missileData.width
			local endPos = obj.missileData.endPos
			local pos = obj.pos
			if speed and width > 0 and endPos and pos then
				for k, hero in pairs(allies) do 
					if isValidTarget(hero,E.range) and hero.health/hero.maxHealth  < self.Menu.Eset.HP:Value()/100 then
						local pointSegment,pointLine,isOnSegment = VectorPointProjectionOnLineSegment(pos,endPos,hero.pos)
						if isOnSegment and hero.pos:DistanceTo(Vector(pointSegment.x,myHero.pos.y,pointSegment.y)) < width+ hero.boundingRadius and os.clock() - self.LastSpellT > 0.35 then
							self.LastSpellT = os.clock()
							Control.CastSpell(HK_E,hero)
						end
					end
				end
				
			elseif pos and endPos then
				for k,hero in pairs(allies)	do
					if isValidTarget(hero,E.range) and (pos:DistanceTo(hero.pos) < 80 or Vector(endPos):DistanceTo(hero.pos) < 80) and hero.health/hero.maxHealth  < self.Menu.Eset.HP:Value()/100  then
						Control.CastSpell(HK_E,hero)--not sure 
					end
				end
			end
			--Shield Attacks 
		elseif obj and obj.isEnemy and obj.missileData and obj.missileData.name and not obj.missileData.name:find("Minion") and obj.missileData.target > 0 then
			local target = obj.missileData.target
			for k, hero in pairs(allies) do 
				if isValidTarget(hero,E.range) and target == hero.handle and hero.health/hero.maxHealth  < self.Menu.Eset.HP:Value()/100  then
					Control.CastSpell(HK_E,hero)
				end
			end
		end
	end	
end

function Janna:Tick()
	
	if self.SelectedTarget and self.SelectedTarget.dead then 
		self.SelectedTarget = nil
	end
	--self:
	self:AutoInterrupt()
	
	if self.Menu.Key.Combo:Value() then
		self:Combo()
	end
	if self.Menu.Key.Harass:Value() then
		self:Harass()
	end
	if isReady(_R) then
		self:AutoR()
	end
	
end

function Janna:CastQ(unit)
	if not unit  then return end
		local pos =  unit:GetPrediction(Q.speed,Q.delay)
		if pos and os.clock() - self.LastSpellT > 0.35 then
			self.LastSpellT = os.clock()
			Control.CastSpell(HK_Q,pos)
		end
	
end

function Janna:CastW(unit)
	if os.clock() - self.LastSpellT > 0.35 then
		self.LastSpellT = os.clock()
		Control.CastSpell(HK_W,unit)
	end
end

function Janna:Combo()
	local qtarget = self:GetTarget(Q.range)
	local wtarget = self:GetTarget(W.range)
	
	if qtarget and isReady(_Q) and self.Menu.Qset.Combo:Value() then
		self:CastQ(qtarget)
	end
	if wtarget and isReady(_W) and self.Menu.Wset.Combo:Value() and (not isReady(_Q) or myHero.mana > myHero:GetSpellData(_R).mana) then
		self:CastW(wtarget)
	end
	if isReady(_E) and self.Menu.Eset.Combo:Value() then
		for id, hero in pairs(self.Allies) do
			if isValidTarget(hero,E.range) and  hero.attackData.state == 2 and self.Enemies[hero.attackData.target] and os.clock() - self.LastSpellT > 0.35 then  
				self.LastSpellT = os.clock()
				Control.CastSpell(HK_E,hero)
			end
		end
	end
end

function Janna:Harass()
	local qtarget = self:GetTarget(Q.range)
	local wtarget = self:GetTarget(W.range)
	
	if qtarget and isReady(_Q) and self.Menu.Qset.Harass:Value() then
		self:CastQ(qtarget)
	end
	if wtarget and isReady(_W) and self.Menu.Wset.Harass:Value() and (not isReady(_Q) or myHero.mana > myHero:GetSpellData(_R).mana ) then
		self:CastW(wtarget)
	end
end

function Janna:AutoR()
	if self.Menu.Rset.AutoR:Value() then
		for i, hero in pairs(self.Allies) do
			if isValidTarget(hero,500) and hero.health/hero.maxHealth  < self.Menu.Rset.HP:Value()/100 and CountEnemies(hero.pos,R.range - 100) > 0  then
				Control.CastSpell(HK_R)
			end
		end
	end
end

function Janna:AutoInterrupt()--to do
	if not isReady(_Q) then return end
	for i = 1, Game.HeroCount() do
		local enemy  = Game.Hero(i)
 		if enemy.isEnemy and isReady(_Q) and isValidTarget(enemy,Q.range) and AutoInterrupter:IsChannelling(enemy) and self.Menu.Qset.Interrupt:Value() then
			self:CastQ(enemy,enemy.pos)
			return
		end
		
	end
end

function Janna:Draw()
	if myHero.dead then return end

	if self.Menu.Draw.Q:Value() then
		local qcolor = isReady(_Q) and  Draw.Color(189, 183, 107, 255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),Q.range,1,qcolor)
	end
	if self.Menu.Draw.W:Value() then
		local wcolor = isReady(_W) and  Draw.Color(240,30,144,255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),W.range,1,wcolor)
	end
	if self.Menu.Draw.E:Value() then
		local ecolor = isReady(_E) and  Draw.Color(233, 150, 122, 255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),E.range,1,ecolor)
	end
end

function Janna:WndMsg(msg,key)
	if msg == 513 then
		local starget = nil
		for i  = 1,Game.HeroCount(i) do
			local enemy = Game.Hero(i)
			if isValidTarget(enemy) and enemy.isEnemy and enemy.pos:DistanceTo(mousePos) < 200 then
				starget = enemy
				break
			end
		end
		if starget then
			self.SelectedTarget = starget
			print("New target selected: "..starget.charName)
		else
			self.SelectedTarget = nil
		end
	end	
end

--[[Nami]]


class "Nami"

function Nami:__init()
	Q = {ready = false, range = 875, radius = 150, speed = 5000, delay = 0.7, type = "circular"}
	W = {ready = false, range = 725,}
	E = {ready = false, range = 800}
	R = {ready = false, range = 2750,radius = 260, speed = 850, delay = 0.5, type = "line" }
	
	self.Enemies = {}
	self.Allies = {}
	for i = 1,Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isAlly then
			self.Allies[hero.handle] = hero
		else
			self.Enemies[hero.handle] = hero
		end	
	end	
	self.lastTick = 0
	self.SelectedTarget = nil
	self:LoadData()
	self:LoadMenu()
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Draw",function() self:Draw() end)
	Callback.Add("WndMsg",function(Msg, Key) self:WndMsg(Msg, Key) end)
end

function Nami:LoadMenu()
	self.Menu = MenuElement( {id = "SB"..myHero.charName, name = "Nami - The River Spirit", type = MENU})
	self.Menu:MenuElement({id = "Key", name = "> Key Settings", type = MENU})
	self.Menu.Key:MenuElement({id = "Combo",name = "Combo", key = 32})
	self.Menu.Key:MenuElement({id = "Harass",name = "Harass", key = string.byte("C")})

	self.Menu:MenuElement({type = MENU, id = "Qset", name = "> Q Settings"})
	self.Menu.Qset:MenuElement({id = "Combo",name = "Use in Combo", value = true })
	self.Menu.Qset:MenuElement({id = "Harass", name = "Use in Harass", value = true})
	self.Menu.Qset:MenuElement({id = "Immobile",name = "Auto on Immobile",value = true})
	self.Menu.Qset:MenuElement({id = "Interrupt",name = "Auto Interrupt Spells",value = true})

	self.Menu:MenuElement({type = MENU, id = "Eset", name = "> E Settings"})
	self.Menu.Eset:MenuElement({id = "Combo", name = "Use in Combo",value = true})
	self.Menu.Eset:MenuElement({ id = "Harass", name = "Use in Harass",value = true})
	
	self.Menu:MenuElement({id = "Wset", name = "> W Settings", type = MENU})
	self.Menu.Wset:MenuElement({id = "AutoW", name = "Enable Auto Health",value = true})
	self.Menu.Wset:MenuElement({id = "Me", name = "Heal me",value = true})
	self.Menu.Wset:MenuElement({id = "MyHp", name = "Heal me if HP Percent below ",value = 50, min = 0, max = 100,step = 1})
	self.Menu.Wset:MenuElement({id = "Ally", name = "Heal Allies",value = true})
	self.Menu.Wset:MenuElement({id = "AllyHp", name = "Heal Allies if HP Percent below ",value = 80, min = 0, max = 100,step = 1})
	
	self.Menu:MenuElement({id = "Rset", name = "> R Settings",type = MENU})
	self.Menu.Rset:MenuElement({id = "AimR",name = "R-Cast Assistant Key", key = string.byte("T")})
	self.Menu.Rset:MenuElement({id = "Interrupt",name ="Auto Interrupt Spells", value = true})
	self.Menu.Rset:MenuElement({id = "Min", name = "Active if Hits X Enemies", value =  3, min = 1, max = 5, step =1})
	
	self.Menu:MenuElement({type = MENU, id = "Draw",name = "> Draw Settings"})
	self.Menu.Draw:MenuElement({id = "Q", name = "Draw Q Range", value = true})
	self.Menu.Draw:MenuElement({id = "W", name = "Draw W Range", value = true})
	self.Menu.Draw:MenuElement({id = "E", name = "Draw E Range", value = true})
	self.Menu.Draw:MenuElement({id = "R", name = "Draw R Range", value = true})
	PrintChat("SupportBundle: "..myHero.charName.." Loaded")
end

function Nami:LoadData()
	self.MissileSpells = {}
	for i = 1,Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isEnemy then
			if MissileSpells[hero.charName] then
				for k,v in pairs(MissileSpells[hero.charName]) do
					if #v > 1 then
						self.MissileSpells[v] = true
					else
						--print(hero.charName)
					end	
				end
			end
		end
	end
end


function Nami:GetTarget(range)
	if self.SelectedTarget and isValidTarget(self.SelectedTarget,range) then
		return self.SelectedTarget
	end	
	return GetUglyTarget(range)
end

function Nami:AutoW()
	if (not isReady(_W) or not self.Menu.Wset.AutoW:Value())then return end
	for i, ally in pairs(self.Allies) do
		if isValidTarget(ally,W.range) then
			if ally.isMe then
				if ally.health/ally.maxHealth  < self.Menu.Wset.MyHp:Value()/100 then
					Control.CastSpell(HK_W,myHero)
					return
				end	
			else 
				if ally.health/ally.maxHealth  < self.Menu.Wset.AllyHp:Value()/100 then
					Control.CastSpell(HK_W,ally)
					return
				end	
			end			
		end
	end
end

function Nami:Tick()
	if myHero.dead then return end
	if self.SelectedTarget and self.SelectedTarget.dead then 
		self.SelectedTarget = nil
	end
	--self:
	if isReady(_Q) then
		self:AutoQ()
	end	
	if isReady(_R) then
		self:AutoR()
	end
	if isReady(_W) then
		self:AutoW()
	end
	if self.Menu.Key.Combo:Value() then
		self:Combo()
	end
	if self.Menu.Key.Harass:Value() then
		self:Harass()
	end

	
end

function Nami:CastQ(unit)
	if not unit then return end
	local pos = unit:GetPrediction(Q.speed,Q.delay)
		if pos then
			Control.CastSpell(HK_Q,pos)
		end

end

function Nami:CastR(unit)
	if not unit then return end
	local pos = unit:GetPrediction(R.speed,R.delay)
	if pos then
		Control.CastSpell(HK_R,pos)
	end
end

function Nami:CastE(unit)
	if not unit then return end
	Control.CastSpell(HK_E,unit)
end

function Nami:Combo()
	local qtarget = self:GetTarget(Q.range)
	local etarget = self:GetTarget(E.range)
	
	if qtarget and isReady(_Q) and self.Menu.Qset.Combo:Value() then
		self:CastQ(qtarget)
	end
	if etarget and isReady(_E) and self.Menu.Eset.Combo:Value()  then
		self:CastE(etarget)
	end
	if isReady(_E) and self.Menu.Eset.Combo:Value() then
		for id, hero in pairs(self.Allies) do
			if isValidTarget(hero,E.range) and  hero.attackData.state == 2 and self.Enemies[hero.attackData.target] then  
				Control.CastSpell(HK_E,hero)
			end
		end
	end
end

function Nami:Harass()
	local qtarget = self:GetTarget(Q.range)
	local etarget = self:GetTarget(E.range)
	
	if qtarget and isReady(_Q) and self.Menu.Qset.Harass:Value() then
		self:CastQ(qtarget)
	end
	if etarget and isReady(_W) and self.Menu.Eset.Harass:Value() and (not isReady(_Q) or myHero.mana > myHero:GetSpellData(_R).mana ) then
		self:CastE(etarget)
	end
end

function Nami:AutoR()
	local target = self:GetTarget(R.range)
	if self.Menu.Rset.AimR:Value() then
		if target then
			self:CastR(target)
		end
	end
	if target and CountEnemies(target.pos,R.radius) >= self.Menu.Rset.Min:Value() then-- :3
		self:CastR(target)
	end
end

function Nami:AutoQ()
	for i = 1, Game.HeroCount() do
		local enemy  = Game.Hero(i)
 
		if enemy.isEnemy and isReady(_Q) and isValidTarget(enemy,Q.range) and IsImmobileTarget(enemy) and self.Menu.Qset.Immobile:Value() then
			self:CastQ(enemy,enemy.pos)
			return
		end
		if enemy.isEnemy and isReady(_Q) and isValidTarget(enemy,Q.range) and AutoInterrupter:IsChannelling(enemy) and self.Menu.Qset.Interrupt:Value() then
			self:CastQ(enemy,enemy.pos)
			return
		end
	end
end

function Nami:Draw()
	if myHero.dead then return end

	if self.Menu.Draw.Q:Value() then
		local qcolor = isReady(_Q) and  Draw.Color(189, 183, 107, 255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),Q.range,1,qcolor)
	end
	if self.Menu.Draw.W:Value() then
		local wcolor = isReady(_W) and  Draw.Color(240,30,144,255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),W.range,1,wcolor)
	end
	if self.Menu.Draw.E:Value() then
		local ecolor = isReady(_E) and  Draw.Color(233, 150, 122, 255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),E.range,1,ecolor)
	end
	--R
end

function Nami:WndMsg(msg,key)
	if msg == 513 then
		local starget = nil
		for i  = 1,Game.HeroCount(i) do
			local enemy = Game.Hero(i)
			if isValidTarget(enemy) and enemy.isEnemy and enemy.pos:DistanceTo(mousePos) < 200 then
				starget = enemy
				break
			end
		end
		if starget then
			self.SelectedTarget = starget
			print("New target selected: "..starget.charName)
		else
			self.SelectedTarget = nil
		end
	end	
end

--[[Soraka]]


class "Soraka"

function Soraka:__init()
	Q = {ready = false, range = 810, radius = 235, speed = math.huge, delay = 0.250, type = "circular"}
	W = {ready = false, range = 550,}
	E = {ready = false, range = 925, radius = 310, speed = math.huge, delay = 1.75, type = "circular"}
	R = {ready = false, range = math.huge,}
	
	self.Enemies = {}
	self.Allies = {}
	for i = 1,Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isAlly then
			self.Allies[hero.handle] = hero
		else
			self.Enemies[hero.handle] = hero
		end	
	end	
	self.lastTick = 0
	self.SelectedTarget = nil
	self:LoadData()
	self:LoadMenu()
	Callback.Add("Tick",function() self:Tick() end)
	Callback.Add("Draw",function() self:Draw() end)
	Callback.Add("WndMsg",function(Msg, Key) self:WndMsg(Msg, Key) end)
end

function Soraka:LoadMenu()
	self.Menu = MenuElement( {id = "SB"..myHero.charName, name = "Soraka - The Starchild", type = MENU, leftIcon = "http://ddragon.leagueoflegends.com/cdn/6.24.1/img/champion/Soraka.png"})
	self.Menu:MenuElement({id = "Key", name = "> Key Settings", type = MENU})
	self.Menu.Key:MenuElement({id = "Combo",name = "Combo", key = 32})
	self.Menu.Key:MenuElement({id = "Harass",name = "Harass", key = string.byte("C")})

	self.Menu:MenuElement({type = MENU, id = "Qset", name = "> Q Settings"})
	self.Menu.Qset:MenuElement({id = "Combo",name = "Use in Combo", value = true })
	self.Menu.Qset:MenuElement({id = "Harass", name = "Use in Harass", value = true})

	self.Menu:MenuElement({type = MENU, id = "Eset", name = "> E Settings"})
	self.Menu.Eset:MenuElement({id = "Combo", name = "Use in Combo",value = true})
	self.Menu.Eset:MenuElement({id = "Harass", name = "Use in Harass",value = true})
	self.Menu.Eset:MenuElement({id = "Immobile",name = "Auto on Immobile",value = true})
	self.Menu.Eset:MenuElement({id = "Interrupt",name = "Auto Interrupt Spells",value = true})
	
	self.Menu:MenuElement({id = "Wset", name = "> W Settings", type = MENU})
	self.Menu.Wset:MenuElement({id = "AutoW", name = "Enable Auto Health",value = true})
	self.Menu.Wset:MenuElement({id = "MyHp", name = "Heal Allies if my HP Percent above ",value = 8, min = 1, max = 100,step = 1})
	self.Menu.Wset:MenuElement({id = "AllyHp", name = "Heal Allies if HP Percent below ",value = 80, min = 1, max = 100,step = 1})
	
	self.Menu:MenuElement({id = "Rset", name = "> R Settings",type = MENU})
	self.Menu.Rset:MenuElement({id = "AutoR", name = "Enable Auto R",value = true})
	
	self.Menu:MenuElement({type = MENU, id = "Draw",name = "> Draw Settings"})
	self.Menu.Draw:MenuElement({id = "Q", name = "Draw Q Range", value = true})
	self.Menu.Draw:MenuElement({id = "W", name = "Draw W Range", value = true})
	self.Menu.Draw:MenuElement({id = "E", name = "Draw E Range", value = true})
	PrintChat("SupportBundle: "..myHero.charName.." Loaded")
end

function Soraka:LoadData()
	self.MissileSpells = {}
	for i = 1,Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isEnemy then
			if MissileSpells[hero.charName] then
				for k,v in pairs(MissileSpells[hero.charName]) do
					if #v > 1 then
						self.MissileSpells[v] = true
					end	
				end
			end
		end
	end
end

function Soraka:Tick()
	if myHero.dead then return end
	if self.SelectedTarget and self.SelectedTarget.dead then 
		self.SelectedTarget = nil
	end
	--self:
	if isReady(_E) then
		self:AutoE()
	end	
	if isReady(_R) then
		self:AutoR()
	end
	if isReady(_W) then
		self:AutoW()
	end
	if self.Menu.Key.Combo:Value() then
		self:Combo()
	end
	if self.Menu.Key.Harass:Value() then
		self:Harass()
	end
end

function Soraka:GetTarget(range)
	if self.SelectedTarget and isValidTarget(self.SelectedTarget,range) then
		return self.SelectedTarget
	end	
	return GetUglyTarget(range)
end

function Soraka:CastQ(unit)
	if not unit then return end
	local pos = unit:GetPrediction(Q.speed,Q.delay)
		if pos then
			Control.CastSpell(HK_Q,pos)
		end
end

function Soraka:CastE(unit)
	if not unit then return end
	local pos = unit:GetPrediction(E.speed,E.delay)
		if pos then
			Control.CastSpell(HK_E,pos)
		end
end

function Soraka:Combo()
	local qtarget = self:GetTarget(Q.range)
	local etarget = self:GetTarget(E.range)
	
	if etarget and isReady(_E) and self.Menu.Eset.Combo:Value()  then
		self:CastE(etarget)
	end
	if qtarget and isReady(_Q) and self.Menu.Qset.Combo:Value() then
		self:CastQ(qtarget)
	end
end

function Soraka:Harass()
	local qtarget = self:GetTarget(Q.range)
	local etarget = self:GetTarget(E.range)
	
	if etarget and isReady(_E) and self.Menu.Eset.Harass:Value() and (myHero.mana > myHero:GetSpellData(_R).mana) then
		self:CastE(etarget)
	end
	if qtarget and isReady(_Q) and self.Menu.Qset.Harass:Value() and (myHero.mana > myHero:GetSpellData(_R).mana) then
		self:CastQ(qtarget)
	end
end

function Soraka:AutoW()
	if (not isReady(_W) or not self.Menu.Wset.AutoW:Value())then return end
	for i, ally in pairs(self.Allies) do
		if isValidTarget(ally,W.range) then
			if not ally.isMe then
				if (ally.health/ally.maxHealth  < self.Menu.Wset.AllyHp:Value()/100) and (myHero.health/myHero.maxHealth  >= self.Menu.Wset.MyHp:Value()/100) then
					Control.CastSpell(HK_W,ally)
					return
				end	
			end			
		end
	end
end

function Soraka:AutoR()
	if (not isReady(_R) or not self.Menu.Rset.AutoR:Value())then return end
	for i, ally in pairs(self.Allies) do
		if (ally.health/ally.maxHealth  < self.Menu.Wset.MyHp:Value()/100) and (CountEnemies(ally.pos,E.range - 100) > 0) then
			Control.CastSpell(HK_R)
			return
		end	
	end
end

function Soraka:AutoE()
	for i = 1, Game.HeroCount() do
		local enemy  = Game.Hero(i)
 
		if enemy.isEnemy and isReady(_E) and isValidTarget(enemy,E.range) and IsImmobileTarget(enemy) and self.Menu.Eset.Immobile:Value() then
			self:CastE(enemy,enemy.pos)
			return
		end
		if enemy.isEnemy and isReady(_E) and isValidTarget(enemy,E.range) and AutoInterrupter:IsChannelling(enemy) and self.Menu.Eset.Interrupt:Value() then
			self:CastQ(enemy,enemy.pos)
			return
		end
	end
end

function Soraka:Draw()
	if myHero.dead then return end

	if self.Menu.Draw.Q:Value() then
		local qcolor = isReady(_Q) and  Draw.Color(189, 183, 107, 255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),Q.range,1,qcolor)
	end
	if self.Menu.Draw.W:Value() then
		local wcolor = isReady(_W) and  Draw.Color(240,30,144,255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),W.range,1,wcolor)
	end
	if self.Menu.Draw.E:Value() then
		local ecolor = isReady(_E) and  Draw.Color(233, 150, 122, 255) or Draw.Color(240,255,0,0)
		Draw.Circle(Vector(myHero.pos),E.range,1,ecolor)
	end
	--R
end

function Soraka:WndMsg(msg,key)
	if msg == 513 then
		local starget = nil
		for i  = 1,Game.HeroCount(i) do
			local enemy = Game.Hero(i)
			if isValidTarget(enemy) and enemy.isEnemy and enemy.pos:DistanceTo(mousePos) < 200 then
				starget = enemy
				break
			end
		end
		if starget then
			self.SelectedTarget = starget
			print("New target selected: "..starget.charName)
		else
			self.SelectedTarget = nil
		end
	end	
end


Callback.Add("Load",function() _G[myHero.charName]() end)
