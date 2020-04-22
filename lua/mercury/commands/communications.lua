Mercury.Commands.AddPrivilege("commcontrol")
Mercury.Commands.AddPrivilege("adminchat")
 
hook.Add("PlayerSay","MercuryComm",function(XAD, txt,tea )
	local etab = string.Explode(" ",string.lower(txt))
	if XAD["Muted"] ==true then 
		return ""		
	end
	if etab[1]=="/me" then 
		local rck = string.Explode(" ",txt)
		table.remove(rck,1)
		for k,v in pairs(player.GetAll()) do 
			v:ChatPrint( "*"  .. XAD:Nick() .. " " .. table.concat(rck," "))
		end
		return ""
	end
	if tea==true or etab[1]=="~" or etab[1]=="@" then 
		if etab[1]=="~" or etab[1]=="@" then 
			txt = string.sub(txt,2,#txt)
		end 

			local rck = string.Explode(" ",txt)
			table.remove(rck,1)
			for k,v in pairs(player.GetAll()) do 
				if v:HasPrivilege("adminchat") then 
					Mercury.Util.SendMessage(v,{Mercury.Config.Colors.Arg,"~ADMIN - ",XAD,Mercury.Config.Colors.Arg,": ", txt })
				end
			end
			return ""
	
	end




	if etab[1]=="!aboutmercury" then 
		
		for k,v in pairs(player.GetAll()) do 
				Mercury.Util.SendMessage(v,{Color(255,255,255) ,"Mercury Administration System ~ version (HungryHungry)HOTEL 9.3 Created by " , Color(255,0,255) , " FreezeBug " , Color(255,255,255), " with help from ", Color(255,0,0), " Rusketh, Mythic, Merc, and !cake" })
		end
		return ""
	end



end, -18 )

hook.Add("PlayerCanHearPlayersVoice","mercurygag",function(XAD, ply)
	if ply.Gagged==true then 
		return false,false
	end
end)

Mercury.ModHook.Add("PostUserDataLoaded","CommGag",function(Ply)
	if Ply._MercuryUserData["gaginfo"] then 
		if Ply._MercuryUserData["gaginfo"]["permagagged"] == true then
			Ply.Gagged = true
		end 
	end 


	if Ply._MercuryUserData["muteinfo"] then 
		if Ply._MercuryUserData["muteinfo"]["permamuted"] == true then
			Ply.Muted = true
		end 
	end 

end) 



local function CommPrivCheck(ply)
	return ply:HasPrivilege("commcontrol",true)
end


MCMD = {
	["Command"] = "mute",
	["Verb"] = "muted",
	["RconUse"] = true,
	["Useage"] = "!mute <player>",
	["UseImmunity"] =  true,
	["HasMenu"] = true,
	["Category"] = "Communications",
	["UseCustomPrivCheck"] = true,
	["PlayerTarget"] = true,
	["PrivCheck"] = CommPrivCheck,
	["AllowWildcard"] = true
}

function callfunc(caller,args)
	local addon = {"."}
	if args[2] == "true" then 
		if !args[1]._MercuryUserData["muteinfo"] then 
			args[1]._MercuryUserData["muteinfo"] = {permamuted = true}
			addon = {" for ",Color(255,0,0), "eternity",Mercury.Config.Colors.Default,"."}
			Mercury.UDL.SaveSingle(args[1])
		end 
	end 

	args[1].Muted = true 
	return true, "", true, {Mercury.Config.Colors.Default,caller," has muted ", args[1],unpack(addon) }
end

function MCMD.GenerateMenu(frame)
	local selectedplayer = nil 

	local ctrl = vgui.Create( "DListView", frame)
	ctrl:AddColumn( "Players" )
	ctrl:SetSize( 210, 380 )	
	ctrl:SetPos( 10, 0 )
				
	local UnmuteButton = vgui.Create( "DButton" , frame)
	local MuteButton = vgui.Create( "DButton" , frame)
	MuteButton:SetPos( 240, 40 )
	MuteButton:SetText( "Mute Chat" )
	MuteButton:SetSize( 130, 60 )
	MuteButton:SetDisabled(true)
	MuteButton.DoClick = function(self)
		if self:GetDisabled()==true then return false end
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("mute")
			net.WriteTable({selectedplayer})
		net.SendToServer()
	end

	UnmuteButton:SetPos( 240, 120 )
	UnmuteButton:SetText( "Unmute Chat" )
	UnmuteButton:SetSize( 130, 60 )
	UnmuteButton:SetDisabled(true)
	UnmuteButton.DoClick = function(self)
		if self:GetDisabled()==true then return false end
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("unmute")
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
		UnmuteButton:SetDisabled(false)
		MuteButton:SetDisabled(false)
		selectedplayer = line_obj.ply
		return true
	end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

MCMD = {
	["Command"] = "denmark",
	["Verb"] = "censored",
	["RconUse"] = true,
	["Useage"] = "!mute <player>",
	["UseImmunity"] =  true,
	["HasMenu"] = true,
	["Category"] = "Communications",
	["UseCustomPrivCheck"] = true,
	["PlayerTarget"] = true,
	["PrivCheck"] = CommPrivCheck,
	["AllowWildcard"] = true
}

function callfunc(caller,args)

	args[1].Muted = true 
	return true, "", false, {}
end

Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Unmute
MCMD = {
	["Command"] = "unmute",
	["Verb"] = "unmuted",
	["RconUse"] = true,
	["Useage"] = "!unmute <player>",
	["UseImmunity"] = true,
	["HasMenu"] = false,
	["Category"] = "Communications",
	["UseCustomPrivCheck"] = true,
	["PrivCheck"] = CommPrivCheck,
	["PlayerTarget"] = true,
	["AllowWildcard"] = true
}
function callfunc(caller,args)
	args[1].Muted = false

	if args[1]._MercuryUserData["muteinfo"] then 

			args[1]._MercuryUserData["gaginfo"] = {permagagged = false}
			Mercury.UDL.SaveSingle(args[1])
	end 


	return true, "", false, {}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Gag
MCMD = {
	["Command"] = "gag",
	["Verb"] = "gagged",
	["RconUse"] = true,
	["Useage"] = "!gag <player>",
	["UseImmunity"] =  true,
	["HasMenu"] = true,
	["Category"] = "Communications",
	["UseCustomPrivCheck"] = true,
	["PrivCheck"] = CommPrivCheck,
	["PlayerTarget"] = true,
	["AllowWildcard"] = true
}

function callfunc(caller,args)
	args[1].Gagged = true
	local addon = {"."}

	if args[2] == "true" then 
		if !args[1]._MercuryUserData["gaginfo"] then 
			args[1]._MercuryUserData["gaginfo"] = {permagagged = true}
			addon = {" for ",Color(255,0,0), "eternity",Mercury.Config.Colors.Default,"."}
			Mercury.UDL.SaveSingle(args[1])
		end 
	end 

	return true, "", true, {caller,Mercury.Config.Colors.Default," has gagged ", args[1],unpack(addon) }
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
	GagButton:SetText( "Gag Voice" )
	GagButton:SetSize( 130, 60 )
	GagButton:SetDisabled(true)
	GagButton.DoClick = function(self)
		if self:GetDisabled()==true then return false end
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("gag")
			net.WriteTable({selectedplayer})
		net.SendToServer()
	end

	UnGagButton:SetPos( 240, 120 )
	UnGagButton:SetText( "UnGag Voice" )
	UnGagButton:SetSize( 130, 60 )
	UnGagButton:SetDisabled(true)
	UnGagButton.DoClick = function(self)
		if self:GetDisabled()==true then return false end
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("ungag")
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
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)




MCMD = {
	["Command"] = "ungag",
	["Verb"] = "ungagged",
	["RconUse"] = true,
	["Useage"] = "!ungag <player>",
	["UseImmunity"] =  true,
	["HasMenu"] = false,
	["Category"] = "Communications",
	["UseCustomPrivCheck"] = true,
	["PrivCheck"] = CommPrivCheck,
	["PlayerTarget"] = true,
	["AllowWildcard"] = true
}

function callfunc(caller,args)
		args[1].Gagged = false


		if args[1]._MercuryUserData["gaginfo"] then 

			args[1]._MercuryUserData["gaginfo"] = {permagagged = false}
			Mercury.UDL.SaveSingle(args[1])
		end 



	return true, "", false, {}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)