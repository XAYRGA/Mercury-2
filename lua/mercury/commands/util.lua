


Mercury.Commands.AddPrivilege("utest")
local function UTestPrivCheck(ply)
    return ply:HasPrivilege('utest')
end 



-- Noclip
local MCMD = Mercury.Commands.CreateTable("noclip", "", true, "<player>", true, false, true, "Fun")
function callfunc(caller, args)
    local target_player = nil
    if !args[1] then 
        target_player = caller 
    end

    if args[1] then
        if type(args[1])=="string" then 
            local plr = Mercury.Commands.PlayerLookup(args[1])
            if IsValid(plr) then 
                target_player = plr 
            end 
        elseif type(args[1])=="Player" then 
                target_player = args[1]


        end 

    end


    if IsValid(caller) then 
        if not caller:CanUserTarget(target_player) then 
                return false,"You cannot target this person."
        end

    end

    if !target_player or !IsValid(target_player) then 
        return false,"Could not find target."
    end

    target_player:ExitVehicle()
    
    if target_player:GetMoveType() == MOVETYPE_WALK then
        target_player:SetMoveType( MOVETYPE_NOCLIP )
    elseif target_player:GetMoveType() == MOVETYPE_NOCLIP then
        target_player:SetMoveType( MOVETYPE_WALK )
    else
        return false, target_player:Nick() .. " can't be noclipped right now", false, {}
    end


    if target_player == caller then
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " toggled noclip for themselves."}
    else
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " toggled noclip for ", target_player,  Mercury.Config.Colors.Default, "."}
    end
    return true, "", false, {}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
    
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)
               
    local NoclipButton = vgui.Create("DButton" , frame)
    NoclipButton:SetPos(240, 40)
    NoclipButton:SetText("Toggle Noclip")
    NoclipButton:SetSize(130, 60)
    NoclipButton:SetDisabled(true)
    NoclipButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("noclip")
            net.WriteTable({selectedplayer})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        NoclipButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)




-- Slay
MCMD = {
    ["Command"] = "slay",
    ["Verb"] = "slayed",
    ["RconUse"] = true,
    ["Useage"] = "slay <player>",
    ["UseImmunity"] =  true,
    ["HasMenu"] = true,
    ["Category"] = "Fun",
    ["UseCustomPrivCheck"] = false,
    ["PlayerTarget"] = true,
    ["AllowWildcard"] = true
}

function callfunc(caller, args)
    -- Caller is the player who issued the command.
    -- args is the string or player arguments that may have been passed.
    PrintTable(args)
    if not args[1] then
        return false, "No player was supplied to the command", false, {}
    end

    if args[1] and IsValid(args[1]) and args[1]:IsPlayer() then
        if args[1]:Alive() then
            args[1]:Kill()
        else
            return false, args[1]:Nick().." is already dead", false, {}
        end
    end

    return true, "", false, {}
end


function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)
               
    local SpawnButton = vgui.Create("DButton" , frame)
    SpawnButton:SetPos(240, 40)
    SpawnButton:SetText("Slay")
    SpawnButton:SetSize(130, 60)
    SpawnButton:SetDisabled(true)
    SpawnButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("slay")
            net.WriteTable({selectedplayer})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        SpawnButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)





-- Silent Slay
local MCMD = Mercury.Commands.CreateTable("sslay", "", true, "<player>", true, true, true, "Fun")
function callfunc(caller, args)
    -- Caller is the player who issued the command.
    -- args is the string or player arguments that may have been passed.
    
    if not args[1] then
        return false, "No player was supplied", false, {}
    end

    if args[1] and IsValid(args[1]) and args[1]:IsPlayer() then
        if args[1]:Alive() then
            args[1]:KillSilent()
        else
            return false, args[1]:Nick().." is already dead", false, {}
        end
    end

    return false, " "
end


function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)
               
    local SpawnButton = vgui.Create("DButton" , frame)
    SpawnButton:SetPos(240, 40)
    SpawnButton:SetText("Silent Slay")
    SpawnButton:SetSize(130, 60)
    SpawnButton:SetDisabled(true)
    SpawnButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("sslay")
            net.WriteTable({selectedplayer})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        SpawnButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)




