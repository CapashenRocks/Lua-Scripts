-- Config
local MIN_MULTIPLIER = 1.2
local MAX_MULTIPLIER = 2.4
local FAILURE_CHANCE = 0.02   -- 2%
local JACKPOT_CHANCE = 0.01   -- 1%
local JACKPOT_MULTIPLIER = 8 -- 8x payout

-- Success messages
local FLAVOR_TEXTS = {
    "%s was fenced for %s.",
    "%s found a shady buyer and sold for %s.",
    "%s slipped into the black market for %s.",
    "A mysterious trader took your %s for %s.",
    "Your junk %s fetched %s under the table.",
    "A shadowy figure paid %s for %s.",
    "%s disappeared from your bags… you pocketed %s.",
    "You sold %s on the black market for %s.",
 -- Extra lines
    "Rumors spread of your sale: %s moved quietly, you gained %s.",
    "Under moonlight, %s changed hands for %s.",
    "A masked broker valued your %s at %s.",
    "%s was offloaded to Gallywix's underground for %s.",
    "In a hidden alley, %s earned you %s."
}

-- Failure messages
local FAILURE_TEXTS = {
    "Your contact vanished with %s… no gold this time.",
    "The black market deal for %s went sour. You got nothing.",
    "%s was stolen before the deal closed. Tough luck.",
    "Your shady buyer took %s and never came back.",
    "The guards raided the trade %s was confiscated, no payout.",
    -- Extra lines
    "The deal fell apart and %s is gone, and your purse stays light.",
    "Goblin rogues intercepted %s, leaving you empty-handed.",
    "Word got out, the heat was too high — %s disappeared.",
    "A double-cross! %s was taken, no payment given.",
    "Your smuggler botched the job and %s was lost in the chaos."
}

-- Jackpot messages
local JACKPOT_TEXTS = {
    "WHOA! A desperate collector paid a fortune: %s fetched %s!",
    "Incredible luck! You scored a massive haul selling %s for %s!",
    "A bidding war broke out on the black market — %s sold for %s!",
 --   "Fortune smiles upon you: %s brought in %s!"
}

-- Helper: random float
local function RandomFloat(min, max)
    return min + (max - min) * math.random()
end

-- Helper: format copper into g/s/c
local function FormatMoney(copper)
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local c = copper % 100

    local parts = {}
    if gold > 0 then table.insert(parts, gold .. "g") end
    if silver > 0 then table.insert(parts, silver .. "s") end
    if c > 0 then table.insert(parts, c .. "c") end
    if #parts == 0 then return "0c" end
    return table.concat(parts, " ")
end

-- Transaction logic
local function SendTransactionInformation(player, item, count, finalPrice)
    local link = string.format("|cff9d9d9d|Hitem:%d::::::::80:::::|h[%s]|h|r",
        item:GetEntry(), item:GetName())
    if count > 1 then
        link = link .. "x" .. count
    end

    -- Failure chance
    if math.random() < FAILURE_CHANCE then
        local failText = FAILURE_TEXTS[math.random(1, #FAILURE_TEXTS)]
        player:SendBroadcastMessage("|cffff2020[Black Market]|r " .. string.format(failText, link))
        return 0
    end

    -- Jackpot chance
    if math.random() < JACKPOT_CHANCE then
        local jackpotValue = finalPrice * JACKPOT_MULTIPLIER
        local jackpotText = JACKPOT_TEXTS[math.random(1, #JACKPOT_TEXTS)]
        player:SendBroadcastMessage("|cffffd700[Black Market: JACKPOT]|r " ..
            string.format(jackpotText, link, FormatMoney(jackpotValue)))
        return jackpotValue
    end

    -- Normal success
    local msg = FLAVOR_TEXTS[math.random(1, #FLAVOR_TEXTS)]
    player:SendBroadcastMessage("|cff20ff20[Black Market]|r " ..
        string.format(msg, link, FormatMoney(finalPrice)))
    return finalPrice
end

-- Event handler
local function OnLootItem(event, player, item, count)
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

        -- Always remove the item (whether success, jackpot, or failure)
        player:RemoveItem(item:GetEntry(), count)
    end
end

RegisterPlayerEvent(32, OnLootItem) -- PLAYER_EVENT_ON_LOOT_ITEM
