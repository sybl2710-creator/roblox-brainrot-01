-- Tsunami event: 3-minute cycle, 30s warning banner, wave sweep, knockback for players outside base

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local GameState = require(script.Parent:WaitForChild("GameState"))
local WorldBuilder = require(script.Parent:WaitForChild("WorldBuilder"))
local Remotes = require(game:GetService("ReplicatedStorage"):WaitForChild("Remotes"))

local Tsunami = {}

function Tsunami.init()
	task.spawn(function()
		while true do
			-- Wait 2.5 minutes before warning (or 150s, so total cycle is 3 mins)
			task.wait(150)

			-- 30s Warning
			Remotes.TsunamiEvent:FireAllClients("WARNING", 30)
			task.wait(30)

			-- Tsunami Wave Sweep
			Remotes.TsunamiEvent:FireAllClients("SWEEP", 5)

			local wavePart = Instance.new("Part")
			wavePart.Name = "TsunamiWave"
			wavePart.Size = Vector3.new(350, 40, 10)
			wavePart.Position = Vector3.new(0, 20, -160)
			wavePart.Anchored = true
			wavePart.CanCollide = false
			wavePart.Color = Color3.fromRGB(50, 150, 255)
			wavePart.Material = Enum.Material.Glass
			wavePart.Transparency = 0.4
			wavePart.Parent = Workspace

			-- Sweep across
			local steps = 50
			for i = 1, steps do
				task.wait(0.1)
				wavePart.Position = Vector3.new(0, 20, -160 + (320 * (i / steps)))

				-- Check players outside bases
				for _, player in ipairs(Players:GetPlayers()) do
					local char = player.Character
					if char and char:FindFirstChild("HumanoidRootPart") then
						local hrp = char.HumanoidRootPart
						local pos = hrp.Position

						-- Check if inside any base plot (radius ~25 studs from base center)
						local insideBase = false
						for _, base in ipairs(WorldBuilder.Bases) do
							if (Vector3.new(pos.X, 0, pos.Z) - Vector3.new(base.center.X, 0, base.center.Z)).Magnitude < 25 then
								insideBase = true
								break
							end
						end

						-- Also safe if near center spawn (< 20 studs)
						if Vector3.new(pos.X, 0, pos.Z).Magnitude < 20 then
							insideBase = true
						end

						if not insideBase then
							-- Knock back to spawn & drop held brainrot
							hrp.Position = Vector3.new(0, 5, 0)
							local data = GameState.getData(player)
							if data then
								data.heldBrainrot = nil
							end
						end
					end
				end
			end

			wavePart:Destroy()
			GameState.syncAll()
		end
	end)
end

return Tsunami
