-- Client UI and Controls for Brainrot Battlegrounds

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage:WaitForChild("Remotes"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotBattlegroundsGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- Top Bar / HUD (Cash & Income)
local hudFrame = Instance.new("Frame")
hudFrame.Size = UDim2.new(0, 400, 0, 70)
hudFrame.Position = UDim2.new(0.5, -200, 0, 10)
hudFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
hudFrame.BorderSizePixel = 0
hudFrame.Parent = gui

local hudCorner = Instance.new("UICorner")
hudCorner.CornerRadius = UDim.new(0, 12)
hudCorner.Parent = hudFrame

local cashLabel = Instance.new("TextLabel")
cashLabel.Size = UDim2.new(1, 0, 0.5, 0)
cashLabel.Position = UDim2.new(0, 0, 0, 0)
cashLabel.BackgroundTransparency = 1
cashLabel.Text = "Cash: $100"
cashLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
cashLabel.TextSize = 22
cashLabel.Font = Enum.Font.SourceSansBold
cashLabel.Parent = hudFrame

local incomeLabel = Instance.new("TextLabel")
incomeLabel.Size = UDim2.new(1, 0, 0.5, 0)
incomeLabel.Position = UDim2.new(0, 0, 0.5, 0)
incomeLabel.BackgroundTransparency = 1
incomeLabel.Text = "Income: $0/s | Rebirths: 0"
incomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
incomeLabel.TextSize = 16
incomeLabel.Font = Enum.Font.SourceSans
incomeLabel.Parent = hudFrame

-- Left Side Panel: Base Slots & Management
local basePanel = Instance.new("ScrollingFrame")
basePanel.Size = UDim2.new(0, 280, 0, 450)
basePanel.Position = UDim2.new(0, 15, 0.2, 0)
basePanel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
basePanel.BorderSizePixel = 0
basePanel.ScrollBarThickness = 6
basePanel.Parent = gui

local baseCorner = Instance.new("UICorner")
baseCorner.CornerRadius = UDim.new(0, 12)
baseCorner.Parent = basePanel

local baseTitle = Instance.new("TextLabel")
baseTitle.Size = UDim2.new(1, 0, 0, 40)
baseTitle.BackgroundTransparency = 1
baseTitle.Text = "YOUR BASE SLOTS"
baseTitle.TextColor3 = Color3.fromRGB(255, 200, 50)
baseTitle.TextSize = 18
baseTitle.Font = Enum.Font.SourceSansBold
baseTitle.Parent = basePanel

-- Right Side Panel: Leaderboard & Tutorial
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0, 260, 0, 350)
rightPanel.Position = UDim2.new(1, -275, 0.2, 0)
rightPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
rightPanel.BorderSizePixel = 0
rightPanel.Parent = gui

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 12)
rightCorner.Parent = rightPanel

local lbTitle = Instance.new("TextLabel")
lbTitle.Size = UDim2.new(1, 0, 0, 40)
lbTitle.BackgroundTransparency = 1
lbTitle.Text = "LEADERBOARD (TOP CASH)"
lbTitle.TextColor3 = Color3.fromRGB(255, 200, 50)
lbTitle.TextSize = 16
lbTitle.Font = Enum.Font.SourceSansBold
lbTitle.Parent = rightPanel

local lbListLabel = Instance.new("TextLabel")
lbListLabel.Size = UDim2.new(1, -20, 1, -50)
lbListLabel.Position = UDim2.new(0, 10, 0, 45)
lbListLabel.BackgroundTransparency = 1
lbListLabel.Text = "Loading leaderboard..."
lbListLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
lbListLabel.TextSize = 14
lbListLabel.TextXAlignment = Enum.TextXAlignment.Left
lbListLabel.TextYAlignment = Enum.TextYAlignment.Top
lbListLabel.Font = Enum.Font.SourceSans
lbListLabel.Parent = rightPanel

-- Bottom Panel: Actions (Lock, Deposit, Slap, Rebirth)
local actionPanel = Instance.new("Frame")
actionPanel.Size = UDim2.new(0, 680, 0, 60)
actionPanel.Position = UDim2.new(0.5, -340, 1, -80)
actionPanel.BackgroundTransparency = 1
actionPanel.Parent = gui

