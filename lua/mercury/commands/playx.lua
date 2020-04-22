timer.Simple(0,function()
	if PlayX then 
		Mercury.Commands.AddPrivilege("playx")
		function PlayX.IsPermitted(ply) 
			MsgC(Mercury.Config.Colors.Default,"[MERCURY]") 
			MsgN(" " , tostring(ply), " tried to use permission 'playx'.")
			return ply:HasPrivilege("playx")

		end
	end
end)

