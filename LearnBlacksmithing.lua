-- #####################################################
-- JerCore's learn Blacksmithing for 11.2.5
-- Teaches all Blacksmithing ranks
-- Command .prof learn blacksmithing
-- #####################################################

local SPELLS_BLACKSMITHING = {
    9785,   -- Blacksmithing (base, rank 4)
    264435, -- Classic Blacksmithing
    264437, -- Outland Blacksmithing
    264439, -- Wrath Blacksmithing
    264441, -- Cata Blacksmithing
    264443, -- Panda Blacksmithing
    264445, -- Draenor Blacksmithing
    264447, -- Legion Blacksmithing
    309828, -- SL Blacksmithing
    365699, -- DF Blacksmithing
    423344  -- War Blacksmithing
}

local SPELL_ALLIANCE = 264449 -- Kul Tiran Blacksmithing
local SPELL_HORDE    = 265804 -- Zandalari Blacksmithing

local function OnCommand(event, player, command)
    command = command:lower()

    if command == "prof learn blacksmithing" then
        player:SendBroadcastMessage("|cff00ff00[Professions]|r Teaching all Blacksmithing ranks")

        for _, spellId in ipairs(SPELLS_BLACKSMITHING) do
            if not player:HasSpell(spellId) then
                player:LearnSpell(spellId)
            end
        end

        if player:GetTeam() == 0 then
            player:LearnSpell(SPELL_ALLIANCE)
        else
            player:LearnSpell(SPELL_HORDE)
        end

        return false 
    end

    return true
end

RegisterPlayerEvent(42, OnCommand)

