-- TradingManager.luau
-- Main trading system coordinator

local TradingManager = {}
TradingManager.__index = TradingManager

local CommonBoard = require(script.Parent.CommonBoard)
local ReceiptSystem = require(script.Parent.ReceiptSystem)
local ItemTracker = require(script.Parent.ItemTracker)

local RS = game:GetService("ReplicatedStorage")
local GameSettings = require(RS.Shared.config.GameSettings)

function TradingManager.new(playerManager, inventorySystem, resourceSystem, itemSystem, activityTracker)
	local self = setmetatable({}, TradingManager)
	self._playerManager = playerManager
	self._inventorySystem = inventorySystem
	self._resourceSystem = resourceSystem
	self._itemSystem = itemSystem
	self._activityTracker = activityTracker
	self._commonBoard = CommonBoard.new()
	self._receiptSystem = ReceiptSystem.new()
	self._itemTracker = ItemTracker.new()
	
	return self
end

-- Post item for sale on common board
function TradingManager:PostForSale(userId: number, itemId: string, price: number): string?
	local playerData = self._playerManager:GetPlayerData(userId)
	if not playerData then
		return nil
	end
	
	-- Check if player has item (simplified - will need inventory check)
	-- TODO: Check inventory for item
	
	-- Post to board
	local listingId = self._commonBoard:PostForSale(userId, itemId, price)
	
	-- Log activity
	self._activityTracker:LogActivity(userId, "Trading", Vector3.new(0, 0, 0), {
		tradeType = "post_sale",
		itemId = itemId,
		money = price,
	})
	
	return listingId
end

-- Buy item from common board
function TradingManager:BuyFromBoard(userId: number, listingId: string): boolean
	local playerData = self._playerManager:GetPlayerData(userId)
	if not playerData then
		return false
	end
	
	-- Find listing
	local listing = nil
	for _, l in ipairs(self._commonBoard:GetActiveListings()) do
		if l.id == listingId then
			listing = l
			break
		end
	end
	
	if not listing or not listing.isActive then
		return false
	end
	
	-- Check if player has enough money
	if self._resourceSystem:GetMoney(userId) < listing.price then
		return false
	end
	
	-- Check if player has inventory space
	if not self._inventorySystem:HasSpaceForItem(playerData.inventory, listing.itemId) then
		return false
	end
	
	-- Transfer money
	if not self._resourceSystem:TransferMoney(userId, listing.userId, listing.price) then
		return false
	end
	
	-- Add item to buyer's inventory (simplified - will need proper item transfer)
	-- TODO: Remove item from seller's inventory and add to buyer's
	
	-- Create receipt (visible to everyone)
	self._receiptSystem:CreateReceipt("buy", userId, listing.userId, listing.itemId, listing.price)
	
	-- Remove listing
	self._commonBoard:RemoveListing(listingId)
	
	-- Log activity
	self._activityTracker:LogActivity(userId, "Trading", Vector3.new(0, 0, 0), {
		tradeType = "buy",
		itemId = listing.itemId,
		money = listing.price,
	})
	
	return true
end

-- Direct trade between players
function TradingManager:DirectTrade(buyerId: number, sellerId: number, itemId: string, price: number): boolean
	local buyerData = self._playerManager:GetPlayerData(buyerId)
	local sellerData = self._playerManager:GetPlayerData(sellerId)
	
	if not buyerData or not sellerData then
		return false
	end
	
	-- Check money
	if self._resourceSystem:GetMoney(buyerId) < price then
		return false
	end
	
	-- Check inventory space
	if not self._inventorySystem:HasSpaceForItem(buyerData.inventory, itemId) then
		return false
	end
	
	-- Transfer money
	if not self._resourceSystem:TransferMoney(buyerId, sellerId, price) then
		return false
	end
	
	-- Transfer item (simplified)
	-- TODO: Remove from seller inventory, add to buyer inventory
	
	-- Create receipt
	self._receiptSystem:CreateReceipt("trade", buyerId, sellerId, itemId, price)
	
	-- Log activity
	self._activityTracker:LogActivity(buyerId, "Trading", Vector3.new(0, 0, 0), {
		tradeType = "direct_trade",
		itemId = itemId,
		money = price,
	})
	
	return true
end

-- Get all receipts (visible to everyone)
function TradingManager:GetAllReceipts(): {any}
	return self._receiptSystem:GetAllReceipts()
end

-- Get common board listings
function TradingManager:GetBoardListings(): {any}
	return self._commonBoard:GetActiveListings()
end

-- Get common board requests
function TradingManager:GetBoardRequests(): {any}
	return self._commonBoard:GetActiveRequests()
end

return TradingManager
