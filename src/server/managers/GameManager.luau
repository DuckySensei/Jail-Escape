-- GameManager.luau
-- Main game coordinator - handles initialization, game state, and orchestration

local GameManager = {}
GameManager.__index = GameManager

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local GameSettings = require(RS.Shared.config.GameSettings)

-- Managers
local CellManager = require(script.Parent.CellManager)
local PlayerManager = require(script.Parent.PlayerManager)

-- Phase 2 Systems
local ActivityTracker = require(script.Parent.Parent.systems.activity.ActivityTracker)
local SuspicionSystem = require(script.Parent.Parent.systems.suspicion.SuspicionSystem)
local ItemSystem = require(script.Parent.Parent.data.ItemSystem)
local InventorySystem = require(script.Parent.Parent.data.InventorySystem)
local ResourceSystem = require(script.Parent.Parent.data.ResourceSystem)

-- Phase 3 Systems
local TaskManager = require(script.Parent.Parent.systems.tasks.TaskManager)
local TradingManager = require(script.Parent.Parent.systems.trading.TradingManager)
local EscapeMethodManager = require(script.Parent.Parent.systems.escape.EscapeMethodManager)
local CellSystem = require(script.Parent.Parent.data.CellSystem)

-- Phase 4 Systems
local NPCManager = require(script.Parent.Parent.systems.npcs.NPCManager)
local GuardManager = require(script.Parent.Parent.systems.guards.GuardManager)
local ReportingManager = require(script.Parent.Parent.systems.reporting.ReportingManager)

function GameManager.new()
	local self = setmetatable({}, GameManager)
	
	-- Initialize managers
	self._cellManager = CellManager.new()
	self._npcManager = NPCManager.new()
	self._playerManager = PlayerManager.new(self._cellManager, self._npcManager)
	
	-- Initialize Phase 2 systems
	self._gameStartTime = tick()
	self._activityTracker = ActivityTracker.new(self._gameStartTime)
	self._suspicionSystem = SuspicionSystem.new(self._activityTracker)
	self._itemSystem = ItemSystem.new()
	self._inventorySystem = InventorySystem.new(self._itemSystem)
	self._resourceSystem = ResourceSystem.new()
	
	-- Initialize Phase 3 systems
	self._escapeMethodManager = EscapeMethodManager.new(self._playerManager, self._itemSystem, self._inventorySystem)
	self._cellSystem = CellSystem.new(self._escapeMethodManager)
	self._taskManager = TaskManager.new(self._playerManager, self._resourceSystem, self._activityTracker)
	self._tradingManager = TradingManager.new(self._playerManager, self._inventorySystem, self._resourceSystem, self._itemSystem, self._activityTracker)
	
	-- Initialize Phase 4 systems (order matters to avoid circular dependency)
	self._reportingManager = ReportingManager.new(self._playerManager, self._activityTracker)
	self._guardManager = GuardManager.new(self._playerManager, self._suspicionSystem, self._activityTracker, self._inventorySystem)
	self._reportingManager:SetGuardManager(self._guardManager)
	
	-- Game state
	self._gameState = "Waiting" -- "Waiting", "Starting", "InProgress", "Ended"
	self._gameMode = GameSettings.DEFAULT_GAME_MODE -- "FreeForAll", "Teams", "Solo"
	self._waitStartTime = nil
	self._firstPlayerJoinTime = nil
	self._winner = nil
	
	-- Connections
	self._playerAddedConnection = nil
	self._playerRemovingConnection = nil
	
	return self
end

-- Initialize the game
function GameManager:Initialize()
	print("GameManager: Initializing game...")
	
	-- Connect to player events
	self._playerAddedConnection = Players.PlayerAdded:Connect(function(player)
		self:OnPlayerAdded(player)
	end)
	
	self._playerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
		self:OnPlayerRemoved(player)
	end)
	
	-- Handle existing players
	for _, player in ipairs(Players:GetPlayers()) do
		self:OnPlayerAdded(player)
	end
	
	self._gameState = "Waiting"
end

-- Handle player joining
function GameManager:OnPlayerAdded(player: Player)
	print("GameManager: Player added:", player.Name)
	
	-- Initialize player
	local playerData = self._playerManager:InitializePlayer(player)
	if not playerData then
		warn("GameManager: Failed to initialize player", player.Name)
		return
	end
	
	-- Track first player join time
	if not self._firstPlayerJoinTime then
		self._firstPlayerJoinTime = tick()
		self._waitStartTime = tick()
		print("GameManager: First player joined, starting 10 second wait window")
	end
	
	-- Check if we should start the game
	self:CheckGameStart()
end

-- Handle player leaving
function GameManager:OnPlayerRemoved(player: Player)
	print("GameManager: Player removed:", player.Name)
	self._playerManager:RemovePlayer(player.UserId)
	
	-- If game ended or no players left, reset
	local playerCount = self._playerManager:GetPlayerCount()
	if playerCount == 0 then
		self:ResetGame()
	end
