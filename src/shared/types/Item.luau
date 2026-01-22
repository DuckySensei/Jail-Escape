-- Item.luau
-- Type definitions for items

export type ItemCategory = 
	"Tool" | 
	"Consumable" | 
	"Uniform" | 
	"Key" | 
	"Resource" | 
	"Contraband" | 
	"Other"

export type ItemDefinition = {
	id: string,
	name: string,
	category: ItemCategory,
	gridSize: {width: number, height: number}, -- Grid space taken
	suspicionValue: number, -- Suspicion increase when found
	properties: {[string]: any}, -- Flexible properties
	stackable: boolean?,
	maxStack: number?,
}

export type ItemInstance = {
	itemId: string,
	instance: BasePart?, -- Physical instance in workspace (if exists)
	ownerId: number?, -- userId of owner, nil if unowned
	location: Vector3?, -- Location if in world
}

return {}
