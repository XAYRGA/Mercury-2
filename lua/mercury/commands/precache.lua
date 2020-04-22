
Mercury.Commands.AddPrivilege("precache")

local function PrecachePrivcheck(ply)
    return ply:HasPrivilege("precache")
end 

MCMD = {
    ["Command"] = "pstats",
    ["Verb"] = "output blame",
    ["RconUse"] = true,
    ["Useage"] = "",
    ["UseImmunity"] =   false ,
    ["HasMenu"] = false ,
    ["Category"] = "Player Management",
    ["UseCustomPrivCheck"] = true,
    ["PlayerTarget"] = false ,
    ["PrivCheck"] = PrecachePrivcheck,
    ["AllowWildcard"] = false

}

function callfunc(caller,args)
     PRECACHE.STATS()
    
    return true, "", true, {}
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)



MCMD = {
    ["Command"] = "pblame",
    ["Verb"] = "output blame",
    ["RconUse"] = true,
    ["Useage"] = "",
    ["UseImmunity"] =   false ,
    ["HasMenu"] = false ,
    ["Category"] = "Player Management",
    ["UseCustomPrivCheck"] = true,
    ["PlayerTarget"] = false ,
    ["PrivCheck"] = PrecachePrivcheck,
    ["AllowWildcard"] = false

}

function callfunc(caller,args)
     PRECACHE.BLAME()
    
    return true, "", true, {}
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)



MCMD = {
    ["Command"] = "lblame",
    ["Verb"] = "output blame",
    ["RconUse"] = true,
    ["Useage"] = "",
    ["UseImmunity"] =   false ,
    ["HasMenu"] = false ,
    ["Category"] = "Player Management",
    ["PlayerTarget"] = false ,
    ["AllowWildcard"] = false

}

function callfunc(caller,args)
                
            local plrs = {}

            for k,v in pairs(player.GetAll()) do 
                plrs[v] = {
                    ents = 0,
                    moving = 0,
                    constraints = 0,
                    }
               
            end


            for k,v in pairs(ents.GetAll()) do 
                local gh = v:CPPIGetOwner()
                if gh and IsValid(gh) then 
                    local po = v:GetPhysicsObject()
                    if IsValid(po) then 
                        if po:IsMotionEnabled() and not string.find(v:GetClass(),"constraint") then
                            plrs[gh]["moving"] = plrs[gh]["moving"] + 1
                            
                        end
                        
                        
                    end
                    //print( table.Count(constraint.GetTable(gh,"Weld")) )
                    plrs[gh]["constraints"] = plrs[gh]["constraints"] +  math.Round(table.Count(constraint.GetTable(v,"Weld")) / 2) // apparently doubles constraint count because two entities have the constraint.

                    //plrs[gh]["constraints"] = plrs[gh]["constraints"] + table.Count(constraint.GetTable(gh,"Elastic"))
                    //plrs[gh]["constraints"] = plrs[gh]["constraints"] + table.Count(constraint.GetTable(gh,"Rope"))
                    if not string.find(v:GetClass(),"constraint") then 
                        plrs[gh]["ents"]  = plrs[gh]["ents"]  + 1
                    end 
                  
                
                end


            end
            local WngColor = Mercury.Config.Colors.Default
            local add = ""
            local addc = "" 
            local addm = ""

            for k,v in pairs(player.GetAll()) do
                for i,ply in pairs(plrs) do
                    WngColor = Mercury.Config.Colors.Arg
                    local realratio = ( ply.constraints / ply.ents  ) * math.Clamp( (ply.ents  / 25 ) ,0,1) 


                    local ratio = math.ceil(  realratio * 100)
                    add = ""
                    WngColor = Mercury.Config.Colors.Arg
                    /*
                    if ratio > 80 and ply.ents > 0 then 
                        WngColor = Color(255,0,0)
                        add = "!!!"
                    end 
                    */

                    if ply.ents==0 then 
                        ratio = "N/A"
                    end 
             



                   // v:ChatPrint(i:Nick() .. " - " .. ply.ents .. " entities (" .. ply.moving .. " moving) + " .. ply.constraints .. " constraints. ")    

                    Mercury.Util.SendMessage(v, {i, " ", Mercury.Config.Colors.Arg ,tostring(ply.ents) , Mercury.Config.Colors.Default ,

                    " entities (",  Mercury.Config.Colors.Arg,  tostring(ply.moving) , " moving" ,  Mercury.Config.Colors.Default ,")  and ", Mercury.Config.Colors.Arg , tostring(ply.constraints) , Mercury.Config.Colors.Default ," constraints. Ratio: ",WngColor,add,tostring(ratio),"%",add,Mercury.Config.Colors.Default,"." } )    
                

                end
                      
            end

    
    return true, "", true, {}
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

