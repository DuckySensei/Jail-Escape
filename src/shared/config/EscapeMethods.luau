-- EscapeMethods.luau
-- Escape method configurations
-- Each method has different trade-offs: Time, Suspicion, Cost

local EscapeMethods = {}

-- Fence Cutting Method
EscapeMethods.FenceCutting = {
	id = "FenceCutting",
	name = "Fence Cutting",
	description = "Cut through the perimeter fence to escape",
	time = "Medium", -- Time investment
	suspicion = "Medium", -- Suspicion risk
	cost = "Medium", -- Resource cost
	steps = {
		{
			id = "acquireTool",
			name = "Acquire Cutting Tool",
			description = "Obtain wire cutters or similar cutting tool",
			requirements = {
				{type = "Item", value = "wireCutters", quantity = 1},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "locateWeakPoint",
			name = "Locate Weak Point",
			description = "Find a weak point in the perimeter fence",
			requirements = {
				{type = "Knowledge", value = "fenceWeakPoints"},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "waitForOpportunity",
			name = "Wait for Low Guard Activity",
			description = "Wait for guards to be away from the fence area",
			requirements = {
				{type = "Time", value = "guardPatrolCycle"},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "cutFence",
			name = "Cut Fence",
			description = "Cut through the fence section",
			requirements = {
				{type = "Item", value = "wireCutters", quantity = 1},
				{type = "Location", value = "fenceWeakPoint"},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "escape",
			name = "Escape",
			description = "Escape through the opening",
			requirements = {
				{type = "Location", value = "outsidePrison"},
			},
			progress = 0,
			isComplete = false,
		},
	},
}

-- Guard Disguise Method
EscapeMethods.GuardDisguise = {
	id = "GuardDisguise",
	name = "Guard Disguise",
	description = "Disguise as a guard and walk out",
	time = "Short", -- Fastest method
	suspicion = "VeryHigh", -- Very high risk
	cost = "Medium",
	steps = {
		{
			id = "acquireUniform",
			name = "Acquire Guard Uniform",
			description = "Steal or acquire a guard uniform",
			requirements = {
				{type = "Item", value = "guardUniform", quantity = 1},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "acquireBadge",
			name = "Acquire ID Badge",
			description = "Obtain or forge a guard ID badge",
			requirements = {
				{type = "Item", value = "guardBadge", quantity = 1},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "learnRoutines",
			name = "Learn Guard Routines",
			description = "Study guard patrol patterns and routines",
			requirements = {
				{type = "Knowledge", value = "guardRoutines"},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "disguise",
			name = "Disguise as Guard",
			description = "Put on uniform and badge during shift change",
			requirements = {
				{type = "Item", value = "guardUniform", quantity = 1},
				{type = "Item", value = "guardBadge", quantity = 1},
				{type = "Time", value = "shiftChange"},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "walkOut",
			name = "Walk Out",
			description = "Walk out through the main gate",
			requirements = {
				{type = "Location", value = "mainGate"},
			},
			progress = 0,
			isComplete = false,
		},
	},
}

-- Cell Digging Method
EscapeMethods.CellDigging = {
	id = "CellDigging",
	name = "Cell Digging",
	description = "Dig a tunnel from your cell to outside",
	time = "VeryLong", -- Takes a long time
	suspicion = "Low", -- Low suspicion if done carefully
	cost = "LowToMedium",
	steps = {
		{
			id = "acquireDiggingTool",
			name = "Acquire Digging Tool",
			description = "Obtain a shovel or similar digging tool",
			requirements = {
				{type = "Item", value = "shovel", quantity = 1},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "identifyLocation",
			name = "Identify Dig Location",
			description = "Find a suitable spot in your cell to dig",
			requirements = {
				{type = "Location", value = "cell"},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "digTunnel",
			name = "Dig Tunnel",
			description = "Dig the tunnel (takes significant time)",
			requirements = {
				{type = "Item", value = "shovel", quantity = 1},
				{type = "Time", value = "longDigTime"}, -- Very long time
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "disposeDirt",
			name = "Dispose of Dirt",
			description = "Get rid of the dirt without being caught",
			requirements = {
				{type = "Knowledge", value = "dirtDisposalMethods"},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "escapeThroughTunnel",
			name = "Escape Through Tunnel",
			description = "Crawl through the tunnel to freedom",
			requirements = {
				{type = "Location", value = "outsidePrison"},
			},
			progress = 0,
			isComplete = false,
		},
	},
}

-- Parole Method
EscapeMethods.Parole = {
	id = "Parole",
	name = "Parole",
	description = "Complete rehabilitation and get legal early release",
	time = "Long", -- Many tasks required
	suspicion = "Low", -- Requires maintaining good behavior
	cost = "Low", -- Mostly time investment
	steps = {
		{
			id = "completeRehabTasks",
			name = "Complete Rehabilitation Tasks",
			description = "Complete multiple rehabilitation tasks",
			requirements = {
				{type = "Task", value = "groupTherapy", quantity = 5},
				{type = "Task", value = "educationalCourse", quantity = 3},
				{type = "Task", value = "communityService", quantity = 2},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "maintainGoodBehavior",
			name = "Maintain Good Behavior",
			description = "Keep suspicion level low",
			requirements = {
				{type = "Knowledge", value = "lowSuspicion"},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "attendHearings",
			name = "Attend Parole Hearings",
			description = "Attend scheduled parole hearings",
			requirements = {
				{type = "Time", value = "paroleHearingSchedule"},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "passEvaluation",
			name = "Pass Warden Evaluation",
			description = "Convince the warden to grant parole",
			requirements = {
				{type = "Knowledge", value = "wardenApproval"},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "legalRelease",
			name = "Legal Release",
			description = "Walk out legally with early release",
			requirements = {
				{type = "Location", value = "mainGate"},
			},
			progress = 0,
			isComplete = false,
		},
	},
}

-- Cartel Breakout Method
EscapeMethods.CartelBreakout = {
	id = "CartelBreakout",
	name = "Cartel Breakout",
	description = "Pay cartel to break you out",
	time = "MediumToLong", -- Requires coordination and waiting
	suspicion = "Low", -- If done discretely
	cost = "VeryHigh", -- Requires significant money/resources
	steps = {
		{
			id = "acquireContact",
			name = "Acquire Cartel Contact",
			description = "Get in touch with external cartel",
			requirements = {
				{type = "Item", value = "cartelContact", quantity = 1},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "payCartel",
			name = "Pay Cartel",
			description = "Pay the cartel for extraction service",
			requirements = {
				{type = "Money", value = "veryHigh", quantity = 500}, -- Very high cost
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "coordinateExtraction",
			name = "Coordinate Extraction",
			description = "Set up extraction location and time",
			requirements = {
				{type = "Location", value = "extractionPoint"},
				{type = "Time", value = "extractionTime"},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "waitForCartel",
			name = "Wait for Cartel",
			description = "Wait for cartel to arrive",
			requirements = {
				{type = "Time", value = "cartelArrival"},
			},
			progress = 0,
			isComplete = false,
		},
		{
			id = "escapeWithCartel",
			name = "Escape with Cartel",
			description = "Escape via cartel vehicle/transport",
			requirements = {
				{type = "Location", value = "extractionPoint"},
			},
			progress = 0,
			isComplete = false,
		},
	},
}

return EscapeMethods
