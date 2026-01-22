-- CameraSystem.luau
-- Security camera monitoring system

local CameraSystem = {}
CameraSystem.__index = CameraSystem

local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local RS = game:GetService("ReplicatedStorage")
local GameSettings = require(RS.Shared.config.GameSettings)

function CameraSystem.new(activityTracker)
	local self = setmetatable({}, CameraSystem)
	self._activityTracker = activityTracker
	self._guardManager = nil -- Set later to avoid circular dependency
	self._cameras = {} -- cameraId -> {instance, location, coverageRange}
	self._checkConnection = nil
	
	-- Find cameras in workspace
	self:FindCameras()
	
	-- Start camera monitoring
	self:StartMonitoring()
	
	return self
end

-- Set guard manager (called after GuardManager is created)
function CameraSystem:SetGuardManager(guardManager)
	self._guardManager = guardManager
end

-- Find cameras in workspace
function CameraSystem:FindCameras()
	local cameras = CollectionService:GetTagged("SecurityCamera")
	
	for _, camera in ipairs(cameras) do
		local cameraId = camera:GetAttribute("CameraId")
		local location = camera:GetAttribute("Location")
		local coverageRange = camera:GetAttribute("CoverageRange") or 50
		
		if cameraId then
			local position = camera:IsA("BasePart") and camera.Position or
			                 (camera:IsA("Model") and camera.PrimaryPart and camera.PrimaryPart.Position) or
			                 camera.Position
			
			self._cameras[cameraId] = {
				instance = camera,
				position = position,
				location = location or "Unknown",
				coverageRange = coverageRange,
			}
		end
	end
	
	print("CameraSystem: Found", #cameras, "security cameras")
end

-- Check if player is in camera range
function CameraSystem:IsPlayerInCameraRange(playerPosition: Vector3, cameraId: string): boolean
	local camera = self._cameras[cameraId]
	if not camera then
		return false
	end
	
	local distance = (playerPosition - camera.position).Magnitude
	return distance <= camera.coverageRange
end

-- Detect suspicious activity on camera
function CameraSystem:DetectSuspiciousActivity(userId: number, playerPosition: Vector3, activityType: string)
	-- Check all cameras
	for cameraId, cameraData in pairs(self._cameras) do
		if self:IsPlayerInCameraRange(playerPosition, cameraId) then
			-- Player detected on camera doing suspicious activity
			print("CameraSystem: Player", userId, "detected on camera", cameraId, "doing", activityType)
			
			-- Log activity
			self._activityTracker:LogActivity(userId, "SuspiciousBehavior", playerPosition, {
				behaviorType = activityType,
				detectedBy = "Camera",
				cameraId = cameraId,
			})
			
			-- Trigger guard investigation
			if self._guardManager then
				-- TODO: Send guard to investigate
				-- self._guardManager:InvestigateLocation(playerPosition, userId)
			end
			
			return true
		end
	end
	
	return false
end

-- Start camera monitoring loop
function CameraSystem:StartMonitoring()
	local checkInterval = GameSettings.CAMERA_CHECK_INTERVAL or 5
	
	self._checkConnection = RunService.Heartbeat:Connect(function()
		-- Camera monitoring happens in real-time when activities occur
		-- This connection can be used for periodic checks if needed
	end)
end

-- Stop camera monitoring
function CameraSystem:StopMonitoring()
	if self._checkConnection then
		self._checkConnection:Disconnect()
		self._checkConnection = nil
	end
end

-- Get all cameras
function CameraSystem:GetAllCameras(): {[string]: any}
	return self._cameras
end

return CameraSystem
