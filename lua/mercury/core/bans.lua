Mercury.Bans = {}
local function mtag(...)
	MsgC(Color(100,255,100),"[Mercury-Bans]: ")
end
 
mtag() 	MsgC(Color(255,255,0),"Checking existance of bans folder... ")
if !file.Exists("mercury/bans","DATA") then
	MsgC(Color(255,0,0)," NO  \n")
	file.CreateDir("mercury/bans") 
	  MsgN(" ") mtag() 	MsgC(Color(255,255,0),"Data folder created \n")
	else
		 MsgC(Color(0,255,0)," OK. \n")
end


local function SAFESID(steam) return string.gsub(steam,":","_") end
local function USAFESID(steam) 

	local gx = string.gsub(steam,"_",":")
	local ax = string.sub(steam,7,#steam)
	gx = string.gsub(ax,"_",":")
	return "STEAM_" ..gx
end

function Mercury.Bans.GetTime() 
	return os.time()
end

function Mercury.Bans.GetTimeStruct(minuites)
	return (Mercury.Bans.GetTime() + (minuites * 60))
end

function Mercury.Bans.GetBanDuration(bantime) -- RETURNS BAN LENGTH IN MINUITES.
	return  math.Round((bantime - Mercury.Bans.GetTime()) / 60)
end

function Mercury.Bans.UnbanID(STEAM,REASON)

	 if (file.Exists("mercury/bans/" .. SAFESID(STEAM) .. ".txt","DATA")) then
	 		file.Delete("mercury/bans/" .. SAFESID(STEAM) .. ".txt")
	
	 		return true,nil
	 else

	 		return false,"Ban did not exist!"

	 end
	
end
function Mercury.Bans.IsBanned(STEAM)
	 if (file.Exists("mercury/bans/" .. SAFESID(STEAM) .. ".txt","DATA")) then
	 	local FI = file.Read("mercury/bans/" .. SAFESID(STEAM) .. ".txt","DATA") -- READ BAN.
		local BINF = util.JSONToTable(FI)
		if BINF["unbantime"]~=0 then
			if BINF["unbantime"] <= Mercury.Bans.GetTime() then
				Mercury.Bans.UnbanID(STEAM ,"AUTO: BAN TIME EXPIRED.") return false
			end
		end

	 	return true,BINF["reason"],BINF["unbantime"] ,BINF["bannedby"]
	 		
	 else
	 	return false,"NOT BANNED",0
	 end
end


--util.SteamIDFrom64( string id ) 
function Mercury.Bans.Prune()
	for k,v in pairs(file.Find("mercury/bans/*.txt","DATA")) do
		-- Decode table
		pcall(function()

			local FI = file.Read("mercury/bans/" .. v,"DATA") -- READ BAN.
			local BINF = util.JSONToTable(FI)
			if BINF["unbantime"]~=0 then
				if BINF["unbantime"] <= Mercury.Bans.GetTime() then
					Mercury.Bans.UnbanID(string.sub(v,#v-#v,#v-4) ,"AUTO: BAN TIME EXPIRED.")
				end
			end
		end)
	end
end
 

function Mercury.Bans.Add(caller,plr,time,rsn)
	if !plr then return false,"No player specified" end
	if !time then time = 5 end
	if !type(caller)=="Player" then caller = "[SERVER]" else
		if type(caller)=="Player" then
			 caller = caller:GetName()
		end
	end


	local ban = {}
	ban["bannedby"] = caller
	if time~=0 then
		ban["unbantime"] = Mercury.Bans.GetTimeStruct(time)
	else
		ban["unbantime"] = 0
	end
	rsn = string.gsub(rsn,[["]],"-")
	ban["reason"] = rsn
	if type(plr)=="Player" then
		ban["Name"] = plr:Nick()
		file.Write("mercury/bans/" .. SAFESID(plr:SteamID()) .. ".txt",util.TableToJSON(ban))
	else
		file.Write("mercury/bans/" .. SAFESID(plr) .. ".txt",util.TableToJSON(ban))


		for k,v in pairs(player.GetAll()) do
			if v:SteamID()==plr then 
				timer.Simple(0.1,function()	// takes a few frames for the command to process w/ player entity for some reason :B 
					v:Kick(rsn)
				end)
			end
		end

	end
	

 end

 local BannedSounds = {
 	"vo/spy_dominationdemoman04.mp3",
 	"vo/spy_dominationengineer04.mp3",
 	"vo/spy_dominationscout07.mp3",
 	"vo/spy_dominationsniper05.mp3",
 	"vo/spy_laughlong01.mp3",
 	"vo/spy_negativevocalization05.mp3",
 }

function Mercury.Bans.ConnectionCheck(steamID,ipAdress, svPassword, clPassword, name, override)
	if svPassword and svPassword !="" then 
		if clPassword~=svPassword then return false,"Incorrect password!" end
	end
	local stm = util.SteamIDFrom64( steamID )
	if override!=nil then 
		override = true 
	end


		if SAPI then 
			local AccountID = SAPI.IsPlayingSharedGame(stm,GAME_GARRYSMOD,function(newid)

				if newid~="0" then 
					local newstm = util.SteamIDFrom64( newid )
					print(newstm)
					local banned,reason,time,banner = Mercury.Bans.IsBanned(newstm)
					if banned then 
							game.KickID(stm, "The account associated with this one (" .. newstm .. ") is banned. "  .. reason )

							Mercury.Util.Broadcast({Color(255,1,1,255),name,Color(47,150,255,255), " was dropped (" ..  "The account associated with this one (" .. newstm .. ") is banned. ("  .. reason .. ")"})

					end 
				end 

			end)			
		end 


	if Mercury.Bans.IsBanned(stm) or override then
	
		local banned,reason,time,banner = Mercury.Bans.IsBanned(stm)
		if override then banned = true end 
		banned = (not banned) -- I have to reverse the result of the value, due to the nature of the hook.
		local banmsg = "Sorry " .. name .. " you have been banned!  Though unfortunately we were unable to retrieve any information on your ban."
		if !reason then reason  = banmsg end
	//	local abl = BannedSounds[math.random(1,#BannedSounds)]
//		for k,v in pairs(player.GetAll()) do
//			v:EmitSound(abl)
//		end


		if banned==false then 
			if time~=0 then 
				-- banmsg = "Your ban expires in: " .. Mercury.Bans.GetBanDuration(time) .. "(" .. reason.. ")"
				banmsg = 
				[[Greetings %s, we're sorry to inform you that you are banned. 
				You will be unbanned: %s

				Reasoning: %s 

				Inflicting Administrator: %s ]]
				banmsg = string.format(banmsg,name,os.date("%x @ %X", Mercury.Bans.GetBanDuration(time)*60 + os.time()  ) or 0,reason or "",banner or "")

			else
					banmsg = 
				[[Greetings %s, we're sorry to inform you that you are banned.
				This ban is not set to expire. 

				Reasoning: %s 
				Banning Administrator Name: %s .]]
				banmsg = string.format(banmsg,name,reason,banner)
			end
				print("[BANSYS]: CNCT_DENY_BANNED " .. stm .. " " .. banmsg)
				Mercury.Util.Broadcast({Color(255,1,1,255),name,Color(47,150,255,255), " has tried to connect but is banned for " .. reason})
			else
				//Mercury.Util.Broadcast({Color(255,1,1,255),name,Color(47,150,255,255), " has connected."})

		end


		return banned,banmsg
	end
end
hook.Add("CheckPassword","MARS_CheckBanned",Mercury.Bans.ConnectionCheck)
concommand.Add("Mercury_TestBan",function(P,C,A)
	P:ChatPrint(	tostring(Mercury.Bans.ConnectionCheck(unpack(A))) )
end)
  
net.Receive("Mercury:BanData",function(len,p)
	local args = net.ReadString()
	if args == "GET_DATA" then 
		
		local bdata = {}
		for k,v in pairs(file.Find("mercury/bans/*.txt","DATA")) do
			-- Decode table
			local FI = file.Read("mercury/bans/" .. v,"DATA") -- READ BAN.
			if !FI then FI="" print("!!! Mercury is unable to decode ban " .. v) end 
			local BINF = util.JSONToTable(FI)
			local bkey = USAFESID(v)
			
			if BINF then 
				bkey = string.sub(bkey,0,#bkey-4)
				BINF.STEAMID = USAFESID(bkey)
				BINF.TimeRemaining = Mercury.Bans.GetBanDuration(BINF["unbantime"])  
				if BINF.TimeRemaining < -1 then 
					BINF.TimeRemaining = "Unbanned."
				end

				if BINF["unbantime"]==0 then 
					BINF.TimeRemaining = "Never"
				end
			
				bdata[#bdata + 1] = BINF
			else 
				print("!!! Mercury is unable to decode ban " .. v)
				//p:SendLua([[ Mercury.Menu.ShowWarning("Unable to decode ban ]] .. v .. [[")]])
			end
		end
		net.Start("Mercury:BanData")
			net.WriteTable({data = bdata,tchunks = 0,chunkno = 0})
		net.Send(p)


	end

end)

Mercury.ModHook.Add("PrivilegesReady","UnbanBot",function()
	Mercury.Bans.UnbanID("BOT","Bots don't need to be banned.")
end)