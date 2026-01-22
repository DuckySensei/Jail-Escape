-- SolitarySystem.luau
-- Handles solitary confinement

local SolitarySystem = {}
SolitarySystem.__index = SolitarySystem

local CollectionService = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local GameSettings = require(RS.Shared.config.GameSettings)

function SolitarySystem.new(playerManager, inventorySystem)
	local self = setmetatable({}, SolitarySystem)
	self._playerManager = playerManager
	self._inventorySystem = inventorySystem
	self._solitaryCells = {} -- cellId -> {instance, spawnPoint}
	self._confiscatedItems = {} -- userId -> {items}
	
	-- Find solitary cells
	self:FindSolitaryCells()
	
	return self
end

-- Find solitary cells in workspace
function SolitarySystem:FindSolitaryCells()
	local cells = CollectionService:GetTagged("SolitaryCell")
	
	for _, cell in ipairs(cells) do
		local cellId = cell:GetAttribute("SolitaryCellId")
		if cellId then
			local position = cell:IsA("BasePart") and cell.Position or
			                 (cell:IsA("Model") and cell.PrimaryPart and cell.PrimaryPart.Position) or
			                 cell.Position
			
			self._solitaryCells[cellId] = {
				instance = cell,
				spawnPoint = position,
			}
		end
	end
	
	print("SolitarySystem: Found", #cells, "solitary cells")
end

-- Send player to solitary
function SolitarySystem:SendToSolitary(userId: number, reason: string?): boolean
	local playerData = self._playerManager:GetPlayerData(userId)
	if not playerData then
		return false
	end
	
	-- Confiscate all items
	local confiscatedItems = {}
	for _, item in ipairs(playerData.inventory.items) do
		table.insert(confiscatedItems, item)
		-- Remove from inventory
		self._inventorySystem:RemoveItem(playerData.inventory, item.itemId, item.position.x, item.position.y)
	end
	
	-- Store confiscated items in armory
	self._confiscatedItems[userId] = confiscatedItems
	
	-- Clear inventory
	playerData.inventory.items = {}
	
	-- Update player data
	self._playerManager:UpdatePlayerData(userId, {
		isInSolitary = true,
		solitaryStartTime = tick(),
	})
	
	-- Teleport to solitary cell
	local player = self._playerManager:GetPlayer(userId)
	if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		-- Find available solitary cell
		local cellId = self:GetAvailableSolitaryCell()
		if cellId and self._solitaryCells[cellId] then
			player.Character.HumanoidRootPart.CFrame = CFrame.new(self._solitaryCells[cellId].spawnPoint)
		end
	end
	
	print("SolitarySystem: Sent player", userId, "to solitary. Reason:", reason or "Unknown")
	return true
end

-- Release player from solitary
function SolitarySystem:ReleaseFromSolitary(userId: number): boolean
	local playerData = self._playerManager:GetPlayerData(userId)
	if not playerData or not playerData.isInSolitary then
		return false
	end
	
	-- Update player data
	self._playerManager:UpdatePlayerData(userId, {
		isInSolitary = false,
		solitaryStartTime = nil,
	})
	
	-- Items remain in armory - player must retrieve them
	
	print("SolitarySystem: Released player", userId, "from solitary")
	return true
end

-- Get available solitary cell
function SolitarySystem:GetAvailableSolitaryCell(): number?
	for cellId, _ in pairs(self._solitaryCells) do
		-- Simple: return first available (could be improved)
		return cellId
	end
	return nil
end

-- Get confiscated items for player
function SolitarySystem:GetConfiscatedItems(userId: number): {any}
	return self._confiscatedItems[userId] or {}
end

return SolitarySystem
