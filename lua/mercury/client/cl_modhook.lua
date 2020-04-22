

Mercury.ModHook = {}
local hooktab = {}


function Mercury.ModHook.Add(hk,uname,func)
	if !hk then return false,"NO EVENT NAME" end
	if !uname then return false,"NO UNIQUE NAME" end
	if !func then return false, "NO CALLBACK FUNC!" end
	if !hooktab[hk] then hooktab[hk] = {} end
	hooktab[hk][uname] = func
end

function Mercury.ModHook.Call(hk)
	if !hk then return false,"NO EVENT NAME" end
	local mk = hooktab[hk]
	if mk then 
		print("MERCURY: DispatchEvent " .. hk)
		for k,v in pairs(mk) do 
			pcall(v) // do the call

		end
	end
end

function Mercury.ModHook.Remove(hk,uname)
	if !hk then return false,"NO EVENT NAME" end
	if !uname then return false,"NO UNIQUE NAME" end
	
	if !hooktab[hk] then hooktab[hk] = {} end
	hooktab[hk][uname] = nil // Bad practice to rely on GC, but oh well.
end









hook.Remove("HUDPaint","Render_Upset")