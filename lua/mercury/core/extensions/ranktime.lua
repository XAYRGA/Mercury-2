if Mercury.Config["UseRankTime"]~=true then return false end // Disable the service.


local RankTime = {}
if (!file.Exists("mercury/timedata/","DATA")) then
    file.CreateDir("mercury/timedata/") // Check for directory
end
function RankTime.SaveSingle(GAX)
  if IsValid(GAX) and GAX:IsPlayer() then
    if !GAX.__TIME or !GAX.TimeLoaded then
        return false
    end
    local uid = GAX:UniqueID()
    local time = GAX.__TIME
    file.Write("mercury/timedata/" ..  uid .. ".txt",tostring(time))
   
  end
end
       
 
 
function RankTime.SaveAll()
    for k,v in pairs(player.GetAll()) do
        RankTime.SaveSingle(v)
    end
end
  
function RankTime.PIS(P)
    local uid = P:UniqueID()
    if file.Exists("mercury/timedata/" ..  uid .. ".txt","DATA") then
        local fstr = file.Read("mercury/timedata/" ..  uid .. ".txt","DATA")
        local ptime = tonumber(fstr,10)
        if ptime then 
             P.__TIME = ptime
             P.TimeLoaded = true 
        
        else 
            MsgC(Mercury.Config.Colors.Error,"Mercury encountered an error loading the time for " .. tostring(P) .. ", check their data file.\n")
        end 
        else
        P.__TIME = 0
        P.TimeLoaded = true
    end
end
 
for k,v in pairs(player.GetAll()) do
        RankTime.PIS(v)
end
local lastsave = 0
 
function RankTime.Tick()
    pcall(function() // Be safe.
    lastsave = lastsave + 1
    for k,v in pairs(player.GetAll()) do

        if v.TimeLoaded==true and v.__TIME then
            v.__TIME = v.__TIME + 1
            v:SetNWInt("ranktime",v.__TIME)
        end
    end
    if lastsave > 30 then
        RankTime.SaveAll()
        lastsave = 0
    end
   
    end)
end
 


timer.Create("RankTick",1,0,function()
    pcall(function()
        RankTime.Tick()    
    
    end)
end)
Mercury.RankTime = RankTime 
hook.Add("PlayerInitialSpawn","Mercury:RankTime",function(x) RankTime.PIS(x) end)
