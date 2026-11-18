-- Server Entrypoint for Brainrot Battlegrounds

local Players = game:GetService("Players")

local WorldBuilder = require(script.Parent:WaitForChild("WorldBuilder"))
local GameState = require(script.Parent:WaitForChild("GameState"))
local Conveyor = require(script.Parent:WaitForChild("Conveyor"))
local Economy = require(script.Parent:WaitForChild("Economy"))
local Steal = require(script.Parent:WaitForChild("Steal"))
local Tsunami = require(script.Parent:WaitForChild("Tsunami"))
local Leaderboard = require(script.Parent:WaitForChild("Leaderboard"))

print("Initializing Brainrot Battlegrounds Server...")

WorldBuilder.build()

Players.PlayerAdded:Connect(function(player)
	GameState.initPlayer(player)
	GameState.syncAll()

	player.CharacterAdded:Connect(function(character)
		-- Optional character spawn handling
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	GameState.removePlayer(player)
	GameState.syncAll()
end)

-- Initialize modules
Conveyor.init()
Economy.init()
Steal.init()
Tsunami.init()
Leaderboard.init()

print("Brainrot Battlegrounds Server fully initialized!")
