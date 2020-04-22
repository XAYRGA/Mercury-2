if SERVER then 

    function MakeGold( what )
    if not IsValid( what ) then
        return
    end
    
    if what.Welds then
        --Already gold
        return
    end
    
    if not what:GetModel( ):match( "models/.*%.mdl" ) then
        --Brush entity / point / something without a proper model
        return
    end
    
    if what:IsNPC( ) then
        what:SetSchedule( SCHED_WAIT_FOR_SCRIPT )
    end
    
    local bone, bones, bone1, bone2, weld, weld2
    
    if not ( what:IsPlayer( ) or what:IsNPC( ) ) then
			
			what:EmitSound("Weapon_Wrench.MissCrit")
        --Make use of existing object
		
        bones = what:GetPhysicsObjectCount( )
        
        what.Welds = what.Welds or { }
        
        for bone = 1, bones do
            bone1 = bone - 1
            bone2 = bones - bone
            
            if not what.Welds[ bone2 ] then
                weld = constraint.Weld( what, what, bone1, bone2, 0 )
                
                if weld then
                    what.Welds[ bone1 ] = weld
                    what:DeleteOnRemove( weld )
                end
            end
            
            weld2 = constraint.Weld( what, what, bone1, 0, 0 )
            
            if weld2 then
                what.Welds[ bone1 + bones ] = weld2
                what:DeleteOnRemove( weld2 )
            end
            
            --what:GetPhysicsObjectNum( bone ):EnableMotion( true )
        end
        
        what:SetMaterial( "models/player/shared/gold_player" )
      --  what:SetColor( color_gold )


    else
        local rag, vel, solid, wep, fakewep
        
        bones = what:GetPhysicsObjectCount( )
        vel = what:GetVelocity( )
        
        solid = what:GetSolid( )
        
        what:SetSolid( SOLID_NONE )
        
		
		
		
	
        if bones > 1 or what:IsPlayer( ) or what:IsNPC( ) then
            rag = ents.Create( "prop_ragdoll" )
                rag:SetModel( what:GetModel( ) )
                rag._MercuryRagdoll = true
                rag:SetPos( what:GetPos( ) )
                rag:SetAngles( what:GetAngles( ) )
				--rag:EmitSound( "spy-ciclefreeze.wav" )
            rag:Spawn( )
            
            bones = rag:GetPhysicsObjectCount( )
            
            for solid = 1, what:GetNumBodyGroups( ) do
            	rag:SetBodygroup( solid, what:GetBodygroup( solid ) )
            end
            
            rag:SetSequence( what:GetSequence( ) )
            rag:SetCycle( what:GetCycle( ) )
            
            for bone = 1, bones do
                bone1 = rag:GetPhysicsObjectNum( bone )
                
                if IsValid( bone1 ) then
                    weld, weld2 = what:GetBonePosition( what:TranslatePhysBoneToBone( bone ) )
                    
                    bone1:SetPos( weld )
                    bone1:SetAngles( weld2 )
                    bone1:SetMaterial( "metal" )
                    
                    bone1:AddGameFlag( FVPHYSICS_NO_SELF_COLLISIONS )
                    bone1:AddGameFlag( FVPHYSICS_HEAVY_OBJECT )
                    bone1:SetMass( 500 )
                    
                    bone1:Sleep( )
                                        
                    local bone2 = bone1
                end
            end

            
            constraint.Weld( rag, Entity( 0 ), 0, 0, 900 )
            
			



            if what:IsNPC( ) or what:IsPlayer( ) then
            	wep = what:GetActiveWeapon( )
            	
            	if wep:IsValid( ) then
            		fakewep = ents.Create( "base_anim" )
            			fakewep:SetModel( wep:GetModel( ) )
            			--fakewep:SetColor( color_gold ) this makes the weapon not call the unknown value leaving the weapon, non pink
            			fakewep:SetParent( rag )
            			fakewep:AddEffects( EF_BONEMERGE )
            			fakewep:SetMaterial( "models/shiny" )
            			fakewep.Class = wep:GetClass( )
            		fakewep:Spawn( )
            		
            		function rag.PlayerUse( rag, pl )
        				pl:Give( fakewep.Class )
        				fakewep:Remove( )
        				hook.Remove( "KeyPress", rag )
        			end
        			
        			function rag.KeyPress( this, pl, key )
        				if key == IN_USE then
        					local tr = { }
        					tr.start = pl:EyePos( )
        					tr.endpos = pl:EyePos( ) + pl:GetAimVector( ) * 85
        					tr.filter = pl
        					
        					tr = util.TraceLine( tr )
        					
        					if tr.Entity == this then
        						this:PlayerUse( pl )
        					end
        				end
        			end
        			
        			hook.Add( "KeyPress", rag, rag.KeyPress )

            		rag.FakeWeapon = fakewep
            	end
            end
            
           	MakeGold( rag )
            
           // SafeRemoveEntityDelayed( rag, 90 )
        else
            rag = ents.Create( "prop_physics" )
                rag:SetModel( what:GetModel( ) )
                rag:SetPos( what:GetPos( ) )
                rag:SetAngles( what:GetAngles( ) )
            rag:Spawn( )
        end
        
        what:SetSolid( solid )
        
        rag:SetSequence( what:GetSequence( ) )
        rag:SetCycle( what:GetCycle( ) )

        rag:SetSkin( what:GetSkin( ) )
        if what:IsPlayer( ) then
            what:KillSilent( )
           	
			what:SpectateEntity(rag)
			what:Spectate( OBS_MODE_CHASE ) 
			what.RagREnt = rag
        else
            what:Remove( )
        end
        MakeGold( rag )
    end
