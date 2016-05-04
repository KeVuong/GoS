class "AttackMove"
--Inspired
	function ValidTarget(object, distance, enemyTeam)
		local enemyTeam = (enemyTeam ~= false)
		return object ~= nil  and (object.team ~= myHero.team) == enemyTeam and object.visible and not object.dead and object.isTargetable and (enemyTeam == false or object.isInvulnerable == false) and (distance == nil or GetDistanceSqr(object) <= distance * distance)
	end
--End Inspired	
	
	
function AttackMove:__init()
	self.AttackMoveCommand = false
	self:LoadMenu()
	Callback.Add("WndMsg",function(Msg, Key) self:OnWndMsg(Msg, Key) end)
	Callback.Add("IssueOrder",function(order) self:OnIssueOrder(order) end)
end

function AttackMove:LoadMenu()
	self.oMenu = Menu("LCO","Left-Click Orbwalker")
	self.oMenu:Boolean("Enable","Enable",true)
	self.oMenu:Slider("Range","Max Range",myHero.range + 200,100,2000)
end

function AttackMove:OnIssueOrder(order)
	
end

function AttackMove:Attack(unit)
	myHero:Attack(unit)
end

function AttackMove:OnWndMsg(Msg, Key)
	if Msg == 513 then
		local target = GetCurrentTarget()
		if ValidTarget(target,myHero.range + myHero.boundingRadius) and self.oMenu.Enable:Value() then
			self:Attack(target)
		elseif target and GetDistance(target) < self.oMenu.Range:Value() then
			myHero:Move(target.pos.x,target.pos.z)
		end
	end
end

AttackMove()
