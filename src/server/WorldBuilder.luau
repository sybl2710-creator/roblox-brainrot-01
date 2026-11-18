-- WorldBuilder: procedurally generates arena, conveyor, 8 player bases, and decorations

local Workspace = game:GetService("Workspace")

local WorldBuilder = {}

WorldBuilder.Bases = {}

function WorldBuilder.build()
	local mapFolder = Workspace:FindFirstChild("Map")
	if not mapFolder then
		mapFolder = Instance.new("Folder")
		mapFolder.Name = "Map"
		mapFolder.Parent = Workspace
	end

	-- Arena Floor
	local arena = Instance.new("Part")
	arena.Name = "ArenaFloor"
	arena.Size = Vector3.new(300, 2, 300)
	arena.Position = Vector3.new(0, 0, 0)
	arena.Anchored = true
	arena.Color = Color3.fromRGB(90, 180, 90)
	arena.Material = Enum.Material.Grass
	arena.Parent = mapFolder

	-- Central Conveyor Walkway
	local conveyorTrack = Instance.new("Part")
	conveyorTrack.Name = "ConveyorTrack"
	conveyorTrack.Size = Vector3.new(20, 1, 220)
	conveyorTrack.Position = Vector3.new(0, 1.5, 0)
	conveyorTrack.Anchored = true
	conveyorTrack.Color = Color3.fromRGB(50, 50, 50)
	conveyorTrack.Material = Enum.Material.Metal
	conveyorTrack.Parent = mapFolder

	-- Spawn Pad
	local spawnPad = Instance.new("Part")
	spawnPad.Name = "SpawnPad"
	spawnPad.Size = Vector3.new(30, 1.2, 30)
	spawnPad.Position = Vector3.new(0, 1.6, 0)
	spawnPad.Anchored = true
	spawnPad.Color = Color3.fromRGB(220, 220, 255)
	spawnPad.Material = Enum.Material.Neon
	spawnPad.Parent = mapFolder

	local spawnLocation = Instance.new("SpawnLocation")
	spawnLocation.Name = "GameSpawn"
	spawnLocation.Size = Vector3.new(4, 1, 4)
	spawnLocation.Position = Vector3.new(0, 3, 0)
	spawnLocation.Anchored = true
	spawnLocation.Transparency = 1
	spawnLocation.Parent = mapFolder

	-- 8 Player Base Plots arranged radially
	local radius = 110
	local baseColors = {
		Color3.fromRGB(255, 80, 80),
		Color3.fromRGB(80, 150, 255),
		Color3.fromRGB(80, 255, 80),
		Color3.fromRGB(255, 255, 80),
		Color3.fromRGB(255, 120, 255),
		Color3.fromRGB(80, 255, 255),
		Color3.fromRGB(255, 165, 0),
		Color3.fromRGB(180, 100, 255),
	}

	WorldBuilder.Bases = {}

	for i = 1, 8 do
		local angle = (i - 1) * (2 * math.pi / 8)
		local x = math.cos(angle) * radius
		local z = math.sin(angle) * radius

		local basePad = Instance.new("Part")
		basePad.Name = "BasePad_" .. i
		basePad.Size = Vector3.new(40, 1, 40)
		basePad.Position = Vector3.new(x, 1.5, z)
		basePad.Anchored = true
		basePad.Color = baseColors[i]
		basePad.Material = Enum.Material.SmoothPlastic
		basePad.Parent = mapFolder

		-- Gate / Wall
		local gate = Instance.new("Part")
		gate.Name = "BaseGate_" .. i
		gate.Size = Vector3.new(40, 6, 2)
		gate.Position = Vector3.new(x, 4, z - 18)
		gate.Anchored = true
		gate.Color = baseColors[i]
		gate.Material = Enum.Material.Glass
		gate.Transparency = 0.3
		gate.Parent = mapFolder

		-- 6 Slot markers on base
		local slots = {}
		for s = 1, 6 do
			local sx = x + ((s <= 3) and -10 or 10)
			local sz = z + (((s - 1) % 3 - 1) * 10)
			local slotPart = Instance.new("Part")
			slotPart.Name = "Slot_" .. i .. "_" .. s
			slotPart.Size = Vector3.new(8, 0.5, 8)
			slotPart.Position = Vector3.new(sx, 2.1, sz)
			slotPart.Anchored = true
			slotPart.Color = Color3.fromRGB(200, 200, 200)
			slotPart.Material = Enum.Material.Neon
			slotPart.Parent = mapFolder
			table.insert(slots, slotPart.Position)
		end

		table.insert(WorldBuilder.Bases, {
			index = i,
			center = basePad.Position,
			slots = slots,
			color = baseColors[i],
			gate = gate,
		})
	end

	-- Decorations (Fences, Rocks, Trees)
	for i = 1, 20 do
		local angle = math.random() * 2 * math.pi
		local dist = math.random(130, 145)
		local tree = Instance.new("Part")
		tree.Name = "DecorationTree"
		tree.Size = Vector3.new(6, 15, 6)
		tree.Position = Vector3.new(math.cos(angle) * dist, 8.5, math.sin(angle) * dist)
		tree.Anchored = true
		tree.Color = Color3.fromRGB(34, 139, 34)
		tree.Material = Enum.Material.Leafy
		tree.Parent = mapFolder
	end

	print("WorldBuilder generated arena, conveyor, and 8 player bases successfully.")
end

return WorldBuilder
