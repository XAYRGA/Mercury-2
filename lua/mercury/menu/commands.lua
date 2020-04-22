  local MenuTab = {}
  MenuTab.index = 1
  MenuTab.Name = "Commands"
  MenuTab.Desc = "Avalible commands"
  MenuTab.Icon = "icon16/table.png"
function GenerateMenu(CONTAINER)
	-- Create the frame we will be drawing things too
 	local comwindow = CONTAINER
	local gframe = vgui.Create("ContextBase" , comwindow) 
	comwindow.CurrentGFrame = gframe
	gframe:SetSize(390, 400)
	gframe:SetPos(225,10)
	gframe:SetVisible(true)
	function gframe:GetWindow()
		return comwindow
	end

	-- Draw a little logo thingy
	local MercuryLogo = vgui.Create("DImage", gframe)	
	MercuryLogo:SetPos(10, 120)
	MercuryLogo:SetSize(360, 100)
	MercuryLogo:SetImage("mercury/mercury.png")

	---------------------------------------------------
	---------------------------------------------------
	--//                                           //--
	--// You touch my _'s, I break your knee caps. //--
	--//                                           //--
	---------------------------------------------------
	---------------------------------------------------

	-- Need all the category names, and create the categories
	local Category = {}
	local CategoryList = {}
	local CommandButton = {}
	local CategoryNames = {}
	for _, v in pairs(Mercury.Commands.CommandTable) do
		if not v.Category then v.Category = "Uncategorized" end
		if v.HasMenu == true then
			if not CategoryNames[v.Category] then CategoryNames[v.Category] = {} end 
			CategoryNames[v.Category][#CategoryNames[v.Category] + 1] = _
		end
	end

	-- Little cleanup script
	for _, v in pairs(CategoryNames) do if #CategoryNames[_] <= 0 then v = nil end end

	-- Need an external list to add all the categories too
	local CommandLists = vgui.Create("DPanelList", comwindow)
	CommandLists:SetSize(210, 410)
	CommandLists:SetSpacing(2)
	CommandLists:EnableVerticalScrollbar(true) 

	-- Table is constructed, now lets add to them
	for _, v in SortedPairs(CategoryNames, false) do
		CategoryList[_] = vgui.Create("DPanelList", comwindow)
		CategoryList[_]:SetSpacing(2)
		CategoryList[_]:SetAutoSize(true)
		CategoryList[_]:EnableVerticalScrollbar(true)

		Category[_] = vgui.Create("DCollapsibleCategory", comwindow)
		Category[_]:SetPos(10, 10)
		Category[_]:SetSize(210, 200)
		Category[_]:SetLabel(_ or "_undefined_")
		Category[_].Paint = function(self, w, h)
			draw.RoundedBox(5, 0, 0, w, h, Color(108, 111, 114, 255))
		end

		Category[_]:SetContents(CategoryList[_])
		CommandLists:AddItem(Category[_])

		-- Loop through all the command and add them to their respective category
		for __, command in SortedPairs(Mercury.Commands.CommandTable, false) do
			if _ == command.Category and command.HasMenu == true and CategoryNames[command.Category] and LocalPlayer():HasPrivilege(__) then
				CommandButton[__] = vgui.Create("DButton", comwindow)
				CommandButton[__]:SetSize(210, 20)
				CommandButton[__]:SetPos(15, 0)
				CommandButton[__]:SetText(command.Command or "_undefined_")
				CommandButton[__]:SetColor(Color(234, 234, 234, 255))
				CommandButton[__]:SetFont("Trebuchet18")
				CommandButton[__].GetWindow = function()
					return comwindow
				end
				CommandButton[__].Paint = function(self, w, h)
					draw.RoundedBox(0, 4, 1, w - 8, h - 2, Color(157, 161, 165, 255))
				end
				CommandButton[__].DoClick = function(self)
					if self:GetWindow().CurrentGFrame then self:GetWindow().CurrentGFrame:Remove() end
							
					local gframe = vgui.Create("ContextBase" , comwindow)
					gframe:SetSize(390, 400)
					self:GetWindow().CurrentGFrame = gframe
					gframe:SetPos(225,10)
					gframe:SetVisible(true)
					function gframe:GetWindow()
						return comwindow
					end

					if LocalPlayer():HasPrivilege(__) then
						if command.GenerateMenu then
							command.GenerateMenu(gframe)
						end
					end
				end

				if not LocalPlayer():HasPrivilege(__) then
					CommandButton[__]:SetDisabled(true)
				end

				CategoryList[_]:AddItem(CommandButton[__])
			end
		end
	end
end
Mercury.Menu.AddMenuTab(MenuTab.index, MenuTab.Icon, MenuTab.Name, MenuTab.Desc, GenerateMenu) 












