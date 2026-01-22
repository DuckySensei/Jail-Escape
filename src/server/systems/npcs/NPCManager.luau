-- NPCManager.luau
-- Main NPC system coordinator

local NPCManager = {}
NPCManager.__index = NPCManager

local NPCBase = require(script.Parent.NPCBase)
local NPCPathfinding = require(script.Parent.NPCPathfinding)
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

local RS = game:GetService("ReplicatedStorage")
local GameSettings = require(RS.Shared.config.GameSettings)

function NPCManager.new()
	local self = setmetatable({}, NPCManager)
	self._npcs = {} -- npcId -> NPCData
	self._pathfinding = NPCPathfinding.new()
	self._guardSpawns = {}
	self._inmateSpawns = {}
	self._wardenSpawn = nil
	
	-- Find spawn points
	self:FindSpawnPoints()
	
	return self
end

-- Find spawn points in workspace
function NPCManager:FindSpawnPoints()
	-- Find guard spawns
	local guardSpawns = CollectionService:GetTagged("GuardSpawn")
	for _, spawn in ipairs(guardSpawns) do
		local position = spawn:IsA("BasePart") and spawn.Position or 
		                 (spawn:IsA("Model") and spawn.PrimaryPart and spawn.PrimaryPart.Position) or
		                 spawn.Position
		table.insert(self._guardSpawns, position)
	end
	
	-- Find inmate NPC spawns
	local inmateSpawns = CollectionService:GetTagged("InmateNPCSpawn")
	for _, spawn in ipairs(inmateSpawns) do
		local position = spawn:IsA("BasePart") and spawn.Position or 
		                 (spawn:IsA("Model") and spawn.PrimaryPart and spawn.PrimaryPart.Position) or
		                 spawn.Position
		table.insert(self._inmateSpawns, position)
	end
	
	-- Find warden spawn
	local wardenSpawns = CollectionService:GetTagged("WardenSpawn")
	if #wardenSpawns > 0 then
		local spawn = wardenSpawns[1]
		self._wardenSpawn = spawn:IsA("BasePart") and spawn.Position or 
		                    (spawn:IsA("Model") and spawn.PrimaryPart and spawn.PrimaryPart.Position) or
		                    spawn.Position
	end
	
	print("NPCManager: Found", #self._guardSpawns, "guard spawns,", #self._inmateSpawns, "inmate spawns")
end

-- Spawn NPCs to fill empty player slots
function NPCManager:SpawnNPCs(count: number, gameMode: string): {string}
	local spawnedNPCs = {}
	
	-- Determine difficulty for solo mode
	local difficulty = nil
	if gameMode == "Solo" then
		difficulty = math.random(
			GameSettings.NPC_DIFFICULTY_SOLO_MODE.MIN,
			GameSettings.NPC_DIFFICULTY_SOLO_MODE.MAX
		)
	end
	
	-- Spawn inmate NPCs (they fill player slots)
	for i = 1, count do
		local npcId = "InmateNPC_" .. tostring(tick()) .. "_" .. tostring(i)
		local spawnPosition = self._inmateSpawns[math.random(1, #self._inmateSpawns)] or Vector3.new(0, 5, 0)
		
		local npc = NPCBase.new(npcId, "Inmate", spawnPosition)
		npc._difficulty = difficulty
		
		self._npcs[npcId] = npc
		table.insert(spawnedNPCs, npcId)
	end
	
	print("NPCManager: Spawned", count, "inmate NPCs")
	return spawnedNPCs
end

-- Get NPC by ID
function NPCManager:GetNPC(npcId: string): NPCBase?
	return self._npcs[npcId]
end

-- Get all NPCs
function NPCManager:GetAllNPCs(): {[string]: NPCBase}
	return self._npcs
end

-- Get NPCs by type
function NPCManager:GetNPCsByType(npcType: string): {NPCBase}
	local npcs = {}
	for _, npc in pairs(self._npcs) do
		if npc:GetType() == npcType then
			table.insert(npcs, npc)
		end
	end
	return npcs
end

-- Remove NPC
function NPCManager:RemoveNPC(npcId: string)
	self._npcs[npcId] = nil
end

return NPCManager
