-- SuspicionTracker.luau
-- Tracks suspicion per player

local SuspicionTracker = {}
SuspicionTracker.__index = SuspicionTracker

function SuspicionTracker.new()
	local self = setmetatable({}, SuspicionTracker)
	self._suspicionLevels = {} -- userId -> suspicion (0-100)
	self._lastActivityTimes = {} -- userId -> timestamp
	return self
end

-- Get suspicion level for a player
function SuspicionTracker:GetSuspicion(userId: number): number
	return self._suspicionLevels[userId] or 0
end

-- Set suspicion level for a player
function SuspicionTracker:SetSuspicion(userId: number, suspicion: number)
	self._suspicionLevels[userId] = math.max(0, math.min(100, suspicion))
end

-- Update suspicion based on activities
function SuspicionTracker:UpdateSuspicion(userId: number, newSuspicion: number)
	self:SetSuspicion(userId, newSuspicion)
	self._lastActivityTimes[userId] = tick()
end

-- Get last activity time
function SuspicionTracker:GetLastActivityTime(userId: number): number?
	return self._lastActivityTimes[userId]
end

-- Apply suspicion decay
function SuspicionTracker:ApplyDecay(userId: number, decayedSuspicion: number)
	self:SetSuspicion(userId, decayedSuspicion)
end

-- Get all suspicion levels
function SuspicionTracker:GetAllSuspicionLevels(): {[number]: number}
	return self._suspicionLevels
end

-- Clear suspicion for a player
function SuspicionTracker:ClearSuspicion(userId: number)
	self._suspicionLevels[userId] = nil
	self._lastActivityTimes[userId] = nil
end

return SuspicionTracker
