-- GameSettings.luau
-- Game-wide configuration and settings

return {
	-- Player Configuration
	MAX_PLAYERS = 12,
	MIN_PLAYERS = 1,
	PLAYER_JOIN_WAIT_TIME = 10, -- Seconds to wait after first player joins
	
	-- Cell Configuration
	CELL_COUNT = 24, -- Total cells available
	CELL_ASSIGNMENT_RANGE = 1, -- Distance for cell assignment check
	
	-- Time Configuration
	GAME_TIME_SCALE = 1/10, -- 1 game hour = 10 real minutes
	DAY_DURATION_MINUTES = 1440, -- 24 hours game time
	LOCKDOWN_TIME_START = 22, -- 10 PM game time
	LOCKDOWN_TIME_END = 6, -- 6 AM game time
	
	-- Suspicion Configuration
	SUSPICION_MAX = 100,
	SUSPICION_DECAY_RATE = 0.1, -- Per game hour
	SUSPICION_DECAY_COOLDOWN = 3600, -- Seconds between decay ticks
	
	-- Location Frequency Thresholds
	LOCATION_VISIT_SUSPICIOUS_COUNT = 3, -- Visit same location 3+ times per day = suspicious
	
	-- Inventory Configuration
	INVENTORY_GRID_WIDTH = 10,
	INVENTORY_GRID_HEIGHT = 10,
	
	-- Solitary Configuration
	SOLITARY_DURATION_MINUTES = 60, -- 1 hour game time
	AUTOMATIC_SOLITARY_TRIGGERS = {
		NOT_IN_CELL_ON_TIME = true,
		DISOBEY_GUARD_ORDER = true,
	},
	
	-- Reporting Configuration
	FALSE_REPORT_PENALTY = "solitary", -- Send to solitary for false reports
	SUCCESSFUL_REPORT_REWARD = 10, -- Money reward
	
	-- Trading Configuration
	COMMON_BOARD_ENABLED = true,
	RECEIPTS_VISIBLE_TO_ALL = true,
	ITEM_TRACKING_ENABLED = true,
	
	-- Camera Configuration
	CAMERA_DETECTION_RANGE = 50, -- Studs
	CAMERA_CHECK_INTERVAL = 5, -- Seconds
	
	-- Warden Configuration
	WARDEN_TASK_CHECK_INTERVAL = 300, -- 5 minutes real time
	WARDEN_PATTERN_ANALYSIS_INTERVAL = 600, -- 10 minutes real time
	
	-- NPC Configuration
	NPC_FILL_EMPTY_SLOTS = true,
	NPC_DIFFICULTY_SOLO_MODE = {
		MIN = 30,
		MAX = 70,
	},
	
	-- Escape Configuration
	MULTIPLE_METHODS_ALLOWED = true,
	ESCAPE_WIN_CONDITION = "first_to_escape", -- "first_to_escape" or "all_team_escape"
	
	-- Game Mode Defaults
	DEFAULT_GAME_MODE = "FreeForAll",
	
	-- Balance Configuration
	TASK_PAY_SCALE = {
		-- Less suspicious = higher pay multiplier
		LOW_SUSPICION_MULTIPLIER = 1.5, -- High pay for low suspicion
		MEDIUM_SUSPICION_MULTIPLIER = 1.0, -- Normal pay
		HIGH_SUSPICION_MULTIPLIER = 0.7, -- Lower pay for high suspicion
	},
}
