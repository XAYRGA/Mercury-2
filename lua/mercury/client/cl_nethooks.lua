
net.Receive("Mercury:ChatPrint",function()

	chat.AddText(unpack(net.ReadTable()))

end)