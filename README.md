# Lua Scripts
Collection of JerCore lua scripts and addons (in the Misc folder). Most of these are used on Azerothcore, but have also been tested on modern repacks (lightly).

#### 1. ApplyWorldBuff_SpecificExpire
 <ins>Details:</ins>
 Apply world buff at character login that will expire at a specific date and no loger apply it. This uses a custom spell I made called Fall Celebration (this was an xp buff) and thus needs to be edited to your spell.<br><br>


#### 2a. AutoSellVT
 <ins>Details:</ins>
  Ported from my C++ Azerothcore custom script. This script upon looting any gray items will auto sell them at a set multiplier rate above standard vendor pricing (unless the multiplier is adjusted to 1.0). 
  
  <br>There is a small chance this fails and player loses the item, but also a chance for a huge jackpot sale that will more than mitigate any lost items, in theory. Designed to add fun and flavor. Version 2.0 added an NPC (need to change the one in the script is my custom NPC) as well as a command to toggle on/off anywhere in the game world. Updated with a configuration option to turn off the full chat messages for those that don't want to see that. 
  
  <br><i>Note- Tested and working on 3.3.5 Azerothcore as well as some modern repacks- 10.2.7 and 11.2.0. Only repack it had an issue with so far in testing was Ashen Order that constantly crashed on looting.</i><br><br>

#### 2b. JerCore's AutoSellVT_LowMarket- ALT Version
 <ins>Details:</ins>
 This version lowers the sale multiplier rates with a possibility to sell under vendor rate for those that enjoy emersion and a more realistic feel where sometimes these items would be saturated in the market and sell for a lower price. Just a fun alternative for some that like RP.<br><br>

#### 3. LearnBlacksmithing- for War Within ![The War Within Logo](https://github.com/CapashenRocks/Lua-Scripts/blob/main/Misc/Art/tww.png)
<ins>Details:</ins>
Quick lua script that adds a command in game to learn blacksmithing and all ranks. It was written for a War Within repack that had some profession issues with Blacksmithing. It also correctly teaches BFA ranks based on player's faction. <br>
Note: I have not tested this much as it was written for someone requesting it in a discord. Confirmed working<br><br>
 
#### 4. NewPlayerStartSpells
 <ins>Details:</ins>
 Add customized spells to new characters on first login. Current spells were for a 11.2.0 repack, change spells if testing/using with an older version.<br><br>

