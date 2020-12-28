PathfinderTools = { }

function PathfinderTools:getTargetPlayer()
    if UnitName("Target") ~= nil and UnitIsPlayer("Target") then
        name = UnitName("Target")
        return name
    else
        print("PF Error: Target is not a player.")
        return nil
    end
end

function PathfinderTools:playerSelection(name)
    if name == nil or name == "" then
        name = PathfinderTools:getTargetPlayer()
    end
    return name
end

function PathfinderTools:Recruit(name)
    player = PathfinderTools:playerSelection(name)
    
    if UnitIsUnit(player,"player") then
        print("PF Error: You can't recruit yourself....")
    elseif player ~= nil then 
        SendChatMessage("Hello "..player..", would you be interested in joining a leveling guild? We're a light hearted group looking for more people interested in quest and dungeon parties.", "WHISPER", "Common", player)
    end
end

function PathfinderTools:Welcome(name)
    player = PathfinderTools:playerSelection(name)

    if UnitIsUnit(player,"player") then
        print("PF Error: You can't welcome yourself....")
    elseif player ~= nil then
        SendChatMessage("Welcome "..player,"GUILD","Common",nil)
        SendChatMessage("So the guild is currently in open recruitment. This means that everyone can recruit and that you should feel free to /ginvite people you meet in your travels who could benifit from guild membership.","WHISPER","Common",player)
        SendChatMessage("We try to organize dungeon runs in the evenings and weekends so watch out for those. Also we have a shiny new Discord server, link in the MOTD, which you can check out if you are interested.","WHISPER","Common",player)
    end
end

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")

SLASH_PF1 = '/pf'
function SlashCmdList.PF(args, editbox)
    local _, _, cmd, arg = string.find(args, "%s?(%w+)%s?(.*)")

    --print(cmd.." : "..args)

    if cmd == 'recruit' then
        PathfinderTools:Recruit(arg)
    elseif cmd == 'welcome' then
        PathfinderTools:Welcome(arg)
    else
        print("PF Error: Invalid command.")
    end
end