
-------------------------
--// Rank  Functions //--
-------------------------
Mercury.Commands.AddPrivilege("manageranks")
Mercury.Commands.AddPrivilege("viewranks")	

local function RankPrivilegeCheck(ply)
	return ply:HasPrivilege("manageranks")
end

-- Create rank
local MCMD = Mercury.Commands.CreateTable("rankadd", "created the rank", true, "<rank index> <rank title> <color>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if not (args[2] and type(args[2])=="string") then return false,"No title specified." end
	if !args[3] then return false,"No color specified." end
	local col 
	if type(args[3])=="string" then
		local rtab = string.Explode(",",args[3])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
		col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[3])=="table" then 
			col = args[3]
	end
	if !col then return false,"Could not get color value." end 

	local rsl,err = Mercury.Ranks.CreateRank(string.lower(args[1]),string.lower(args[2]),col) 	
	if rsl~=true then
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has created the rank ", Mercury.Config.Colors.Rank , args[1] ,Mercury.Config.Colors.Default , " with the title of ",Mercury.Config.Colors.Rank ,args[2] ,Mercury.Config.Colors.Default , " and ", col , "this color" } //RETURN CODES.
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Delete rank
local MCMD = Mercury.Commands.CreateTable("rankdel", "deleted the rank", true, "<rank index>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	local rsl,err = Mercury.Ranks.DeleteRank(args[1]) 
	if rsl~=true then 
		return false,err
	end
	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has deleted the rank ", Mercury.Config.Colors.Rank , args[1]}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Modify privledges
local MCMD = Mercury.Commands.CreateTable("rankmodpriv", "set the privileges of", true, "<rank index> <add / remove> <privilege>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if not (args[2] and type(args[2])=="string") then return false,"Add / Remove not specified." end
	if not (args[3] and type(args[3])=="string") then return false,"Command not specified to add / remove." end
	local index = string.lower(args[1])
	local action = string.lower(args[2])
	local apriv = string.lower(args[3])

	local gprivleges = Mercury.Commands.GetPrivileges()
	if action == "add" then 

		local privexists = false 
		for k,v in pairs(gprivleges) do
			if v==apriv then privexists = true  end
		end
		if privexists==false then return false,"Privilege does not exist." end

		local data,err = Mercury.Ranks.GetProperty(index,"privileges")
		if data==false then 
			return false,err
		end
		for k,v in pairs(data) do
			if v==apriv then return false,"Rank already has that privilege." end
		end
		data[#data + 1] = apriv 
		Mercury.Ranks.ModProperty(index,"privileges",data)
		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has added the privilege ", Mercury.Config.Colors.Rank , apriv,Mercury.Config.Colors.Default," to ", Mercury.Config.Colors.Rank ,index }
	end

	if action == "remove" then 
		local privexists = false 
		for k,v in pairs(gprivleges) do
			if v==apriv then privexists = true  end
		end
		if privexists==false then return false,"Privilege does not exist." end

		local data,err = Mercury.Ranks.GetProperty(index,"privileges")
		if data==false then 
			return false,err
		end
		local canremove = false
		for k,v in pairs(data) do
			if v==apriv then canremove = true end
		end
		if !canremove then 
			return false,"Rank does not have the privilege to remove"
		end

		for k,v in pairs(data) do
			if v==apriv then 
				data[k] = nil
			end
		end
		Mercury.Ranks.ModProperty(index,"privileges",data)
		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has removed the privilege ", Mercury.Config.Colors.Rank , apriv,Mercury.Config.Colors.Default," from ", Mercury.Config.Colors.Rank ,index }
	end

	return false,"Malformed syntax. Example: hg rankmodpriv owner add @allcmds@"
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Set rank's color
local MCMD = Mercury.Commands.CreateTable("ranksetcolor", "set the color of", true, "<rank index> <rank title> <color>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if !args[2] then return false,"No color specified." end
	local index = string.lower(args[1])
	local col 
	if type(args[2])=="string" then
		local rtab = string.Explode(",",args[2])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
		col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[3])=="table" then 
			col = args[2]
	end
	if !col then return false,"Could not get color value." end 

	local rsl,err = Mercury.Ranks.ModProperty(index,"color",col)
	if rsl~=true then
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," changed ", Mercury.Config.Colors.Rank , args[1] .. "'s" ,Mercury.Config.Colors.Default , " color to ", col , "this." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Modify rank's title
local MCMD = Mercury.Commands.CreateTable("ranksettitle", "modified the title of", true, "<rank index> <rank title>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if !args[2] then return false,"No title specified." end
	local index = string.lower(args[1])
	local rsl,err = Mercury.Ranks.ModProperty(index,[[title]],args[2])
	if rsl~=true then
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," changed ", Mercury.Config.Colors.Rank , args[1] .. "'s title" ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Set admin
local MCMD = Mercury.Commands.CreateTable("ranksetadmin", "set the admin of", true, "<rank index> <admin / superadmin> <true/false>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if not (args[2] and type(args[2])=="string") then return false,"Admin / superadmin not specified" end
	if not (args[3] and type(args[3])=="string") then return false,"true / false not specified" end
	local index = string.lower(args[1])
	local group = string.lower(args[2])
	local truefalse = string.lower(args[3])

	if truefalse~="true" and truefalse~="false"  then 
		return false,"Malformed syntax. Example: hg ranksetadmin owner admin true"
	end
	local bool = truefalse=="true"


	if group == "superadmin" then 
		local rsl,err = Mercury.Ranks.ModProperty(index,[[superadmin]],bool)
		if rsl~=true then 
			return false,err
		end
		local rsl,err = Mercury.Ranks.ModProperty(index,[[admin]],bool)
		if rsl~=true then 
			return false,err
		end

		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set ", Mercury.Config.Colors.Rank , index .. "'s" ,Mercury.Config.Colors.Default," superadmin status to ", Mercury.Config.Colors.Rank ,truefalse }
	end


	if group == "admin" then 
		local rsl,err = Mercury.Ranks.ModProperty(index,[[admin]],bool)
		if rsl~=true then 
			return false,err
		end

		if bool==false then 
			local rsl,err = Mercury.Ranks.ModProperty(index,[[superadmin]],bool)
			if rsl~=true then 
				return false,err
			end
			local rsl,err = Mercury.Ranks.ModProperty(index,[[admin]],bool)
			if rsl~=true then 
				return false,err
			end
		end

		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set ", Mercury.Config.Colors.Rank , index .. "'s" ,Mercury.Config.Colors.Default," admin status to ", Mercury.Config.Colors.Rank ,truefalse }
	end
	
	return false,"Malformed syntax. Example: hg ranksetadmin owner admin true"
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Scoreboard order ;)
local MCMD = Mercury.Commands.CreateTable("ranksetorder", "set the order of", true, "<rank index> <rank title>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if !args[2] then return false,"No order specified." end
	local index = string.lower(args[1])
	local rsl,err = Mercury.Ranks.ModProperty(index,[[order]],tonumber(args[2]))
	if rsl~=true then
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," changed ", Mercury.Config.Colors.Rank , args[1] .. "'s order" ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Set rank
local MCMD = Mercury.Commands.CreateTable("setrank", "set the rank of", true, "<player> <rank>", false, true, false, "Player Management")
function callfunc(caller,args)
	if !args[2] then return false,"No rank specified." end
	local index = string.lower(args[2])

	if !Mercury.Ranks.RankTable[index] then return false,"Rank did not exist." end
	Mercury.UDL.SetSaveRank(args[1],index)


	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," set the rank of ", Mercury.Config.Colors.Rank , args[1] ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Change index
local MCMD = Mercury.Commands.CreateTable("ranksetindex", "set the index of", true, "<rank index> <new index>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if !args[1] then return false,"No rank specified." end
	if !args[2] then return false,"New index not specified." end
	local index = string.lower(args[1])
	local newindex = string.lower(args[2])
	if !Mercury.Ranks.RankTable[index] then return false,"Rank did not exist." end
	local sts,err = Mercury.Ranks.ChangeIndex(index,newindex)
	if sts~=true then
		return false,err
	end


	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," changed the index of ", Mercury.Config.Colors.Rank , args[1] ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


-- Copy rank
local MCMD = Mercury.Commands.CreateTable("rankcopy", "", true, "", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if !args[1] then return false,"No rank specified." end
	if !args[2] then return false,"New index not specified." end
	local index = string.lower(args[1])
	local newindex = string.lower(args[2])
	if !Mercury.Ranks.RankTable[index] then return false,"Rank did not exist." end
	local sts,err = Mercury.Ranks.CopyRank(index,newindex)
	if sts~=true then
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," copied the rank ", Mercury.Config.Colors.Rank , args[1] ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Modify immunities
local MCMD = Mercury.Commands.CreateTable("ranksetimmunity", "set the immunity of", true, "<rank index> <number immunity>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if !args[2] then return false,"No immunity specified." end
	local index = string.lower(args[1])
	local rsl,err = Mercury.Ranks.ModProperty(index,[[immunity]],tonumber(args[2]))
	if rsl~=true then
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," changed ", Mercury.Config.Colors.Rank , args[1] .. "'s immunity" ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Set target as self
local MCMD = Mercury.Commands.CreateTable("ranksettargetself", "", true, "<rank index> <true/false>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if not (args[2] and type(args[2])=="string") then return false,"True / false not specified" end

	local index = string.lower(args[1])
	local truefalse = string.lower(args[2])

	if truefalse~="true" and truefalse~="false"  then 
		return false,"Malformed syntax. Example: hg ranksettargetself group true/false"
	end

	local bool = truefalse=="true"
	local rsl,err = Mercury.Ranks.ModProperty(index,[[only_target_self]],bool)

	if rsl~=true then 
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set ", Mercury.Config.Colors.Rank , index .. "s" ,Mercury.Config.Colors.Default," to only be able to target ", Mercury.Config.Colors.Rank ,index }
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)