MCMD = {
    ["Command"] = "myblame",
    ["Verb"] = "output blame",
    ["RconUse"] = true,
    ["Useage"] = "",
    ["UseImmunity"] =   false ,
    ["HasMenu"] = false ,
    ["Category"] = "Player Management",
    ["PlayerTarget"] = false ,
    ["AllowWildcard"] = false

}

function callfunc(caller,args)
    
local myents = { moving = 0, ents = 0,const = 0}


for k,v in pairs(ents.GetAll()) do 
    local gh = v:CPPIGetOwner()
    if gh and IsValid(gh) and gh==caller then 
        local po = v:GetPhysicsObject()
        if IsValid(po) then 
            if po:IsMotionEnabled() then
             

                    if not string.find(v:GetClass(),"constraint") then 
               myents["moving"] = myents["moving"] +  1
        end 
                 // apparently doubles constraint count because two entities have the constraint.
            end
        end
        myents["const"] = myents["const"] + math.Round(table.Count(constraint.GetTable(v,"Weld")) / 2)

        if not string.find(v:GetClass(),"constraint") then 
           myents["ents"]  = myents["ents"]  + 1
        end 

    end
end


 
        Mercury.Util.SendMessage(caller, {Mercury.Config.Colors.Arg, tostring(myents.ents) , Mercury.Config.Colors.Default, " entities (", Mercury.Config.Colors.Arg, tostring(myents.moving) , Mercury.Config.Colors.Default, " moving) and ", Mercury.Config.Colors.Arg , tostring(myents.const) , Mercury.Config.Colors.Default, " constraints."  } )    
    


    
    return true, "", true, {}
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)





local t_ent = {
    ["prop_physics"] = true ,
}
local lag_t = {}

local function lagman_createent(ent)


        ent:SetCustomCollisionCheck(true)
 
end 
LMG = lagman_createent

local function lagman_tick()
    for k,v in pairs(lag_t) do  
        lag_t[k] = 0 
    end
end 
 
local function lagman_collide(e1,e2)
 
    if e1  then 
        local own = e1:CPPIGetOwner() 
        if IsValid(own) then 
            if !lag_t[own:SteamID()] then lag_t[own:SteamID()] = 0 end 
            lag_t[own:SteamID()] = (lag_t[own:SteamID()] + 1)
        end 
    end 

    if e2  then 
        local own = e2:CPPIGetOwner() 
        if IsValid(own) then 
            if !lag_t[own:SteamID()] then lag_t[own:SteamID()] = 0 end 
            lag_t[own:SteamID()] = (lag_t[own:SteamID()] + 1)
        end 
    end 

end  
 

hook.Remove("OnEntityCreated","Mercury:LagManagement",lagman_createent)
    hook.Remove("ShouldCollide","Mercury:LagManagement",lagman_collide)
if SERVER then 
    hook.Add("ShouldCollide","Mercury:LagManagement",lagman_collide)

    timer.Create("Mercury:LagManagement",1,0,lagman_tick)

    hook.Add("OnEntityCreated","Mercury:LagManagement",lagman_createent)
end


MCMD = {
    ["Command"] = "wholag",
    ["Verb"] = "output blame",
    ["RconUse"] = true,
    ["Useage"] = "",
    ["UseImmunity"] =   false ,
    ["HasMenu"] = false ,
    ["Category"] = "Player Management",
    ["PlayerTarget"] = false ,
    ["AllowWildcard"] = false

}

function callfunc(caller,args)
                

            local WngColor = Mercury.Config.Colors.Default
            local add = ""
            local addc = "" 
            local addm = ""
            local allplys = player.GetAll()

            for k,v in pairs(allplys) do
                
                    local colls = lag_t[v:SteamID()] or 0 

                    Mercury.Util.SendMessage(allplys, {v, " ",Mercury.Config.Colors.Default, " collisions/sec ", Mercury.Config.Colors.Arg ,  tostring(colls)})


            end

    
    return true, "", true, {}
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)