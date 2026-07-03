local addonName, addon = ...

-- Create the global addon table
_G["PeaversConsumablesData"] = _G["PeaversConsumablesData"] or {}
local publicAPI = _G["PeaversConsumablesData"]

-- Create the API namespace
publicAPI.API = publicAPI.API or {}
local API = publicAPI.API

-- Constants for error messages
local ERR_INVALID_CLASS = "Invalid class ID provided"
local ERR_INVALID_SPEC = "Invalid specialization ID provided"
local ERR_INVALID_SOURCE = "Invalid source provided. Valid sources are: 'wowhead'"
local ERR_INVALID_CATEGORY = "Invalid category provided"

-- Provider configuration
local PROVIDERS = {
	wowhead = {
		db = "WowheadDB",
	},
}

-- Category keys in display order
local CATEGORY_ORDER = { "enchants", "gems", "flasks", "potions", "oils", "runes", "food", "misc" }

-- Category key to display name mapping
local CATEGORY_NAMES = {
	enchants = "Enchants",
	gems = "Gems",
	flasks = "Flasks",
	potions = "Potions",
	oils = "Weapon Buffs",
	runes = "Augment Runes",
	food = "Food",
	misc = "Other",
}

---Helper function to validate inputs for API functions
---@param classID number The WoW class ID (1-13)
---@param specID number|nil The specialization ID
---@param category string|nil The consumable category
---@param source string|nil The source of consumable data
---@return boolean isValid Whether the inputs are valid
---@return string|nil errorMsg Error message if validation fails
local function ValidateInputs(classID, specID, category, source)
	if not classID or type(classID) ~= "number" or classID < 1 or classID > 13 then
		return false, ERR_INVALID_CLASS
	end

	if specID and (type(specID) ~= "number" or specID < 1) then
		return false, ERR_INVALID_SPEC
	end

	if category and not CATEGORY_NAMES[category] then
		return false, ERR_INVALID_CATEGORY
	end

	if source and not PROVIDERS[source] then
		return false, ERR_INVALID_SOURCE
	end

	return true, nil
end

---Get the best consumables for a spec in a single category
---@param classID number The WoW class ID (1-13)
---@param specID number The specialization ID
---@param category string Category key ("enchants", "gems", "flasks", "potions", "food", "runes")
---@param source string|nil "wowhead" (default: all sources)
---@return table|nil items Array of consumable item tables
---@return string|nil errorMsg Error message if request fails
function API.GetConsumables(classID, specID, category, source)
	local isValid, errorMsg = ValidateInputs(classID, specID, category, source)
	if not isValid then
		return nil, errorMsg
	end

	local items = {}

	local function ProcessProvider(providerName, config)
		local db = addon[config.db]
		if not db then return end
		if not db[classID] then return end
		if not db[classID].specs then return end
		if not db[classID].specs[specID] then return end
		if not db[classID].specs[specID][category] then return end

		for _, item in ipairs(db[classID].specs[specID][category]) do
			table.insert(items, {
				source = providerName,
				category = category,
				slot = item.slot,
				itemID = item.itemID,
				itemName = item.itemName,
				quality = item.quality,
				priority = item.priority or 1,
				updated = db.updated,
			})
		end
	end

	if source then
		ProcessProvider(source, PROVIDERS[source])
	else
		for providerName, config in pairs(PROVIDERS) do
			ProcessProvider(providerName, config)
		end
	end

	-- Data files list items in guide display order (best first, alternatives
	-- adjacent to their slot), so no re-sort; priority is per-slot metadata
	return items
end

---Get all consumables for a spec across every category
---@param classID number The WoW class ID (1-13)
---@param specID number The specialization ID
---@param source string|nil "wowhead" (default: all sources)
---@return table|nil consumables Table of category key -> items array (only categories with data)
---@return string|nil errorMsg Error message if request fails
function API.GetAllConsumables(classID, specID, source)
	local isValid, errorMsg = ValidateInputs(classID, specID, nil, source)
	if not isValid then
		return nil, errorMsg
	end

	local consumables = {}

	for _, category in ipairs(CATEGORY_ORDER) do
		local items = API.GetConsumables(classID, specID, category, source)
		if items and #items > 0 then
			consumables[category] = items
		end
	end

	return consumables
end

---Check whether any consumable data exists for a spec
---@param classID number The WoW class ID (1-13)
---@param specID number The specialization ID
---@param source string|nil "wowhead" (default: all sources)
---@return boolean hasData
function API.HasData(classID, specID, source)
	local consumables = API.GetAllConsumables(classID, specID, source)
	if not consumables then
		return false
	end
	return next(consumables) ~= nil
end

---Get available sources with their last update timestamps
---@param source string|nil Optional source filter
---@return table updates Table of source -> timestamp
function API.GetLastUpdate(source)
	local updates = {}

	local function ProcessProvider(providerName, config)
		local db = addon[config.db]
		updates[providerName] = db and db.updated
	end

	if source then
		if PROVIDERS[source] then
			ProcessProvider(source, PROVIDERS[source])
		end
	else
		for providerName, config in pairs(PROVIDERS) do
			ProcessProvider(providerName, config)
		end
	end

	return updates
end

---Get list of available data sources
---@return table sources Array of source names with data
function API.GetSources()
	local sources = {}

	for providerName, config in pairs(PROVIDERS) do
		if addon[config.db] then
			table.insert(sources, providerName)
		end
	end

	return sources
end

---Get category keys in display order
---@return table categories Array of category keys
function API.GetCategories()
	return CATEGORY_ORDER
end

---Get display name for a category key
---@param category string The category key
---@return string|nil categoryName The display name
function API.GetCategoryName(category)
	return CATEGORY_NAMES[category]
end

return API
