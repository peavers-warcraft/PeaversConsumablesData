# PeaversConsumablesData

A data library addon for World of Warcraft that provides best consumable, enchant and gem data per class and spec, sourced from Wowhead.

## Features

<!-- peavers:features -->
- Per class/spec best enchants, gems and consumables scraped from Wowhead class guides
- Clean public API consumed by [PeaversConsumables](https://github.com/peavers-warcraft/PeaversConsumables) and available to any addon
- No configuration, no saved variables — pure data provider
<!-- /peavers:features -->

<!-- peavers:custom -->
## API

The addon exposes a global `PeaversConsumablesData.API`:

```lua
local API = PeaversConsumablesData.API

-- All categories for a spec (Priest = 5, Discipline = 256)
local consumables = API.GetAllConsumables(5, 256)

-- One category
local enchants = API.GetConsumables(5, 256, "enchants")

-- Metadata
API.HasData(5, 256)          -- boolean
API.GetCategories()          -- ordered category keys
API.GetCategoryName("gems")  -- "Gems"
API.GetLastUpdate()          -- source -> timestamp
API.GetSources()             -- { "wowhead" }
```

Each item row contains `slot`, `itemID`, `itemName`, `quality`, `priority`, `source` and `updated`.
<!-- /peavers:custom -->

## Installation

This is a data library used by other Peavers addons and doesn't require direct user interaction. [PeaversUpdater](https://github.com/peavers-warcraft/PeaversUpdater/releases/latest) installs and updates it automatically alongside its parent addon, or download it directly from [CurseForge](https://www.curseforge.com/wow/addons/peaversconsumablesdata).

---

*Part of the [Peavers](https://peavers.io) addon collection · [Report an issue](https://github.com/peavers-warcraft/PeaversConsumablesData/issues) · [Support development on Patreon](https://www.patreon.com/Peavers)*
