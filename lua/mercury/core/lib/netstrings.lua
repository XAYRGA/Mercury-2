///////////////Mercury Netstrings Defenitions/////////////
///////////////Defines all communication channels with client/////////////
local NetStrings = {
	"Mercury:ChatPrint",
	"Mercury:RankData",
	"Mercury:BanData",
	"Mercury:MenuData",
	"Mercury:Commands",
	"Mercury:Config",
	"Mercury:Progress"


}

for k,v in pairs(NetStrings) do 
	print("Adding network string: " .. v)
	util.AddNetworkString(v)

end