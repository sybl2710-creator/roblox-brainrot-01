-- Steal & Lock system: picking up from unsecured bases, base locks, slapping, and depositing

local Players = game:GetService("Players")
local GameState = require(script.Parent:WaitForChild("GameState"))
local WorldBuilder = require(script.Parent:WaitForChild("WorldBuilder"))
local Remotes = require(game:GetService("ReplicatedStorage"):WaitForChild("Remotes"))

local Steal = {}

function Steal.init()
	-- Toggle Base Lock
	Remotes.ToggleLock.OnServerInvoke = function(player)
		local data = GameState.getData(player)
		if not data then return false end

		local now = os.time()
		if data.isLocked then
			-- Unlock
			data.isLocked = false
			data.lastLockTime = now
		else
			-- Check cooldown (60s cooldown after lock ends/starts)
			if now - data.lastLockTime < 60 then
				return false, "Lock on cooldown!"
			end
			data.isLocked = true
			data.lastLockTime = now

			-- Auto unlock after 30 seconds
			task.spawn(function()
				task.wait(30)
				if data.isLocked then
					data.isLocked = false
					GameState.syncAll()
				end
			end)
		end

		GameState.syncAll()
		return true
	end

	-- Pickup brainrot from target player's base slot
	Remotes.PickupBrainrot.OnServerInvoke = function(player, targetUserId, slotIndex)
		local thiefData = GameState.getData(player)
		if not thiefData then return false, "No data" end
		if thiefData.heldBrainrot then return false, "Already carrying a brainrot!" end

		local targetPlayer = Players:GetPlayerByUserId(targetUserId)
		if not targetPlayer then return false, "Player not found" end
		if targetPlayer == player then return false, "Cannot steal from yourself!" end

		local targetData = GameState.getData(targetPlayer)
		if not targetData then return false, "Target data not found" end

		if targetData.isLocked then
			return false, "Base is locked!"
		end

		local item = targetData.slots[slotIndex]
		if not item then return false, "Slot is empty!" end

		-- Remove from target and set as held by thief
		targetData.slots[slotIndex] = nil
		thiefData.heldBrainrot = item

		GameState.syncAll()
		return true
	end

	-- Deposit held brainrot into own base slot
	Remotes.DepositBrainrot.OnServerInvoke = function(player)
		local data = GameState.getData(player)
		if not data then return false, "No data" end
		if not data.heldBrainrot then return false, "Not carrying a brainrot!" end

		-- Find free slot
		local freeSlotIndex = nil
		for i, slot in ipairs(data.slots) do
			if not slot then
				freeSlotIndex = i
				break
			end
		end

		if not freeSlotIndex then
			return false, "Base slots are full!"
		end

		data.slots[freeSlotIndex] = data.heldBrainrot
		data.heldBrainrot = nil

		GameState.syncAll()
		return true
	end

	-- Slap player (if holding brainrot, drop it)
	Remotes.SlapPlayer.OnServerEvent:Connect(function(slapper, targetPlayer)
		if not targetPlayer or not targetPlayer:IsA("Player") then return end
		local targetData = GameState.getData(targetPlayer)
		if targetData and targetData.heldBrainrot then
			-- Drop held brainrot
			targetData.heldBrainrot = nil
			GameState.syncAll()
		end
	end)
end

return Steal
