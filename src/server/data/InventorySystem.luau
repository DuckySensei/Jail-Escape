-- InventorySystem.luau
-- Grid-based inventory system

local InventorySystem = {}
InventorySystem.__index = InventorySystem

local RS = game:GetService("ReplicatedStorage")
local GameSettings = require(RS.Shared.config.GameSettings)

function InventorySystem.new(itemSystem)
	local self = setmetatable({}, InventorySystem)
	self._itemSystem = itemSystem
	return self
end

-- Check if item can be placed at position
function InventorySystem:CanPlaceItem(inventory: Inventory, itemId: string, x: number, y: number, rotation: number): boolean
	local definition = self._itemSystem:GetItemDefinition(itemId)
	if not definition then
		return false
	end
	
	local gridSize = definition.gridSize
	local width = gridSize.width
	local height = gridSize.height
	
	-- Handle rotation (swap width/height if rotated 90 or 270 degrees)
	if rotation == 90 or rotation == 270 then
		width, height = height, width
	end
	
	-- Check bounds
	if x < 1 or y < 1 or x + width - 1 > inventory.width or y + height - 1 > inventory.height then
		return false
	end
	
	-- Check if cells are available
	for dx = 0, width - 1 do
		for dy = 0, height - 1 do
			local cellX = x + dx
			local cellY = y + dy
			
			if inventory.grid[cellX] and inventory.grid[cellX][cellY] then
				local cell = inventory.grid[cellX][cellY]
				if cell.itemId and cell.itemId ~= "" then
					return false -- Cell is occupied
				end
			else
				return false -- Cell doesn't exist
			end
		end
	end
	
	return true
end

-- Place item in inventory
function InventorySystem:PlaceItem(inventory: Inventory, itemId: string, x: number, y: number, rotation: number): boolean
	if not self:CanPlaceItem(inventory, itemId, x, y, rotation) then
		return false
	end
	
	local definition = self._itemSystem:GetItemDefinition(itemId)
	if not definition then
		return false
	end
	
	local gridSize = definition.gridSize
	local width = gridSize.width
	local height = gridSize.height
	
	-- Handle rotation
	if rotation == 90 or rotation == 270 then
		width, height = height, width
	end
	
	-- Place item in grid
	for dx = 0, width - 1 do
		for dy = 0, height - 1 do
			local cellX = x + dx
			local cellY = y + dy
			
			if inventory.grid[cellX] and inventory.grid[cellX][cellY] then
				inventory.grid[cellX][cellY].itemId = itemId
				inventory.grid[cellX][cellY].rotation = rotation
			end
		end
	end
	
	-- Add to items list
	table.insert(inventory.items, {
		itemId = itemId,
		position = {x = x, y = y},
		rotation = rotation,
		size = {width = width, height = height},
	})
	
	return true
end

-- Remove item from inventory
function InventorySystem:RemoveItem(inventory: Inventory, itemId: string, x: number, y: number): boolean
	-- Find item in items list
	local itemIndex = nil
	for i, item in ipairs(inventory.items) do
		if item.itemId == itemId and item.position.x == x and item.position.y == y then
			itemIndex = i
			break
		end
	end
	
	if not itemIndex then
		return false
	end
	
	local item = inventory.items[itemIndex]
	local width = item.size.width
	local height = item.size.height
	
	-- Remove from grid
	for dx = 0, width - 1 do
		for dy = 0, height - 1 do
			local cellX = item.position.x + dx
			local cellY = item.position.y + dy
			
			if inventory.grid[cellX] and inventory.grid[cellX][cellY] then
				inventory.grid[cellX][cellY].itemId = nil
				inventory.grid[cellX][cellY].rotation = nil
			end
		end
	end
	
	-- Remove from items list
	table.remove(inventory.items, itemIndex)
	
	return true
end

-- Get item at position
function InventorySystem:GetItemAt(inventory: Inventory, x: number, y: number): InventoryItem?
	if inventory.grid[x] and inventory.grid[x][y] then
		local cell = inventory.grid[x][y]
		if cell.itemId then
			-- Find the item in items list
			for _, item in ipairs(inventory.items) do
				if item.itemId == cell.itemId and 
				   item.position.x <= x and x < item.position.x + item.size.width and
				   item.position.y <= y and y < item.position.y + item.size.height then
					return item
				end
			end
		end
	end
	return nil
end

-- Check if inventory has space for item
function InventorySystem:HasSpaceForItem(inventory: Inventory, itemId: string): boolean
	local definition = self._itemSystem:GetItemDefinition(itemId)
	if not definition then
		return false
	end
	
	local gridSize = definition.gridSize
	
	-- Try all rotations
	for _, rotation in ipairs({0, 90, 180, 270}) do
		-- Try all positions
		for x = 1, inventory.width do
			for y = 1, inventory.height do
				if self:CanPlaceItem(inventory, itemId, x, y, rotation) then
					return true
				end
			end
		end
	end
	
	return false
end

return InventorySystem
