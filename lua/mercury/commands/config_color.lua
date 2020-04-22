-------------------------------
--//    Color Functions    //--
-------------------------------
Mercury.Commands.AddPrivilege("viewconfig")	
Mercury.Commands.AddPrivilege("configmanagement")

local function ConfigPrivilegeCheck(ply)
	return ply:HasPrivilege("configmanagement")
end

MCMD = {
	["Command"] = "setuseteams",
	["Verb"] = "@SETUSETEAMS",
	["RconUse"] = true,
	["Useage"] = "!setuseteams <true / false>",
	["UseImmunity"] =  false,
	["HasMenu"] = false,
	["Category"] = "Config",
	["UseCustomPrivCheck"] = true,
	["PrivCheck"] = ConfigPrivilegeCheck,
	["AllowWildcard"] = true
}

function callfunc(caller,args) 
   	if !args[1] then return false, "true / false not specified." end
   	args[1] = string.lower(args[1])

   	if args[1]=="true" then 
   		Mercury.Config.UseTeams = true
   		Mercury.ConfigManager.WriteConfig()
   		return true,"",true,{caller,Mercury.Config.Colors.Default," has set teams", Mercury.Config.Colors.Setting, " to " , Mercury.Config.Colors.Default,"be used."}

   	else 
   		Mercury.Config.UseTeams = false
   		Mercury.ConfigManager.WriteConfig()
   		return true,"",true,{caller,Mercury.Config.Colors.Default," has set teams", Mercury.Config.Colors.Setting, " to not " , Mercury.Config.Colors.Default,"be used."}


   	end
    target:Lock(true)

    return true, "", false, {}
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)



MCMD = {
	["Command"] = "setusetime",
	["Verb"] = "@SETUSETEAMS",
	["RconUse"] = true,
	["Useage"] = "<true / false>",
	["UseImmunity"] =  false,
	["HasMenu"] = false,
	["Category"] = "Config",
	["UseCustomPrivCheck"] = true,
	["PrivCheck"] = ConfigPrivilegeCheck,
	["AllowWildcard"] = true
}

function callfunc(caller,args) 
   	if !args[1] then return false, "true / false not specified." end
   	args[1] = string.lower(args[1])

   	if args[1]=="true" then 
   		Mercury.Config.UseRankTime = true
   		Mercury.ConfigManager.WriteConfig()
   		return true,"",true,{caller,Mercury.Config.Colors.Default," has set time recording", Mercury.Config.Colors.Setting, " to " , Mercury.Config.Colors.Default,"be used."}

   	else 
   		Mercury.Config.UseRankTime = false
   		Mercury.ConfigManager.WriteConfig()
   		return true,"",true,{caller,Mercury.Config.Colors.Default," has set time recording", Mercury.Config.Colors.Setting, " to not " , Mercury.Config.Colors.Default,"be used."}


   	end
    return true, "", false, {}
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)


MCMD = {
	["Command"] = "setservercolor",
	["Verb"] = "@SETUSETEAMS",
	["RconUse"] = true,
	["Useage"] = "set",
	["UseImmunity"] =  false,
	["HasMenu"] = false,
	["Category"] = "Config",
	["UseCustomPrivCheck"] = true,
	["PrivCheck"] = ConfigPrivilegeCheck,
	["AllowWildcard"] = true
}

 function callfunc(caller,args) 
	if !args[1] then return false,"Specify a color." end
	local col 
	if type(args[1])=="string" then
		local rtab = string.Explode(",",args[1])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
			col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[1])=="table" then 
			col = args[1]
	end

	Mercury.Config.Colors.Server = col
    Mercury.ConfigManager.WriteConfig()

	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Server Color" ,Mercury.Config.Colors.Default , " to ", col , "this."} 
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

-- Set settings color
MCMD = {
	["Command"] = "setsettingcolor",
	["Verb"] = "@SET",
	["RconUse"] = true,
	["Useage"] = "set",
	["UseImmunity"] =  false,
	["HasMenu"] = false,
	["Category"] = "Config",
	["UseCustomPrivCheck"] = true,
	["PrivCheck"] = ConfigPrivilegeCheck,
	["AllowWildcard"] = true
}

