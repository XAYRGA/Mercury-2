Mercury.GotoExt = {}
Mercury.GotoExt.Locations = {}

local ad = file.Read("mercury/gotolocs.txt","DATA") or ""

local map = game.GetMap()


Mercury.GotoExt.Locations = util.JSONToTable(ad)
 
if !Mercury.GotoExt.Locations then 
	Mercury.GotoExt.Locations = {}
end

if !Mercury.GotoExt.Locations[map] then 
	Mercury.GotoExt.Locations[map] = {} 
end 

local function save()
	file.Write("mercury/gotolocs.txt",util.TableToJSON(Mercury.GotoExt.Locations,true))
end
Mercury.GotoExt.Save = save

function Mercury.GotoExt.AddLocation(nam,loc)
	local nam = string.lower(nam)
	if Mercury.GotoExt.Locations[map][nam]  then 
		return false, "A location with that name already exists "
	end
	Mercury.GotoExt.Locations[map][nam] = loc
	save()
	return true
end


function Mercury.GotoExt.RemoveLocation(nam)
	local nam = string.lower(nam) 
	if !Mercury.GotoExt.Locations[map][nam]  then 
		return false, "Cannot delete location as it does not exist"
	end
	Mercury.GotoExt.Locations[map][nam] = nil
	save()
	return true
end


function Mercury.GotoExt.GetLocation(nam)
	local nam = string.lower(nam)
	if !Mercury.GotoExt.Locations[map][nam]  then 
		return false, "Location was not found in location table"
	end
	return Mercury.GotoExt.Locations[map][nam] 
end

function Mercury.GotoExt.GetTable(nam)
	return table.Copy(Mercury.GotoExt.Locations[map])
end
