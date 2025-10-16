-- #####################################################
-- JerCore's World Buff: Applied only during specific time period
-- Fall Celebration
-- Applies spell 957353 at login until 10/31/2025
-- 957353 is a custom spell, change to your spell!
-- #####################################################

local ENABLE_EVENT = true
local SPELL_ID = 957353
-- Change message to apply to your buff and note- this text color is orange
local MESSAGE = "|cffffa500Fall Celebration is now active!|r"

local EXPIRATION = os.time({
    year = 2025,
    month = 11,
    day = 1,
    hour = 0,
    min = 1,
    sec = 0
})

local removalDone = true

local function OnLogin(event, player)
  if not ENABLE_EVENT then
        return
    end
   
    local now = os.time()

    if now < EXPIRATION then
        player:AddAura(SPELL_ID, player)

        local guid = player:GetGUIDLow()

        CreateLuaEvent(function()
            local p = GetPlayerByGUID(guid)
            if p and p:IsInWorld() then
                p:SendBroadcastMessage(MESSAGE)
            end
        end, 3000, 1)

    else
       
        if not removalDone and player:HasAura(SPELL_ID) then
            player:RemoveAura(SPELL_ID)
        end
    end
end

local function CheckExpiration()
    if not removalDone and os.time() >= EXPIRATION then
        for _, player in pairs(GetPlayersInWorld()) do
            if player:HasAura(SPELL_ID) then
                player:RemoveAura(SPELL_ID)
            end
        end
        removalDone = true
        SendWorldMessage("Fall Celebration has ended.")
    end
end

RegisterPlayerEvent(3, OnLogin)            






