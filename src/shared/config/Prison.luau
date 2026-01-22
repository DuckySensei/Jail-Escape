-- Prison.luau
-- Prison layout configuration
-- This is the default prison. More prisons can be added later.

return {
	id = "default",
	name = "Default Prison",
	description = "Standard maximum-security prison",
	
	-- Cell Block Configuration
	cellBlock = {
		totalCells = 24,
		cellsPerRow = 6,
		cellSize = {width = 4, height = 8, depth = 6},
		-- Cell positions will be defined in workspace placement
	},
	
	-- Common Areas
	commonAreas = {
		cafeteria = {
			name = "Cafeteria",
			-- Position will be defined in workspace
			capacity = 12,
		},
		yard = {
			name = "Yard",
			capacity = 20,
		},
		library = {
			name = "Library",
			capacity = 8,
		},
		gym = {
			name = "Gym",
			capacity = 10,
		},
		commonCell = {
			name = "Common Cell",
			description = "Trading board location",
			capacity = 15,
		},
	},
	
	-- Administrative Areas
	administrativeAreas = {
		wardenOffice = {
			name = "Warden's Office",
			-- Position will be defined in workspace
		},
		guardStation = {
			name = "Guard Station",
			-- Multiple guard stations
		},
		securityRoom = {
			name = "Security Room",
			description = "Camera monitoring center",
		},
	},
	
	-- Service Areas
	serviceAreas = {
		kitchen = {
			name = "Kitchen",
		},
		laundry = {
			name = "Laundry",
		},
		maintenance = {
			name = "Maintenance",
		},
	},
	
	-- Perimeter
	perimeter = {
		fence = {
			description = "Perimeter fence with weak points",
			weakPoints = 3, -- Number of potential weak points
		},
		mainGate = {
			name = "Main Gate",
			description = "Main entrance/exit",
		},
		guardTowers = {
			count = 4,
		},
	},
	
	-- Restricted Areas
	restrictedAreas = {
		solitaryConfinement = {
			name = "Solitary Confinement",
			cellCount = 4,
		},
		medicalBay = {
			name = "Medical Bay",
		},
		armory = {
			name = "Armory",
			description = "Where confiscated items are stored",
		},
	},
	
	-- Task Board Locations
	taskBoards = {
		{
			name = "Main Job Board",
			location = "cafeteria", -- Reference to common area
		},
		{
			name = "Library Job Board",
			location = "library",
		},
		{
			name = "Maintenance Job Board",
			location = "maintenance",
		},
	},
	
	-- Camera Locations
	cameras = {
		{
			location = "cafeteria",
			coverage = 50, -- Studs
		},
		{
			location = "yard",
			coverage = 60,
		},
		{
			location = "perimeter",
			coverage = 100,
		},
		{
			location = "mainGate",
			coverage = 30,
		},
		-- More cameras defined in workspace placement
	},
	
	-- Guard Patrol Routes
	guardPatrolRoutes = {
		{
			name = "Main Perimeter",
			waypoints = {}, -- Defined in workspace
		},
		{
			name = "Cell Block A",
			waypoints = {},
		},
		{
			name = "Cell Block B",
			waypoints = {},
		},
		-- More routes defined in workspace
	},
	
	-- Interactive Elements
	interactiveElements = {
		lockers = {
			description = "Lockers for storing items",
			count = 20,
		},
		vendingMachines = {
			description = "Commissary vending machines",
			count = 5,
		},
		guardStations = {
			description = "Guard stations for reporting",
			count = 3,
		},
	},
}
