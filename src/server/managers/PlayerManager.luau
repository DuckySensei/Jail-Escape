-- PlayerManager.luau
-- Manages player lifecycle, initialization, and data

local PlayerManager = {}
PlayerManager.__index = PlayerManager

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage" )
local GameSettings = require(RS.Shared.config.GameSettings)

function PlayerManager.new(cellManager, npcManager)
	local self = setmetatable({}, PlayerManager)
	self._cellManager = cellManager
	self._npcManager = npcManager
	self._players = {} -- userId -> PlayerData
	self._playerObjects = {} -- userId -> Player (Roblox Player object)
	
	return self
end

-- Initialize player data when they join
function PlayerManager:InitializePlayer(player: Player): PlayerData
	local userId = player.UserId
	
	-- Assign cell
	local cellId = self._cellManager:AssignCell(userId)
	if not cellId then
		warn("PlayerManager: Could not assign cell to player", player.Name)
		return nil
	end
	
	-- Create player data
	local playerData: PlayerData = {
		userId = userId,
		player = player,
		cellId = cellId,
		suspicion = 0,
		money = 0,
		teamId = nil,
		inventory = {
			grid = {},
			width = GameSettings.INVENTORY_GRID_WIDTH,
			height = GameSettings.INVENTORY_GRID_HEIGHT,
			items = {},
		},
		escapeProgress = {},
		activityLog = {},
		currentLocation = nil,
		currentTask = nil,
		isInSolitary = false,
		solitaryStartTime = nil,
	}
	
	-- Initialize inventory grid
	for x = 1, playerData.inventory.width do
		playerData.inventory.grid[x] = {}
		for y = 1, playerData.inventory.height do
			playerData.inventory.grid[x][y] = {
				itemId = nil,
				rotation = nil,
			}
		end
	end
	
	self._players[userId] = playerData
	self._playerObjects[userId] = player
	
	-- Teleport player to their cell
	task.spawn(function()
		-- Wait for character to load
		if not player.Character then
			player.CharacterAdded:Wait()
		end
		
		-- Small delay to ensure character is fully loaded
		task.wait(0.5)
		
		local success = self._cellManager:TeleportPlayerToCell(player, cellId)
		if success then
			print("PlayerManager: Teleported", player.Name, "to cell", cellId)
		else
			warn("PlayerManager: Failed to teleport", player.Name, "to cell", cellId)
		end
	end)
	
	return playerData
end

-- Handle player leaving
function PlayerManager:RemovePlayer(userId: number)
	local playerData = self._players[userId]
	if not playerData then
		return
	end
	
	-- Unassign cell
	self._cellManager:UnassignCell(userId)
	
	-- Clean up
	self._players[userId] = nil
	self._playerObjects[userId] = nil
end

-- Get player data
function PlayerManager:GetPlayerData(userId: number): PlayerData?
	return self._players[userId]
end

-- Get player object
function PlayerManager:GetPlayer(userId: number): Player?
	return self._playerObjects[userId]
end

-- Get all player data
function PlayerManager:GetAllPlayers(): {[number]: PlayerData}
	return self._players
end

-- Get all player IDs
function PlayerManager:GetAllPlayerIds(): {number}
	local ids = {}
	for userId, _ in pairs(self._players) do
		table.insert(ids, userId)
	end
	return ids
end

-- Get player count
function PlayerManager:GetPlayerCount(): number
	return #self:GetAllPlayerIds()
end

-- Check if player exists
function PlayerManager:PlayerExists(userId: number): boolean
	return self._players[userId] ~= nil
end

-- Update player data
function PlayerManager:UpdatePlayerData(userId: number, updates: {[string]: any})
	local playerData = self._players[userId]
	if not playerData then
		warn("PlayerManager: Player data not found for userId", userId)
		return
	end
	
	for key, value in pairs(updates) do
		playerData[key] = value
	end
end

-- Fill empty slots with NPCs (called after waiting period)
-- Note: This is now handled in GameManager after all systems are initialized
function PlayerManager:FillEmptySlots()
	-- Moved to GameManager:StartGame() for proper initialization order
	-- Keeping this function for compatibility but it's a no-op
end

-- Set team for player
function PlayerManager:SetTeam(userId: number, teamId: number)
	local playerData = self._players[userId]
	if playerData then
		playerData.teamId = teamId
	end
end

return PlayerManager
