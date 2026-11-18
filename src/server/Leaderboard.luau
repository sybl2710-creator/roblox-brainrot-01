-- Leaderboard: tracks top cash players

local Players = game:GetService("Players")
local GameState = require(script.Parent:WaitForChild("GameState"))

local Leaderboard = {}

function Leaderboard.getTopPlayers()
	local list = {}
	for _, player in ipairs(Players:GetPlayers()) do
		local data = GameState.getData(player)
		if data then
			table.insert(list, { name = player.Name, cash = data.cash, rebirths = data.rebirths })
		end
	end

	table.sort(list, function(a, b)
		return a.cash > b.cash
	end)

	local top = {}
	for i = 1, math.min(5, #list) do
		table.insert(top, list[i])
	end
	return top
end

function Leaderboard.init()
	-- Leaderboard updates are handled via GameState sync
end

return Leaderboard
