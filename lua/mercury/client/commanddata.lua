Mercury.Commands = {}
Mercury.Commands.CommandTable = {}
local GlobalPrivileges = {"*root"}

function Mercury.Commands.AddPrivilege(str) 
  str = string.lower(str)
  for k,v in pairs(GlobalPrivileges) do
    if string.lower(v)==str then return false,"PRIVLAGE ALREADY EXISTS" end
  end
  print("Adding priv " .. str)
  GlobalPrivileges[#GlobalPrivileges + 1] = str
end

function Mercury.Commands.GetPrivileges()
  return table.Copy(GlobalPrivileges)
end

-- Function used to create command table
function Mercury.Commands.CreateTable(command, verb, hasrcon, usage, hasimmunity, hasplayertarget, hasmenu, category, hascustomprivledge, privledgecheckfunction)
    if not command then error("No command name was given to function") return end
    if not verb then verb = "" end
    if not hasrcon then hasrcon = false end
    if not usage then usage = "" end
    if not hasimmunity then hasimmunity = true end
    if not hasplayertarget then hasplayertarget = false end
    if not hasmenu then hasmenu = false end
    if not category then category = "Uncategorized" end
    if not hascustomprivledge then hascustomprivledge = false end
    if not privledgecheckfunction then privledgecheckfunction = nil end
    print("loading command " .. command)
    local tab = {}
    tab.Command = command
    tab.Verb = verb
    tab.RconUse = hasrcon
    tab.Useage = usage
    tab.UseImmunity = hasimmunity
    tab.PlayerTarget = hasplayertarget
    tab.HasMenu = hasmenu
    tab.Category = category
    tab.UseCustomPrivCheck = hascustomprivledge
  tab.PrivCheck = privledgecheckfunction

    return tab
end

function Mercury.Commands.AddCommand(comname,comtab,callfunc)
  if !comname then return false,"NO INDEX" end
  if !comtab then return false,"Empty command" end
  comname = string.lower(comname)
  if !comtab.UseCustomPrivCheck then 
    Mercury.Commands.AddPrivilege(comname)
  end

  Mercury.Commands.CommandTable[comname] = comtab
end

for k,v in pairs(file.Find("mercury/commands/*.lua","LUA")) do
  print("load command category " .. v)
  include("mercury/commands/" .. v) // Give loowa.
end

