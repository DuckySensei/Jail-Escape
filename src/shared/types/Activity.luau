-- Activity.luau
-- Type definitions for activity tracking

export type ActivityType = 
	"LocationVisit" | 
	"ItemUse" | 
	"ItemPickup" | 
	"ItemDrop" | 
	"TaskComplete" | 
	"TaskAccept" | 
	"EscapeMethodProgress" | 
	"SuspiciousBehavior" |
	"ReportSubmitted" |
	"Trading" |
	"GuardInteraction"

export type ActivityLog = {
	activities: {Activity}
}

export type Activity = {
	timestamp: number, -- Unix timestamp
	type: ActivityType,
	location: Vector3,
	details: ActivityDetails,
}

export type ActivityDetails = {
	-- For LocationVisit
	locationName: string?,
	
	-- For ItemUse/ItemPickup/ItemDrop
	itemId: string?,
	
	-- For TaskComplete/TaskAccept
	taskId: string?,
	taskCategory: string?,
	
	-- For EscapeMethodProgress
	escapeMethodId: string?,
	progress: number?,
	step: string?,
	
	-- For SuspiciousBehavior
	behaviorType: string?,
	
	-- For ReportSubmitted
	targetUserId: number?,
	reportDetails: string?,
	
	-- For Trading
	tradeType: string?, -- "buy", "sell", "trade"
	itemId: string?,
	money: number?,
	
	-- For GuardInteraction
	guardId: string?,
	interactionType: string?, -- "caught", "investigation", "order"
}

-- Daily activity log structure
export type DailyActivityLog = {
	[day: number]: ActivityLog
}

return {}
