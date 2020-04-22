-- Goto

Mercury.Commands.AddPrivilege("location_management")

local function location_mgmt_check(ply)
	return ply:HasPrivilege("location_management",true)
end


local function CheckPrivacy(p2,p1)
	if p1.MercuryPrivacy == true then
		if p2:CanUserTarget(p1) then 
			return false
		end 

		return true,{p1,Mercury.Config.Colors.Default," has privacy mode enabled."}
	end

	return false
end 


MCMD = {
	["Command"] = "locadd",
	["Verb"] = "@SETUSETEAMS",
	["RconUse"] = true,
	["Useage"] = "addloc <name>",
	["UseImmunity"] =  false,
	["HasMenu"] = false,
	["Category"] = "Config",
	["UseCustomPrivCheck"] = true,
	["PrivCheck"] = location_mgmt_check,
	["AllowWildcard"] = true
}

function callfunc(caller,args) 
     if !args[1] then 
     	return false,"No location name specified."
     end
     local res,err = Mercury.GotoExt.AddLocation(args[1],caller:GetEyeTraceNoCursor().HitPos)
     if !res then 
     	return res,err
     end
    return true, "", true,{caller,Mercury.Config.Colors.Default," has added location ",Mercury.Config.Colors.Arg,args[1]}
end

Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

local function location_mgmt_check(ply)
	return ply:HasPrivilege("location_management")
end


MCMD = {
	["Command"] = "locdel",
	["Verb"] = "@SETUSETEAMS",
	["RconUse"] = true,
	["Useage"] = "addloc <name>",
	["UseImmunity"] =  false,
	["HasMenu"] = false,
	["Category"] = "Config",
	["UseCustomPrivCheck"] = true,
	["PrivCheck"] = location_mgmt_check,
	["AllowWildcard"] = true
}

function callfunc(caller,args) 
     if !args[1] then 
     	return false,"No location name specified."
     end
     local res,err = Mercury.GotoExt.RemoveLocation(args[1])
     if !res then 
     	return res,err
     end
    return true, "", true,{caller,Mercury.Config.Colors.Default," has deleted location ",Mercury.Config.Colors.Arg,args[1]}
end

Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)



MCMD = {
	["Command"] = "lgo",
	["Verb"] = "@SETUSETEAMS",
	["RconUse"] = true,
	["Useage"] = "addloc <name>",
	["UseImmunity"] =  false,
	["HasMenu"] = false,
	["Category"] = "Config",
	["UseCustomPrivCheck"] = false,
	["PrivCheck"] = location_mgmt_check,
	["AllowWildcard"] = true
}

function callfunc(caller,args) 
     if !args[1] then 
     	return false,"No location name specified."
     end

     local res,err = Mercury.GotoExt.GetLocation(args[1])

     if !res then 
     	return res,err
     end

     caller:SetPos(res)

    return true, "", true,{caller,Mercury.Config.Colors.Default," has gone to location ",Mercury.Config.Colors.Arg,args[1]}
end

Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)




MCMD = {
	["Command"] = "loclist",
	["Verb"] = "@SETUSETEAMS",
	["RconUse"] = true,
	["Useage"] = "addloc <name>",
	["UseImmunity"] =  false,
	["HasMenu"] = false,
	["Category"] = "Config",
	["UseCustomPrivCheck"] = false,
	["PrivCheck"] = location_mgmt_check,
	["AllowWildcard"] = true
}

function callfunc(caller,args) 
     for k,v in SortedPairs(Mercury.GotoExt.GetTable()) do 
     	caller:ChatPrint(k)
     end

    return true, "", true,{}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


local MCMD = Mercury.Commands.CreateTable("goto", "gone to", false, "<player>", false, true, true, "Teleportation") 
function callfunc(caller,args)
	local r,m = CheckPrivacy(caller,args[1])
	if r then 
		return false,m
	end 	

	caller.__RETURNPOS = caller:GetPos()
	caller:SetPos(args[1]:GetPos() + Vector(0,0,80) )
	 
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
	DButtonRmsel:SetText( "GoTo" )
	DButtonRmsel:SetSize( 130, 60 )
	DButtonRmsel:SetDisabled(true)
	DButtonRmsel.DoClick = function(self)
		if self:GetDisabled()==true then return false end
			surface.PlaySound("buttons/button3.wav")
			net.Start("Mercury:Commands")
				net.WriteString("goto")
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


