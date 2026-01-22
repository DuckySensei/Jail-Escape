-- ReportProcessor.luau
-- Processes report outcomes

local ReportProcessor = {}
ReportProcessor.__index = ReportProcessor

local RS = game:GetService("ReplicatedStorage")
local GameSettings = require(RS.Shared.config.GameSettings)

function ReportProcessor.new(playerManager)
	local self = setmetatable({}, ReportProcessor)
	self._playerManager = playerManager
	self._guardManager = nil -- Set later to avoid circular dependency
	return self
end

-- Set guard manager (called after GuardManager is created)
function ReportProcessor:SetGuardManager(guardManager)
	self._guardManager = guardManager
end

-- Process successful report
function ReportProcessor:ProcessSuccessfulReport(reporterUserId: number)
	-- Reward reporter with money
	local resourceSystem = nil -- TODO: Get from game manager
	if resourceSystem then
		resourceSystem:AddMoney(reporterUserId, GameSettings.SUCCESSFUL_REPORT_REWARD or 10)
	end
	
	print("ReportProcessor: Successful report from player", reporterUserId, "- reward given")
end

-- Process false report
function ReportProcessor:ProcessFalseReport(reporterUserId: number)
	-- Send reporter to solitary confinement
	local playerData = self._playerManager:GetPlayerData(reporterUserId)
	if playerData then
		-- TODO: Send to solitary
		-- self._guardManager:SendToSolitary(reporterUserId)
		print("ReportProcessor: False report from player", reporterUserId, "- sending to solitary")
	end
end

return ReportProcessor
