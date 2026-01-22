-- NPCBehaviorTree.luau
-- Behavior tree system for NPC decision-making

local NPCBehaviorTree = {}
NPCBehaviorTree.__index = NPCBehaviorTree

function NPCBehaviorTree.new(difficulty: number)
	local self = setmetatable({}, NPCBehaviorTree)
	self._difficulty = difficulty or 50 -- 0-100
	return self
end

-- Evaluate decision based on available information
function NPCBehaviorTree:EvaluateDecision(options: {any}, informationDepth: number): any?
	if #options == 0 then
		return nil
	end
	
	-- Higher difficulty = better decision making
	-- Deeper information = better decisions
	local decisionQuality = (self._difficulty / 100) * (informationDepth / 10)
	
	-- Simple decision: choose best option based on quality
	-- In a full implementation, this would use a proper behavior tree
	local bestOption = options[1]
	local bestScore = 0
	
	for _, option in ipairs(options) do
		local score = (option.priority or 0) * decisionQuality
		if score > bestScore then
			bestScore = score
			bestOption = option
		end
	end
	
	return bestOption
end

-- Get difficulty level
function NPCBehaviorTree:GetDifficulty(): number
	return self._difficulty
end

-- Set difficulty level
function NPCBehaviorTree:SetDifficulty(difficulty: number)
	self._difficulty = math.max(0, math.min(100, difficulty))
end

return NPCBehaviorTree
