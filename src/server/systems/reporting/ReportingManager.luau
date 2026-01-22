-- ReportingManager.luau
-- Main reporting system coordinator

local ReportingManager = {}
ReportingManager.__index = ReportingManager

local ReportVerifier = require(script.Parent.ReportVerifier)
local ReportProcessor = require(script.Parent.ReportProcessor)

function ReportingManager.new(playerManager, activityTracker)
	local self = setmetatable({}, ReportingManager)
	self._playerManager = playerManager
	self._activityTracker = activityTracker
	self._guardManager = nil -- Set later to avoid circular dependency
	self._verifier = ReportVerifier.new(activityTracker)
	self._processor = ReportProcessor.new(playerManager)
	self._reports = {} -- Array of reports
	
	return self
end

-- Set guard manager (called after GuardManager is created)
function ReportingManager:SetGuardManager(guardManager)
	self._guardManager = guardManager
	self._processor:SetGuardManager(guardManager)
end

-- Submit a report
function ReportingManager:SubmitReport(reporterUserId: number, targetUserId: number, location: Vector3, activityType: string, observationTime: number): boolean
	-- Verify report
	local isValid = self._verifier:VerifyReport(targetUserId, activityType, location, observationTime)
	
	-- Create report record
	local report = {
		id = tostring(tick()) .. "_" .. tostring(math.random(1000, 9999)),
		reporterUserId = reporterUserId,
		targetUserId = targetUserId,
		location = location,
		activityType = activityType,
		observationTime = observationTime,
		timestamp = tick(),
		isValid = isValid,
	}
	
	table.insert(self._reports, report)
	
	-- Process outcome
	if isValid then
		self._processor:ProcessSuccessfulReport(reporterUserId)
	else
		self._processor:ProcessFalseReport(reporterUserId)
	end
	
	-- Log activity
	self._activityTracker:LogActivity(reporterUserId, "ReportSubmitted", location, {
		targetUserId = targetUserId,
		reportDetails = activityType,
		isValid = isValid,
	})
	
	return isValid
end

-- Get all reports
function ReportingManager:GetAllReports(): {any}
	return self._reports
end

-- Get reports for a player (as reporter)
function ReportingManager:GetPlayerReports(userId: number): {any}
	local playerReports = {}
	for _, report in ipairs(self._reports) do
		if report.reporterUserId == userId then
			table.insert(playerReports, report)
		end
	end
	return playerReports
end

return ReportingManager
