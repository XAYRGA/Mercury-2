	for _,f in pairs(file.Find("mercury/menu/*.lua","LUA")) do
		local S,ER =	pcall(function() AddCSLuaFile("mercury/menu/" .. f) end) // OUCH!!!! MY MEMORY!!!
		if (S) then print("MenuSend: " .. f) else
	 		 Msg("[Mercury-Menu-Packager]: " .. ER)
		end
	end
	
for k,v in pairs(file.Find("mercury/menu/rsc/*.lua","LUA")) do
	AddCSLuaFile("mercury/menu/rsc/" ..v )
	print("MenuSend /rsc/ " .. v)
end


for k,v in pairs(file.Find("mercury/menu/elements/*.lua","LUA")) do
	AddCSLuaFile("mercury/menu/elements/" ..v )
	print("MenuSend /elements/ " .. v)
end

