-- TaskManager.luau
-- Main task system coordinator

local TaskManager = {}
TaskManager.__index = TaskManager

local TaskGenerator = require(script.Parent.TaskGenerator)
local TaskBoard = require(script.Parent.TaskBoard)
local TaskAssigner = require(script.Parent.TaskAssigner)

local RS = game:GetService("ReplicatedStorage")
local GameSettings = require(RS.Shared.config.GameSettings)

function TaskManager.new(playerManager, resourceSystem, activityTracker)
	local self = setmetatable({}, TaskManager)
	self._playerManager = playerManager
	self._resourceSystem = resourceSystem
	self._activityTracker = activityTracker
	self._generator = TaskGenerator.new()
	self._board = TaskBoard.new()
	self._assigner = TaskAssigner.new()
	self._activeTasks = {} -- taskId -> Task
	self._playerTasks = {} -- userId -> taskId
	
	return self
end

-- Initialize task boards with tasks
function TaskManager:InitializeTaskBoards()
	-- Generate tasks for each board
	local boards = self._board:GetAllBoards()
	
	for boardId, boardData in pairs(boards) do
		-- Generate mix of task categories
		local laborTasks = self._generator:GenerateTasksForCategory("Labor", 3, boardData.location)
		local skilledTasks = self._generator:GenerateTasksForCategory("Skilled", 2, boardData.location)
		local illegalTasks = self._generator:GenerateTasksForCategory("Illegal", 2, boardData.location)
		local rehabTasks = self._generator:GenerateTasksForCategory("Rehabilitation", 2, boardData.location)
		
		-- Add all tasks to board
		for _, task in ipairs(laborTasks) do
			self._board:AddTaskToBoard(boardId, task)
			self._activeTasks[task.id] = task
		end
		
		for _, task in ipairs(skilledTasks) do
			self._board:AddTaskToBoard(boardId, task)
			self._activeTasks[task.id] = task
		end
		
		for _, task in ipairs(illegalTasks) do
			self._board:AddTaskToBoard(boardId, task)
			self._activeTasks[task.id] = task
		end
		
		for _, task in ipairs(rehabTasks) do
			self._board:AddTaskToBoard(boardId, task)
			self._activeTasks[task.id] = task
		end
	end
	
	print("TaskManager: Initialized task boards with", #self._activeTasks, "tasks")
end

-- Accept a task
function TaskManager:AcceptTask(userId: number, taskId: string): boolean
	local playerData = self._playerManager:GetPlayerData(userId)
	if not playerData then
		return false
	end
	
	local task = self._activeTasks[taskId]
	if not task then
		return false
	end
	
	-- Check if player can accept
	if not self._assigner:CanAcceptTask(playerData, task) then
		return false
	end
	
	-- Assign task
	if not self._assigner:AssignTask(task, userId) then
		return false
	end
	
	-- Update player data
	self._playerManager:UpdatePlayerData(userId, {
		currentTask = taskId,
	})
	
	self._playerTasks[userId] = taskId
	
	-- Log activity
	self._activityTracker:LogActivity(userId, "TaskAccept", task.location, {
		taskId = taskId,
		taskCategory = task.category,
	})
	
	return true
end

-- Complete a task
function TaskManager:CompleteTask(userId: number, taskId: string): boolean
	local playerData = self._playerManager:GetPlayerData(userId)
	if not playerData then
		return false
	end
	
	local task = self._activeTasks[taskId]
	if not task or task.assignedTo ~= userId then
		return false
	end
	
	-- Give reward
	self._resourceSystem:AddMoney(userId, task.pay)
	
	-- Update suspicion if rehabilitation task
	if task.category == "Rehabilitation" and task.properties and task.properties.suspicionReduction then
		-- TODO: Reduce suspicion through suspicion system
	end
	
	-- Unassign task
	self._assigner:UnassignTask(task)
	
	-- Update player data
	self._playerManager:UpdatePlayerData(userId, {
		currentTask = nil,
	})
	
	self._playerTasks[userId] = nil
	
	-- Log activity
	self._activityTracker:LogActivity(userId, "TaskComplete", task.location, {
		taskId = taskId,
		taskCategory = task.category,
	})
	
	return true
end

-- Get available tasks for a board
function TaskManager:GetBoardTasks(boardId: number): {Task}
	return self._board:GetBoardTasks(boardId)
end

-- Get player's current task
function TaskManager:GetPlayerTask(userId: number): Task?
	local taskId = self._playerTasks[userId]
	if taskId then
		return self._activeTasks[taskId]
	end
	return nil
end

return TaskManager
