-- NPC.luau
-- Type definitions for NPCs

export type NPCType = "Guard" | "Inmate" | "Warden"

export type NPCId = string

export type NPCData = {
	id: NPCId,
	type: NPCType,
	currentLocation: Vector3,
	patrolRoute: {Vector3}?,
	targetLocation: Vector3?,
	isPathfinding: boolean,
	currentTask: string?, -- taskId
	difficulty: number?, -- 0-100, for solo mode AI
	behaviorState: string?, -- Current behavior state
}

export type GuardNPC = NPCData & {
	type: "Guard",
	patrolRoute: {Vector3},
	investigatingTarget: number?, -- userId being investigated
	surveillanceTargets: {number}, -- userIds being watched
}

export type InmateNPC = NPCData & {
	type: "Inmate",
	money: number,
	inventory: Inventory, -- Similar to player inventory
	escapeProgress: {[string]: number}, -- Can attempt escape like players
	preferredItems: {string}, -- ItemIds this NPC wants for services
}

export type WardenNPC = NPCData & {
	type: "Warden",
	dailyTasks: {WardenTask},
	currentTask: WardenTask?,
	knownPatterns: {[number]: BehaviorPattern}, -- userId -> behavior pattern
}

export type WardenTask = {
	id: string,
	type: "CheckCameras" | "WatchArea" | "Patrol" | "Investigate",
	location: Vector3?,
	targetArea: string?,
	duration: number,
	startTime: number,
}

export type BehaviorPattern = {
	userId: number,
	commonLocations: {[string]: number}, -- location -> visit count
	suspicionLevel: number,
	lastSeen: number, -- timestamp
	lastLocation: Vector3?,
}

export type Inventory = {
	grid: {[number]: {[number]: InventoryCell}},
	width: number,
	height: number,
	items: {InventoryItem}
}

export type InventoryCell = {
	itemId: string?,
	rotation: number?,
}

export type InventoryItem = {
	itemId: string,
	position: {x: number, y: number},
	rotation: number,
	size: {width: number, height: number},
}

return {}
