-- Player.luau
-- Type definitions for player data structures

export type PlayerData = {
	userId: number,
	player: Player?, -- Optional, may be nil if player left
	cellId: number,
	suspicion: number, -- 0-100
	money: number,
	teamId: number?, -- Optional, nil in free-for-all
	inventory: Inventory,
	escapeProgress: {[string]: number}, -- escapeMethodId -> progress percentage (0-100)
	activityLog: {[number]: ActivityLog}, -- day -> activities
	currentLocation: Vector3?,
	currentTask: string?, -- taskId, if assigned
	isInSolitary: boolean,
	solitaryStartTime: number?, -- timestamp
}

export type Inventory = {
	grid: {[number]: {[number]: InventoryCell}},
	width: number,
	height: number,
	items: {InventoryItem}
}

export type InventoryCell = {
	itemId: string?,
	rotation: number?, -- 0, 90, 180, 270
}

export type InventoryItem = {
	itemId: string,
	position: {x: number, y: number},
	rotation: number, -- 0, 90, 180, 270
	size: {width: number, height: number},
}

export type Team = {
	teamId: number,
	members: {number}, -- userIds
	escapeCount: number, -- number of members who escaped
}

return {}
