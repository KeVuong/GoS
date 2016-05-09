--Kappa

--[[
Usage

GPrediction:GetPrediction(Target,From,SpellData,Collision)
Input:
	target:
	from:   
	spelldata: 	
	      .range
				.delay
				.speed
				.radius/angle	
				.aoe (true/false)
				.type ("position","line","circular","cone")
	
	collision {"champion","minion","yasuowall"} 
Output:
	{CastPosition,Position,HitChance,MaxHit}
	
]]
