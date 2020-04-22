local MCMD = {}
MCMD.Command = "freezeall"
MCMD.Verb = ""
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.Category = "fuck" 
 
function callfunc(caller, args)
  for k,v in pairs(ents.GetAll()) do
    if v:CPPIGetOwner()==caller then 
        local phys = v:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(false)
        end
    end
   end
    return true,"",true,{caller, Mercury.Config.Colors.Default, " has frozen all of their props."}
    
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


local MCMD = {}
MCMD.Command = "freezemap"
MCMD.Verb = ""
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.Category = "fuck" 
 
function callfunc(caller, args)
  for k,v in pairs(ents.GetAll()) do

        local phys = v:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(false)
        end
  	if v:IsPlayer() then 
  		v:EmitSound("weapons/icicle_freeze_victim_01.wav")

  	end
   end
    return true,"",true,{caller, Mercury.Config.Colors.Default, " froze the map."}
    
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


local MCMD = {}
MCMD.Command = "freezeallof"
MCMD.Verb = ""
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true 
MCMD.PlayerTarget = true
MCMD.HasMenu = false
MCMD.Category = "fuck" 
 
function callfunc(caller, args)
  for k,v in pairs(ents.GetAll()) do
    if v:CPPIGetOwner()==args[1] then 
        local phys = v:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(false)
        end
    end
   end
    return true,"",true,{caller, Mercury.Config.Colors.Default, " has frozen all of ", args[1], "'s props."}
    
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)
