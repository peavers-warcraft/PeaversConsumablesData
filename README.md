# PeaversConsumablesData

Best consumable, enchant and gem data per class and spec, sourced from Wowhead.

[peavers.io](https://peavers.io) | [Report Issues](https://github.com/peavers-warcraft/PeaversConsumablesData/issues)

## Features

- Per class/spec best enchants, gems and consumables scraped from Wowhead class guides
- Clean public API consumed by [PeaversConsumables](https://github.com/peavers-warcraft/PeaversConsumables) and available to any addon
- No configuration, no saved variables — pure data provider

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

## Installation

Installed automatically as a dependency of PeaversConsumables, or manually from CurseForge.
