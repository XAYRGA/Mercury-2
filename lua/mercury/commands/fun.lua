Mercury.Commands.AddPrivilege("physgunpickup")

if SERVER then 
    local function PlayerPickup( ply, ent )
        if ply:HasPrivilege("physgunpickup") and ent:GetClass():lower() == "player" then
            if ply:CanUserTarget(ent) then
                ent:SetGravity(0.00001)

                return true

            else 
                return false
            end
        end
    end
    hook.Add( "PhysgunPickup", "MercuryPhysgunPickup", PlayerPickup )


     local function PlayerPickup( ply, ent )
        if ply:HasPrivilege("physgunpickup") and ent:GetClass():lower() == "player" then
            if ply:CanUserTarget(ent) then
                ent:SetGravity(1)
                return true

            else 
                return false
            end
        end
    end
    hook.Add( "PhysgunDrop", "MercuryPhysgunDrop", PlayerPickup )
end

-------------------------
--// Local Functions //--
-------------------------
local function DoInvisible()
    local players = player.GetAll()
    local remove = true
    for _, player in ipairs( players ) do
        local t = player:GetTable()
        if t.invis then
            remove = false
            if player:Alive() and player:GetActiveWeapon():IsValid() then
                if player:GetActiveWeapon() ~= t.invis.wep then

                    if t.invis.wep and IsValid( t.invis.web ) then      -- If changed weapon, set the old weapon to be visible.
                        t.invis.wep:SetRenderMode( RENDERMODE_NORMAL )
                        t.invis.wep:Fire( "alpha", 255, 0 )
                        t.invis.wep:SetMaterial( "" )
                    end

                    t.invis.wep = player:GetActiveWeapon()
                    Mercury.Invisible(player, true, t.invis.vis)
                end
            end
        end
    end

    if remove then
        hook.Remove( "Think", "InvisThink" )
    end
end

function Mercury.Invisible( ply, bool, visibility )
    if not ply:IsValid() then return end -- This is called on a timer so we need to verify they're still connected

    if bool == true then
        visibility = visibility or 0
        ply:DrawShadow( false )
        ply:SetRenderMode( RENDERMODE_TRANSALPHA )
        ply:Fire( "alpha", visibility, 0 )
        ply:GetTable().invis = { vis=visibility, wep=ply:GetActiveWeapon() }

        if IsValid( ply:GetActiveWeapon() ) then
            ply:GetActiveWeapon():SetRenderMode( RENDERMODE_TRANSALPHA )
            ply:GetActiveWeapon():Fire( "alpha", visibility, 0 )
            ply:GetActiveWeapon():SetMaterial( "models/effects/vol_light001" )
            if ply:GetActiveWeapon():GetClass() == "gmod_tool" then
                ply:DrawWorldModel( false ) -- tool gun has problems
            else
                ply:DrawWorldModel( true )
            end
        end

        hook.Add( "Think", "InvisThink", DoInvisible )
    else
        ply:DrawShadow( true )
        ply:SetMaterial( "" )
        ply:SetRenderMode( RENDERMODE_NORMAL )
        ply:Fire( "alpha", 255, 0 )
        local activeWeapon = ply:GetActiveWeapon()
        if IsValid( activeWeapon ) then
            activeWeapon:SetRenderMode( RENDERMODE_NORMAL )
            activeWeapon:Fire( "alpha", 255, 0 )
            activeWeapon:SetMaterial( "" )
        end
        ply:GetTable().invis = nil
    end
end

-------------------------
--//  The  commands  //--
-------------------------

-- Explode
local MCMD = Mercury.Commands.CreateTable("explode", "exploded", true, "<player>", true, true, true, "Fun")


