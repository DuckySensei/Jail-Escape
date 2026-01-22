-- Tasks.luau
-- Task definitions for the game
-- Pay scale: Less suspicious = Higher pay

local Tasks = {}

-- Labor Tasks (Low suspicion, Low-Medium pay)
Tasks.kitchenPrep = {
	id = "kitchenPrep",
	name = "Kitchen Prep",
	category = "Labor",
	suspicionLevel = 5, -- Low
	pay = 8, -- Higher pay for low suspicion
	timeRequired = 30, -- Game minutes
	description = "Help prepare meals in the kitchen",
	requirements = nil,
}

Tasks.bathroomCleaning = {
	id = "bathroomCleaning",
	name = "Bathroom Cleaning",
	category = "Labor",
	suspicionLevel = 15, -- Higher suspicion (unpleasant work)
	pay = 3, -- Lower pay for higher suspicion
	timeRequired = 20, -- Game minutes
	description = "Clean the bathrooms",
	requirements = nil,
}

Tasks.laundryDuty = {
	id = "laundryDuty",
	name = "Laundry Duty",
	category = "Labor",
	suspicionLevel = 5,
	pay = 7,
	timeRequired = 45,
	description = "Sort and fold laundry",
	requirements = nil,
}

Tasks.maintenanceWork = {
	id = "maintenanceWork",
	name = "Maintenance Work",
	category = "Labor",
	suspicionLevel = 8,
	pay = 10,
	timeRequired = 60,
	description = "General maintenance and repairs",
	requirements = nil,
}

-- Skilled Tasks (Medium suspicion, Higher pay)
Tasks.woodWorking = {
	id = "woodWorking",
	name = "Wood Working",
	category = "Skilled",
	suspicionLevel = 10, -- Low suspicion (legitimate skilled work)
	pay = 20, -- High pay for low suspicion
	timeRequired = 90,
	description = "Craft items in the wood shop",
	requirements = nil,
}

Tasks.libraryOrganization = {
	id = "libraryOrganization",
	name = "Library Organization",
	category = "Skilled",
	suspicionLevel = 15,
	pay = 12,
	timeRequired = 40,
	description = "Organize books in the library",
	requirements = nil,
}

Tasks.educationTutoring = {
	id = "educationTutoring",
	name = "Education Tutoring",
	category = "Skilled",
	suspicionLevel = 12,
	pay = 15,
	timeRequired = 50,
	description = "Tutor other inmates in educational programs",
	requirements = nil,
}

Tasks.administrativeFiling = {
	id = "administrativeFiling",
	name = "Administrative Filing",
	category = "Skilled",
	suspicionLevel = 18, -- Medium-high (access to admin areas)
	pay = 10,
	timeRequired = 35,
	description = "File paperwork in administrative office",
	requirements = nil,
}

-- Illegal Tasks (On job board, High suspicion, Good pay)
Tasks.contrabandSmuggling = {
	id = "contrabandSmuggling",
	name = "Contraband Smuggling",
	category = "Illegal",
	suspicionLevel = 40, -- High suspicion
	pay = 25, -- Good pay but high risk
	timeRequired = 20,
	description = "Smuggle contraband into the prison",
	requirements = nil,
}

Tasks.informationGathering = {
	id = "informationGathering",
	name = "Information Gathering",
	category = "Illegal",
	suspicionLevel = 35,
	pay = 20,
	timeRequired = 30,
	description = "Gather information about guard schedules",
	requirements = nil,
}

Tasks.itemTheft = {
	id = "itemTheft",
	name = "Item Theft",
	category = "Illegal",
	suspicionLevel = 45,
	pay = 22,
	timeRequired = 25,
	description = "Steal items from other inmates or guards",
	requirements = nil,
}

-- Super Illegal Tasks (Gang members only, Very high suspicion, Very good pay)
Tasks.assaultOrder = {
	id = "assaultOrder",
	name = "Assault Order",
	category = "SuperIllegal",
	suspicionLevel = 60, -- Very high
	pay = 50, -- Very good pay
	timeRequired = 15,
	description = "Cause a distraction through assault (gang members only)",
	requirements = {
		{type = "Prerequisite", value = "gangMember"},
	},
}

Tasks.distractionCreation = {
	id = "distractionCreation",
	name = "Create Distraction",
	category = "SuperIllegal",
	suspicionLevel = 55,
	pay = 40,
	timeRequired = 15,
	description = "Create a major distraction (gang members only)",
	requirements = {
		{type = "Prerequisite", value = "gangMember"},
	},
}

-- Rehabilitation Tasks (Low suspicion, Low pay, Reduces suspicion)
Tasks.groupTherapy = {
	id = "groupTherapy",
	name = "Group Therapy",
	category = "Rehabilitation",
	suspicionLevel = 0, -- No suspicion
	pay = 3, -- Low pay
	timeRequired = 60,
	description = "Attend group therapy session",
	properties = {
		suspicionReduction = 5, -- Reduces suspicion by 5
	},
	requirements = nil,
}

Tasks.educationalCourse = {
	id = "educationalCourse",
	name = "Educational Course",
	category = "Rehabilitation",
	suspicionLevel = 0,
	pay = 5,
	timeRequired = 90,
	description = "Take an educational course",
	properties = {
		suspicionReduction = 8,
	},
	requirements = nil,
}

Tasks.communityService = {
	id = "communityService",
	name = "Community Service",
	category = "Rehabilitation",
	suspicionLevel = 0,
	pay = 8,
	timeRequired = 120,
	description = "Perform community service work",
	properties = {
		suspicionReduction = 10,
	},
	requirements = nil,
}

Tasks.behaviorModification = {
	id = "behaviorModification",
	name = "Behavior Modification",
	category = "Rehabilitation",
	suspicionLevel = 0,
	pay = 2,
	timeRequired = 45,
	description = "Attend behavior modification class",
	properties = {
		suspicionReduction = 3,
	},
	requirements = nil,
}

return Tasks
