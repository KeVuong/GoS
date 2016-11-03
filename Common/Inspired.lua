local iVersion = 30
-- { local vars and funcs
-- }
do -- helpers
	Timer = os and os.clock or function() return GetTickCount() / 1000 end
	function Set(list)
		local set = {}
		for _, l in ipairs(list) do 
			set[l] = true 
		end
		return set
	end
	function VecIsUnder(a, b, c, d, e, f)
		if type(a) == "table" then
			f,e,d,c,b=e,d,c,b
			a,b = a.x,a.y
		end
		return a>=c and a<=c+e and b>=d and b<= d+f
	end
end
do -- advanced callbacks
	if not Callback.callbacks.HumanTick then
		Callback.callbacks.HumanTick = {}
		function InspiredNeverCalledOnHumanTick()
		    for c, cb in pairs(Callback.callbacks["HumanTick"]) do
		        cb()
		    end
		end
		OnProcessPacket(function(p)
		    if p.header == 186 then InspiredNeverCalledOnHumanTick() end
		end)
		OnHumanTick = function(cb) return Callback.Add("HumanTick", cb) end
		DelHumanTick = function(which) Callback.Del("HumanTick", which) end
	end
end
do -- geometry
	local uniqueId2 = 0
	class 'Point2' -- {
		function Point2:__init(x, y)
			uniqueId2 = uniqueId2 + 1
			self.uniqueId2 = uniqueId2

			self.x = x
			self.y = y

			self.points = {self}
		end

		function Point2:__type()
			return "Point2"
		end

		function Point2:__eq(spatialObject)
			return spatialObject:__type() == "Point2" and self.x == spatialObject.x and self.y == spatialObject.y
		end

		function Point2:__unm()
			return Point2(-self.x, -self.y)
		end

		function Point2:__add(p)
			return Point2(self.x + p.x, self.y + p.y)
		end

		function Point2:__sub(p)
			return Point2(self.x - p.x, self.y - p.y)
		end

		function Point2:__mul(p)
			if type(p) == "number" then
				return Point2(self.x * p, self.y * p)
			else
				return Point2(self.x * p.x, self.y * p.y)
			end
		end

		function Point2:tostring()
			return "Point2(" .. tostring(self.x) .. ", " .. tostring(self.y) .. ")"
		end

		function Point2:__div(p)
			if type(p) == "number" then
				return Point2(self.x / p, self.y / p)
			else
				return Point2(self.x / p.x, self.y / p.y)
			end
		end

		function Point2:between(point1, point2)
			local normal = Line2(point1, point2):normal()

			return Line2(point1, point1 + normal):side(self) ~= Line2(point2, point2 + normal):side(self)
		end

		function Point2:len()
			return math.sqrt(self.x * self.x + self.y * self.y)
		end

		function Point2:normalize()
			len = self:len()

			self.x = self.x / len
			self.y = self.y / len

			return self
		end

		function Point2:clone()
			return Point2(self.x, self.y)
		end

		function Point2:normalized()
			local a = self:clone()
			a:normalize()
			return a
		end

		function Point2:getPoints()
			return self.points
		end

		function Point2:getLineSegments()
			return {}
		end

		function Point2:perpendicularFoot(line)
			local distanceFromLine = line:distance(self)
			local normalVector = line:normal():normalized()

			local footOfPerpendicular = self + normalVector * distanceFromLine
			if line:distance(footOfPerpendicular) > distanceFromLine then
				footOfPerpendicular = self - normalVector * distanceFromLine
			end

			return footOfPerpendicular
		end

		function Point2:contains(spatialObject)
			if spatialObject:__type() == "Line2" then
				return false
			elseif spatialObject:__type() == "Circle2" then
				return spatialObject.point == self and spatialObject.radius == 0
			else
			for i, point in ipairs(spatialObject:getPoints()) do
				if point ~= self then
					return false
				end
			end
		end

			return true
		end

		function Point2:polar()
			if math.close(self.x, 0) then
				if self.y > 0 then return 90
				elseif self.y < 0 then return 270
				else return 0
				end
			else
				local theta = math.deg(math.atan(self.y / self.x))
				if self.x < 0 then theta = theta + 180 end
				if theta < 0 then theta = theta + 360 end
				return theta
			end
		end

		function Point2:insideOf(spatialObject)
			return spatialObject.contains(self)
		end

		function Point2:distance(spatialObject)
			if spatialObject:__type() == "Point2" then
				return math.sqrt((self.x - spatialObject.x)^2 + (self.y - spatialObject.y)^2)
			elseif spatialObject:__type() == "Line2" then
				denominator = (spatialObject.points[2].x - spatialObject.points[1].x)
				if denominator == 0 then
					return math.abs(self.x - spatialObject.points[2].x)
				end

				m = (spatialObject.points[2].y - spatialObject.points[1].y) / denominator

				return math.abs((m * self.x - self.y + (spatialObject.points[1].y - m * spatialObject.points[1].x)) / math.sqrt(m * m + 1))
			elseif spatialObject:__type() == "Circle2" then
				return self:distance(spatialObject.point) - spatialObject.radius
			elseif spatialObject:__type() == "LineSegment2" then
				local t = ((self.x - spatialObject.points[1].x) * (spatialObject.points[2].x - spatialObject.points[1].x) + (self.y - spatialObject.points[1].y) * (spatialObject.points[2].y - spatialObject.points[1].y)) / ((spatialObject.points[2].x - spatialObject.points[1].x)^2 + (spatialObject.points[2].y - spatialObject.points[1].y)^2)

				if t <= 0.0 then
					return self:distance(spatialObject.points[1])
				elseif t >= 1.0 then
					return self:distance(spatialObject.points[2])
				else
					return self:distance(Line2(spatialObject.points[1], spatialObject.points[2]))
				end
			else
				local minDistance = nil

				for i, lineSegment in ipairs(spatialObject:getLineSegments()) do
					if minDistance == nil then
						minDistance = self:distance(lineSegment)
					else
						minDistance = math.min(minDistance, self:distance(lineSegment))
					end
				end

				return minDistance
			end
		end

	class 'Line2' -- {
		function Line2:__init(point1, point2)
			uniqueId2 = uniqueId2 + 1
			self.uniqueId2 = uniqueId2

			self.points = {point1, point2}
		end

		function Line2:__type()
			return "Line2"
		end

		function Line2:__eq(spatialObject)
			return spatialObject:__type() == "Line2" and self:distance(spatialObject) == 0
		end

		function Line2:getPoints()
			return self.points
		end

		function Line2:getLineSegments()
			return {}
		end

		function Line2:direction()
			return self.points[2] - self.points[1]
		end

		function Line2:normal()
			return Point2(- self.points[2].y + self.points[1].y, self.points[2].x - self.points[1].x)
		end

		function Line2:perpendicularFoot(point)
			return point:perpendicularFoot(self)
		end

		function Line2:side(spatialObject)
			leftPoints = 0
			rightPoints = 0
			onPoints = 0
			for i, point in ipairs(spatialObject:getPoints()) do
				local result = ((self.points[2].x - self.points[1].x) * (point.y - self.points[1].y) - (self.points[2].y - self.points[1].y) * (point.x - self.points[1].x))

				if result < 0 then
					leftPoints = leftPoints + 1
				elseif result > 0 then
					rightPoints = rightPoints + 1
				else
					onPoints = onPoints + 1
				end
			end

			if leftPoints ~= 0 and rightPoints == 0 and onPoints == 0 then
				return -1
			elseif leftPoints == 0 and rightPoints ~= 0 and onPoints == 0 then
				return 1
			else
				return 0
			end
		end

		function Line2:contains(spatialObject)
			if spatialObject:__type() == "Point2" then
				return spatialObject:distance(self) == 0
			elseif spatialObject:__type() == "Line2" then
				return self.points[1]:distance(spatialObject) == 0 and self.points[2]:distance(spatialObject) == 0
			elseif spatialObject:__type() == "Circle2" then
				return spatialObject.point:distance(self) == 0 and spatialObject.radius == 0
			elseif spatialObject:__type() == "LineSegment2" then
				return spatialObject.points[1]:distance(self) == 0 and spatialObject.points[2]:distance(self) == 0
			else
			for i, point in ipairs(spatialObject:getPoints()) do
				if point:distance(self) ~= 0 then
					return false
				end
				end

				return true
			end

			return false
		end

		function Line2:insideOf(spatialObject)
			return spatialObject:contains(self)
		end

		function Line2:distance(spatialObject)
			if spatialObject == nil then return 0 end
			if spatialObject:__type() == "Circle2" then
				return spatialObject.point:distance(self) - spatialObject.radius
			elseif spatialObject:__type() == "Line2" then
				distance1 = self.points[1]:distance(spatialObject)
				distance2 = self.points[2]:distance(spatialObject)
				if distance1 ~= distance2 then
					return 0
				else
					return distance1
				end
			else
				local minDistance = nil
				for i, point in ipairs(spatialObject:getPoints()) do
					distance = point:distance(self)
					if minDistance == nil or distance <= minDistance then
						minDistance = distance
					end
				end

				return minDistance
			end
		end

	class 'Circle2' -- {
		function Circle2:__init(point, radius)
			uniqueId2 = uniqueId2 + 1
			self.uniqueId2 = uniqueId2

			self.point = point
			self.radius = radius

			self.points = {self.point}
		end

		function Circle2:__type()
			return "Circle2"
		end

		function Circle2:__eq(spatialObject)
			return spatialObject:__type() == "Circle2" and (self.point == spatialObject.point and self.radius == spatialObject.radius)
		end

		function Circle2:getPoints()
			return self.points
		end

		function Circle2:getLineSegments()
			return {}
		end

		function Circle2:contains(spatialObject)
			if spatialObject:__type() == "Line2" then
				return false
			elseif spatialObject:__type() == "Circle2" then
				return self.radius >= spatialObject.radius + self.point:distance(spatialObject.point)
			else
				for i, point in ipairs(spatialObject:getPoints()) do
					if self.point:distance(point) >= self.radius then
						return false
					end
				end

				return true
			end
		end

		function Circle2:insideOf(spatialObject)
			return spatialObject:contains(self)
		end

		function Circle2:distance(spatialObject)
			return self.point:distance(spatialObject) - self.radius
		end

		function Circle2:intersectionPoints(spatialObject)
			local result = {}

			dx = self.point.x - spatialObject.point.x
			dy = self.point.y - spatialObject.point.y
			dist = math.sqrt(dx * dx + dy * dy)

			if dist > self.radius + spatialObject.radius then
				return result
			elseif dist < math.abs(self.radius - spatialObject.radius) then
				return result
			elseif (dist == 0) and (self.radius == spatialObject.radius) then
				return result
			else
				a = (self.radius * self.radius - spatialObject.radius * spatialObject.radius + dist * dist) / (2 * dist)
				h = math.sqrt(self.radius * self.radius - a * a)

				cx2 = self.point.x + a * (spatialObject.point.x - self.point.x) / dist
				cy2 = self.point.y + a * (spatialObject.point.y - self.point.y) / dist

				intersectionx1 = cx2 + h * (spatialObject.point.y - self.point.y) / dist
				intersectiony1 = cy2 - h * (spatialObject.point.x - self.point.x) / dist
				intersectionx2 = cx2 - h * (spatialObject.point.y - self.point.y) / dist
				intersectiony2 = cy2 + h * (spatialObject.point.x - self.point.x) / dist

				table.insert(result, Point2(intersectionx1, intersectiony1))

				if intersectionx1 ~= intersectionx2 or intersectiony1 ~= intersectiony2 then
					table.insert(result, Point2(intersectionx2, intersectiony2))
				end
			end

			return result
		end

		function Circle2:tostring()
			return "Circle2(Point2(" .. self.point.x .. ", " .. self.point.y .. "), " .. self.radius .. ")"
		end

	class 'LineSegment2' -- {
		function LineSegment2:__init(point1, point2)
			uniqueId2 = uniqueId2 + 1
			self.uniqueId2 = uniqueId2

			self.points = {point1, point2}
		end

		function LineSegment2:__type()
			return "LineSegment2"
		end

		function LineSegment2:__eq(spatialObject)
			return spatialObject:__type() == "LineSegment2" and ((self.points[1] == spatialObject.points[1] and self.points[2] == spatialObject.points[2]) or (self.points[2] == spatialObject.points[1] and self.points[1] == spatialObject.points[2]))
		end

		function LineSegment2:getPoints()
			return self.points
		end

		function LineSegment2:getLineSegments()
			return {self}
		end

		function LineSegment2:direction()
			return self.points[2] - self.points[1]
		end

		function LineSegment2:len()
			return (self.points[1] - self.points[2]):len()
		end

		function LineSegment2:contains(spatialObject)
			if spatialObject:__type() == "Point2" then
				return spatialObject:distance(self) == 0
			elseif spatialObject:__type() == "Line2" then
				return false
			elseif spatialObject:__type() == "Circle2" then
				return spatialObject.point:distance(self) == 0 and spatialObject.radius == 0
			elseif spatialObject:__type() == "LineSegment2" then
				return spatialObject.points[1]:distance(self) == 0 and spatialObject.points[2]:distance(self) == 0
			else
			for i, point in ipairs(spatialObject:getPoints()) do
				if point:distance(self) ~= 0 then
					return false
				end
				end

				return true
			end

			return false
		end

		function LineSegment2:insideOf(spatialObject)
			return spatialObject:contains(self)
		end

		function LineSegment2:distance(spatialObject)
			if spatialObject:__type() == "Circle2" then
				return spatialObject.point:distance(self) - spatialObject.radius
			elseif spatialObject:__type() == "Line2" then
				return math.min(self.points[1]:distance(spatialObject), self.points[2]:distance(spatialObject))
			else
				local minDistance = nil
				for i, point in ipairs(spatialObject:getPoints()) do
					distance = point:distance(self)
					if minDistance == nil or distance <= minDistance then
						minDistance = distance
					end
				end

				return minDistance
			end
		end

		function LineSegment2:intersects(spatialObject)
			return #self:intersectionPoints(spatialObject) >= 1
		end

		function LineSegment2:intersectionPoints(spatialObject)
			if spatialObject:__type()  == "LineSegment2" then
				d = (spatialObject.points[2].y - spatialObject.points[1].y) * (self.points[2].x - self.points[1].x) - (spatialObject.points[2].x - spatialObject.points[1].x) * (self.points[2].y - self.points[1].y)

				if d ~= 0 then
					ua = ((spatialObject.points[2].x - spatialObject.points[1].x) * (self.points[1].y - spatialObject.points[1].y) - (spatialObject.points[2].y - spatialObject.points[1].y) * (self.points[1].x - spatialObject.points[1].x)) / d
					ub = ((self.points[2].x - self.points[1].x) * (self.points[1].y - spatialObject.points[1].y) - (self.points[2].y - self.points[1].y) * (self.points[1].x - spatialObject.points[1].x)) / d

					if ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1 then
						return {Point2 (self.points[1].x + (ua * (self.points[2].x - self.points[1].x)), self.points[1].y + (ua * (self.points[2].y - self.points[1].y)))}
					end
				end
			end

			return {}
		end

		function LineSegment2:draw(color, width)
			drawLine(self, color or 0XFF00FF00, width or 4)
		end

	class 'Polygon2' -- {
		function Polygon2:__init(...)
			uniqueId2 = uniqueId2 + 1
			self.uniqueId2 = uniqueId2

			self.points = {...}
		end

		function Polygon2:__type()
			return "Polygon2"
		end

		function Polygon2:__eq(spatialObject)
			return spatialObject:__type() == "Polygon2" -- TODO
		end

		function Polygon2:getPoints()
			return self.points
		end

		function Polygon2:addPoint(point)
			table.insert(self.points, point)
			self.lineSegments = nil
			self.triangles = nil
		end

		function Polygon2:getLineSegments()
			if self.lineSegments == nil then
				self.lineSegments = {}
				for i = 1, #self.points, 1 do
					table.insert(self.lineSegments, LineSegment2(self.points[i], self.points[(i % #self.points) + 1]))
				end
			end

			return self.lineSegments
		end

		function Polygon2:contains(spatialObject)
			if spatialObject:__type() == "Line2" then
				return false
			elseif #self.points == 3 then
				for i, point in ipairs(spatialObject:getPoints()) do
					corner1DotCorner2 = ((point.y - self.points[1].y) * (self.points[2].x - self.points[1].x)) - ((point.x - self.points[1].x) * (self.points[2].y - self.points[1].y))
					corner2DotCorner3 = ((point.y - self.points[2].y) * (self.points[3].x - self.points[2].x)) - ((point.x - self.points[2].x) * (self.points[3].y - self.points[2].y))
					corner3DotCorner1 = ((point.y - self.points[3].y) * (self.points[1].x - self.points[3].x)) - ((point.x - self.points[3].x) * (self.points[1].y - self.points[3].y))

					if not (corner1DotCorner2 * corner2DotCorner3 >= 0 and corner2DotCorner3 * corner3DotCorner1 >= 0) then
						return false
					end
				end

				if spatialObject:__type() == "Circle2" then
					for i, lineSegment in ipairs(self:getLineSegments()) do
						if spatialObject.point:distance(lineSegment) <= 0 then
							return false
						end
					end
				end

				return true
			else
				for i, point in ipairs(spatialObject:getPoints()) do
					inTriangles = false
					for j, triangle in ipairs(self:triangulate()) do
						if triangle:contains(point) then
							inTriangles = true
							break
						end
					end
					if not inTriangles then
						return false
					end
				end

				return true
			end
		end

		function Polygon2:insideOf(spatialObject)
			return spatialObject.contains(self)
		end

		function Polygon2:direction()
			if self.directionValue == nil then
				local rightMostPoint = nil
				local rightMostPointIndex = nil
				for i, point in ipairs(self.points) do
					if rightMostPoint == nil or point.x >= rightMostPoint.x then
						rightMostPoint = point
						rightMostPointIndex = i
					end
				end

				rightMostPointPredecessor = self.points[(rightMostPointIndex - 1 - 1) % #self.points + 1]
				rightMostPointSuccessor   = self.points[(rightMostPointIndex + 1 - 1) % #self.points + 1]

				z = (rightMostPoint.x - rightMostPointPredecessor.x) * (rightMostPointSuccessor.y - rightMostPoint.y) - (rightMostPoint.y - rightMostPointPredecessor.y) * (rightMostPointSuccessor.x - rightMostPoint.x)
				if z > 0 then
					self.directionValue = 1
				elseif z < 0 then
					self.directionValue = -1
				else
					self.directionValue = 0
				end
			end

			return self.directionValue
		end

		function Polygon2:triangulate()
			if self.triangles == nil then
				self.triangles = {}

				if #self.points > 3 then
					tempPoints = {}
					for i, point in ipairs(self.points) do
						table.insert(tempPoints, point)
					end
			
					triangleFound = true
					while #tempPoints > 3 and triangleFound do
						triangleFound = false
						for i, point in ipairs(tempPoints) do
							point1Index = (i - 1 - 1) % #tempPoints + 1
							point2Index = (i + 1 - 1) % #tempPoints + 1

							point1 = tempPoints[point1Index]
							point2 = tempPoints[point2Index]

							if ((((point1.x - point.x) * (point2.y - point.y) - (point1.y - point.y) * (point2.x - point.x))) * self:direction()) < 0 then
								triangleCandidate = Polygon2(point1, point, point2)

								anotherPointInTriangleFound = false
								for q = 1, #tempPoints, 1 do
									if q ~= i and q ~= point1Index and q ~= point2Index and triangleCandidate:contains(tempPoints[q]) then
										anotherPointInTriangleFound = true
										break
									end
								end

								if not anotherPointInTriangleFound then
									table.insert(self.triangles, triangleCandidate)
									table.remove(tempPoints, i)
									i = i - 1

									triangleFound = true
								end
							end
						end
					end

					if #tempPoints == 3 then
						table.insert(self.triangles, Polygon2(tempPoints[1], tempPoints[2], tempPoints[3]))
					end
				elseif #self.points == 3 then
					table.insert(self.triangles, self)
				end
			end

			return self.triangles
		end

		function Polygon2:intersects(spatialObject)
			for i, lineSegment1 in ipairs(self:getLineSegments()) do
				for j, lineSegment2 in ipairs(spatialObject:getLineSegments()) do
					if lineSegment1:intersects(lineSegment2) then
						return true
					end
				end
			end

			return false
		end

		function Polygon2:distance(spatialObject)
			local minDistance = nil
			for i, lineSegment in ipairs(self:getLineSegment()) do
				distance = point:distance(self)
				if minDistance == nil or distance <= minDistance then
					minDistance = distance
				end
			end

			return minDistance
		end

		function Polygon2:tostring()
			local result = "Polygon2("

			for i, point in ipairs(self.points) do
				if i == 1 then
					result = result .. point:tostring()
				else
					result = result .. ", " .. point:tostring()
				end
			end

			return result .. ")"
		end

		function Polygon2:draw(color, width)
			for i, lineSegment in ipairs(self:getLineSegments()) do
				lineSegment:draw(color, width)
			end
		end
end
do -- object managers
	class "MinionManager"

	function MinionManager:__init()
		self.objects = {}
		self.maxObjects = 0
		Callback.Add("ObjectLoad", function(o) self:CreateObj(o) end)
		Callback.Add("CreateObj", function(o) self:CreateObj(o) end)
	end

	function MinionManager:CreateObj(o)
		if o and GetObjectType(o) == Obj_AI_Minion then
			if o.name:find('_') then
				self:insert(o)
			end
		end
	end

	function MinionManager:insert(o)
		local function FindSpot()
			for i=1, self.maxObjects do
				local o = self.objects[i]
				if not o or not IsObjectAlive(o) then
					return i
				end
			end
			self.maxObjects = self.maxObjects + 1
			return self.maxObjects
		end
		self.objects[FindSpot()] = o
	end
	_G.minionManager = _G.minionManager or MinionManager()

	function GetMinions(_)
		return GetObjects(_,minionManager.objects,minionManager.maxObjects)
	end
	local iheroes
	function GetHeroes(_)
		if not iheroes then
			iheroes = {}
			for i=1, heroManager.iCount do
				table.insert(iheroes, heroManager:getHero(i))
			end
		end
		return GetObjects(_,iheroes,heroManager.iCount)
	end

	function GetObjects(_,__,___)
		local i,o,c=0,__,___ or#__
		local function cpairs(_)
			local function IsOk(m,_)if m and m.valid and not m.dead then for k,v in pairs(_)do if(k=="distance")then if m[k]>v then return false end elseif(type(v)=="function"and not v(m)) or not m[k] or m[k]~=v then return false end end return true else return false end end
			i=1+i if i>c then return end local m=o[i]
			while not IsOk(m,_)do i=1+i if i>c then return end m=o[i]end
			return m
		end
		return cpairs,_ or{}
	end
end
do -- sprite class
	class "Sprite"

	function Sprite:__init(path, width, height, x, y, scale)
		scale = math.max(0, scale or 1)
		self.scale = scale
		self.id = CreateSpriteFromFile("\\"..path, self.scale)
		self.path = path
		self.x, self.y, self.sx, self.sy, self.w, self.h, self.color = 0, 0, x or 0, y or 0, width or 1, height or 1, ARGB(255,255,255,255)
		self.pos = { x = self.x, y = self.y }
		self.callbacks = {}
		self.Callback = {
			Add = function(which, what, posFunc)
				self.callbacks[which] = Callback.Add(which, function(...)
					if VecIsUnder(posFunc and posFunc() or GetCursorPos(), self.x, self.y, (self.w-self.sx)*self.scale, (self.h-self.sy)*self.scale) then
						what(...)
					end
				end)
			end,
			Del = function(which, what)
				Callback.Del(which, self.callbacks[which])
			end
		}
		self.width, self.height = self.w*self.scale, self.h*self.scale
	end

	function Sprite:Scale(scale)
		ReleaseSprite(self.id)
		scale = math.max(0, scale or 1)
		self.scale = scale
		self.id = CreateSpriteFromFile("\\"..self.path, scale or 1)
		self.width, self.height = self.w*self.scale, self.h*self.scale
	end

	function Sprite:Color(c)
		if c == nil then return self.color end
		self.color = c
	end

	function Sprite:Release()
		ReleaseSprite(self.id)
	end

	function Sprite:Draw(x, y, color, w, h, sx, sy)
		self.x, self.y, self.sx, self.sy, self.w, self.h = x or self.pos.x or 0, y or self.pos.y or 0, sx or self.sx, sy or self.sy, w or self.w, h or self.h
		self.pos = { x = self.x, y = self.y }
		DrawSprite(self.id, self.x, self.y, self.sx*self.scale, self.sy*self.scale, self.w*self.scale, self.h*self.scale, self.color or color or ARGB(255,255,255,255))
	end
end
do -- notify class
	Notify = { notifications = {}, time = 10, speed = 8.3 }

	function Notify.Add(header, text, time)
		table.insert(Notify.notifications, {header=header,text=text or"",time=time or Notify.time,t=os.clock(),x=250})
	end

	function Notify.Tick()
		for i=1, #Notify.notifications do
			local n = Notify.notifications[i]
			if n then
				if n.t+n.time<os.clock() then
					table.remove(Notify.notifications, i)
				elseif n.t+n.time-1<os.clock() then
					Notify.notifications[i].x = n.x + Notify.speed
				else
					Notify.notifications[i].x = math.max(0, n.x - Notify.speed)
				end
			end
		end
	end

	function Notify.Draw()
		for i=1, #Notify.notifications do
			local n = Notify.notifications[i]
			if n then
				FillRect(WINDOW_W-260+n.x,85*i+190,270,95,CursorIsUnder(WINDOW_W-260+n.x,85*i+190,270,95) and 0x17ffffff or 0x07ffffff)
				FillRect(WINDOW_W-250+n.x,85*i+200,250,75,0xaf000000)
				DrawTextOutline(n.header,25,WINDOW_W-245+n.x,85*i+200)
				DrawTextOutline(n.text,20,WINDOW_W-245+n.x,85*i+235)
			end
		end
	end

	function Notify.WndMsg(msg, key)
		if key == 0 and msg == 513 then
			for i=1, #Notify.notifications do
				if CursorIsUnder(WINDOW_W-260+Notify.notifications[i].x,85*i+190,270,95) then
					Notify.notifications[i].t = os.clock()-Notify.notifications[i].time+1
				end
			end
		end
	end

	Callback.Add("Draw", Notify.Draw)
	Callback.Add("Tick", Notify.Tick)
	Callback.Add("WndMsg", Notify.WndMsg)
end
do -- waypoint manager
end
do -- auto updater class
	class "AutoUpdater" function AutoUpdater:__init(LocalVersion, UseHttps, Host, VersionPath, ScriptPath, SavePath, CallbackUpdate, CallbackNoUpdate, CallbackNewVersion, CallbackError)
		self.LocalVersion = LocalVersion
		self.Host = Host
		self.VersionPath = '/GOS/TCPUpdater/GetScript' .. (UseHttps and '5' or '6') .. '.php?script=' .. Base64Encode(self.Host .. VersionPath) .. '&rand=' .. math.random(99999999)
		self.ScriptPath = '/GOS/TCPUpdater/GetScript' .. (UseHttps and '5' or '6') .. '.php?script=' .. Base64Encode(self.Host .. ScriptPath) .. '&rand=' .. math.random(99999999)
		self.SavePath = SavePath
		self.CallbackUpdate = CallbackUpdate
		self.CallbackNoUpdate = CallbackNoUpdate
		self.CallbackNewVersion = CallbackNewVersion
		self.CallbackError = CallbackError
		self:CreateSocket(self.VersionPath)
		if type(VersionPath) == "number" then
			self.GotScriptVersion = true
			self.OnlineVersion = VersionPath
		end
		self.DownloadStatus = 'Connect to Server for VersionInfo'
		Callback.Add("Tick", function () self:GetOnlineVersion() end)
		return self
	end
	 
	function AutoUpdater:print(str)
		PrintChat('<font color="#FFFFFF">' .. (GetTickCount() / 1000) .. ': ' .. str)
	end
	 
	function AutoUpdater:CreateSocket(url)
		if not self.LuaSocket then
			self.LuaSocket = require("socket")
		else
			self.Socket:close()
			self.Socket = nil
			self.Size = nil
			self.RecvStarted = false
		end
		self.LuaSocket = require("socket")
		self.Socket = self.LuaSocket.tcp()
		self.Socket:settimeout(0, 'b')
		self.Socket:settimeout(99999999, 't')
		self.Socket:connect('gamingonsteroids.com', 80)
		self.Url = url
		self.Started = false
		self.LastPrint = ""
		self.File = ""
	end
	 
	function AutoUpdater:GetOnlineVersion()
		if self.GotScriptVersion then return end
	 
		self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
		if self.Status == 'timeout' and not self.Started then
			self.Started = true
			self.Socket:send("GET " .. self.Url .. " HTTP/1.1\r\nHost: gamingonsteroids.com\r\n\r\n")
		end
		if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
			self.RecvStarted = true
			self.DownloadStatus = 'Downloading VersionInfo (0%)'
		end
		self.File = self.File .. (self.Receive or self.Snipped)
		if self.File:find('</s' .. 'ize>') then
			if not self.Size then
				self.Size = tonumber(self.File:sub(self.File:find('<si' .. 'ze>') + 6, self.File:find('</si' .. 'ze>') - 1))
			end
			if self.File:find('<scr' .. 'ipt>') then
				local _, ScriptFind = self.File:find('<scr' .. 'ipt>')
				local ScriptEnd = self.File:find('</scr' .. 'ipt>')
				if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
				local DownloadedSize = self.File:sub(ScriptFind + 1, ScriptEnd or -1):len()
				self.DownloadStatus = 'Downloading VersionInfo (' .. math.round(100 / self.Size * DownloadedSize, 2) .. '%)'
			end
		end
		if self.File:find('</scr' .. 'ipt>') then
			self.DownloadStatus = 'Downloading VersionInfo (100%)'
			local a, b = self.File:find('\r\n\r\n')
			self.File = self.File:sub(a, -1)
			self.NewFile = ''
			for line, content in ipairs(self.File:split('\n')) do
				if content:len() > 5 then
					self.NewFile = self.NewFile .. content
				end
			end
			local HeaderEnd, ContentStart = self.File:find('<scr' .. 'ipt>')
			local ContentEnd, _ = self.File:find('</sc' .. 'ript>')
			if not ContentStart or not ContentEnd then
				if self.CallbackError and type(self.CallbackError) == 'function' then
					self.CallbackError()
				end
			else
				self.OnlineVersion = (Base64Decode(self.File:sub(ContentStart + 1, ContentEnd - 1)))
				self.OnlineVersion = tonumber(self.OnlineVersion)
				if not self.OnlineVersion or not self.LocalVersion then
					if self.CallbackError and type(self.CallbackError) == 'function' then
						self.CallbackError()
					end
				elseif self.OnlineVersion > self.LocalVersion then
					if self.CallbackNewVersion and type(self.CallbackNewVersion) == 'function' then
						self.CallbackNewVersion(self.OnlineVersion, self.LocalVersion)
					end
					self:CreateSocket(self.ScriptPath)
					self.DownloadStatus = 'Connect to Server for ScriptDownload'
					OnTick(function () self:DownloadUpdate() end)
				else
					if self.CallbackNoUpdate and type(self.CallbackNoUpdate) == 'function' then
						self.CallbackNoUpdate(self.LocalVersion)
					end
				end
			end
			self.GotScriptVersion = true
		end
	end
	 
	function AutoUpdater:DownloadUpdate()
		if self.GotAutoUpdater then return end
		self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
		if self.Status == 'timeout' and not self.Started then
			self.Started = true
			self.Socket:send("GET " .. self.Url .. " HTTP/1.1\r\nHost: gamingonsteroids.com\r\n\r\n")
		end
		if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
			self.RecvStarted = true
			self.DownloadStatus = 'Downloading Script (0%)'
		end
	 
		self.File = self.File .. (self.Receive or self.Snipped)
		if self.File:find('</si' .. 'ze>') then
			if not self.Size then
				self.Size = tonumber(self.File:sub(self.File:find('<si' .. 'ze>') + 6, self.File:find('</si' .. 'ze>') - 1))
			end
			if self.File:find('<scr' .. 'ipt>') then
				local _, ScriptFind = self.File:find('<scr' .. 'ipt>')
				local ScriptEnd = self.File:find('</scr' .. 'ipt>')
				if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
				local DownloadedSize = self.File:sub(ScriptFind + 1, ScriptEnd or -1):len()
				self.DownloadStatus = 'Downloading Script (' .. math.round(100 / self.Size * DownloadedSize, 2) .. '%)'
			end
		end
		if self.File:find('</scr' .. 'ipt>') then
			self.DownloadStatus = 'Downloading Script (100%)'
			local a, b = self.File:find('\r\n\r\n')
			self.File = self.File:sub(a, -1)
			self.NewFile = ''
			for line, content in ipairs(self.File:split('\n')) do
				if content:len() > 5 then
					self.NewFile = self.NewFile .. content
				end
			end
			local HeaderEnd, ContentStart = self.NewFile:find('<sc' .. 'ript>')
			local ContentEnd, _ = self.NewFile:find('</scr' .. 'ipt>')
			if not ContentStart or not ContentEnd then
				if self.CallbackError and type(self.CallbackError) == 'function' then
					self.CallbackError()
				end
			else
				local newf = self.NewFile:sub(ContentStart + 1, ContentEnd - 1)
				local newf = string.gsub(newf, '\r', '')
				if newf:len() ~= self.Size then
					if self.CallbackError and type(self.CallbackError) == 'function' then
						self.CallbackError()
					end
					return
				end
				local f = io.open(self.SavePath, "w+b")
				f:write(Base64Decode(newf))
				f:close()
				if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
					self.CallbackUpdate(self.OnlineVersion, self.LocalVersion)
				end
			end
			self.GotAutoUpdater = true
		end
	end
end
do -- other functions
	function AddGapcloseEvent(spell, range, targeted, cfg)
		GapcloseSpell = spell
		GapcloseTime = 0
		GapcloseUnit = nil
		GapcloseTargeted = targeted
		GapcloseRange = range
		GoS.str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
		GapcloseConfig = cfg or Menu("Anti-Gapclose ("..GoS.str[spell]..")", "gapclose")
		DelayAction(function()
			for _,k in pairs(GetEnemyHeroes()) do
			  if GoS.gapcloserTable[GetObjectName(k)] then
				GapcloseConfig:Boolean(GetObjectName(k).."agap", "On "..GetObjectName(k).." "..(type(GoS.gapcloserTable[GetObjectName(k)]) == 'number' and GoS.str[GoS.gapcloserTable[GetObjectName(k)]] or (GetObjectName(k) == "LeeSin" and "Q" or "E")), true)
			  end
			end
		end, 1)
		Callback.Add("ProcessSpell", function(unit, spell)
		  if not unit or not GoS.gapcloserTable[GetObjectName(unit)] or GapcloseConfig[GetObjectName(unit).."agap"] == nil or not GapcloseConfig[GetObjectName(unit).."agap"]:Value() then return end
		  local unitName = GetObjectName(unit)
		  if spell.name == (type(GoS.gapcloserTable[unitName]) == 'number' and GetCastName(unit, GoS.gapcloserTable[unitName]) or GoS.gapcloserTable[unitName]) and (spell.target == myHero or GetDistanceSqr(spell.endPos) < GapcloseRange*GapcloseRange*4) then
			GapcloseTime = GetTickCount() + 2000
			GapcloseUnit = unit
		  end
		end)
		Callback.Add("Tick", function(myHero)
		  if CanUseSpell(myHero, GapcloseSpell) == READY and GapcloseTime and GapcloseUnit and GapcloseTime >GetTickCount() then
			local pos = GetOrigin(GapcloseUnit)
			if GapcloseTargeted then
			  if GetDistanceSqr(pos,myHero.pos) < GapcloseRange*GapcloseRange then
				CastTargetSpell(GapcloseUnit, GapcloseSpell)
			  end
			else 
			  if GetDistanceSqr(pos,myHero.pos) < GapcloseRange*GapcloseRange*4 then
				CastSkillShot(GapcloseSpell, pos.x, pos.y, pos.z)
			  end
			end
		  else
			GapcloseTime = 0
			GapcloseUnit = nil
		  end
		end)
	end

	function myHeroPos()
		return myHero.pos
	end

	function GetDistanceSqr(p1, p2)
		p2 = p2 or myHero.pos
		local dx = p1.x - p2.x
		local dz = (p1.z or p1.y) - (p2.z or p2.y)
		return dx*dx + dz*dz
	end

	function GetDistance(p1, p2)
		return math.sqrt(GetDistanceSqr(p1, p2))
	end

	function ctype(t)
		local _type = type(t)
		if _type == "userdata" then
			local metatable = getmetatable(t)
			if not metatable or not metatable.__index then
				t, _type = "userdata", "string"
			end
		end
		if _type == "userdata" or _type == "table" then
			local _getType = t.__type or t.type or t.Type
			_type = type(_getType)=="function" and _getType(t) or type(_getType)=="string" and _getType or _type
		end
		return _type
	end

	function ctostring(t)
		local _type = type(t)
		if _type == "userdata" then
			local metatable = getmetatable(t)
			if not metatable or not metatable.__index then
				t, _type = "userdata", "string"
			end
		end
		if _type == "userdata" or _type == "table" then
			local _tostring = t.tostring or t.toString or t.__tostring
			if type(_tostring)=="function" then
				local tstring = _tostring(t)
				t = _tostring(t)
			else
				local _ctype = ctype(t) or "Unknown"
				if _type == "table" then
					t = tostring(t):gsub(_type,_ctype) or tostring(t)
				else
					t = _ctype
				end
			end
		end
		return tostring(t)
	end

	function print(...)
		local t, len = {}, select("#",...)
		for i=1, len do
			local v = select(i,...)
			local _type = ctype(v)
			if _type == "string" then t[i] = v
			elseif _type == "Object" then t[i] = "Object: "..v.charName
			elseif _type == "Vector" then t[i] = tostring(v)
			elseif _type == "number" then t[i] = tostring(v)
			elseif _type == "table" then t[i] = table.serialize(v)
			elseif _type == "boolean" then t[i] = ({[true]="True",[false]="False"})[v]
			elseif _type == "userdata" then t[i] = ctostring(v)
			elseif _type == "function" then t[i] = ""
			else t[i] = _type
			end
		end
		if len>0 then PrintChat(table.concat(t)) end
	end

	function ValidTarget(object, distance, enemyTeam)
		local enemyTeam = (enemyTeam ~= false)
		return object ~= nil and object.valid and (object.team ~= myHero.team) == enemyTeam and object.visible and not object.dead and object.isTargetable and (enemyTeam == false or object.isInvulnerable == false) and (distance == nil or GetDistanceSqr(object) <= distance * distance)
	end

	function ValidTargetNear(object, distance, target)
		return object ~= nil and object.valid and object.team == target.team and object.networkID ~= target.networkID and object.visible and not object.dead and object.bTargetable and GetDistanceSqr(target, object) <= distance * distance
	end

	function GetDistanceFromMouse(object)
		if object ~= nil and VectorType(object) then return GetDistance(object, mousePos) end
		return math.huge
	end

	local _enemyHeroes
	function GetEnemyHeroes()
		if _enemyHeroes then return _enemyHeroes end
		_enemyHeroes = {}
		for i = 1, heroManager.iCount do
			local hero = heroManager:GetHero(i)
			if hero.team ~= myHero.team then
				table.insert(_enemyHeroes, hero)
			end
		end
		return setmetatable(_enemyHeroes,{
			__newindex = function(self, key, value)
				error("Adding to EnemyHeroes is not granted. Use table.copy.")
			end,
		})
	end

	local _allyHeroes
	function GetAllyHeroes()
		if _allyHeroes then return _allyHeroes end
		_allyHeroes = {}
		for i = 1, heroManager.iCount do
			local hero = heroManager:GetHero(i)
			if hero.team == myHero.team and hero.networkID ~= myHero.networkID then
				table.insert(_allyHeroes, hero)
			end
		end
		return setmetatable(_allyHeroes,{
			__newindex = function(self, key, value)
				error("Adding to AllyHeroes is not granted. Use table.copy.")
			end,
		})
	end

	function GetDrawClock(time, offset)
		time, offset = time or 1, offset or 0
		return (os.clock() + offset) % time / time
	end

	function table.clear(t)
		for i, v in pairs(t) do
			t[i] = nil
		end
	end

	function table.copy(from, deepCopy)
		if type(from) == "table" then
			local to = {}
			for k, v in pairs(from) do
				if deepCopy and type(v) == "table" then to[k] = table.copy(v)
				else to[k] = v
				end
			end
			return to
		end
	end

	function table.contains(t, what, member) --member is optional
		assert(type(t) == "table", "table.contains: wrong argument types (<table> expected for t)")
		for i, v in pairs(t) do
			if member and v[member] == what or v == what then return i, v end
		end
	end

	function table.serialize(t, tab, functions)
		assert(type(t) == "table", "table.serialize: Wrong Argument, table expected")
		local s, len = {"{\n"}, 1
		for i, v in pairs(t) do
			local iType, vType = type(i), type(v)
			if vType~="userdata" and (functions or vType~="function") then
				if tab then 
					s[len+1] = tab 
					len = len + 1
				end
				s[len+1] = "\t"
				if iType == "number" then
					s[len+2], s[len+3], s[len+4] = "[", i, "]"
				elseif iType == "string" then
					s[len+2], s[len+3], s[len+4] = '["', i, '"]'
				end
				s[len+5] = " = "
				if vType == "number" then 
					s[len+6], s[len+7], len = v, ",\n", len + 7
				elseif vType == "string" then 
					s[len+6], s[len+7], s[len+8], len = '"', v:unescape(), '",\n', len + 8
				elseif vType == "table" then 
					s[len+6], s[len+7], len = table.serialize(v, (tab or "") .. "\t", functions), ",\n", len + 7
				elseif vType == "boolean" then 
					s[len+6], s[len+7], len = tostring(v), ",\n", len + 7
				elseif vType == "function" and functions then
					local dump = string.dump(v)
					s[len+6], s[len+7], s[len+8], len = "load(Base64Decode(\"", Base64Encode(dump, #dump), "\")),\n", len + 8
				end
			end
		end
		if tab then 
			s[len+1] = tab
			len = len + 1
		end
		s[len+1] = "}"
		return table.concat(s)
	end

	function table.merge(base, t, deepMerge)
		for i, v in pairs(t) do
			if deepMerge and type(v) == "table" and type(base[i]) == "table" then
				base[i] = table.merge(base[i], v)
			else base[i] = v
			end
		end
		return base
	end

	--from http://lua-users.org/wiki/SplitJoin
	function string.split(str, delim, maxNb)
		-- Eliminate bad cases...
		if not delim or delim == "" or string.find(str, delim) == nil then
			return { str }
		end
		maxNb = (maxNb and maxNb >= 1) and maxNb or 0
		local result = {}
		local pat = "(.-)" .. delim .. "()"
		local nb = 0
		local lastPos
		for part, pos in string.gmatch(str, pat) do
			nb = nb + 1
			if nb == maxNb then
				result[nb] = lastPos and string.sub(str, lastPos, #str) or str
				break
			end
			result[nb] = part
			lastPos = pos
		end
		-- Handle the last field
		if nb ~= maxNb then
			result[nb + 1] = string.sub(str, lastPos)
		end
		return result
	end

	function string.join(arg, del)
		return table.concat(arg, del)
	end

	function string.trim(s)
		return s:match'^%s*(.*%S)' or ''
	end

	function string.unescape(s)
		return s:gsub(".",{
			["\a"] = [[\a]],
			["\b"] = [[\b]],
			["\f"] = [[\f]],
			["\n"] = [[\n]],
			["\r"] = [[\r]],
			["\t"] = [[\t]],
			["\v"] = [[\v]],
			["\\"] = [[\\]],
			['"'] = [[\"]],
			["'"] = [[\']],
			["["] = "\\[",
			["]"] = "\\]",
			})
	end

	function math.isNaN(num)
		return num ~= num
	end

	-- Round half away from zero
	function math.round(num, idp)
		assert(type(num) == "number", "math.round: wrong argument types (<number> expected for num)")
		assert(type(idp) == "number" or idp == nil, "math.round: wrong argument types (<integer> expected for idp)")
		local mult = 10 ^ (idp or 0)
		if num >= 0 then return math.floor(num * mult + 0.5) / mult
		else return math.ceil(num * mult - 0.5) / mult
		end
	end

	function math.close(a, b, eps)
		assert(type(a) == "number" and type(b) == "number", "math.close: wrong argument types (at least 2 <number> expected)")
		eps = eps or 1e-9
		return math.abs(a - b) <= eps
	end

	function math.limit(val, min, max)
		assert(type(val) == "number" and type(min) == "number" and type(max) == "number", "math.limit: wrong argument types (3 <number> expected)")
		return math.min(max, math.max(min, val))
	end

	local fps, avgFps, frameCount, fFrame, lastFrame, updateFPS = 0, 0, 0, -math.huge, -math.huge, nil
	local function startFPSCounter()
		if not updateFPS then
			function updateFPS()
				fps = 1 / (os.clock() - lastFrame)
				lastFrame, frameCount = os.clock(), frameCount + 1
				if os.clock() < 0.5 + fFrame then return end
				avgFps = math.floor(frameCount / (os.clock() - fFrame))
				fFrame, frameCount = os.clock(), 0
			end

			Callback.Add("Draw", updateFPS)
		end
	end

	function GetExactFPS()
		startFPSCounter()
		return fps
	end

	function GetFPS()
		startFPSCounter()
		return avgFps
	end

	local _saves, _initSave, lastSave = {}, true, GetTickCount()
	function GetSave(name)
		local save
		if not _saves[name] then
			if FileExist(COMMON_PATH .. "\\" .. name .. ".save") then
				local f = loadfile(COMMON_PATH .. "\\" .. name .. ".save")
				if type(f) == "function" then
					_saves[name] = f()
				end
			else
				_saves[name] = {}
			end
		end
		save = _saves[name]
		if not save then
			print("SaveFile: " .. name .. " is broken. Reset.")
			_saves[name] = {}
			save = _saves[name]
		end
		function save:Save()
			local _save, _reload, _clear, _isempty, _remove = self.Save, self.Reload, self.Clear, self.IsEmpty, self.Remove
			self.Save, self.Reload, self.Clear, self.IsEmpty, self.Remove = nil, nil, nil, nil, nil
			WriteFile("return "..table.serialize(self, nil, true), COMMON_PATH .. "\\" .. name .. ".save")
			self.Save, self.Reload, self.Clear, self.IsEmpty, self.Remove = _save, _reload, _clear, _isempty, _remove
		end

		function save:Reload()
			_saves[name] = loadfile(COMMON_PATH .. "\\" .. name .. ".save")()
			save = _saves[name]
		end

		function save:Clear()
			for i, v in pairs(self) do
				if type(v) ~= "function" or (i ~= "Save" and i ~= "Reload" and i ~= "Clear" and i ~= "IsEmpty" and i ~= "Remove") then
					self[i] = nil
				end
			end
		end

		function save:IsEmpty()
			for i, v in pairs(self) do
				if type(v) ~= "function" or (i ~= "Save" and i ~= "Reload" and i ~= "Clear" and i ~= "IsEmpty" and i ~= "Remove") then
					return false
				end
			end
			return true
		end

		function save:Remove()
			for i, v in pairs(_saves) do
				if v == self then
					_saves[i] = nil
				end
				if FileExist(COMMON_PATH .. "\\" .. name .. ".save") then
					DeleteFile(COMMON_PATH .. "\\" .. name .. ".save")
				end
			end
		end

		if _initSave then
			_initSave = nil
			local function saveAll()
				for i, v in pairs(_saves) do
					if v and v.Save then
						if v:IsEmpty() then
							v:Remove()
						else 
							v:Save()
						end
					end
				end
			end
			Callback.Add("UnLoad", saveAll)
			Callback.Add("BugSplat", saveAll)
		end
		return save
	end

	function FileExist(path)
		assert(type(path) == "string", "FileExist: wrong argument types (<string> expected for path)")
		local file = io.open(path, "r")
		if file then file:close() return true else return false end
	end

	function WriteFile(text, path, mode)
		assert(type(text) == "string" and type(path) == "string" and (not mode or type(mode) == "string"), "WriteFile: wrong argument types (<string> expected for text, path and mode)")
		local file = io.open(path, mode or "w+")
		if not file then
			file = io.open(path, mode or "w+")
			if not file then
				return false
			end
		end
		file:write(text)
		file:close()
		return true
	end

	function ReadFile(path)
		assert(type(path) == "string", "ReadFile: wrong argument types (<string> expected for path)")
		local file = io.open(path, "r")
		if not file then
			file = io.open(SCRIPT_PATH .. path, "r")
			if not file then
				file = io.open(LIB_PATH .. path, "r")
				if not file then return end
			end
		end
		local text = file:read("*all")
		file:close()
		return text
	end

	function CursorIsUnder(x, y, sizeX, sizeY)
		assert(type(x) == "number" and type(y) == "number" and type(sizeX) == "number", "CursorIsUnder: wrong argument types (at least 3 <number> expected)")
		local posX, posY = GetCursorPos().x, GetCursorPos().y
		if sizeY == nil then sizeY = sizeX end
		if sizeX < 0 then
			x = x + sizeX
			sizeX = -sizeX
		end
		if sizeY < 0 then
			y = y + sizeY
			sizeY = -sizeY
		end
		return (posX >= x and posX <= x + sizeX and posY >= y and posY <= y + sizeY)
	end

	function GetFileSize(path)
		assert(type(path) == "string", "GetFileSize: wrong argument types (<string> expected for path)")
		local file = io.open(path, "r")
		if not file then
			file = io.open(SCRIPT_PATH .. path, "r")
			if not file then
				file = io.open(LIB_PATH .. path, "r")
				if not file then return end
			end
		end
		local size = file:seek("end")
		file:close()
		return size
	end

	function IsInDistance(p1,r)
		return GetDistanceSqr(GetOrigin(p1)) < r*r
	end

	local _turrets, __turrets__OnTick
	local function __Turrets__init()
		if _turrets == nil then
			_turrets = {}
			local turretRange = 950
			local fountainRange = 1050
			local visibilityRange = 1300
			Callback.Add("ObjectLoad", function(object)
				if object ~= nil and object.type == Obj_AI_Turret then
					local turretName = object.name
					_turrets[turretName] = {
						object = object,
						team = object.team,
						range = turretRange,
						visibilityRange = visibilityRange,
						x = object.x,
						y = object.y,
						z = object.z,
					}
					if turretName == "Turret_OrderTurretShrine_A" or turretName == "Turret_ChaosTurretShrine_A" then
						_turrets[turretName].range = fountainRange
						Callback.Add("ObjectLoad", function(object2)
							if object2 ~= nil and object2.type == Obj_AI_SpawnPoint and GetDistanceSqr(object, object2) < 1000000 then
								_turrets[turretName].x = object2.x
								_turrets[turretName].z = object2.z
							elseif object2 ~= nil and object2.type == Obj_AI_Shop and GetTeam(object2) == GetTeam(object) then
								_turrets[turretName].y = object2.y
							end
						end)
					end
				end
			end)
			function __turrets__OnTick()
				for name, turret in pairs(_turrets) do
					if not turret.object.valid or turret.object.dead or turret.object.health == 0 then
						_turrets[name] = nil
					end
				end
			end
			Callback.Add("Tick", __turrets__OnTick)
		end
	end;__Turrets__init()

	function GetTurrets()
		return _turrets
	end

	function GetUnderTurret(pos, enemyTurret)
		local enemyTurret = (enemyTurret ~= false)
		for _, turret in pairs(_turrets) do
			if turret ~= nil and (turret.team ~= myHero.team) == enemyTurret and GetDistanceSqr(turret, pos) <= (turret.range) ^ 2 then
				return turret
			end
		end
	end

	function UnderTurret(pos, enemyTurret)
		return (GetUnderTurret(pos, enemyTurret) ~= nil)
	end
	if not unpack then unpack = table.unpack end
	local delayedActions, delayedActionsExecuter = {}, nil
	function DelayAction(func, delay, args) --delay in seconds
		if not delayedActionsExecuter then
			function delayedActionsExecuter()
				for t, funcs in pairs(delayedActions) do
					if t <= os.clock() then
						for _, f in ipairs(funcs) do f.func(unpack(f.args or {})) end
						delayedActions[t] = nil
					end
				end
			end
			Callback.Add("Tick", delayedActionsExecuter)
		end
		local t = os.clock() + (delay or 0)
		if delayedActions[t] then table.insert(delayedActions[t], { func = func, args = args })
		else delayedActions[t] = { { func = func, args = args } }
		end
	end

	local _intervalFunction
	function SetInterval(userFunction, timeout, count, params)
		if not _intervalFunction then
			function _intervalFunction(userFunction, startTime, timeout, count, params)
				if userFunction(table.unpack(params or {})) ~= false and (not count or count > 1) then
					DelayAction(_intervalFunction, (timeout - (os.clock() - startTime - timeout)), { userFunction, startTime + timeout, timeout, count and (count - 1), params })
				end
			end
		end
		DelayAction(_intervalFunction, timeout, { userFunction, os.clock(), timeout or 0, count, params })
	end

	local _DrawText, _PrintChat, _DrawLine, _DrawCircle, _FillRect2 = DrawText, PrintChat, DrawLine, DrawCircle, FillRect
	function EnableOverlay()
		_G.DrawText, _G.PrintChat, _G.DrawLine, _G.DrawCircle, _G.FillRect = _DrawText, _PrintChat, _DrawLine, _DrawCircle, _FillRect
	end

	function DisableOverlay()
		_DrawText, _PrintChat, _DrawLine, _DrawCircle, _FillRect2 = DrawText, PrintChat, DrawLine, DrawCircle, FillRect
		_G.DrawText, _G.PrintChat, _G.DrawLine, _G.DrawCircle, _G.FillRect = function() end, function() end, function() end, function() end, function() end
	end

	function BuffIsValid(buff)
		return buff and buff.name and buff.startT <= GetGameTimer() and buff.startT+buff.endT >= GetGameTimer()
	end

	function UnitHaveBuff(target, buffName)
		assert(type(buffName) == "string" or type(buffName) == "table", "TargetHaveBuff: wrong argument types (<string> or <table of string> expected for buffName)")
		for i = 1, target.buffCount do
			local tBuff = target:getBuff(i)
			if BuffIsValid(tBuff) then
				if type(buffName) == "string" then
					if tBuff.name:lower() == buffName:lower() then return true end
				else
					for _, sBuff in ipairs(buffName) do
						if tBuff.name:lower() == sBuff:lower() then return true end
					end
				end
			end
		end
		return false
	end

	function CountEnemyHeroInRange(range, object)
		object = object or myHero
		range = range and range * range or myHero.range * myHero.range
		local enemyInRange = 0
		for i = 1, heroManager.iCount, 1 do
			local hero = heroManager:getHero(i)
			if ValidTarget(hero) and GetDistanceSqr(object, hero) <= range then
				enemyInRange = enemyInRange + 1
			end
		end
		return enemyInRange
	end

	function DrawLine3D(x,y,z,a,b,c,width,col)
		local p1 = WorldToScreen(0, Vector(x,y,z))
		local p2 = WorldToScreen(0, Vector(a,b,c))
		DrawLine(p1.x, p1.y, p2.x, p2.y, width, col)
	end

	function DrawRectangleOutline(startPos, endPos, width, t, color)
		local c1 = startPos+Vector(Vector(endPos)-startPos):perpendicular():normalized()*width
		local c2 = startPos+Vector(Vector(endPos)-startPos):perpendicular2():normalized()*width
		local c3 = endPos+Vector(Vector(startPos)-endPos):perpendicular():normalized()*width
		local c4 = endPos+Vector(Vector(startPos)-endPos):perpendicular2():normalized()*width
		DrawLine3D(c1.x,c1.y,c1.z,c2.x,c2.y,c2.z,t,color)
		DrawLine3D(c2.x,c2.y,c2.z,c3.x,c3.y,c3.z,t,color)
		DrawLine3D(c3.x,c3.y,c3.z,c4.x,c4.y,c4.z,t,color)
		DrawLine3D(c1.x,c1.y,c1.z,c4.x,c4.y,c4.z,t,color)
	end

	function GetMaladySlot(unit)
		for slot = 6, 13 do
		if GetCastName(unit, slot) and GetCastName(unit, slot):lower():find("malady") then
			return slot
		end
		end
		return nil
	end

	function CastOffensiveItems(unit)
		i = {3074, 3077, 3142, 3184}
		u = {3153, 3146, 3144}
		for _,k in pairs(i) do
		slot = GetItemSlot(myHero,k)
		if slot ~= nil and slot ~= 0 and CanUseSpell(myHero, slot) == READY then
			CastTargetSpell(GetMyHero(), slot)
			return true
		end
		end
		if ValidTarget(unit) then
		for _,k in pairs(u) do
			slot = GetItemSlot(myHero,k)
			if slot ~= nil and slot ~= 0 and CanUseSpell(myHero, slot) == READY then
			CastTargetSpell(unit, slot)
			return true
			end
		end
		end
		return false
	end

	function EnemiesAround(pos, range)
		local c = 0
		if pos == nil then return 0 end
		for k,v in pairs(GetEnemyHeroes()) do 
		if v and ValidTarget(v) and GetDistanceSqr(pos,GetOrigin(v)) < range*range then
			c = c + 1
		end
		end
		return c
	end

	function ClosestEnemy(pos)
		local enemy = nil
		for k,v in pairs(GetEnemyHeroes()) do 
		if not enemy and v then enemy = v end
		if enemy and v and GetDistanceSqr(GetOrigin(enemy),pos) > GetDistanceSqr(GetOrigin(v),pos) then
			enemy = v
		end
		end
		return enemy
	end

	function AlliesAround(pos, range)
		local c = 0
		if pos == nil then return 0 end
		for k,v in pairs(GetAllyHeroes()) do 
		if v and GetOrigin(v) ~= nil and not IsDead(v) and v ~= myHero and GetDistanceSqr(pos,GetOrigin(v)) < range*range then
			c = c + 1
		end
		end
		return c
	end

	function ClosestAlly(pos)
		local ally = nil
		for k,v in pairs(GetAllyHeroes()) do 
		if not ally and v then ally = v end
		if ally and v and GetDistanceSqr(GetOrigin(ally),pos) > GetDistanceSqr(GetOrigin(v),pos) then
			ally = v
		end
		end
		return ally
	end

	function MinionsAround(pos, range, team)
		local c = 0
		if pos == nil then return 0 end
		for k,v in pairs(minionManager.objects) do 
		if v and GetOrigin(v) ~= nil and not IsDead(v) and GetDistanceSqr(pos,GetOrigin(v)) < range*range and (not team or team == GetTeam(v)) then
			c = c + 1
		end
		end
		return c
	end

	function ClosestMinion(pos, team)
		local m = nil
		for k,v in pairs(minionManager.objects) do 
		if not m and v then m = v end
		if m and v and GetDistanceSqr(GetOrigin(m),pos) > GetDistanceSqr(GetOrigin(v),pos) and (not team or team == GetTeam(v)) then
			m = v
		end
		end
		return m
	end

	function Ready(slot)
		return CanUseSpell(myHero, slot) == 0
	end IsReady = Ready

	function GetLineFarmPosition(range, width, team)
		local BestPos 
		local BestHit = 0
		local objects = minionManager.objects
		for i, object in pairs(objects) do
			if GetOrigin(object) ~= nil and IsObjectAlive(object) and (not team or GetTeam(object) == team) then
				local EndPos = Vector(myHero) + range * (Vector(object) - Vector(myHero)):normalized()
				local hit = CountObjectsOnLineSegment(GetOrigin(myHero), EndPos, width, objects, team)
				if hit > BestHit and GetDistanceSqr(GetOrigin(object)) < range^2 then
					BestHit = hit
					BestPos = Vector(object)
					if BestHit == #objects then
						break
					end
				end
			end
		end
		return BestPos, BestHit
	end

	function GetFarmPosition(range, width, team)
		local BestPos 
		local BestHit = 0
		local objects = minionManager.objects
		for i, object in pairs(objects) do
			if GetOrigin(object) ~= nil and IsObjectAlive(object) and (not team or GetTeam(object) == team) then
				local hit = CountObjectsNearPos(Vector(object), range, width, objects, team)
					if hit > BestHit and GetDistanceSqr(Vector(object)) < range * range then
					BestHit = hit
					BestPos = Vector(object)
					if BestHit == #objects then
						break
					end
				end
			end
		end
		return BestPos, BestHit
	end

	function CountObjectsOnLineSegment(StartPos, EndPos, width, objects, team)
		local n = 0
		for i, object in pairs(objects) do
			if object ~= nil and object.valid and (not team or object.team == team) then
				local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, GetOrigin(object))
				local w = width
				if isOnSegment and GetDistanceSqr(pointSegment, GetOrigin(object)) < w^2 and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, GetOrigin(object)) then
					n = n + 1
				end
			end
		end
		return n
	end

	function CountObjectsNearPos(pos, range, radius, objects, team)
		local n = 0
		for i, object in pairs(objects) do
			if IsObjectAlive(object) and (not team or GetTeam(object) == team) and GetDistanceSqr(pos, Vector(object)) <= radius^2 then
				n = n + 1
			end
		end
		return n
	end

	function GetPercentHP(unit)
		return 100 * GetCurrentHP(unit) / GetMaxHP(unit)
	end

	function GetPercentMP(unit)
		return 100 * GetCurrentMana(unit) / GetMaxMana(unit)
	end

	function DrawScreenCircle(x, y, size, color, quality, elliptic)
		local quality = quality or 1;
		local elliptic = elliptic or 1;
		for theta=0,360,quality do
			DrawLine(x + size * math.cos(2*math.pi/360*theta), y - elliptic * size * math.sin(2*math.pi/360*theta), x + size * math.cos(2*math.pi/360*(theta-1)), y - elliptic * size * math.sin(2*math.pi/360*(theta-1)), 1, color)
		end
	end

	function DrawFilledScreenCircle(x, y, size, color, quality, elliptic)
		local quality = quality or 1;
		local elliptic = elliptic or 1;
		for theta=0,360,quality do
			DrawLine(x + size * math.cos(2*math.pi/360*theta), y - elliptic * size * math.sin(2*math.pi/360*theta), x + size * math.cos(2*math.pi/360*(theta-180)), y - elliptic * size * math.sin(2*math.pi/360*(theta-180)), 1, color)
		end
	end

	function DrawCircle2(o, radius, width, quality, color)
		local p = GetOrigin(o) or o
		local quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5);
		local points = {}
		for theta=0,2*math.pi+quality,quality do
			local a = WorldToScreen(0, Vector(p.x+radius*math.cos(theta), p.y, p.z-radius*math.sin(theta)))
			points[1+#points] = a
		end
		for I=1, #points-1 do
			local a = points[I]
			local b = points[I+1]
			DrawLine(a.x, a.y, b.x, b.y, width, color)
		end
	end

	function DrawLines2(t,w,c)
		for i=1, #t-1 do
			if t[i].x > 0 and t[i].y > 0 and t[i+1].x > 0 and t[i+1].y > 0 then
				DrawLine(t[i].x, t[i].y, t[i+1].x, t[i+1].y, w, c)
			end
		end
	end

	function DrawRectangle(x, y, width, height, color, thickness)
		local thickness = thickness or 1
		if thickness == 0 then return end
		x = x - 1
		y = y - 1
		width = width + 2
		height = height + 2
		local halfThick = math.floor(thickness/2)
		DrawLine(x - halfThick, y, x + width + halfThick, y, thickness, color)
		DrawLine(x, y + halfThick, x, y + height - halfThick, thickness, color)
		DrawLine(x + width, y + halfThick, x + width, y + height - halfThick, thickness, color)
		DrawLine(x - halfThick, y + height, x + width + halfThick, y + height, thickness, color)
	end

	function OnScreen(x, y) 
		local typex = type(x)
		if typex == "number" then 
			return x <= WINDOW_W and x >= 0 and y >= 0 and y <= WINDOW_H
		elseif typex == "userdata" or typex == "table" then
			local p1, p2, p3, p4 = {x = 0,y = 0}, {x = WINDOW_W,y = 0}, {x = 0,y = WINDOW_H}, {x = WINDOW_W,y = WINDOW_H}
			return OnScreen(x.x, x.z or x.y) or (y and OnScreen(y.x, y.z or y.y) or IsLineSegmentIntersection(x,y,p1,p2) or IsLineSegmentIntersection(x,y,p3,p4) or IsLineSegmentIntersection(x,y,p1,p3) or IsLineSegmentIntersection(x,y,p2,p4))
		end
	end

	function DrawLineBorder3D(x1, y1, z1, x2, y2, z2, size, color, width)
		local o = { x = -(z2 - z1), z = x2 - x1 }
		local len = math.sqrt(o.x ^ 2 + o.z ^ 2)
		o.x, o.z = o.x / len * size / 2, o.z / len * size / 2
		local points = {
			WorldToScreen(0,Vector(x1 + o.x, y1, z1 + o.z)),
			WorldToScreen(0,Vector(x1 - o.x, y1, z1 - o.z)),
			WorldToScreen(0,Vector(x2 - o.x, y2, z2 - o.z)),
			WorldToScreen(0,Vector(x2 + o.x, y2, z2 + o.z)),
			WorldToScreen(0,Vector(x1 + o.x, y1, z1 + o.z)),
		}
		for i, c in ipairs(points) do points[i] = Vector(c.x, c.y) end
		DrawLines2(points, width or 1, color or 4294967295)
	end

	function DrawLineBorder(x1, y1, x2, y2, size, color, width)
		local o = { x = -(y2 - y1), y = x2 - x1 }
		local len = math.sqrt(o.x ^ 2 + o.y ^ 2)
		o.x, o.y = o.x / len * size / 2, o.y / len * size / 2
		local points = {
			Vector(x1 + o.x, y1 + o.y),
			Vector(x1 - o.x, y1 - o.y),
			Vector(x2 - o.x, y2 - o.y),
			Vector(x2 + o.x, y2 + o.y),
			Vector(x1 + o.x, y1 + o.y),
		}
		DrawLines2(points, width or 1, color or 4294967295)
	end

	function DrawCircle2D(x, y, radius, width, color, quality)
		quality, radius = quality and 2 * math.pi / quality or 2 * math.pi / 20, radius or 50
		local points = {}
		for theta = 0, 2 * math.pi + quality, quality do
			points[#points + 1] = Vector(x + radius * math.cos(theta), y - radius * math.sin(theta))
		end
		DrawLines2(points, width or 1, color or 4294967295)
	end

	function DrawCircle3D(x, y, z, radius, width, color, quality)
		radius = radius or 300
		quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
		local points = {}
		for theta = 0, 2 * math.pi + quality, quality do
			local c = WorldToScreen(0,Vector(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
			points[#points + 1] = Vector(c.x, c.y)
		end
		DrawLines2(points, width or 1, color or 4294967295)
	end

	function DrawArrow3D(v1, v2, radius, width, color, quality)
		radius = radius or 300
		quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
		local points = {}
		for theta = 0, 2 * math.pi + quality, quality do
			local c = WorldToScreen(0,Vector(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
			points[#points + 1] = Vector(c.x, c.y)
		end
		DrawLines2(points, width or 1, color or 4294967295)
	end

	function DrawLine3D(x1, y1, z1, x2, y2, z2, width, color)
		local p = WorldToScreen(0,Vector(x1, y1, z1))
		local px, py = p.x, p.y
		local c = WorldToScreen(0,Vector(x2, y2, z2))
		local cx, cy = c.x, c.y
		if OnScreen({ x = px, y = py }, { x = px, y = py }) then
			DrawLine(cx, cy, px, py, width or 1, color or 4294967295)
		end
	end

	function DrawLines3D(points, width, color)
		local l
		for _, point in ipairs(points) do
			local p = { x = point.x, y = point.y, z = point.z }
			if not p.z then p.z = p.y; p.y = nil end
			p.y = p.y or myHero.y
			local c = WorldToScreen(0,Vector(p.x, p.y, p.z))
			if l and OnScreen({ x = l.x, y = l.y }, { x = c.x, y = c.y }) then
				DrawLine(l.x, l.y, c.x, c.y, width or 1, color or 4294967295)
			end
			l = c
		end
	end

	local old_DrawText = DrawText
	function DrawText(str, s, x, y, col)
		old_DrawText(tostring(str), s, x, y, col or ARGB(255,255,255,255))
	end

	function DrawTextA(text, size, x, y, color, halign, valign)
		local textArea = GetTextArea(tostring(text) or "", size or 12)
		halign, valign = halign and halign:lower() or "left", valign and valign:lower() or "top"
		x = (halign == "right"	and x - textArea.x) or (halign == "center" and x - textArea.x/2) or x or 0
		y = (valign == "bottom" and y - textArea.y) or (valign == "center" and y - textArea.y/2) or y or 0
		DrawText(tostring(text) or "", size or 12, math.floor(x), math.floor(y), color or 4294967295)
	end

	function DrawText3D(text, x, y, z, size, color, center)
		local p = WorldToScreen(0,Vector(x, y, z))
		local textArea = GetTextArea(text, size or 12)
		if center then
			if OnScreen(p.x + textArea.x / 2, p.y + textArea.y / 2) then
				DrawText(text, size or 12, p.x - textArea.x / 2, p.y, color or 4294967295)
			end
		else
			if OnScreen({ x = p.x, y = p.y }, { x = p.x + textArea.x, y = p.y + textArea.y }) then
				DrawText(text, size or 12, p.x, p.y, color or 4294967295)
			end
		end
	end

	class'MEC'
	function MEC:__init(points)
		self.circle = Circle()
		self.points = {}
		if points then
			self:SetPoints(points)
		end
	end

	function MEC:SetPoints(points)
		-- Set the points
		self.points = {}
		for _, p in ipairs(points) do
			table.insert(self.points, Vector(p))
		end
	end

	function MEC:HalfHull(left, right, pointTable, factor)
		-- Computes the half hull of a set of points
		local input = pointTable
		table.insert(input, right)
		local half = {}
		table.insert(half, left)
		for _, p in ipairs(input) do
			table.insert(half, p)
			while #half >= 3 do
				local dir = factor * VectorDirection(half[(#half + 1) - 3], half[(#half + 1) - 1], half[(#half + 1) - 2])
				if dir <= 0 then
					table.remove(half, #half - 1)
				else
					break
				end
			end
		end
		return half
	end

	function MEC:ConvexHull()
		-- Computes the set of points that represent the convex hull of the set of points
		local left, right = self.points[1], self.points[#self.points]
		local upper, lower, ret = {}, {}, {}
		-- Partition remaining points into upper and lower buckets.
		for i = 2, #self.points - 1 do
			if VectorType(self.points[i]) == false then PrintChat("self.points[i]") end
			table.insert((VectorDirection(left, right, self.points[i]) < 0 and upper or lower), self.points[i])
		end
		local upperHull = self:HalfHull(left, right, upper, -1)
		local lowerHull = self:HalfHull(left, right, lower, 1)
		local unique = {}
		for _, p in ipairs(upperHull) do
			unique["x" .. p.x .. "z" .. p.z] = p
		end
		for _, p in ipairs(lowerHull) do
			unique["x" .. p.x .. "z" .. p.z] = p
		end
		for _, p in pairs(unique) do
			table.insert(ret, p)
		end
		return ret
	end

	function MEC:Compute()
		-- Compute the MEC.
		-- Make sure there are some points.
		if #self.points == 0 then return nil end
		-- Handle degenerate cases first
		if #self.points == 1 then
			self.circle.center = self.points[1]
			self.circle.radius = 0
			self.circle.radiusPoint = self.points[1]
		elseif #self.points == 2 then
			local a = self.points
			self.circle.center = a[1]:center(a[2])
			self.circle.radius = a[1]:dist(self.circle.center)
			self.circle.radiusPoint = a[1]
		else
			local a = self:ConvexHull()
			local point_a = a[1]
			local point_b
			local point_c = a[2]
			if not point_c then
				self.circle.center = point_a
				self.circle.radius = 0
				self.circle.radiusPoint = point_a
				return self.circle
			end
			-- Loop until we get appropriate values for point_a and point_c
			while true do
				point_b = nil
				local best_theta = 180.0
				-- Search for the point "b" which subtends the smallest angle a-b-c.
				for _, point in ipairs(self.points) do
					if (not point == point_a) and (not point == point_c) then
						local theta_abc = point:angleBetween(point_a, point_c)
						if theta_abc < best_theta then
							point_b = point
							best_theta = theta_abc
						end
					end
				end
				-- If the angle is obtuse, then line a-c is the diameter of the circle,
				-- so we can return.
				if best_theta >= 90.0 or (not point_b) then
					self.circle.center = point_a:center(point_c)
					self.circle.radius = point_a:dist(self.circle.center)
					self.circle.radiusPoint = point_a
					return self.circle
				end
				local ang_bca = point_c:angleBetween(point_b, point_a)
				local ang_cab = point_a:angleBetween(point_c, point_b)
				if ang_bca > 90.0 then
					point_c = point_b
				elseif ang_cab <= 90.0 then
					break
				else
					point_a = point_b
				end
			end
			local ch1 = (point_b - point_a) * 0.5
			local ch2 = (point_c - point_a) * 0.5
			local n1 = ch1:perpendicular2()
			local n2 = ch2:perpendicular2()
			ch1 = point_a + ch1
			ch2 = point_a + ch2
			self.circle.center = VectorIntersection(ch1, n1, ch2, n2)
			self.circle.radius = self.circle.center:dist(point_a)
			self.circle.radiusPoint = point_a
		end
		return self.circle
	end

	function GetMEC(radius, range, target)
		assert(type(radius) == "number" and type(range) == "number" and (target == nil or target.team ~= nil), "GetMEC: wrong argument types (expected <number>, <number>, <object> or nil)")
		local points = {}
		for i = 1, heroManager.iCount do
			local object = heroManager:GetHero(i)
			if (target == nil and ValidTarget(object, (range + radius))) or (target and ValidTarget(object, (range + radius), (target.team ~= myHero.team)) and (ValidTargetNear(object, radius * 2, target) or object.networkID == target.networkID)) then
				table.insert(points, Vector(object))
			end
		end
		return _CalcSpellPosForGroup(radius, range, points)
	end

	function _CalcSpellPosForGroup(radius, range, points)
		if #points == 0 then
			return nil
		elseif #points == 1 then
			return Vector(points[1])
		end
		local mec = MEC()
		local combos = {}
		for j = #points, 2, -1 do
			local spellPos
			combos[j] = {}
			_CalcCombos(j, points, combos[j])
			for _, v in ipairs(combos[j]) do
				mec:SetPoints(v)
				local c = mec:Compute()
				if c ~= nil and c.radius <= radius and c.center:dist(myHero) <= range and (spellPos == nil or c.radius < spellPos.radius) then
					spellPos = Circle(c.center, c.radius)
				end
			end
			if spellPos ~= nil then return spellPos end
		end
	end

	function _CalcCombos(comboSize, targetsTable, comboTableToFill, comboString, index_number)
		local comboString = comboString or ""
		local index_number = index_number or 1
		if string.len(comboString) == comboSize then
			local b = {}
			for i = 1, string.len(comboString), 1 do
				local ai = tonumber(string.sub(comboString, i, i))
				table.insert(b, targetsTable[ai])
			end
			return table.insert(comboTableToFill, b)
		end
		for i = index_number, #targetsTable, 1 do
			_CalcCombos(comboSize, targetsTable, comboTableToFill, comboString .. i, i + 1)
		end
	end

	-- for combat
	FindGroupCenterFromNearestEnemies = GetMEC
	function FindGroupCenterNearTarget(target, radius, range)
		return GetMEC(radius, range, target)
	end

	function DrawTextOutline(t, s, x, y, c, l)
		for i=-1, 1, 1 do
			for j=-1, 1, 1 do
				DrawText(t, s, x+i, y+j, l or ARGB(255, 0, 0, 0))
			end
		end
		DrawText(t, s, x, y, c or ARGB(255, 255, 255, 255))
	end

	function DrawTextOutlineA(t, s, x, y, h, v, c, l)
		for i=-1, 1, 1 do
			for j=-1, 1, 1 do
				DrawTextA(t, s, x+i, y+j, l or ARGB(255, 0, 0, 0), h, v)
			end
		end
		DrawTextA(t, s, x, y, c or ARGB(255, 255, 255, 255), h, v)
	end

	function GetTextArea(str, size)
		local ret=0
		for c in str:gmatch"." do
			if c==" " then 
				ret=ret+4
			elseif tonumber(c)~=nil then 
				ret=ret+6
			elseif c==string.upper(c) then 
				ret=ret+8
			elseif c==string.lower(c) then 
				ret=ret+7
			else 
				ret=ret+5 
			end
		end
		return {x = ret * size * 0.035, y = size }
	end
end

do -- menu
	class "MenuConfig"
	class "Boolean"
	class "DropDown"
	class "Slider"
	class "ColorPick"
	class "Info"
	class "Empty"
	class "Section"
	class "TargetSelector"
	class "KeyBinding"
	class "MenuSprite"
	class "PermaShow"

	local hasMenuSprites = FileExist(SPRITE_PATH.."MenuConfig\\sliderfillback.png")
	local MCsprites = {}
	if not GetSave("MenuConfig").Menu_Base then 
	  GetSave("MenuConfig").Menu_Base = {x = 15, y = -5, width = 200} 
	end

	if GetSave("MenuConfig").MCscale then
		GetSave("MenuConfig"):Clear()
		GetSave("MenuConfig").Menu_Base = {x = 15, y = -5, width = 200} 
	end

	local MC = GetSave("MenuConfig").Menu_Base
	local MCscale = MC.scale and MC.scale/100 or 1
	if hasMenuSprites then
		local MCsprites2 = {
			arrowright = {8, 10},
			arrowselection = {12, 11},
			Background = {199, 22},
			between = {201, 1},
			borderside = {1, 22},
			bordertopbot = {201, 1},
			colorpick = {28, 16},
			dropdown = {12, 13},
			OFF = {28, 12},
			ON = {28, 12},
			selected = {199, 22},
			slider = {5, 8},
			slider1 = {2, 8},
			slider2 = {2, 8},
			sliderfill = {1, 6},
			sliderfillback = {193, 6},
			targetselector = {15, 15},
			updown = {10, 16},
		}
		for k, v in pairs(MCsprites2) do
			MCsprites[k] = Sprite("MenuConfig\\"..k..".png", v[1], v[2], 0, 0, MCscale)
		end
	end
	local MCadd = {instances = {}, lastChange = 0, startT = GetTickCount()}
	local function __MC__remove(name)
	  if not GetSave("MenuConfig")[name] then GetSave("MenuConfig")[name] = {} end
	  table.clear(GetSave("MenuConfig")[name])
	end

	local function __MC__load(name)
	  if not GetSave("MenuConfig")[name] then GetSave("MenuConfig")[name] = {} end
	  return GetSave("MenuConfig")[name]
	end

	local function __MC__save(name, content)
	  if not GetSave("MenuConfig")[name] then GetSave("MenuConfig")[name] = {} end
	  table.clear(GetSave("MenuConfig")[name])
	  table.merge(GetSave("MenuConfig")[name], content, true)
	  GetSave("MenuConfig"):Save()
	end

	local function __MC_SaveInstance(ins)
	  local toSave = {}
	  for _, p in pairs(ins.__params) do
		if not toSave[p.id] then toSave[p.id] = {} end
		if p.type == "ColorPick" then
		  toSave[p.id].color = { a = p.color[1]:Value(), r = p.color[2]:Value(), g = p.color[3]:Value(), b = p.color[4]:Value(), }
		elseif p.type == "TargetSelector" then
		  toSave[p.id].focus = p.settings[1]:Value()
		  toSave[p.id].mode = p.settings[2]:Value()
		else
		  if p.value ~= nil and (p.type ~= "KeyBinding" or p:Toggle()) then toSave[p.id].value = p.value end
		  if p.key ~= nil then toSave[p.id].key = p.key end
		  if p.isToggle ~= nil then toSave[p.id].isToggle = p:Toggle() end
		end
	  end
	  for _, i in pairs(ins.__subMenus) do
		toSave[i.__id] = __MC_SaveInstance(i)
	  end
	  return toSave
	end

	local function __MC_SaveAll()
	  MCadd.lastChange = GetTickCount()
	  if MCadd.startT + 1000 > GetTickCount() or (not mc_cfg_base.MenuKey:Value() and not mc_cfg_base.Show:Value()) then return end
	  for i=1, #MCadd.instances do
		local ins = MCadd.instances[i]
		__MC__save(ins.__id, __MC_SaveInstance(ins))
	  end
	end

	local function __MC_LoadInstance(ins, saved)
	  if not saved then return end
	  for _, p in pairs(ins.__params) do
		if p.forceDefault == false or not p.forceDefault then
		  if saved[p.id] then
			if p.type == "ColorPick" then
			  p:Value({saved[p.id].color.a,saved[p.id].color.r,saved[p.id].color.g,saved[p.id].color.b})
			elseif p.type == "KeyBinding" then
			  p:Toggle(saved[p.id].isToggle)
			  p:Key(saved[p.id].key)
			  if saved[p.id].isToggle then p:Value(saved[p.id].value) end
			elseif p.type == "TargetSelector" then
			  p.settings[1]:Value(saved[p.id].focus)
			  p.settings[2]:Value(saved[p.id].mode)
			else
			  if p.value ~= nil then p.value = saved[p.id].value end
			  if p.key ~= nil then p.key = saved[p.id].key end
			end
		  end
		end
	  end
	  for _, i in pairs(ins.__subMenus) do
		__MC_LoadInstance(i, saved[i.__id])
	  end
	end

	local function __MC_LoadAll()
	  for i=1, #MCadd.instances do
		local ins = MCadd.instances[i]
		__MC_LoadInstance(ins, __MC__load(ins.__id))
	  end
	end

	local function __MC_Draw()
	  local function __MC_DrawParam(i, p, k)
		if p.type == "Boolean" then
		  FillRect(MC.x-1+(4+MC.width)*k, MC.y-1+23*i, MC.width+2, 22, ARGB(55,255,255,255))
		  FillRect(MC.x+(4+MC.width)*k, MC.y+23*i, MC.width, 20, ARGB(255,0,0,0))
		  DrawText(" "..p.name.." ",15,MC.x+(4+MC.width)*k,MC.y+1+23*i,0xffffffff)
		  DrawScreenCircle(MC.x-1+4+MC.width*(k+1)-12, MC.y+10+23*i, 8, p:Value() and ARGB(255,0,255,0) or ARGB(255,255,0,0), 8)
		  if p:Value() then
			  DrawText("ON",8,MC.x+MC.width*(k+1)-14,MC.y+6+23*i,0xffffffff)
		  else
			  DrawText("OFF",8,MC.x+MC.width*(k+1)-15,MC.y+6+23*i,0xffffffff)
		  end
		  return 0
		elseif p.type == "KeyBinding" then
		  FillRect(MC.x-1+(4+MC.width)*k, MC.y-1+23*i, MC.width+2, 22, ARGB(55,255,255,255))
		  FillRect(MC.x+(4+MC.width)*k, MC.y+23*i, MC.width, 20, ARGB(255,0,0,0))
		  DrawText(" "..p.name.." ",15,MC.x+(4+MC.width)*k,MC.y+1+23*i,0xffffffff)
		  if p.key > 32 and p.key < 96 then
			FillRect(MC.x-1+4+MC.width*(k+1)-18, MC.y+4+23*i, 15, 13, p:Value() and ARGB(155,0,255,0) or ARGB(155,255,0,0))
			DrawText("["..(string.char(p.key)).."]",15,MC.x-1+4+MC.width*(k+1)-20, MC.y+1+23*i,0xffffffff)
		  else
			FillRect(MC.x-1+4+MC.width*(k+1)-23, MC.y+4+23*i, 22, 13, p:Value() and ARGB(155,0,255,0) or ARGB(155,255,0,0))
			DrawText("["..(p.key).."]",15,MC.x-1+4+MC.width*(k+1)-25, MC.y+1+23*i,0xffffffff)
		  end
		  if p.active then
			for c,v in pairs(p.settings) do v.active = true end
			__MC_DrawParam(i, p.settings[1], k+1)
			__MC_DrawParam(i+1, p.settings[2], k+1)
		  end
		  return 0
		elseif p.type == "Slider" then
		  FillRect(MC.x-1+(4+MC.width)*k, MC.y-1+23*i, MC.width+2, 30, ARGB(55,255,255,255))
		  FillRect(MC.x+(4+MC.width)*k, MC.y+23*i, MC.width, 28, ARGB(255,0,0,0))
		  DrawText(" "..p.name.." ",15,MC.x+(4+MC.width)*k,MC.y+1+23*i,0xffffffff)
		  local psize = GetTextArea(tostring(p.value), 15).x * 3
		  DrawText(" "..p.value.." ",15,MC.x-1+4+MC.width*(k+1)-psize/2-5, MC.y+23*i, 0xffffffff)
		  DrawLine(MC.x+5+(4+MC.width)*k, MC.y+23*i+20,MC.x+(4+MC.width)*k+MC.width-5, MC.y+23*i+20,1,ARGB(255,255,255,255))
		  local psize = GetTextArea(tostring(p.max), 10).x * 3
		  local lineWidth = MC.width - 10
		  local delta = (p.value - p.min) / (p.max - p.min)
		  FillRect(MC.x+5+(4+MC.width)*k + lineWidth * delta - 2, MC.y+23*i+16, 5, 10, ARGB(155,0,0,0))
		  FillRect(MC.x+5+(4+MC.width)*k + lineWidth * delta - 1, MC.y+23*i+17, 3, 8, ARGB(255,255,255,255))
		  if p.active then
			if KeyIsDown(1) and CursorIsUnder(MC.x+4+(4+MC.width)*k, MC.y+23*i, lineWidth+2, 30) then
			  local cpos = GetCursorPos()
			  local delta = (cpos.x - (MC.x+5+(4+MC.width)*k)) / lineWidth
			  p:Value(math.round(delta * (p.max - p.min) + p.min), p.step)
			end
		  end
		  return 0.35
		elseif p.type == "DropDown" then
		  FillRect(MC.x-1+(4+MC.width)*k, MC.y-1+23*i, MC.width+2, 22, ARGB(55,255,255,255))
		  FillRect(MC.x+(4+MC.width)*k, MC.y+23*i, MC.width, 20, ARGB(255,0,0,0))
		  DrawText(" "..p.name.." ",15,MC.x+(4+MC.width)*k,MC.y+1+23*i,0xffffffff)
		  DrawText("->", 15, MC.x-1+4+MC.width*(k+1)-18, MC.y+2+23*i, 0xffffffff)
		  if p.active then
			for m=1,#p.drop do
			  local c = p.drop[m]
			  FillRect(MC.x-1+(4+MC.width)*(k+1), MC.y-1+23*(i+m-1), MC.width+2, 22, ARGB(55,255,255,255))
			  FillRect(MC.x+(4+MC.width)*(k+1), MC.y+23*(i+m-1), MC.width, 20, ARGB(255,0,0,0))
			  if p.value == m then
				DrawText("->",15,MC.x+(4+MC.width)*(k+1)+5,MC.y+2+23*(i+m-1),0xffffffff)
			  end
			  DrawText(" "..c.." ",15,MC.x+(4+MC.width)*(k+1)+20,MC.y+1+23*(i+m-1),0xffffffff)
			end
		  end
		  return 0
		elseif p.type == "Empty" then
		  return p.value
		elseif p.type == "Section" then
		  FillRect(MC.x-1+(4+MC.width)*k, MC.y-1+23*i, MC.width+2, 22, ARGB(55,255,255,255))
		  FillRect(MC.x+(4+MC.width)*k, MC.y+23*i, MC.width, 20, ARGB(255,0,0,0))
		  DrawLine(MC.x+5+(4+MC.width)*k, MC.y+23*i+10,MC.x+(4+MC.width)*k+MC.width-5, MC.y+23*i+10,1,ARGB(255,255,255,255))
		  return 0
		elseif p.type == "TargetSelector" then
		  FillRect(MC.x-1+(4+MC.width)*k, MC.y-1+23*i, MC.width+2, 22, ARGB(55,255,255,255))
		  FillRect(MC.x+(4+MC.width)*k, MC.y+23*i, MC.width, 20, ARGB(255,0,0,0))
		  DrawText(" "..p.name.." ",15,MC.x+(4+MC.width)*k,MC.y+1+23*i,0xffffffff)
		  for I = -1, 1 do
			for j = -1, 1 do
			  DrawText("x", 25, MC.x+4+MC.width*(k+1)-15+I, MC.y-6+23*i+j, 0xffffffff)
			end
		  end
		  DrawText("x", 25, MC.x+4+MC.width*(k+1)-15, MC.y-6+23*i, 0xff000000)
		  if p.active then
			if CursorIsUnder(MC.x+(4+MC.width)*(k+1), MC.y+23*i+23, MC.width, 20) then
			  p.settings[2].active = true
			else
			  if p.settings[2].active and CursorIsUnder(MC.x+(4+MC.width)*(k+2)-5, MC.y+23*i+23, MC.width+5, 23*9) then
			  else 
				p.settings[2].active = false
			  end
			end
			__MC_DrawParam(i, p.settings[1], k+1)
			__MC_DrawParam(i+1, p.settings[2], k+1)
			local mode = p.settings[2]:Value()
			if mode == 2 or mode == 3 or mode == 9 then
			  for I=3,#p.settings do
				p.settings[I].active = true
				__MC_DrawParam(i+(I*1.35-2), p.settings[I], k+1)
			  end
			end
		  end
		  return 0
		elseif p.type == "ColorPick" then
		  FillRect(MC.x-1+(4+MC.width)*k, MC.y-1+23*i, MC.width+2, 22, ARGB(55,255,255,255))
		  FillRect(MC.x+(4+MC.width)*k, MC.y+23*i, MC.width, 20, ARGB(255,0,0,0))
		  DrawText(" "..p.name.." ",15,MC.x+(4+MC.width)*k,MC.y+1+23*i,0xffffffff)
		  DrawFilledScreenCircle(MC.x-1+4+MC.width*(k+1)-12, MC.y+10+23*i, 6, p:Value())
		  if p.active then
			for c,v in pairs(p.color) do v.active = true end
			__MC_DrawParam(i, p.color[1], k+1)
			__MC_DrawParam(i, p.color[2], k+2.35)
			FillRect(MC.x+(4+MC.width)*(k+2), MC.y+23*i, MC.width*0.35-3, 60, p:Value())
			__MC_DrawParam(i+1.35, p.color[3], k+1)
			__MC_DrawParam(i+1.35, p.color[4], k+2.35)
		  end
		  return 0
		elseif p.type == "Info" then
		  FillRect(MC.x-1+(4+MC.width)*k, MC.y-1+23*i, MC.width+2, 22, ARGB(55,255,255,255))
		  FillRect(MC.x+(4+MC.width)*k, MC.y+23*i, MC.width, 20, ARGB(255,0,0,0))
		  DrawText(" "..p.name.." ",15,MC.x+(4+MC.width)*k,MC.y+1+23*i,0xffffffff)
		  return 0
		elseif p.type == "MenuSprite" then
		  FillRect(MC.x-1+(4+MC.width)*k, MC.y-2+23*i, MC.width+3, p.height+2, ARGB(55,255,255,255))
		  DrawSprite(p.ID, MC.x+(4+MC.width)*k, MC.y+23*i, p.x, p.y, MC.width+p.x, p.height+p.y, p.color)
		  return p.height/23-0.9
		else
		  return 0
		end
	  end
	  local function __MC_DrawParam_Sprites(i, p, k)
		if p.type == "Boolean" then
	  	  local y = MC.y+math.floor(MC.h-MCscale)*i
		  MCsprites["Background"]:Draw(MC.x-1+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(MC.x-MCscale+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(math.floor(MC.x-MCscale+MC.width+(MC.width+4)*k), y)
		  DrawText(" "..p.name.." ",15*MCscale,MC.x+(4+MC.width)*k+5,y+MCscale*7.5-MC.h/5,0xffffffff)
		  MCsprites[p:Value() and "ON" or "OFF"]:Draw(MC.x+(4+MC.width)*k+MC.width-34*MCscale, y+MCsprites["ON"].height/2)
		  return 0
		elseif p.type == "KeyBinding" then
	  	  local y = MC.y+math.floor(MC.h-MCscale)*i
		  MCsprites["Background"]:Draw(MC.x-1+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(MC.x-MCscale+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(math.floor(MC.x-MCscale+MC.width+(MC.width+4)*k), y)
		  DrawText(" "..p.name.." ",15*MCscale,MC.x+(4+MC.width)*k+5,y+MCscale*7.5-MC.h/5,0xffffffff)
		  FillRect(MC.x+(4+MC.width)*k+MC.width-33*MCscale, y+1+4*MCscale, MCsprites["colorpick"].width-2, MCsprites["colorpick"].height-2, p:Value() and ARGB(255, 0x35, 0xc5, 0x2a) or ARGB(255, 0xc9, 0x2e, 0x2e))
		  MCsprites["colorpick"]:Draw(MC.x+(4+MC.width)*k+MC.width-34*MCscale, y+4*MCscale)
		  if p.key > 32 and p.key < 96 then
			DrawText(""..(string.char(p.key)).."",12*MCscale,MC.x+(4+MC.width)*k+MC.width-MC.h, y+6*MCscale, 0xff050906)
		  else
			DrawText(""..(p.key).."",12*MCscale,MC.x+(4+MC.width)*k+MC.width-26*MCscale, y+6*MCscale, 0xff050906)
		  end
		  if p.active then
			for c,v in pairs(p.settings) do v.active = true end
			__MC_DrawParam_Sprites(i, p.settings[1], k+1)
			__MC_DrawParam_Sprites(i+1, p.settings[2], k+1)
			MCsprites["bordertopbot"]:Draw(MC.x-1+(4+MC.width)*(k+1), y)
			MCsprites["between"]:Draw(MC.x-1+(4+MC.width)*(k+1), y+math.floor(MC.h-MCscale))
			MCsprites["bordertopbot"]:Draw(MC.x-1+(4+MC.width)*(k+1), y+math.floor(MC.h-MCscale)*2)
		  end
		  return 0
		elseif p.type == "Slider" then
	  	  local y = MC.y+math.floor(MC.h-MCscale)*i
		  MCsprites["Background"]:Draw(MC.x-1+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(MC.x-MCscale+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(math.floor(MC.x-MCscale+MC.width+(MC.width+4)*k), y)
		  DrawText(" "..p.name.." ",10*MCscale,MC.x+(4+MC.width)*k+5,y+MCscale,0xffffffff)
		  local psize = GetTextArea(tostring(p.value), 10).x
		  local lineWidth = 193*MCscale
		  local delta = (p.value - p.min) / (p.max - p.min)
		  DrawText(" "..p.value.." ",10*MCscale,MC.x+(4+MC.width)*k+MC.width-(psize*2+7)*MCscale,y+MCscale,0xffffffff)
		  MCsprites["sliderfillback"]:Draw(MC.x+2+(4+MC.width)*k, y+13*MCscale)
		  for j=1,lineWidth * delta do
		  	MCsprites["sliderfill"]:Draw(MC.x+1+(4+MC.width)*k+j, y+14*MCscale)
		  end
		  MCsprites["slider1"]:Draw(MC.x+2+(4+MC.width)*k, y+13*MCscale)
		  MCsprites["slider2"]:Draw(MC.x+195*MCscale+(4+MC.width)*k, y+13*MCscale)
		  MCsprites["slider"]:Draw(MC.x+1+(4+MC.width)*k+lineWidth * delta, y+13*MCscale)
		  if p.active then
			if KeyIsDown(1) and CursorIsUnder(MC.x+4+(4+MC.width)*k, y, lineWidth+2, 30*MCscale) then
			  local cpos = GetCursorPos()
			  local delta = (cpos.x - (MC.x+5+(4+MC.width)*k)) / lineWidth
			  p:Value(math.round((delta * (p.max - p.min) + p.min) * 1/p.step)*p.step)
			end
		  end
		  return 0
		elseif p.type == "DropDown" then
	  	  local sy = math.floor(MC.h-MCscale)
	  	  local y = MC.y+sy*i
		  MCsprites["Background"]:Draw(MC.x-1+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(MC.x-MCscale+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(math.floor(MC.x-MCscale+MC.width+(MC.width+4)*k), y)
		  DrawText(" "..p.name.." ",15*MCscale,MC.x+(4+MC.width)*k+5,y+MCscale*7.5-MC.h/5,0xffffffff)
		  MCsprites["dropdown"]:Draw(MC.x+MC.width*(k+1)-12*MCscale, y+5*MCscale)
		  if p.active then
			for m=1,#p.drop do
			  local c = p.drop[m]
			  MCsprites["Background"]:Draw(MC.x-1+(4+MC.width)*(k+1), MC.y+sy*(i+m-1))
			  MCsprites["borderside"]:Draw(MC.x-1+(4+MC.width)*(k+1), MC.y+sy*(i+m-1))
			  MCsprites["borderside"]:Draw(MC.x-1+MC.width+(4+MC.width)*(k+1), MC.y+sy*(i+m-1))
			  if p.value == m then
		  		MCsprites["arrowselection"]:Draw(MC.x+(4+MC.width)*(k+1)+5,MC.y+MC.h/4+sy*(i+m-1))
			  end
			  DrawText(" "..c.." ",15*MCscale,MC.x+(4+MC.width)*(k+1)+20,MC.y+MC.h/8+sy*(i+m-1),0xffffffff)
			end
			for m=1,#p.drop do
			  if m < #p.drop then
			  	MCsprites["between"]:Draw(MC.x-1+(4+MC.width)*(k+1), MC.y+sy*(i+m))
			  end
			end
			MCsprites["bordertopbot"]:Draw(MC.x-1+(4+MC.width)*(k+1), y)
			MCsprites["bordertopbot"]:Draw(MC.x-1+(4+MC.width)*(k+1), y+math.floor(MC.h-MCscale)*(#p.drop))
		  end
		  return 0
		elseif p.type == "Empty" then
		  return p.value
		elseif p.type == "Section" then
	  	  local y = MC.y+math.floor(MC.h-MCscale)*i
		  MCsprites["Background"]:Draw(MC.x-1+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(MC.x-MCscale+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(math.floor(MC.x-MCscale+MC.width+(MC.width+4)*k), y)
		  DrawLine(MC.x+5+(4+MC.width)*k, MC.y+MC.h*i+10,MC.x+(4+MC.width)*k+MC.width-5, MC.y+MC.h*i+10,1,ARGB(255,255,255,255))
		  return 0
		elseif p.type == "TargetSelector" then
	  	  local y = MC.y+math.floor(MC.h-MCscale)*i
		  MCsprites["Background"]:Draw(MC.x-1+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(MC.x-MCscale+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(math.floor(MC.x-MCscale+MC.width+(MC.width+4)*k), y)
		  DrawText(" "..p.name.." ",15*MCscale,MC.x+(4+MC.width)*k+5,y+MCscale*7.5-MC.h/5,0xffffffff)
		  MCsprites["targetselector"]:Draw(MC.x+MC.width*(k+1)-17*MCscale, y+4*MCscale)
		  if p.active then
			if CursorIsUnder(MC.x+(4+MC.width)*(k+1), y+MC.h, MC.width, 20*MCscale) then
			  p.settings[2].active = true
			else
			  if p.settings[2].active and CursorIsUnder(MC.x+(4+MC.width)*(k+2)-5, y+MC.h, MC.width+5, MC.h*9) then
			  else 
				p.settings[2].active = false
			  end
			end
			__MC_DrawParam_Sprites(i, p.settings[1], k+1)
			__MC_DrawParam_Sprites(i+1, p.settings[2], k+1)
			local mode = p.settings[2]:Value()
			if mode == 2 or mode == 3 or mode == 9 then
			  for I=3,#p.settings do
				p.settings[I].active = true
				__MC_DrawParam_Sprites(i+(I*1.35-2), p.settings[I], k+1)
			  end
			end
			MCsprites["bordertopbot"]:Draw(MC.x-1+(4+MC.width)*(k+1), y)
			MCsprites["bordertopbot"]:Draw(MC.x-1+(4+MC.width)*(k+1), y+math.floor(MC.h-MCscale)*((mode == 2 or mode == 3 or mode == 9)and 3 or 2))
		  end
		  return 0
		elseif p.type == "ColorPick" then
	  	  local y = MC.y+math.floor(MC.h-MCscale)*i
		  MCsprites["Background"]:Draw(MC.x-1+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(MC.x-MCscale+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(math.floor(MC.x-MCscale+MC.width+(MC.width+4)*k), y)
		  DrawText(" "..p.name.." ",15*MCscale,MC.x+(4+MC.width)*k+5,y+MCscale*7.5-MC.h/5,0xffffffff)
		  MCsprites["colorpick"]:Draw(MC.x+(4+MC.width)*k+MC.width-34*MCscale, y+4*MCscale)FillRect(MC.x+(4+MC.width)*k+MC.width-33*MCscale, y+1+4*MCscale, MCsprites["colorpick"].width-2, MCsprites["colorpick"].height-2, p:Value())
		  if p.active then
			for c,v in pairs(p.color) do v.active = true end
			__MC_DrawParam_Sprites(i, p.color[1], k+1)
			__MC_DrawParam_Sprites(i, p.color[2], k+2.35)
			FillRect(MC.x+(4+MC.width)*(k+2), MC.y+MC.h*(i-0.175), MC.width*0.35-3, 60, p:Value())
			__MC_DrawParam_Sprites(i+1, p.color[3], k+1)
			__MC_DrawParam_Sprites(i+1, p.color[4], k+2.35)
		  end
		  return 0
		elseif p.type == "Info" then
	  	  local y = MC.y+math.floor(MC.h-MCscale)*i
		  MCsprites["Background"]:Draw(MC.x-1+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(MC.x-MCscale+(MC.width+4)*k, y)
		  MCsprites["borderside"]:Draw(math.floor(MC.x-MCscale+MC.width+(MC.width+4)*k), y)
		  DrawText(" "..p.name.." ",15*MCscale,MC.x+(4+MC.width)*k+5,y+MCscale*7.5-MC.h/5,0xffffffff)
		  return 0
		elseif p.type == "MenuSprite" then
	  	  local y = MC.y+math.floor(MC.h-MCscale)*i
		  FillRect(MC.x-1+(4+MC.width)*k, y, MC.width+3, p.height+2, ARGB(55,255,255,255))
		  DrawSprite(p.ID, MC.x+(4+MC.width)*k, y, p.x, p.y, MC.width+p.x, p.height+p.y, p.color)
		  return p.height/MC.h-0.9
		else
		  return 0
		end
	  end
	  local function __MC_DrawInstance(k, v, madd)
		if v.__active then
		  local sh = #v.__subMenus
		  for i=1, sh do
			local s = v.__subMenus[i]
			__MC_DrawInstance(i+k-1, s, madd+1)
		  end
		  local add = sh
		  local ph = #v.__params
		  for i=1, ph do
			local p = v.__params[i]
			add = add + __MC_DrawParam(i+k+add-1, p, madd+1)
		  end
		end
		FillRect(MC.x-1+(MC.width+4)*madd, MC.y-1+MC.h*k, MC.width+2, 22, ARGB(55,255,255,255))
		FillRect(MC.x+(MC.width+4)*madd, MC.y+MC.h*k, MC.width, 20, ARGB(255,0,0,0))
		DrawText(" "..v.__name.." ",15,MC.x+(MC.width+4)*madd,MC.y+1+MC.h*k,0xffffffff)
		DrawText(">",15,MC.x+(MC.width+4)*madd+MC.width-15,MC.y+1+MC.h*k,0xffffffff)
	  end
	  local function __MC_DrawInstance_Sprites(k, v, madd)
		if v.__active then
		  local sh = #v.__subMenus
		  for i=1, sh do
			local s = v.__subMenus[i]
			__MC_DrawInstance_Sprites(i+k-1, s, madd+1)
		  end
		  local add = sh
		  local ph = #v.__params
		  for i=1, ph do
			local p = v.__params[i]
			add = add + __MC_DrawParam_Sprites(i+k+add-1, p, madd+1)
		  end
		  for i=1, add+ph do
			if i < add+ph then
		  	  MCsprites["between"]:Draw(MC.x-MCscale+(MC.width+4)*(madd+1), MC.y+math.floor(MC.h-MCscale)*(i+k-1)+MC.h-MCscale)
			end
		  end
		  if add+ph > 0 then
			MCsprites["bordertopbot"]:Draw(MC.x-MCscale+(MC.width+4)*(madd+1), MC.y+math.floor(MC.h-MCscale)*(k-1)+MC.h-MCscale)
			MCsprites["bordertopbot"]:Draw(MC.x-MCscale+(MC.width+4)*(madd+1), MC.y+math.floor(MC.h-MCscale)*(ph+add+k-1)+MC.h-MCscale)
		  end
		end
		local y = MC.y+math.floor(MC.h-MCscale)*k
		MCsprites["Background"]:Draw(MC.x-1+(MC.width+4)*madd, y)
		MCsprites["borderside"]:Draw(MC.x-MCscale+(MC.width+4)*madd, y)
		MCsprites["borderside"]:Draw(math.floor(MC.x-MCscale+MC.width+(MC.width+4)*madd), y)
		DrawText(" "..v.__name.." ",15*MCscale,MC.x+(MC.width+4)*madd+5,y+MCscale*7.5-MC.h/5,0xffffffff)
		MCsprites["arrowright"]:Draw(MC.x+(MC.width+4)*madd+MC.width-15*MCscale,y+MC.h/3-MCscale)
	  end
	  local function __MC_Draw()
		if mc_cfg_base.Show:Value() or mc_cfg_base.MenuKey:Value() then
		  if hasMenuSprites then 
		  	local c, i = 0, #MCadd.instances
			for k, v in pairs(MCadd.instances) do
			  c = c + 1
			  __MC_DrawInstance_Sprites(k, v, 0)
			end
			for c=1,i do
			  if c < i then
			  	MCsprites["between"]:Draw(MC.x-MCscale, MC.y+math.floor(MC.h-MCscale)*c+MC.h-MCscale)
			  end
		  	end
			if c > 0 then
				MCsprites["bordertopbot"]:Draw(MC.x-MCscale, MC.y-MCscale+MC.h)
				MCsprites["bordertopbot"]:Draw(MC.x-MCscale, MC.y+math.floor(MC.h-MCscale)*c+MC.h-MCscale)
			end
		  else
			for k, v in pairs(MCadd.instances) do
			  __MC_DrawInstance(k, v, 0)
			end
		  end
		end
	  end
	  Callback.Add("DrawMinimap", function() if mc_cfg_base.ontop:Value() then __MC_Draw() end end)
	  Callback.Add("Draw", function() if not mc_cfg_base.ontop:Value() then __MC_Draw() end end)
	end

	local function __MC_WndMsg()
	  local function __MC_IsBrowsing()
		local function __MC_IsBrowseParam(i, p, k)
		  local isB, ladd = false, 0
		  if p.type == "MenuSprite" then ladd = p.height/MC.h-0.9 end
		  if p.type == "Empty" then ladd = p.value end
		  local y = hasMenuSprites and MC.y+math.floor(MC.h-MCscale)*i or MC.y+MC.h*i-2
		  if CursorIsUnder(MC.x+(4+MC.width)*k, y, MC.width, MC.h+ladd*MC.h) then
			isB = true
		  end
		  if p.active then
			if p.type == "Boolean" then
			  if CursorIsUnder(MC.x+(4+MC.width)*k, y, MC.width, MC.h) then
				isB = true
				p:Value(not p:Value())
			  end
			elseif p.type == "DropDown" then 
			  local padd = #p.drop
			  for m=1, padd do
				if CursorIsUnder(MC.x+(4+MC.width)*(k+1), y+math.floor(MC.h-MCscale)*(m-1), MC.width, MC.h) then
				  isB = true
				  p:Value(m)
				end
			  end
			elseif p.type == "KeyBinding" then 
			  if CursorIsUnder(MC.x+(4+MC.width)*(k+1), y, MC.width*2+6, MC.h) then
				p:Toggle(not p:Toggle())
				isB = true
			  elseif CursorIsUnder(MC.x+(4+MC.width)*(k+1), y+MC.h, MC.width*2+6, MC.h) then
				MCadd.keyChange = p
				p.settings[2].name = "Press key to change now."
				isB = true
			  end
			elseif p.type == "ColorPick" then 
			  if CursorIsUnder(MC.x+(4+MC.width)*(k+1), y, MC.width*3+6, MC.h*4) then
				isB = true
			  end
			elseif p.type == "TargetSelector" then
			  	if CursorIsUnder(MC.x+(4+MC.width)*(k+1), y, MC.width, MC.h) then
					p.settings[1]:Value(not p.settings[1]:Value())
					isB = true
			  	elseif CursorIsUnder(MC.x+(4+MC.width)*(k+1), y, MC.width, MC.h*#p.settings) then
			  		isB = true
				end
				if p.settings[2].active then
				  	for m=1, 9 do
						if CursorIsUnder(MC.x+(4+MC.width)*(k+2), y+MC.h+MC.h*(m-1), MC.width, MC.h) then
							isB = true
							p.settings[2]:Value(m)
						end
				  	end
			  	end
			end
		  end
		  return isB, ladd
		end
		local function __MC_IsBrowseInstance(k, v, madd)
		  local y = hasMenuSprites and MC.y+math.floor(MC.h-MCscale)*k or MC.y+MC.h*k-2
		  if CursorIsUnder(MC.x+(MC.width+4)*madd, y, MC.width, MC.h-2) then
			return true
		  end
		  if v.__active then
			local sh = #v.__subMenus
			for _=1, sh do
			  local s = v.__subMenus[_]
			  if __MC_IsBrowseInstance(_+k-1, s, madd+1) then
				return true
			  end
			end
			local add = sh
			for _, p in pairs(v.__params) do
			  local isB, ladd = __MC_IsBrowseParam(_+k-1+add, p, madd+1)
			  add = add + ladd
			  if isB then
				return true
			  end
			end
		  end
		end
		if mc_cfg_base.Show:Value() or mc_cfg_base.MenuKey:Value() then
		  for k, v in pairs(MCadd.instances) do
			if __MC_IsBrowseInstance(k, v, 0) then
			  return true
			end
		  end
		end
		return false
	  end
	  local function __MC_ResetInstance(v, skipID, onlyParams)
		for _, s in pairs(v.__subMenus) do
		  if not skipID or skipID ~= v.__id then
			__MC_ResetInstance(s, skipID)
		  end
		end
		for _, p in pairs(v.__params) do
		  if not skipID or skipID ~= p.__id then
			p.active = false
		  end
		end
		if not onlyParams then v.__active = false end
	  end
	  local function __MC_ResetActive(skipID, onlyParams)
	  if MCadd.lastChange + 375 > GetTickCount() then return end
		for k, v in pairs(MCadd.instances) do
		  if not skipID or skipID ~= v.__id then
			__MC_ResetInstance(v, skipID, onlyParams)
			if not onlyParams then 
			  v.__active = false 
			end
		  end
		end
	  end
	  local function __MC_WndMsg(msg, key)
		if not IsGameOnTop() or IsChatOpened() then return end
		if MCadd.keyChange ~= nil then
		  if key >= 16 and key ~= 117 then
			MCadd.keyChange.key = key
			MCadd.keyChange.settings[2].name = "> Click to change key <"
			MCadd.keyChange = nil
		  end
		end
		if msg == 514 then
		  if moveNow then moveNow = nil end
		  if not __MC_IsBrowsing() then 
			if MCadd.lastChange < GetTickCount() + 125 then
			  __MC_ResetActive()
			end
		  end
		end
		if msg == 513 and CursorIsUnder(MC.x, MC.y, MC.width, MC.h*#MCadd.instances+MC.h) then
		  local cpos = GetCursorPos()
		  moveNow = {x = cpos.x - MC.x, y = cpos.y - MC.y}
		end
	  end
	  local function __MC_BrowseParam(i, p, k)
		local isB, ladd = false, 0
		local y = hasMenuSprites and MC.y+math.floor(MC.h-MCscale)*i or MC.y+MC.h*i-2
		if p.type == "MenuSprite" then ladd = p.height/MC.h-0.9 end
		if p.type == "Empty" then ladd = p.value
		elseif CursorIsUnder(MC.x+(4+MC.width)*k, y+ladd*MC.h, MC.width, 20*MCscale) then
		  __MC_ResetInstance(p.head, nil, true)
		  p.active = true
		end
		return ladd
	  end
	  local function __MC_BrowseInstance(k, v, madd)
		if CursorIsUnder(MC.x+(MC.width+4)*madd, hasMenuSprites and MC.y+math.floor(MC.h-MCscale)*k or MC.y+MC.h*k-2, MC.width, 20*MCscale) then
		  if not v.__head then __MC_ResetActive(v.__id) end
		  if v.__head then
			for _, s in pairs(v.__head.__subMenus) do
			  __MC_ResetInstance(s)
			end
			__MC_ResetInstance(v.__head, nil, true)
		  end
		  v.__active = true
		end
		if v.__active then
		  local sh = #v.__subMenus
		  for _=1, sh do
			local s = v.__subMenus[_]
			__MC_BrowseInstance(_+k-1, s, madd+1)
		  end
		  local add = sh
		  for _, p in pairs(v.__params) do
			add = add + __MC_BrowseParam(_+k-1+add, p, madd+1) 
		  end
		end
	  end
	  local function __MC_Browse()
		if mc_cfg_base.Show:Value() or mc_cfg_base.MenuKey:Value() then
		  for k, v in pairs(MCadd.instances) do
			__MC_BrowseInstance(k, v, 0)
		  end
		  if moveNow then
			local cpos = GetCursorPos()
			MC.x = math.min(math.max(cpos.x - moveNow.x, 15), 1920)
			MC.y = math.min(math.max(cpos.y - moveNow.y, -5), 1080)
			GetSave("MenuConfig"):Save()
		  end
		end
	  end
	  Callback.Add("WndMsg", __MC_WndMsg)
	  Callback.Add("Tick", __MC_Browse)
	end

	do -- __MC_Init()
	  __MC_Draw()
	  __MC_WndMsg()
	end

	function Boolean:__init(head, id, name, value, callback, forceDefault)
	  self.head = head
	  self.id = id
	  self.name = name
	  self.type = "Boolean"
	  self.value = value or false
	  self.callback = callback
	  self.forceDefault = forceDefault or false
	end

	function Boolean:Value(x)
	  if x ~= nil then
		if self.value ~= x then
		  self.value = x
		  if self.callback then self.callback(self.value) end
		  __MC_SaveAll()
		end
	  else 
		return self.value
	  end
	end

	function KeyBinding:__init(head, id, name, key, isToggle, callback, forceDefault)
	  self.head = head
	  self.id = id
	  self.name = name
	  self.type = "KeyBinding"
	  self.key = key
	  self.value = forceDefault or false
	  self.isToggle = isToggle or false
	  self.callback = callback
	  self.forceDefault = forceDefault or false
	  self.settings = {
			  Boolean(head, "isToggle", "Is Toggle:", isToggle, nil, forceDefault),
			  Info(head, "change", "> Click to change key <"),
			}
	  Callback.Add("WndMsg", function(msg, key)
		if key == self.key then
		  if IsChatOpened() or not IsGameOnTop() then return end
		  if self:Toggle() then
			if msg == 256 then
			  self.value = not self.value
			  if self.callback then self.callback(self.value) end
			  __MC_SaveAll()
			end
		  else
			if msg == 256 then
			  self.value = true
			  if self.callback then self.callback(self.value) end
			elseif msg == 257 then
			  self.value = false
			  if self.callback then self.callback(self.value) end
			end
		  end
		end
	  end)
	end

	function KeyBinding:Value(x)
	  if x ~= nil then
		if self.value ~= x then
		  self.value = x
		  if self.callback then self.callback(self.value) end
		  __MC_SaveAll()
		end
	  else
		return self.value
	  end
	end

	function KeyBinding:Key(x)
	  if x ~= nil then
		self.key = x
	  else
		return self.key
	  end
	end

	function KeyBinding:Toggle(x)
	  if x ~= nil then
		self.settings[1]:Value(x)
	  else
		return self.settings[1]:Value()
	  end
	end

	function ColorPick:__init(head, id, name, color, callback, forceDefault)
	  self.head = head
	  self.id = id
	  self.name = name
	  self.type = "ColorPick"
	  self.color = {
			  Slider(head, "c1", "Alpha", color[1], 0, 255, 1, callback, forceDefault),
			  Slider(head, "c2", "Red", color[2], 0, 255, 1, callback, forceDefault),
			  Slider(head, "c3", "Green", color[3], 0, 255, 1, callback, forceDefault),
			  Slider(head, "c4", "Blue", color[4], 0, 255, 1, callback, forceDefault)
			}
	end

	function ColorPick:Value(x)
	  if x ~= nil then
		for i=1,4 do
		  self.color[i]:Value(x[i])
		end
		if self.callback then self.callback(self:Value()) end
		__MC_SaveAll()
	  else
		return ARGB(self.color[1]:Value(),self.color[2]:Value(),self.color[3]:Value(),self.color[4]:Value())
	  end
	end

	function Info:__init(head, id, name)
	  self.head = head
	  self.id = id
	  self.name = name
	  self.type = "Info"
	end

	function Empty:__init(head, id, value)
	  self.head = head
	  self.id = id
	  self.type = "Empty"
	  self.value = value or 0
	end

	TARGET_LESS_CAST = 1
	TARGET_LESS_CAST_PRIORITY = 2
	TARGET_PRIORITY = 3
	TARGET_MOST_AP = 4
	TARGET_MOST_AD = 5
	TARGET_CLOSEST = 6
	TARGET_NEAR_MOUSE = 7
	TARGET_LOW_HP = 8
	TARGET_LOW_HP_PRIORITY = 9
	DAMAGE_MAGIC = 1
	DAMAGE_PHYSICAL = 2

	local function GetD(p1, p2)
	  local dx = p1.x - p2.x
	  local dz = p1.z - p2.z
	  return dx*dx + dz*dz
	end

	function TargetSelector:__init(range, mode, type, focusselected, ownteam, priorityTable)
	  self.head = head
	  self.id = "id"
	  self.name = "name"
	  self.type = "TargetSelector"
	  self.dtype = type
	  self.mode = mode or 1
	  self.range = range or 1000
	  self.focusselected = focusselected or false
	  self.forceDefault = false
	  self.ownteam = ownteam or false
	  self.priorityTable = priorityTable or {
		[5] = Set {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "JarvanIV", "Leona", "Lulu", "Malphite", "Nasus", "Nautilus", "Nunu", "Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac"},
		[4] = Set {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
		[3] = Set {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Janna", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nami", "Nidalee", "Riven", "Shaco", "Sona", "Soraka", "TahmKench", "Vladimir", "Yasuo", "Zilean", "Zyra"},
		[2] = Set {"Ahri", "Anivia", "Annie", "Brand",  "Cassiopeia", "Ekko", "Karma", "Karthus", "Katarina", "Kennen", "LeBlanc",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
		[1] = Set {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
	  }
	  self.settings = {
			  Boolean(head, "sel", "Focus selected:", self.focusselected, function(var) self.focusselected = var end, false),
			  DropDown(head, "mode", "TargetSelector Mode:", self.mode, {"Less Cast", "Less Cast Priority", "Priority", "Most AP", "Most AD", "Closest", "Near Mouse", "Lowest Health", "Lowest Health Priority"}, function(var) self.mode = var end, false)
			}
	  local I = 0;
	  for i=1, heroManager.iCount do
  		local hero = heroManager:getHero(i)
		if self.ownteam and GetTeam(hero) == GetTeam(myHero) or GetTeam(hero) ~= GetTeam(myHero) then
		  I = I + 1
		  table.insert(self.settings, Slider(head, GetObjectName(hero), "Priority: "..GetObjectName(hero), (self.priorityTable[5][GetObjectName(hero)] and 5 or self.priorityTable[4][GetObjectName(hero)] and 4 or self.priorityTable[3][GetObjectName(hero)] and 3 or self.priorityTable[2][GetObjectName(hero)] and 2 or self.priorityTable[1][GetObjectName(hero)] and 1 or 1), 1, 5, 1))
		end
	  end
	  Callback.Add("WndMsg", function(msg, key)
		if msg == 513 and self.focusselected then
		  local t, d = nil, math.huge
		  local mpos = GetMousePos()
		  for i=1, heroManager.iCount do
			local h = heroManager:getHero(i)
			if h then
				local p = GetD(GetOrigin(h), mpos)
				if p < d then
				  t = h
				  d = p
				end
			end
		  end
		  if t and d < GetHitBox(t)^2.25 and (self.ownteam and GetTeam(t) == GetTeam(myHero) or GetTeam(t) ~= GetTeam(myHero)) then
			self.selected = t
		  else
			self.selected = nil
		  end
		end
	  end)
	  self.IsValid = function(t,r)
		if t == nil or GetOrigin(t) == nil or not IsTargetable(t) or IsImmune(t,myHero) or IsDead(t) or not IsVisible(t) or (r and GetD(GetOrigin(t), GetOrigin(myHero)) > r^2) then
		  return false
		end
		return true
	  end
	  Callback.Add("Draw", function()
		if self.focusselected and self.IsValid(self.selected) then
		  DrawCircle(GetOrigin(self.selected), GetHitBox(self.selected), 1, 1, ARGB(155,255,255,0))
		end
	  end)
	end

	function TargetSelector:GetPriority(hero)
	  for I=2, #self.settings do
		local s = self.settings[I]
		if s.id == GetObjectName(hero) then
		  return s:Value()
		end
	  end
	  return 1
	end

	function TargetSelector:GetTarget()
	  if self.focusselected then
		if self.IsValid(self.selected) then
		  return self.selected
		else
		  self.selected = nil
		end
	  end
	  if self.mode == TARGET_LESS_CAST then
		local t, p = nil, math.huge
		for i=1, heroManager.iCount do
		  local hero = heroManager:getHero(i)
		  if self.IsValid(hero, self.range) and ((self.ownteam and GetTeam(hero) == GetTeam(myHero)) or (not self.ownteam and GetTeam(hero) ~= GetTeam(myHero))) then
			local prio = CalcDamage(myHero, hero, self.dtype == DAMAGE_PHYSICAL and 100 or 0, self.dtype == DAMAGE_MAGIC and 100 or 0)
			if prio < p then
			  t = hero
			  p = prio
			end
		  end
		end
		return t
	  elseif self.mode == TARGET_LESS_CAST_PRIORITY then
		local t, p = nil, math.huge
		for i=1, heroManager.iCount do
		  local hero = heroManager:getHero(i)
		  if self.IsValid(hero, self.range) and ((self.ownteam and GetTeam(hero) == GetTeam(myHero)) or (not self.ownteam and GetTeam(hero) ~= GetTeam(myHero))) then
			local prio = CalcDamage(myHero, hero, self.dtype == DAMAGE_PHYSICAL and 100 or 0, self.dtype == DAMAGE_MAGIC and 100 or 0)*(self:GetPriority(hero))
			if prio < p then
			  t = hero
			  p = prio
			end
		  end
		end
		return t
	  elseif self.mode == TARGET_PRIORITY then
		local t, p = nil, math.huge
		for i=1, heroManager.iCount do
		  local hero = heroManager:getHero(i)
		  if self.IsValid(hero, self.range) and ((self.ownteam and GetTeam(hero) == GetTeam(myHero)) or (not self.ownteam and GetTeam(hero) ~= GetTeam(myHero))) then
			local prio = self:GetPriority(hero)
			if prio < p then
			  t = hero
			  p = prio
			end
		  end
		end
		return t
	  elseif self.mode == TARGET_MOST_AP then
		local t, p = nil, -1
		for i=1, heroManager.iCount do
		  local hero = heroManager:getHero(i)
		  if self.IsValid(hero, self.range) and ((self.ownteam and GetTeam(hero) == GetTeam(myHero)) or (not self.ownteam and GetTeam(hero) ~= GetTeam(myHero))) then
			local prio = GetBonusAP(hero)
			if prio > p then
			  t = hero
			  p = prio
			end
		  end
		end
		return t
	  elseif self.mode == TARGET_MOST_AD then
		local t, p = nil, -1
		for i=1, heroManager.iCount do
		  local hero = heroManager:getHero(i)
		  if self.IsValid(hero, self.range) and ((self.ownteam and GetTeam(hero) == GetTeam(myHero)) or (not self.ownteam and GetTeam(hero) ~= GetTeam(myHero))) then
			local prio = GetBaseDamage(hero)+GetBonusDmg(hero)
			if prio > p then
			  t = hero
			  p = prio
			end
		  end
		end
		return t
	  elseif self.mode == TARGET_CLOSEST then
		local t, p = nil, math.huge
		for i=1, heroManager.iCount do
		  local hero = heroManager:getHero(i)
		  if (self.ownteam and GetTeam(hero) == GetTeam(myHero)) or (not self.ownteam and GetTeam(hero) ~= GetTeam(myHero)) then
			local prio = GetD(GetOrigin(hero), GetOrigin(myHero))
			if self.IsValid(hero, self.range) and prio < p then
			  t = hero
			  p = prio
			end
		  end
		end
		return t
	  elseif self.mode == TARGET_NEAR_MOUSE then
		local t, p = nil, math.huge
		for i=1, heroManager.iCount do
		  local hero = heroManager:getHero(i)
		  if (self.ownteam and GetTeam(hero) == GetTeam(myHero)) or (not self.ownteam and GetTeam(hero) ~= GetTeam(myHero)) then
			local prio = GetD(GetOrigin(hero), GetMousePos())
			if self.IsValid(hero, self.range) and prio < p then
			  t = hero
			  p = prio
			end
		  end
		end
		return t
	  elseif self.mode == TARGET_LOW_HP then
		local t, p = nil, math.huge
		for i=1, heroManager.iCount do
		  local hero = heroManager:getHero(i)
		  if (self.ownteam and GetTeam(hero) == GetTeam(myHero)) or (not self.ownteam and GetTeam(hero) ~= GetTeam(myHero)) then
			local prio = GetCurrentHP(hero)
			if self.IsValid(hero, self.range) and prio < p then
			  t = hero
			  p = prio
			end
		  end
		end
		return t
	  elseif self.mode == TARGET_LOW_HP_PRIORITY then
		local t, p = nil, math.huge
		for i=1, heroManager.iCount do
		  local hero = heroManager:getHero(i)
		  if (self.ownteam and GetTeam(hero) == GetTeam(myHero)) or (not self.ownteam and GetTeam(hero) ~= GetTeam(myHero)) then
			local prio = GetCurrentHP(hero)*(self:GetPriority(hero))
			if self.IsValid(hero, self.range) and prio < p then
			  t = hero
			  p = prio
			end
		  end
		end
		return t
	  end
	end

	function Section:__init(head, id, name)
	  self.head = head
	  self.id = id
	  self.name = name
	  self.type = "Section"
	end

	function MenuSprite:__init(head, id, ID, x, y, height, color)
	  self.head = head
	  self.id = id
	  self.type = "MenuSprite"
	  self.ID = ID
	  self.x = x or 0
	  self.y = y or 0
	  self.height = height or 0
	  self.color = color or ARGB(255,255,255,255)
	end

	function DropDown:__init(head, id, name, value, drop, callback, forceDefault)
	  self.head = head
	  self.id = id
	  self.name = name
	  self.type = "DropDown"
	  self.value = value
	  self.drop = drop
	  self.callback = callback
	  self.forceDefault = forceDefault or false
	end

	function DropDown:Value(x)
	  if x ~= nil then
		if self.value ~= x then
		  self.value = x
		  if self.callback then self.callback(self.value) end
		  __MC_SaveAll()
		end
	  else
		return self.value
	  end
	end

	function Slider:__init(head, id, name, value, min, max, step, callback, forceDefault)
	  self.head = head
	  self.id = id
	  self.name = name
	  self.type = "Slider"
	  self.value = value
	  self.min = min
	  self.max = max
	  self.step = step or 1
	  self.callback = callback
	  self.forceDefault = forceDefault or false
	end

	function Slider:Value(x)
	  if x ~= nil then
		if self.value ~= x then
		  if x < self.min then self.value = self.min
		  elseif x > self.max then self.value = self.max
		  else self.value = x
		  end
		  if self.callback then self.callback(self.value) end
		  __MC_SaveAll()
		end
	  else
		return self.value
	  end
	end

	function Slider:Modify(min, max, step)
	  self.min = min
	  self.max = max
	  self.step = step or 1
	end

	function Slider:Get()
	  return self.min, self.max, self.step
	end

	function MenuConfig:__init(id, name, head)
	  self.__id = id
	  self.__name = name or id
	  self.__subMenus = {}
	  self.__params = {}
	  self.__active = false
	  self.__head = head
	  if not head then
		table.insert(MCadd.instances, self)
		self = __MC__load(id)
	  end
	  return self
	end

	function MenuConfig:Menu(id, name)
	  local m = MenuConfig(id, name, self)
	  table.insert(self.__subMenus, m)
	  self[id] = m
	  self[name or id] = m
	end

	function MenuConfig:KeyBinding(id, name, key, isToggle, callback, forceDefault)
	  local key = KeyBinding(self, id, name, key, isToggle, callback, forceDefault)
	  table.insert(self.__params, key)
	  self[id] = key
	  __MC_LoadAll()
	end

	function MenuConfig:Boolean(id, name, value, callback, forceDefault)
	  local bool = Boolean(self, id, name, value, callback, forceDefault)
	  table.insert(self.__params, bool)
	  self[id] = bool
	  __MC_LoadAll()
	end

	function MenuConfig:Slider(id, name, value, min, max, step, callback, forceDefault)
	  local slide = Slider(self, id, name, value, min, max, step, callback, forceDefault)
	  table.insert(self.__params, slide)
	  self[id] = slide
	  __MC_LoadAll()
	end

	function MenuConfig:UpDown(id, name, value, min, max, callback, forceDefault)
	  local slide = Slider(self, id, name, value, min, max, 1, callback, forceDefault)
	  table.insert(self.__params, slide)
	  self[id] = slide
	  __MC_LoadAll()
	end

	function MenuConfig:DropDown(id, name, value, drop, callback, forceDefault)
	  local d = DropDown(self, id, name, value, drop, callback, forceDefault)
	  table.insert(self.__params, d)
	  self[id] = d
	  __MC_LoadAll()
	end

	function MenuConfig:ColorPick(id, name, color, callback, forceDefault)
	  local cp = ColorPick(self, id, name, color, callback, forceDefault)
	  table.insert(self.__params, cp)
	  self[id] = cp
	  __MC_LoadAll()
	end

	function MenuConfig:Info(id, name)
	  local i = Info(self, id, name)
	  table.insert(self.__params, i)
	  self[id] = i
	  __MC_LoadAll()
	end

	function MenuConfig:Empty(id, value)
	  local e = Empty(self, id, value)
	  table.insert(self.__params, e)
	  self[id] = e
	  __MC_LoadAll()
	end

	function MenuConfig:TargetSelector(id, name, ts, forceDefault)
	  ts.head = self
	  ts.id = id
	  ts.name = name
	  ts.forceDefault = forceDefault or false
	  table.insert(self.__params, ts)
	  self[id] = ts
	  __MC_LoadAll()
	end

	function MenuConfig:Section(id, name)
	  local s = Section(self, id, name)
	  table.insert(self.__params, s)
	  self[id] = s
	  __MC_LoadAll()
	end

	function MenuConfig:Sprite(id, name, x, y, height, color)
	  local sID = CreateSpriteFromFile(name)
	  if sID == 0 then print("Sprite "..name.." not found!") end
	  local s = Sprite(self, id, sID, x, y, height, color)
	  table.insert(self.__params, s)
	  self[id] = s
	  __MC_LoadAll()
	end

	function MenuConfig:removeParam(id)
		for i, p in pairs(self.__params) do
			if p.id and p.id == id or p.__id and p.__id == id then
				table.remove(self.__params, i)
			end
		end
	end

	function MenuConfig:removeSubMenu(id)
		for i, p in pairs(self.__subMenus) do
			if p.id and p.id == id or p.__id and p.__id == id then
				table.remove(self.__subMenus:Value(), i)
			end
		end
	end

	function MenuConfig:clear(clearParams, clearSubMenus)
		if (clearParams) then
			local i = #self.__params;
			while i > 0 do
				local param = self.__params[i];
				table.remove(self.__params, i);
				i = i - 1;
			end
			self.__params = {};
		end

		if (clearSubMenus) then
			for i, subMenu in pairs(self.__subMenus) do
				subMenu:clear(clearParams, clearSubMenus);
			end
			self.__subMenus = {};
		end
	end

	-- backward compability
	function MenuConfig:SubMenu(id, name)
	  local m = MenuConfig(id, name, self)
	  table.insert(self.__subMenus, m)
	  self[id] = m
	  self[name or id] = m
	end

	function MenuConfig:Key(id, name, key, isToggle, callback, forceDefault)
	  local key = KeyBinding(self, id, name, key, isToggle, callback, forceDefault)
	  table.insert(self.__params, key)
	  self[id] = key
	  __MC_LoadAll()
	end

	function MenuConfig:List(id, name, value, drop, callback, forceDefault)
	  local d = DropDown(self, id, name, value, drop, callback, forceDefault)
	  table.insert(self.__params, d)
	  self[id] = d
	  __MC_LoadAll()
	end

	if not GetSave("MenuConfig").Perma_Show then 
	  GetSave("MenuConfig").Perma_Show = {x = 15, y = 400} 
	end

	local PS = GetSave("MenuConfig").Perma_Show
	local PSadd = {instances = {}}

	local function __PS__Draw()
	  local ps = #PSadd.instances
	  for k = 1, ps do
		local v = PSadd.instances[k]
		FillRect(PS.x-1, PS.y+17*k-1, 2+MC.width/2+50+25, 16, ARGB(55,255,255,255))
		FillRect(PS.x, PS.y+17*k, MC.width/2+50+25, 14, ARGB(155,0,0,0))
		DrawText(v.p.name, 12, PS.x+2, PS.y+17*k, ARGB(255,255,255,255))
		DrawText(v.p:Value() and " ON" or "OFF", 12, PS.x+2+MC.width/2+50, PS.y+17*k, v.p:Value() and ARGB(255,0,255,0) or ARGB(255,255,0,0))
	  end
	  if PSadd.moveNow then
		local cpos = GetCursorPos()
		PS.x = math.min(math.max(cpos.x - PSadd.moveNow.x, 15), 1920)
		PS.y = math.min(math.max(cpos.y - PSadd.moveNow.y, -5), 1080)
		GetSave("MenuConfig"):Save()
	  end
	end
	local function __PS__Draw_Sprites()
	  local ps = #PSadd.instances
	  if ps > 0 then
		local off = MCsprites["Background"].height
		for k = 1, ps do
			local v = PSadd.instances[k]
			MCsprites["Background"]:Draw(PS.x-MCscale, PS.y+off*k-MCscale)
			DrawText(v.p.name, MCscale*12, PS.x+MCscale*4, PS.y+off*k+MCscale*2, ARGB(255,255,255,255))
			MCsprites[v.p:Value() and "ON" or "OFF"]:Draw(PS.x+MC.width-MCsprites["ON"].width-MCscale*8, PS.y+off*k+4*MCscale)
			MCsprites["borderside"]:Draw(PS.x-MCscale*2, PS.y+off*k-MCscale)
			MCsprites["borderside"]:Draw(PS.x-MCscale*2+MC.width, PS.y+off*k-MCscale)
		end
		for k = 1, ps do
			MCsprites["between"]:Draw(PS.x-MCscale*2, PS.y+off*k-MCscale)
		end
		MCsprites["bordertopbot"]:Draw(PS.x-MCscale*2, PS.y+off-MCscale)
		MCsprites["bordertopbot"]:Draw(PS.x-MCscale*2, PS.y+off*(ps+1)-MCscale)
	  end
	  if PSadd.moveNow then
		local cpos = GetCursorPos()
		PS.x = math.min(math.max(cpos.x - PSadd.moveNow.x, 15), 1920)
		PS.y = math.min(math.max(cpos.y - PSadd.moveNow.y, -5), 1080)
		GetSave("MenuConfig"):Save()
	  end
	end
	if hasMenuSprites then
		Callback.Add("DrawMinimap", function() if mc_cfg_base.ontop:Value() and mc_cfg_base.ps:Value() then __PS__Draw_Sprites() end end)
		Callback.Add("Draw", function() if not mc_cfg_base.ontop:Value() and mc_cfg_base.ps:Value() then __PS__Draw_Sprites() end end)
	else
		Callback.Add("DrawMinimap", function() if mc_cfg_base.ontop:Value() and mc_cfg_base.ps:Value() then __PS__Draw() end end)
		Callback.Add("Draw", function() if not mc_cfg_base.ontop:Value() and mc_cfg_base.ps:Value() then __PS__Draw() end end)
	end

	local function __PS__WndMsg(msg, key)
	  if msg == 514 then
		if PSadd.moveNow then PSadd.moveNow = nil end
	  end
	  if msg == 513 and CursorIsUnder(PS.x, PS.y, MC.width/2+25, 17*#PSadd.instances+17) then
		local cpos = GetCursorPos()
		PSadd.moveNow = {x = cpos.x - PS.x, y = cpos.y - PS.y}
	  end
	end
	Callback.Add("WndMsg", __PS__WndMsg)

	function PermaShow:__init(p)
	  assert(p.type == "Boolean" or p.type == "KeyBinding", "Parameter must be of type Boolean or KeyBinding!")
	  self.p = p
	  table.insert(PSadd.instances, self)
	end;

	_G.Menu = MenuConfig
	-- backward compability end
	if not _G.mc_cfg_base then
		_G.mc_cfg_base = MenuConfig("MenuConfig", "MenuConfig")
		mc_cfg_base:Info("Inf", "MenuConfig Settings")
		mc_cfg_base:Boolean("Show", "Show always", true)
		mc_cfg_base:Boolean("ontop", "Stay OnTop", false)
		mc_cfg_base:Boolean("ps", "PermaShow", true)
		mc_cfg_base:Slider("scale", "Menu Scale (reload!)", 100, 100, 250, 1, function(var) MC.scale = var end)
		MC.width = 200*(hasMenuSprites and MCscale or 1)
		MC.h = 23*(hasMenuSprites and MCscale or 1)
		mc_cfg_base:KeyBinding("MenuKey", "Key to open Menu", 16)
	end
	function UnLoadIOW()
		if IOW then
			for i, v in pairs(IOW) do
				if type(v) == "function" then
					IOW[i] = function() end
				elseif type(v) == "table" then
					IOW[i] = {}
				else
					IOW[i] = nil
				end
			end
			IOW = nil
			for i,v in pairs(MCadd.instances) do
				if v.__name == "InspiredsOrbWalker" then
					table.remove(MCadd.instances, i)
				end
			end
			for i,v in pairs(PSadd.instances) do
				print(v.p.id)
				if v.p.id == "OrbWalking" then
					table.remove(PSadd.instances, i)
				end
			end
		end
	end; UnloadIOW = UnLoadIOW
end
do -- misc load
	myHeroName = myHero.charName
	mapID = GetMapID()
	DAMAGE_MAGIC, DAMAGE_MAGICAL, DAMAGE_PHYSICAL, DAMAGE_PHYSIC, DAMAGE_MIXED = 1, 1, 2, 2, 3
	MINION_ALLY, MINION_ENEMY, MINION_JUNGLE = myHero.team, 300-myHero.team, 300
	mixed = Set {"Akali","Corki","Ekko","Evelynn","Ezreal","Kayle","Kennen","KogMaw","Malzahar","MissFortune","Mordekaiser","Pantheon","Poppy","Shaco","Skarner","Teemo","Tristana","TwistedFate","XinZhao","Yoric"}
	ad = Set {"Aatrox","Corki","Darius","Draven","Ezreal","Fiora","Gangplank","Garen","Gnar","Graves","Hecarim","Illaoi","Irelia","JarvanIV","Jax","Jayce","Jinx","Kalista","KhaZix","KogMaw","LeeSin","Lucian","MasterYi","MissFortune","Nasus","Nocturne","Olaf","Pantheon","Quinn","RekSai","Renekton","Rengar","Riven","Shaco","Shyvana","Sion","Sivir","Talon","Tristana","Trundle","Tryndamere","Twitch","Udyr","Urgot","Varus","Vayne","Vi","Warwick","Wukong","XinZhao","Yasuo","Yoric","Zed"}
	ap = Set {"Ahri","Akali","Alistar","Amumu","Anivia","Annie","Azir","Bard","Blitzcrank","Brand","Braum","Cassiopea","ChoGath","Diana","DrMundo","Ekko","Elise","Evelynn","Fiddlesticks","Fizz","Galio","Gragas","Heimerdinger","Janna","Karma","Karthus","Kassadin","Katarina","Kayle","Kennen","LeBlanc","Leona","Lissandra","Lulu","Lux","Malphite","Malzahar","Maokai","Mordekaiser","Morgana","Nami","Nautilus","Nidalee","Nunu","Orianna","Poppy","Rammus","Rumble","Ryze","Sejuani","Shen","Singed","Skarner","Sona","Soraka","Swain","Syndra","TahmKench","Taric","Teemo","Thresh","TwistedFate","Veigar","VelKoz","Viktor","Vladimir","Volibear","Xerath","Zac","Ziggz","Zilean","Zyra"}
	GoS = {}
	GoS.White = ARGB(255,255,255,255)
	GoS.Red = ARGB(255,255,0,0)
	GoS.Blue = ARGB(255,0,0,255)
	GoS.Green = ARGB(255,0,255,0)
	GoS.Pink = ARGB(255,255,0,255)
	GoS.Black = ARGB(255,0,0,0)
	GoS.Yellow = ARGB(255,255,255,0)
	GoS.Cyan = ARGB(255,0,255,255)
	GoS.objectLoopEvents = {}
	GoS.delayedActions = {}
	GoS.delayedActionsExecuter = nil
	GoS.gapcloserTable = {
		["Aatrox"] = _Q, ["Akali"] = _R, ["Alistar"] = _W, ["Ahri"] = _R, ["Amumu"] = _Q, ["Corki"] = _W,
		["Diana"] = _R, ["Elise"] = _Q, ["Elise"] = _E, ["Fiddlesticks"] = _R, ["Fiora"] = _Q,
		["Fizz"] = _Q, ["Gnar"] = _E, ["Grags"] = _E, ["Graves"] = _E, ["Hecarim"] = _R,
		["Irelia"] = _Q, ["JarvanIV"] = _Q, ["Jax"] = _Q, ["Jayce"] = "JayceToTheSkies", ["Katarina"] = _E, 
		["Kassadin"] = _R, ["Kennen"] = _E, ["KhaZix"] = _E, ["Lissandra"] = _E, ["LeBlanc"] = _W, 
		["LeeSin"] = "blindmonkqtwo", ["Leona"] = _E, ["Lucian"] = _E, ["Malphite"] = _R, ["MasterYi"] = _Q, 
		["MonkeyKing"] = _E, ["Nautilus"] = _Q, ["Nocturne"] = _R, ["Olaf"] = _R, ["Pantheon"] = _W, 
		["Poppy"] = _E, ["RekSai"] = _E, ["Renekton"] = _E, ["Riven"] = _E, ["Sejuani"] = _Q, 
		["Sion"] = _R, ["Shen"] = _E, ["Shyvana"] = _R, ["Talon"] = _E, ["Thresh"] = _Q, 
		["Tristana"] = _W, ["Tryndamere"] = "Slash", ["Udyr"] = _E, ["Volibear"] = _Q, ["Vi"] = _Q, 
		["XinZhao"] = _E, ["Yasuo"] = _E, ["Zac"] = _E, ["Ziggs"] = _W
	}
	CHANELLING_SPELLS = {
		["CaitlynAceintheHole"]		 = {Name = "Caitlyn",	  Spellslot = _R},
		["Crowstorm"]				   = {Name = "FiddleSticks", Spellslot = _R},
		["Drain"]					   = {Name = "FiddleSticks", Spellslot = _W},
		["GalioIdolOfDurand"]		   = {Name = "Galio",		Spellslot = _R},
		["ReapTheWhirlwind"]			= {Name = "Janna",		Spellslot = _R},
		["KarthusFallenOne"]			= {Name = "Karthus",	  Spellslot = _R},
		["KatarinaR"]				   = {Name = "Katarina",	 Spellslot = _R},
		["LucianR"]					 = {Name = "Lucian",	   Spellslot = _R},
		["AlZaharNetherGrasp"]		  = {Name = "Malzahar",	 Spellslot = _R},
		["MissFortuneBulletTime"]	   = {Name = "MissFortune",  Spellslot = _R},
		["AbsoluteZero"]				= {Name = "Nunu",		 Spellslot = _R},						
		["PantheonRJump"]			   = {Name = "Pantheon",	 Spellslot = _R},
		["PantheonRFall"]			   = {Name = "Pantheon",	 Spellslot = _R},
		["ShenStandUnited"]			 = {Name = "Shen",		 Spellslot = _R},
		["Destiny"]					 = {Name = "TwistedFate",  Spellslot = _R},
		["UrgotSwap2"]				  = {Name = "Urgot",		Spellslot = _R},
		["VarusQ"]					  = {Name = "Varus",		Spellslot = _Q},
		["VelkozR"]					 = {Name = "Velkoz",	   Spellslot = _R},
		["InfiniteDuress"]			  = {Name = "Warwick",	  Spellslot = _R},
		["XerathLocusOfPower2"]		 = {Name = "Xerath",	   Spellslot = _R}
		
	}

	GAPCLOSER_SPELLS = {
		["AkaliShadowDance"]			= {Name = "Akali",	  Spellslot = _R},
		["Headbutt"]					= {Name = "Alistar",	Spellslot = _W},
		["DianaTeleport"]			   = {Name = "Diana",	  Spellslot = _R},
		["FizzPiercingStrike"]		  = {Name = "Fizz",	   Spellslot = _Q},
		["IreliaGatotsu"]			   = {Name = "Irelia",	 Spellslot = _Q},
		["JaxLeapStrike"]			   = {Name = "Jax",		Spellslot = _Q},
		["JayceToTheSkies"]			 = {Name = "Jayce",	  Spellslot = _Q},
		["blindmonkqtwo"]			   = {Name = "LeeSin",	 Spellslot = _Q},
		["MaokaiUnstableGrowth"]		= {Name = "Maokai",	 Spellslot = _W},
		["MonkeyKingNimbus"]			= {Name = "MonkeyKing", Spellslot = _E},
		["Pantheon_LeapBash"]		   = {Name = "Pantheon",   Spellslot = _W},
		["PoppyHeroicCharge"]		   = {Name = "Poppy",	  Spellslot = _E},
		["QuinnE"]					  = {Name = "Quinn",	  Spellslot = _E},
		["RengarLeap"]				  = {Name = "Rengar",	 Spellslot = _R},
		["XenZhaoSweep"]				= {Name = "XinZhao",	Spellslot = _E}
	}

	GAPCLOSER2_SPELLS = {
		["AatroxQ"]					 = {Name = "Aatrox",	 Range = 1000, ProjectileSpeed = 1200, Spellslot = _Q},
		["GragasE"]					 = {Name = "Gragas",	 Range = 600,  ProjectileSpeed = 2000, Spellslot = _E},
		["GravesMove"]				  = {Name = "Graves",	 Range = 425,  ProjectileSpeed = 2000, Spellslot = _E},
		["HecarimUlt"]				  = {Name = "Hecarim",	Range = 1000, ProjectileSpeed = 1200, Spellslot = _R},
		["JarvanIVDragonStrike"]		= {Name = "JarvanIV",   Range = 770,  ProjectileSpeed = 2000, Spellslot = _Q},
		["JarvanIVCataclysm"]		   = {Name = "JarvanIV",   Range = 650,  ProjectileSpeed = 2000, Spellslot = _R},
		["KhazixE"]					 = {Name = "Khazix",	 Range = 900,  ProjectileSpeed = 2000, Spellslot = _E},
		["khazixelong"]				 = {Name = "Khazix",	 Range = 900,  ProjectileSpeed = 2000, Spellslot = _E},
		["LeblancSlide"]				= {Name = "Leblanc",	Range = 600,  ProjectileSpeed = 2000, Spellslot = _W},
		["LeblancSlideM"]			   = {Name = "Leblanc",	Range = 600,  ProjectileSpeed = 2000, Spellslot = _R},
		["LeonaZenithBlade"]			= {Name = "Leona",	  Range = 900,  ProjectileSpeed = 2000, Spellslot = _E},
		["UFSlash"]					 = {Name = "Malphite",   Range = 1000, ProjectileSpeed = 1800, Spellslot = _R},
		["RenektonSliceAndDice"]		= {Name = "Renekton",   Range = 450,  ProjectileSpeed = 2000, Spellslot = _E},
		["SejuaniArcticAssault"]		= {Name = "Sejuani",	Range = 650,  ProjectileSpeed = 2000, Spellslot = _Q},
		["ShenShadowDash"]			  = {Name = "Shen",	   Range = 575,  ProjectileSpeed = 2000, Spellslot = _E},
		["RocketJump"]				  = {Name = "Tristana",   Range = 900,  ProjectileSpeed = 2000, Spellslot = _W},
		["slashCast"]				   = {Name = "Tryndamere", Range = 650,  ProjectileSpeed = 1450, Spellslot = _E}
	}

	DANGEROUS_SPELLS = {
		["Akali"]	  = {Spellslot = _R},
		["Alistar"]	= {Spellslot = _W},
		["Amumu"]	  = {Spellslot = _R},
		["Annie"]	  = {Spellslot = _R},
		["Ashe"]	   = {Spellslot = _R},
		["Akali"]	  = {Spellslot = _R},
		["Brand"]	  = {Spellslot = _R},
		["Braum"]	  = {Spellslot = _R},
		["Caitlyn"]	= {Spellslot = _R},
		["Cassiopeia"] = {Spellslot = _R},
		["Chogath"]	= {Spellslot = _R},
		["Darius"]	 = {Spellslot = _R},
		["Diana"]	  = {Spellslot = _R},
		["Draven"]	 = {Spellslot = _R},
		["Ekko"]	   = {Spellslot = _R},
		["Evelynn"]	= {Spellslot = _R},
		["Fiora"]	  = {Spellslot = _R},
		["Fizz"]	   = {Spellslot = _R},
		["Galio"]	  = {Spellslot = _R},
		["Garen"]	  = {Spellslot = _R},
		["Gnar"]	   = {Spellslot = _R},
		["Graves"]	 = {Spellslot = _R},
		["Hecarim"]	= {Spellslot = _R},
		["JarvanIV"]   = {Spellslot = _R},
		["Jinx"]	   = {Spellslot = _R},
		["Katarina"]   = {Spellslot = _R},
		["Kennen"]	 = {Spellslot = _R},
		["LeBlanc"]	= {Spellslot = _R},
		["LeeSin"]	 = {Spellslot = _R},
		["Leona"]	  = {Spellslot = _R},
		["Lissandra"]  = {Spellslot = _R},
		["Lux"]		= {Spellslot = _R},
		["Malphite"]   = {Spellslot = _R},
		["Malzahar"]   = {Spellslot = _R},
		["Morgana"]	= {Spellslot = _R},
		["Nautilus"]   = {Spellslot = _R},
		["Nocturne"]   = {Spellslot = _R},
		["Orianna"]	= {Spellslot = _R},
		["Rammus"]	 = {Spellslot = _E},
		["Riven"]	  = {Spellslot = _R},
		["Sejuani"]	= {Spellslot = _R},
		["Shen"]	   = {Spellslot = _E},
		["Skarner"]	= {Spellslot = _R},
		["Sona"]	   = {Spellslot = _R},
		["Syndra"]	 = {Spellslot = _R},
		["Tristana"]   = {Spellslot = _R},
		["Urgot"]	  = {Spellslot = _R},
		["Varus"]	  = {Spellslot = _R},
		["Veigar"]	 = {Spellslot = _R},
		["Vi"]		 = {Spellslot = _R},
		["Viktor"]	 = {Spellslot = _R},
		["Warwick"]	= {Spellslot = _R},
		["Yasuo"]	  = {Spellslot = _R},
		["Zed"]		= {Spellslot = _R},
		["Ziggs"]	  = {Spellslot = _R},
		["Zyra"]	   = {Spellslot = _R},
	}

	Dashes = {
		["Vayne"]	  = {Spellslot = _Q, Range = 300, Delay = 250},
		["Riven"]	  = {Spellslot = _E, Range = 325, Delay = 250},
		["Ezreal"]	 = {Spellslot = _E, Range = 450, Delay = 250},
		["Caitlyn"]	= {Spellslot = _E, Range = 400, Delay = 250},
		["Kassadin"]   = {Spellslot = _R, Range = 700, Delay = 250},
		["Graves"]	 = {Spellslot = _E, Range = 425, Delay = 250},
		["Renekton"]   = {Spellslot = _E, Range = 450, Delay = 250},
		["Aatrox"]	 = {Spellslot = _Q, Range = 650, Delay = 250},
		["Gragas"]	 = {Spellslot = _E, Range = 600, delay = 250},
		["Khazix"]	 = {Spellslot = _E, Range = 600, Delay = 250},
		["Lucian"]	 = {Spellslot = _E, Range = 425, Delay = 250},
		["Sejuani"]	= {Spellslot = _Q, Range = 650, Delay = 250},
		["Shen"]	   = {Spellslot = _E, Range = 575, Delay = 250},
		["Tryndamere"] = {Spellslot = _E, Range = 660, Delay = 250},
		["Tristana"]   = {Spellslot = _W, Range = 900, Delay = 250},
		["Corki"]	  = {Spellslot = _W, Range = 800, Delay = 250},
	}
	CalcDamage = function(i, t, d, a) return a and d and (i:CalcMagicDamage(t, a)+i:CalcDamage(t, d)) or a and i:CalcMagicDamage(t, a) or i:CalcDamage(t, d) end
	local syncCallback = -1
	_G.AutoUpdate = function(gitLua, gitVersion, localLua, localVersion)
		AutoUpdater(localVersion, true, "raw.githubusercontent.com", gitVersion, gitLua, localLua, function()print("Updated "..localLua)end, function()end, function()end, function()end)
	end
end

_G.mc_cfg_orb = MenuConfig("Orbwalker", "Orbwalker")
mc_cfg_orb:DropDown("orb", "Select your orbwalker:", 2, {"Disabled", "IOW", "DAC", "Platywalk", "GoSWalk"})
mc_cfg_orb.orb.callback = function() print("Please 2x F6 to change Orbwalkers") end

function LoadOrb()
	if mc_cfg_orb.orb:Value() == 1 then
		print("All Orbwalkers Disabled!")
	elseif mc_cfg_orb.orb:Value() == 2 and not IOW_Loaded then
		require("IOW")
		LoadIOW()
		_G.IOW_Loaded = true
	elseif mc_cfg_orb.orb:Value() == 3 and not DAC_Loaded then
		require("Deftsu's Auto Carry")
		LoadDAC()
		_G.DAC_Loaded = true
	elseif mc_cfg_orb.orb:Value() == 4 and not PW_Loaded then
		require("Platywalk")
		LoadPW()
		_G.PW_Loaded = true
	elseif mc_cfg_orb.orb:Value() == 5 and not GoSWalkLoaded then
		require("GoSWalk")
		LoadGoSWalk()
		_G.GoSWalkLoaded = true
	end
end

LoadOrb()
