-- JerCore's Tool Tip Item Number
-- Description: Adds Item Number to the tool tips, for example Frostweave Bag will show "Item ID: 41599"
-- TOC info: To update to a different version of wow, just update the .toc Interface number
-- You need the interface number not patch number, can see an example here: https://wowwiki-archive.fandom.com/wiki/Patch_3.3.5


local function AddItemIDToTooltip(tooltip)
    local _, itemLink = tooltip:GetItem()
    if itemLink then
        local itemID = string.match(itemLink, "item:(%d+):")
        if itemID then
            tooltip:AddLine("|cffffd200Item ID:|r " .. itemID)
            tooltip:Show()
        end
    end
end

GameTooltip:HookScript("OnTooltipSetItem", AddItemIDToTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", AddItemIDToTooltip)