local lockButton = Instance.new("TextButton")
lockButton.Size = UDim2.new(0, 155, 1, 0)
lockButton.Position = UDim2.new(0, 0, 0, 0)
lockButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
lockButton.Text = "LOCK BASE (30s)"
lockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockButton.TextSize = 16
lockButton.Font = Enum.Font.SourceSansBold
lockButton.Parent = actionPanel

local lockCorner = Instance.new("UICorner")
lockCorner.CornerRadius = UDim.new(0, 8)
lockCorner.Parent = lockButton

local depositButton = Instance.new("TextButton")
depositButton.Size = UDim2.new(0, 155, 1, 0)
depositButton.Position = UDim2.new(0, 175, 0, 0)
depositButton.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
depositButton.Text = "DEPOSIT"
depositButton.TextColor3 = Color3.fromRGB(255, 255, 255)
depositButton.TextSize = 16
depositButton.Font = Enum.Font.SourceSansBold
depositButton.Visible = false
depositButton.Parent = actionPanel

local depositCorner = Instance.new("UICorner")
depositCorner.CornerRadius = UDim.new(0, 8)
depositCorner.Parent = depositButton

local slapButton = Instance.new("TextButton")
slapButton.Size = UDim2.new(0, 155, 1, 0)
slapButton.Position = UDim2.new(0, 350, 0, 0)
slapButton.BackgroundColor3 = Color3.fromRGB(220, 120, 50)
slapButton.Text = "SLAP"
slapButton.TextColor3 = Color3.fromRGB(255, 255, 255)
slapButton.TextSize = 16
slapButton.Font = Enum.Font.SourceSansBold
slapButton.Parent = actionPanel

local slapCorner = Instance.new("UICorner")
slapCorner.CornerRadius = UDim.new(0, 8)
slapCorner.Parent = slapButton

local rebirthButton = Instance.new("TextButton")
rebirthButton.Size = UDim2.new(0, 155, 1, 0)
rebirthButton.Position = UDim2.new(0, 525, 0, 0)
rebirthButton.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
rebirthButton.Text = "REBIRTH ($10,000)"
rebirthButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rebirthButton.TextSize = 16
rebirthButton.Font = Enum.Font.SourceSansBold
rebirthButton.Parent = actionPanel

local rebirthCorner = Instance.new("UICorner")
rebirthCorner.CornerRadius = UDim.new(0, 8)
rebirthCorner.Parent = rebirthButton

-- Tsunami Warning Banner
local banner = Instance.new("TextLabel")
banner.Size = UDim2.new(1, 0, 0, 60)
banner.Position = UDim2.new(0, 0, 0.1, 0)
banner.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
banner.BackgroundTransparency = 0.2
banner.Text = ""
banner.TextColor3 = Color3.fromRGB(255, 255, 255)
banner.TextSize = 24
banner.Font = Enum.Font.SourceSansBold
banner.Visible = false
banner.Parent = gui

-- Wire up Action Buttons
lockButton.MouseButton1Click:Connect(function()
	local success, err = Remotes.ToggleLock:InvokeServer()
	if not success and err then
		lockButton.Text = err
		task.wait(2)
	end
end)

depositButton.MouseButton1Click:Connect(function()
	local success, err = Remotes.DepositBrainrot:InvokeServer()
	if not success and err then
		depositButton.Text = err
		task.wait(2)
		depositButton.Text = "DEPOSIT"
	end
end)

slapButton.MouseButton1Click:Connect(function()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local myHrp = char.HumanoidRootPart
	local nearestPlayer = nil
	local minDistance = 12

	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local otherHrp = otherPlayer.Character.HumanoidRootPart
			local dist = (myHrp.Position - otherHrp.Position).Magnitude
			if dist <= minDistance then
				minDistance = dist
				nearestPlayer = otherPlayer
			end
		end
	end

	if nearestPlayer then
		Remotes.SlapPlayer:FireServer(nearestPlayer)
	end
end)

rebirthButton.MouseButton1Click:Connect(function()
	Remotes.Rebirth:InvokeServer()
end)

