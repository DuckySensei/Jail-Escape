-- ReportVerifier.luau
-- Verifies reports against activity log

local ReportVerifier = {}
ReportVerifier.__index = ReportVerifier

function ReportVerifier.new(activityTracker)
	local self = setmetatable({}, ReportVerifier)
	self._activityTracker = activityTracker
	return self
end

-- Verify a report
function ReportVerifier:VerifyReport(targetUserId: number, activityType: string, location: Vector3, observationTime: number): boolean
	-- Get activities around the observation time (within 5 minutes)
	local timeRange = {
		start = observationTime - 300, -- 5 minutes before
		["end"] = observationTime + 300, -- 5 minutes after
	}
	
	-- Verify activity occurred
	return self._activityTracker:VerifyActivity(targetUserId, activityType, location, timeRange)
end

-- Check if report is false
function ReportVerifier:IsFalseReport(targetUserId: number, activityType: string, location: Vector3, observationTime: number): boolean
	return not self:VerifyReport(targetUserId, activityType, location, observationTime)
end

return ReportVerifier
