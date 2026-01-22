-- GuardNPC.luau
-- Guard NPC implementation

local GuardNPC = {}
GuardNPC.__index = GuardNPC

local NPCBase = require(script.Parent.Parent.npcs.NPCBase)

function GuardNPC.new(guardId: string, spawnPosition: Vector3, patrolRoute: {Vector3})
	local self = setmetatable(NPCBase.new(guardId, "Guard", spawnPosition), GuardNPC)
	self._patrolRoute = patrolRoute
	self._currentPatrolIndex = 1
	self._investigatingTarget = nil
	self._surveillanceTargets = {}
	
	return self
end

-- Get patrol route
function GuardNPC:GetPatrolRoute(): {Vector3}
	return self._patrolRoute
end

-- Get current patrol waypoint
function GuardNPC:GetCurrentWaypoint(): Vector3?
	if self._patrolRoute and #self._patrolRoute > 0 then
		return self._patrolRoute[self._currentPatrolIndex]
	end
	return nil
end

-- Move to next waypoint
function GuardNPC:NextWaypoint()
	if self._patrolRoute and #self._patrolRoute > 0 then
		self._currentPatrolIndex = self._currentPatrolIndex + 1
		if self._currentPatrolIndex > #self._patrolRoute then
			self._currentPatrolIndex = 1 -- Loop back
		end
	end
end

-- Set investigating target
function GuardNPC:SetInvestigatingTarget(userId: number?)
	self._investigatingTarget = userId
end

-- Get investigating target
function GuardNPC:GetInvestigatingTarget(): number?
	return self._investigatingTarget
end

-- Add surveillance target
function GuardNPC:AddSurveillanceTarget(userId: number)
	table.insert(self._surveillanceTargets, userId)
end

-- Remove surveillance target
function GuardNPC:RemoveSurveillanceTarget(userId: number)
	for i, target in ipairs(self._surveillanceTargets) do
		if target == userId then
			table.remove(self._surveillanceTargets, i)
			break
		end
	end
end

-- Get surveillance targets
function GuardNPC:GetSurveillanceTargets(): {number}
	return self._surveillanceTargets
end

-- Order inmate to leave current task (if suspicion is high)
function GuardNPC:CanOrderInmateToLeave(suspicionLevel: number): boolean
	-- Guards can order inmates to leave tasks if suspicion is medium or higher
	return suspicionLevel >= 30
end

return GuardNPC