function callfunc(caller,args)



	local ply = args[1]
	local rmtab = {}

    if !ply._MercuryExplodeCount then 
        ply._MercuryExplodeCount = 0
    end
    if !ply._MercuryExplodeTimeout then 
        ply._MercuryExplodeTimeout = CurTime() + 10
    end

    if ply._MercuryExplodeCount > 2 then 
        if CurTime() < ply._MercuryExplodeTimeout then 
            return false,{"You're executing this command too fast. (" .. math.Round( ply._MercuryExplodeTimeout - CurTime() ) .. ")"}            
        elseif CurTime() > ply._MercuryExplodeTimeout then 
            ply._MercuryExplodeTimeout = CurTime() + 10
            ply._MercuryExplodeCount = 0
        end
    end

    ply._MercuryExplodeCount = ply._MercuryExplodeCount + 1


	ply:EmitSound("items/cart_explode_falling.wav",150)
    ply:SetPos(ply:GetPos() + Vector(0,0,10))
    ply:SetVelocity(Vector(0,0,99999))
    timer.Simple(0.2,function() 
        ply:Kill()

        ply:EmitSound("items/cart_explode.wav")

              local explosive = ents.Create( "env_explosion" )
                        explosive:SetPos( ply:GetPos() )
                        explosive:SetOwner( ply )
                        explosive:Spawn()
                        explosive:SetKeyValue( "iMagnitude", "1" )
                        explosive:Fire( "Explode", 0, 0 )

        for I=1,6 do
            rmtab[I] = ents.Create("prop_physics")
            rmtab[I]:SetModel("models/Roller.mdl")
            rmtab[I]:SetPos(ply:GetPos() + Vector(math.random(-50,50) ,math.random(-50,50) ,math.random(-50,50)))
            rmtab[I]:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
            rmtab[I]:Spawn()
            local trail = util.SpriteTrail(rmtab[I], 0, Color(math.random(1,255) ,math.random(1,255) ,math.random(1,255) ), false, 15, 1, 10, 3, "trails/plasma.vmt")
            rmtab[I]:GetPhysicsObject():SetVelocityInstantaneous(Vector(math.random(-1000,1000) ,math.random(-1000,1000) ,1000))
        end
        timer.Simple(10,function()
            for k,v in pairs(rmtab) do
                if v and IsValid(v) then v:Remove() end
            end

        end)    
    end)

	return true,"",false,{}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn( "Players" )
    ctrl:SetSize( 210, 380 )    
    ctrl:SetPos( 10, 0 )
               
    local Button = vgui.Create( "DButton" , frame)
    Button:SetPos( 240, 40 )
    Button:SetText( "Explode" )
    Button:SetSize( 130, 60 )
    Button:SetDisabled(true)
    Button.DoClick = function(self)
        if self:GetDisabled()==true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("explode")
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
        Button:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end 
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


local MCMD = Mercury.Commands.CreateTable("explode2", "exploded", true, "<player>", true, true, true, "Fun")
MCMD.AllowWildcard = true

function callfunc(caller,args)

    local ply = args[1]



    ply:SetPos(ply:GetPos() + Vector(0,0,10))
    ply:SetVelocity(Vector(0,0,500) + ply:GetVelocity() * 0.3)


        ply:EmitSound("mvm/mvm_tank_explode.wav",50,math.random(50,150))

              local explosive = ents.Create( "env_explosion" )
                        explosive:SetPos( ply:GetPos() )
                        explosive:SetOwner( ply )
                        explosive:Spawn()
                        explosive:SetKeyValue( "iMagnitude", "1" )
                        explosive:Fire( "Explode", 0, 0 )
                ply:Kill()


    return true,"",false,{}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn( "Players" )
    ctrl:SetSize( 210, 380 )    
    ctrl:SetPos( 10, 0 )
               
    local Button = vgui.Create( "DButton" , frame)
    Button:SetPos( 240, 40 )
    Button:SetText( "Explode 2" )
    Button:SetSize( 130, 60 )
    Button:SetDisabled(true)
    Button.DoClick = function(self)
        if self:GetDisabled()==true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("explode2")
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
        Button:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end 
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)




