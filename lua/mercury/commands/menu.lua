local MCMD = Mercury.Commands.CreateTable("menu", "", false, "", false, false, false, nil)
function callfunc(caller,args)
	caller:SendLua("Mercury.Menu.Open()")
	return true, "heh", true, {}
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)