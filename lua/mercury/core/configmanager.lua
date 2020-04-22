Mercury.ConfigManager = {}
local types = {}
local defaults = {}


function Mercury.ConfigManager.WriteConfig()
	local rma = util.TableToJSON(Mercury.Config) 
	file.Write("mercury/config.txt",rma)
	Mercury.ConfigManager.RefreshAll()
	return true
end

function Mercury.ConfigManager.Receive(len,ply)

	local COMMAND = net.ReadString()
	local CARGS = net.ReadTable()
	if COMMAND=="GET_CONFIG" then 
		
		Mercury.ConfigManager.SendConfig(ply)

	end
end
net.Receive("Mercury:Config",Mercury.ConfigManager.Receive)

function Mercury.ConfigManager.SendConfig(ply)

	net.Start("Mercury:Config")
			net.WriteString("SEND_CONFIG")
			net.WriteTable(Mercury.Config)
	net.Send(ply)

end


function Mercury.ConfigManager.RefreshAll()

	Mercury.ConfigManager.SendConfig(player.GetAll())

end


function Mercury.ConfigManager.Receive(len,ply)

	local COMMAND = net.ReadString()
	local CARGS = net.ReadTable()
	if COMMAND=="GET_CONFIG" then 
		
		Mercury.ConfigManager.SendConfig(ply)

	end

end


function Mercury.ConfigManager.SendConfig(ply)

	net.Start("Mercury:Config")
			net.WriteString("SEND_CONFIG")
			net.WriteTable(Mercury.Config)
	net.Send(ply)

end


function Mercury.ConfigManager.RefreshAll()

	Mercury.ConfigManager.SendConfig(player.GetAll())

end