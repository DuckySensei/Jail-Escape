-- EscapeMethod.luau
-- Base class for all escape methods

local EscapeMethod = {}
EscapeMethod.__index = EscapeMethod

function EscapeMethod.new(methodId: string, config: any)
	local self = setmetatable({}, EscapeMethod)
	self._methodId = methodId
	self._config = config
	self._steps = {}
	self._completedSteps = {}
	
	-- Initialize steps from config
	if config and config.steps then
		for i, stepConfig in ipairs(config.steps) do
			self._steps[i] = {
				id = stepConfig.id,
				name = stepConfig.name,
				description = stepConfig.description,
				requirements = stepConfig.requirements or {},
				progress = 0,
				isComplete = false,
			}
		end
	end
	
	return self
end

-- Get method ID
function EscapeMethod:GetMethodId(): string
	return self._methodId
end

-- Get all steps
function EscapeMethod:GetSteps(): {EscapeMethodStep}
	return self._steps
end

-- Get current step index
function EscapeMethod:GetCurrentStepIndex(): number
	for i, step in ipairs(self._steps) do
		if not step.isComplete then
			return i
		end
	end
	return #self._steps + 1 -- All steps complete
end

-- Get current step
function EscapeMethod:GetCurrentStep(): EscapeMethodStep?
	local index = self:GetCurrentStepIndex()
	if index <= #self._steps then
		return self._steps[index]
	end
	return nil
end

-- Get overall progress (0-100)
function EscapeMethod:GetOverallProgress(): number
	if #self._steps == 0 then
		return 0
	end
	
	local completedCount = 0
	for _, step in ipairs(self._steps) do
		if step.isComplete then
			completedCount = completedCount + 1
		end
	end
	
	return math.floor((completedCount / #self._steps) * 100)
end

-- Get next items needed for current step
function EscapeMethod:GetNextItemsNeeded(): {string}
	local currentStep = self:GetCurrentStep()
	if not currentStep then
		return {}
	end
	
	local itemsNeeded = {}
	if currentStep.requirements then
		for _, requirement in ipairs(currentStep.requirements) do
			if requirement.type == "Item" then
				table.insert(itemsNeeded, requirement.value)
			end
		end
	end
	
	return itemsNeeded
end

-- Check if requirements are met for current step
function EscapeMethod:CheckRequirements(playerData: any, itemSystem: any): boolean
	local currentStep = self:GetCurrentStep()
	if not currentStep or not currentStep.requirements then
		return true
	end
	
	-- TODO: Implement requirement checking
	-- For now, return false (needs item system integration)
	return false
end

-- Update step progress
function EscapeMethod:UpdateStepProgress(stepIndex: number, progress: number)
	if self._steps[stepIndex] then
		self._steps[stepIndex].progress = math.min(100, math.max(0, progress))
	end
end

-- Complete a step
function EscapeMethod:CompleteStep(stepIndex: number)
	if self._steps[stepIndex] then
		self._steps[stepIndex].isComplete = true
		self._steps[stepIndex].progress = 100
		table.insert(self._completedSteps, stepIndex)
	end
end

-- Check if method can be completed
function EscapeMethod:CanComplete(): boolean
	return self:GetOverallProgress() >= 100
end

return EscapeMethod
