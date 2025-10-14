-- ###########################################################
-- Jercore's ZoneLevels AddOn for 3.3.5 
-- Shows level ranges on world map, numerical text colors mimic later expansions
-- ###########################################################

--DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[ZoneLevels]|r AddOn loaded.")

local ZoneLevels = {
    ["Eastern Kingdoms"] = "1–60",
    ["Kalimdor"]         = "1–60",
    ["Outland"]          = "58–70",
    ["Northrend"]        = "68–80",

 -- EASTERN KINGDOMS
    ["Elwynn Forest"]        = "1–10",
    ["Dun Morogh"]           = "1–10",
    ["Tirisfal Glades"]      = "1–10",
    ["Eversong Woods"]       = "1–10",
    ["Loch Modan"]           = "10–20",
    ["Westfall"]             = "10–20",
    ["Silverpine Forest"]    = "10–20",
    ["Ghostlands"]           = "10–20",
    ["Redridge Mountains"]   = "15–25",
    ["Duskwood"]             = "18–30",
    ["Wetlands"]             = "20–30",
    ["Hillsbrad Foothills"]  = "20–30",
    ["Arathi Highlands"]     = "30–40",
    ["Stranglethorn Vale"]   = "30–45",
    ["Badlands"]             = "35–45",
    ["Swamp of Sorrows"]     = "35–45",
    ["The Hinterlands"]      = "40–50",
    ["Searing Gorge"]        = "45–50",
    ["Burning Steppes"]      = "50–58",
    ["Western Plaguelands"]  = "51–58",
    ["Eastern Plaguelands"]  = "53–60",
    ["Blasted Lands"]        = "55–60",
    ["Isle of Quel'Danas"]   = "70",

  -- KALIMDOR
    ["Durotar"]              = "1–10",
    ["Mulgore"]              = "1–10",
    ["Teldrassil"]           = "1–10",
    ["Azuremyst Isle"]       = "1–10",
    ["Darkshore"]            = "10–20",
    ["Bloodmyst Isle"]       = "10–20",
    ["The Barrens"]          = "10–25",
    ["Stonetalon Mountains"] = "15–27",
    ["Ashenvale"]            = "18–30",
    ["Thousand Needles"]     = "25–35",
    ["Desolace"]             = "30–40",
    ["Dustwallow Marsh"]     = "35–45",
    ["Feralas"]              = "40–50",
    ["Tanaris"]              = "40–50",
    ["Azshara"]              = "45–55",
    ["Felwood"]              = "48–55",
    ["Un'Goro Crater"]       = "48–55",
    ["Silithus"]             = "55–60",
    ["Winterspring"]         = "55–60",
 
  -- OUTLAND
    ["Hellfire Peninsula"]   = "58–63",
    ["Zangarmarsh"]          = "60–64",
    ["Terokkar Forest"]      = "62–65",
    ["Nagrand"]              = "64–67",
    ["Blade's Edge Mountains"]= "65–68",
    ["Netherstorm"]          = "67–70",
    ["Shadowmoon Valley"]    = "67–70",
 --   ["Shattrath City"]       = "60–70",

 -- NORTHREND
    ["Borean Tundra"]        = "68–72",
    ["Howling Fjord"]        = "68–72",
    ["Dragonblight"]         = "71–74",
    ["Grizzly Hills"]        = "73–75",
    ["Zul'Drak"]             = "74–77",
    ["Sholazar Basin"]       = "76–78",
    ["Crystalsong Forest"]   = "77–80",
    ["The Storm Peaks"]      = "77–80",
    ["Icecrown"]             = "77–80",
    ["Wintergrasp"]          = "77–80",
   -- ["Dalaran"]            = "70–80",
    ["Utgarde Keep"]         = "68-72",
}

local function GetRange(range)
    if not range then return nil,nil end
    local min,max = string.match(range, "^(%d+)%D+(%d+)$")
    if not min then
        min = string.match(range, "(%d+)")
    end
    return tonumber(min), tonumber(max)
end

local function GetDifficultyColor(player, min, max)
    if not min then
        return "|cffffff00" -- default yellow
    end

    if player >= (max + 3) then
        return "|cff40c040" -- green
    elseif player >= min and player <= max then
        return "|cffffff00" -- yellow
    elseif player >= (min - 4) and player < min then
        return "|cffff8040" -- orange
    elseif player < (min - 4) then
        return "|cffff2020" -- red
    end
    return "|cffffff00"
end

local oldSetText = WorldMapFrameAreaLabel.SetText

function WorldMapFrameAreaLabel:SetText(name)
    if not name or name == "" then
        return oldSetText(self, name)
    end

    local range = ZoneLevels[name]
    if range then
        local playerLevel = UnitLevel("player")
        local min,max = GetRange(range)
        local color = GetDifficultyColor(playerLevel, min, max)
        name = string.format("%s (%s%s|r)", name, color, range)
    end

    oldSetText(self, name)
end

local function OnMapOpen()
    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00[ZoneLevels]|r Difficulty colors: |cff40c040Green|r easy, |cffffff00Yellow|r even, |cffff8040Orange|r hard, |cffff2020Red|r very hard.")
end

WorldMapFrame:HookScript("OnShow", OnMapOpen)
