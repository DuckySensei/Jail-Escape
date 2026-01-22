-- GuardManager.luau
-- Main guard system coordinator

local GuardManager = {}
GuardManager.__index = GuardManager

local GuardNPC = require(script.Parent.GuardNPC)
local GuardPatrol = require(script.Parent.GuardPatrol)
local GuardInvestigation = require(script.Parent.GuardInvestigation)
local WardenAI = require(script.Parent.WardenAI)
local WardenNPC = require(script.Parent.WardenNPC)
local CameraSystem = require(script.Parent.CameraSystem)
local SolitarySystem = require(script.Parent.SolitarySystem)
local ArmorySystem = require(script.Parent.ArmorySystem)

local CollectionService = game:GetService("CollectionService")

function GuardManager.new(playerManager, suspicionSystem, activityTracker, inventorySystem)
	local self = setmetatable({}, GuardManager)
	self._playerManager = playerManager
	self._suspicionSystem = suspicionSystem
	self._activityTracker = activityTracker
	self._inventorySystem = inventorySystem
	
	-- Initialize subsystems
	self._patrol = GuardPatrol.new()
	self._investigation = GuardInvestigation.new()
	self._wardenAI = WardenAI.new(suspicionSystem, activityTracker)
	self._cameraSystem = CameraSystem.new(activityTracker)
	self._cameraSystem:SetGuardManager(self) -- Set after creation
	self._solitarySystem = SolitarySystem.new(playerManager, inventorySystem)
	self._armorySystem = ArmorySystem.new(self._solitarySystem)
	
	-- Guards and warden
	self._guards = {} -- guardId -> GuardNPC
	self._warden = nil
	
	-- Spawn guards and warden
	self:SpawnGuards()
	self:SpawnWarden()
	
	return self
end

-- Spawn guards
function GuardManager:SpawnGuards()
	local guardSpawns = CollectionService:GetTagged("GuardSpawn")
	local routes = self._patrol:GetAllRoutes()
	local routeIds = {}
	for routeId, _ in pairs(routes) do
		table.insert(routeIds, routeId)
	end
	
	for i, spawn in ipairs(guardSpawns) do
		local guardId = "Guard_" .. tostring(i)
		local spawnPosition = spawn:IsA("BasePart") and spawn.Position or
		                      (spawn:IsA("Model") and spawn.PrimaryPart and spawn.PrimaryPart.Position) or
		                      spawn.Position
		
		-- Assign patrol route
		local routeId = routeIds[math.random(1, #routeIds)] or routeIds[1]
		local route = self._patrol:GetRoute(routeId) or {}
		
		local guard = GuardNPC.new(guardId, spawnPosition, route)
		self._guards[guardId] = guard
	end
	
	print("GuardManager: Spawned", #guardSpawns, "guards")
end

-- Spawn warden
function GuardManager:SpawnWarden()
	local wardenSpawns = CollectionService:GetTagged("WardenSpawn")
	
	if #wardenSpawns > 0 then
		local spawn = wardenSpawns[1]
		local spawnPosition = spawn:IsA("BasePart") and spawn.Position or
		                      (spawn:IsA("Model") and spawn.PrimaryPart and spawn.PrimaryPart.Position) or
		                      spawn.Position
		
		local wardenId = "Warden_1"
		self._warden = WardenNPC.new(wardenId, spawnPosition, self._wardenAI)
		
		-- Generate daily tasks
		self._wardenAI:GenerateDailyTasks()
		
		print("GuardManager: Spawned warden")
	else
		warn("GuardManager: No warden spawn found")
	end
end

-- Send player to solitary
function GuardManager:SendToSolitary(userId: number, reason: string?): boolean
	return self._solitarySystem:SendToSolitary(userId, reason)
end

-- Investigate location
function GuardManager:InvestigateLocation(location: Vector3, targetUserId: number?)
	-- Find nearest guard
	local nearestGuard = nil
	local nearestDistance = math.huge
	
	for _, guard in pairs(self._guards) do
		local distance = (guard:GetCurrentLocation() - location).Magnitude
		if distance < nearestDistance then
			nearestDistance = distance
			nearestGuard = guard
		end
	end
	
	if nearestGuard then
		local guardId = nearestGuard:GetId()
		self._investigation:StartInvestigation(guardId, targetUserId, location)
		nearestGuard:SetTargetLocation(location)
		nearestGuard:SetInvestigatingTarget(targetUserId)
	end
end

-- Get guard manager
function GuardManager:GetGuardManager()
	return self
end

return GuardManager