-- Slap
local MCMD = Mercury.Commands.CreateTable("slap", "", true, "<player> <damage>", true, true, true, "Fun")
function callfunc(caller, args)
    local target_player = nil
    local damage = args[2] or 0
    local sSounds = {
        "physics/body/body_medium_impact_hard1.wav",
        "physics/body/body_medium_impact_hard2.wav",
        "physics/body/body_medium_impact_hard3.wav",
        "physics/body/body_medium_impact_hard5.wav",
        "physics/body/body_medium_impact_hard6.wav",
        "physics/body/body_medium_impact_soft5.wav",
        "physics/body/body_medium_impact_soft6.wav",
        "physics/body/body_medium_impact_soft7.wav",
    }

    if not args[1] then return false, "No target player was defined." end


    if IsValid(args[1]) and args[1]:IsPlayer() then 
        if not args[1]:Alive() then return end
        args[1]:ExitVehicle()
        if args[1]:GetMoveType() == MOVETYPE_NOCLIP then
            args[1]:SetMoveType(MOVETYPE_WALK)
        end

        args[1]:EmitSound(sSounds[math.random(#sSounds)])
        
        local direction = Vector(math.random(20) - 10, math.random(20) - 10, math.random(20) - 5)
        local accel = direction * 50
        args[1]:SetPos(args[1]:GetPos() + Vector(0,0,8))
        args[1]:SetVelocity(accel)

        -- Angular punch
        local angle_punch_pitch = math.Rand( -20, 20 )
        local angle_punch_yaw = math.sqrt( 20*20 - angle_punch_pitch * angle_punch_pitch )
        if math.random( 0, 1 ) == 1 then
            angle_punch_yaw = angle_punch_yaw * -1
        end
        args[1]:ViewPunch(Angle(angle_punch_pitch, angle_punch_yaw, 0))

        -- Deal with their health
        local newHp = args[1]:Health() - damage
        if newHp <= 0 then
            if args[1]:IsPlayer() then
                args[1]:Kill()
            end
        else
            -- Set the new health
            args[1]:SetHealth(newHp)
        end
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " slapped ", args[1], " for ", Mercury.Config.Colors.Arg, tostring( damage ), Mercury.Config.Colors.Default, " damage."}
    end
    
    -- Finish!
    return true, "", false, {}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)

    local Damage = vgui.Create("DTextEntry", frame)
    Damage:SetPos(240, 20)
    Damage:SetSize(130, 20)
    Damage:CheckNumeric(true)
    Damage:SetText("Damage")
    Damage:SetEnterAllowed(false)
               
    local SlapButton = vgui.Create("DButton" , frame)
    SlapButton:SetPos(240, 40)
    SlapButton:SetText("Slap")
    SlapButton:SetSize(130, 60)
    SlapButton:SetDisabled(true)
    SlapButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        local damage = nil
        local IsNumeric = true
        local DamageVal = Damage:GetValue()
        for i=1, #DamageVal do
            if (string.byte(DamageVal[i]) >= 48 and string.byte(DamageVal[i]) <= 57) then
                continue
            else
                IsNumeric = false
                break
            end
        end
        if IsNumeric == true then damage = DamageVal end

        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("slap")
            net.WriteTable({selectedplayer, damage})
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
        SlapButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Cloak
local MCMD = Mercury.Commands.CreateTable("cloak", "", true, "<player> <amount>", true, true, true, "Fun")
function callfunc(caller, args)
    local amount = 0
    if !args[2] then amount = 255 else amount = args[2] end
    Mercury.Invisible(args[1], true, amount)
    return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " cloaked ", args[1],  Mercury.Config.Colors.Default, " by amount ", Mercury.Config.Colors.Arg, amount}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
    local cloak_amount = 0
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)

    local NumSlider = vgui.Create("DNumSlider", frame)
    NumSlider:SetPos(230, 15)
    NumSlider:SetWide(150)
    NumSlider:SetText("Amount")
    NumSlider:SetMinMax(0, 255)
    NumSlider:SetDecimals(0)
    NumSlider:SetValue(0)
                        
    local Button = vgui.Create("DButton" , frame)
    Button:SetPos(230, 40)
    Button:SetText("Cloak")
    Button:SetSize(150, 20)
    Button:SetDisabled(true)
    Button.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        cloak_amount = NumSlider:GetValue()
        print(cloak_amount)
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("cloak")
            net.WriteTable({selectedplayer, cloak_amount})
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
        Button:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Uncloak
local MCMD = Mercury.Commands.CreateTable("uncloak", "uncloaked", true, "<player>", true, true, true, "Fun")
MCMD.Command = "uncloak"
MCMD.Verb = "uncloaked"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = true
MCMD.Category = "Fun" 
 
function callfunc(caller, args)
    if !args[2] then args[2] = 255 end 
    Mercury.Invisible(args[1], false, 255)
    return true, "", false,{}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)
               
    local Button = vgui.Create("DButton" , frame)
    Button:SetPos(240, 40)
    Button:SetText("Uncloak")
    Button:SetSize(130, 60)
    Button:SetDisabled(true)
    Button.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("uncloak")
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
        Button:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Jail
local jailstuff = {}
timer.Create("JailRemove",0.8,0,function()
    for k,v in pairs(jailstuff) do
        if !IsValid(v["player"]) then 
            for o,ent in pairs(v["jail"]) do
                if IsValid(ent) then 
                    ent:Remove()
                end
            end
        end
    end
end)

