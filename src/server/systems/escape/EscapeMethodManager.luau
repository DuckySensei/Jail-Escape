-- EscapeMethodManager.luau
-- Main escape method coordinator

local EscapeMethodManager = {}
EscapeMethodManager.__index = EscapeMethodManager

local EscapeMethod = require(script.Parent.EscapeMethod)

local RS = game:GetService("ReplicatedStorage")
local EscapeMethodsConfig = require(RS.Shared.config.EscapeMethods)
local GameSettings = require(RS.Shared.config.GameSettings)

function EscapeMethodManager.new(playerManager, itemSystem, inventorySystem)
	local self = setmetatable({}, EscapeMethodManager)
	self._playerManager = playerManager
	self._itemSystem = itemSystem
	self._inventorySystem = inventorySystem
	self._playerMethods = {} -- userId -> {methodId -> EscapeMethod}
	
	return self
end

-- Initialize escape methods for a player
function EscapeMethodManager:InitializePlayerMethods(userId: number)
	if self._playerMethods[userId] then
		return -- Already initialized
	end
	
	self._playerMethods[userId] = {}
	
	-- Create all escape methods for player
	for methodId, config in pairs(EscapeMethodsConfig) do
		local method = EscapeMethod.new(methodId, config)
		self._playerMethods[userId][methodId] = method
	end
end

-- Get escape method for a player
function EscapeMethodManager:GetMethod(userId: number, methodId: string): EscapeMethod?
	if not self._playerMethods[userId] then
		self:InitializePlayerMethods(userId)
	end
	
	return self._playerMethods[userId][methodId]
end

-- Get all methods for a player
function EscapeMethodManager:GetAllMethods(userId: number): {[string]: EscapeMethod}
	if not self._playerMethods[userId] then
		self:InitializePlayerMethods(userId)
	end
	
	return self._playerMethods[userId]
end

-- Get escape progress for a player (all methods)
function EscapeMethodManager:GetEscapeProgress(userId: number): {[string]: EscapeMethodProgress}
	if not self._playerMethods[userId] then
		self:InitializePlayerMethods(userId)
	end
	
	local progress = {}
	
	for methodId, method in pairs(self._playerMethods[userId]) do
		local currentStep = method:GetCurrentStep()
		progress[methodId] = {
			methodId = methodId,
			steps = method:GetSteps(),
			overallProgress = method:GetOverallProgress(),
			currentStep = method:GetCurrentStepIndex(),
			requirementsMet = method:CheckRequirements(
				self._playerManager:GetPlayerData(userId),
				self._itemSystem
			),
			nextItemsNeeded = method:GetNextItemsNeeded(),
		}
	end
	
	return progress
end

-- Update method progress
function EscapeMethodManager:UpdateMethodProgress(userId: number, methodId: string, stepIndex: number, progress: number)
	local method = self:GetMethod(userId, methodId)
	if method then
		method:UpdateStepProgress(stepIndex, progress)
	end
end

-- Complete a step
function EscapeMethodManager:CompleteStep(userId: number, methodId: string, stepIndex: number)
	local method = self:GetMethod(userId, methodId)
	if method then
		method:CompleteStep(stepIndex)
		
		-- Check if method is complete
		if method:CanComplete() then
			-- TODO: Handle escape completion
			print("EscapeMethodManager: Player", userId, "completed escape method", methodId)
		end
	end
end

-- Check if player can escape via a method
function EscapeMethodManager:CanEscape(userId: number, methodId: string): boolean
	local method = self:GetMethod(userId, methodId)
	if not method then
		return false
	end
	
	return method:CanComplete()
end

return EscapeMethodManager
