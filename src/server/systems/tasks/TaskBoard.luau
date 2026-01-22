-- TaskBoard.luau
-- Manages job boards and task availability

local TaskBoard = {}
TaskBoard.__index = TaskBoard

local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

function TaskBoard.new()
	local self = setmetatable({}, TaskBoard)
	self._boards = {} -- boardId -> {tasks, location}
	self._boardInstances = {} -- boardId -> workspace instance
	
	-- Find task boards in workspace
	self:FindTaskBoards()
	
	return self
end

-- Find task boards in workspace
function TaskBoard:FindTaskBoards()
	local boards = CollectionService:GetTagged("TaskBoard")
	
	for _, board in ipairs(boards) do
		local boardId = board:GetAttribute("BoardId")
		local location = board:GetAttribute("Location")
		
		if boardId then
			-- Get position - handle both BasePart and Model with PrimaryPart
			local position: Vector3?
			if board:IsA("Model") and board.PrimaryPart then
				position = board.PrimaryPart.Position
			elseif board:IsA("BasePart") then
				position = board.Position
			else
				warn("TaskBoard: Board", board.Name, "is not a Model with PrimaryPart or BasePart")
				position = nil
			end
			
			if position then
				self._boardInstances[boardId] = board
				self._boards[boardId] = {
					tasks = {},
					location = position,
					locationName = location or "Unknown",
				}
			end
		end
	end
	
	print("TaskBoard: Found", #boards, "task boards in workspace")
end

-- Add task to a board
function TaskBoard:AddTaskToBoard(boardId: number, task: Task)
	if not self._boards[boardId] then
		warn("TaskBoard: Board not found:", boardId)
		return false
	end
	
	table.insert(self._boards[boardId].tasks, task)
	return true
end

-- Get tasks from a board
function TaskBoard:GetBoardTasks(boardId: number): {Task}
	if not self._boards[boardId] then
		return {}
	end
	
	-- Filter to only available tasks
	local availableTasks = {}
	for _, task in ipairs(self._boards[boardId].tasks) do
		if task.isAvailable and not task.assignedTo then
			table.insert(availableTasks, task)
		end
	end
	
	return availableTasks
end

-- Get all boards
function TaskBoard:GetAllBoards(): {[number]: any}
	return self._boards
end

-- Get board location
function TaskBoard:GetBoardLocation(boardId: number): Vector3?
	if self._boards[boardId] then
		return self._boards[boardId].location
	end
	return nil
end

return TaskBoard