end

end


MCMD = {}
MCMD.Command = "gold"
MCMD.Verb = "goldified"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = true




function callfunc(caller,args)
    local target = args[1]


    MakeGold(target)
    target:EmitSound("weapons/saxxy_impact_gen_06.wav")
    timer.Simple(1.6,function()
        target:EmitSound("vo/engineer_goldenwrenchkill0" .. math.random(1,4)  .. ".mp3")

    end)


    return true,"",false,{} //RETURN CODES.
    // First argument true / false -- Command succeeded? 
    // Second argument: String error, if first argument is false this is pushed to the client.
    // Third argument true / false -- supress default messages
    // Fourth argument table, the message to print to chat if second argument is true.

end


function MCMD.GenerateMenu(frame)
        local selectedplayer = nil 

            local ctrl = vgui.Create( "DListView", frame)
            ctrl:AddColumn( "Players" )
            ctrl:SetSize( 210, 380 )    
            ctrl:SetPos( 10, 0 )
                
            local UnGagButton = vgui.Create( "DButton" , frame)
            local GagButton = vgui.Create( "DButton" , frame)
            GagButton:SetPos( 240, 40 )
            GagButton:SetText( "Goldify" )
            GagButton:SetSize( 130, 60 )
            GagButton:SetDisabled(true)
            GagButton.DoClick = function(self)
                if self:GetDisabled()==true then return false end
                surface.PlaySound("buttons/button3.wav")
                net.Start("Mercury:Commands")
                    net.WriteString("gold")
                    net.WriteTable({selectedplayer})
                net.SendToServer()

            end




            UnGagButton:SetPos( 240, 120 )
            UnGagButton:SetText( "UnGoldify" )
            UnGagButton:SetSize( 130, 60 )
            UnGagButton:SetDisabled(true)
            UnGagButton.DoClick = function(self)
                if self:GetDisabled()==true then return false end
                surface.PlaySound("buttons/button3.wav")
                net.Start("Mercury:Commands")
                    net.WriteString("ungold")
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
                 UnGagButton:SetDisabled(false)
                 GagButton:SetDisabled(false)
                selectedplayer = line_obj.ply
                return true
            end
end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

MCMD = {}
MCMD.Command = "ragdoll"
MCMD.Verb = "ragdolled"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = true
MCMD.AllowWildcard = true




function callfunc(caller,args)
    local what = args[1]
    local target = args[1]

    

    local rag, vel, solid, wep, fakewep, bones
    target:EmitSound("weapons/axe_hit_flesh3.wav")
 
        bones = what:GetPhysicsObjectCount( )
 
        vel = what:GetVelocity( )
        
        solid = what:GetSolid( )
        
        what:SetSolid( SOLID_NONE )
        


        
       
        
    
        if bones > 1 or what:IsPlayer( ) or what:IsNPC( ) then
            rag = ents.Create( "prop_ragdoll" )
                rag._MercuryRagdoll = true
                rag:SetModel( what:GetModel( ) )
                rag:SetPos( what:GetPos( ) )
                rag:SetAngles( what:GetAngles( ) )
                --rag:EmitSound( "spy-ciclefreeze.wav" )
            rag:Spawn( )
            
            bones = rag:GetPhysicsObjectCount( )
            
            for solid = 1, what:GetNumBodyGroups( ) do
                rag:SetBodygroup( solid, what:GetBodygroup( solid ) )
            end
            
            rag:SetSequence( what:GetSequence( ) )
            rag:SetCycle( what:GetCycle( ) )
            rag:SetVelocity(what:GetVelocity())
            for bone = 1, bones do
                bone1 = rag:GetPhysicsObjectNum( bone )
    
                if IsValid( bone1 ) then
                    weld, weld2 = what:GetBonePosition( what:TranslatePhysBoneToBone( bone ) )
                    bone1:SetVelocity( what:GetVelocity() * 1.5 )
                    bone1:SetPos( weld )
                    bone1:SetAngles( weld2 )
                    bone1:SetMaterial( "flesh" )
                    
                    bone1:AddGameFlag( FVPHYSICS_NO_SELF_COLLISIONS )
                    bone1:AddGameFlag( FVPHYSICS_HEAVY_OBJECT )
                    bone1:SetMass( 100 )
                    
                    bone1:Sleep( )
                                        
                    local bone2 = bone1
                end
            end
            target.RagREnt = rag 
            target:KillSilent()

            what:SpectateEntity(rag)
            what:Spectate( OBS_MODE_CHASE ) 
        else 
            return false,{"You don't have any bones."}
        end 






    return true,"",false,{} //RETURN CODES.
    // First argument true / false -- Command succeeded? 
    // Second argument: String error, if first argument is false this is pushed to the client.
    // Third argument true / false -- supress default messages
    // Fourth argument table, the message to print to chat if second argument is true.

