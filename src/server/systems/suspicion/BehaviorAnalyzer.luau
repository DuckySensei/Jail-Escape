-- BehaviorAnalyzer.luau
-- Analyzes behavior patterns for suspicion calculation

local BehaviorAnalyzer = {}
BehaviorAnalyzer.__index = BehaviorAnalyzer

function BehaviorAnalyzer.new()
	local self = setmetatable({}, BehaviorAnalyzer)
	return self
end

-- Analyze location visit frequency
function BehaviorAnalyzer:AnalyzeLocationFrequency(activities: {Activity}): {[string]: number}
	local locationCounts = {}
	
	for _, activity in ipairs(activities) do
		if activity.type == "LocationVisit" then
			local locationName = activity.details.locationName or "Unknown"
			locationCounts[locationName] = (locationCounts[locationName] or 0) + 1
		end
	end
	
	return locationCounts
end

-- Check if location visits are suspicious (visiting same location multiple times)
function BehaviorAnalyzer:IsLocationFrequencySuspicious(locationCounts: {[string]: number}, threshold: number): boolean
	for locationName, count in pairs(locationCounts) do
		if count >= threshold then
			return true
		end
	end
	return false
end

-- Analyze item usage patterns
function BehaviorAnalyzer:AnalyzeItemUsage(activities: {Activity}): {[string]: number}
	local itemCounts = {}
	
	for _, activity in ipairs(activities) do
		if activity.type == "ItemUse" or activity.type == "ItemPickup" then
			local itemId = activity.details.itemId
			if itemId then
				itemCounts[itemId] = (itemCounts[itemId] or 0) + 1
			end
		end
	end
	
	return itemCounts
end

-- Analyze unusual behavior patterns
function BehaviorAnalyzer:AnalyzeUnusualBehavior(activities: {Activity}): number
	local unusualBehaviorCount = 0
	
	for _, activity in ipairs(activities) do
		if activity.type == "SuspiciousBehavior" then
			unusualBehaviorCount = unusualBehaviorCount + 1
		end
		
		-- Activities outside normal routine
		if activity.type == "EscapeMethodProgress" then
			unusualBehaviorCount = unusualBehaviorCount + 2 -- More suspicious
		end
		
		if activity.type == "GuardInteraction" then
			unusualBehaviorCount = unusualBehaviorCount + 3 -- Very suspicious
		end
	end
	
	return unusualBehaviorCount
end

-- Get behavior pattern summary
function BehaviorAnalyzer:GetBehaviorPattern(userId: number, activities: {Activity}): BehaviorPattern
	local locationCounts = self:AnalyzeLocationFrequency(activities)
	local lastActivity = activities[#activities] or nil
	
	return {
		userId = userId,
		commonLocations = locationCounts,
		suspicionLevel = 0, -- Will be calculated by SuspicionCalculator
		lastSeen = lastActivity and lastActivity.timestamp or tick(),
		lastLocation = lastActivity and lastActivity.location or nil,
	}
end

return BehaviorAnalyzer
