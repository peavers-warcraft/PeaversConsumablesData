local addonName, addonTable = ...
addonTable.WowheadDB = addonTable.WowheadDB or {}

local consumablesData = {
	updated = "2026-07-03 00:00:00",

	[5] = {
		specs = {
			[256] = {
				["enchants"] = {
					{
						slot = "Weapon",
						itemID = 243973,
						itemName = "Enchant Weapon - Berserker's Rage",
						quality = 3,
						priority = 1,
					},
					{
						slot = "Shoulders",
						itemID = 244021,
						itemName = "Enchant Shoulders - Silvermoon's Mending",
						quality = 3,
						priority = 1,
					},
					{
						slot = "Chest",
						itemID = 243977,
						itemName = "Enchant Chest - Mark of the Worldsoul",
						quality = 3,
						priority = 1,
					},
					{
						slot = "Helm",
						itemID = 243951,
						itemName = "Enchant Helm - Empowered Hex of Leeching",
						quality = 3,
						priority = 1,
					},
					{
						slot = "Legs",
						itemID = 240133,
						itemName = "Sunfire Silk Spellthread",
						quality = 4,
						priority = 1,
					},
					{
						slot = "Boots",
						itemID = 243983,
						itemName = "Enchant Boots - Shaladrassil's Roots",
						quality = 3,
						priority = 1,
					},
					{
						slot = "Ring",
						itemID = 244015,
						itemName = "Enchant Ring - Silvermoon's Alacrity",
						quality = 3,
						priority = 1,
					},
				},
				["gems"] = {
					{
						slot = "Diamond",
						itemID = 240983,
						itemName = "Indecipherable Eversong Diamond",
						quality = 4,
						priority = 1,
					},
					{
						slot = "Other Gems",
						itemID = 240890,
						itemName = "Flawless Deadly Peridot",
						quality = 3,
						priority = 1,
					},
				},
				["flasks"] = {
					{
						slot = "Flask",
						itemID = 241324,
						itemName = "Flask of the Blood Knights",
						quality = 1,
						priority = 1,
					},
				},
				["potions"] = {
					{
						slot = "Combat Potion",
						itemID = 241300,
						itemName = "Lightfused Mana Potion",
						quality = 1,
						priority = 1,
					},
					{
						slot = "Combat Potion",
						itemID = 241308,
						itemName = "Light's Potential",
						quality = 1,
						priority = 2,
					},
					{
						slot = "Health Potion",
						itemID = 241304,
						itemName = "Silvermoon Health Potion",
						quality = 1,
						priority = 1,
					},
				},
				["oils"] = {
					{
						slot = "Weapon Buff",
						itemID = 243734,
						itemName = "Thalassian Phoenix Oil",
						quality = 2,
						priority = 1,
					},
				},
				["runes"] = {
					{
						slot = "Augment Rune",
						itemID = 259085,
						itemName = "Void-Touched Augment Rune",
						quality = 3,
						priority = 1,
					},
				},
				["food"] = {
					{
						slot = "Food",
						itemID = 255846,
						itemName = "Harandar Celebration",
						quality = 3,
						priority = 1,
					},
				},
			},
		},
	},
}

addonTable.WowheadDB = consumablesData
