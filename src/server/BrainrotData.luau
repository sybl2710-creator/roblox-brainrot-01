-- Brainrot character definitions and rarity/mutation data

local BrainrotData = {}

BrainrotData.Rarities = {
	Common = { name = "Common", color = Color3.fromRGB(180, 180, 180), weight = 50 },
	Rare = { name = "Rare", color = Color3.fromRGB(50, 150, 255), weight = 25 },
	Epic = { name = "Epic", color = Color3.fromRGB(160, 50, 255), weight = 15 },
	Legendary = { name = "Legendary", color = Color3.fromRGB(255, 200, 0), weight = 7 },
	Mythic = { name = "Mythic", color = Color3.fromRGB(255, 50, 50), weight = 2 },
	BrainrotGod = { name = "Brainrot God", color = Color3.fromRGB(0, 255, 200), weight = 1 },
}

BrainrotData.Cast = {
	{ name = "Noobini Pizzanini", rarity = "Common", cost = 50, income = 5, color = Color3.fromRGB(200, 180, 150) },
	{ name = "Chimpanzini Bananini", rarity = "Common", cost = 75, income = 8, color = Color3.fromRGB(180, 140, 100) },
	{ name = "Tung Tung Tung Sahur", rarity = "Rare", cost = 250, income = 25, color = Color3.fromRGB(100, 180, 255) },
	{ name = "Tralalero Tralala", rarity = "Rare", cost = 400, income = 40, color = Color3.fromRGB(80, 200, 220) },
	{ name = "Bombardiro Crocodilo", rarity = "Epic", cost = 1200, income = 120, color = Color3.fromRGB(140, 60, 220) },
	{ name = "Lirili Larila", rarity = "Epic", cost = 1500, income = 150, color = Color3.fromRGB(180, 50, 255) },
	{ name = "Cappuccino Assassino", rarity = "Legendary", cost = 4000, income = 400, color = Color3.fromRGB(255, 210, 50) },
	{ name = "Ballerina Cappuccina", rarity = "Legendary", cost = 5000, income = 500, color = Color3.fromRGB(255, 180, 80) },
	{ name = "La Grande Combinazione", rarity = "Mythic", cost = 15000, income = 1500, color = Color3.fromRGB(255, 60, 60) },
	{ name = "Garamararamaraman", rarity = "BrainrotGod", cost = 50000, income = 5000, color = Color3.fromRGB(0, 255, 220) },
}

BrainrotData.Mutations = {
	{ name = "Normal", multiplier = 1, chance = 0.86, colorFactor = Color3.new(1, 1, 1) },
	{ name = "Golden", multiplier = 2, chance = 0.10, colorFactor = Color3.fromRGB(255, 220, 50) },
	{ name = "Diamond", multiplier = 5, chance = 0.03, colorFactor = Color3.fromRGB(100, 220, 255) },
	{ name = "Rainbow", multiplier = 10, chance = 0.01, colorFactor = Color3.fromRGB(255, 100, 255) },
}

function BrainrotData.getRandomBrainrot()
	local totalWeight = 0
	for _, r in pairs(BrainrotData.Rarities) do
		totalWeight += r.weight
	end
	local roll = math.random(1, totalWeight)
	local currentWeight = 0
	local selectedRarity = "Common"
	for name, r in pairs(BrainrotData.Rarities) do
		currentWeight += r.weight
		if roll <= currentWeight then
			selectedRarity = name
			break
		end
	end

	local pool = {}
	for _, b in ipairs(BrainrotData.Cast) do
		if b.rarity == selectedRarity then
			table.insert(pool, b)
		end
	end
	if #pool == 0 then
		pool = BrainrotData.Cast
	end
	local baseItem = pool[math.random(1, #pool)]

	-- Roll mutation
	local mutRoll = math.random()
	local cumulative = 0
	local mutation = BrainrotData.Mutations[1]
	for _, m in ipairs(BrainrotData.Mutations) do
		cumulative += m.chance
		if mutRoll <= cumulative then
			mutation = m
			break
		end
	end

	return {
		id = tostring(math.random(100000, 999999)),
		name = baseItem.name,
		rarity = baseItem.rarity,
		cost = baseItem.cost,
		income = math.floor(baseItem.income * mutation.multiplier),
		baseIncome = baseItem.income,
		color = baseItem.color,
		mutation = mutation.name,
		multiplier = mutation.multiplier,
	}
end

return BrainrotData
