Mercury.Ranks = {}
Mercury.Ranks.RankTable = {}
Mercury.Ranks.AdminRanks = {}
Mercury.Ranks.__TEAMACCESS = {}

Mercury.Ranks.RankTable["default"] =  { -- MARS is dependent on this rank.
	title = "Guest",
	order = 99999,
	color = {r= 0,g=0,b=255}, -- Yeah.. sorry about this. The meathod i'm using to save this litterally HATES vectors / colors
	commands = {"motd"},
	immunity = -1000,
	admin = false,
	superadmin = false,
}

Mercury.Ranks.RankTable["owner"] = {
	color = Color(255,255,255),
	title = "Owner",
	privileges = {"*root"},
	immunity = 1000,
	order = 1,
	admin = true,
	superadmin = true

}

net.Receive("Mercury:RankData",function()
local command = net.ReadString()
local args =  net.ReadTable()

	if command=="SEND_RANKS" then

		Mercury.Ranks.RankTable = args
		for k,rtab in pairs(Mercury.Ranks.RankTable) do
			local title = rtab.title
			local order = rtab.order
			local color = rtab.color 
			if Mercury.Config["UseTeams"]==true then 
				team.SetUp(order - Mercury.Config["TeamOffset"]  , title, color, false ) 
			end
		end
		
	end


end)

metaplayer = FindMetaTable("Player")

function metaplayer:GetUserRank()
	local xad = self:GetNWString("UserRank")
	if xad == "" or xad==nil then 
		return "default"
	end
	return xad
end

 

function metaplayer:GetRank()
	local xad = self:GetNWString("UserRank")
	if xad == "" or xad==nil then 
		return "default"
	end
	return xad
end




function metaplayer:GetRankTable()
	return Mercury.Ranks.RankTable[self:GetUserRank()]
end
function metaplayer:GetImmunity()
		return Mercury.Ranks.RankTable[self:GetUserRank()].immunity
end
function metaplayer:HasPrivilege(x) 
	if !x then return false,"NO PRIVLAGE?" end
	local rnk = self:GetUserRank()
	x = string.lower(x)
		local gax = Mercury.Ranks.RankTable[rnk]
		for k,v in pairs(gax["privileges"]) do
			if x==v or v=="*root" then return true end
		end
/*
		if Mercury.Commands.CommandTable[x] then
			
			if Mercury.Commands.CommandTable[x].UseCustomPrivCheck then 
				return Mercury.Commands.CommandTable[x].PrivCheck(self)
			end 
			
		end 
		*/
		return false 
end

hook.Add("HUDPaint","MInitialRankUpdate",function()
	net.Start("Mercury:RankData")
		net.WriteString("GET_RANKS")
		net.WriteTable({"0"})
	net.SendToServer()
	hook.Remove("HUDPaint","MInitialRankUpdate")

end)





timer.Create("Mercury.OverrideAdmin",1,0,function() // Its just me, gabe newell.
	function metaplayer:GetUserGroup()
		return self:GetRank()
	end

	function metaplayer:IsUserGroup(grp)
		local grp2 = string.lower(grp)
		if self:GetRank()==grp2 then return true end

		return false
	end

	function metaplayer:IsAdmin()
		local admin = false 
			if Mercury then 
				if Mercury.Ranks then 
					if Mercury.Ranks.RankTable then 
						if Mercury.Ranks.RankTable[self:GetRank()] then 
							if Mercury.Ranks.RankTable[self:GetRank()].admin==true or Mercury.Ranks.RankTable[self:GetRank()].superadmin==true then
											admin = true
							end

						end 

					end 

				end 

			end 
		return admin
	end

	function metaplayer:IsSuperAdmin()
			local admin = false 
			pcall(function()
				if  Mercury.Ranks.RankTable[self:GetRank()].superadmin==true then
					admin = true
				end

			end)
		return admin
	end

end)