local MCMD = Mercury.Commands.CreateTable("jail", "", true, "<player> <time>", true, true, false, "Fun")
function callfunc(caller, args)
    local ply = nil
    local time = 999999
    local Jail = {
        { pos = Vector( 0, 0, -5 ), ang = Angle( 90, 0, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( 0, 0, 97 ), ang = Angle( 90, 0, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( 21, 31, 46 ), ang = Angle( 0, 90, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( 21, -31, 46 ), ang = Angle( 0, 90, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( -21, 31, 46 ), ang = Angle( 0, 90, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( -21, -31, 46), ang = Angle( 0, 90, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( -52, 0, 46 ), ang = Angle( 0, 0, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( 52, 0, 46 ), ang = Angle( 0, 0, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
    }

    if args[1] then ply = args[1] else return false, "No target player was specified." end
    if args[2] then time = tonumber(args[2]) end


    if IsValid(ply) and ply:IsPlayer() and not ply.IsJailed then 
        ply:ExitVehicle()
        -- Construct the jail
        ply.IsJailed = true
        ply.JailWalls = {}
        local jailtab = {}
        for _, info in ipairs(Jail) do
            local ent = ents.Create("prop_physics")
            ent:SetModel(info.mdl)
            ent:SetPos(ply:GetPos() + info.pos)
            ent:SetAngles(info.ang)
            ent:Spawn()
            ent:GetPhysicsObject():EnableMotion(false)
            ent:SetMoveType(MOVETYPE_NONE)
            ent.jailWall = true
            jailtab[#jailtab + 1] = ent
            table.insert(ply.JailWalls, ent)
        end

        jailstuff[#jailstuff + 1 ] = {player = ply, jail = jailtab}

        timer.Create("Mercury:JailedPlayer:"..ply:UniqueID(), time, 1, function()
            if IsValid(ply) and ply.IsJailed == true then
                ply.IsJailed = nil
                for k,v in pairs(jailstuff) do 
                    if v["player"]==ply then 
                        table.remove(jailstuff,k)
                    end
                end
                for _, ent in ipairs(ply.JailWalls) do
                    if ent:IsValid() then
                        ent:Remove()
                    end
                end
            end
        end, ply)
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " has jailed ", args[1], " for ", Mercury.Config.Colors.Arg, time, Mercury.Config.Colors.Default, " seconds."}
    elseif IsValid(ply) and ply:IsPlayer() and ply.IsJailed == true then 
        return false, ply:Nick().." is already jailed."
    end
    
    -- Finish!
    return true, "", false, {}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- UnJail
local MCMD = Mercury.Commands.CreateTable("unjail", "", true, "<player>", true, true, false, "Fun")
function callfunc(caller, args)
    local ply = nil
    if args[1] then ply = args[1] else return false, "No target player was specified." end


    if IsValid(ply) and ply:IsPlayer() and ply.IsJailed == true then 
        -- Construct the jail
        ply.IsJailed = nil
        for _, ent in ipairs(ply.JailWalls) do
            if ent:IsValid() then
                ent:Remove()
            end
        end
          for k,v in pairs(jailstuff) do 
                    if v["player"]==ply then 
                        table.remove(jailstuff,k)
                    end
          end
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " has unjailed ", args[1], Mercury.Config.Colors.Default, "."}
    elseif IsValid(ply) and ply:IsPlayer() and not ply.IsJailed then 
        return false, ply:Nick().." is not jailed."
    end
    
    -- Finish!
    return true, "", false, {}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- HP
MCMD = {
    ["Command"] = "hp",
    ["Verb"] = "asd",
    ["RconUse"] = true,
    ["Useage"] = "hp <player> <amount>",
    ["UseImmunity"] =  true,
    ["HasMenu"] = true,
    ["Category"] = "Fun",
    ["PlayerTarget"] = true,
    ["AllowWildcard"] = true
}

function callfunc(caller, args)
    if not args[1] then return false, "No target player was specified." end
    if not args[2] or !tonumber(args[2])  then return false, "No health amount was specified." end

    if IsValid(args[1]) and args[1]:IsPlayer() then 
        -- Set the new health
        local health = tonumber(args[2])
        args[1]:SetHealth(health)
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " has set the hp of ", args[1], " to ", Mercury.Config.Colors.Arg, health, Mercury.Config.Colors.Default, "."}
    end
    
    -- Finish!
    return true, "", false, {}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil

    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)

    local HP = vgui.Create("DTextEntry", frame)
    HP:SetPos(240, 20)
    HP:SetSize(130, 20)
    HP:CheckNumeric(true)
    HP:SetText("Amount")
    HP:SetEnterAllowed(false)
               
    local HPButton = vgui.Create("DButton" , frame)
    HPButton:SetPos(240, 40)
    HPButton:SetText("Set Health")
    HPButton:SetSize(130, 60)
    HPButton:SetDisabled(true)
    HPButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        local health = 100
        local IsNumeric = true
        local hpVal = HP:GetValue()
        for i=1, #hpVal do
            if (string.byte(hpVal[i]) >= 48 and string.byte(hpVal[i]) <= 57) then
                continue
            else
                IsNumeric = false
                break
            end
        end
        if IsNumeric == true then health = hpVal end

        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("hp")
            net.WriteTable({selectedplayer, health})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs(players) do
        local item = ctrl:AddLine(ply:Nick())
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        HPButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

--Armor
local MCMD = Mercury.Commands.CreateTable("armor", "", true, "<player> <amount>", true, true, true, "Fun")


MCMD = {
    ["Command"] = "armor",
    ["Verb"] = "asd",
    ["RconUse"] = true,
    ["Useage"] = "armor <player> <amount>",
    ["UseImmunity"] =  true,
    ["HasMenu"] = true,
    ["Category"] = "Fun",
    ["PlayerTarget"] = true,
    ["AllowWildcard"] = true
}


function callfunc(caller, args)
    if not args[1] then return false, "No target player was specified." end
    if not args[2] or !tonumber(args[2])  then return false, "@SYNTAX_ERR" end
    if tonumber(args[2]) > 255 then args[2] = 255 end

    if IsValid(args[1]) and args[1]:IsPlayer() then 
        -- Set the new armor
        local armor = tonumber(args[2])
        if !armor then 
            return  false,"@SYNTAX_ERR"
        end
        args[1]:SetArmor(armor)
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " has set the armor of ", args[1], " to ", Mercury.Config.Colors.Arg, args[2], Mercury.Config.Colors.Default, "."}
    end
    
    -- Finish!
    return true, "", false, {}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil

    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)

    local Armor = vgui.Create("DTextEntry", frame)
    Armor:SetPos(240, 20)
    Armor:SetSize(130, 20)
    Armor:CheckNumeric(true)
    Armor:SetText("Amount")
    Armor:SetEnterAllowed(false)
               
    local ArmorButton = vgui.Create("DButton" , frame)
    ArmorButton:SetPos(240, 40)
    ArmorButton:SetText("Set Health")
    ArmorButton:SetSize(130, 60)
    ArmorButton:SetDisabled(true)
    ArmorButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        local armor = 0
        local IsNumeric = true
        local armorVal = Armor:GetValue()
        for i=1, #armorVal do
            if (string.byte(armorVal[i]) >= 48 and string.byte(armorVal[i]) <= 57) then
                continue
            else
                IsNumeric = false
                break
            end
        end
        if IsNumeric == true then armor = armorVal end

        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("armor")
            net.WriteTable({selectedplayer, armor})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs(players) do
        local item = ctrl:AddLine(ply:Nick())
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        ArmorButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)




MCMD = {
    ["Command"] = "gravity",
    ["Verb"] = "asd",
    ["RconUse"] = true,
    ["Useage"] = "<player> <amount>",
    ["UseImmunity"] =  true,
    ["HasMenu"] = true,
    ["Category"] = "Fun",
    ["PlayerTarget"] = true,
    ["AllowWildcard"] = true
}


function callfunc(caller, args)
    if not args[1] then return false, "No target player was specified." end
    if not args[2] or !tonumber(args[2])  then return false, "@SYNTAX_ERR" end
    if tonumber(args[2]) > 255 then args[2] = 255 end

    if IsValid(args[1]) and args[1]:IsPlayer() then 
        -- Set the new armor
        local armor = tonumber(args[2])
        if armor == 0 then armor = 0.00001 end
        if !armor then 
            return  false,"@SYNTAX_ERR"
        end
        args[1]:SetGravity(armor)
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " has set the gravity of ", args[1], " to ", Mercury.Config.Colors.Arg, args[2], Mercury.Config.Colors.Default, "."}
    end
    
    -- Finish!
    return true, "", false, {}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil

    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)

    local Armor = vgui.Create("DTextEntry", frame)
    Armor:SetPos(240, 20)
    Armor:SetSize(130, 20)
    Armor:CheckNumeric(true)
    Armor:SetText("Amount")
    Armor:SetEnterAllowed(false)
               
    local ArmorButton = vgui.Create("DButton" , frame)
    ArmorButton:SetPos(240, 40)
    ArmorButton:SetText("Set Health")
    ArmorButton:SetSize(130, 60)
    ArmorButton:SetDisabled(true)
    ArmorButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        local armor = 0
        local IsNumeric = true
        local armorVal = Armor:GetValue()
        for i=1, #armorVal do
            if (string.byte(armorVal[i]) >= 48 and string.byte(armorVal[i]) <= 57) then
                continue
            else
                IsNumeric = false
                break
            end
        end
        if IsNumeric == true then armor = armorVal end

        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("armor")
            net.WriteTable({selectedplayer, armor})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs(players) do
        local item = ctrl:AddLine(ply:Nick())
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        ArmorButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)









-- Ignite
local MCMD = Mercury.Commands.CreateTable("ignite", "", true, "<player> <time>", true, true, true, "Fun")
function callfunc(caller, args)
    -- Caller is the player who issued the command.
    -- args is the string or player arguments that may have been passed.
    if not args[1] then return false, "No player was supplied to the command", false, {} end

    local time = 999
    if args[2] then time = args[2] end

    if args[1] and IsValid(args[1]) and args[1]:IsPlayer() then
        if args[1]:Alive() then
            args[1]:Ignite(time)
            return true, "", true, {args[1],Mercury.Config.Colors.Default," has been ignited for ", Mercury.Config.Colors.Arg, time, Mercury.Config.Colors.Default, " seconds"}
        else
            return false, args[1]:Nick().." is dead", false, {}
        end
    end

    return true, "", false, {}
end


function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
    local time = 999
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)

    local Time = vgui.Create("DTextEntry", frame)
    Time:SetPos(240, 20)
    Time:SetSize(130, 20)
    Time:CheckNumeric(true)
    Time:SetText("Enter a time")
    Time:SetEnterAllowed(false)
               
    local SpawnButton = vgui.Create("DButton" , frame)
    SpawnButton:SetPos(240, 40)
    SpawnButton:SetText("Ignite")
    SpawnButton:SetSize(130, 60)
    SpawnButton:SetDisabled(true)
    SpawnButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        
        local time = nil
        local IsNumeric = true
        local timeVal = Time:GetValue()
        for i=1, #timeVal do
            if (string.byte(timeVal[i]) >= 48 and string.byte(timeVal[i]) <= 57) then
                continue
            else
                IsNumeric = false
                break
            end
        end
        if IsNumeric == true then time = timeVal end

        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("ignite")
            net.WriteTable({selectedplayer, time})
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

