-- ReceiptSystem.luau
-- Tracks all trading receipts (visible to everyone - hurts anonymity)

local ReceiptSystem = {}
ReceiptSystem.__index = ReceiptSystem

function ReceiptSystem.new()
	local self = setmetatable({}, ReceiptSystem)
	self._receipts = {} -- Array of receipts
	self._maxReceipts = 100 -- Keep last 100 receipts
	return self
end

-- Create a receipt
function ReceiptSystem:CreateReceipt(tradeType: string, buyerId: number?, sellerId: number?, itemId: string?, money: number?): any
	local receipt = {
		id = tostring(tick()) .. "_" .. tostring(math.random(1000, 9999)),
		timestamp = tick(),
		tradeType = tradeType, -- "buy", "sell", "trade"
		buyerId = buyerId,
		sellerId = sellerId,
		itemId = itemId,
		money = money,
	}
	
	table.insert(self._receipts, receipt)
	
	-- Keep only last N receipts
	if #self._receipts > self._maxReceipts then
		table.remove(self._receipts, 1)
	end
	
	return receipt
end

-- Get all receipts (visible to everyone)
function ReceiptSystem:GetAllReceipts(): {any}
	return self._receipts
end

-- Get receipts for a specific item
function ReceiptSystem:GetReceiptsForItem(itemId: string): {any}
	local itemReceipts = {}
	for _, receipt in ipairs(self._receipts) do
		if receipt.itemId == itemId then
			table.insert(itemReceipts, receipt)
		end
	end
	return itemReceipts
end

-- Get receipts involving a player (for anonymity tracking)
function ReceiptSystem:GetReceiptsForPlayer(userId: number): {any}
	local playerReceipts = {}
	for _, receipt in ipairs(self._receipts) do
		if receipt.buyerId == userId or receipt.sellerId == userId then
			table.insert(playerReceipts, receipt)
		end
	end
	return playerReceipts
end

return ReceiptSystem