-- bring
local MCMD = Mercury.Commands.CreateTable("bring", "brought", true, "<player>", true, true, true, "Teleportation")
function callfunc(caller,args)

	local r,m = CheckPrivacy(caller,args[1])
	if r then 
		return false,m
	end 	


	args[1].__RETURNPOS = args[1]:GetPos()
	args[1]:SetPos(caller:GetPos() + Vector(0,0,80) )

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
	DButtonRmsel:SetText( "Bring" )
	DButtonRmsel:SetSize( 130, 60 )
	DButtonRmsel:SetDisabled(true)
	DButtonRmsel.DoClick = function(self)
		if self:GetDisabled()==true then return false end
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("bring")
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



MCMD = {
	["Command"] = "tp",
	["Verb"] = "teleported",
	["RconUse"] = true,
	["Useage"] = "teleported",
	["UseImmunity"] =  true,
	["HasMenu"] = true,
	["Category"] = "Teleportation",
	["UseCustomPrivCheck"] = false,
	["PlayerTarget"] = true,
	["AllowWildcard"] = true
}

function callfunc(caller,args)
	local r,m = CheckPrivacy(caller,args[1])
	if r then 
		return false,m
	end 	

	args[1].__RETURNPOS = args[1]:GetPos()
	args[1]:SetPos(caller:GetEyeTraceNoCursor().HitPos + Vector(0,0,72))
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
	DButtonRmsel:SetText( "Teleport" )
	DButtonRmsel:SetSize( 130, 60 )
	DButtonRmsel:SetDisabled(true)
	DButtonRmsel.DoClick = function(self)
		if self:GetDisabled()==true then return false end
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("tp")
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


MCMD = {
	["Command"] = "return",
	["Verb"] = "returned themselves to their original position",
	["RconUse"] = false,
	["Useage"] = "return",
	["UseImmunity"] =  true,
	["HasMenu"] = false,
	["UseCustomPrivCheck"] = false,
	["PlayerTarget"] = false,
	["AllowWildcard"] = false
}


function callfunc(caller,args)
	if !caller.__RETURNPOS then 
		return false,"You have no location to return to."
	end
	
	caller:SetPos(caller.__RETURNPOS )
	return true, "heh", false,{}
end

Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)




MCMD = {
	["Command"] = "privacy",
	["Verb"] = "enabled privacy",
	["RconUse"] = true,
	["Useage"] = "",
	["UseImmunity"] =  true,
	["HasMenu"] = false,
	["Category"] = "Teleportation",
	["UseCustomPrivCheck"] = false,
	["PlayerTarget"] = true,
	["AllowWildcard"] = true
}

function callfunc(caller,args)
	if !args[1].MercuryPrivacy then 
		args[1].MercuryPrivacy = false
	end
	args[1].MercuryPrivacy = not args[1].MercuryPrivacy
	if args[1].MercuryPrivacy==true then 
		Mercury.Util.SendMessage(caller,{Mercury.Config.Colors.Default,args[1],"'s privacy mode has been ", Mercury.Config.Colors.Arg, "enabled."})
		if args[1]!=caller and IsValid(caller) then 
			Mercury.Util.SendMessage(caller,{Mercury.Config.Colors.Default,args[1],"'s privacy mode has been ", Mercury.Config.Colors.Arg, "enabled."})
		end 
	end

	if args[1].MercuryPrivacy==false then 
		Mercury.Util.SendMessage(args[1],{Mercury.Config.Colors.Default,args[1],"'s privacy mode has been ", Mercury.Config.Colors.Arg, "disabled."})
		if args[1]!=caller and IsValid(caller) then 
			Mercury.Util.SendMessage(caller,{Mercury.Config.Colors.Default,args[1],"'s privacy mode has been ", Mercury.Config.Colors.Arg, "disabled."})
		end 
	end

	args[1]:SetNWBool("MercuryPrivacy",args[1].MercuryPrivacy)
	return true, "heh", true, {}// empty table
end


Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc) 