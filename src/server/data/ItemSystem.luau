-- ItemSystem.luau
-- Manages items in the game

local ItemSystem = {}
ItemSystem.__index = ItemSystem

local RS = game:GetService("ReplicatedStorage")
local ItemsConfig = require(RS.Shared.config.Items)

function ItemSystem.new()
	local self = setmetatable({}, ItemSystem)
	self._itemDefinitions = ItemsConfig
	self._itemInstances = {} -- itemInstanceId -> ItemInstance
	self._itemCounter = 0
	
	return self
end

-- Get item definition
function ItemSystem:GetItemDefinition(itemId: string): ItemDefinition?
	return self._itemDefinitions[itemId]
end

-- Create an item instance
function ItemSystem:CreateItemInstance(itemId: string, ownerId: number?, location: Vector3?): ItemInstance
	local definition = self:GetItemDefinition(itemId)
	if not definition then
		warn("ItemSystem: Item definition not found:", itemId)
		return nil
	end
	
	self._itemCounter = self._itemCounter + 1
	local instanceId = tostring(self._itemCounter)
	
	local itemInstance: ItemInstance = {
		itemId = itemId,
		instance = nil, -- Physical instance (if spawned in workspace)
		ownerId = ownerId,
		location = location,
	}
	
	self._itemInstances[instanceId] = itemInstance
	return itemInstance
end

-- Spawn item in workspace (optional - for physical items)
function ItemSystem:SpawnItemInWorkspace(itemInstance: ItemInstance, position: Vector3): BasePart?
	local definition = self:GetItemDefinition(itemInstance.itemId)
	if not definition then
		return nil
	end
	
	-- Create a simple part to represent the item
	local part = Instance.new("Part")
	part.Name = definition.name
	part.Size = Vector3.new(1, 1, 1)
	part.Position = position
	part.Anchored = false
	part.CanCollide = true
	part.Parent = workspace
	
	-- Add item data as attribute
	part:SetAttribute("ItemId", itemInstance.itemId)
	
	itemInstance.instance = part
	return part
end

-- Get item instance
function ItemSystem:GetItemInstance(instanceId: string): ItemInstance?
	return self._itemInstances[instanceId]
end

-- Remove item instance
function ItemSystem:RemoveItemInstance(instanceId: string)
	local itemInstance = self._itemInstances[instanceId]
	if itemInstance and itemInstance.instance then
		itemInstance.instance:Destroy()
	end
	self._itemInstances[instanceId] = nil
end

-- Get all item definitions
function ItemSystem:GetAllItemDefinitions(): {[string]: ItemDefinition}
	return self._itemDefinitions
end

-- Check if item exists
function ItemSystem:ItemExists(itemId: string): boolean
	return self._itemDefinitions[itemId] ~= nil
end

return ItemSystem
