-- #########################################################
-- JerCore's Black Market Auto-Sell (Gray Items)
-- Details and setting info:
-- Automatically Sell Vendor Trash when looted in the game world
-- Sale multiplier can be adjusted, if you want blizz-like make the min and max 1.0 and change Faulure_Chance and Jackpot_chance to 0.00
-- Chat delay added to allow looting to show in the chat window prior to the sale/flavor text
-- Sound_ID is an option to add another sound when the text fires
-- Lastly, setting enable chat to false will remove the flavor texts and just show a simple sold amount
-- #########################################################

local NPC_ID              = 97876  -- Change to any NPC, this is my custom Goblin NPC
local BLACKMARKET_ENABLED = true  
local MIN_MULTIPLIER      = 1.2
local MAX_MULTIPLIER      = 2.4
local FAILURE_CHANCE      = 0.02   -- 2%
local JACKPOT_CHANCE      = 0.01   -- 1%
local JACKPOT_MULTIPLIER  = 8      -- 8x payout
local ENABLE_CHAT         = true   -- true = flavor text; false = simple payout line
local CHAT_DELAY_MS       = 1000   -- 1-second delay on flavor texts
local SOUND_ID            = 0      -- optional sound if want something other than the gold sound (default already on)

local FLAVOR_TEXTS = {
    "%s was fenced for %s.",
    "%s found a shady buyer and sold for %s.",
    "%s slipped into the black market for %s.",
    "A mysterious trader took your %s for %s.",
    "Your junk %s fetched %s under the table.",
    "A shadowy figure paid %s for %s.",
    "%s disappeared from your bags… you pocketed %s.",
    "You sold %s on the black market for %s."
}

local FAILURE_TEXTS = {
    "Your contact vanished with %s… no gold this time.",
    "The black market deal for %s went sour. You got nothing.",
    "%s was stolen before the deal closed. Tough luck.",
    "Your shady buyer took %s and never came back.",
    "The guards raided the trade — %s confiscated, no payout."
}

local JACKPOT_TEXTS = {
    "WHOA! A desperate collector paid a fortune: %s fetched %s!",
    "Incredible luck! You scored a massive haul selling %s for %s!",
    "A bidding war broke out on the black market — %s sold for %s!"
}

-- DO NOT EDIT below this line unless you know what you are doing :)

local function RandomFloat(min, max)
    return min + (max - min) * math.random()
end

local function FormatMoney(copper)
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local c = copper % 100
    local parts = {}
    if gold > 0 then table.insert(parts, gold .. " Gold") end
    if silver > 0 then table.insert(parts, silver .. " Silver") end
    if c > 0 then table.insert(parts, c .. " Copper") end
    if #parts == 0 then return "0 Copper" end
    return table.concat(parts, " ")
end

