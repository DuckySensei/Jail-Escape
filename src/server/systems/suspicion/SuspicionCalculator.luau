-- SuspicionCalculator.luau
-- Calculates suspicion levels based on behavior

local SuspicionCalculator = {}
SuspicionCalculator.__index = SuspicionCalculator

local RS = game:GetService("ReplicatedStorage")
local GameSettings = require(RS.Shared.config.GameSettings)

function SuspicionCalculator.new(activityTracker)
	local self = setmetatable({}, SuspicionCalculator)
	self._activityTracker = activityTracker
	self._locationFrequencyThreshold = GameSettings.LOCATION_VISIT_SUSPICIOUS_COUNT or 3
	return self
end

-- Calculate suspicion based on activities
function SuspicionCalculator:CalculateSuspicion(userId: number, currentSuspicion: number, activities: {Activity}): number
	local suspicion = currentSuspicion or 0
	
	-- Analyze location frequency
	local locationCounts = {}
	for _, activity in ipairs(activities) do
		if activity.type == "LocationVisit" then
			local locationName = activity.details.locationName or "Unknown"
			locationCounts[locationName] = (locationCounts[locationName] or 0) + 1
		end
	end
	
	-- Add suspicion for frequent location visits
	for locationName, count in pairs(locationCounts) do
		if count >= self._locationFrequencyThreshold then
			suspicion = suspicion + (count - self._locationFrequencyThreshold + 1) * 2
		end
	end
	
	-- Add suspicion for item usage (contraband)
	for _, activity in ipairs(activities) do
		if activity.type == "ItemUse" or activity.type == "ItemPickup" then
			local itemId = activity.details.itemId
			if itemId then
				-- Item suspicion will be calculated based on item definitions
				-- For now, add base suspicion
				suspicion = suspicion + 3
			end
		end
	end
	
	-- Add suspicion for suspicious behaviors
	for _, activity in ipairs(activities) do
		if activity.type == "SuspiciousBehavior" then
			suspicion = suspicion + 5
		elseif activity.type == "EscapeMethodProgress" then
			suspicion = suspicion + 8
		elseif activity.type == "GuardInteraction" then
			suspicion = suspicion + 10
		end
	end
	
	-- Cap at maximum
	return math.min(suspicion, GameSettings.SUSPICION_MAX)
end

-- Calculate suspicion decay
function SuspicionCalculator:CalculateDecay(currentSuspicion: number, timeSinceLastActivity: number): number
	if currentSuspicion <= 0 then
		return 0
	end
	
	local decayRate = GameSettings.SUSPICION_DECAY_RATE or 0.1
	local hoursSinceActivity = timeSinceLastActivity / 3600 -- Convert seconds to hours
	local decayAmount = decayRate * hoursSinceActivity * currentSuspicion
	
	-- Higher suspicion decays slower
	local decayMultiplier = 1 - (currentSuspicion / GameSettings.SUSPICION_MAX) * 0.5
	decayAmount = decayAmount * decayMultiplier
	
	return math.max(0, currentSuspicion - decayAmount)
end

return SuspicionCalculator
