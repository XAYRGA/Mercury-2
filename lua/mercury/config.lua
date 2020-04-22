Mercury.Config = {
	UseScoreboard = true,
	UseTeams = true,
	Language = "enUS",

	TeamOffset = 50000, 
	UseRankTime = true,


	Colors = {
			Default = Color(255,255,255,255),
			Error = Color(255,131,85),
			Arg = Color(102,198,255),
			Rank = Color(130,255,132),
			Server = Color(1,1,1),
			Setting = Color(255,100,255),
			

		},

	EnabledPackages = {},
}
 


/////////// Do not modify below this line //////////////////


if SERVER then 
	local tab = file.Read("mercury/config.txt","DATA")
	if tab then 
		local jdata = util.JSONToTable(tab)
		for k,v in pairs(jdata) do
				Mercury.Config[k] = v
		end
	end
end
 

if CLIENT then

	hook.Add("HUDPaint","MercuryGetConfig",function()
		net.Start("Mercury:Config")
			net.WriteString("GET_CONFIG")
			net.WriteTable({})
		net.SendToServer()
		hook.Remove("HUDPaint","MercuryGetConfig")
	end) 

	net.Receive("Mercury:Config",function()
		local COMMAND = net.ReadString()
		local CARGS = net.ReadTable()
		if COMMAND=="SEND_CONFIG" then 
			Mercury.Config = CARGS
			print("Got config")
			Mercury.ModHook.Call("GotConfig")
		end
	end)
end