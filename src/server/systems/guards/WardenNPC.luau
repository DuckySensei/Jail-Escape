-- WardenNPC.luau
-- Warden NPC implementation

local WardenNPC = {}
WardenNPC.__index = WardenNPC

local NPCBase = require(script.Parent.Parent.npcs.NPCBase)

function WardenNPC.new(wardenId: string, spawnPosition: Vector3, wardenAI: any)
	local self = setmetatable(NPCBase.new(wardenId, "Warden", spawnPosition), WardenNPC)
	self._wardenAI = wardenAI
	self._dailyTasks = {}
	self._currentTask = nil
	self._knownPatterns = {}
	
	return self
end

-- Get warden AI
function WardenNPC:GetWardenAI(): any
	return self._wardenAI
end

-- Get daily tasks
function WardenNPC:GetDailyTasks(): {any}
	return self._dailyTasks
end

-- Set daily tasks
function WardenNPC:SetDailyTasks(tasks: {any})
	self._dailyTasks = tasks
end

-- Get current task
function WardenNPC:GetCurrentTask(): any?
	return self._currentTask or self._wardenAI:GetCurrentTask()
end

-- Get known patterns
function WardenNPC:GetKnownPatterns(): {[number]: BehaviorPattern}
	return self._knownPatterns
end

return WardenNPC
