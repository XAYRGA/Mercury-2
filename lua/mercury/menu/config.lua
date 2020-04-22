  local MenuTab = {}
  MenuTab.index = 5 //Internal identifier for table
  MenuTab.Name = "Configuration" // Display name 
  MenuTab.Desc = "Settings and Configuration" // Description 
  MenuTab.Icon = "icon16/cog.png" // Icon
local ConfigGroups = {

}


function MenuTab:ShouldGenerateTab()

	return LocalPlayer():HasPrivilege("viewconfig")


end



function Mercury.Menu.AddConfigGroup(index,desc,func)
	ConfigGroups[index] = {desc = desc, func = func}
end


local function RankTeamMenu(frame)
	local UseTeamsCheckBox = vgui.Create("DCheckBox",frame)
		UseTeamsCheckBox:SetPos(0,10)		
		local UseTeamsLabel = vgui.Create( "DLabel", frame )
		UseTeamsLabel:SetPos( 20, 10 )
		UseTeamsLabel:SetText( "Use Teams (Disable for non-sandbox gamemodes) " )
		UseTeamsLabel:SetTextColor(Color(1,1,1,255))
		UseTeamsLabel:SizeToContents()
		UseTeamsCheckBox:SetChecked(Mercury.Config.UseTeams)

	function UseTeamsCheckBox:OnChange(val)
			net.Start("Mercury:Commands")
				net.WriteString("setuseteams")
				net.WriteTable({tostring(val)})
			net.SendToServer()


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
						DLabel:SetText( "Changing this setting requires a server restart to take effect. Restart now? " )
						DLabel:SetColor(Color(255,255,255))
						DLabel:SizeToContents()
						local ConfirmRestartButton = vgui.Create( "DButton" , rootwindow)
							ConfirmRestartButton:SetPos( 90,  80 )
							ConfirmRestartButton:SetText( "Yes, restart now" )
							ConfirmRestartButton:SetSize(90,20)
							ConfirmRestartButton.DoClick = function( self )
								surface.PlaySound("mercury/mercury_info.ogg")
								timer.Simple(0.5,function() 
									net.Start("Mercury:Commands")
										net.WriteString("changelevel")
										net.WriteTable({game.GetMap()})
									net.SendToServer()
									end)
				
									rootwindow:Close()
									frame:Remove()
							end
						local DenyRestart = vgui.Create( "DButton" , rootwindow)
							DenyRestart:SetPos( 250,  80 )
							DenyRestart:SetText( "No, do not restart yet." )
							DenyRestart:SetSize(175,20)
							
							DenyRestart.DoClick = function( self )
									rootwindow:Remove()
							end



	end


end

Mercury.Menu.AddConfigGroup("rankteams","Ranks and Teams",RankTeamMenu)



