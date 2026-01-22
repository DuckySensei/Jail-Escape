-- TaskGenerator.luau
-- Generates tasks dynamically

local TaskGenerator = {}
TaskGenerator.__index = TaskGenerator

local RS = game:GetService("ReplicatedStorage")
local TasksConfig = require(RS.Shared.config.Tasks)
local GameSettings = require(RS.Shared.config.GameSettings)

function TaskGenerator.new()
	local self = setmetatable({}, TaskGenerator)
	self._taskTemplates = TasksConfig
	return self
end

-- Generate a task instance from a template
function TaskGenerator:GenerateTask(taskId: string, location: Vector3): Task?
	local template = self._taskTemplates[taskId]
	if not template then
		warn("TaskGenerator: Task template not found:", taskId)
		return nil
	end
	
	-- Apply pay scale based on suspicion
	local payMultiplier = 1.0
	if template.suspicionLevel <= 10 then
		payMultiplier = GameSettings.TASK_PAY_SCALE.LOW_SUSPICION_MULTIPLIER or 1.5
	elseif template.suspicionLevel <= 30 then
		payMultiplier = GameSettings.TASK_PAY_SCALE.MEDIUM_SUSPICION_MULTIPLIER or 1.0
	else
		payMultiplier = GameSettings.TASK_PAY_SCALE.HIGH_SUSPICION_MULTIPLIER or 0.7
	end
	
	local finalPay = math.floor(template.pay * payMultiplier)
	
	local task: Task = {
		id = taskId .. "_" .. tostring(tick()), -- Unique ID
		name = template.name,
		category = template.category,
		suspicionLevel = template.suspicionLevel,
		pay = finalPay,
		timeRequired = template.timeRequired,
		requirements = template.requirements,
		location = location,
		assignedTo = nil,
		description = template.description,
		isAvailable = true,
	}
	
	return task
end

-- Generate tasks for a specific category
function TaskGenerator:GenerateTasksForCategory(category: string, count: number, location: Vector3): {Task}
	local tasks = {}
	local categoryTasks = {}
	
	-- Find all tasks in this category
	for taskId, template in pairs(self._taskTemplates) do
		if template.category == category then
			table.insert(categoryTasks, taskId)
		end
	end
	
	-- Generate random tasks from category
	for i = 1, math.min(count, #categoryTasks) do
		local randomTaskId = categoryTasks[math.random(1, #categoryTasks)]
		local task = self:GenerateTask(randomTaskId, location)
		if task then
			table.insert(tasks, task)
		end
	end
	
	return tasks
end

-- Get all available task templates
function TaskGenerator:GetTaskTemplates(): {[string]: any}
	return self._taskTemplates
end

-- Get task templates by category
function TaskGenerator:GetTasksByCategory(category: string): {string}
	local taskIds = {}
	for taskId, template in pairs(self._taskTemplates) do
		if template.category == category then
			table.insert(taskIds, taskId)
		end
	end
	return taskIds
end

return TaskGenerator