Mercury.Commands.AddPrivilege("god")

local function GodPrivilegeCheck(ply)
    return ply:HasPrivilege("god")
end

-- Decals
local MCMD = Mercury.Commands.CreateTable("decals", "cleaned up the decals", true, "", true, false, true, "Utility")
function callfunc(caller,args)
    for k,v in pairs(player.GetAll()) do
        v:SendLua([[RunConsoleCommand("r_cleardecals")]])
    end
    
    return true, "heh", false, {}
end


function MCMD.GenerateMenu(frame)
    local selectedplayer = nil 

    local DButtonRmsel = vgui.Create( "DButton" , frame)
    DButtonRmsel:SetPos( 10, 0 )
    DButtonRmsel:SetText( "Clean decals" )
    DButtonRmsel:SetSize( 130, 60 )

    DButtonRmsel.DoClick = function(self)
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("decals")
            net.WriteTable({})
        net.SendToServer()
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Cleanup
local MCMD = Mercury.Commands.CreateTable("cleanup", "cleaned up", true, "<player>", true, true, true, "Utility")
function callfunc(caller,args)
    local target = args[1]
    local vm = target:GetViewModel( 0 ) 
    for k,v in pairs(ents.GetAll()) do
        if v:CPPIGetOwner()==target and v~=vm then
            if !v:IsPlayer() and !v:IsWeapon() then
                v:Remove()
            end
        end
    end

    return true, "heh", false, {}
end


function MCMD.GenerateMenu(frame)
    local selectedplayer = nil 

    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn( "Players" )
    ctrl:SetSize( 210, 380 )    
    ctrl:SetPos( 10, 0 )
    
    local DButtonRmsel = vgui.Create( "DButton" , frame)
    DButtonRmsel:SetPos( 240, 40 )
    DButtonRmsel:SetText( "CleanUp" )
    DButtonRmsel:SetSize( 130, 60 )
    DButtonRmsel:SetDisabled(true)
    DButtonRmsel.DoClick = function(self)
        if self:GetDisabled()==true then return false end
        local lid = ctrl:GetSelectedLine()
        ctrl:RemoveLine(lid)    
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("cleanup")
            net.WriteTable({selectedplayer})
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
        selectedplayer = line_obj.ply
        DButtonRmsel:SetDisabled(false)
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- God
local MCMD = Mercury.Commands.CreateTable("god", "enabled godmode for", true, "<player>", true, true, true, "Utility", true, GodPrivilegeCheck)
function callfunc(caller,args)
    args[1]:GodEnable()

    return true, "", false, {}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil 

    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn( "Players" )
    ctrl:SetSize( 210, 380 )    
    ctrl:SetPos( 10, 0 )
                
    local God = vgui.Create( "DButton" , frame)
    God:SetPos( 240, 40 )
    God:SetText("God")
    God:SetSize( 130, 20 )
    God:SetDisabled(true)
    God.DoClick = function(self)
        if self:GetDisabled()==true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("god")
            net.WriteTable({selectedplayer})
        net.SendToServer()
    end

    local UnGod = vgui.Create( "DButton" , frame)
    UnGod:SetPos( 240, 120 )
    UnGod:SetText("Ungod")
    UnGod:SetSize( 130, 20 )
    UnGod:SetDisabled(true)
    UnGod.DoClick = function(self)
        if self:GetDisabled()==true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("ungod")
            net.WriteTable({selectedplayer})
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
         UnGod:SetDisabled(false)
         God:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Ungod
local MCMD = Mercury.Commands.CreateTable("ungod", "disabled godmode for", true, "<player>", true, true, false, "Utility", true, GodPrivilegeCheck)
function callfunc(caller,args)
    args[1]:GodDisable()
    return true, "", false, {}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Force respawn
