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
local ERR_INVALID_CATEGORY = "Invalid category provided"

-- The table src/Data/Consumables.lua installs on the addon table. Both that
-- name and the file's are deliberately source-agnostic: the scrape source has
-- changed twice, and the last rename left the TOC loading the previous file
-- for a month while every update landed somewhere nothing read. Do not rename
-- this after a source; it is the contract with the generator.
local DB = "ConsumablesData"

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
---@return boolean isValid Whether the inputs are valid
---@return string|nil errorMsg Error message if validation fails
local function ValidateInputs(classID, specID, category)
	if not classID or type(classID) ~= "number" or classID < 1 or classID > 13 then
		return false, ERR_INVALID_CLASS
	end

	if specID and (type(specID) ~= "number" or specID < 1) then
		return false, ERR_INVALID_SPEC
	end

	if category and not CATEGORY_NAMES[category] then
		return false, ERR_INVALID_CATEGORY
	end

	return true, nil
end

---Get the best consumables for a spec in a single category
---@param classID number The WoW class ID (1-13)
---@param specID number The specialization ID
---@param category string Category key ("enchants", "gems", "flasks", "potions", "food", "runes")
---@return table|nil items Array of consumable item tables
---@return string|nil errorMsg Error message if request fails
function API.GetConsumables(classID, specID, category)
	local isValid, errorMsg = ValidateInputs(classID, specID, category)
	if not isValid then
		return nil, errorMsg
	end

	local items = {}

	local db = addon[DB]
	if not db then return items end
	if not db[classID] then return items end
	if not db[classID].specs then return items end
	if not db[classID].specs[specID] then return items end
	if not db[classID].specs[specID][category] then return items end

	for _, item in ipairs(db[classID].specs[specID][category]) do
		table.insert(items, {
			category = category,
			slot = item.slot,
			itemID = item.itemID,
			itemName = item.itemName,
			quality = item.quality,
			priority = item.priority or 1,
			updated = db.updated,
		})
	end

	-- Data files list items in guide display order (best first, alternatives
	-- adjacent to their slot), so no re-sort; priority is per-slot metadata
	return items
end

---Get all consumables for a spec across every category
---@param classID number The WoW class ID (1-13)
---@param specID number The specialization ID
---@return table|nil consumables Table of category key -> items array (only categories with data)
---@return string|nil errorMsg Error message if request fails
function API.GetAllConsumables(classID, specID)
	local isValid, errorMsg = ValidateInputs(classID, specID, nil)
	if not isValid then
		return nil, errorMsg
	end

	local consumables = {}

	for _, category in ipairs(CATEGORY_ORDER) do
		local items = API.GetConsumables(classID, specID, category)
		if items and #items > 0 then
			consumables[category] = items
		end
	end

	return consumables
end

---Check whether any consumable data exists for a spec
---@param classID number The WoW class ID (1-13)
---@param specID number The specialization ID
---@return boolean hasData
function API.HasData(classID, specID)
	local consumables = API.GetAllConsumables(classID, specID)
	if not consumables then
		return false
	end
	return next(consumables) ~= nil
end

---Get the timestamp the data was generated, as "YYYY-MM-DD HH:MM:SS"
---@return string|nil updated nil when no data is loaded
function API.GetLastUpdate()
	local db = addon[DB]
	return db and db.updated
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
