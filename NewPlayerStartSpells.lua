-- Teach certain spells only on First Login
-- Reasoning- To add some flavor and make things easier on a smaller low-pop server
-- Description: When a new character enters the world for the first time, they will automatically learn spells identified below.
-- A one-time broadcast message will also be sent if custom message is setup/defined.

-- Add or remove spells to learn that spell on first character login
local SPELLS_TO_LEARN = {455532, 20608, 33389}
-- Spell List: Coreforged skeleton key spell, Reincarnation, Appretice Riding

local function OnFirstLogin(event, player)
    for _, spellId in ipairs(SPELLS_TO_LEARN) do
        if not player:HasSpell(spellId) then
            player:LearnSpell(spellId)
        end
    end

    -- Custom message, change to anything you would like or delete for no messaging
    player:SendBroadcastMessage("You have been granted additional abilities!")
end

RegisterPlayerEvent(30, OnFirstLogin)


