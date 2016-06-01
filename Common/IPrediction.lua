do
	local Prediction = {}
	Prediction.User = {}
	Prediction.User.Interface = {}
	Prediction.User.State = {}
	Prediction.Callback = {}
	Prediction.Core = {}
	Prediction.Core.Math = {}
	Prediction.WayPointManager = {}

	Prediction.Vars = {
		Version = 17,
		Heroes = {},
		Slowed = {},
		Stunned = {},
		Dashing = {},
		Config = MenuConfig("IPrediction", "IPrediction"..myHeroName),
		DashCallbacks = {},
		StunCallbacks = {},
		LastBuffTick = 0,
		WayPoints = {},
		BUFF_NONE = 0,
		BUFF_GLOBAL = 1,
		BUFF_BASIC = 2,
		BUFF_DEBUFF = 3,
		BUFF_STUN = 5,
		BUFF_STEALTH = 6,
		BUFF_SILENCE = 7,
		BUFF_TAUNT = 8,
		BUFF_SLOW = 10,
		BUFF_ROOT = 11,
		BUFF_DOT = 12,
		BUFF_REGENERATION = 13,
		BUFF_SPEED = 14,
		BUFF_MAGIC_IMMUNE = 15,
		BUFF_PHYSICAL_IMMUNE = 16,
		BUFF_IMMUNE = 17,
		BUFF_Vision_Reduce = 19,
		BUFF_FEAR = 21,
		BUFF_CHARM = 22,
		BUFF_POISON = 23,
		BUFF_SUPPRESS = 24,
		BUFF_BLIND = 25,
		BUFF_STATS_INCREASE = 26,
		BUFF_STATS_DECREASE = 27,
		BUFF_FLEE = 28,
		BUFF_KNOCKUP = 29,
		BUFF_KNOCKBACK = 30,
		BUFF_DISARM = 31,
		spells = {
			{name = "katarinar", duration = 1},
			{name = "drain", duration = 5},
			{name = "crowstorm", duration = 1.5},
			{name = "consume", duration = 1.5},
			{name = "absolutezero", duration = 1},
			{name = "rocketgrab", duration = 0.5},
			{name = "staticfield", duration = 0.5},
			{name = "cassiopeiapetrifyinggaze", duration = 0.5},
			{name = "ezrealtrueshotbarrage", duration = 1},
			{name = "galioidolofdurand", duration = 1},
			{name = "luxmalicecannon", duration = 0.5},
			{name = "reapthewhirlwind", duration = 1},
			{name = "jinxw", duration = 0.5},
			{name = "jinxr", duration = 0.5},
			{name = "missfortunebullettime", duration = 1},
			{name = "shenstandunited", duration = 1},
			{name = "threshe", duration = 0.4},
			{name = "threshrpenta", duration = 0.75},
			{name = "infiniteduress", duration = 0.5},
			{name = "meditate", duration = 1},
			{name = "gate", duration = 1.5},
		},
		Spells = {},
		blinks = {
			{name = "ezrealarcaneshift", range = 475, delay = 0.25, delay2=0.8},
			{name = "deceive", range = 400, delay = 0.25, delay2=0.8},
			{name = "riftwalk", range = 700, delay = 0.25, delay2=0.8},
			{name = "gate", range = 5500, delay = 1.5, delay2=1.5},
			{name = "katarinae", range = math.huge, delay = 0.25, delay2=0.8},
			{name = "elisespideredescent", range = math.huge, delay = 0.25, delay2=0.8},
			{name = "elisespidere", range = math.huge, delay = 0.25, delay2=0.8},
		}
	}

	function Prediction.Callback.ObjectLoad(hero)
		if GetObjectType(hero) == Obj_AI_Hero then
			Prediction.Vars.Heroes[GetNetworkID(hero)] = hero;
			Prediction.Vars.Slowed[GetNetworkID(hero)] = {};
			Prediction.Vars.Stunned[GetNetworkID(hero)] = {};
			Prediction.Vars.Dashing[GetNetworkID(hero)] = {};
			Prediction.Vars.WayPoints[GetNetworkID(hero)] = {};
		end
	end

	function Prediction.Callback.Tick()
		for i = 1, #heroes do
			local unit = heroes[i];
			if Prediction.Vars.LastBuffTick < GetGameTimer() then
				Prediction.Vars.LastBuffTick = GetGameTimer() + 0.05;
				local sccEndT = Prediction.Vars.Slowed[GetNetworkID(unit)].endT;
				local hccEndT = Prediction.Vars.Stunned[GetNetworkID(unit)].endT;
				for I = 0, 64 do
					local buff = { valid = GetBuffCount(unit,I) > 0, type = GetBuffType(unit, I), startT = GetBuffStartTime(unit, I), endT = GetBuffExpireTime(unit, I), name = GetBuffName(unit, I)}
					if buff and buff.valid and buff.endT > GetGameTimer() then
						if (buff.type == Prediction.Vars.BUFF_STUN or buff.type == Prediction.Vars.BUFF_ROOT or buff.type == Prediction.Vars.BUFF_KNOCKUP or buff.type == Prediction.Vars.BUFF_SUPPRESS) then
							if (not hccEndT or hccEndT < buff.endT) then
								Prediction.Vars.Stunned[GetNetworkID(unit)] = {endT = buff.endT, bType = buff.type, bName = buff.name}
							end
						elseif (buff.type == Prediction.Vars.BUFF_SLOW or buff.type == Prediction.Vars.BUFF_CHARM or buff.type == Prediction.Vars.BUFF_FEAR or buff.type == Prediction.Vars.BUFF_TAUNT) then
							if (not sccEndT or sccEndT < buff.endT) then
								Prediction.Vars.Slowed[GetNetworkID(unit)] = {endT = buff.endT, bType = buff.type, bName = buff.name}
							end
						end
					end
				end
			end
			Prediction.WayPointManager.RemoveOldWayPoints(unit)
			if ValidTarget(unit) then
				if Prediction.Vars.Config.callbacks.dash["h"..GetObjectName(unit)]:Value() then
					local I = #Prediction.Vars.DashCallbacks;
					for i = 1, I do
						dashCallback = Prediction.Vars.DashCallbacks[i]
						local x, y, z = Prediction.User.Interface.IsUnitDashing(unit, dashCallback.range, dashCallback.speed, dashCallback.delay, dashCallback.width, dashCallback.source)
						if x and z <= dashCallback.width + GetHitBox(unit) then
							dashCallback.callback(unit, y)
						end
					end
				end
				if Prediction.Vars.Config.callbacks.stun["h"..GetObjectName(unit)]:Value() then
					local I = #Prediction.Vars.StunCallbacks;
					for i = 1, I do
						stunCallback = Prediction.Vars.StunCallbacks[i]
						local x, y, z = Prediction.User.Interface.IsUnitStunned(unit, stunCallback.range, stunCallback.speed, stunCallback.delay, stunCallback.width, stunCallback.source)
						if x and y <= stunCallback.width + GetHitBox(unit) and GetDistance(z) < stunCallback.range + stunCallback.width + GetHitBox(unit) then
							stunCallback.callback(unit, z, y)
						end
					end
				end
			end
		end
	end

	function Prediction.Callback.ProcessWaypoint(unit, waypoint)
		if unit and IsObjectAlive(unit) and GetObjectType(unit) == GetObjectType(myHero) then
			if waypoint.dashspeed > 0 then
				local endPos = Vector(waypoint.position)
				local realDist = GetDistance(unit, endPos)
				local speed = waypoint.dashspeed
				speed = speed * (100 + waypoint.dashgravity) / 100
				Prediction.Vars.Dashing[GetNetworkID(unit)] = {startT = GetGameTimer(), endT = GetGameTimer() + realDist/(speed), startPos = Vector(unit), endPos = endPos, dashSpeed = speed, dashDistance = realDist}
			else
				local current_way_point = Vector(waypoint.position)
				local my_current_position = Vector(myHero)
				local diff_coordinates = {x = current_way_point.x - my_current_position.x, y = current_way_point.y - my_current_position.y}
				local polar_coordinate = {theta = math.atan2(diff_coordinates.x, diff_coordinates.y), r = Prediction.Core.pythag(diff_coordinates.x, diff_coordinates.y)}
				Prediction.Vars.Stunned[GetNetworkID(unit)] = {}
				if not Prediction.Vars.WayPoints[GetNetworkID(unit)] then Prediction.Vars.WayPoints[GetNetworkID(unit)] = {} end
				table.insert(Prediction.Vars.WayPoints[GetNetworkID(unit)], {rel = polar_coordinate, time = GetGameTimer(), pos = Vector(waypoint.position), index = waypoint.index})
			end
		end
	end

	function Prediction.Callback.ProcessSpell(unit, spell)
		if unit and spell and spell.name then
			for _, thing in pairs(Prediction.Vars.spells) do
				if spell.name:lower() == thing.name then
					Prediction.Vars.Stunned[GetNetworkID(unit)] = {endT = GetGameTimer() + thing.duration + spell.windUpTime, bType = Prediction.Vars.BUFF_STUN, bName = spell.name}
					return
				end
			end
		end
	end

	function Prediction.Callback.Draw()
		if display then
			DrawCircle(GetOrigin(myHero), display[1].range+display[1].width, 1, 1, ARGB(255-255 * (GetGameTimer()-display[2]),255,255,255))
			if display[2] + 1 < GetGameTimer() then
				display = nil
			end
		end
	end

	function Prediction.Core.Collision(startP, endP, spell, type, team, exclude)
		local objects = {}
		local collides = {}
		if not type or type == Obj_AI_Minion then
			for i=1, minionManager.maxObjects do
				local object = minionManager.objects[i]
				if object and GetTeam(object) == team and (not exclude and endP ~= object or exclude ~= object) then
					table.insert(objects, object)
				end
			end
		end
		if not type or type == Obj_AI_Hero then
			for i=1, #heroes do
				local object = heroes[i]
				if GetTeam(object) == team and (not exclude and endP ~= object or exclude ~= object) then
					table.insert(objects, object)
				end
			end
		end
		for I=1, #objects do
			local object = objects[I]
			if IsObjectAlive(object) and GetOrigin(object) ~= nil and IsVisible(object) and GetDistance(object) < spell.range+spell.width then
				local hc, predP = Prediction.Core.PredictPos(object, GetDistance(startP,unit)/spell.speed+spell.delay)
				if not predP then predP = Vector(object) end
				local ProjPoint,_,OnSegment = VectorPointProjectionOnLineSegment(Vector(startP), Vector(endP), Vector(predP))
				if OnSegment then
					if GetDistanceSqr(ProjPoint, predP) < (GetHitBox(object) + spell.width) ^ 2 then
						table.insert(collides, object)
					end
				end
			end
		end
		local collN = #collides
		return collN>0, collN, collides
	end

	function Prediction.Core.Predict(unit, spell, source)
		local chance, pos, info = 0, nil, nil
		if not unit or not IsVisible(unit) or not Prediction.WayPointManager.IsVisible(unit) then
			return Prediction.User.State.INVISIBLE, nil
		end
		if spell.collision < math.huge then
			local collType = not (spell.collisionH and spell.collisionM) and (spell.collisionH and Obj_AI_Hero or Obj_AI_Minion) or nil
			local x, y, z = Prediction.Core.Collision(source, unit, spell, collType, GetTeam(unit), unit)
			if x and y-spell.collision > 0 then
				return Prediction.User.State.WILL_COLLIDE, nil, {num = y, objects = z}
			end
		end
		if GetObjectType(unit) == Obj_AI_Hero then
			if Prediction.Vars.Config.spells["s"..spell.id].dash:Value() then
				local i, p, d = Prediction.User.Interface.IsUnitDashing(unit, spell.range, spell.speed, spell.delay, spell.width, source)
				if i and d <= spell.width + GetHitBox(unit) then
					return Prediction.User.State.ENEMY_IS_DASHING, Vector(p), d
				end
			end
			if Prediction.Vars.Config.spells["s"..spell.id].stun:Value() then
				local i, d, p = Prediction.User.Interface.IsUnitStunned(unit, spell.range, spell.speed, spell.delay, spell.width, source)
				if i and d <= spell.width + GetHitBox(unit) and GetDistance(p) < spell.range + spell.width + GetHitBox(unit) then
					return Prediction.User.State.ENEMY_IS_IMMOBILE, Vector(p), d
				end
			end
			local wp = Prediction.WayPointManager.GetWayPoints(unit)
			if #wp == 0 then
				if GetMoveSpeed(unit)*spell.delay+GetDistance(unit, source)/spell.speed < spell.width+GetHitBox(unit) then
					return Prediction.User.State.ENEMY_IS_STUPID, Vector(unit)
				else
					return Prediction.User.State.WILL_MISS, nil
				end
			end
		end
		--[[ TODO: cone | circular
		if spell.type == "cone" then
			chance, pos, info = Prediction.Core.PredictCone(unit, spell, source)
		elseif spell.type == "linear " then
			chance, pos, info = Prediction.Core.PredictLinear(unit, spell, source)
		else
			chance, pos, info = Prediction.Core.PredictCircular(unit, spell, source)
		end]]
		return Prediction.Core.PredictLinear(unit, spell, source)
	end

	function Prediction.Core.PredictPos(unit, delay)
		return Vector(unit)+Vector(Prediction.WayPointManager.GetDirection(unit)):normalized()*delay*GetMoveSpeed(unit)
	end

	function Prediction.Core.PredictCone(unit, spell, source)
		if spell.aoe then
		end
	end

	function Prediction.Core.PredictCircular(unit, spell, source)
		if spell.aoe then
		end
	end

	function Prediction.Core.PredictLinear(unit, spell, source)
		if spell.aoe then
		end
        local Position = Prediction.Core.PredictPos(unit, GetDistance(source,unit)/spell.speed+spell.delay)
        local coll, colL = 0, {}
		if spell.collision < math.huge then
			local collType = not (spell.collisionH and spell.collisionM) and (spell.collisionH and Obj_AI_Hero or Obj_AI_Minion) or nil
			local x, y, z = Prediction.Core.Collision(source, Position, spell, collType, GetTeam(unit), unit)
			coll, colL = y, z
			if x and y-spell.collision > 0 then
				return Prediction.User.State.WILL_COLLIDE, nil, {num = y, objects = z}
			end
		end
        return GetDistance(Position, source) < spell.range + spell.width and Prediction.User.State.WILL_HIT or Prediction.User.State.WILL_MISS, Position, {num = coll, objects = colL}
	end

	function Prediction.Core.pythag(x,y)
		return math.sqrt(x*x + y*y)
	end

	function Prediction.WayPointManager.GetWayPoints(unit, from, to)
		local from, to = from or 10, to or 0
		local result = {}
		if not Prediction.Vars.WayPoints[GetNetworkID(unit)] then Prediction.Vars.WayPoints[GetNetworkID(unit)] = {} end
		for i, waypoint in pairs(Prediction.Vars.WayPoints[GetNetworkID(unit)]) do
			if (GetGameTimer() - waypoint.time) < from and (GetGameTimer() - waypoint.time) > to then
				table.insert(result, waypoint)
			end
		end
		return result
	end

	function Prediction.WayPointManager.RemoveOldWayPoints(unit)
		local result = {}
		for i, waypoint in pairs(Prediction.Vars.WayPoints[GetNetworkID(unit)]) do
			if (GetGameTimer() - waypoint.time) >= 10 then
				table.remove(Prediction.Vars.WayPoints[GetNetworkID(unit)], i)
			end
		end
		return result
	end

	function Prediction.WayPointManager.IsVisible(unit)
		return true
	end

	function Prediction.WayPointManager.GetPath(unit)
		local wp = Prediction.WayPointManager.GetWayPoints(unit)
		local wpn, lastI = #wp, 0
		local result, result2 = {}, {}
		for I=wpn, 1, -1 do
			if lastI > 0 and lastI > wp[I].time then
				break
			end
			lastI = wp[I].time
			table.insert(result, wp[I].pos)
		end
		for I=#result, 1, -1 do
			table.insert(result2, result[I])
		end
		return result2
	end

	function Prediction.WayPointManager.GetSimulatedPath(unit)
		local wp = Prediction.WayPointManager.GetPath(unit)
		-- TODO
		return wp
	end

	function Prediction.WayPointManager.GetDirection(unit)
		local path = Prediction.WayPointManager.GetPath(unit)
		local unit = Vector(unit)
		if #path == 0 then
			return unit
		else
			local path = path[#path]
			return Vector(path.x - unit.x, path.y - unit.y, path.z - unit.z)
		end
	end

	Prediction.User.State = {
		WILL_MISS = 0,
		INVISIBLE = 1,
		WILL_COLLIDE = 2,
		WILL_HIT = 3,
		ENEMY_IS_SLOWED = 4,
		ENEMY_IS_DASHING = 5,
		ENEMY_IS_IMMOBILE = 6,
		ENEMY_IS_STUPID = 7,
	}
	Prediction.User.StateToString = {
		[0] = "WILL_MISS",
		[1] = "INVISIBLE",
		[2] = "WILL_COLLIDE",
		[3] = "WILL_HIT",
		[4] = "ENEMY_IS_SLOWED",
		[5] = "ENEMY_IS_DASHING",
		[6] = "ENEMY_IS_IMMOBILE",
		[7] = "ENEMY_IS_STUPID"
	}

	function Prediction.User.OnDash(callback, range, speed, delay, width, source)
		local callback, range, speed, delay, width, source = callback, range, speed, delay, width, source
		if type(range) == "table" then
			source = speed
			speed = range.speed
			delay = range.delay
			width = range.width
			range = range.range
		end
		Prediction.Vars.DashCallbacks[#Prediction.Vars.DashCallbacks + 1] = {callback = callback, range = range, speed = speed, delay = delay, width = width, source = source or myHero}
	end

	function Prediction.User.OnImmobile(callback, range, speed, delay, width, source)
		local callback, range, speed, delay, width, source = callback, range, speed, delay, width, source
		if type(range) == "table" then
			source = speed
			speed = range.speed
			delay = range.delay
			width = range.width
			range = range.range
		end
		Prediction.Vars.StunCallbacks[#Prediction.Vars.StunCallbacks + 1] = {callback = callback, range = range, speed = speed, delay = delay, width = width, source = source or myHero}
	end

	function Prediction.User.Interface.IsUnitStunned(unit, range, speed, delay, width, source)
		range = range or math.huge
		speed = speed or math.huge
		delay = delay or 0
		width = width or 0
		source = source or myHero
		if not unit or not IsObjectAlive(unit) then return false, math.huge end
		local dist = GetDistance(unit, source)
		if range ~= math.huge and speed ~= math.huge and dist < range+width/2 then
			delay = delay + (dist) / speed
		end
		local canHasStun = Prediction.Vars.Stunned[GetNetworkID(unit)];
		if canHasStun and canHasStun.endT and canHasStun.endT > GetGameTimer() then
			local remainingTime = canHasStun.endT - GetGameTimer()
			if canHasStun.pos and canHasStun.midT < remainingTime then
				Prediction.Vars.Stunned[GetNetworkID(unit)].pos = GetOrigin(unit)
			end
			if remainingTime > delay then
				return true, 0, canHasStun.pos or GetOrigin(unit)
			else
				return true, GetMoveSpeed(unit) * (delay - remainingTime), canHasStun.pos or GetOrigin(unit)
			end
		end
		return false, GetMoveSpeed(unit) * delay, GetOrigin(unit)
	end

	function Prediction.User.Interface.IsUnitSlowed(unit, range, speed, delay, width, source)
		range = range or math.huge
		speed = speed or math.huge
		delay = delay or 0
		width = width or 0
		source = source or myHero
		if not unit or not IsObjectAlive(unit) then return false, math.huge end
		local dist = GetDistance(unit, source)
		if range ~= math.huge and speed ~= math.huge and dist < range+width/2 then
			delay = delay + (dist) / speed
		end
		local canHasSlow = Prediction.Vars.Slowed[GetNetworkID(unit)];
		if canHasSlow and canHasSlow.endT and canHasSlow.endT > GetGameTimer() then
			local remainingTime = canHasSlow.endT - GetGameTimer()
			if remainingTime > delay then
				return true, GetMoveSpeed(unit) * (delay)
			else
				return true, GetMoveSpeed(unit) * (delay - remainingTime)
			end
		end
		return false, GetMoveSpeed(unit) * delay
	end

	function Prediction.User.Interface.IsUnitDashing(unit, range, speed, delay, width, source)
		range = range or math.huge
		speed = speed or math.huge
		delay = delay or 0
		width = width or 0
		source = source or myHero
		if not unit or not IsObjectAlive(unit) then return false, nil, math.huge end
		local dist = GetDistance(unit, source)
		if range ~= math.huge and speed ~= math.huge and dist < range+width/2 then
			delay = delay + (dist) / speed
		end
		local canHasDash = Prediction.Vars.Dashing[GetNetworkID(unit)];
 		if canHasDash.startT then
			local remainingTime = canHasDash.endT - GetGameTimer()
			if remainingTime > delay then
				local pos = Vector(canHasDash.startPos.x,0,canHasDash.startPos.z) + Vector(canHasDash.endPos.x-canHasDash.startPos.x,0,canHasDash.endPos.z-canHasDash.startPos.z):normalized() * canHasDash.dashSpeed * (GetGameTimer() - canHasDash.startT + delay)
				return true, pos, 0
			elseif remainingTime > 0 then
				return true, Vector(canHasDash.endPos), GetMoveSpeed(unit) * (delay - remainingTime)
			else
				Prediction.Vars.Dashing[GetNetworkID(unit)] = {};
				return false, nil, GetMoveSpeed(unit) * (delay - remainingTime)
			end
		end
		return false, nil, math.huge
	end

	function Prediction.User.Interface.Collision(startP, endP, spell, team, exc)
		return Prediction.Core.Collision(startP, endP, spell, nil, team or GetTeam(endP), exc or endP)
	end

	function Prediction.User.Interface.CollisionH(startP, endP, spell, team, exc)
		return Prediction.Core.Collision(startP, endP, spell, Obj_AI_Hero, team or GetTeam(endP), exc or endP)
	end

	function Prediction.User.Interface.CollisionM(startP, endP, spell, team, exc)
		return Prediction.Core.Collision(startP, endP, spell, Obj_AI_Minion, team or GetTeam(endP), exc or endP)
	end
	
	function Prediction.User.Interface.PredictPos(unit, delay)
                return Prediction.Core.PredictPos(unit, delay)
	end
	
	do
		for name, callback in pairs(Prediction.Callback) do
			_G["On"..name](callback)
		end
		--Prediction.Vars.Config:Info("i1", "Loaded!")
		--Prediction.Vars.Config:Info("i2", "More menu options soon")
		Prediction.Vars.Config:SubMenu("callbacks", "Callbacks")
		Prediction.Vars.Config.callbacks:SubMenu("stun", "Immobile")
		Prediction.Vars.Config.callbacks:SubMenu("dash", "Dash")
		OnObjectLoad(function(hero)
			if GetObjectType(hero) == GetObjectType(myHero) and GetTeam(hero) ~= GetTeam(myHero) then
				Prediction.Vars.Config.callbacks.stun:Boolean("h"..GetObjectName(hero), "Predict -> "..GetObjectName(hero), true, function() end, true)
				Prediction.Vars.Config.callbacks.dash:Boolean("h"..GetObjectName(hero), "Predict -> "..GetObjectName(hero), true, function() end, true)
			end
		end)
		Prediction.Vars.Config:SubMenu("spells", "Spells")
		--[[AutoUpdate(
			"/Inspired-gos/scripts/master/Common/IPrediction.lua", -- git lua url
			"/Inspired-gos/scripts/master/Common/IPrediction.version", -- git version url
			"Common\\IPrediction.lua", -- local lua path
			Prediction.Vars.Version)]] -- local version number
	end

	class "Spell"

	function Spell:__init(table)
		self.name = table.name
		self.key = table.key
		self.range = table.range
		self.speed = table.speed
		self.delay = table.delay
		self.width = table.width
		self.type = table.type
		self.collision = table.collision
		self.callback = table.callback
		self.collisionH = table.collisionH
		self.collisionM = table.collisionM
		return self;
	end

	function Spell:Predict(unit, source)
		return Prediction.Core.Predict(unit, self, source or myHero)
	end

	function Spell:Collision(unit, source)
		return Prediction.Core.Collision(Vector(source or myHero), Vector(unit), self, (self.collisionH and self.collisionM) and nil or self.collisionH and Obj_AI_Hero or self.collisionM and Obj_AI_Minion or nil, GetTeam(unit), unit)
	end

	_G.IPrediction = {
		IsUnitDashing = Prediction.User.Interface.IsUnitDashing,
		IsUnitSlowed = Prediction.User.Interface.IsUnitSlowed,
		IsUnitStunned = Prediction.User.Interface.IsUnitStunned,
		CollisionM = Prediction.User.Interface.CollisionM,
		CollisionH = Prediction.User.Interface.CollisionH,
		Collision = Prediction.User.Interface.Collision,
		PredictPos = Prediction.User.Interface.PredictPos,
		Prediction = function(data)
			if not (data.range and data.speed and data.delay and data.width) then print("Please specify spelldata!") end
			if not data.name then print("Please specify a spellname!") end
			local spell = Spell({name = data.name, range = data.range, speed = data.speed, delay = data.delay, width = data.width, type = data.type, collisionH = data.collisionH or false, collisionM = data.collisionM or false, collision = type(data.collision) == "number" and data.collision or data.collision and 0 or math.huge, aoe = data.aoe})						
			if spell.collision < math.huge and not spell.collisionH and not spell.collisionM then
				spell.collisionH = true
				spell.collisionM = true
			end
			spell.id = #Prediction.Vars.Spells+1
			Prediction.Vars.Config.spells:SubMenu("s"..spell.id, spell.name or data.name or ".")
			Prediction.Vars.Config.spells["s"..spell.id]:Boolean("dash", "Dash", true, function() end, true)
			Prediction.Vars.Config.spells["s"..spell.id]:Boolean("stun", "Stun", true, function() end, true)
			Prediction.Vars.Config.spells["s"..spell.id]:Slider("r", "Max Range", spell.range, 0, spell.range*1.25, 1, function(x) display = {spell, GetGameTimer()} spell.range = x end, true)
			Prediction.Vars.Config.spells["s"..spell.id]:Empty("e", -0.75)
			OnObjectLoad(function(hero)
				if GetObjectType(hero) == GetObjectType(myHero) and GetTeam(hero) ~= GetTeam(myHero) then
					Prediction.Vars.Config.spells["s"..spell.id]:Boolean("h"..GetObjectName(hero), "Predict -> "..GetObjectName(hero), true, function() end, true)
				end
			end)
			Prediction.Vars.Spells[spell.id] = spell
			return spell
		end,
		OnDash = Prediction.User.OnDash,
		OnImmobile = Prediction.User.OnImmobile,
		State = Prediction.User.State,
		StateToString = Prediction.User.StateToString,
	}
end
