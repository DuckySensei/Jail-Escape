-- InmateNPC.luau
-- Inmate NPC implementation

local InmateNPC = {}
InmateNPC.__index = InmateNPC

local NPCBase = require(script.Parent.NPCBase)
local NPCBehaviorTree = require(script.Parent.NPCBehaviorTree)

local RS = game:GetService("ReplicatedStorage")
local GameSettings = require(RS.Shared.config.GameSettings)

function InmateNPC.new(inmateId: string, spawnPosition: Vector3, difficulty: number?)
	local self = setmetatable(NPCBase.new(inmateId, "Inmate", spawnPosition), InmateNPC)
	
	-- Set difficulty (for solo mode)
	local npcDifficulty = difficulty or math.random(
		GameSettings.NPC_DIFFICULTY_SOLO_MODE.MIN or 30,
		GameSettings.NPC_DIFFICULTY_SOLO_MODE.MAX or 70
	)
	
	self._behaviorTree = NPCBehaviorTree.new(npcDifficulty)
	self._money = 0
	self._inventory = {
		grid = {},
		width = GameSettings.INVENTORY_GRID_WIDTH,
		height = GameSettings.INVENTORY_GRID_HEIGHT,
		items = {},
	}
	self._escapeProgress = {}
	self._preferredItems = {} -- Items this NPC wants for services
	
	-- Initialize inventory grid
	for x = 1, self._inventory.width do
		self._inventory.grid[x] = {}
		for y = 1, self._inventory.height do
			self._inventory.grid[x][y] = {
				itemId = nil,
				rotation = nil,
			}
		end
	end
	
	return self
end

-- Get money
function InmateNPC:GetMoney(): number
	return self._money
end

-- Add money
function InmateNPC:AddMoney(amount: number)
	self._money = self._money + amount
end

-- Get inventory
function InmateNPC:GetInventory(): Inventory
	return self._inventory
end

-- Get escape progress
function InmateNPC:GetEscapeProgress(): {[string]: number}
	return self._escapeProgress
end

-- Get preferred items
function InmateNPC:GetPreferredItems(): {string}
	return self._preferredItems
end

-- Set preferred items
function InmateNPC:SetPreferredItems(items: {string})
	self._preferredItems = items
end

-- Get behavior tree
function InmateNPC:GetBehaviorTree(): NPCBehaviorTree
	return self._behaviorTree
end

-- Make decision (for solo mode AI)
function InmateNPC:MakeDecision(options: {any}, informationDepth: number): any?
	return self._behaviorTree:EvaluateDecision(options, informationDepth)
end

return InmateNPC
