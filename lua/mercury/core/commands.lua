Mercury.Commands = {Logs = {}}
Mercury.Commands.CommandTable = {}
local GlobalProperties = {
	"Command",
	"Verb",
	"RconUse",
	"Useage", 
	"UseImmunity",
	"PlayerTarget",
	"HasMenu",
	"Category",
	"UseCustomPrivCheck",
	"PrivCheck"

}
local GlobalPrivileges = {
	"*root"
}
  
	local function tconcat(tabl,con,sp)
		if !sp then sp = 1 end 
		local istr = tostring(tabl[sp])
		for I=sp + 1,#tabl do 

			istr = istr .. con .. tostring(tabl[I])
		end 
		return istr
	end


	function Mercury.Commands.Logs.GetDateString() 
		return os.date("%m-%d-%y")
	end

	function Mercury.Commands.Logs.GetTimeStamp()
		return os.date("[%H:%M] ")
	end

	Mercury.Commands.Logs.FileName = Mercury.Commands.Logs.GetDateString()

	if not file.IsDir("mercury/logs/commands", "DATA") then
		file.CreateDir("mercury/logs/commands")
	end

	if file.Exists("mercury/logs/commands/" .. Mercury.Commands.Logs.FileName .. ".txt", "DATA") then
		print("File exists - extending")
		print("")
	else
		file.Write("mercury/logs/commands/" .. Mercury.Commands.Logs.FileName .. ".txt", "~~~ HG CommandLog Start ~~~\n")
		print("Creating Log File")
		print("-----------------------")
	end

	print(Mercury.Commands.Logs.FileName)
	Mercury.Commands.Logs.OldMsgC = MsgC
	Mercury.Commands.Logs.OldPrint = print
	Mercury.Commands.Logs.OldMsgN = MsgN


	local function WriteTimestamp()
		file.Append("mercury/logs/commands/" .. Mercury.Commands.Logs.FileName .. ".txt", Mercury.Commands.Logs.GetTimeStamp() .. " ")
	end
	local function MsgC(COLVEC, STRM)
		file.Append("mercury/logs/commands/" .. Mercury.Commands.Logs.FileName .. ".txt", STRM)
		
		Mercury.Commands.Logs.OldMsgC(COLVEC, STRM)
	end

	local function print(STRM)
		file.Append("mercury/logs/commands/" .. Mercury.Commands.Logs.FileName .. ".txt",  tostring(STRM) .. "")
		Mercury.Commands.Logs.OldPrint(STRM)
	end

	local function MsgN(STRM)
		file.Append("mercury/logs/commands/" .. Mercury.Commands.Logs.FileName .. ".txt",  tostring(STRM) .. "\n")
		Mercury.Commands.Logs.OldMsgN(STRM)
	end