end


function MCMD.GenerateMenu(frame)
        local selectedplayer = nil 

            local ctrl = vgui.Create( "DListView", frame)
            ctrl:AddColumn( "Players" )
            ctrl:SetSize( 210, 380 )    
            ctrl:SetPos( 10, 0 )
                
            local UnGagButton = vgui.Create( "DButton" , frame)
            local GagButton = vgui.Create( "DButton" , frame)
            GagButton:SetPos( 240, 40 )
            GagButton:SetText( "Ragdoll" )
            GagButton:SetSize( 130, 60 )
            GagButton:SetDisabled(true)
            GagButton.DoClick = function(self)
                if self:GetDisabled()==true then return false end
                surface.PlaySound("buttons/button3.wav")
                net.Start("Mercury:Commands")
                    net.WriteString("ragdoll")
                    net.WriteTable({selectedplayer})
                net.SendToServer()

            end




            UnGagButton:SetPos( 240, 120 )
            UnGagButton:SetText( "Unragdoll" )
            UnGagButton:SetSize( 130, 60 )
            UnGagButton:SetDisabled(true)
            UnGagButton.DoClick = function(self)
                if self:GetDisabled()==true then return false end
                surface.PlaySound("buttons/button3.wav")
                net.Start("Mercury:Commands")
                    net.WriteString("unragdoll")
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
                 UnGagButton:SetDisabled(false)
                 GagButton:SetDisabled(false)
                selectedplayer = line_obj.ply
                return true
            end
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)


MCMD = {}
MCMD.Command = "unragdoll"
MCMD.Verb = "unragdolled"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = false
MCMD.AllowWildcard = true





function callfunc(caller,args)
    local target = args[1]

    if not IsValid(target.RagREnt) then 
        return false,{target," is not ragdolled." }
    end  

    if target.RagREnt and IsValid(target.RagREnt) then 
            target:Spawn()
            target:SetPos(target.RagREnt:GetPos())
        target.RagREnt:Remove()
    else 
        target:Spawn()
    end

    return true,"",false,{} //RETURN CODES.
    // First argument true / false -- Command succeeded? 
    // Second argument: String error, if first argument is false this is pushed to the client.
    // Third argument true / false -- supress default messages
    // Fourth argument table, the message to print to chat if second argument is true.
end


function MCMD.GenerateMenu(frame)

end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)



MCMD = {}
MCMD.Command = "cleandolls"
MCMD.Verb = "cleanup mercury ragdolls"
MCMD.RconUse = true
MCMD.Useage = ""
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = false
MCMD.AllowWildcard = true





function callfunc(caller,args)
    local target = args[1]

    for k,v in pairs(ents.GetAll()) do 
        if v._MercuryRagdoll == true then 
            v:Remove()
        end 
    end
    return true,"",true,{caller, Mercury.Config.Colors.Default," cleaned up " ,Mercury.Config.Colors.Server,"Mercury's", Mercury.Config.Colors.Default, " ragdolls."} //RETURN CODES.
    // First argument true / false -- Command succeeded? 
    // Second argument: String error, if first argument is false this is pushed to the client.
    // Third argument true / false -- supress default messages
    // Fourth argument table, the message to print to chat if second argument is true.
end


function MCMD.GenerateMenu(frame)

end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)











MCMD = {}
MCMD.Command = "ungold"
MCMD.Verb = "ungoldified"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = false



function callfunc(caller,args)
    local target = args[1]

    if target.RagREnt and IsValid(target.RagREnt) then 
            target:Spawn()
            target:SetPos(target.RagREnt:GetPos())
        target.RagREnt:Remove()
    else 
        target:Spawn()
    end

    return true,"",false,{} //RETURN CODES.
    // First argument true / false -- Command succeeded? 
    // Second argument: String error, if first argument is false this is pushed to the client.
    // Third argument true / false -- supress default messages
    // Fourth argument table, the message to print to chat if second argument is true.

end


function MCMD.GenerateMenu(frame)

end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)


local function playergoldrespawn( ply )
    if ply.RagREnt and IsValid( ply.RagREnt ) then 
        return false
    end
 
end
 
hook.Add( "PlayerDeathThink", "Mercury:GoldBlockRespawn", playergoldrespawn,-20 );


