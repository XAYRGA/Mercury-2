  local MenuTab = {}
  MenuTab.index = 2 //Internal identifier for table
  MenuTab.Name = "Ranks" // Display name 
  MenuTab.Desc = "Ranks" // Description 
  MenuTab.Icon = "icon16/user.png" // Icon


function MenuTab:ShouldGenerateTab()

	return LocalPlayer():HasPrivilege("viewranks")


end




local function ApplyTeamData(frame,rtab,line,rindex,ranklist)
		rtab = Mercury.Ranks.RankTable[rindex]
		local RankLabel = vgui.Create( "DLabel", frame )
		RankLabel:SetPos( 10, 0 )
		RankLabel:SetText( "Index" )
		RankLabel:SetTextColor(Color(1,1,1,255))


		local IndexBox = vgui.Create( "DTextEntry", frame )
		IndexBox:SetPos( 55, 0 )
		IndexBox:SetSize( 80, 16 )
		IndexBox:SetText( rindex )

		function IndexBox:OnEnter(self)

			net.Start("Mercury:Commands")
				net.WriteString("ranksetindex")
				net.WriteTable({rindex,IndexBox:GetValue()})
				rindex = string.lower(IndexBox:GetValue())
				line.__RANKINDEX = string.lower(IndexBox:GetValue())
			
				line.RNAME = string.lower(IndexBox:GetValue())
				line:SetValue(1,string.lower(IndexBox:GetValue()))

				line:SetColumnText(1,rindex)
				line:InvalidateLayout()
				
			net.SendToServer()
		end


		local TitleLabel = vgui.Create( "DLabel", frame )
		TitleLabel:SetPos( 10, 16 )
		TitleLabel:SetText( "Title" )
		TitleLabel:SetTextColor(Color(1,1,1,255))


		local TitleBox = vgui.Create( "DTextEntry", frame )
		TitleBox:SetPos( 55, 18 )
		TitleBox:SetSize( 80, 16)
		TitleBox:SetText( rtab.title )

		function TitleBox:OnEnter(self)

			net.Start("Mercury:Commands")
				net.WriteString("ranksettitle")
				net.WriteTable({rindex,TitleBox:GetValue()})
			net.SendToServer()
		end

		local OrderLab = vgui.Create( "DLabel", frame )
		OrderLab:SetPos( 10, 34 )
		OrderLab:SetText( "Order" )
		OrderLab:SetTextColor(Color(1,1,1,255))

		local OrderBox = vgui.Create( "DTextEntry", frame )
		OrderBox:SetPos( 55, 36 )
		OrderBox:SetSize( 80, 16 )
		OrderBox:SetText( rtab.order )

		function OrderBox:OnEnter(self)
			net.Start("Mercury:Commands")
				net.WriteString("ranksetorder")
				net.WriteTable({rindex,OrderBox:GetValue()})
			net.SendToServer()
		end


		local ImmuLab = vgui.Create( "DLabel", frame )
		ImmuLab:SetPos( 10, 52 )
		ImmuLab:SetText( "Immunity" )
		ImmuLab:SetTextColor(Color(1,1,1,255))

		local ImmuBox = vgui.Create( "DTextEntry", frame )
		ImmuBox:SetPos( 55, 52 )
		ImmuBox:SetSize( 80, 16 )
		ImmuBox:SetText( rtab.immunity )

		function ImmuBox:OnEnter(self)
			net.Start("Mercury:Commands")
				net.WriteString("ranksetimmunity")
				net.WriteTable({rindex,ImmuBox:GetValue()})
			net.SendToServer()
		end



		local AdminCheckBox = vgui.Create("DCheckBox",frame)
		AdminCheckBox:SetPos(180,10)		
		local AdminLabel = vgui.Create( "DLabel", frame )
		AdminLabel:SetPos( 200, 10 )
		AdminLabel:SetText( "Is Admin" )
		AdminLabel:SetTextColor(Color(1,1,1,255))
		AdminCheckBox:SetChecked(rtab.admin)


		local SuperAdminCheckBox = vgui.Create("DCheckBox",frame)
		SuperAdminCheckBox:SetPos(180,30)		
		local SuperAdminLabel = vgui.Create( "DLabel", frame )
		SuperAdminLabel:SetPos( 200, 30 )
		SuperAdminLabel:SetText( "Is SuperAdmin" )
		SuperAdminLabel:SetTextColor(Color(1,1,1,255))
		SuperAdminLabel:SizeToContents()
		SuperAdminCheckBox:SetChecked(rtab.superadmin)

		function SuperAdminCheckBox:OnChange(val)
			net.Start("Mercury:Commands")
				net.WriteString("ranksetadmin")
				net.WriteTable({rindex,"superadmin",tostring(val)})
			net.SendToServer()

		end

		function AdminCheckBox:OnChange(val)
			net.Start("Mercury:Commands")
				net.WriteString("ranksetadmin")
				net.WriteTable({rindex,"admin",tostring(val)})
			net.SendToServer()

		end


		local ranksettargetself = vgui.Create("DCheckBox",frame)
		ranksettargetself:SetPos(180,50)		
		local ranksettargetselfLabel = vgui.Create( "DLabel", frame )
		ranksettargetselfLabel:SetPos( 200, 50 )
		ranksettargetselfLabel:SetText( "Only target self?" )
		ranksettargetselfLabel:SetTextColor(Color(1,1,1,255))
		ranksettargetselfLabel:SizeToContents()
		ranksettargetself:SetChecked(rtab.only_target_self)

		function ranksettargetself:OnChange(val)
			net.Start("Mercury:Commands")
				net.WriteString("ranksettargetself")
				net.WriteTable({rindex,tostring(val)})
			net.SendToServer()

		end

			local selected_index 
			local one_line_selected = false

			local nocommands = vgui.Create( "DListView", frame)
			nocommands:AddColumn( "Availible Commands" )
			nocommands:SetSize( 150, 150 )	
			nocommands:SetPos( 10 , 70 )
				

			local currentcommands = vgui.Create( "DListView", frame)
			currentcommands:AddColumn( "Current Commands" )
			currentcommands:SetSize( 150, 150 )	
			currentcommands:SetPos( 225, 70 )


			local allcmds = Mercury.Commands.GetPrivileges()
			local allcmds2 = Mercury.Commands.GetPrivileges()
	
			for k,v in SortedPairs(rtab.privileges) do
				if #v > 1 then
					local add = false 
					for i,pri in SortedPairs(allcmds2) do 
						if pri==v then add = true end // get rid of garbage commands	
					end	
					if add then 
						local gx = currentcommands:AddLine(v)
						gx.privilege = v
					end
				end
				for i,comm in SortedPairs(allcmds) do
					if comm==v then 
						table.remove(allcmds,i)
					end
				end
			end
			for k,v in SortedPairs(allcmds) do
				local gx = nocommands:AddLine(v)
				gx.privilege = v
				
			end


			

			local AddCommandButton = vgui.Create( "DButton" , frame)
			AddCommandButton:SetPos( 172 ,  121 )
			AddCommandButton:SetText( "-->" )
			AddCommandButton:SetSize( 40, 20 )
			AddCommandButton:SetDisabled(true)
			AddCommandButton.DoClick = function(self)
				if self:GetDisabled()==true then return false end
				if not one_line_selected then surface.PlaySound("buttons/button2.wav") return false else surface.PlaySound("mercury/mercury_ster_switch.ogg")  end
				local cmdcount = 0
				for k,v in pairs(nocommands.Lines) do 
					if v:IsSelected() then 
						cmdcount = cmdcount + 1 
					end
				end

				Mercury.Menu.ShowProgress("Applying changes. . . ")
				local dar = coroutine.create(function(thread)
					
					local idx = 0
					for k,line in pairs(nocommands.Lines) do 
				
						if line:IsSelected()==true then
							idx = idx + 1
							local selected_index = line.privilege
							local xg = currentcommands:AddLine(selected_index)
							xg.privilege = selected_index
							local lid = nocommands:GetSelectedLine()
							nocommands:RemoveLine(lid)	
							net.Start("Mercury:Commands")
								net.WriteString("rankmodpriv")
								net.WriteTable({rindex,"add",tostring(selected_index)})
							net.SendToServer()
							timer.Simple(0.3,function()
								coroutine.resume(thread,thread)
							end)
							coroutine.yield()

							Mercury.Menu.UpdateProgress(idx,cmdcount)
						end
					end
						Mercury.Menu.CloseProgress()
				end)
				coroutine.resume(dar,dar)
				one_line_selected = false
				AddCommandButton:SetDisabled(true)
				
			end



			local RemCommandButton = vgui.Create( "DButton" , frame)
			RemCommandButton:SetPos( 172,  151 )
			RemCommandButton:SetText( "<--" )
			RemCommandButton:SetSize( 40, 20 )
			RemCommandButton:SetDisabled(true)
			RemCommandButton.DoClick = function(self)
				if self:GetDisabled()==true then return false end
				if not one_line_selected then surface.PlaySound("buttons/button2.wav") return false else surface.PlaySound("mercury/mercury_ster_switch.ogg")  end
			

				local cmdcount = 0
				for k,v in pairs(currentcommands.Lines) do 
					if v:IsSelected() then 
						cmdcount = cmdcount + 1 
					end
				end
				local idx = 0
				Mercury.Menu.ShowProgress("Applying changes. . . ")
				local dar = coroutine.create(function(thread)
					
					PrintTable(currentcommands.Lines)
					for k,line in pairs(currentcommands.Lines) do 
				
						if line:IsSelected()==true then
							idx = idx + 1
							local selected_index = line.privilege
							local xg = nocommands:AddLine(selected_index)
							xg.privilege = selected_index
							local lid = currentcommands:GetSelectedLine()
							currentcommands:RemoveLine(lid)	
							net.Start("Mercury:Commands")
								net.WriteString("rankmodpriv")
								net.WriteTable({rindex,"remove",tostring(selected_index)})
							net.SendToServer()
							timer.Simple(0.5,function()
								coroutine.resume(thread,thread)
							end)
							coroutine.yield()
							Mercury.Menu.UpdateProgress(idx,cmdcount)
						end
					end
						Mercury.Menu.CloseProgress()
				end)
				coroutine.resume(dar,dar)



				one_line_selected = false 
				RemCommandButton:SetDisabled(true)

			end


			function nocommands:OnRowSelected(lineid,isselected)
				local line_obj = self:GetLine(lineid)
				surface.PlaySound("buttons/button6.wav")
				currentcommands:ClearSelection()
				RemCommandButton:SetDisabled(true)
				AddCommandButton:SetDisabled(false)
				one_line_selected = true
				return true
			end

			function currentcommands:OnRowSelected(lineid,isselected)
				local line_obj = self:GetLine(lineid)
				surface.PlaySound("buttons/button6.wav")
				nocommands:ClearSelection()
				RemCommandButton:SetDisabled(false)
				AddCommandButton:SetDisabled(true)
				one_line_selected = true
				return true
			end
 

			local gframe = vgui.Create( "ContextBase" , frame)
				gframe:SetSize( 165, 170 )
				gframe:SetPos(220,225)
				gframe:SetVisible( true )
				function gframe:GetWindow()
					return CONTAINER
				end
		

			local Mixer = vgui.Create( "DColorMixer", gframe )
			Mixer:Dock( FILL )			--Make Mixer fill place of Frame
			Mixer:SetPalette( true ) 		--Show/hide the palette			DEF:true
			Mixer:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
			Mixer:SetWangs( true )	 		--Show/hide the R G B A indicators 	DEF:true
			Mixer:SetColor( rtab.color )	--Set the default color

			local UpdateColorButton = vgui.Create( "DButton" , frame)
			UpdateColorButton:SetPos( 130,  225 )
			UpdateColorButton:SetText( "Update Color" )
			UpdateColorButton:SetSize( 80, 80 )
	
			UpdateColorButton.DoClick = function(self)
				local str = "" .. tostring(Mixer:GetColor().r ) ..",".. tostring(Mixer:GetColor().g ) .."," .. tostring(Mixer:GetColor().b )

				net.Start("Mercury:Commands")
					net.WriteString("ranksetcolor")
					net.WriteTable({rindex,str})
				net.SendToServer()

			end


			local DeleteRankButton = vgui.Create( "DButton" , frame)
			DeleteRankButton:SetPos( 10,  375 )
			DeleteRankButton:SetText( "Delete Rank" )
			DeleteRankButton:SetSize(75,20)
			DeleteRankButton.DoClick = function( self )
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
						DLabel:SetText( "Are you sure you want to delete this rank? (This cannot be undone) " )
						DLabel:SetColor(Color(255,255,255))
						DLabel:SizeToContents()
						local ConfirmDelRankButton = vgui.Create( "DButton" , rootwindow)
							ConfirmDelRankButton:SetPos( 90,  80 )
							ConfirmDelRankButton:SetText( "Yes, I'm sure." )
							ConfirmDelRankButton:SetSize(90,20)
							ConfirmDelRankButton.DoClick = function( self )
								surface.PlaySound("mercury/mercury_info.ogg")
									net.Start("Mercury:Commands")
										net.WriteString("rankdel")
										net.WriteTable({rindex})
									net.SendToServer()
									local lid = ranklist:GetSelectedLine()
									ranklist:RemoveLine(lid)	
									rootwindow:Close()
									frame:Remove()
							end
						local DenyRankDelete = vgui.Create( "DButton" , rootwindow)
							DenyRankDelete:SetPos( 250,  80 )
							DenyRankDelete:SetText( "On second thought, no." )
							DenyRankDelete:SetSize(175,20)
							
							
							DenyRankDelete.DoClick = function( self )
									rootwindow:Remove()
							end


			end
			

	/*surface.PlaySound("mercury/mercury_error.ogg")
	local rootwindow = vgui.Create( "DFrame" ) // Actual window frame
		rootwindow:SetSize( 480, 480 )
		rootwindow:Center()
 		rootwindow:SetTitle( "Mercury - Error" )
		rootwindow:SetVisible( true )
		rootwindow:MakePopup()


		local DLabel = vgui.Create( "DLabel", rootwindow )
		DLabel:SetPos( 60, 50 )
		DLabel:SetText( "There was an error generating a tab." )
		DLabel:SizeToContents()

	local tbox = vgui.Create("HTML", rootwindow) 
	 tbox:SetSize( 450 , 365)
	 tbox:SetPos(15,96)
	 tbox:SetHTML([[<pre>  <font color="white">]] .. err .. "<font></pre>")
	 function tbox:Paint(w,h)
	 	    draw.RoundedBox( 0, 0, 0, w, h, Color( 1,1,1,255 ) )

	 end*/





