-- EventBus.luau
-- Central event bus for inter-system communication
-- Supports both BindableEvents (server-only) and RemoteEvents (client-server)

local EventBus = {}
EventBus.__index = EventBus

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create shared events folder if it doesn't exist
local function getEventsFolder()
	local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
	if not eventsFolder then
		eventsFolder = Instance.new("Folder")
		eventsFolder.Name = "Events"
		eventsFolder.Parent = ReplicatedStorage
	end
	return eventsFolder
end

-- Create shared bindable events folder for server-only events
local function getBindableEventsFolder()
	local folder = ReplicatedStorage:FindFirstChild("BindableEvents")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "BindableEvents"
		folder.Parent = ReplicatedStorage
	end
	return folder
end

function EventBus.new()
	local self = setmetatable({}, EventBus)
	self._remoteEvents = {}
	self._bindableEvents = {}
	self._eventGroups = {}
	return self
end

-- Create a RemoteEvent (for client-server communication)
function EventBus:CreateRemoteEvent(eventName: string): RemoteEvent
	if self._remoteEvents[eventName] then
		return self._remoteEvents[eventName]
	end
	
	local eventsFolder = getEventsFolder()
	local event = eventsFolder:FindFirstChild(eventName)
	
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = eventName
		event.Parent = eventsFolder
	end
	
	self._remoteEvents[eventName] = event
	return event
end

-- Create a BindableEvent (for server-only communication)
function EventBus:CreateBindableEvent(eventName: string): BindableEvent
	if self._bindableEvents[eventName] then
		return self._bindableEvents[eventName]
	end
	
	local folder = getBindableEventsFolder()
	local event = folder:FindFirstChild(eventName)
	
	if not event then
		event = Instance.new("BindableEvent")
		event.Name = eventName
		event.Parent = folder
	end
	
	self._bindableEvents[eventName] = event
	return event
end

-- Create an event group (multiple related events)
function EventBus:CreateEventGroup(groupName: string, eventNames: {string}): {[string]: RemoteEvent | BindableEvent}
	if self._eventGroups[groupName] then
		return self._eventGroups[groupName]
	end
	
	local group = {}
	for _, eventName in ipairs(eventNames) do
		group[eventName] = self:CreateRemoteEvent(groupName .. "_" .. eventName)
	end
	
	self._eventGroups[groupName] = group
	return group
end

-- Get an existing RemoteEvent
function EventBus:GetRemoteEvent(eventName: string): RemoteEvent?
	local eventsFolder = getEventsFolder()
	return eventsFolder:FindFirstChild(eventName) :: RemoteEvent
end

-- Get an existing BindableEvent
function EventBus:GetBindableEvent(eventName: string): BindableEvent?
	local folder = getBindableEventsFolder()
	return folder:FindFirstChild(eventName) :: BindableEvent
end

-- Fire a RemoteEvent (from server to client or vice versa)
function EventBus:FireRemoteEvent(eventName: string, ...)
	local event = self:GetRemoteEvent(eventName)
	if event then
		event:FireAllClients(...)
	else
		warn("EventBus: RemoteEvent not found:", eventName)
	end
end

-- Fire a RemoteEvent to a specific client
function EventBus:FireRemoteEventToClient(player: Player, eventName: string, ...)
	local event = self:GetRemoteEvent(eventName)
	if event then
		event:FireClient(player, ...)
	else
		warn("EventBus: RemoteEvent not found:", eventName)
	end
end

-- Fire a BindableEvent (server-only)
function EventBus:FireBindableEvent(eventName: string, ...)
	local event = self:GetBindableEvent(eventName)
	if event then
		event:Fire(...)
	else
		warn("EventBus: BindableEvent not found:", eventName)
	end
end

-- Connect to a RemoteEvent (server-side)
function EventBus:ConnectRemoteEvent(eventName: string, callback: (...any) -> ())
	local event = self:GetRemoteEvent(eventName)
	if event then
		return event.OnServerEvent:Connect(callback)
	else
		warn("EventBus: RemoteEvent not found:", eventName)
		return nil
	end
end

-- Connect to a RemoteEvent (client-side)
function EventBus:ConnectRemoteEventClient(eventName: string, callback: (...any) -> ())
	local event = self:GetRemoteEvent(eventName)
	if event then
		return event.OnClientEvent:Connect(callback)
	else
		warn("EventBus: RemoteEvent not found:", eventName)
		return nil
	end
end

-- Connect to a BindableEvent
function EventBus:ConnectBindableEvent(eventName: string, callback: (...any) -> ())
	local event = self:GetBindableEvent(eventName)
	if event then
		return event.Event:Connect(callback)
	else
		warn("EventBus: BindableEvent not found:", eventName)
		return nil
	end
end

return EventBus
