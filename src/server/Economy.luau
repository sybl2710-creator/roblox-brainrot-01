-- Economy: handles income ticks every second, selling brainrots (50% refund), and rebirths

local Players = game:GetService("Players")
local GameState = require(script.Parent:WaitForChild("GameState"))
local Remotes = require(game:GetService("ReplicatedStorage"):WaitForChild("Remotes"))

local Economy = {}

function Economy.init()
	-- Income Ticker every second
	task.spawn(function()
		while true do
			task.wait(1)
			for _, player in ipairs(Players:GetPlayers()) do
				local data = GameState.getData(player)
				if data then
					local income = GameState.getTotalIncome(player)
					data.cash += income
				end
			end
			GameState.syncAll()
		end
	end)

	-- Sell brainrot (50% refund)
	Remotes.SellBrainrot.OnServerInvoke = function(player, slotIndex)
		local data = GameState.getData(player)
		if not data then return false end
		local item = data.slots[slotIndex]
		if not item then return false end

		local refund = math.floor(item.cost * 0.5)
		data.cash += refund
		data.slots[slotIndex] = nil

		GameState.syncAll()
		return true
	end

	-- Rebirth
	Remotes.Rebirth.OnServerInvoke = function(player)
		local data = GameState.getData(player)
		if not data then return false end

		local cost = GameState.getRebirthCost(data.rebirths)
		if data.cash < cost then
			return false
		end

		data.cash = 100
		data.rebirths += 1
		data.slots = { nil, nil, nil, nil, nil, nil }

		GameState.syncAll()
		return true
	end
end

return Economy