-- Extinguish
local MCMD = Mercury.Commands.CreateTable("extinguish", "", true, "<player>", true, true, true, "Fun")
function callfunc(caller, args)
    -- Caller is the player who issued the command.
    -- args is the string or player arguments that may have been passed.
    if not args[1] then return false, "No player was supplied to the command", false, {} end

    if args[1] and IsValid(args[1]) and args[1]:IsPlayer() then
        if args[1]:Alive() then
            if args[1]:IsOnFire() then
                args[1]:Extinguish()
                return true, "", true, {args[1],Mercury.Config.Colors.Default," has been extinguished"}
            else
                 return false, args[1]:Nick().." is not on fire", false, {}
            end
        else
            return false, args[1]:Nick().." is dead", false, {}
        end
    end

    return true, "", false, {}
end


function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
    local time = 999
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)

    local SpawnButton = vgui.Create("DButton" , frame)
    SpawnButton:SetPos(240, 40)
    SpawnButton:SetText("DONT PUSH IT")
    SpawnButton:SetSize(130, 60)
    SpawnButton:SetDisabled(true)
    SpawnButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("extinguish")
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






MCMD = {
    ["Command"] = "10-13",
    ["Verb"] = "asd",
    ["RconUse"] = true,
    ["Useage"] = "<location>",
    ["UseImmunity"] =  false,
    ["HasMenu"] = false,
    ["Category"] = "Fun",
    ["PlayerTarget"] = false,
    ["AllowWildcard"] = false
}

