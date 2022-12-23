Mercury.Bans = {}

function Mercury.Bans.FortiBanSendFile(dfile)
    local fbfile = file.Read(dfile,"DATA")
    if (fbfile!=nil) then 
        net.Start("Mercury:BanData") 
            net.WriteString("FORTIBAN_CHECK")
            net.WriteString(fbfile) 
        net.SendToServer()
    end
end 


function Mercury.Bans.Handle()
    local command = net.ReadString()
    if command=="BANDATA_PACKET" then 
        local comm,args 
        pcall(function()
            args = net.ReadTable()
        end)
        Mercury.ModHook.Call("ReceiveBanDataPacket",args)
    end 
    if command=="FORTIBAN_INFO" then 
        Mercury.Bans.FortiBanFile(net.ReadString())
    end 
end

net.Receive("Mercury:BanData",Mercury.Bans.Handle)