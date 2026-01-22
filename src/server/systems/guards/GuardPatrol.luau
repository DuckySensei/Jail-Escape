-- GuardPatrol.luau
-- Manages guard patrol routes

local GuardPatrol = {}
GuardPatrol.__index = GuardPatrol

local CollectionService = game:GetService("CollectionService")
local NPCPathfinding = require(script.Parent.Parent.npcs.NPCPathfinding)

function GuardPatrol.new()
	local self = setmetatable({}, GuardPatrol)
	self._patrolRoutes = {} -- routeId -> {waypoints}
	self._pathfinding = NPCPathfinding.new()
	
	-- Find patrol routes in workspace
	self:FindPatrolRoutes()
	
	return self
end

-- Find patrol routes in workspace
function GuardPatrol:FindPatrolRoutes()
	local waypoints = CollectionService:GetTagged("PatrolWaypoint")
	
	-- Group waypoints by route
	local routes = {}
	for _, waypoint in ipairs(waypoints) do
		local routeId = waypoint:GetAttribute("RouteId")
		local waypointIndex = waypoint:GetAttribute("WaypointIndex")
		
		if routeId and waypointIndex then
			if not routes[routeId] then
				routes[routeId] = {}
			end
			
			local position = waypoint:IsA("BasePart") and waypoint.Position or
			                 (waypoint:IsA("Model") and waypoint.PrimaryPart and waypoint.PrimaryPart.Position) or
			                 waypoint.Position
			
			routes[routeId][waypointIndex] = position
		end
	end
	
	-- Convert to sorted arrays
	for routeId, waypointMap in pairs(routes) do
		local sortedWaypoints = {}
		for index, position in pairs(waypointMap) do
			sortedWaypoints[index] = position
		end
		self._patrolRoutes[routeId] = sortedWaypoints
	end
	
	print("GuardPatrol: Found", #self._patrolRoutes, "patrol routes")
end

-- Get patrol route
function GuardPatrol:GetRoute(routeId: string): {Vector3}?
	return self._patrolRoutes[routeId]
end

-- Get all routes
function GuardPatrol:GetAllRoutes(): {[string]: {Vector3}}
	return self._patrolRoutes
end

-- Get next waypoint in route
function GuardPatrol:GetNextWaypoint(routeId: string, currentIndex: number): Vector3?
	local route = self._patrolRoutes[routeId]
	if not route then
		return nil
	end
	
	local nextIndex = currentIndex + 1
	if nextIndex > #route then
		nextIndex = 1 -- Loop back to start
	end
	
	return route[nextIndex]
end

return GuardPatrol
