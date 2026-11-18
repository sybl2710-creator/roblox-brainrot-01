-- Remotes definition for client-server communication

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = {}

local folder = ReplicatedStorage:FindFirstChild("Remotes")
if not folder then
	folder = Instance.new("Folder")
	folder.Name = "Remotes"
	folder.Parent = ReplicatedStorage
end

local function getOrCreate(className, name)
	local remote = folder:FindFirstChild(name)
	if not remote then
		remote = Instance.new(className)
		remote.Name = name
		remote.Parent = folder
	end
	return remote
end

Remotes.BuyBrainrot = getOrCreate("RemoteFunction", "BuyBrainrot")
Remotes.SellBrainrot = getOrCreate("RemoteFunction", "SellBrainrot")
Remotes.Rebirth = getOrCreate("RemoteFunction", "Rebirth")
Remotes.ToggleLock = getOrCreate("RemoteFunction", "ToggleLock")
Remotes.PickupBrainrot = getOrCreate("RemoteFunction", "PickupBrainrot")
Remotes.DepositBrainrot = getOrCreate("RemoteFunction", "DepositBrainrot")
Remotes.SlapPlayer = getOrCreate("RemoteEvent", "SlapPlayer")
Remotes.GameStateSync = getOrCreate("RemoteEvent", "GameStateSync")
Remotes.TsunamiEvent = getOrCreate("RemoteEvent", "TsunamiEvent")

return Remotes
