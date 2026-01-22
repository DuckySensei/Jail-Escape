-- GuardInvestigation.luau
-- Handles guard investigation logic

local GuardInvestigation = {}
GuardInvestigation.__index = GuardInvestigation

function GuardInvestigation.new()
	local self = setmetatable({}, GuardInvestigation)
	self._activeInvestigations = {} -- guardId -> {targetUserId, location, startTime}
	return self
end

-- Start an investigation
function GuardInvestigation:StartInvestigation(guardId: string, targetUserId: number, location: Vector3)
	self._activeInvestigations[guardId] = {
		targetUserId = targetUserId,
		location = location,
		startTime = tick(),
	}
end

-- End an investigation
function GuardInvestigation:EndInvestigation(guardId: string)
	self._activeInvestigations[guardId] = nil
end

-- Get active investigation
function GuardInvestigation:GetInvestigation(guardId: string): any?
	return self._activeInvestigations[guardId]
end

-- Check if guard is investigating
function GuardInvestigation:IsInvestigating(guardId: string): boolean
	return self._activeInvestigations[guardId] ~= nil
end

-- Get investigation target
function GuardInvestigation:GetInvestigationTarget(guardId: string): number?
	local investigation = self._activeInvestigations[guardId]
	return investigation and investigation.targetUserId or nil
end

return GuardInvestigation