-- Listen for GameState updates
Remotes.GameStateSync.OnClientEvent:Connect(function(summary)
	local myData = summary[tostring(player.UserId)]
	if not myData then return end

	cashLabel.Text = "Cash: $" .. myData.cash
	incomeLabel.Text = "Income: $" .. myData.income .. "/s | Rebirths: " .. myData.rebirths
	rebirthButton.Text = "REBIRTH ($" .. (10000 * (5 ^ myData.rebirths)) .. ")"
	lockButton.Text = myData.isLocked and "UNLOCK BASE" else "LOCK BASE (30s)"
	depositButton.Visible = (myData.heldBrainrot ~= nil)

	-- Update base slots UI
	for i, item in ipairs(myData.slots) do
		local slotName = "SlotUI_" .. i
		local slotFrame = basePanel:FindFirstChild(slotName)
		if not slotFrame then
			slotFrame = Instance.new("Frame")
			slotFrame.Name = slotName
			slotFrame.Size = UDim2.new(1, -20, 0, 55)
			slotFrame.Position = UDim2.new(0, 10, 0, 45 + (i - 1) * 62)
			slotFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
			slotFrame.BorderSizePixel = 0
			slotFrame.Parent = basePanel

			local sc = Instance.new("UICorner")
			sc.CornerRadius = UDim.new(0, 6)
			sc.Parent = slotFrame

			local infoText = Instance.new("TextLabel")
			infoText.Name = "Info"
			infoText.Size = UDim2.new(0.65, 0, 1, 0)
			infoText.Position = UDim2.new(0, 10, 0, 0)
			infoText.BackgroundTransparency = 1
			infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
			infoText.TextSize = 13
			infoText.TextXAlignment = Enum.TextXAlignment.Left
			infoText.Font = Enum.Font.SourceSansBold
			infoText.Parent = slotFrame

			local sellBtn = Instance.new("TextButton")
			sellBtn.Name = "SellBtn"
			sellBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
			sellBtn.Position = UDim2.new(0.68, 0, 0.15, 0)
			sellBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
			sellBtn.Text = "Sell"
			sellBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			sellBtn.TextSize = 14
			sellBtn.Font = Enum.Font.SourceSansBold
			sellBtn.Parent = slotFrame

			local sbc = Instance.new("UICorner")
			sbc.CornerRadius = UDim.new(0, 4)
			sbc.Parent = sellBtn

			sellBtn.MouseButton1Click:Connect(function()
				Remotes.SellBrainrot:InvokeServer(i)
			end)
		end

		local infoText = slotFrame:FindFirstChild("Info")
		local sellBtn = slotFrame:FindFirstChild("SellBtn")
		if item then
			infoText.Text = item.mutation .. " " .. item.name .. "\n+$" .. item.income .. "/s"
			sellBtn.Visible = true
		else
			infoText.Text = "Slot " .. i .. " (Empty)"
			sellBtn.Visible = false
		end
	end

	-- Update Leaderboard
	local sortedList = {}
	for _, pData in pairs(summary) do
		table.insert(sortedList, pData)
	end
	table.sort(sortedList, function(a, b) return a.cash > b.cash end)

	local lbText = ""
	for idx, pData in ipairs(sortedList) do
		if idx <= 5 then
			lbText ..= idx .. ". " .. pData.name .. " - $" .. pData.cash .. " (R: " .. pData.rebirths .. ")\n"
		end
	end
	lbListLabel.Text = lbText
end)

-- Listen for Tsunami events
Remotes.TsunamiEvent.OnClientEvent:Connect(function(eventType, duration)
	if eventType == "WARNING" then
		banner.Text = "⚠️ TSUNAMI WARNING! GET TO YOUR BASE IN " .. duration .. "s! ⚠️"
		banner.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
		banner.Visible = true
	elseif eventType == "SWEEP" then
		banner.Text = "🌊 TSUNAMI WAVE SWEEPING THE MAP! 🌊"
		banner.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
		banner.Visible = true
		task.wait(5)
		banner.Visible = false
	end
end)

print("Brainrot Battlegrounds Client UI initialized.")
