-- ResourceSystem.luau
-- Manages money and resources

local ResourceSystem = {}
ResourceSystem.__index = ResourceSystem

function ResourceSystem.new()
	local self = setmetatable({}, ResourceSystem)
	self._playerMoney = {} -- userId -> money amount
	return self
end

-- Get money for a player
function ResourceSystem:GetMoney(userId: number): number
	return self._playerMoney[userId] or 0
end

-- Set money for a player
function ResourceSystem:SetMoney(userId: number, amount: number)
	self._playerMoney[userId] = math.max(0, amount)
end

-- Add money to a player
function ResourceSystem:AddMoney(userId: number, amount: number): number
	local currentMoney = self:GetMoney(userId)
	local newAmount = currentMoney + amount
	self:SetMoney(userId, newAmount)
	return newAmount
end

-- Remove money from a player
function ResourceSystem:RemoveMoney(userId: number, amount: number): boolean
	local currentMoney = self:GetMoney(userId)
	if currentMoney < amount then
		return false -- Not enough money
	end
	
	self:SetMoney(userId, currentMoney - amount)
	return true
end

-- Transfer money between players
function ResourceSystem:TransferMoney(fromUserId: number, toUserId: number, amount: number): boolean
	if not self:RemoveMoney(fromUserId, amount) then
		return false
	end
	
	self:AddMoney(toUserId, amount)
	return true
end

-- Clear money for a player
function ResourceSystem:ClearMoney(userId: number)
	self._playerMoney[userId] = nil
end

return ResourceSystem
