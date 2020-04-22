--.____           __           .__                  .__  __  ._.
--|    |    _____/  |_  ______ |  |   ____   ____   |__|/  |_| |
--|    |  _/ __ \   __\/  ___/ |  |  /  _ \ / ___\  |  \   __\ |
--|    |__\  ___/|  |  \___ \  |  |_(  <_> ) /_/  > |  ||  |  \|
--|_______ \___  >__| /____  > |____/\____/\___  /  |__||__|  __
--        \/   \/          \/             /_____/             \/



Mercury.Logs = {}
Mercury.Logs.Version = "1.8"
Mercury.Logs.OldMsgC = MsgC
Mercury.Logs.OldPrint = print
Mercury.Logs.LastKnownSpray = nil
Mercury.Logs.ExcludeTools = {
	["leafblower"] =  true,
	["inflator"] = true
}
-- Configs
Mercury.Logs.Configs = {}
Mercury.Logs.Configs.IsActive = Mercury.Config.LoggingActive or true
Mercury.Logs.Configs.LogCustomEvents = true
Mercury.Logs.Configs.LogNPCKills = true
Mercury.Logs.Configs.LogPlayerDeaths = true
Mercury.Logs.Configs.LogChat = true
Mercury.Logs.Configs.LogPlayerConnections = true
Mercury.Logs.Configs.LogPlayerAuthed = true
Mercury.Logs.Configs.LogPlayerDisconnections = true
Mercury.Logs.Configs.LogPropSpawn = true
Mercury.Logs.Configs.LogEntSpawn = true
Mercury.Logs.Configs.LogPlayerInitialSpawns = true
Mercury.Logs.Configs.LogPlayerSpawns = true
Mercury.Logs.Configs.LogPropDeath = true
Mercury.Logs.Configs.LogTools = true 
Mercury.Logs.Configs.DetectSpraySystem = false 

