SAPI = {}
SAPI.Version = "Zerf_1.1"

--Found here: http://facepunch.com/showthread.php?t=1400043
--Modified based on version "Hotel 1"

   GAME_COUNTER_STRIKE  = 10
    GAME_TEAM_FORTRESS_CLASSIC = 20
    GAME_DAY_OF_DEFEAT = 30
    GAME_DEATHMATCH_CLASSIC = 40
    GAME_OPPOSING_FORCE = 50
    GAME_RICOCHET = 60
    GAME_HALF_LIFE = 70
    GAME_CONDITION_ZERO = 80
    GAME_HALF_LIFE_BLUE_SHIFT = 130
    GAME_HALF_LIFE_2 = 220
    GAME_COUNTER_STRING_SOURCE = 240
    GAME_HALF_LIFE_SOURCE = 280
    GAME_DAY_OF_DEFEAT_SOURCE = 300
    GAME_HALF_LIFE_2_DEATHMATCH = 320
    GAME_HALF_LIFE_LOST_COAST = 340
    GAME_HALF_LIFE_DEATHMATCH_SOURCE = 360
    GAME_HALF_LIFE_2_EPISODE_1 = 380
    GAME_HALF_LIFE_2_EPISODE_2 = 320
    GAME_HALF_LIFE_2_EPISODE_3 = nil
    GAME_TEAM_FORTRESS_2 = 440
    GAME_LEFT_4_DEAD = 500
    GAME_LEFT_4_DEAD_2 = 550
    GAME_DOTA_2 = 570
    GAME_PORTAL_2 = 620
    GAME_ALIEN_SWARM = 630
    GAME_COUNTER_STRIKE_GLOBAL_OFFENSIVE = 730 // or 1800? I don't know, it was documented twice, both with different IDs.
    GAME_SIN_EPISODES_EMERGENCE = 1300
    GAME_DARK_MESSIAH = 2100
    GAME_DARK_MESSIAH_MULTIPLAYER = 2130
    GAME_THE_SHIP = 2400
    GAME_THE_SHIP_TUTORIAL = 2400
    GAME_BLOODY_GOOD_TIME = 2450
    GAME_VAMPIRE_BLOODLINES = 2600
    GAME_GARRYSMOD = 4000
    GAME_ZOMBIE_PANIC = 17500
    GAME_AGE_OF_CHIVALRY = 17510
    GAME_SYNERGY = 17520
    GAME_DIPRIP = 17530
    GAME_ETERNAL_SILENCE = 17550
    GAME_PIRATES_VIKINGS_KNIGHTS = 17570
    GAME_DYSTOPIA = 17580
    GAME_INSURGENCY = 17700
    GAME_NUCLEAR_DAWN = 17710
    GAME_SMASHBALL = 17730



local apikey = "FC198EA5435F3DC82A2AE6149A6510ED"
local apiurl = "http://api.steampowered.com/"
local jdec = util.JSONToTable
local jenc = util.TableToJSON
local fetch = http.Fetch
local assert = assert

local function checkkey()
	assert(#apikey > 1, "No API key is defined. Change the 'apikey' line in this file.")
end

local function callbackcheck(code)
	assert(code~=401, "Authorization error (Is your key valid?)")
	assert(code~=500, "Steam servers appear to be busy.")
	assert(code~=404, "API page not found.")
	assert(code~=400, "Bad module request.")
end

local function steamid_verify(id)
	if string.find(id,"STEAM_") then
		id = util.SteamIDTo64(tostring(id))
	end
	assert(#id == 17, "Invalid SteamID passed to GSAPI! (Use Steam32 or Steam64)")
	return id
end

local function GenericAPIQuery(method, steamid, callback, exargs)
	checkkey()
	steamid = steamid_verify(steamid)

	local fetchstr = apiurl .. method .. "?key=" .. apikey .. "&steamid=" .. steamid .. "&steamids=" .. steamid .. "&format=json"
	if exargs then
		for k, v in pairs(exargs) do
			fetchstr = fetchstr.."&"..k.."="..v
		end
	end

	fetch(fetchstr, function(body, _, _, code)
		callbackcheck(code)
		local data = jdec(body)
		data = (data.response) and data.response or data
		callback(data)
	end,
	function(err)
		assert(false, "GSAPI HTTP error: "..err)
	end)
end

function SAPI.GetPlayerSummaries(steamid,callback)
	GenericAPIQuery("ISteamUser/GetPlayerSummaries/v0002/", steamid, function(data)
		callback(data.players)
	end)
end

function SAPI.GetFriendList(steamid,callback)
	GenericAPIQuery("ISteamUser/GetFriendList/v0001/", steamid, function(data)
		local flist = (data.friendslist) and data.friendslist.friends or false
		callback(flist)
	end)
end

function SAPI.GetUserGroupList(steamid,callback)
	GenericAPIQuery("ISteamUser/GetUserGroupList/v1/", steamid, function(data)
		if data.success == true then
			local ret = {}
			for i, g in pairs(data.groups) do
				ret[g.gid] = true
			end
			callback(ret)
		end
	end)
end

function SAPI.GetPlayerBans(steamid,callback)
	GenericAPIQuery("ISteamUser/GetPlayerBans/v1/", steamid, function(data)
		callback(data.players[1])
	end)
end

function SAPI.GetSteamLevel(steamid,callback)
	GenericAPIQuery("IPlayerService/GetSteamLevel/v1/", steamid, function(data)
		callback(data.player_level)
	end)
end

function SAPI.IsPlayingSharedGame(steamid,appid,callback)
	appid = appid or 4000
	GenericAPIQuery("IPlayerService/IsPlayingSharedGame/v0001/", steamid, function(data)
		local sid = (data.lender_steamid == 0) and false or data.lender_steamid
		callback(sid)
	end, {appid_playing = appid})
end
