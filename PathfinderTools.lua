PathfinderTools = { }

local defaultRecruitmentMsg = "Hello {p}, would you be interested in joining a leveling guild? We're a light hearted group looking for more people interested in quest and dungeon parties."
local defaultPublicWelcomeMsg = "Welcome {p}"
local defaultOrientationMsg = "So the guild is currently in open recruitment. This means that everyone can recruit and that you should feel free to /ginvite people you meet in your travels who could benifit from guild membership. We try to organize dungeon runs in the evenings and weekends so watch out for those. Also we have a shiny new Discord server, link in the MOTD, which you can check out if you are interested."
local discordInfo = "Discord Server: https://discord.gg/vMUmvY9Fpy - Please set your nickname to match your character's name."

function PathfinderTools:getTargetPlayer()
    if UnitName("Target") ~= nil and UnitIsPlayer("Target") then
        name = UnitName("Target")
        return name
    else
        print("PF Error: Target is not a player.")
        return nil
    end
end

function PathfinderTools:getPlayerSelection(name)
    if name == nil or name == "" then
        name = PathfinderTools:getTargetPlayer()
    end
    return name
end

function PathfinderTools:Recruit(name)
    player = PathfinderTools:getPlayerSelection(name)
    if player ~= nil then
        if UnitIsUnit(player,UnitName("player")) then
            print("PF Error: You can't recruit yourself....")
        else 
            SendChatMessage(defaultRecruitmentMsg:gsub("{p}",player), "WHISPER", "Common", player)
        end
    end
end

function PathfinderTools:sendLongMessage(msg,to)
    words = {}
    s = ""
    for word in msg:gmatch("%S+") do table.insert(words, word) end
    for i, word in pairs(words) do
        s = s..(s ~= "" and " " or "")..word
        if s:len() >= 225 or next(words,i) == nil then
            SendChatMessage(s,"WHISPER","Common",to)
            s = ""
        end
    end
end

function PathfinderTools:Welcome(name)
    player = PathfinderTools:getPlayerSelection(name)
    if player ~= nil then
        if UnitIsUnit(player,"player") then
            print("PF Error: You can't welcome yourself....")
        else
            SendChatMessage(defaultPublicWelcomeMsg:gsub("{p}",player),"GUILD","Common",nil)
            PathfinderTools:sendLongMessage(defaultOrientationMsg,player)
        end
    end
end

function PathfinderTools:ShareDiscord(with)
    if with == "raid" or with == "party" or with == "guild" then
        SendChatMessage(discordInfo, with:upper(), "Common", nil)
    else
        player = PathfinderTools:getPlayerSelection(with)
        if player ~= nil then
            SendChatMessage(discordInfo, "WHISPER", "Common", player)
        end
    end
end

local function OnEvent(self, event, ...)
    --print(event, ...)
    if event == "ADDON_LOADED" and ... == "PathfinderTools" then
        print("PathfinderTools Loaded ...")
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", OnEvent)

SLASH_PF1 = '/pf'
function SlashCmdList.PF(args, editbox)
    local _, _, cmd, arg = string.find(args, "%s?(%w+)%s?(.*)")

    print(cmd.." : "..arg)

    if cmd == 'recruit' then
        PathfinderTools:Recruit(arg)
    elseif cmd == 'welcome' then
        PathfinderTools:Welcome(arg)
    elseif cmd == "discord" then
        PathfinderTools:ShareDiscord(arg)
    else
        print("PF Error: Invalid command.")
    end
end