local function kelvtofar(num)
    return tostring( ( math.Round(num - 273.15) * 1.8000) + 32) .. "°F"
end
local function kelvtocelc(num)
    return tostring( math.Round((num - 273)) ) .. "°C"
end

function callfunc(caller, args)
    if not args[1] then return false, "@SYNTAX_ERR" end

    local str = table.concat(args," ")
    str = string.Replace(str," ","%20")


    http.Fetch("http://api.openweathermap.org/data/2.5/weather?q=" .. str .. "&appid=fbff08b113b646759aafdaffee2fc48e",function(jas)
           if !jas then 
                 Mercury.Util.SendMessage(caller,{Mercury.Config.Colors.Error," A problem happened while looking for \"" .. args[1] .. "\""})
           end

            local weather = util.JSONToTable(jas)
            if string.find(jas,"Bad") or weather["cod"] == "404" then 
                
                Mercury.Util.SendMessage(caller,{Mercury.Config.Colors.Error,"We can't find any location with \"" .. args[1] .. "\""})
                return
            end

            if weather["main"] then 
              
                Mercury.Util.SendMessage(player.GetAll(),{Mercury.Config.Colors.Default,"Weather for \"",Mercury.Config.Colors.Arg, weather["name"] ,Mercury.Config.Colors.Default,"\". ", " It is ", Mercury.Config.Colors.Arg, kelvtofar(weather["main"]["temp"]) ," (",kelvtocelc(weather["main"]["temp"]),")", Mercury.Config.Colors.Default,  " and ", Mercury.Config.Colors.Arg, tostring(weather["main"]["humidity"]) ,"%",Mercury.Config.Colors.Default," humidity with ", Mercury.Config.Colors.Arg, weather["weather"][1]["description"]   })
       
                return
            end


            

    end ,function(ohno) 

  end)
    return true,{},true,{}
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


MCMD = {
    ["Command"] = "weather",
    ["Verb"] = "asd",
    ["RconUse"] = true,
    ["Useage"] = "<location>",
    ["UseImmunity"] =  false,
    ["HasMenu"] = false,
    ["Category"] = "Fun",
    ["PlayerTarget"] = false,
    ["AllowWildcard"] = false
}

Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

local qarr = {

    "vo/scout_laughlong02.mp3",
    "vo/pyro_laugh_addl04.mp3",
    "vo/soldier_laughlong02.mp3",
    "vo/demoman_laughlong02.mp3",
    "vo/heavy_laugherbigsnort01.mp3",
    "vo/engineer_laughlong02.mp3",
    "vo/medic_laughlong02.mp3",
    "vo/sniper_laughlong02.mp3",
    "vo/spy_laughlong01.mp3",
    
    "vo/demoman_jeers07.mp3",
    "vo/engineer_jeers01.mp3",
    "vo/heavy_jeers08.mp3",
    "vo/medic_jeers04.mp3",
    "vo/pyro_jeers01.mp3",
    "vo/scout_jeers11.mp3",
    "vo/sniper_jeers01.mp3",
    "vo/soldier_jeers03.mp3",
    "vo/spy_jeers06.mp3"
    
 }


