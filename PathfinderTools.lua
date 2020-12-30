PathfinderTools = { }

local db
local defaultDB = {
    recruitMsg = "Hello {p}, would you be interested in joining a leveling guild? We're a light hearted group looking for more people interested in quest and dungeon parties.",
    recruits = 0,
    welcomeMsg = "Welcome to the guild, {p}!",
    orientationMsg = "So the guild is currently in open recruitment. This means that everyone can recruit and that you should feel free to /ginvite people you meet in your travels who could benifit from guild membership. We try to organize dungeon runs in the evenings and weekends so watch out for those. Also we have a shiny new Discord server, link in the MOTD, which you can check out if you are interested.",
    welcomes = 0,
    discordInfo = "Discord Server: https://discord.gg/vMUmvY9Fpy - Please set your nickname to match your character's name."
}
-- local defaultRecruitmentMsg = "Hello {p}, would you be interested in joining a leveling guild? We're a light hearted group looking for more people interested in quest and dungeon parties."
-- local defaultPublicWelcomeMsg = "Welcome to the guild, {p}!"
-- local defaultOrientationMsg = "So the guild is currently in open recruitment. This means that everyone can recruit and that you should feel free to /ginvite people you meet in your travels who could benifit from guild membership. We try to organize dungeon runs in the evenings and weekends so watch out for those. Also we have a shiny new Discord server, link in the MOTD, which you can check out if you are interested."
-- local discordInfo = "Discord Server: https://discord.gg/vMUmvY9Fpy - Please set your nickname to match your character's name."

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

function PathfinderTools:Recruit(name)
    player = PathfinderTools:getPlayerSelection(name)
    if player ~= nil then
        if UnitIsPlayer(player) then
            print("PF Error: You can't recruit yourself....")
        else 
            SendChatMessage(db.recruitMsg:gsub("{p}",player), "WHISPER", "Common", player)
            db.recruits = db.recruits + 1
        end
    end
end

function PathfinderTools:Welcome(name)
    player = PathfinderTools:getPlayerSelection(name)
    if player ~= nil then
        if UnitIsPlayer(player) then
            print("PF Error: You can't welcome yourself....")
        else
            SendChatMessage(db.welcomeMsg:gsub("{p}",player),"GUILD","Common",nil)
            PathfinderTools:sendLongMessage(db.orientationMsg,player)
            db.welcomes = db.welcomes + 1
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

function PathfinderTools:showStats()
    local rate = 0.0
    if db.recruits > 0 then
        rate = ((db.welcomes/db.recruits)*100)
    end
    print("--PathfinderTools Stats--")
    print("Recruit Attempts: "..db.recruits)
    print("Recruits Welcomed: "..db.welcomes)
    print("Converstion Rate: "..rate.."%")
end

function PathfinderTools:getGuildMemberInfo(member)
    SetGuildRosterShowOffline(true) --show offline members
    GuildRoster()
    local totalMembers, onlineMembers, mobileMembers = GetNumGuildMembers()
    local member = nil

    local count = totalMembers

    while count >= 0 do
        local m = {
            name = "",
            rankName = "",
            rankIndex = "",
            level = "",
            classDisplayName = "",
            zone = "",
            publicNote = "",
            officerNote = "",
            isOnline = "",
            status = "",
            class = "",
            achievementPoints = "",
            achievementRank = "",
            isMobile = "",
            canSoR = "",
            repStanding = "",
            GUID = "",
            lastOnline = {}
        }
        local name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, GUID = GetGuildRosterInfo(count)
        local lastOnline = { GetGuildRosterLastOnline(count) }
        iwwwwwwwwwwwwwwwwwf name:lower() == member:lower() then
            member = {
                name = name,
                rankName = rankName,
                rankIndex = rankIndex,
                level = level,
                classDisplayName = classDisplayName,
                zone = zone,
                publicNote = publicNote,
                officerNote = officerNote,
                isOnline = isOnline,
                status = status,
                class = class,
                achievementPoints = achievementPoints,
                achievementRank = achievementRank,
                isMobile = isMobile,
                canSoR = canSoR,
                repStanding = repStanding,
                GUID = GUID,
                lastOnline = lastOnline
            }
            break
        end
        count = count - 1
    end

    return member
end

local function OnEvent(self, event, ...)
    --print(event, ...)
    if event == "ADDON_LOADED" and ... == "PathfinderTools" then
        PathfinderToolsDB = PathfinderToolsDB or CopyTable(defaultDB)
        --Add new options from defaultDB
        for k, v in pairs(defaultDB) do
			if PathfinderToolsDB[k] == nil then -- don't reset false values
				PathfinderToolsDB[k] = v
			end
        end
        db = PathfinderToolsDB
        print("PathfinderTools Loaded ...")
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", OnEvent)

SLASH_PF1 = '/pf'
function SlashCmdList.PF(args, editbox)
    local _, _, cmd, arg = string.find(args, "%s?(%w+)%s?(.*)")

    --print(cmd.." : "..arg)

    if cmd == 'recruit' then
        PathfinderTools:Recruit(arg)
    elseif cmd == 'welcome' then
        PathfinderTools:Welcome(arg)
    elseif cmd == "discord" then
        PathfinderTools:ShareDiscord(arg)
    elseif cmd == 'stats' then
        PathfinderTools:showStats()
    else
        print("PF Error: Invalid command.")
    end
end