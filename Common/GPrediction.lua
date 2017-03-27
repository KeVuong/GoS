--require "GoSWalk"
--[[
gPred:GetPrediction(target,from,spellData,aoe,checkcol)
spellData	
    	.speed --spell's speed
	.range  -- spell's range
	.delay -- spell's delay
	.radius --spell's radius = width/2
	.type = "line"/"circular"/"cone" --spell type
	.col = {"minion","champion","yasuowall"}--table of collision objects
	.from (range check from, dont use)
			
from -- where spell casted
aoe(can be nil)		true/false  -- is aoe spell?
checkcol(can be nil) 	true/false -- check collision
 
Usage: 
1. local result = gPred:GetPrediction(target,from,spellData,aoe,checkcol) -- get normal prediction
result  	
    	.HitChance 
	.CastPosition
	.Position
	.MaxHit (for AOE spells only)
2. local dashinfo = gPred:GetDashInfo(unit)-- Get unit dash info
	.isDashing
	.dashSpeed
	.startPos
	.endPos
	.startT
	.endT
	.duration (second)
3. local pos = gPred:GetPosition(unit,delay,waypoint,moveSpeed)--Get unit's position after a delay
	delay (second)
	waypoint (can be nil)
	moveSpeed (can be nil)
4. local wp = gPred:GetCurrentWayPoints(unit) --get units waypoint ( a table )
for i = 1,#wp-1 do 
  drawline(wp[i],wp[i+1])
end
]]
