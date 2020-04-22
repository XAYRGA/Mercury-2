Mercury.Localizer = {Languages = {}}
Mercury.Localization = {}


local locmt_idx = {
	__index =  function(self,idx)
		return rawget(self,idx) or "{Missing localizer string " .. idx .. "}"
	end

}

setmetatable(Mercury.Localization,locmt_idx)

for k,v in pairs(file.Find("mercury/languages/*.lua","LUA")) do
	LANG = {}
	include("mercury/languages/" ..v )
	if SERVER then 
		AddCSLuaFile("mercury/languages/" .. v)
	end 
	Mercury.Localizer.Languages[LANG.key] = LANG
	print("Loaded language " .. v) 
	if CLIENT then print(true) end 
end


function Mercury.Localizer.SetLanguage(lang)

	if !Mercury.Localizer.Languages[lang] then return false end
	for k,v in pairs(Mercury.Localizer.Languages[lang]) do 
		Mercury.Localization[k] = v
	end
	print("Setting language to " .. lang)
	Mercury.ModHook.Call("LanguageChanged",lang)
end

function Mercury.Localizer.SetString(str,text)
	Mercury.Localization[str] = text
end

if CLIENT  then 
	Mercury.ModHook.Add("GotConfig","SetLanguage",function()
		print(" DO IT ")
		Mercury.Localizer.SetLanguage(Mercury.Config.Language)
	end )

else 
		Mercury.Localizer.SetLanguage(Mercury.Config.Language)
end 