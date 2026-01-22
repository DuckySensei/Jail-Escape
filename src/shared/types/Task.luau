-- Task.luau
-- Type definitions for tasks

export type TaskCategory = 
	"Labor" | 
	"Skilled" | 
	"Illegal" | 
	"SuperIllegal" | 
	"Rehabilitation"

export type Task = {
	id: string,
	name: string,
	category: TaskCategory,
	suspicionLevel: number, -- 0-100
	pay: number,
	timeRequired: number, -- Game time in minutes
	requirements: {TaskRequirement}?,
	location: Vector3,
	assignedTo: number?, -- userId, nil if unassigned
	description: string?,
	isAvailable: boolean,
}

export type TaskRequirement = {
	type: "Item" | "Skill" | "Prerequisite",
	value: string, -- ItemId, SkillName, or TaskId
}

return {}