-- Who cares?
function Mercury.Commands.AddPrivilege(str)	
	str = string.lower(str)
	for k,v in pairs(GlobalPrivileges) do
		if string.lower(v)==str then return false,"PRIVLAGE ALREADY EXISTS" end
	end
	GlobalPrivileges[#GlobalPrivileges + 1] = str
end

function Mercury.Commands.GetPrivileges()
	return table.Copy(GlobalPrivileges)
end

-- Function used to create command table
/* NOTICE! THIS FUNCTION WILL BE DEPRECATED */
/* DO NOT USE IT                            */
function Mercury.Commands.CreateTable(command, verb, hasrcon, usage, hasimmunity, hasplayertarget, hasmenu, category, hascustomprivledge, privledgecheckfunction)
   	if command==nil then error("No command name was given to function") return end
   	if verb==nil then verb = "" end
   	if hasrcon==nil then hasrcon = false end
   	if usage==nil then usage = "" end
   	if hasimmunity==nil then hasimmunity = true end
   	if hasplayertarget==nil then hasplayertarget = false end
   	if hasmenu==nil then hasmenu = false end
   	if category==nil then category = "Uncategorized" end
   	if hascustomprivledge==nil then hascustomprivledge = false end
   
   	
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
	print("ADDING COMMAND " .. comname)
	comname = string.lower(comname)
	if not comtab.UseCustomPrivCheck then 
		Mercury.Commands.AddPrivilege(comname)
	end
	comtab._CALLFUNC = callfunc
	Mercury.Commands.CommandTable[comname] = comtab
end

local function plookup(info)

	if  type(info)=="Player" then  // This is just so I  don't have to add code to implement  entity targeting xD
		return {info}
	end

	if !type(info)=="string" then return nil end


	local targets ={}
	for k, v in pairs(player.GetAll()) do
	
		local find = string.find(string.lower(v:Name()), string.lower(tostring(info)),1,#v:Name(),true)

		if not (find==1 and (info=="&" or info=="") ) and find then
			targets[#targets + 1] = v
		end
		if v:SteamID()==info then
			targets[#targets + 1] = v
		end
	end

	return targets
end      
Mercury.Commands.PlayerLookup = plookup




 // 					Mercury.Util.Broadcast({Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default, " has " .. com.Verb .." ",gabe,Mercury.Config.Colors.Default, "."})
function Mercury.Commands.Call(caller,command,args,silent) 
	if !command then return false,{"No command specified."} end // Check for specified command.
	WriteTimestamp()
	MsgC(Mercury.Config.Colors.Setting,"[HG] ")
	command = string.lower(command)

	if !Mercury.Commands.CommandTable[command] then 

		MsgC(Mercury.Config.Colors.Default,tostring(caller) .. " tried to run " )
		MsgC(Mercury.Config.Colors.Arg,command)
		MsgC(Mercury.Config.Colors.Default," but it didn't exist.")
		MsgN(" ")

		return false,{"Command does not exist."}
	end // Check for existance of command

	local CommandTable = Mercury.Commands.CommandTable[command] 
	local CallerIdentifier ="[SERVER]"
	local RconIsCalling = false 
	local Targets = {}
	local ptarget = nil


	if not IsValid(caller) then 
		  caller = "[SERVER]"
		  RconIsCalling = true // Ring ring
	end

	if RconIsCalling then 
		if CommandTable.RconUse == false then 
			return false,{"Rcon cannot use this command."}

		end

	end 

	//* Checking for privileges
	if not RconIsCalling then // * Rcon is god
			if not CommandTable.UseCustomPrivCheck then 
				if not caller:HasPrivilege(command) then 

					MsgC(Mercury.Config.Colors.Default,tostring(caller) .. " tried to run " )
					MsgC(Mercury.Config.Colors.Arg,command)
					MsgC(Mercury.Config.Colors.Default," but didn't have access. ")
					MsgN(" ")
					return false,{"You do not have access to this command."}
				end 
			else //* Command has a custom privilege check.
				if not CommandTable.PrivCheck(caller) then 
					return false,{"You do not have access to this command."}
				end 
			end
	end 

	// TARGETED COMMANDS
	

	if CommandTable.PlayerTarget then 

		if !args[1] then 
			if CommandTable.AllowWildcard then //Check if command allows wildcard to be used 
				Targets[#Targets + 1] = caller 
			else 
				return false,{"No target was specified for the command."}
			end
		end
		
		if args[1] then 
			if type(args[1])=="string" then 
				if CommandTable.AllowWildcard then
					local names = string.Explode("&",args[1])
					for i,nam in pairs(names) do 
						if nam=="^" then 
							Targets[#Targets + 1] = caller 	
						end 
						if nam=="*" then 
							for k,v in pairs(player.GetAll()) do
								if !RconIsCalling then 
									if caller:CanUserTarget(v) then 
										Targets[#Targets + 1] =  v
									end
								else 
									Targets[#Targets + 1] =  v
								end
							end
						end 
					
						local plys = plookup(string.Trim(nam))
							for d,ply in pairs(plys) do 
								if IsValid(ply) then 
									Targets[#Targets + 1] = ply 
								end  
							end 


						if (nam[1]=="!") then 
						local rem = plookup(string.sub(nam,2))
						if nam[2]=="^" then 
							rem[#rem + 1] = caller
						end 
						for k,v in pairs(rem) do 
							for i,ply in pairs(Targets) do 
								if ply==v then 
									table.remove(Targets,i)
								end 

							end 
						end 
					end 
				end 
			else 
					Targets = plookup(args[1])
				end 
								


				if #Targets==0 then 
					return false,{"No target was found."}
				end
					
				
			else 
				
				local tgs = plookup(args[1])
				if #tgs == 0 then 
					return false,{"No target was found."}
				end 

				if #tgs > 0 then 
					if #tgs > 1 and not CommandTable.AllowWildcard then 
						local playernamesor = {} 
						for I=1,#tgs do 
							if I~=#tgs then 
								playernamesor[#playernamesor + 1] = tgs[I]
								playernamesor[#playernamesor + 1] = ", "
							else 
								playernamesor[#playernamesor + 1] =  " or "
								playernamesor[#playernamesor + 1] = tgs[I] 
								playernamesor[#playernamesor + 1] = "?"
							end
						end
						return false,{"Multiple targets found, did you mean ", unpack(playernamesor) }
					end
					for k,v in pairs(tgs)do 
						Targets[#Targets + 1] = v 
					end 
				
				end
				
			end
		end

		local success,error,custom,ctable
		for k,v in pairs(Targets) do 

			local s,fnc_rsl,fnc_msg = pcall( function()
				local ar2 = args
				ar2[1] = v

				if not RconIsCalling then 
				 	if not CommandTable.UseImmunity==false and not  caller:CanUserTarget(v) then 
				 		MsgC(Mercury.Config.Colors.Default,tostring(caller) .. " tried to run " )
						MsgC(Mercury.Config.Colors.Arg,command)
						MsgC(Mercury.Config.Colors.Default," on " .. tostring(v) .. " but can't target them.")
						MsgN(" ")
				 		return false, {"You cannot target " , v }
				 	end 
				end
				/////////Problem Here
				local STS,EXEC_ERR = pcall(function()


				
					success,error,custom,ctable = CommandTable._CALLFUNC(caller,args)			

						MsgC(Mercury.Config.Colors.Default,tostring(caller) .. " ran command " )
						MsgC(Mercury.Config.Colors.Arg,command)
						MsgC(Mercury.Config.Colors.Default," on " .. tostring(args[1]) .. " {" .. tconcat(args,", ",2) .. "}")
						MsgN(" ")
				end)

				if !STS then 
						MsgC(Mercury.Config.Colors.Default,tostring(caller) .. " tried to run " )
						MsgC(Mercury.Config.Colors.Arg,command)
						MsgC(Mercury.Config.Colors.Default," on " .. tostring(v) .. " but ")
					
						MsgC(Color(255,0,0)," SOMETHING TERRIBLE HAPPENED. ")
						Msg(EXEC_ERR)
							MsgN(" ")
					return false,{"Command execution error ", EXEC_ERR}

				end
					
				if type(error) == "string" then // Legacy command support
					if error == "@SYNTAX_ERR" then
						error = {"Command syntax error. Syntax of this command is: ", command ,	" ",	CommandTable.Useage}
					else 
						error = {error}
					end
				end
				if success then 
					if custom then 
						if not silent then 
							if #ctable > 1 then 
								Mercury.Util.Broadcast({Mercury.Config.Colors.Server, unpack( ctable ) })
							end
						else 
							//Mercury.Util.SendMessage(caller, {Mercury.Config.Colors.Server, "(SILENT) ", unpack( ctable ) })
						end 

					else 
						if not silent then 
							Mercury.Util.Broadcast({Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default, " has " .. CommandTable.Verb .." ",v,Mercury.Config.Colors.Default, "."})				
						else 
							// Mercury.Util.SendMessage(caller, {Mercury.Config.Colors.Server,"(SILENT) ",caller,Mercury.Config.Colors.Default, " has " .. CommandTable.Verb .." ",v,Mercury.Config.Colors.Default, "."})
						end

					end
					return true,{"Command completed successfully. "} 

				else 
					return false,error
				end

 
		
 

			end)
			 

			 	if s==false then 
					return false,fnc_msg 
				end 	

			
				if fnc_rsl~=true then 
					if IsValid(caller)  then 
						Mercury.Util.SendMessage(caller,{Mercury.Config.Colors.Error,unpack(fnc_msg)})

					else 
						print(unpack(err))
					end 

				end
				
				
				if k==#Targets then 
					return true,{"Command completed successfully."}
				end 

		
		end


		
			

	end // END OF TARGETED COMMANDS
	//////////////////////////////////////////////////////////////////////


	////////////////NON TARGETED COMMANDS//////////////////////
					
		



	local success,error,custom,ctable 
		local STS,EXEC_ERR = pcall(function()
			success,error,custom,ctable = CommandTable._CALLFUNC(caller,args)			
		end)

		if !STS then 

				MsgC(Mercury.Config.Colors.Default,tostring(caller) .. " tried to run " )
					MsgC(Mercury.Config.Colors.Arg,command)
					MsgC(Mercury.Config.Colors.Default," but ")
				
					MsgC(Color(255,0,0)," CONDUCTOR WE HAVE A PROBLEM. ")
					Msg(EXEC_ERR)


			return false,{"Command execution error ", EXEC_ERR}

		end
			
			if type(error) == "string" then // Legacy command support
				if error == "@SYNTAX_ERR" then
					error = {"Command syntax error. Syntax of this command is: ", command ," ",	CommandTable.Useage}
				else 
					error = {error}
				end
			end
					MsgC(Mercury.Config.Colors.Default,tostring(caller) .. " ran command " )
					MsgC(Mercury.Config.Colors.Arg,command)
					MsgC(Mercury.Config.Colors.Default, " {" .. tconcat(args,", ") .. "}")
					MsgN(" ")

			if success then 


				

				if custom then 
					if not silent then 
						if #ctable > 1 then 
							Mercury.Util.Broadcast({Mercury.Config.Colors.Server, unpack( ctable ) })
						end
					else 
						//Mercury.Util.SendMessage(caller, {Mercury.Config.Colors.Server, "(SILENT) ", unpack( ctable ) })
					end 

				else 
					if not silent then 
						Mercury.Util.Broadcast({Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default, " has " .. CommandTable.Verb .." ",v,Mercury.Config.Colors.Default, "."})				
					else 
						// Mercury.Util.SendMessage(caller, {Mercury.Config.Colors.Server,"(SILENT) ",caller,Mercury.Config.Colors.Default, " has " .. CommandTable.Verb .." ",v,Mercury.Config.Colors.Default, "."})
					end

				end
				return true,{"Command completed successfully. "} 

			else 
				return false,error
			end


	return false,{"Something pretty weird happened."}
end


concommand.Add("hg",function(P,C,A)
	local command = ""
	local argtab = {}
	command = A[1]
	if !command then  
		Mercury.Util.SendMessage(P,{Mercury.Config.Colors.Error,"No command specified."})
		return false 
	end
	if #A > 1 then 

		for I=1,#A - 1 do
			argtab[I] = A[1 + I]

		end

	end
	local result,err = Mercury.Commands.Call(P,command,argtab,false) 
	if result~=true and IsValid(P) then 
//		print(unpack(err)) 
		//PrintTable(err)
		Mercury.Util.SendMessage(P,{Mercury.Config.Colors.Error,unpack(err)})
	end
	if !IsValid(P) and result~=true then 
		print(err)
	end
end)


concommand.Add("hgs",function(P,C,A)
	local command = ""
	local argtab = {}
	command = A[1]
	if !command then 
		Mercury.Util.SendMessage(P,{Mercury.Config.Colors.Error,"No command specified."})
		return false 
	end
	if #A > 1 then 
		for I=1,#A - 1 do
			argtab[I] = A[1 + I]
		end
	end
	local result,err = Mercury.Commands.Call(P,command,argtab,true) 
	if result~=true and IsValid(P) then 
		Mercury.Util.SendMessage(P,{Mercury.Config.Colors.Error,unpack(err)})
	end
	if !IsValid(P) and result~=true then 
		print(err)
	end 
end)
net.Receive("Mercury:Commands",function(len,P)
	if len and len > 0xFFF then // Thanks !cake
			P:SendLua('Mercury.Menu.ShowErrorCritical([[Net buffer is too large. \n]] .. [[ ' .. debug.traceback()  .. '"]] )')
		return "OH SHIT, INCOMING"
	end

	local command = ""
	local argtab = {}
	pcall(function()
		command = net.ReadString()
		argtab = net.ReadTable()
	end)
	if !command then 
		Mercury.Util.SendMessage(P,{Mercury.Config.Colors.Error,"No command specified."})
		return false 
	end
	local result,err = Mercury.Commands.Call(P,command,argtab,false) 
	if result~=true and IsValid(P) then 
		Mercury.Util.SendMessage(P,{Mercury.Config.Colors.Error,unpack(err)})
	end
	if !IsValid(P) and result~=true then 
		print(err)
	end
end)
  

function Mercury.Commands.ChatHook(Plr,Text,TeamOnly)
	local argms = {}
	local firstsym = Text[1]
	if Text[1]=="!" or Text[1]=="/" or Text[1]=="@" then  -- This is shitty.
		Text = string.sub(Text,2,#Text)
		argms = Mercury.Util.StringArguments(Text)
		local command = string.lower(argms[1])
		table.remove(argms,1) // remove command.
		if command then 
			for k,v in pairs(Mercury.Commands.CommandTable) do
	
				if k==command then 
					if firstsym == "!" then
				
						result,err = Mercury.Commands.Call(Plr,command,argms,false) 
						if result~=true then 
							Mercury.Util.SendMessage(Plr,{Mercury.Config.Colors.Error,unpack(err)})
						end
					end
					if firstsym == "/" then 
						result,err = Mercury.Commands.Call(Plr,command,argms,false) 
						if result~=true then 
							Mercury.Util.SendMessage(Plr,{Mercury.Config.Colors.Error,unpack(err)})
						end
						return ""
					end
					if firstsym == "@" then
						result,err = Mercury.Commands.Call(Plr,command,argms,true) 
						if result~=true then 
							Mercury.Util.SendMessage(Plr,{Mercury.Config.Colors.Error,unpack(err)})
						end
						return ""
					end
				end
			end 
		end
	end
end
hook.Add("PlayerSay","Mercury:ChatCommands",Mercury.Commands.ChatHook)


for k,v in pairs(file.Find("mercury/commands/*.lua","LUA")) do
	AddCSLuaFile("mercury/commands/" .. v)  // FREEZEBUG FREEZEBUG DONT SENT MAI LUA 2 CLINT PLS!
	include("mercury/commands/" .. v)
end

if Mercury.Booted==true then // This will call the modhook library's hooks again. This is for lua refresh. If Mercury is fully loaded. Then it will not call the init script again. When the commands file is refreshed, the privilege registers are terminated. This will call them again.
		Mercury.ModHook.Call("AddPrivileges")
		Mercury.ModHook.Call("PrivilegesReady")
end
 