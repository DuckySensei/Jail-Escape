-- ItemTracker.luau
-- Tracks items within the prison to control availability

local ItemTracker = {}
ItemTracker.__index = ItemTracker

function ItemTracker.new()
	local self = setmetatable({}, ItemTracker)
	self._itemCounts = {} -- itemId -> count in prison
	self._maxItemCounts = {} -- itemId -> max allowed
	return self
end

-- Set max count for an item
function ItemTracker:SetMaxCount(itemId: string, maxCount: number)
	self._maxItemCounts[itemId] = maxCount
end

-- Get current count of an item
function ItemTracker:GetCount(itemId: string): number
	return self._itemCounts[itemId] or 0
end

-- Get max count for an item
function ItemTracker:GetMaxCount(itemId: string): number
	return self._maxItemCounts[itemId] or math.huge -- Unlimited if not set
end

-- Check if item is available (can be added)
function ItemTracker:IsAvailable(itemId: string): boolean
	local current = self:GetCount(itemId)
	local max = self:GetMaxCount(itemId)
	return current < max
end

-- Add item to prison
function ItemTracker:AddItem(itemId: string, count: number): boolean
	if not self:IsAvailable(itemId) then
		return false
	end
	
	local current = self:GetCount(itemId)
	local max = self:GetMaxCount(itemId)
	local newCount = math.min(current + count, max)
	
	self._itemCounts[itemId] = newCount
	return true
end

-- Remove item from prison
function ItemTracker:RemoveItem(itemId: string, count: number): boolean
	local current = self:GetCount(itemId)
	if current < count then
		return false
	end
	
	self._itemCounts[itemId] = current - count
	return true
end

-- Get all item counts
function ItemTracker:GetAllItemCounts(): {[string]: number}
	return self._itemCounts
end

return ItemTracker