local garr = {
    
    "vo/scout_laughlong02.mp3",
    "vo/pyro_laugh_addl04.mp3",
    "vo/soldier_laughlong02.mp3",
    "vo/demoman_laughlong02.mp3",
    "vo/heavy_laugherbigsnort01.mp3",
    "vo/engineer_laughlong02.mp3",
    "vo/medic_laughlong02.mp3",
    "vo/sniper_laughlong02.mp3",
    "vo/spy_laughlong01.mp3",
}


local badarr = {
        "vo/demoman_jeers07.mp3",
    "vo/engineer_jeers01.mp3",
    "vo/heavy_jeers08.mp3",
    "vo/medic_jeers04.mp3",
    "vo/pyro_jeers01.mp3",
    "vo/scout_jeers11.mp3",
    "vo/sniper_jeers01.mp3",
    "vo/soldier_jeers03.mp3",
    "vo/spy_jeers06.mp3"
}


MCMD = {
    ["Command"] = "joke",
    ["Verb"] = "asd",
    ["RconUse"] = true,
    ["Useage"] = "<location>",
    ["UseImmunity"] =  false,
    ["HasMenu"] = false,
    ["Category"] = "Fun",
    ["PlayerTarget"] = false,
    ["AllowWildcard"] = false
}


 function callfunc(caller, args)
    local laugh = table.Random(qarr)
    if args[1] then 
        if args[1]=="good" then 
            laugh = table.Random(garr)
        elseif args[1]=="bad" then 
            laugh = table.Random(badarr)
        end 

    end 
    
    for k,v in pairs(player.GetAll()) do 
        v:SendLua([[
            surface.PlaySound("mercury/budum.mp3")
            timer.Simple(2,function() 
            surface.PlaySound("]] .. laugh .. [[") end)
            ]])

    end 


    return true,{},true,{}
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)







PLY = FindMetaTable("Player")

if PLY.OldNick then 
    PLY.Nick = PLY.OldNick
end 

if PLY.OldName then 
    PLY.Name = PLY.OldName 
end 

PLY.OldNick = PLY.Nick 
PLY.OldName = PLY.Name 


function PLY:GetOverrideName()
    local asd = self:GetNWString("OverrideName",nil) 
    if !asd then return nil end 
    if #asd < 1 then return nil end 
    return asd 


end 


function PLY:Nick() 
    if self:GetOverrideName() then 
        return self:GetOverrideName() 
    end 
    return self:OldNick()
end 


function PLY:Name() 
    if self:GetOverrideName() then 
        return self:GetOverrideName() 
    end 
    return self:OldName()
end 


MCMD = {
    ["Command"] = "changename",
    ["Verb"] = "name changed",
    ["RconUse"] = true,
    ["Useage"] = "<player> <name>",
    ["UseImmunity"] =  true,
    ["HasMenu"] = false,
    ["Category"] = "Fun",
    ["PlayerTarget"] = true,
    ["AllowWildcard"] = true
}


 function callfunc(caller, args)
    args[1]:SetNWString("OverrideName",args[2])

    return true,{},true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has changed ",args[1], "'s name to ", Mercury.Config.Colors.Arg,args[2]}
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)






MCMD = {
    ["Command"] = "namechange",
    ["Verb"] = "name changed",
    ["RconUse"] = true,
    ["Useage"] = "<player> <name>",
    ["UseImmunity"] =  true,
    ["HasMenu"] = false,
    ["Category"] = "Fun",
    ["PlayerTarget"] = true,
    ["AllowWildcard"] = true
}
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


local function OnPlayerChat( player, strText, bTeamOnly, bPlayerIsDead )

    --
    -- I've made this all look more complicated than it is. Here's the easy version
    --
    -- chat.AddText( player, Color( 255, 255, 255 ), ": ", strText )
    --

    local tab = {}

    if ( bPlayerIsDead ) then
        table.insert( tab, Color( 255, 30, 40 ) )
        table.insert( tab, "*DEAD* " )
    end

    if ( bTeamOnly ) then
        table.insert( tab, Color( 30, 160, 40 ) )
        table.insert( tab, "( TEAM ) " )
    end

    if ( IsValid( player ) ) then
        table.insert( tab, team.GetColor(player:Team()))
        table.insert( tab, player:Nick() )
    else
        table.insert( tab, "Console" )
    end

    table.insert( tab, Color( 255, 255, 255 ) )
    table.insert( tab, ": "..strText )

    chat.AddText( unpack( tab ) )

    return true

end

hook.Add("OnPlayerChat","asd",OnPlayerChat)





