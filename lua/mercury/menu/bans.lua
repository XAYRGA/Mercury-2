  local MenuTab = {}
  MenuTab.index = 3 //Internal identifier for table
  MenuTab.Name = "Bans" // Display name 
  MenuTab.Desc = "Server Bans" // Description 
  MenuTab.Icon = "icon16/vcard_delete.png" // Icon
local bandata = {}
local totalchunks = 0
local gotchunks = 0

function MenuTab:ShouldGenerateTab()

	return LocalPlayer():HasPrivilege("viewbans")


end


local function DoLayout(gframe,bantable)
			if !IsValid(gframe) then return false end
			local steamid = ""
			local selban = nil
			local ctrl = vgui.Create( "DListView", gframe)
			ctrl:AddColumn( "Name" )
			ctrl:AddColumn( "Steam ID" )
			ctrl:AddColumn( "Time left" )
			ctrl:AddColumn( "Banning Administrator" )
			ctrl:AddColumn( " Reason " )

			ctrl:SetSize( 450, 390 )	
			ctrl:SetPos( 10, 10 )
			ctrl:Dock(FILL)	



			local ReasonLabel = vgui.Create( "DLabel", gframe )
			ReasonLabel:SetText( "Reason" )
			ReasonLabel:SetTextColor(Color(1,1,1,255))
			ReasonLabel:Dock(TOP)


			local ReasonBox = vgui.Create( "DTextEntry", gframe)
			ReasonBox:Dock(TOP)
			ReasonBox:SetText( "Select a ban" )


			local UnbanButton = vgui.Create( "DButton" , gframe)
				UnbanButton:Dock(TOP)
				UnbanButton:SetText("Unban User")

				



			local TimeLabel = vgui.Create( "DLabel", gframe )
					TimeLabel:SetText( "Time" )
					TimeLabel:Dock(TOP)
					TimeLabel:SetTextColor(Color(1,1,1,255))
			

			local TimeBox = vgui.Create( "DTextEntry", gframe)
				TimeBox:SetText( "Select a ban" )
				TimeBox:Dock(TOP)


			local UpdateButton = vgui.Create( "DButton" , gframe)
			
			UpdateButton:SetText( "Update Ban" )
			UpdateButton:SetDisabled(true)
			UpdateButton:Dock(TOP)
		

			
				UpdateButton.DoClick = function( self )
				
					if !selban then return false end
							net.Start("Mercury:Commands")
										net.WriteString("banid")
										net.WriteTable({steamid,TimeBox:GetValue(),ReasonBox:GetValue()})

							net.SendToServer()
							surface.PlaySound("mercury/mercury_ok.ogg")


				end



			function ctrl:OnRowSelected(lineid,isselected)
				local line_obj = self:GetLine(lineid)
				surface.PlaySound("buttons/button6.wav")
				UnbanButton:SetDisabled(false)
				UpdateButton:SetDisabled(false)
				steamid = line_obj.ban.STEAMID
				selban = line_obj.ban
				ReasonBox:SetValue(selban.reason)
				if selban["TimeRemaining"] == "Eternity" then 
					TimeBox:SetValue("0")
				else
					TimeBox:SetValue(selban.TimeRemaining)
				end
				return true
			end
			for k, ply in pairs( bandata ) do

				local item = ctrl:AddLine( ply.Name or "Unknown",ply.STEAMID,tostring(ply["TimeRemaining"]),ply["bannedby"],ply["reason"] )
				item.ban = ply
			end	



	
			UnbanButton.DoClick = function( self )
					if self.RW and IsValid(self.RW) then self.RW:Remove() end
					surface.PlaySound("mercury/mercury_error.ogg")
					local rootwindow = vgui.Create( "DFrame" ) // actual window frame
					self.RW = rootwindow
					rootwindow:SetSize( 480, 150 )
					rootwindow:Center()
			 		rootwindow:SetTitle( "Mercury - Warning" )
					rootwindow:SetVisible( true )
					rootwindow:MakePopup()
			
						local DLabel = vgui.Create( "DLabel", rootwindow )
						DLabel:SetPos( 60, 50 )
						DLabel:SetText( "Really unban " .. steamid .. "?" )
						DLabel:SetColor(Color(255,255,255))
						DLabel:SizeToContents()
						local ConfirmUnban = vgui.Create( "DButton" , rootwindow)
							ConfirmUnban:SetPos( 90,  80 )
							ConfirmUnban:SetText( "Yes, unban them." )
							ConfirmUnban:SetSize(90,20)
							ConfirmUnban.DoClick = function( self )
								surface.PlaySound("mercury/mercury_info.ogg")
									net.Start("Mercury:Commands")
										net.WriteString("unban")
										net.WriteTable({steamid})
									net.SendToServer()
									local lid = ctrl:GetSelectedLine()
									ctrl:RemoveLine(lid)	
									UnbanButton:SetDisabled(true)
									UpdateButton:SetDisabled(true)
									rootwindow:Close()
									selban = nil
									
							end
						local DenyUnban = vgui.Create( "DButton" , rootwindow)
							DenyUnban:SetPos( 250,  80 )
							DenyUnban:SetText( "No, don't unban them." )
							DenyUnban:SetSize(175,20)
							
							
							DenyUnban.DoClick = function( self )
									rootwindow:Remove()
							end


			end
	




end



 function GenerateMenu(CONTAINER)
 
 	local banwindow = CONTAINER
 	local obanpaint = banwindow.Paint
 	bandata = {}
 	net.Start("Mercury:BanData")
 		net.WriteString("GET_DATA")
 	net.SendToServer()

 	
 	  local bstr = [[Mercury Ban System
     
Just a sec, waiting on the server. ]]



 	  function banwindow:Paint(w,h)
   		  draw.RoundedBox( 0, 0, 0, w, h, Color( 1,1, 1, 255 ) )
          draw.DrawText(bstr, "Default", 0, 0, Color(255,255,255) , TEXT_ALLIGN_LEFT )

		  if math.sin(CurTime() * 20) > 0 then 
			        if bstr[#bstr]!="_" then 
			            bstr = bstr .. "_"
			        end
			        else
			        if bstr[#bstr]=="_" then
			            bstr = string.sub(bstr,0,#bstr-1)
			        end
			    end 
			    
		  end

 	
 	 
	timer.Simple(2,function()
		DoLayout(CONTAINER)
		if IsValid(banwindow) then 
			banwindow.Paint = obanpaint
		end
	end)


end

Mercury.Menu.AddMenuTab(MenuTab.index,MenuTab.Icon,MenuTab.Name,MenuTab.Desc,GenerateMenu,MenuTab.ShouldGenerateTab) 









net.Receive("Mercury:BanData",function()
	local comm,args 
	pcall(function()
		args = net.ReadTable()
	end)
	local dat = args["data"]
	totalchunks = args["tchunks"]
	gotchunks = args["chunkno"]

	for k,v in pairs(dat) do
		bandata[#bandata + 1] = v

	end

end)