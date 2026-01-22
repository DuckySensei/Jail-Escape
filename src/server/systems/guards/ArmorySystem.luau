-- ArmorySystem.luau
-- Manages confiscated items in armory

local ArmorySystem = {}
ArmorySystem.__index = ArmorySystem

local CollectionService = game:GetService("CollectionService")

function ArmorySystem.new(solitarySystem)
	local self = setmetatable({}, ArmorySystem)
	self._solitarySystem = solitarySystem
	self._armoryLocation = nil
	
	-- Find armory in workspace
	self:FindArmory()
	
	return self
end

-- Find armory in workspace
function ArmorySystem:FindArmory()
	local armories = CollectionService:GetTagged("Armory")
	
	if #armories > 0 then
		local armory = armories[1]
		self._armoryLocation = armory:IsA("BasePart") and armory.Position or
		                       (armory:IsA("Model") and armory.PrimaryPart and armory.PrimaryPart.Position) or
		                       armory.Position
		print("ArmorySystem: Found armory in workspace")
	else
		warn("ArmorySystem: No armory found in workspace")
	end
end

-- Retrieve item from armory (requires work/effort)
function ArmorySystem:RetrieveItem(userId: number, itemIndex: number): boolean
	local confiscatedItems = self._solitarySystem:GetConfiscatedItems(userId)
	
	if itemIndex < 1 or itemIndex > #confiscatedItems then
		return false
	end
	
	-- TODO: Implement retrieval logic
	-- For now, just return true
	return true
end

-- Get armory location
function ArmorySystem:GetArmoryLocation(): Vector3?
	return self._armoryLocation
end

return ArmorySystem
