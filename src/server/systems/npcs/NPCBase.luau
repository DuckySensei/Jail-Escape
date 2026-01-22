-- NPCBase.luau
-- Base class for all NPCs

local NPCBase = {}
NPCBase.__index = NPCBase

function NPCBase.new(npcId: string, npcType: string, spawnPosition: Vector3)
	local self = setmetatable({}, NPCBase)
	self._id = npcId
	self._type = npcType
	self._spawnPosition = spawnPosition
	self._currentLocation = spawnPosition
	self._targetLocation = nil
	self._isPathfinding = false
	self._currentTask = nil
	self._behaviorState = "Idle"
	
	return self
end

-- Get NPC ID
function NPCBase:GetId(): string
	return self._id
end

-- Get NPC type
function NPCBase:GetType(): string
	return self._type
end

-- Get current location
function NPCBase:GetCurrentLocation(): Vector3
	return self._currentLocation
end

-- Set target location
function NPCBase:SetTargetLocation(location: Vector3)
	self._targetLocation = location
end

-- Get target location
function NPCBase:GetTargetLocation(): Vector3?
	return self._targetLocation
end

-- Set pathfinding state
function NPCBase:SetPathfinding(isPathfinding: boolean)
	self._isPathfinding = isPathfinding
end

-- Check if pathfinding
function NPCBase:IsPathfinding(): boolean
	return self._isPathfinding
end

-- Set current task
function NPCBase:SetCurrentTask(taskId: string?)
	self._currentTask = taskId
end

-- Get current task
function NPCBase:GetCurrentTask(): string?
	return self._currentTask
end

-- Set behavior state
function NPCBase:SetBehaviorState(state: string)
	self._behaviorState = state
end

-- Get behavior state
function NPCBase:GetBehaviorState(): string
	return self._behaviorState
end

-- Update location (called when NPC moves)
function NPCBase:UpdateLocation(location: Vector3)
	self._currentLocation = location
end

return NPCBase