end

-- Check if game should start
function GameManager:CheckGameStart()
	if self._gameState ~= "Waiting" then
		return
	end
	
	local currentTime = tick()
	local timeSinceFirstPlayer = currentTime - self._firstPlayerJoinTime
	local waitTime = GameSettings.PLAYER_JOIN_WAIT_TIME
	
	-- Check if wait time elapsed or max players reached
	local playerCount = self._playerManager:GetPlayerCount()
	local maxPlayers = GameSettings.MAX_PLAYERS
	
	if timeSinceFirstPlayer >= waitTime or playerCount >= maxPlayers then
		self:StartGame()
	else
		-- Schedule check for when wait time elapses
		task.wait(waitTime - timeSinceFirstPlayer)
		if self._gameState == "Waiting" then
			self:StartGame()
		end
	end
end

-- Start the game
function GameManager:StartGame()
	if self._gameState ~= "Waiting" then
		return
	end
	
	print("GameManager: Starting game...")
	self._gameState = "Starting"
	
	-- Fill empty slots with NPCs
	local emptySlots = GameSettings.MAX_PLAYERS - self._playerManager:GetPlayerCount()
	if emptySlots > 0 then
		local npcIds = self._npcManager:SpawnNPCs(emptySlots, self._gameMode)
		print("GameManager: Spawned", #npcIds, "NPCs to fill empty slots")
	end
	
	-- Phase 2, 3 & 4 systems already initialized
	-- Initialize task boards
	self._taskManager:InitializeTaskBoards()
	
	-- Initialize escape methods for all players
	for userId, _ in pairs(self._playerManager:GetAllPlayers()) do
		self._escapeMethodManager:InitializePlayerMethods(userId)
	end
	
	-- Start game loop
	self._gameState = "InProgress"
	print("GameManager: Game started!")
	print("GameManager: Phase 2, 3 & 4 systems initialized")
	
	-- Suspicion decay loop is handled by SuspicionSystem
	-- TODO: Set up game loop for:
	-- - Time-based events
	-- - Guard patrols
end

-- Check win condition
function GameManager:CheckWinCondition(userId: number)
	-- TODO: Implement win condition checking based on game mode
	-- For now, just log
	print("GameManager: Checking win condition for player", userId)
	
	if self._gameMode == "FreeForAll" then
		-- First to escape wins
		-- TODO: Check if player escaped
	elseif self._gameMode == "Teams" then
		-- All team members must escape
		-- TODO: Check team escape status
	elseif self._gameMode == "Solo" then
		-- Solo player escapes
		-- TODO: Check solo escape
	end
end

-- End the game
function GameManager:EndGame(winner: number?)
	self._gameState = "Ended"
	self._winner = winner
	
	if winner then
		local playerData = self._playerManager:GetPlayerData(winner)
		if playerData and playerData.player then
			print("GameManager: Game ended! Winner:", playerData.player.Name)
		else
			print("GameManager: Game ended! Winner (NPC):", winner)
		end
	else
		print("GameManager: Game ended with no winner")
	end
	
	-- TODO: Announce winner, show results, etc.
	
	-- Reset after delay
	task.wait(10) -- 10 second delay before reset
	self:ResetGame()
end

-- Reset the game
function GameManager:ResetGame()
	print("GameManager: Resetting game...")
	
	self._gameState = "Waiting"
	self._waitStartTime = nil
	self._firstPlayerJoinTime = nil
	self._winner = nil
	
	-- Clean up all players
	for userId, _ in pairs(self._playerManager:GetAllPlayers()) do
		self._playerManager:RemovePlayer(userId)
	end
	
	-- TODO: Reset all systems
	-- - Activity Tracker
	-- - Suspicion System
	-- - Task System
	-- - Escape Methods
	-- - Trading System
	-- - NPC System
	-- - Guard System
	
	print("GameManager: Game reset complete")
end

-- Get game state
function GameManager:GetGameState(): string
	return self._gameState
end

-- Get game mode
function GameManager:GetGameMode(): string
	return self._gameMode
end

-- Set game mode
function GameManager:SetGameMode(gameMode: string)
	if self._gameState ~= "Waiting" then
		warn("GameManager: Cannot change game mode during active game")
		return
	end
	
	self._gameMode = gameMode
	print("GameManager: Game mode set to:", gameMode)
end

-- Get player manager
function GameManager:GetPlayerManager()
	return self._playerManager
end

-- Get cell manager
function GameManager:GetCellManager()
	return self._cellManager
end

-- Cleanup on shutdown
function GameManager:Cleanup()
	if self._playerAddedConnection then
		self._playerAddedConnection:Disconnect()
	end
	
	if self._playerRemovingConnection then
		self._playerRemovingConnection:Disconnect()
	end
end

return GameManager