if Mercury.Logs.Configs.IsActive == true then
	-- System initailized - save stuff?
	print("-----------------------")
	print("Mercury Log "..Mercury.Logs.Version.."  Initialized")
	print("Advanced Logging System")
	-- File writitng
	function Mercury.Logs.GetDateString() 
		return os.date("%m-%d-%y")
	end

	function Mercury.Logs.GetTimeStamp()
		return os.date("[%H:%M] ")
	end

	Mercury.Logs.FileName = Mercury.Logs.GetDateString()

	if not file.IsDir("mercury/logs/", "DATA") then
		file.CreateDir("mercury/logs")
	end

	if file.Exists("mercury/logs/" .. Mercury.Logs.FileName .. ".txt", "DATA") then
		print("File exists - extending")
		print("-----------------------")
	else
		file.Write("mercury/logs/" .. Mercury.Logs.FileName .. ".txt", "~~~ HG Log Start ~~~\n")
		print("Creating Log File")
		print("-----------------------")
	end

	local function MsgC(COLVEC, STRM)
		file.Append("mercury/logs/" .. Mercury.Logs.FileName .. ".txt", Mercury.Logs.GetTimeStamp() .. STRM)
		Mercury.Logs.OldMsgC(COLVEC, STRM)
	end

	local function print(STRM)
		file.Append("mercury/logs/" .. Mercury.Logs.FileName .. ".txt",  STRM .. "\n")
		Mercury.Logs.OldPrint(STRM)
	end

	function Mercury.Logs.CustomEvent(event)
		Msg("[HG] ") MsgC(Color(255,0,0,255), "[Custom Event]") print(" "..event)
	end

	function Mercury.Logs.CustomEventNoOutput(event)
		file.Append("mercury/logs/" .. Mercury.Logs.FileName .. ".txt",  Mercury.Logs.GetTimeStamp().."[Custom Event] "..event.."\n")
	end
	
	if Mercury.Logs.Configs.LogNPCKills == true then
		-- An npc was killed, lets log it
		function Mercury.Logs.NPCKilled(vic, ply, wep)
			if not IsValid(ply) or not ply:Team() then return end 
			
			if IsValid(ply) and IsValid(vic) then
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[NPC Death]" ) print("("..team.GetName(ply:Team())..") "..ply:Nick().." ("..ply:SteamID()..") - Killed: "..vic:GetName().." "..vic:GetClass())
			elseif IsValid(ply) then
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[NPC Death]" ) print("("..team.GetName(ply:Team())..") "..ply:Nick().." ("..ply:SteamID()..") - Killed: _unknown_")
			elseif IsValid(vic) then
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[NPC Death]" ) print("(_unknown_) _unknown_ (_unknown_) - Killed: "..vic:GetName().." "..vic:GetClass())
			else
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[NPC Death]" ) print("(_unknown_) _unknown_ (_unknown_) - Killed: _unknown_")
			end
		end
		hook.Add("OnNPCKilled", "HG NPC Killed", Mercury.Logs.NPCKilled)
	end

	if Mercury.Logs.Configs.LogPlayerDeaths == true then
		-- A player died, lets log it
		function Mercury.Logs.PlayerDeath(vic, ply, dmginfo)
			if not ply:IsPlayer() then return end
			if IsValid(vic) and IsValid(ply) then
				if vic == ply then 
					Msg("[HG] ") MsgC(Color(255,0,0,255), "[Player Death]" ) print("("..team.GetName(ply:Team())..") "..ply:Nick().." ("..ply:SteamID()..") committed suicide.")
				else
					Msg("[HG] ") MsgC(Color(255,0,0,255), "[Player Death]" ) print("("..team.GetName(ply:Team())..") "..ply:Nick().." ("..ply:SteamID()..") - Killed: "..vic:Nick().." ("..vic:SteamID()..")")
				end
			elseif IsValid(ply) then
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Player Death]" ) print("("..team.GetName(ply:Team())..") "..ply:Nick().." ("..ply:SteamID()..") - Killed: _unknown_ (_unknown_)")
			elseif IsValid(vic) then
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Player Death]" ) print("(_unknown_) _unknown_ (_unknown_) - Killed: "..vic:Nick().." ("..vic:SteamID()..")")
			else
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Player Death]" ) print("(_unknown_) _unknown_ (_unknown_) - Killed: _unknown_ (_unknown_)")
			end
		end
		hook.Add("PlayerDeath", "HG Player Death", Mercury.Logs.PlayerDeath)
	end

	if Mercury.Logs.Configs.LogChat == true then
		-- A player said something, lets log it
		function Mercury.Logs.ChatPrint(ply, txt, teamonly)
			if IsValid(ply) then
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Chat] TeamOnly?: "..tostring(teamonly).." ") print("("..team.GetName(ply:Team())..") "..ply:Nick().." ("..ply:SteamID().."): "..txt)
			end
		end
		hook.Add("PlayerSay", "HG Player Chat", Mercury.Logs.ChatPrint)
	end

	if Mercury.Logs.Configs.LogPlayerConnections == true then
		-- A player connected, lets log it
		function Mercury.Logs.Connect(nam,adr)
			Msg("[HG] ") MsgC(Color(255,0,0,255), "[Connect] " ) print(nam.." : "..adr)
		end
		hook.Add("PlayerConnect", "HG Player Connected", Mercury.Logs.Connect)
	end

	if Mercury.Logs.Configs.LogTools == true then
		-- A player connected, lets log it


		function Mercury.Logs.Tool(ply,tr,tool)
			if !Mercury.Logs.ExcludeTools[tool] then 
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Tool] " ) print(tostring(ply) .. " [" ..tool .."] on " .. tostring(tr.Entity) )
			end
		end
		hook.Add("CanTool", "HG TOol Used", Mercury.Logs.Tool)
	end

	if Mercury.Logs.Configs.LogPlayerAuthed == true then
		-- A player was just authed, lets log it
		function Mercury.Logs.Auth(ply, steam, uid)
			if IsValid(ply) and steam and uid then
				Msg("[HG] ") MsgC(Color(0,255,0,255), "[Auth] " ) print(ply:Name().." : "..steam.." : "..uid)
			elseif IsValid(ply) and uid then
				Msg("[HG] ") MsgC(Color(0,255,0,255), "[Auth] " ) print(ply:Name().." : "..ply:SteamID().." : "..uid)
			elseif IsValid(ply) and steam then
				Msg("[HG] ") MsgC(Color(0,255,0,255), "[Auth] " ) print(ply:Name().." : "..steam.." : _unknown_")
			else
				Msg("[HG] ") MsgC(Color(0,255,0,255), "[Auth] " ) print("_unknown_ : _unknown_ : _unknown_")
			end
		end
		hook.Add("PlayerAuthed", "HG Player Authed", Mercury.Logs.Auth )
	end

	if Mercury.Logs.Configs.LogPlayerDisconnections == true then
		-- A player disconnected, lets log it 
		function Mercury.Logs.Disconnect(ply)
			if IsValid(ply) then
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Disconnect] " ) print("("..team.GetName(ply:Team())..") "..ply:Nick().." : "..ply:SteamID())
			else
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Disconnect] " ) print("A player left the server.")
			end
		end
		hook.Add( "PlayerDisconnected", "HG Player Disconnected", Mercury.Logs.Disconnect )
	end

	if Mercury.Logs.Configs.LogPropSpawn == true then
		-- A prop was spawned, lets log it
		function Mercury.Logs.Prop(ply , model)
			if IsValid(ply) and model then
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Prop] " ) print("("..team.GetName(ply:Team())..") "..ply:Nick().." ("..ply:SteamID()..") spawned "..model)
			elseif IsValid(ply) then
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Prop] " ) print("("..team.GetName(ply:Team())..") "..ply:Nick().." ("..ply:SteamID()..") spawned _unknown_")
			elseif model then
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Prop] " ) print("(_unknown_) _unknown_ (_unknown_) spawned "..model)
			else
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Prop] " ) print("(_unknown_) _unknown_ (_unknown_) spawned _unknown_")
			end
		end
		hook.Add("PlayerSpawnedProp", "HG Prop", Mercury.Logs.Prop)
	end

	if Mercury.Logs.Configs.LogEntSpawn == true then
		-- An entity was spawned, lets log it
		function Mercury.Logs.Ent(ply, ent)
			if IsValid(ply) and IsValid(ent) then
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Ent] " ) print("("..team.GetName(ply:Team())..") "..ply:Nick().." ("..ply:SteamID()..") spawned "..ent:GetClass())
			elseif IsValid(ply) then
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Ent] " ) print("("..team.GetName(ply:Team())..") "..ply:Nick().." ("..ply:SteamID()..") spawned _unknown_")
			elseif IsValid(ent) then
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Ent] " ) print("(_unknown_) _unknown_ (_unknown_) spawned "..ent:GetClass())
			else
				Msg("[HG] ") MsgC(Color(255,0,0,255), "[Ent] " ) print("(_unknown_) _unknown_ (_unknown_) spawned _unknown_")
			end
		end
		hook.Add("PlayerSpawnedSent", "HG Ent", Mercury.Logs.Ent)
	end

	if Mercury.Logs.Configs.LogPlayerInitialSpawns == true then
		-- A player just spawned, lets log it
		function Mercury.Logs.InitialSpawn(ply)
			if IsValid(ply) then
				Msg("[HG] ") MsgC(Color(0,255,0,255), "[Initial Spawn] " ) print("("..team.GetName(ply:Team())..") "..ply:Nick() .. " (" .. ply:SteamID() .. ") spawned in the server.")

				-- Incase other addons want argus' initial spawn
				hook.Call("HG:PlayerInitialSpawn", GAMEMODE, ply)
			else
				Msg("[HG] ") MsgC(Color(0,255,0,255), "[Initial Spawn] " ) print("A player just spawned in the server.")
			end

		end
		hook.Add("PlayerInitialSpawn", "HG Initial Spawn", Mercury.Logs.InitialSpawn)
	end

	if Mercury.Logs.Configs.LogPlayerSpawns == true then
		-- A player respawned, lets log it
		function Mercury.Logs.Spawn(ply)
			if IsValid(ply) then
				Msg("[HG] ") MsgC(Color(0,255,0,255), "[Spawn] " ) print("("..team.GetName(ply:Team())..") "..ply:Nick() .. " (" .. ply:SteamID() .. ") (re)spawned.")
				
				-- Incase other addons want argus' spawn
				hook.Call("HG:PlayerSpawn", GAMEMODE, ply)
			else
				Msg("[HG] ") MsgC(Color(0,255,0,255), "[Spawn] " ) print("A player spawned.")
			end
		end
		hook.Add("PlayerSpawn", "HG Spawn", Mercury.Logs.Spawn)
	end

	if Mercury.Logs.Configs.LogPropDeath == true then
		-- A player died by a prop, lets log it
		function Mercury.Logs.PropDeath(ply, ent)
			-- lets log for only certain entities types
			local ent_table = {"prop_static", "prop_physics", "prop_ragdoll", "prop_dynamic", "prop_physics_multiplayer", "durgz_lsd"}
		    
		    -- Lets log it!
		    if IsValid(ply) and IsValid(ent) then
			    if table.HasValue(ent_table, ent:GetClass())  and not ent:IsPlayer() then
					Msg("[HG] ") MsgC(Color(0,255,0,255), "============================= \n") 
					Msg("[HG] ") MsgC(Color(0,255,0,255), "Player was killed by prop \n") 
					Msg("[HG] ") MsgC(Color(0,255,0,255), "Victim: " .. ply:Nick() .. "\n") 
					if IsValid(ent:CPPIGetOwner()) then
						Msg("[HG] ") MsgC(Color(0,255,0,255), "Prop owner: " .. tostring(ent:CPPIGetOwner():Nick()) .. "\n") 
					else
						Msg("[HG] ") MsgC(Color(0,255,0,255), "Prop owner: Could not be determined\n") 
					end
					Msg("[HG] ") MsgC(Color(0,255,0,255), "Prop model: " .. ent:GetModel() .. "\n") 
					Msg("[HG] ") MsgC(Color(0,255,0,255), "============================= \n") 
				end
			else
				Msg("[HG] ") MsgC(Color(0,255,0,255), "=============================\n") 
				Msg("[HG] ") MsgC(Color(0,255,0,255), "Player was killed by prop \n") 
				
				if IsValid(ply) then
					Msg("[HG] ") MsgC(Color(0,255,0,255), "Victim: " .. ply:Nick() .. "\n") 
				else
					Msg("[HG] ") MsgC(Color(0,255,0,255), "Victim: Could not be determined\n") 
				end
				
				if IsValid(ent) then
					if IsValid(ent:CPPIGetOwner()) then
						Msg("[HG] ") MsgC(Color(0,255,0,255), "Prop owner: " .. tostring(ent:CPPIGetOwner():Nick()) .. "\n") 
					else
						Msg("[HG] ") MsgC(Color(0,255,0,255), "Prop owner: Could not be determined\n") 
					end
					Msg("[HG] ") MsgC(Color(0,255,0,255), "Prop model: " .. ent:GetModel() .. "\n") 
				else
					Msg("[HG] ") MsgC(Color(0,255,0,255), "Prop model: Could not be determined\n") 
					Msg("[HG] ") MsgC(Color(0,255,0,255), "Prop owner: Could not be determined\n") 
				end

				Msg("[HG] ") MsgC(Color(0,255,0,255), "=============================\n" ) 
			end
		end
		hook.Add("PlayerDeath", "HG Prop Death", Mercury.Logs.PropDeath)
	end

	if Mercury.Logs.Configs.DetectSpraySystem == true then
		-- A player sprayed, lets log it
		function Mercury.Logs.DetectSpray(ply)
			if IsValid(ply) then
				Msg("[HG] ") MsgC(Color(0,255,0,255), "[Sprayed] " ) print("("..team.GetName(ply:Team())..") "..ply:Nick() .. " (" .. ply:SteamID() .. ") sprayed his/her logo. To go to it type\n.tptospray "..tostring(ply:GetPos()))
				Mercury.Logs.LastKnownSpray = ply:GetPos()
			end
		end
		hook.Add("PlayerSpray", "HG Detect Spray", Mercury.Logs.DetectSpray)

		-- Associated Command with DetectSpray
		function Mercury.Logs.DetectedSprayTeleport(ply, txt)
			local command = string.Explode(" ", txt)
			if command[1] == ".tptospray" then
				if ply:IsAdmin() then
					if command[2] and command[3] and command[4] then
						local pos = Vector(0, 0, 0)
						pos.x, pos.y, pos.z = command[2], command[3], command[4]

						ply:SetMoveType(MOVETYPE_NOCLIP)
						ply:SetPos(pos)
					else
						if Mercury.Logs.LastKnownSpray != nil then
							ply:SetMoveType(MOVETYPE_NOCLIP)
							ply:SetPos(Mercury.Logs.LastKnownSpray)
						else
							MsgPly(ply, "HG has not detected a recent spray")
						end
					end
				end
			end
		end
		hook.Add("PlayerSay", "HG Detect Spray Teleport", Mercury.Logs.DetectedSprayTeleport)
	end
else
	print("-----------------------")  
	print("HG  "..Mercury.Logs.Version.."  Disabled")
	print("Advanced Logging System")
	print("-----------------------")

	hook.Remove("OnNPCKilled", "HG NPC Killed")
	hook.Remove("PlayerDeath", "HG Player Death")
	hook.Remove("PlayerSay", "HG Player Chat")
	hook.Remove("PlayerConnect", "HG Player Connected")
	hook.Remove("PlayerAuthed", "HG Player Authed")
	hook.Remove("PlayerDisconnected", "HG Player Disconnected")
	hook.Remove("PlayerSpawnedProp", "HG Prop")
	hook.Remove("PlayerSpawnedSent", "HG Ent")
	hook.Remove("PlayerInitialSpawn", "HG Initial Spawn")
	hook.Remove("PlayerSpawn", "HG Spawn")
	hook.Remove("PlayerDeath", "HG Prop Death")
	hook.Remove("PlayerSpray", "HG Detect Spray")
	hook.Remove("PlayerSay", "HG Detect Spray Teleport")
end