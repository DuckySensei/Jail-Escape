-- Items.luau
-- Item definitions for the game
-- Items are data-driven and easy to extend

local ItemDefinitions = {}

-- Tool Category
ItemDefinitions.wireCutters = {
	id = "wireCutters",
	name = "Wire Cutters",
	category = "Tool",
	gridSize = {width = 2, height = 1},
	suspicionValue = 8,
	properties = {
		toolType = "cutting",
		durability = 100,
	},
}

ItemDefinitions.shovel = {
	id = "shovel",
	name = "Shovel",
	category = "Tool",
	gridSize = {width = 3, height = 1},
	suspicionValue = 10,
	properties = {
		toolType = "digging",
		durability = 150,
	},
}

ItemDefinitions.lockPick = {
	id = "lockPick",
	name = "Lock Pick",
	category = "Tool",
	gridSize = {width = 1, height = 1},
	suspicionValue = 6,
	properties = {
		toolType = "locking",
		durability = 50,
	},
}

-- Uniform Category
ItemDefinitions.guardUniform = {
	id = "guardUniform",
	name = "Guard Uniform",
	category = "Uniform",
	gridSize = {width = 3, height = 2},
	suspicionValue = 20, -- Very high if caught
	properties = {
		uniformType = "guard",
		requiredForEscape = "GuardDisguise",
	},
}

ItemDefinitions.guardBadge = {
	id = "guardBadge",
	name = "Guard ID Badge",
	category = "Key",
	gridSize = {width = 1, height = 1},
	suspicionValue = 15,
	properties = {
		badgeType = "guard",
		requiredForEscape = "GuardDisguise",
	},
}

-- Consumable Category
ItemDefinitions.ramen = {
	id = "ramen",
	name = "Ramen",
	category = "Consumable",
	gridSize = {width = 1, height = 1},
	suspicionValue = 0, -- Normal prison food
	stackable = true,
	maxStack = 10,
	properties = {
		foodValue = 1,
	},
}

ItemDefinitions.gum = {
	id = "gum",
	name = "Gum",
	category = "Consumable",
	gridSize = {width = 1, height = 1},
	suspicionValue = 1,
	stackable = true,
	maxStack = 5,
	properties = {
		distractionValue = 1,
	},
}

ItemDefinitions.sleepingPills = {
	id = "sleepingPills",
	name = "Sleeping Pills",
	category = "Consumable",
	gridSize = {width = 1, height = 1},
	suspicionValue = 5,
	stackable = true,
	maxStack = 3,
	properties = {
		effect = "sleep",
		duration = 300, -- 5 minutes
	},
}

-- Resource Category
ItemDefinitions.money = {
	id = "money",
	name = "Money",
	category = "Resource",
	gridSize = {width = 1, height = 1},
	suspicionValue = 2,
	stackable = true,
	maxStack = 9999,
	properties = {
		currency = true,
	},
}

-- Contraband Category
ItemDefinitions.shiv = {
	id = "shiv",
	name = "Shiv",
	category = "Contraband",
	gridSize = {width = 1, height = 1},
	suspicionValue = 15, -- Very high
	properties = {
		weaponType = "melee",
		damage = 10,
	},
}

return ItemDefinitions