local function ColorControlMenu(frame)
			local gframe = vgui.Create( "ContextBase" , frame)
				gframe:SetSize( 95, 130 )
				gframe:SetPos(0,0)
				gframe:SetVisible( true )
				function gframe:GetWindow()
					return CONTAINER
				end
		

			local Mixer = vgui.Create( "DColorMixer", gframe )
				Mixer:Dock( FILL )			--Make Mixer fill place of Frame
				Mixer:SetPalette( false ) 		--Show/hide the palette			DEF:true
				Mixer:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
				Mixer:SetWangs( false )	 		--Show/hide the R G B A indicators 	DEF:true
				Mixer:SetColor( Mercury.Config.Colors.Default)	--Set the default color
				local UpdateColorButton = vgui.Create( "DButton" , gframe)
					UpdateColorButton:SetPos( 130,  225 )
					UpdateColorButton:SetText( "Update Color" )
					UpdateColorButton:Dock(BOTTOM)
					function UpdateColorButton:DoClick()
									surface.PlaySound("mercury/mercury_info.ogg")
									net.Start("Mercury:Commands")
										net.WriteString("setdefaultcolor")
										net.WriteTable({Mixer:GetColor()})
									net.SendToServer()

					end
			local DLabel = vgui.Create( "DLabel", gframe )
					DLabel:Dock(BOTTOM)
					DLabel:SetText( "Default Color" )
					DLabel:SetColor(Color(1,1,1))

			//////////////ERROR COLOR//////////////


		  	local gframe = vgui.Create( "ContextBase" , frame)
				gframe:SetSize( 95, 130 )
				gframe:SetPos(150,0)
				gframe:SetVisible( true )
				function gframe:GetWindow()
					return CONTAINER
				end
		

			local Mixer = vgui.Create( "DColorMixer", gframe )
				Mixer:Dock( FILL )			--Make Mixer fill place of Frame
				Mixer:SetPalette( false ) 		--Show/hide the palette			DEF:true
				Mixer:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
				Mixer:SetWangs( false )	 		--Show/hide the R G B A indicators 	DEF:true
				Mixer:SetColor( Mercury.Config.Colors.Error)	--Set the default color
				local UpdateColorButton = vgui.Create( "DButton" , gframe)
					UpdateColorButton:SetPos( 130,  225 )
					UpdateColorButton:SetText( "Update Color" )
					UpdateColorButton:Dock(BOTTOM)
					function UpdateColorButton:DoClick()
									surface.PlaySound("mercury/mercury_info.ogg")
									net.Start("Mercury:Commands")
										net.WriteString("seterrorcolor")
										net.WriteTable({Mixer:GetColor()})
									net.SendToServer()

					end
			local DLabel = vgui.Create( "DLabel", gframe )
					DLabel:Dock(BOTTOM)
					DLabel:SetText( "Error Color" )
					DLabel:SetColor(Color(1,1,1))

			//////////////ARGUMENT COLOR//////////////


		  	local gframe = vgui.Create( "ContextBase" , frame)
				gframe:SetSize( 95, 130 )
				gframe:SetPos(frame:GetWide() - 100,0)
				gframe:SetVisible( true )
				function gframe:GetWindow()
					return CONTAINER
				end
		

			local Mixer = vgui.Create( "DColorMixer", gframe )
				Mixer:Dock( FILL )			--Make Mixer fill place of Frame
				Mixer:SetPalette( false ) 		--Show/hide the palette			DEF:true
				Mixer:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
				Mixer:SetWangs( false )	 		--Show/hide the R G B A indicators 	DEF:true
				Mixer:SetColor( Mercury.Config.Colors.Arg)	--Set the default color
				local UpdateColorButton = vgui.Create( "DButton" , gframe)
					UpdateColorButton:SetPos( 130,  225 )
					UpdateColorButton:SetText( "Update Color" )
					UpdateColorButton:Dock(BOTTOM)
					function UpdateColorButton:DoClick()
									surface.PlaySound("mercury/mercury_info.ogg")
									net.Start("Mercury:Commands")
										net.WriteString("setargcolor")
										net.WriteTable({Mixer:GetColor()})
									net.SendToServer()

					end
			local DLabel = vgui.Create( "DLabel", gframe )
					DLabel:Dock(BOTTOM)
					DLabel:SetText( "Argument Color" )
					DLabel:SetColor(Color(1,1,1))




					/////////////////////////// BOTTOM //////////////////////////////////////////



					////////////// RANK COLOR /////////////

				local gframe = vgui.Create( "ContextBase" , frame)
				gframe:SetSize( 95, 130 )
				gframe:SetPos(0,frame:GetTall() - 135)
				gframe:SetVisible( true )
				function gframe:GetWindow()
					return CONTAINER
				end

			local Mixer = vgui.Create( "DColorMixer", gframe )
				Mixer:Dock( FILL )			--Make Mixer fill place of Frame
				Mixer:SetPalette( false ) 		--Show/hide the palette			DEF:true
				Mixer:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
				Mixer:SetWangs( false )	 		--Show/hide the R G B A indicators 	DEF:true
				Mixer:SetColor( Mercury.Config.Colors.Rank)	--Set the default color
				local UpdateColorButton = vgui.Create( "DButton" , gframe)
					UpdateColorButton:SetPos( 130,  225 )
					UpdateColorButton:SetText( "Update Color" )
					UpdateColorButton:Dock(BOTTOM)
					function UpdateColorButton:DoClick()
									surface.PlaySound("mercury/mercury_info.ogg")
									net.Start("Mercury:Commands")
										net.WriteString("setrankcolor")
										net.WriteTable({Mixer:GetColor()})
									net.SendToServer()

					end
			local DLabel = vgui.Create( "DLabel", gframe )
					DLabel:Dock(BOTTOM)
					DLabel:SetText( "Rank Color" )
					DLabel:SetColor(Color(1,1,1))

			//////////////ERROR COLOR//////////////


		  	local gframe = vgui.Create( "ContextBase" , frame)
				gframe:SetSize( 95, 130 )
				gframe:SetPos(150,frame:GetTall() - 135)
				gframe:SetVisible( true )
				function gframe:GetWindow()
					return CONTAINER
				end
		

			local Mixer = vgui.Create( "DColorMixer", gframe )
				Mixer:Dock( FILL )			--Make Mixer fill place of Frame
				Mixer:SetPalette( false ) 		--Show/hide the palette			DEF:true
				Mixer:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
				Mixer:SetWangs( false )	 		--Show/hide the R G B A indicators 	DEF:true
				Mixer:SetColor( Mercury.Config.Colors.Setting)	--Set the default color
				local UpdateColorButton = vgui.Create( "DButton" , gframe)
					UpdateColorButton:SetPos( 130,  225 )
					UpdateColorButton:SetText( "Update Color" )
					UpdateColorButton:Dock(BOTTOM)
					function UpdateColorButton:DoClick()
									surface.PlaySound("mercury/mercury_info.ogg")
									net.Start("Mercury:Commands")
										net.WriteString("setsettingcolor")
										net.WriteTable({Mixer:GetColor()})
									net.SendToServer()

					end
			local DLabel = vgui.Create( "DLabel", gframe )
					DLabel:Dock(BOTTOM)
					DLabel:SetText( "Setting Color" )
					DLabel:SetColor(Color(1,1,1))

			//////////////ARGUMENT COLOR//////////////


		  	local gframe = vgui.Create( "ContextBase" , frame)
				gframe:SetSize( 95, 130 )
				gframe:SetPos(frame:GetWide() - 100,frame:GetTall() - 135)
				gframe:SetVisible( true )
				function gframe:GetWindow()
					return CONTAINER
				end
		

			local Mixer = vgui.Create( "DColorMixer", gframe )
				Mixer:Dock( FILL )			--Make Mixer fill place of Frame
				Mixer:SetPalette( false ) 		--Show/hide the palette			DEF:true
				Mixer:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
				Mixer:SetWangs( false )	 		--Show/hide the R G B A indicators 	DEF:true
				Mixer:SetColor( Mercury.Config.Colors.Server)	--Set the default color
				local UpdateColorButton = vgui.Create( "DButton" , gframe)
					UpdateColorButton:SetPos( 130,  225 )
					UpdateColorButton:SetText( "Update Color" )
					UpdateColorButton:Dock(BOTTOM)
					function UpdateColorButton:DoClick()
									surface.PlaySound("mercury/mercury_info.ogg")
									net.Start("Mercury:Commands")
										net.WriteString("setservercolor")
										net.WriteTable({Mixer:GetColor()})
									net.SendToServer()

					end
			local DLabel = vgui.Create( "DLabel", gframe )
					DLabel:Dock(BOTTOM)
					DLabel:SetText( "Server Color" )
					DLabel:SetColor(Color(1,1,1))













	