local MCMD = Mercury.Commands.CreateTable("spawn", "respawned", true, "<player>", true, true, true, "Utility")
function callfunc(caller,args)
    args[1]:Spawn() 
    return true, "", false, {Color(1,1,1,255),caller,Color(47,150,255,255)," respawned ", args[1]}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn( "Players" )
    ctrl:SetSize( 210, 380 )    
    ctrl:SetPos( 10, 0 )
               
    local SpawnButton = vgui.Create( "DButton" , frame)
    SpawnButton:SetPos( 240, 40 )
    SpawnButton:SetText( "Respawn" )
    SpawnButton:SetSize( 130, 60 )
    SpawnButton:SetDisabled(true)
    SpawnButton.DoClick = function(self)
        if self:GetDisabled()==true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("spawn")
            net.WriteTable({selectedplayer})
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
        SpawnButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end 
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Slay
MCMD = {
    ["Command"] = "motd",
    ["Verb"] = "motd'd",
    ["RconUse"] = true,
    ["Useage"] = "",
    ["UseImmunity"] =  false,
    ["HasMenu"] = false,
    ["Category"] = "Fun",
    ["UseCustomPrivCheck"] = true,
    ["PrivCheck"] = function() return true end,
    ["PlayerTarget"] = false,
    ["AllowWildcard"] = true
}

function callfunc(caller, args)
    caller:ConCommand("motd")
    return true, "", true, {}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


MCMD = {
    ["Command"] = "renderbender",
    ["Verb"] = "motd'd",
    ["RconUse"] = true,
    ["Useage"] = "",
    ["UseImmunity"] =  false,
    ["HasMenu"] = false,
    ["Category"] = "Fun",
    ["UseCustomPrivCheck"] = true,
    ["PrivCheck"] = function() return true end,
    ["PlayerTarget"] = false,
    ["AllowWildcard"] = true
}

function callfunc(caller, args)
    caller:ConCommand("renderbender")
    return true, "", true, {}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)



local cache = cache or {}

local function FormatTb( tab )
    local t = {}
    for k, v in pairs( tab ) do
        local time, cut = v.timechanged, 0
        local day, month, year
        cut = ( time:sub( 0, 2 ):find( " " ) and 3 ) or 4
        day = time:sub( 0, cut - 2 )
        month = string.sub( string.gsub( time:sub( cut, cut + 3 ), ",", "" ), 0, 3 )
        year = time:sub( cut + 5, cut + 8 ), " "
        year = year:find( " " ) and os.date( "%Y" ) or year
        t[v.newname] = { d = day, m = month, y = year }
    end
    
    return t
end

local function RetrieveAliases( ply,out ,bad)
    if cache[ply] then return cache[ply] end

    local function OnSuccess( body )
        out(util.JSONToTable( body ) )
    end
    
    local function OnFail( err )
        bad(err)
    end
    
    local URL = string.format( "http://steamcommunity.com/profiles/%s/ajaxaliases", ply:SteamID64() )
    http.Fetch( URL, OnSuccess, OnFail )
end



MCMD = {
    ["Command"] = "aliases",
    ["Verb"] = "motd'd",
    ["RconUse"] = true,
    ["Useage"] = "",
    ["UseImmunity"] =  false,
    ["HasMenu"] = false,
    ["Category"] = "Fun",
    ["UseCustomPrivCheck"] = false,
    ["PlayerTarget"] = true,
    ["AllowWildcard"] = true
}

function callfunc(caller, args)
    if !args[1] then 
        return false,{Mercury.Config.Colors.Error, "No player specified."}
    end 
    RetrieveAliases(args[1],function(ptab)
        local str = args[1]:Nick() .. " has gone by the following names: "
        for k,v in pairs(ptab) do 
           

            str = str .. "," .. v.newname 
        end
        Mercury.Util.SendMessage(caller,{Mercury.Config.Colors.Default,str})


    end,function(E) 
          Mercury.Util.SendMessage(caller,{Mercury.Config.Colors.Error,"Unable to grab aliases: ", E})
    end)

    if true then return false, {Mercury.Config.Colors.Default, " Aliases were requested. They will be posted in your chat as soon as they are received by the server. "}  end 
    return true, "", true, {}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)




