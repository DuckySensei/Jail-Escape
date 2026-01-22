-- init.server.luau
-- Server entry point

local GameManager = require(script.managers.GameManager)

-- Initialize game
local gameManager = GameManager.new()
gameManager:Initialize()

print("Jail Escape: Server initialized")