end

Mercury.Menu.AddConfigGroup("colors","System Chat Colors",ColorControlMenu)



local function MOTDMenu(frame)
	local UseTeamsCheckBox = vgui.Create("DCheckBox",frame)
		UseTeamsCheckBox:SetPos(0,10)		
		local UseTeamsLabel = vgui.Create( "DLabel", frame )
		UseTeamsLabel:SetPos( 20, 10 )
		UseTeamsLabel:SetText( "Show the MOTD at spawn?" )
		UseTeamsLabel:SetTextColor(Color(1,1,1,255))
		UseTeamsLabel:SizeToContents()
		UseTeamsCheckBox:SetChecked(Mercury.Config.UseMOTD)

	function UseTeamsCheckBox:OnChange(val)
			net.Start("Mercury:Commands")
				net.WriteString("setusemotd")
				net.WriteTable({tostring(val)})
			net.SendToServer()

	end


	local OrderBox = vgui.Create( "DTextEntry", frame )
	OrderBox:SetPos( 0, 36 )
	OrderBox:SetSize( 375, 16 )
	OrderBox:SetText( Mercury.Config.MotdURL )

	function OrderBox:OnEnter(self)
		net.Start("Mercury:Commands")
			net.WriteString("setmotdurl")
			net.WriteTable({OrderBox:GetValue()})
		net.SendToServer()
	end



end

Mercury.Menu.AddConfigGroup("motd","MOTD Configuration",MOTDMenu)






Mercury.ModHook.Call("AddConfigGroups")





function GenerateMenu(CONTAINER)





 	local gframe = vgui.Create( "ContextBase" , CONTAINER ) 
	gframe:SetSize( 390, 400 )
	gframe:SetPos(225,10)
	gframe:SetVisible( true )
	function gframe:GetWindow()
		return CONTAINER
	end	



	CONTAINER.CurrentConfigGFrame  = gframe

	local ctrl = vgui.Create( "DListView", CONTAINER )
	ctrl:AddColumn( "Groups" )
	ctrl:SetSize( 210, 390 )	
	ctrl:SetPos( 10, 10 )
	ctrl:SetMultiSelect(false)
	function ctrl:GetWindow()
		return CONTAINER
	end
	function ctrl:Regenerate()
		self:Clear()
			local sortab = {}
			for k,v in SortedPairs(ConfigGroups) do
			local line = ctrl:AddLine(v.desc)	// so much hax.
		 		line.GenFunc = v.func
			end

 
	end
	function ctrl:OnRowSelected(lineid,isselected)
			if IsValid(self.GetWindow().CurrentConfigGFrame) then 
				self.GetWindow().CurrentConfigGFrame:Remove()
			end
			local line = self:GetLine(lineid)
			local gframe = vgui.Create( "ContextBase" , CONTAINER )
			gframe:SetSize( 390, 400 )
			gframe:SetPos(225,10)
			gframe:SetVisible( true )
			function gframe:GetWindow()
				return CONTAINER
			end
		
			self:GetWindow().CurrentConfigGFrame = gframe
			line.GenFunc(gframe)
			line:SetSelected(true)
			self.LastSelectedRow = line
		
	end
	ctrl:Regenerate()












 
 end


Mercury.Menu.AddMenuTab(MenuTab.index,MenuTab.Icon,MenuTab.Name,MenuTab.Desc,GenerateMenu,MenuTab.ShouldGenerateTab) 