function callfunc(caller,args) 
	if !args[1] then return false,"Specify a color." end
	local col 
	if type(args[1])=="string" then
		local rtab = string.Explode(",",args[1])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
			col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[1])=="table" then 
			col = args[1]
	end

	Mercury.Config.Colors.Setting = col
    Mercury.ConfigManager.WriteConfig()
	
	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Setting Color" ,Mercury.Config.Colors.Default , " to ", col , "this."} 
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

-- Set args color
MCMD = {
	["Command"] = "setargcolor",
	["Verb"] = "@SET",
	["RconUse"] = true,
	["Useage"] = "set",
	["UseImmunity"] =  false,
	["HasMenu"] = false,
	["Category"] = "Config",
	["UseCustomPrivCheck"] = true,
	["PrivCheck"] = ConfigPrivilegeCheck,
	["AllowWildcard"] = true
}

function callfunc(caller,args) 
	if !args[1] then return false,"Specify a color." end
	local col 
	if type(args[1])=="string" then
		local rtab = string.Explode(",",args[1])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
			col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[1])=="table" then 
			col = args[1]
	end

	Mercury.Config.Colors.Arg = col
    Mercury.ConfigManager.WriteConfig()

	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Argument Color" ,Mercury.Config.Colors.Default , " to ", col , "this."} 
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

-- Set rank color
MCMD = {
	["Command"] = "setrankcolor",
	["Verb"] = "@SET",
	["RconUse"] = true,
	["Useage"] = "set",
	["UseImmunity"] =  false,
	["HasMenu"] = false,
	["Category"] = "Config",
	["UseCustomPrivCheck"] = true,
	["PrivCheck"] = ConfigPrivilegeCheck,
	["AllowWildcard"] = true
}
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = ConfigPrivilegeCheck
function callfunc(caller,args) 
	if !args[1] then return false,"Specify a color." end
	local col 
	if type(args[1])=="string" then
		local rtab = string.Explode(",",args[1])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
			col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[1])=="table" then 
			col = args[1]
	end

	Mercury.Config.Colors.Rank = col
    Mercury.ConfigManager.WriteConfig()
   
	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Rank Color" ,Mercury.Config.Colors.Default , " to ", col , "this."} 
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

-- Set error color
MCMD = {
	["Command"] = "seterrorcolor",
	["Verb"] = "@SET",
	["RconUse"] = true,
	["Useage"] = "set",
	["UseImmunity"] =  false,
	["HasMenu"] = false,
	["Category"] = "Config",
	["UseCustomPrivCheck"] = true,
	["PrivCheck"] = ConfigPrivilegeCheck,
	["AllowWildcard"] = true
}
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = ConfigPrivilegeCheck
function callfunc(caller,args) 
	if !args[1] then return false,"Specify a color." end
	local col 
	if type(args[1])=="string" then
		local rtab = string.Explode(",",args[1])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
			col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[1])=="table" then 
			col = args[1]
	end

	Mercury.Config.Colors.Error = col
    Mercury.ConfigManager.WriteConfig()

	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Error Color" ,Mercury.Config.Colors.Default , " to ", col , "this."} 
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

-- Set default color
MCMD = {
	["Command"] = "setdefaultcolor",
	["Verb"] = "@SET",
	["RconUse"] = true,
	["Useage"] = "set",
	["UseImmunity"] =  false,
	["HasMenu"] = false,
	["Category"] = "Config",
	["UseCustomPrivCheck"] = true,
	["PrivCheck"] = ConfigPrivilegeCheck,
	["AllowWildcard"] = true
}
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = ConfigPrivilegeCheck
function callfunc(caller,args) 
	if !args[1] then return false,"Specify a color." end
	local col 
	if type(args[1])=="string" then
		local rtab = string.Explode(",",args[1])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
			col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[1])=="table" then 
			col = args[1]
	end

	Mercury.Config.Colors.Default = col
    Mercury.ConfigManager.WriteConfig()
  
	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Default Color" ,Mercury.Config.Colors.Default , " to ", col , "this."} 
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

