-- Centralized Game State management for players, economy, bases, and locks

local Players = game:GetService("Players")
local Remotes = require(game:GetService("ReplicatedStorage"):WaitForChild("Remotes"))

local GameState = {}
GameState.PlayersData = {}

local START_CASH = 100

function GameState.initPlayer(player)
	GameState.PlayersData[player.UserId] = {
		cash = START_CASH,
		rebirths = 0,
		slots = { nil, nil, nil, nil, nil, nil }, -- 6 base slots
		isLocked = false,
		lastLockTime = 0,
		heldBrainrot = nil,
		baseIndex = 1,
	}
}

function GameState.removePlayer(player)
	GameState.PlayersData[player.UserId] = nil
end

function GameState.getData(player)
	return GameState.PlayersData[player.UserId]
end

function GameState.getRebirthCost(rebirthCount)
	return 10000 * (5 ^ rebirthCount)
end

function GameState.getTotalIncome(player)
	local data = GameState.getData(player)
	if not data then return 0 end
	local total = 0
	for _, item in ipairs(data.slots) do
		if item then
			total += item.income
		end
	end
	-- Rebirth multiplier: +100% (2x, 3x, etc.) per rebirth
	local multiplier = 1 + data.rebirths
	return math.floor(total * multiplier)
end

function GameState.syncAll()
	local summary = {}
	for _, player in ipairs(Players:GetPlayers()) do
		local data = GameState.getData(player)
		if data then
			summary[tostring(player.UserId)] = {
				name = player.Name,
				cash = data.cash,
				rebirths = data.rebirths,
				income = GameState.getTotalIncome(player),
				slots = data.slots,
				isLocked = data.isLocked,
				heldBrainrot = data.heldBrainrot,
				baseIndex = data.baseIndex,
			}
		end
	end
	Remotes.GameStateSync:FireAllClients(summary)
end

return GameState
