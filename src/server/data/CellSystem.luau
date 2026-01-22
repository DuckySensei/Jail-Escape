-- CellSystem.luau
-- Manages cell interactions, including the photo system

local CellSystem = {}
CellSystem.__index = CellSystem

local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

function CellSystem.new(escapeMethodManager)
	local self = setmetatable({}, CellSystem)
	self._escapeMethodManager = escapeMethodManager
	self._cellPhotos = {} -- cellId -> workspace instance
	
	-- Find cell photos in workspace
	self:FindCellPhotos()
	
	return self
end

-- Find cell photos in workspace
function CellSystem:FindCellPhotos()
	local photos = CollectionService:GetTagged("CellPhoto")
	
	for _, photo in ipairs(photos) do
		local cellId = photo:GetAttribute("CellId")
		if cellId then
			self._cellPhotos[cellId] = photo
		end
	end
	
	print("CellSystem: Found", #photos, "cell photos in workspace")
end

-- Get escape progress data for cell photo display
function CellSystem:GetEscapeProgressForCell(cellId: number, userId: number): any
	if not self._escapeMethodManager then
		return nil
	end
	
	local progress = self._escapeMethodManager:GetEscapeProgress(userId)
	
	-- Format for display
	local displayData = {
		methods = {},
	}
	
	for methodId, methodProgress in pairs(progress) do
		table.insert(displayData.methods, {
			methodId = methodId,
			name = methodId, -- Will get from config
			progress = methodProgress.overallProgress,
			currentStep = methodProgress.currentStep,
			nextItemsNeeded = methodProgress.nextItemsNeeded,
		})
	end
	
	return displayData
end

-- Handle photo interaction
function CellSystem:OnPhotoInteract(userId: number, cellId: number): any
	-- Get escape progress
	local progress = self:GetEscapeProgressForCell(cellId, userId)
	return progress
end

return CellSystem
