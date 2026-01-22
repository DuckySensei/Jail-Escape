-- TaskAssigner.luau
-- Handles task assignment logic

local TaskAssigner = {}
TaskAssigner.__index = TaskAssigner

function TaskAssigner.new()
	local self = setmetatable({}, TaskAssigner)
	return self
end

-- Check if player can accept task
function TaskAssigner:CanAcceptTask(playerData: any, task: Task): boolean
	-- Check if task is available
	if not task.isAvailable or task.assignedTo then
		return false
	end
	
	-- Check if player already has a task
	if playerData.currentTask then
		return false -- Player can only have one task at a time
	end
	
	-- Check requirements
	if task.requirements then
		for _, requirement in ipairs(task.requirements) do
			if requirement.type == "Item" then
				-- Check if player has item in inventory
				-- TODO: Implement inventory check when inventory system is integrated
			elseif requirement.type == "Prerequisite" then
				-- Check prerequisite (e.g., "gangMember")
				-- TODO: Implement prerequisite checking
			end
		end
	end
	
	return true
end

-- Assign task to player
function TaskAssigner:AssignTask(task: Task, userId: number): boolean
	if task.assignedTo then
		return false -- Already assigned
	end
	
	task.assignedTo = userId
	task.isAvailable = false
	return true
end

-- Unassign task from player
function TaskAssigner:UnassignTask(task: Task)
	task.assignedTo = nil
	task.isAvailable = true
end

-- Check if task requirements are met
function TaskAssigner:CheckRequirements(playerData: any, task: Task): boolean
	if not task.requirements then
		return true
	end
	
	for _, requirement in ipairs(task.requirements) do
		if requirement.type == "Item" then
			-- TODO: Check inventory for item
			return false -- Placeholder
		elseif requirement.type == "Prerequisite" then
			-- TODO: Check prerequisites
			return false -- Placeholder
		end
	end
	
	return true
end

return TaskAssigner
