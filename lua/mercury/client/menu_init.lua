local MenuTabs = {}
Mercury.Menu = {}


for k,v in pairs(file.Find("mercury/menu/rsc/*.lua","LUA")) do
	include("mercury/menu/rsc/" ..v )
	print("Mercury-Menu: initialized menu resource " .. v)
end


for k,v in pairs(file.Find("mercury/menu/elements/*.lua","LUA")) do
	include("mercury/menu/elements/" ..v )
	print("Mercury-Menu: initialized menu element " .. v)
end




	function Mercury.Menu.AddMenuTab(index,icon,name,desc,func,chfnk) 
		MenuTabs[index] = { name = name,icon = icon, desc = desc, genfunc = func,checkfunc = chfnk}
	end


surface.CreateFont( "Mercurycrash", {
	font = "Tehoma", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 30,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


surface.CreateFont( "Mercurycrashs", {
	font = "Tehoma", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 16,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local o_vgui_create = vgui.Create



function Mercury.Menu.Open()
	function vgui.Create(...)
		local gas = o_vgui_create(...)
		//gas:SetSkin("mercury3")
		//print("skin")
		return gas
	end 

	for _,f in pairs(file.Find("mercury/menu/*.lua","LUA")) do
		local S,ER =	pcall(function() include("mercury/menu/" .. f) end) // OUCH!!!! MY MEMORY!!!
		if (S) then Msg("[Mercury-Menu]: Adding accessory: " .. f .. "\n") else
	 		 Msg("[Mercury-Menu]: Adding accessory: " .. ER .. "\n")
		end
	end   
	Mercury.ModHook.Call("AddMenuRealtime")
	local rootwindow = vgui.Create( "DFrame" )

	rootwindow:SetSize( 640, 480 )
	rootwindow:Center()
 	rootwindow:SetTitle( "MERCURY MENUVM2 BETA V1.87" )
	rootwindow:SetVisible( true )
	rootwindow:MakePopup()
	
	local prosh = vgui.Create("DPropertySheet", rootwindow)
	prosh:Dock(FILL)
	prosh:SetPos(0,24)

	function prosh:GetWindow()
		return rootwindow
	end 

	function rootwindow:GetPropertySheet()
		return prosh
	end
	
	/*
	local trace = debug.traceback()
	timer.Simple(2,function()
		if rootwindow and IsValid(rootwindow) then 
				function rootwindow:Paint(w,h) 

					surface.SetDrawColor(Color(0,0,255))
					surface.DrawRect(0,0,w,h)
					surface.SetTextColor(Color(255,255,255))
					surface.SetTextPos(10,50)
					surface.SetFont("Mercurycrash")
					surface.DrawText("NO PLS.") 

							surface.SetTextPos(10,90)
					surface.SetFont("ChatFont")
					surface.DrawText("Mercury can't load menu VM.") 

					draw.DrawText( trace, "Mercurycrashs", 10, 120, Color(255,255,255), TEXT_ALIGN_LEFT) 


				end

		end
	end)
*/

	//if true then return false end lol
	for k,v in pairs(MenuTabs) do
		local cf = MenuTabs[k]["checkfunc"]
		local shouldgen = true 
		if (cf) and cf~=nil then 
			shouldgen = cf()
		end
	
		if shouldgen == true then 
			local window = vgui.Create("DPanel",prosh)
			window:SetSize(640,456)
			local gtab = MenuTabs[k]
			local gf = MenuTabs[k]["genfunc"]
			local stat , err = xpcall(gf,function(err) Mercury.Menu.ShowError(err .. " \n " .. debug.traceback()) end,window)
			prosh:AddSheet(  gtab.name ,window, gtab.icon , false, false, gtab.desc ) // Register window on propertysheet.
		end
	end
	vgui.Create = o_vgui_create
end

function Mercury.Menu.ShowError(err)
	surface.PlaySound("mercury/mercury_error.ogg")
	local rootwindow = vgui.Create( "DFrame" ) // Actual window frame
	rootwindow:SetSize( 480, 480 )
	rootwindow:Center()
 	rootwindow:SetTitle( "Mercury - Error" )
	rootwindow:SetVisible( true )
	rootwindow:MakePopup()

	local DLabel = vgui.Create( "DLabel", rootwindow )
	DLabel:SetPos( 60, 50 )
	DLabel:SetText( "An error occured on clientside." )
	DLabel:SizeToContents()

	local tbox = vgui.Create("HTML", rootwindow) 
	tbox:SetSize( 450 , 365)
	tbox:SetPos(15,96)
	tbox:SetHTML([[<pre>  <font color="white">]] .. err .. "<font></pre>")
end


function Mercury.Menu.ShowErrorCritical(err)
	surface.PlaySound("mercury/mercury_error.ogg")
	local rootwindow = vgui.Create( "DFrame" ) // Actual window frame
	rootwindow:SetSize( 480, 480 )
	rootwindow:Center()
 	rootwindow:SetTitle( "Mercury - Critical Failure" )
	rootwindow:SetVisible( true )
	rootwindow:MakePopup()


	local DLabel = vgui.Create( "DLabel", rootwindow )
	DLabel:SetPos( 60, 50 )
	DLabel:SetText( "A critical failure has occured." )
	DLabel:SizeToContents()

	local tbox = vgui.Create("HTML", rootwindow) 
	tbox:SetSize( 450 , 365)
	tbox:SetPos(15,96)
	tbox:SetHTML([[<pre>  <font color="white">]] .. err .. "<font></pre>")
end

function Mercury.Menu.ShowWarning(text)
	  
					surface.PlaySound("mercury/mercury_error.ogg")
					local rootwindow = vgui.Create( "DFrame" ) // actual window frame
		
					rootwindow:SetSize( 480, 150 )
					rootwindow:Center()
			 		rootwindow:SetTitle( "Mercury - Warning" )
					rootwindow:SetVisible( true )
					rootwindow:MakePopup()
			
						local DLabel = vgui.Create( "DLabel", rootwindow )
						DLabel:SetPos( 60, 50 )
						DLabel:SetText( text )
						DLabel:SetColor(Color(255,255,255))
						DLabel:SizeToContents()
						local ConfirmUnban = vgui.Create( "DButton" , rootwindow)
							ConfirmUnban:SetPos( 90,  80 )
							ConfirmUnban:SetText( "Yeah, okay" )
							ConfirmUnban:SetSize(90,20)
							ConfirmUnban.DoClick = function( self )
								surface.PlaySound("mercury/mercury_info.ogg")
        rootwindow:Close()

									
						end
    ConfirmUnban:Dock(BOTTOM)
    

							
							



end



local progressactive = false
local progress = 0 
local maxprogress = 500
local progresstext = "???"
function Mercury.Menu.ShowProgress(message)
	progresstext = message
	progressactive = true 
end

hook.Add("PostRenderVGUI","MercuryProgress",function()
	if progressactive then
		surface.SetDrawColor(Color(1,1,1))
		surface.DrawRect( (ScrW() / 2 ) - ((ScrW() / 4) / 2), (ScrH() / 2 ) - ((ScrH() / 5) / 2), (ScrW() / 4),(ScrH() / 5))
		surface.SetDrawColor(Color(200,200,200))
		surface.DrawRect( (ScrW() / 2 ) - ((ScrW() / 4) / 2), (ScrH() / 2 ) - ((ScrH() / 5) / 2), (ScrW() / 4),(ScrH() / 5))

		local pulse = math.sin(CurTime()  * 10) * 2
		surface.SetDrawColor(Color(50,50,50))
		surface.DrawRect( (ScrW() / 1.9) - ((ScrW() / 4) / 2) - pulse, (ScrH() / 1.95) - pulse , (ScrW() / 5) + pulse* 2 ,(ScrH() / 24) + pulse * 2)


		surface.SetDrawColor(Color(50,255,50))
		surface.DrawRect( (ScrW() / 1.9) - ((ScrW() / 4) / 2) - pulse , (ScrH() / 1.95) - pulse ,  ((ScrW() / 5) + pulse * 2) * math.Clamp((progress / maxprogress),0,1)  , ((ScrH() / 24))  + pulse*2 )

		draw.SimpleText( progresstext, "ChatFont", ScrW() / 2, ScrH() / 2.3, Color(1,1,1,255) , TEXT_ALIGN_CENTER) 
	end
end)


function Mercury.Menu.CloseProgress()
	progressactive = false
	progresstext = "This shouldn't be open :/"
	progress = 0 
	maxprogress = 1
end

function Mercury.Menu.UpdateProgress(current,max,newtitle)
	print("Should update?")
	progress = current 
	maxprogress = max
	if newtitle then 
		progresstext = newtitle 
	end
end


net.Receive("Mercury:Progress",function()
	local command = net.ReadString()
	local data = net.ReadTable() 
	if command == "START_PROGRESS" then 
		Mercury.Menu.ShowProgress(data.messagetext)
	end
	if command == "UPDATE_PROGRESS" then 
		progress = data.progress 
		maxprogress = data.maxprogress
	end
	if command == "STOP_PROGRESS" then
		Mercury.Menu.CloseProgress()
	end
end)