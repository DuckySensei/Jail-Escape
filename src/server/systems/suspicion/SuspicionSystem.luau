-- SuspicionSystem.luau
-- Main suspicion system coordinator

local SuspicionSystem = {}
SuspicionSystem.__index = SuspicionSystem

local SuspicionCalculator = require(script.Parent.SuspicionCalculator)
local SuspicionTracker = require(script.Parent.SuspicionTracker)
local BehaviorAnalyzer = require(script.Parent.BehaviorAnalyzer)

local RS = game:GetService("ReplicatedStorage")
local GameSettings = require(RS.Shared.config.GameSettings)

function SuspicionSystem.new(activityTracker)
	local self = setmetatable({}, SuspicionSystem)
	self._activityTracker = activityTracker
	self._calculator = SuspicionCalculator.new(activityTracker)
	self._tracker = SuspicionTracker.new()
	self._analyzer = BehaviorAnalyzer.new()
	
	-- Start suspicion decay loop
	self._decayConnection = nil
	self:StartDecayLoop()
	
	return self
end

-- Log an activity and update suspicion
function SuspicionSystem:LogActivity(userId: number, activityType: string, location: Vector3, details: {[string]: any})
	-- Get current day's activities
	local currentDay = self._activityTracker._logger:GetCurrentDay(self._activityTracker._gameStartTime)
	local activities = self._activityTracker:GetPlayerActivities(userId, currentDay)
	
	-- Calculate new suspicion
	local currentSuspicion = self._tracker:GetSuspicion(userId)
	local newSuspicion = self._calculator:CalculateSuspicion(userId, currentSuspicion, activities)
	
	-- Update tracker
	self._tracker:UpdateSuspicion(userId, newSuspicion)
	
	return newSuspicion
end

-- Get suspicion level for a player
function SuspicionSystem:GetSuspicion(userId: number): number
	return self._tracker:GetSuspicion(userId)
end

-- Get suspicion level category
function SuspicionSystem:GetSuspicionCategory(userId: number): string
	local suspicion = self:GetSuspicion(userId)
	
	if suspicion <= 30 then
		return "Low"
	elseif suspicion <= 60 then
		return "Medium"
	elseif suspicion <= 80 then
		return "High"
	else
		return "Critical"
	end
end

-- Get behavior pattern for a player
function SuspicionSystem:GetBehaviorPattern(userId: number): BehaviorPattern
	local activities = self._activityTracker:GetAllPlayerActivities(userId)
	return self._analyzer:GetBehaviorPattern(userId, activities)
end

-- Start suspicion decay loop
function SuspicionSystem:StartDecayLoop()
	local RunService = game:GetService("RunService")
	
	self._decayConnection = RunService.Heartbeat:Connect(function()
		-- Decay suspicion periodically
		task.wait(GameSettings.SUSPICION_DECAY_COOLDOWN or 3600)
		
		for userId, suspicion in pairs(self._tracker:GetAllSuspicionLevels()) do
			local lastActivityTime = self._tracker:GetLastActivityTime(userId)
			if lastActivityTime then
				local timeSinceActivity = tick() - lastActivityTime
				local decayedSuspicion = self._calculator:CalculateDecay(suspicion, timeSinceActivity)
				self._tracker:ApplyDecay(userId, decayedSuspicion)
			end
		end
	end)
end

-- Stop suspicion decay loop
function SuspicionSystem:StopDecayLoop()
	if self._decayConnection then
		self._decayConnection:Disconnect()
		self._decayConnection = nil
	end
end

-- Cleanup
function SuspicionSystem:Cleanup()
	self:StopDecayLoop()
end

return SuspicionSystem
