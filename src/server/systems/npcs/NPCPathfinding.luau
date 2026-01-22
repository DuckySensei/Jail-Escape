-- NPCPathfinding.luau
-- Pathfinding wrapper for NPCs

local NPCPathfinding = {}
NPCPathfinding.__index = NPCPathfinding

local PathfindingService = game:GetService("PathfindingService")

function NPCPathfinding.new()
	local self = setmetatable({}, NPCPathfinding)
	return self
end

-- Create a path from start to end
function NPCPathfinding:CreatePath(startPosition: Vector3, endPosition: Vector3): Path?
	local path = PathfindingService:CreatePath({
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true,
	})
	
	local success, errorMessage = pcall(function()
		path:ComputeAsync(startPosition, endPosition)
	end)
	
	if not success then
		warn("NPCPathfinding: Path computation failed:", errorMessage)
		return nil
	end
	
	if path.Status == Enum.PathStatus.NoPath then
		return nil
	end
	
	return path
end

-- Get waypoints from a path
function NPCPathfinding:GetWaypoints(path: Path): {PathWaypoint}
	return path:GetWaypoints()
end

-- Check if pathfinding is valid (no major obstacles)
function NPCPathfinding:IsPathValid(startPosition: Vector3, endPosition: Vector3): boolean
	local path = self:CreatePath(startPosition, endPosition)
	return path ~= nil
end

return NPCPathfinding
