DeegoData = {
  specs = {
    {
      id = "shaman_elemental",
      name = "Elemental Shaman",
      class = "SHAMAN",
      role = "DPS",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Vers",
        "Crit",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/elemental/shaman/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      bisSource = {
        name = "Wowhead",
        url = "https://www.wowhead.com/guide/classes/shaman/elemental/bis-gear#bis-items-overall",
        label = "Overall BiS gear",
      },
      bisSources = {
        { slot = "Head", itemId = 178816, source = "Halls of Atonement", sourceType = "dungeon" },
        { slot = "Neck", itemId = 251880, source = "Operation: Floodgate", sourceType = "dungeon" },
        { slot = "Shoulders", itemId = 237635, source = "Tier", sourceType = "mixed" },
        { slot = "Cloak", itemId = 235499, source = "Patch 11.2 Questline", sourceType = "quest" },
        { slot = "Chest", itemId = 237640, source = "Tier", sourceType = "mixed" },
        { slot = "Wrist", itemId = 219342, source = "Leatherworking", sourceType = "craft" },
        { slot = "Gloves", itemId = 237638, source = "Tier", sourceType = "mixed" },
        { slot = "Belt", itemId = 237554, source = "The Soul Hunters", sourceType = "boss" },
        { slot = "Legs", itemId = 237636, source = "Tier", sourceType = "mixed" },
        { slot = "Boots", itemId = 243308, source = "The Soul Hunters", sourceType = "boss" },
        { slot = "Ring 1", itemId = 185813, source = "Tazavesh: So'leah's Gambit", sourceType = "dungeon" },
        { slot = "Ring 2", itemId = 185840, source = "Tazavesh: Streets of Wonder", sourceType = "dungeon" },
        { slot = "Trinket 1", itemId = 242402, source = "Forgeweaver Araz", sourceType = "boss" },
        { slot = "Trinket 2", itemId = 242392, source = "Fractillus", sourceType = "boss" },
        { slot = "Main Hand", itemId = 237728, source = "Fractillus", sourceType = "boss" },
        { slot = "Off Hand", itemId = 222566, source = "Inscription", sourceType = "craft" },
        { slot = "Alternative", itemId = 237730, source = "Soulbinder Naazindhri", sourceType = "boss" },
        { slot = "Alt (Passive)", itemId = 242497, source = "Eco-Dome Al'dani", sourceType = "dungeon" },
        { slot = "Alt (On Use)", itemId = 242494, source = "Eco-Dome Al'dani", sourceType = "dungeon" },
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "shaman_enhancement",
      name = "Enhancement Shaman",
      class = "SHAMAN",
      role = "DPS",
      primary = "Agility",
      bestStats = {
        "Haste",
        "Mastery",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/enhancement/shaman/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      bisSource = {
        name = "Wowhead",
        url = "https://www.wowhead.com/guide/classes/shaman/enhancement/bis-gear#bis-items-overall",
        label = "Overall BiS gear",
      },
      bisSources = {
        { slot = "Head", itemId = 237637, source = "Tier", sourceType = "mixed" },
        { slot = "Neck", itemId = 185820, source = "Tazavesh: So'leah's Gambit", sourceType = "dungeon" },
        { slot = "Shoulders", itemId = 237635, source = "Tier", sourceType = "mixed" },
        { slot = "Cloak", itemId = 235499, source = "Patch 11.2 Questline", sourceType = "quest" },
        { slot = "Chest", itemId = 237529, source = "Forgeweaver Araz", sourceType = "boss" },
        { slot = "Wrist", itemId = 219342, source = "Leatherworking", sourceType = "craft" },
        { slot = "Gloves", itemId = 237638, source = "Tier", sourceType = "mixed" },
        { slot = "Belt", itemId = 237554, source = "The Soul Hunters", sourceType = "boss" },
        { slot = "Legs", itemId = 237636, source = "Tier", sourceType = "mixed" },
        { slot = "Boots", itemId = 243308, source = "The Soul Hunters", sourceType = "boss" },
        { slot = "Ring 1", itemId = 237570, source = "Forgeweaver Araz", sourceType = "boss" },
        { slot = "Ring 2", itemId = 242491, source = "Eco-Dome Al'dani", sourceType = "dungeon" },
        { slot = "Trinket 1", itemId = 242402, source = "Forgeweaver Araz", sourceType = "boss" },
        { slot = "Trinket 2", itemId = 242395, source = "Loom'ithar", sourceType = "boss" },
        { slot = "Main Hand", itemId = 185823, source = "Tazavesh: So'leah's Gambit", sourceType = "dungeon" },
        { slot = "Off Hand", itemId = 222446, source = "Blacksmithing", sourceType = "craft" },
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "shaman_restoration",
      name = "Restoration Shaman",
      class = "SHAMAN",
      role = "Healer",
      primary = "Intellect",
      bestStats = {
        "Haste",
        "Crit",
        "Vers",
        "Mastery",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/restoration/shaman/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      bisSource = {
        name = "Wowhead",
        url = "https://www.wowhead.com/guide/classes/shaman/restoration/bis-gear#bis-items-overall",
        label = "Overall BiS gear",
      },
      bisSources = {
        { slot = "Head", itemId = 237637, source = "Tier", sourceType = "mixed" },
        { slot = "Neck", itemId = 185842, source = "Tazavesh: Streets of Wonder", sourceType = "dungeon" },
        { slot = "Shoulders", itemId = 237537, source = "Dimensius", sourceType = "boss" },
        { slot = "Cloak", itemId = 235499, source = "Patch 11.2 Questline", sourceType = "quest" },
        { slot = "Chest", itemId = 237640, source = "Tier", sourceType = "mixed" },
        { slot = "Wrist", itemId = 219342, source = "Leatherworking", sourceType = "craft" },
        { slot = "Gloves", itemId = 237638, source = "Tier", sourceType = "mixed" },
        { slot = "Belt", itemId = 237522, source = "Loom'ithar", sourceType = "boss" },
        { slot = "Legs", itemId = 237636, source = "Tier", sourceType = "mixed" },
        { slot = "Boots", itemId = 243308, source = "The Soul Hunters", sourceType = "boss" },
        { slot = "Ring 1", itemId = 242405, source = "Dimensius", sourceType = "boss" },
        { slot = "Ring 2", itemId = 246281, source = "Tazavesh: Streets of Wonder", sourceType = "dungeon" },
        { slot = "Trinket 1", itemId = 242395, source = "Loom'ithar", sourceType = "boss" },
        { slot = "Trinket 2", itemId = 190958, source = "Tazavesh: So'leah's Gambit", sourceType = "dungeon" },
        { slot = "Main Hand", itemId = 237728, source = "Fractillus", sourceType = "boss" },
        { slot = "Off Hand", itemId = 222432, source = "Blacksmithing", sourceType = "craft" },
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "paladin_retribution",
      name = "Retribution Paladin",
      class = "PALADIN",
      role = "DPS",
      primary = "Strength",
      bestStats = {
        "Crit",
        "Mastery",
        "Haste",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/retribution/paladin/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "druid_balance",
      name = "Balance Druid",
      class = "DRUID",
      role = "DPS",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Crit",
        "Vers",
        "Haste",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/balance/druid/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "druid_feral",
      name = "Feral Druid",
      class = "DRUID",
      role = "DPS",
      primary = "Agility",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/feral/druid/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "druid_guardian",
      name = "Guardian Druid",
      class = "DRUID",
      role = "Tank",
      primary = "Agility",
      bestStats = {
        "Haste",
        "Vers",
        "Crit",
        "Mastery",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/guardian/druid/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "druid_restoration",
      name = "Restoration Druid",
      class = "DRUID",
      role = "Healer",
      primary = "Intellect",
      bestStats = {
        "Haste",
        "Mastery",
        "Vers",
        "Crit",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/restoration/druid/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "warrior_arms",
      name = "Arms Warrior",
      class = "WARRIOR",
      role = "DPS",
      primary = "Strength",
      bestStats = {
        "Haste",
        "Crit",
        "Mastery",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/arms/warrior/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "warrior_fury",
      name = "Fury Warrior",
      class = "WARRIOR",
      role = "DPS",
      primary = "Strength",
      bestStats = {
        "Mastery",
        "Haste",
        "Vers",
        "Crit",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/fury/warrior/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "warrior_protection",
      name = "Protection Warrior",
      class = "WARRIOR",
      role = "Tank",
      primary = "Strength",
      bestStats = {
        "Haste",
        "Crit",
        "Vers",
        "Mastery",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/protection/warrior/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "deathknight_blood",
      name = "Blood Death Knight",
      class = "DEATHKNIGHT",
      role = "Tank",
      primary = "Strength",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/blood/death-knight/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "deathknight_frost",
      name = "Frost Death Knight",
      class = "DEATHKNIGHT",
      role = "DPS",
      primary = "Strength",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/frost/death-knight/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "deathknight_unholy",
      name = "Unholy Death Knight",
      class = "DEATHKNIGHT",
      role = "DPS",
      primary = "Strength",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/unholy/death-knight/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "demonhunter_havoc",
      name = "Havoc Demon Hunter",
      class = "DEMONHUNTER",
      role = "DPS",
      primary = "Agility",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/havoc/demon-hunter/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "demonhunter_vengeance",
      name = "Vengeance Demon Hunter",
      class = "DEMONHUNTER",
      role = "Tank",
      primary = "Agility",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/vengeance/demon-hunter/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "demonhunter_devourer",
      name = "Devourer Demon Hunter",
      class = "DEMONHUNTER",
      role = "DPS",
      primary = "Agility",
      bestStats = {},
      source = {
        name = "TBD",
        url = "",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "evoker_augmentation",
      name = "Augmentation Evoker",
      class = "EVOKER",
      role = "DPS",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/augmentation/evoker/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "evoker_devastation",
      name = "Devastation Evoker",
      class = "EVOKER",
      role = "DPS",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/devastation/evoker/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "evoker_preservation",
      name = "Preservation Evoker",
      class = "EVOKER",
      role = "Healer",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/preservation/evoker/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "hunter_beastmastery",
      name = "Beast Mastery Hunter",
      class = "HUNTER",
      role = "DPS",
      primary = "Agility",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/beast-mastery/hunter/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "hunter_marksmanship",
      name = "Marksmanship Hunter",
      class = "HUNTER",
      role = "DPS",
      primary = "Agility",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/marksmanship/hunter/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "hunter_survival",
      name = "Survival Hunter",
      class = "HUNTER",
      role = "DPS",
      primary = "Agility",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/survival/hunter/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "mage_arcane",
      name = "Arcane Mage",
      class = "MAGE",
      role = "DPS",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/arcane/mage/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "mage_fire",
      name = "Fire Mage",
      class = "MAGE",
      role = "DPS",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/fire/mage/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "mage_frost",
      name = "Frost Mage",
      class = "MAGE",
      role = "DPS",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/frost/mage/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "monk_brewmaster",
      name = "Brewmaster Monk",
      class = "MONK",
      role = "Tank",
      primary = "Agility",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/brewmaster/monk/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "monk_mistweaver",
      name = "Mistweaver Monk",
      class = "MONK",
      role = "Healer",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/mistweaver/monk/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "monk_windwalker",
      name = "Windwalker Monk",
      class = "MONK",
      role = "DPS",
      primary = "Agility",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/windwalker/monk/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "paladin_holy",
      name = "Holy Paladin",
      class = "PALADIN",
      role = "Healer",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/holy/paladin/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "paladin_protection",
      name = "Protection Paladin",
      class = "PALADIN",
      role = "Tank",
      primary = "Strength",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/protection/paladin/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "priest_discipline",
      name = "Discipline Priest",
      class = "PRIEST",
      role = "Healer",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/discipline/priest/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "priest_holy",
      name = "Holy Priest",
      class = "PRIEST",
      role = "Healer",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/holy/priest/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "priest_shadow",
      name = "Shadow Priest",
      class = "PRIEST",
      role = "DPS",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/shadow/priest/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "rogue_assassination",
      name = "Assassination Rogue",
      class = "ROGUE",
      role = "DPS",
      primary = "Agility",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/assassination/rogue/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "rogue_outlaw",
      name = "Outlaw Rogue",
      class = "ROGUE",
      role = "DPS",
      primary = "Agility",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/outlaw/rogue/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "rogue_subtlety",
      name = "Subtlety Rogue",
      class = "ROGUE",
      role = "DPS",
      primary = "Agility",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/subtlety/rogue/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "warlock_affliction",
      name = "Affliction Warlock",
      class = "WARLOCK",
      role = "DPS",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/affliction/warlock/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "warlock_demonology",
      name = "Demonology Warlock",
      class = "WARLOCK",
      role = "DPS",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/demonology/warlock/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
    {
      id = "warlock_destruction",
      name = "Destruction Warlock",
      class = "WARLOCK",
      role = "DPS",
      primary = "Intellect",
      bestStats = {
        "Mastery",
        "Haste",
        "Crit",
        "Vers",
      },
      source = {
        name = "Archon",
        url = "https://www.archon.gg/wow/builds/destruction/warlock/raid/overview/mythic/all-bosses",
        label = "Raid overview (Mythic, all bosses)",
      },
      loot = {
        raid = {},
        mythicPlus = {},
      },
    },
  },
  instances = {
    raid = {
      name = "Season 1 Raids",
      raids = {
        {
          name = "The Voidspire",
          bossCount = 6,
          notes = "Xal'atath's stronghold in the Voidstorm. Finale: Dominus-Lord Averzian and Salhadaar.",
        },
        {
          name = "The Dreamrift",
          bossCount = 1,
          notes = "Primordial dreams meet brutal reality. Hunt an undreamt god with the Shul'ka.",
        },
        {
          name = "March on Quel'Danas",
          bossCount = 2,
          notes = "Story climax at Sunwell Plateau with the united elven armies.",
        },
      },
      bosses = {},
      tips = {},
    },
    mythicPlus = {
      season = "CURRENT_SEASON",
      dungeons = {},
      tips = {},
    },
  },
}

if DeegoBisData and DeegoBisData.specs then
  local bisById = {}
  for _, entry in ipairs(DeegoBisData.specs) do
    if entry.id then
      bisById[entry.id] = entry
    end
  end
  for _, spec in ipairs(DeegoData.specs) do
    local bis = bisById[spec.id]
    if bis then
      if bis.bisSource then
        spec.bisSource = bis.bisSource
      end
      if bis.bisNote then
        spec.bisNote = bis.bisNote
      end
      if bis.bisSourceRaid then
        spec.bisSourceRaid = bis.bisSourceRaid
      end
      if bis.bisNoteRaid then
        spec.bisNoteRaid = bis.bisNoteRaid
      end
      if bis.bisSourcesRaid then
        spec.bisSourcesRaid = bis.bisSourcesRaid
      end
      if bis.bisSourceMythicPlus then
        spec.bisSourceMythicPlus = bis.bisSourceMythicPlus
      end
      if bis.bisNoteMythicPlus then
        spec.bisNoteMythicPlus = bis.bisNoteMythicPlus
      end
      if bis.bisSourcesMythicPlus then
        spec.bisSourcesMythicPlus = bis.bisSourcesMythicPlus
      end
      if bis.trinketTiers then
        spec.trinketTiers = bis.trinketTiers
      end
      if bis.bisSources then
        spec.bisSources = bis.bisSources
      end
    end
  end
end

if DeegoStatData and DeegoStatData.specs then
  local statsById = {}
  for _, entry in ipairs(DeegoStatData.specs) do
    if entry.id then
      statsById[entry.id] = entry
    end
  end
  for _, spec in ipairs(DeegoData.specs) do
    local stats = statsById[spec.id]
    if stats and stats.bestStats then
      spec.bestStats = stats.bestStats
    end
  end
end