end











 function GenerateMenu(CONTAINER)

	local gframe = vgui.Create( "ContextBase" , CONTAINER ) 
	gframe:SetSize( 390, 400 )
	gframe:SetPos(225,10)
	gframe:SetVisible( true )
	function gframe:GetWindow()
		return CONTAINER
	end


	function gframe:Paint(w,h)
				    draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 255, 100, 5 ) )
	end
	CONTAINER.CurrentRankGFrame = gframe

	local ctrl = vgui.Create( "DListView", CONTAINER )
	ctrl:AddColumn( "Index" )
	ctrl:AddColumn( "Title" )
	ctrl:SetSize( 210, 355 )	
	ctrl:SetPos( 10, 10 )
	ctrl:SetMultiSelect(false)
	function ctrl:GetWindow()
		return CONTAINER
	end
	function ctrl:Regenerate()
		self:Clear()
			local sortab = {}
			for k,v in pairs(Mercury.Ranks.RankTable) do
				v._INDEX = k
				sortab[v.order] = v 
			end
			for k,v in SortedPairs(sortab) do
				k = v._INDEX
		 		local line = ctrl:AddLine(k,v.title)
		 		local menutab = table.Copy(v)
		 		menutab._RANKINDEX = k // so much hax.
		 		line.RankTable = menutab
		 		line._RANKINDEX = k
		 		line.RNAME = k
		 	end
 
	end
	function ctrl:OnClickLine(line,isselected)
		if self.LastSelectedRow and IsValid(self.LastSelectedRow) then self.LastSelectedRow:SetSelected(false) end
		if self:GetWindow().CurrentRankGFrame then self:GetWindow().CurrentRankGFrame:Remove() end
		
			local gframe = vgui.Create( "ContextBase" , CONTAINER )
			gframe:SetSize( 390, 400 )
			gframe:SetPos(225,10)
			gframe:SetVisible( true )
			function gframe:GetWindow()
				return CONTAINER
			end
			function gframe:Paint(w,h)
				    draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 255, 100, 5 ) )
			end
			self:GetWindow().CurrentRankGFrame = gframe
			if line.RankTable then 
					ApplyTeamData(gframe,line.RankTable,line,line.RNAME,ctrl)
			end
			line:SetSelected(true)
			self.LastSelectedRow = line
		
	end


		

			local NewRankButton = vgui.Create( "DButton" , CONTAINER)
			NewRankButton:SetPos( 10,  365 )
			NewRankButton:SetText( "New Rank" )
			NewRankButton:SetSize( 105, 40 )
			NewRankButton.DoClick = function(self)
				if self:GetDisabled()==true then return false end
				
				net.Start("Mercury:Commands")
					net.WriteString("rankadd")
					net.WriteTable({"new_rank","New Rank","100,100,100"})
				net.SendToServer()
				timer.Simple(1,function()
					ctrl:Regenerate()
				end)

			end

 
			local CopyRankButton = vgui.Create( "DButton" , CONTAINER)
			CopyRankButton:SetPos( 115,  365 )
			CopyRankButton:SetText( "Copy Rank" )
			CopyRankButton:SetSize( 105, 40 )
			CopyRankButton.DoClick = function(self)
					if !IsValid(ctrl["LastSelectedRow"]) then return false end
					if self:GetDisabled()==true then return false end
					if self.RW and IsValid(self.RW) then self.RW:Remove() end
					surface.PlaySound("mercury/mercury_error.ogg")
					local rootwindow = vgui.Create( "DFrame" ) // actual window frame
					self.RW = rootwindow
					rootwindow:SetSize( 480, 150 )
					rootwindow:Center()
			 		rootwindow:SetTitle( "Mercury - Copy Rank" )
					rootwindow:SetVisible( true )
					rootwindow:MakePopup()
			
						local DLabel = vgui.Create( "DLabel", rootwindow )
						DLabel:SetPos( 60, 50 )
						DLabel:SetText( "You are copying the rank " .. ctrl.LastSelectedRow.RNAME .. ". Specify an index for the new rank")
						DLabel:SetColor(Color(255,255,255))
						DLabel:SizeToContents()

							local OrderBox = vgui.Create( "DTextEntry", rootwindow )
							OrderBox:SetPos( 60, 75 )
							OrderBox:SetSize( 370, 16 )
				



						local ConfirmCopyButton = vgui.Create( "DButton" , rootwindow)
						ConfirmCopyButton:SetPos( 60,100)
						ConfirmCopyButton:SetText( "Confirm and Copy" )
						ConfirmCopyButton:SetSize( 370, 40 )
						ConfirmCopyButton.DoClick = function(x)
							if self:GetDisabled()==true then return false end
							
							net.Start("Mercury:Commands")
								net.WriteString("rankcopy")
								net.WriteTable({ctrl.LastSelectedRow.RNAME,tostring(OrderBox:GetValue())})
							net.SendToServer()
							timer.Simple(1,function()
								ctrl:Regenerate()
							end)
								surface.PlaySound("mercury/mercury_info.ogg")
								self.RW:Remove()
						end





		
			//	surface.PlaySound("mercury/mercury_ok.ogg")
				//net.Start("Mercury:Commands")
					//net.WriteString("rankadd")
					//net.WriteTable({"new_rank","New Rank","100,100,100"})
				//net.SendToServer()
		//		timer.Simple(1,function()
		///			ctrl:Regenerate()
			///	end)



			end


	ctrl:Regenerate()


end

Mercury.Menu.AddMenuTab(MenuTab.index,MenuTab.Icon,MenuTab.Name,MenuTab.Desc,GenerateMenu,MenuTab.ShouldGenerateTab) 

