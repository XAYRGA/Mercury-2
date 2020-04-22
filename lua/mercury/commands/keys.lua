
Mercury.Commands.AddPrivilege("keygen")

local function KeygenPrivcheck(ply)
    return ply:HasPrivilege("keygen")
end 

MCMD = {
    ["Command"] = "keygen",
    ["Verb"] = "generated a key",
    ["RconUse"] = true,
    ["Useage"] = "<rank>",
    ["UseImmunity"] =   false ,
    ["HasMenu"] = false ,
    ["Category"] = "Player Management",
    ["UseCustomPrivCheck"] = true,
    ["PlayerTarget"] = false ,
    ["PrivCheck"] = KeygenPrivcheck,
    ["AllowWildcard"] = false
}

function callfunc(caller,args)
    local s,e = Mercury.Keygen.GenerateKey(args[1])
    if s==false then 
      return s,e 
    end
   Mercury.Util.SendMessage(caller, {Mercury.Config.Colors.Default, " The key for " ,Mercury.Config.Colors.Rank,args[1],Mercury.Config.Colors.Default, " is ", Mercury.Config.Colors.Arg, s })

    return true, "", true, {}
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)






MCMD = {
    ["Command"] = "keydeactivate",
    ["Verb"] = "deactivated a key",
    ["RconUse"] = true,
    ["Useage"] = "<key>",
    ["UseImmunity"] =   false ,
    ["HasMenu"] = false ,
    ["Category"] = "Player Management",
    ["UseCustomPrivCheck"] = true,
    ["PlayerTarget"] = false ,
    ["PrivCheck"] = KeygenPrivcheck,
    ["AllowWildcard"] = false
}

function callfunc(caller,args)
    local s,e = Mercury.Keygen.DeactivateKey(args[1])
    if s==false then 
        return s,e 
    end
    Mercury.Util.SendMessage(caller, {Mercury.Config.Colors.Default, " Deactivated key ", Mercury.Config.Colors.Arg, args[1]  })
        
    return true, "", true, {}
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)



MCMD = {
    ["Command"] = "redeemkey",
    ["Verb"] = "redeemed a key",
    ["RconUse"] = true,
    ["Useage"] = "<key>",
    ["UseImmunity"] =   false ,
    ["HasMenu"] = false ,
    ["Category"] = "Player Management",
    ["UseCustomPrivCheck"] = false,
    ["PlayerTarget"] = false ,

}

function callfunc(caller,args)

    local s,e = Mercury.Keygen.RedeemKey(caller,args[1])
    if s==false then 
        return s,e 
    end

        
    return true, "", true, {}
end

function MCMD.GenerateMenu(frame)

end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)