//
MCMD = {
    ["Command"] = "ach",
    ["Verb"] = "achievement",
    ["RconUse"] = true,
    ["Useage"] = "<player> <name>",
    ["UseImmunity"] =  true,
    ["HasMenu"] = false,
    ["Category"] = "Fun",
    ["PlayerTarget"] = true,
    ["AllowWildcard"] = true
}


 function callfunc(caller, args)

    Mercury.Util.Broadcast({args[1],Color(255,255,255)," earned the achievement ", Color(255,201,0),table.concat(args," ",2)})

    return true,{},true,{}
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)



                    
local MCMD = Mercury.Commands.CreateTable("tslap", "turbo slapped", true, "<player>", true, true, true, "Fun")


function callfunc(caller,args)
        local target_player = nil
    local damage = args[2] or 0
    local sSounds = {
        "physics/body/body_medium_impact_hard1.wav",
        "physics/body/body_medium_impact_hard2.wav",
        "physics/body/body_medium_impact_hard3.wav",
        "physics/body/body_medium_impact_hard5.wav",
        "physics/body/body_medium_impact_hard6.wav",
        "physics/body/body_medium_impact_soft5.wav",
        "physics/body/body_medium_impact_soft6.wav",
        "physics/body/body_medium_impact_soft7.wav",
    }

    if not args[1] then return false, "No target player was defined." end


    if IsValid(args[1]) and args[1]:IsPlayer() then 
        if not args[1]:Alive() then return end
        args[1]:ExitVehicle()
        if args[1]:GetMoveType() == MOVETYPE_NOCLIP then
            args[1]:SetMoveType(MOVETYPE_WALK)
        end

        args[1]:EmitSound(sSounds[math.random(#sSounds)])
        
        local direction = Vector(math.random(9999) - 10, math.random(99999) - 10, math.random(80) - 5)
        local accel = direction * 50
        args[1]:SetPos(args[1]:GetPos() + Vector(0,0,8))
        args[1]:SetVelocity(accel)

        -- Angular punch
        local angle_punch_pitch = math.Rand( -20, 20 )
        local angle_punch_yaw = math.sqrt( 20*20 - angle_punch_pitch * angle_punch_pitch )
        if math.random( 0, 1 ) == 1 then
            angle_punch_yaw = angle_punch_yaw * -1
        end
        args[1]:ViewPunch(Angle(angle_punch_pitch, angle_punch_yaw, 0))

        -- Deal with their health
        local newHp = args[1]:Health() - damage
        if newHp <= 0 then
            if args[1]:IsPlayer() then
                args[1]:Kill()
            end
        else
            -- Set the new health
            args[1]:SetHealth(newHp)
        end
    end



    for I=1,10 do 
        args[1]:EmitSound("mvm/mvm_tank_explode.wav")
    end 
    ParticleEffect("cinefx_goldrush",args[1]:GetPos(),Angle(0,0,0),args[1])

    return true,"",false,{}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn( "Players" )
    ctrl:SetSize( 210, 380 )    
    ctrl:SetPos( 10, 0 )
               
    local Button = vgui.Create( "DButton" , frame)
    Button:SetPos( 240, 40 )
    Button:SetText( "Turbo-Slap" )
    Button:SetSize( 130, 60 )
    Button:SetDisabled(true)
    Button.DoClick = function(self)
        if self:GetDisabled()==true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("tslap")
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
        Button:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end 
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

if SERVER then 
    util.AddNetworkString("drama")
end 
if CLIENT then 

    net.Receive("drama",function()
        local abl = net.ReadString()
        if abl=="start" then 
            if DRAMA then 
                DRAMA:Stop()
                DRAMA = nil 
            end
            sound.PlayURL("http://xayr.ga/share/2016-11/drama.mp3","",function(B)
                DRAMA = B
                DRAMA:SetVolume(0.2)
            end)
        end
        if abl=="stop" then 
            if DRAMA then
                DRAMA:Stop()
                DRAMA = nil 
            end
        end
        
        

    end)


end 



MCMD = {
    ["Command"] = "drama",
    ["Verb"] = "achievement",
    ["RconUse"] = true,
    ["Useage"] = "<player> <name>",
    ["UseImmunity"] =  true,
    ["HasMenu"] = false,
    ["Category"] = "Fun",
    ["PlayerTarget"] = false,
    ["AllowWildcard"] = true
}


 function callfunc(caller, args)
    if args[1]=="start" then 
        net.Start("drama")
            net.WriteString("start")
        net.Broadcast()
        return true,{},true,{caller,Mercury.Config.Colors.Default, " has started a dramatic moment. "}
    end 
    if args[1]=="stop" then 
        net.Start("drama")
            net.WriteString("stop")
        net.Broadcast()
        return true,{},true,{caller,Mercury.Config.Colors.Default, " has stopped a dramatic moment. "}
    end 
        
    return true,{},true,{}
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


