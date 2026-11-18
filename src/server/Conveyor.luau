-- Conveyor: spawns and moves brainrot characters along the central conveyor walkway

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local BrainrotData = require(script.Parent:WaitForChild("BrainrotData"))
local GameState = require(script.Parent:WaitForChild("GameState"))
local WorldBuilder = require(script.Parent:WaitForChild("WorldBuilder"))
local Remotes = require(game:GetService("ReplicatedStorage"):WaitForChild("Remotes"))

local Conveyor = {}
Conveyor.ActiveConveyorItems = {}

local START_Z = -110
local END_Z = 110
local SPEED = 8 -- studs per second

function Conveyor.spawnItem()
	local itemData = BrainrotData.getRandomBrainrot()
	local model = Instance.new("Model")
	model.Name = itemData.name .. "_" .. itemData.id

	local part = Instance.new("Part")
	part.Name = "Body"
	part.Size = Vector3.new(4, 4, 4)
	part.Position = Vector3.new(0, 4, START_Z)
	part.Anchored = false
	part.CanCollide = true
	part.Color = itemData.color
	part.Material = Enum.Material.SmoothPlastic
	part.Parent = model

	-- BillboardGui label showing name, rarity, and $/s
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 160, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = part

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.fromScale(1, 1)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = itemData.mutation .. " " .. itemData.name .. "\n$" .. itemData.income .. "/s (Cost: $" .. itemData.cost .. ")"
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextStrokeTransparency = 0
	textLabel.TextSize = 14
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.Parent = billboard

	-- ClickDetector for buying directly by clicking in 3D
	local clickDetector = Instance.new("ClickDetector")
	clickDetector.MaxActivationDistance = 32
	clickDetector.Parent = part

	clickDetector.MouseClick:Connect(function(player)
		Conveyor.tryBuyItem(player, itemData, model)
	end)

	model.Parent = Workspace

	local itemRecord = {
		id = itemData.id,
		data = itemData,
		model = model,
		part = part,
		z = START_Z,
	}

	table.insert(Conveyor.ActiveConveyorItems, itemRecord)
end

function Conveyor.tryBuyItem(player, itemData, model)
	local data = GameState.getData(player)
	if not data then return false end

	if data.cash < itemData.cost then
		return false
	end

	-- Find free slot
	local freeSlotIndex = nil
	for i, slot in ipairs(data.slots) do
		if not slot then
			freeSlotIndex = i
			break
		end
	end

	if not freeSlotIndex then
		return false -- Base full
	end

	data.cash -= itemData.cost
	data.slots[freeSlotIndex] = itemData

	-- Remove from conveyor
	model:Destroy()
	for i, record in ipairs(Conveyor.ActiveConveyorItems) do
		if record.data.id == itemData.id then
			table.remove(Conveyor.ActiveConveyorItems, i)
			break
		end
	end

	GameState.syncAll()
	return true
end

function Conveyor.init()
	-- Spawn loop task
	task.spawn(function()
		while true do
			task.wait(4)
			if #Conveyor.ActiveConveyorItems < 8 then
				Conveyor.spawnItem()
			end
		end
	end)

	-- Movement update loop
	RunService.Heartbeat:Connect(function(dt)
		for i = #Conveyor.ActiveConveyorItems, 1, -1 do
			local record = Conveyor.ActiveConveyorItems[i]
			record.z += SPEED * dt
			if record.part and record.part.Parent then
				record.part.Position = Vector3.new(0, 4, record.z)
			end
			if record.z > END_Z then
				if record.model then
					record.model:Destroy()
				end
				table.remove(Conveyor.ActiveConveyorItems, i)
			end
		end
	end)

	-- Wire up RemoteFunction for buying from UI
	Remotes.BuyBrainrot.OnServerInvoke = function(player, itemId)
		for _, record in ipairs(Conveyor.ActiveConveyorItems) do
			if record.data.id == itemId then
				return Conveyor.tryBuyItem(player, record.data, record.model)
			end
		end
		return false
	end
end

return Conveyor
