-- ActivityTracker.luau
-- Main activity tracking system - tracks all player activities

local ActivityTracker = {}
ActivityTracker.__index = ActivityTracker

local ActivityLogger = require(script.Parent.ActivityLogger)
local ActivityFilter = require(script.Parent.ActivityFilter)

function ActivityTracker.new(gameStartTime: number)
	local self = setmetatable({}, ActivityTracker)
	self._logger = ActivityLogger.new()
	self._filter = ActivityFilter.new()
	self._gameStartTime = gameStartTime
	self._activityLogs = {} -- userId -> DailyActivityLog
	
	return self
end

-- Log a player activity
function ActivityTracker:LogActivity(userId: number, activityType: string, location: Vector3, details: {[string]: any})
	local activity = self._logger:LogActivity(userId, activityType, location, details)
	local currentDay = self._logger:GetCurrentDay(self._gameStartTime)
	
	-- Initialize daily log if needed
	if not self._activityLogs[userId] then
		self._activityLogs[userId] = {}
	end
	
	if not self._activityLogs[userId][currentDay] then
		self._activityLogs[userId][currentDay] = {
			activities = {},
		}
	end
	
	-- Add activity to log
	table.insert(self._activityLogs[userId][currentDay].activities, activity)
	
	return activity
end

-- Get all activities for a player on a specific day
function ActivityTracker:GetPlayerActivities(userId: number, day: number): {Activity}
	if not self._activityLogs[userId] or not self._activityLogs[userId][day] then
		return {}
	end
	
	return self._activityLogs[userId][day].activities
end

-- Get suspicious activities for a player on a specific day
function ActivityTracker:GetSuspiciousActivities(userId: number, day: number): {Activity}
	local activities = self:GetPlayerActivities(userId, day)
	return self._filter:FilterSuspiciousActivities(activities)
end

-- Get all activities for a player (all days)
function ActivityTracker:GetAllPlayerActivities(userId: number): {Activity}
	if not self._activityLogs[userId] then
		return {}
	end
	
	local allActivities = {}
	for day, log in pairs(self._activityLogs[userId]) do
		for _, activity in ipairs(log.activities) do
			table.insert(allActivities, activity)
		end
	end
	
	return allActivities
end

-- Get activities in a time range for a player
function ActivityTracker:GetActivitiesInTimeRange(userId: number, startTime: number, endTime: number): {Activity}
	local allActivities = self:GetAllPlayerActivities(userId)
	return self._filter:GetActivitiesInTimeRange(allActivities, startTime, endTime)
end

-- Verify if an activity occurred (for reporting system)
function ActivityTracker:VerifyActivity(userId: number, activityType: string, location: Vector3, timeRange: any): boolean
	local activities = self:GetActivitiesInTimeRange(userId, timeRange.start, timeRange["end"])
	
	for _, activity in ipairs(activities) do
		if activity.type == activityType then
			-- Check if location is close enough (within 10 studs)
			local distance = (activity.location - location).Magnitude
			if distance <= 10 then
				return true
			end
		end
	end
	
	return false
end

-- Get activity log for a player (for reporting)
function ActivityTracker:GetActivityLog(userId: number): DailyActivityLog
	return self._activityLogs[userId] or {}
end

-- Clear old activity logs (cleanup)
function ActivityTracker:ClearOldLogs(maxDays: number)
	local currentDay = self._logger:GetCurrentDay(self._gameStartTime)
	
	for userId, dailyLogs in pairs(self._activityLogs) do
		for day, _ in pairs(dailyLogs) do
			if day < currentDay - maxDays then
				dailyLogs[day] = nil
			end
		end
	end
end

return ActivityTracker