-- Slay
MCMD = {
    ["Command"] = "revive",
    ["Verb"] = "revived",
    ["RconUse"] = true,
    ["Useage"] = "slay <player>",
    ["UseImmunity"] =  true,
    ["HasMenu"] = true,
    ["Category"] = "Fun",
    ["UseCustomPrivCheck"] = false,
    ["PlayerTarget"] = true,
    ["AllowWildcard"] = true
}

function callfunc(caller, args)
    -- Caller is the player who issued the command.
    -- args is the string or player arguments that may have been passed.

    if not args[1] then
        return false, "No player was supplied to the command", false, {}
    end

    if args[1] and IsValid(args[1]) and args[1]:IsPlayer() then
        if args[1]:Alive() then
            return false, {args[1]," is already alive."} , false, {}
        else
            local cp = args[1]:GetPos()
            args[1]:Spawn()
            args[1]:SetPos(cp)
        end
    end

    return true, "", false, {}
end


function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)
               
    local SpawnButton = vgui.Create("DButton" , frame)
    SpawnButton:SetPos(240, 40)
    SpawnButton:SetText("Revive")
    SpawnButton:SetSize(130, 60)
    SpawnButton:SetDisabled(true)
    SpawnButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("revive")
            net.WriteTable({selectedplayer})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        SpawnButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


hook.Add("PlayerLeaveVehicle","Mercury_BackSeat",function(P,V)
    P.MercuryLastVehicle = V

end)


-- Slay
MCMD = {
    ["Command"] = "unseat",
    ["Verb"] = "unsat",
    ["RconUse"] = true,
    ["Useage"] = "slay <player>",
    ["UseImmunity"] =  true,
    ["HasMenu"] = false,
    ["Category"] = "Fun",
    ["UseCustomPrivCheck"] = false,
    ["PlayerTarget"] = true,
    ["AllowWildcard"] = true
}

function callfunc(caller, args)
    -- Caller is the player who issued the command.
    -- args is the string or player arguments that may have been passed.

    if not args[1] then
        return false, "No player was supplied to the command", false, {}
    end
    args[1]:ExitVehicle()

    return true, "", false, {caller, Mercury.Config.Colors.Default, " has sent " , args[1] , " to their last seat."}
end

Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)



-- Slay
MCMD = {
    ["Command"] = "backseat",
    ["Verb"] = "backseat'd",
    ["RconUse"] = true,
    ["Useage"] = "slay <player>",
    ["UseImmunity"] =  true,
    ["HasMenu"] = true,
    ["Category"] = "Fun",
    ["UseCustomPrivCheck"] = false,
    ["PlayerTarget"] = true,
    ["AllowWildcard"] = true
}

function callfunc(caller, args)
    -- Caller is the player who issued the command.
    -- args is the string or player arguments that may have been passed.

    if not args[1] then
        return false, "No player was supplied to the command", false, {}
    end

    if args[1] and IsValid(args[1]) and args[1]:IsPlayer() then
        if args[1].MercuryLastVehicle and IsValid(args[1].MercuryLastVehicle ) then 
            args[1]:EnterVehicle(args[1].MercuryLastVehicle )
        else 
            return false,"Your last seat no longer exists."
        end 
    end

    return true, "", true, {caller, Mercury.Config.Colors.Default, " has sent " , args[1] , " to their last seat."}
end


function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)
               
    local SpawnButton = vgui.Create("DButton" , frame)
    SpawnButton:SetPos(240, 40)
    SpawnButton:SetText("Backseat")
    SpawnButton:SetSize(130, 60)
    SpawnButton:SetDisabled(true)
    SpawnButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("backseat")
            net.WriteTable({selectedplayer})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        SpawnButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


MCMD = {}
MCMD.Command = "mercury_utest_error_handler"
MCMD.Verb = "tested the error handling system"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = UTestPrivCheck




function callfunc(caller,args)
    this_function_doesnt_exist()

    return true,"",false,{} //RETURN CODES.
end


function MCMD.GenerateMenu(frame)

end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)
