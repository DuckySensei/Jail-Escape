-- CommonBoard.luau
-- Manages the common cell trading board

local CommonBoard = {}
CommonBoard.__index = CommonBoard

local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

function CommonBoard.new()
	local self = setmetatable({}, CommonBoard)
	self._boardInstance = nil
	self._listings = {} -- Array of listings
	self._requests = {} -- Array of buy requests
	
	-- Find trading board in workspace
	self:FindTradingBoard()
	
	return self
end

-- Find trading board in workspace
function CommonBoard:FindTradingBoard()
	local boards = CollectionService:GetTagged("TradingBoard")
	
	if #boards > 0 then
		local board = boards[1] -- Use first trading board found
		
		-- Verify it's a valid Model or BasePart
		if board:IsA("Model") and board.PrimaryPart then
			self._boardInstance = board
			print("CommonBoard: Found trading board (Model) in workspace")
		elseif board:IsA("BasePart") then
			self._boardInstance = board
			print("CommonBoard: Found trading board (BasePart) in workspace")
		else
			warn("CommonBoard: Trading board is not a Model with PrimaryPart or BasePart")
		end
	else
		warn("CommonBoard: No trading board found in workspace")
	end
end

-- Post an item for sale
function CommonBoard:PostForSale(userId: number, itemId: string, price: number): string?
	local listing = {
		id = tostring(tick()) .. "_" .. tostring(math.random(1000, 9999)),
		userId = userId,
		itemId = itemId,
		price = price,
		timestamp = tick(),
		isActive = true,
	}
	
	table.insert(self._listings, listing)
	return listing.id
end

-- Post a buy request
function CommonBoard:PostBuyRequest(userId: number, itemId: string, maxPrice: number?): string?
	local request = {
		id = tostring(tick()) .. "_" .. tostring(math.random(1000, 9999)),
		userId = userId,
		itemId = itemId,
		maxPrice = maxPrice,
		timestamp = tick(),
		isActive = true,
	}
	
	table.insert(self._requests, request)
	return request.id
end

-- Get all active listings
function CommonBoard:GetActiveListings(): {any}
	local active = {}
	for _, listing in ipairs(self._listings) do
		if listing.isActive then
			table.insert(active, listing)
		end
	end
	return active
end

-- Get all active buy requests
function CommonBoard:GetActiveRequests(): {any}
	local active = {}
	for _, request in ipairs(self._requests) do
		if request.isActive then
			table.insert(active, request)
		end
	end
	return active
end

-- Remove a listing
function CommonBoard:RemoveListing(listingId: string)
	for i, listing in ipairs(self._listings) do
		if listing.id == listingId then
			listing.isActive = false
			return true
		end
	end
	return false
end

-- Remove a request
function CommonBoard:RemoveRequest(requestId: string)
	for i, request in ipairs(self._requests) do
		if request.id == requestId then
			request.isActive = false
			return true
		end
	end
	return false
end

return CommonBoard
