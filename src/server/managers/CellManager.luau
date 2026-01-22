-- CellManager.luau
-- Manages cell assignment and cell interactions

local CellManager = {}
CellManager.__index = CellManager

local RS = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")
local GameSettings = require(RS.Shared.config.GameSettings)

function CellManager.new()
	local self = setmetatable({}, CellManager)
	self._availableCells = {}
	self._assignedCells = {} -- userId -> cellId
	self._cells = {} -- cellId -> cell data
	self._cellInstances = {} -- cellId -> workspace instances
	self._maxCells = GameSettings.CELL_COUNT
	
	-- Find cells in workspace
	self:FindCellsInWorkspace()
	
	-- Initialize available cells
	for i = 1, self._maxCells do
		table.insert(self._availableCells, i)
		self._cells[i] = {
			cellId = i,
			assignedTo = nil, -- userId
			hasPhoto = true, -- Each cell has a photo by the sink
		}
	end
	
	return self
end

-- Find cells in workspace using CollectionService
function CellManager:FindCellsInWorkspace()
	local cells = CollectionService:GetTagged("Cell")
	
	for _, cell in ipairs(cells) do
		local cellId = cell:GetAttribute("CellId")
		if cellId and cellId >= 1 and cellId <= self._maxCells then
			-- Find spawn point in this cell
			local spawnPoint = self:FindSpawnPointInCell(cell)
			
			self._cellInstances[cellId] = {
				cell = cell,
				spawnPoint = spawnPoint,
			}
		end
	end
	
	print("CellManager: Found", #cells, "cells in workspace")
end

-- Find spawn point in a cell (looks for PlayerSpawn tag or uses cell position)
function CellManager:FindSpawnPointInCell(cell: Instance): Vector3?
	-- First, try to find a tagged spawn point
	local descendants = cell:GetDescendants()
	for _, descendant in ipairs(descendants) do
		if CollectionService:HasTag(descendant, "PlayerSpawn") then
			if descendant:IsA("BasePart") then
				return descendant.Position + Vector3.new(0, 3, 0) -- Above the part
			elseif descendant:IsA("SpawnLocation") then
				return descendant.Position
			end
		end
	end
	
	-- If no spawn point found, use cell's position
	if cell:IsA("BasePart") then
		return cell.Position + Vector3.new(0, 5, 0)
	elseif cell:IsA("Model") and cell.PrimaryPart then
		return cell.PrimaryPart.Position + Vector3.new(0, 5, 0)
	elseif cell:IsA("Folder") then
		-- Try to find first part in folder
		for _, child in ipairs(cell:GetChildren()) do
			if child:IsA("BasePart") then
				return child.Position + Vector3.new(0, 5, 0)
			end
		end
	end
	
	-- Fallback: use cell's position if it's a part
	if cell:IsA("BasePart") then
		return cell.Position + Vector3.new(0, 5, 0)
	end
	
	warn("CellManager: Could not find spawn point for cell", cell.Name)
	return nil
end

-- Teleport player to their assigned cell
function CellManager:TeleportPlayerToCell(player: Player, cellId: number): boolean
	local cellData = self._cellInstances[cellId]
	if not cellData or not cellData.spawnPoint then
		warn("CellManager: No spawn point found for cell", cellId)
		return false
	end
	
	local character = player.Character
	if not character then
		-- Wait for character to load
		player.CharacterAdded:Wait()
		character = player.Character
	end
	
	if character and character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame = CFrame.new(cellData.spawnPoint)
		return true
	end
	
	return false
end

-- Assign a cell to a player
function CellManager:AssignCell(userId: number): number?
	if self._assignedCells[userId] then
		return self._assignedCells[userId] -- Already assigned
	end
	
	if #self._availableCells == 0 then
		warn("CellManager: No available cells")
		return nil
	end
	
	local cellId = table.remove(self._availableCells, math.random(1, #self._availableCells))
	self._assignedCells[userId] = cellId
	self._cells[cellId].assignedTo = userId
	
	return cellId
end

-- Unassign a cell (when player leaves)
function CellManager:UnassignCell(userId: number)
	local cellId = self._assignedCells[userId]
	if not cellId then
		return
	end
	
	self._cells[cellId].assignedTo = nil
	self._assignedCells[userId] = nil
	
	-- Add back to available cells
	table.insert(self._availableCells, cellId)
end

-- Get cell ID for a user
function CellManager:GetCellId(userId: number): number?
	return self._assignedCells[userId]
end

-- Get cell data
function CellManager:GetCell(cellId: number)
	return self._cells[cellId]
end

-- Check if cell is available
function CellManager:IsCellAvailable(cellId: number): boolean
	local cell = self._cells[cellId]
	return cell and cell.assignedTo == nil
end

-- Get available cell count
function CellManager:GetAvailableCellCount(): number
	return #self._availableCells
end

-- Get assigned cell count
function CellManager:GetAssignedCellCount(): number
	return self._maxCells - #self._availableCells
end

-- Get all assigned cells
function CellManager:GetAssignedCells(): {[number]: number}
	return self._assignedCells
end

return CellManager
