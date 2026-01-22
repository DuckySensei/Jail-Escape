-- WardenAI.luau
-- Intelligent warden decision-making system

local WardenAI = {}
WardenAI.__index = WardenAI

local RS = game:GetService("ReplicatedStorage")
local GameSettings = require(RS.Shared.config.GameSettings)

function WardenAI.new(suspicionSystem, activityTracker)
	local self = setmetatable({}, WardenAI)
	self._suspicionSystem = suspicionSystem
	self._activityTracker = activityTracker
	self._knownPatterns = {} -- userId -> BehaviorPattern
	self._dailyTasks = {}
	self._currentTask = nil
	self._lastPatternAnalysis = tick()
	
	return self
end

-- Analyze behavior patterns for all players
function WardenAI:AnalyzePatterns()
	local currentTime = tick()
	local analysisInterval = GameSettings.WARDEN_PATTERN_ANALYSIS_INTERVAL or 600
	
	if currentTime - self._lastPatternAnalysis < analysisInterval then
		return -- Too soon to analyze again
	end
	
	self._lastPatternAnalysis = currentTime
	
	-- Get behavior patterns from suspicion system
	-- TODO: Get all players from player manager
	-- For each player, analyze their pattern
	-- Update known patterns
	
	print("WardenAI: Analyzing behavior patterns")
end

-- Get behavior pattern for a player
function WardenAI:GetPattern(userId: number): BehaviorPattern?
	return self._knownPatterns[userId]
end

-- Update pattern for a player
function WardenAI:UpdatePattern(userId: number, pattern: BehaviorPattern)
	self._knownPatterns[userId] = pattern
end

-- Generate daily tasks for warden
function WardenAI:GenerateDailyTasks()
	self._dailyTasks = {
		{
			id = "checkCameras_1",
			type = "CheckCameras",
			location = nil,
			targetArea = "cafeteria",
			duration = 300, -- 5 minutes
			startTime = tick(),
		},
		{
			id = "watchArea_1",
			type = "WatchArea",
			location = nil,
			targetArea = "yard",
			duration = 600, -- 10 minutes
			startTime = tick() + 300,
		},
		-- Add more tasks as needed
	}
	
	print("WardenAI: Generated", #self._dailyTasks, "daily tasks")
end

-- Get current task
function WardenAI:GetCurrentTask(): any?
	return self._currentTask
end

-- Start next task
function WardenAI:StartNextTask()
	if #self._dailyTasks == 0 then
		self:GenerateDailyTasks()
	end
	
	if #self._dailyTasks > 0 then
		self._currentTask = table.remove(self._dailyTasks, 1)
		self._currentTask.startTime = tick()
		return self._currentTask
	end
	
	return nil
end

-- Make decision based on suspicion levels
function WardenAI:MakeDecision(userId: number, suspicionLevel: number): string
	-- Very smart decision-making
	local pattern = self:GetPattern(userId)
	
	-- High suspicion = send guard to investigate
	if suspicionLevel >= 60 then
		return "Investigate"
	end
	
	-- Medium suspicion with pattern = increase surveillance
	if suspicionLevel >= 30 and pattern then
		local visitCount = 0
		for location, count in pairs(pattern.commonLocations) do
			visitCount = visitCount + count
		end
		
		if visitCount >= 5 then -- Visiting same locations frequently
			return "IncreaseSurveillance"
		end
	end
	
	-- Low suspicion = normal monitoring
	return "Monitor"
end

-- Get players to watch (based on patterns and suspicion)
function WardenAI:GetPlayersToWatch(): {number}
	local playersToWatch = {}
	
	for userId, pattern in pairs(self._knownPatterns) do
		local suspicion = self._suspicionSystem:GetSuspicion(userId)
		
		-- Watch players with high suspicion or suspicious patterns
		if suspicion >= 40 or (pattern and #pattern.commonLocations >= 3) then
			table.insert(playersToWatch, userId)
		end
	end
	
	return playersToWatch
end

return WardenAI
