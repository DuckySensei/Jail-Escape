-- ActivityLogger.luau
-- Logs player activities with timestamps

local ActivityLogger = {}
ActivityLogger.__index = ActivityLogger

function ActivityLogger.new()
	local self = setmetatable({}, ActivityLogger)
	return self
end

-- Log an activity
function ActivityLogger:LogActivity(userId: number, activityType: string, location: Vector3, details: {[string]: any}): Activity
	local activity: Activity = {
		timestamp = tick(),
		type = activityType,
		location = location,
		details = details or {},
	}
	
	return activity
end

-- Get current day (based on game time)
function ActivityLogger:GetCurrentDay(startTime: number): number
	local gameTimeScale = 1/10 -- 1 game hour = 10 real minutes
	local realTimeElapsed = tick() - startTime
	local gameTimeElapsed = realTimeElapsed / gameTimeScale
	local gameDays = math.floor(gameTimeElapsed / 1440) + 1 -- 1440 minutes = 1 game day
	
	return gameDays
end

return ActivityLogger
