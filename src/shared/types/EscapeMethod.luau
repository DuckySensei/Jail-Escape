-- EscapeMethod.luau
-- Type definitions for escape methods

export type EscapeMethodId = 
	"FenceCutting" | 
	"GuardDisguise" | 
	"CellDigging" | 
	"Parole" | 
	"CartelBreakout"

export type EscapeMethodStep = {
	id: string,
	name: string,
	description: string,
	requirements: {EscapeRequirement}?,
	progress: number, -- 0-100
	isComplete: boolean,
}

export type EscapeRequirement = {
	type: "Item" | "Location" | "Knowledge" | "Time" | "Money" | "Task",
	value: string, -- ItemId, LocationName, KnowledgeName, TimeAmount, MoneyAmount, TaskId
	quantity: number?, -- For items/money
}

export type EscapeMethodProgress = {
	methodId: EscapeMethodId,
	steps: {EscapeMethodStep},
	overallProgress: number, -- 0-100
	currentStep: number, -- Index of current step
	requirementsMet: boolean,
	nextItemsNeeded: {string}, -- ItemIds needed for next step
}

return {}
