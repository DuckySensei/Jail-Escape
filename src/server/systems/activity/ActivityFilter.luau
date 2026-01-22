-- ActivityFilter.luau
-- Filters suspicious activities from activity logs

local ActivityFilter = {}
ActivityFilter.__index = ActivityFilter

function ActivityFilter.new()
	local self = setmetatable({}, ActivityFilter)
	return self
end

-- Check if an activity is suspicious
function ActivityFilter:IsSuspicious(activity: Activity): boolean
	local activityType = activity.type
	
	-- Suspicious activity types
	local suspiciousTypes = {
		["ItemUse"] = true,
		["ItemPickup"] = true,
		["EscapeMethodProgress"] = true,
		["SuspiciousBehavior"] = true,
		["GuardInteraction"] = true,
	}
	
	if suspiciousTypes[activityType] then
		return true
	end
	
	-- Check item-related activities for contraband
	if activityType == "ItemUse" or activityType == "ItemPickup" then
		local itemId = activity.details.itemId
		if itemId then
			-- Items with high suspicion value are suspicious
			-- This will be checked against item definitions later
			return true -- Assume suspicious for now, will refine with item system
		end
	end
	
	-- Check for suspicious locations
	if activityType == "LocationVisit" then
		local locationName = activity.details.locationName
		if locationName then
			local suspiciousLocations = {
				["Armory"] = true,
				["WardenOffice"] = true,
				["SecurityRoom"] = true,
				["Perimeter"] = true,
			}
			return suspiciousLocations[locationName] == true
		end
	end
	
	return false
end

-- Filter activities to only suspicious ones
function ActivityFilter:FilterSuspiciousActivities(activities: {Activity}): {Activity}
	local suspiciousActivities = {}
	
	for _, activity in ipairs(activities) do
		if self:IsSuspicious(activity) then
			table.insert(suspiciousActivities, activity)
		end
	end
	
	return suspiciousActivities
end

-- Get activities in a time range
function ActivityFilter:GetActivitiesInTimeRange(activities: {Activity}, startTime: number, endTime: number): {Activity}
	local filteredActivities = {}
	
	for _, activity in ipairs(activities) do
		if activity.timestamp >= startTime and activity.timestamp <= endTime then
			table.insert(filteredActivities, activity)
		end
	end
	
	return filteredActivities
end

return ActivityFilter
