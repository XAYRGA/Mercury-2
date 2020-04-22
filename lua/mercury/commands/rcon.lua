-- Rcon
local MCMD = Mercury.Commands.CreateTable("rcon", "", true, "<script>", true, false, true, "Rcon")
function callfunc(caller,args)
    if not args[1] then return false, "No arguement was specified" end
    Mercury.Util.SendMessage(caller,{Color(1,1,1),"[SILENT] ",caller,Color(47,150,255,255), " ran ", Color(255,255,255) , table.concat(args," ") ,Color(47,150,255,255), " on " , Color(1,1,1), "[SERVER]"})
    if SERVER then
                RunConsoleCommand(unpack(args))
    end
    return false," "
end

function MCMD.GenerateMenu(frame)
    local script_string = nil

    local Script = vgui.Create("DTextEntry", frame)
    Script:SetPos(10, 40)
    Script:SetSize(360, 20)
    Script:SetText("")
    Script:SelectAllOnFocus()
    Script:SetMultiline(false)
    Script:SetEnterAllowed(false)

    local Button = vgui.Create("DButton" , frame)
    Button:SetPos(115, 70)
    Button:SetText("Run rcon")
    Button:SetSize(130, 20)
    Button.DoClick = function(self)
        surface.PlaySound("buttons/button3.wav")
        local script_string = Script:GetValue()
        net.Start("Mercury:Commands")
            net.WriteString("rcon")
            net.WriteTable(string.Explode(" ",script_string))
        net.SendToServer()
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Cexec
MCMD = {
    ["Command"] = "cexec",
    ["Verb"] = "ran",
    ["RconUse"] = true,
    ["Useage"] = "cexec <player> <command>",
    ["UseImmunity"] =  true,
    ["HasMenu"] = true,
    ["Category"] = "Rcon",
    ["PlayerTarget"] = true,
    ["AllowWildcard"] = true
}

function callfunc(caller,args)
    local comstring = table.concat(args," ",2)
    args[1]:ConCommand(comstring)

    return true, "", true, {caller, Color(47,150,255,255), " ran ", Color(255,255,255), comstring, Color(47,150,255,255), " on ", Color(47,150,255,255), args[1]} 
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil 
    local script_string = nil

    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn( "Players" )
    ctrl:SetSize( 210, 380 )    
    ctrl:SetPos( 10, 0 )

    local Script = vgui.Create("DTextEntry", frame)
    Script:SetPos(240, 40)
    Script:SetSize(130, 20)
    Script:SetText("")
    Script:SelectAllOnFocus()
    Script:SetMultiline(false)
    Script:SetEnterAllowed(false)

    local Button = vgui.Create("DButton" , frame)
    Button:SetPos(240, 70)
    Button:SetText("Run cexec")
    Button:SetSize(130, 60)
    Button:SetDisabled(true)
    Button.DoClick = function(self)
        surface.PlaySound("buttons/button3.wav")
        local script_string = Script:GetValue()
        net.Start("Mercury:Commands")
            net.WriteString("cexec")
            net.WriteTable({selectedplayer, script_string})
        net.SendToServer()
    end

    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end 

    function ctrl:OnRowSelected(lineid,isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        Button:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)



-- Cexec
MCMD = {
    ["Command"] = "$$rebootsv",
    ["Verb"] = "ran",
    ["RconUse"] = true,
    ["Useage"] = "!reboot",
    ["UseImmunity"] =  true,
    ["HasMenu"] = false,
    ["Category"] = "Rcon",
    ["PlayerTarget"] = false,
    ["AllowWildcard"] = false
}
 
function callfunc(caller,args)
    include("autorun/mercury_entrypoint.lua")
    return true, "", true, {caller, Color(47,150,255,255), " restarted " , Mercury.Config.Colors.Server,"Mercury."} 
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


-- lua run
local MCMD = Mercury.Commands.CreateTable("luarun", "", true, "<script>", true, false, true, "Rcon")
function callfunc(caller,args)

    if type(caller)=="Player" then 

        
        ptrace = caller:GetEyeTraceNoCursor()
        that = ptrace.Entity
        there = ptrace.HitPos 
        me = caller

    end 
    local comstring = table.concat(args," ",1)
    
    Mercury.Util.SendMessage(caller,{Color(1,1,1),"[SILENT] ",caller,Color(47,150,255,255), " ran ", Color(255,255,255) , comstring} )
    RunString(comstring)

    return false, " "
end