local function SendTransactionInformation(player, item, count, finalPrice)
    local link = string.format("|cff9d9d9d|Hitem:%d::::::::80:::::|h[%s]|h|r", item:GetEntry(), item:GetName())
    if count > 1 then link = link .. "x" .. count end

    local function DelayedFeedback(msg)
        local guid = player:GetGUIDLow()
        CreateLuaEvent(function()
            local p = GetPlayerByGUID(guid)
            if p then
                if SOUND_ID and SOUND_ID > 0 then
                    p:PlayDirectSound(SOUND_ID)
                end
                p:SendBroadcastMessage(msg)
            end
        end, CHAT_DELAY_MS, 1)
    end

    if math.random() < FAILURE_CHANCE then
        if ENABLE_CHAT then
            local failText = FAILURE_TEXTS[math.random(#FAILURE_TEXTS)]
            DelayedFeedback("|cffff2020[Black Market]|r " .. string.format(failText, link))
        else
            DelayedFeedback("You acquire nothing.")
        end
        return 0
    end

    if math.random() < JACKPOT_CHANCE then
        local jackpotValue = finalPrice * JACKPOT_MULTIPLIER
        if ENABLE_CHAT then
            local jackpotText = JACKPOT_TEXTS[math.random(#JACKPOT_TEXTS)]
            DelayedFeedback("|cffffd700[BLACK MARKET JACKPOT]|r " ..
                string.format(jackpotText, link, FormatMoney(jackpotValue)))
        else
            DelayedFeedback("You acquire " .. FormatMoney(jackpotValue) .. ".")
        end
        return jackpotValue
    end

    if ENABLE_CHAT then
        local msg = FLAVOR_TEXTS[math.random(#FLAVOR_TEXTS)]
        DelayedFeedback("|cff20ff20[Black Market]|r " ..
            string.format(msg, link, FormatMoney(finalPrice)))
    else
        DelayedFeedback("You acquire " .. FormatMoney(finalPrice) .. ".")
    end

    return finalPrice
end

local function OnLootItem(event, player, item, count)
    if not BLACKMARKET_ENABLED then return end
    if not item then return end
    if item:GetQuality() == 0 then -- gray items only
        local basePrice = item:GetSellPrice() * count
        if basePrice <= 0 then return end

        local multiplier = RandomFloat(MIN_MULTIPLIER, MAX_MULTIPLIER)
        local finalPrice = math.floor(basePrice * multiplier)

        local payout = SendTransactionInformation(player, item, count, finalPrice)
        if payout > 0 then
            player:ModifyMoney(payout)
        end

        player:RemoveItem(item:GetEntry(), count)
    end
end
RegisterPlayerEvent(32, OnLootItem)

local function ToggleBlackMarket(event, player, command)
    if command:lower() == "bm toggle" then
        BLACKMARKET_ENABLED = not BLACKMARKET_ENABLED
        local status = BLACKMARKET_ENABLED and "|cff20ff20ENABLED|r" or "|cffff2020DISABLED|r"
        player:SendBroadcastMessage("|cff00ccff[Black Market]|r Auto-sell is now " .. status .. ".")
        return false -- prevents default command handling
    end
end
RegisterPlayerEvent(42, ToggleBlackMarket) 

local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()   
    local statusText = BLACKMARKET_ENABLED and "|cff20ff20ENABLED|r" or "|cffff2020DISABLED|r"

    creature:SendUnitWhisper("The Black Market when enabled will have traders automatically buy your poor quality items when looted!", 0, player)
    creature:SendUnitWhisper("Black Market Auto-Sell is currently " .. (BLACKMARKET_ENABLED and "enabled." or "disabled."), 0, player)
   -- player:GossipMenuAddItem(0, "Black Market Auto-Sell is currently: " .. statusText, 0, 0)
    player:GossipMenuAddItem(0, "Enable Black Market Auto-Sell", 0, 1)
    player:GossipMenuAddItem(0, "Disable Black Market Auto-Sell", 0, 2)
    player:GossipMenuAddItem(0, "Close", 0, 3)
    player:GossipSendMenu(1, creature)
end

local function OnGossipSelect(event, player, creature, sender, intid)
    if intid == 1 then
        BLACKMARKET_ENABLED = true
        player:SendBroadcastMessage("|cff20ff20[Black Market]|r Auto-Sell ENABLED.")
        creature:SendUnitWhisper("The Black Market traders are at your disposal!", 0, player)
        creature:SendUnitSay("Thanks for your future business!", 0, player)
    elseif intid == 2 then
        BLACKMARKET_ENABLED = false
        player:SendBroadcastMessage("|cffff2020[Black Market]|r Auto-Sell DISABLED.")
        creature:SendUnitWhisper("You have opted out of the Black Market, traders will not bother you.", 0, player)
        creature:SendUnitSay("See me again if you change your mind.", 0, player)
    end
    player:GossipComplete()
end

RegisterCreatureGossipEvent(NPC_ID, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPC_ID, 2, OnGossipSelect)

print("[Black Market Auto Sell] Loaded successfully. Status: ENABLED")

