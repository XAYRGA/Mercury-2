

Mercury.ModHook = {}
Mercury.ModHook.ShowErrors = true 
local hooktab = {}


function Mercury.ModHook.Add(hk,uname,func)
	if !hk then return false,"NO EVENT NAME" end
	if !uname then return false,"NO UNIQUE NAME" end
	if !func then return false, "NO CALLBACK FUNC!" end
	if !hooktab[hk] then hooktab[hk] = {} end
	hooktab[hk][uname] = func
end

function Mercury.ModHook.Call(hk,...)
	if !hk then return false,"NO EVENT NAME" end
	local mk = hooktab[hk]
	if mk then 
		print("MERCURY: DispatchEvent " .. hk)
		for k,v in pairs(mk) do 
		local s,e = pcall(v,...) // do the call
			if not s and Mercury.ModHook.ShowErrors then 

				MsgC(Mercury.Config.Colors.Setting,"[HG] ")
				MsgC(Mercury.Config.Colors.Error,"ModHook Error [")
				MsgC(Mercury.Config.Colors.Arg,hk)
				MsgC(Mercury.Config.Colors.Error,"] failed " .. e)
				MsgC(Mercury.Config.Colors.Setting,"\n")

			end
		end 
	end
end

function Mercury.ModHook.Remove(hk,uname)
	if !hk then return false,"NO EVENT NAME" end
	if !uname then return false,"NO UNIQUE NAME" end
	
	if !hooktab[hk] then hooktab[hk] = {} end
	hooktab[hk][uname] = nil // Bad practice to rely on GC, but oh well.
end 