function MCMD.GenerateMenu(frame)
    local script_string = nil

    local Script = vgui.Create("DTextEntry", frame)
    Script:SetSize(360, 330)    
    Script:SetPos(10, 0)
    Script:SetText("")
    Script:SelectAllOnFocus()
    Script:SetMultiline(true)
    Script:SetEnterAllowed(false)
    Script:SetEditable(true)
    Script:SetTabbingDisabled(true)

    local Button = vgui.Create("DButton" , frame)
    Button:SetPos(115, 335)
    Button:SetText("Run Lua")
    Button:SetSize(130, 60)
    Button:SetDisabled(false)
    Button.DoClick = function(self)
        surface.PlaySound("buttons/button3.wav")
        local script_string = Script:GetValue()

        net.Start("Mercury:Commands")
            net.WriteString("luarun")
            net.WriteTable({script_string})
        net.SendToServer()
    end
    
    Script.OldKP = Script.OnKeyCodeTyped
    function Script:OnKeyCodeTyped(I)
        if I==67 then             
            local tx = self:GetText()
            local rm = self:GetCaretPos()
            local len = #self:GetText() 
            local ostring = string.sub(tx,0,rm)
            local istring  = string.sub(tx,rm + 1,rm  +  (len - rm) )
            local nstring = ostring .. "     "  .. istring

            self:SetText(nstring)
            self:SetCaretPos(#ostring + 5)
        end

        self:OldKP(I)
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Changelevel
local MCMD = Mercury.Commands.CreateTable("changelevel", "change the map", true, "<map>", true, false, true, "Rcon")
function callfunc(caller,args)
    if !args[1] then return false,"No map specified." end
    if !file.Exists("maps/" .. args[1] .. ".bsp","GAME") then return false,"Map does not exist." end

    RunConsoleCommand("changelevel",unpack(args))

    return true, "", false, {}
end

function MCMD.GenerateMenu(frame)
    local map = nil
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn( "Maps" )
    ctrl:SetSize( 210, 380 )    
    ctrl:SetPos( 10, 0 )

    local Button = vgui.Create("DButton" , frame)
    Button:SetPos(240, 70)
    Button:SetText("Change map")
    Button:SetSize(130, 20)
    Button:SetDisabled(true)
    Button.DoClick = function(self)
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("changelevel")
            net.WriteTable({map})
        net.SendToServer()
    end

    -- get the maps
    local maps = {}
    for _, map in ipairs(file.Find( "maps/*.bsp", "GAME" )) do
        table.insert(maps, map:sub( 1, -5 ):lower())
    end

    -- alphabetize the table
    table.sort(maps)

    -- Populate the list of maps
    local t = {}
    for _, map in ipairs(maps) do
        local item = ctrl:AddLine(tostring(map))
        item.mapname = map
    end 


    function ctrl:OnRowSelected(lineid,isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        Button:SetDisabled(false)
        map = line_obj.mapname
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

--/////////////////////////////////////
local MCMD = Mercury.Commands.CreateTable("votemap", "voted for map", true, "<map>", false, false, false, "Rcon")
local VM_CHANGING = false
local VOTEMAP_VOTES = {}
local VOTEMAP_MAPS = file.Find("maps/*.bsp","GAME")
local VOTEMAP_BLACKLIST = Mercury.Config.VotemapBlacklist or {}
for k,v in pairs(VOTEMAP_MAPS) do
    VOTEMAP_MAPS[k] = string.sub(v,0,#v - 4 )
end

for k,v in pairs(VOTEMAP_BLACKLIST) do
    for i,map in pairs(VOTEMAP_MAPS) do
        if map==v then 
            VOTEMAP_MAPS[i] = nil 
        end
    end
end

function callfunc(caller,args)
    if VM_CHANGING==true then 
        return false,"The map is already changing! No further votes can be made."
    end
    if !args[1] then 
        return false,"No argument specified. Please specify a number or 'list' for maps. eg. !votemap list"
    end
    local TVOTES_NEEDED = math.ceil(#player.GetAll() / 2)
    if args[1]=="list" then 
        if !IsValid(caller) then 
            for k,v in pairs(VOTEMAP_MAPS) do 
                print(k,"=",v)
            end
        else 
            for k,v in pairs(VOTEMAP_MAPS) do
                caller:PrintMessage( HUD_PRINTCONSOLE, k .. " \t " .. "= \t " .. v )
            end
        end
        return false,"Maps list printed in your console."
    end

    local map = tonumber(args[1])

    if VOTEMAP_MAPS[map] then 
        if !VOTEMAP_VOTES[map] then 
            VOTEMAP_VOTES[map] = {}
        end
        for k,v in pairs(VOTEMAP_VOTES[map]) do
            if v==caller then 
                return false,"You have already voted for this map!"
            end
        end
        VOTEMAP_VOTES[map][#VOTEMAP_VOTES[map] + 1] = caller 
    else 
        return false,"Map didn't exist, check the number beside your map in !votemap list"
    end
    PrintTable(VOTEMAP_VOTES)
    timer.Simple(0,function()
        for id,votes in pairs(VOTEMAP_VOTES) do
            local mymap = VOTEMAP_MAPS[id]
            local tvotes = 0
            for k,ply in pairs(votes) do
                if IsValid(ply) then 
                    tvotes = tvotes + 1
                end
            end
            if tvotes >= TVOTES_NEEDED then 
                Mercury.Util.Broadcast({Mercury.Config.Colors.Default,"The map will be changed to " , Mercury.Config.Colors.Arg, mymap , Mercury.Config.Colors.Default, " in ",Mercury.Config.Colors.Arg, "30 seconds"})

                
                VM_CHANGING = true 
                timer.Create("VoteMapChangeLevel",30,1,function()
                    game.ConsoleCommand("changelevel " .. mymap .. "\n" )
                end)
            end
        end
    end)

    return true, "", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has voted for map ", Mercury.Config.Colors.Arg, VOTEMAP_MAPS[map] , "[" .. #VOTEMAP_VOTES[map] .. "/" .. TVOTES_NEEDED .. "]"}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)   