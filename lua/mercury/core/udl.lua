Mercury.UDL = {}
// The worst library in here.

UDL = Mercury.UDL 
UDL.Debug = false 
local function SAFESID(steam) return string.gsub(steam,":","_") end


local function mtag(...)
	MsgC(Color(100,255,100),"[Mercury-UDL]: ")
end 

mtag() 	MsgC(Color(255,255,0),"Checking existance of users folder... ")
if !file.Exists("mercury/users","DATA") then
	MsgC(Color(255,0,0)," NO.  \n")
	file.CreateDir("mercury/users") 
	MsgN(" ") mtag() 	MsgC(Color(255,255,0),"Data folder created \n")
else
	MsgC(Color(0,255,0)," OK. \n")
end


function UDL.GetData(data)
	if type(data)=="Player" then
		local uid = SAFESID(data:SteamID())
		if file.Exists("mercury/users/"..uid..".txt","DATA") then
			local pts =  file.Read("mercury/users/" .. uid .. ".txt","DATA")
	
			return util.JSONToTable(pts)
		else
			file.Write("mercury/users/" .. uid .. ".txt",util.TableToJSON({rank = "default"}))
			return {rank = "default"}
		end
	elseif type(data)==string then
		local uid = SAFESID(data)
		if file.Exists("mercury/users/"..uid..".txt","DATA") then
			local pts =  file.Read("mercury/users/" .. uid .. ".txt")
			return util.JSONToTable(pts)
		else
			file.Write("mercury/users/" .. uid .. ".txt",util.TableToJSON({rank = "default"}))
			return {rank = "default"}
		end
	else
		Error("Type " .. type(data) .. " is not supported.")
	end
end

function UDL.SaveData(data,tablea)
	if UDL.Debug then 
		print("~~MERCURY UDL~~")
		print("SERIALIZE DATA TABLE")
		print(tostring(tablea))
		print(tostring(data))


	end 
	if type(data)=="Player" then

		local uid = SAFESID(data:SteamID())
		file.Write("mercury/users/" .. uid .. ".txt",util.TableToJSON(tablea))
		if UDL.Debug then
			print("FILESYSTEM ACCESS ")
			print("WRITE mercury/users/" .. uid)
			
			

		end
		return true
	elseif type(data)==string then
		local uid = SAFESID(data)
		file.Write("mercury/users/" .. uid .. ".txt",util.TableToJSON(tablea))
		return true
	else
		print("[MERCURY-RANKS]: ERROR!!!!!! BAD DATA TYPE FOR UDL.GetPoints()")
		Error("Type " .. type(data) .. " is not supported.")
		return false
		
	end
end


 
function UDL.SaveAllActive()
	for k,v in pairs(player.GetAll()) do 
		if !v._RANK then return end
		UDL.SaveData(v,{rank = v._RANK,userdata = v._MercuryUserData})
	end
end

function UDL.SaveSingle(v)
	
		if !v._RANK then return end
		UDL.SaveData(v,{rank = v._RANK,userdata = v._MercuryUserData})
		
end

function UDL.PIS(P)
	local shouldrank = UDL.GetData(P)
	if ( game.SinglePlayer( ) or P:IsListenServerHost( ) ) then
		shouldrank.rank = "owner"
		UDL.SaveData(P,shouldrank)
	end

	Mercury.Ranks.SetRank(P,shouldrank.rank)
	P._MercuryUserData = shouldrank.userdata or {}
	P.RankLoaded = true
	P._MercuryUserData.LastKnownName = P:Nick()
	P._MercuryUserDataLoaded = true
	Mercury.ModHook.Call("PostUserDataLoaded",P,shouldrank.userdata)
end

function UDL.SetSaveRank(P,rank)
	local a,d,c = Mercury.Ranks.SetRank(P,rank)
	if !a then 
		return a,d,c
	end
	local x = P:GetRank()
	UDL.SaveData(P,{rank = x,userdata = P._MercuryUserData})
	return true
end

hook.Add("PlayerInitialSpawn","Mercury:UDL:PlayerSpawnRank",UDL.PIS)


timer.Create("Mercury:SaveRankGlobal",30,0,function()
	Mercury.UDL.SaveAllActive()
end)


