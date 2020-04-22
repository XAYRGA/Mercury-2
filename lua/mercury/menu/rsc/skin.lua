

local SKIN = setmetatable({}, {
	__index = function(t, k)
		return derma.GetDefaultSkin()[k]
	end,
})

 
SKIN.BrightText = Color( 243, 245, 239, 255 )
SKIN.NormalText = Color( 226, 231, 218, 255 )
SKIN.DarkText = Color( 188, 198, 166, 255 )
SKIN.VeryDarkText = Color( 33, 37, 24, 255 )
 
SKIN.BrightPBrown = Color( 243, 245, 239, 255 )
SKIN.NormalPBrown = Color( 103, 67, 79, 255 )
SKIN.DarkPBrown = Color( 67, 44, 51, 255 )
SKIN.VeryDarkPBrown = Color( 37, 24, 29, 255 )
 
SKIN.BrightRed = Color( 226, 69, 113, 255 )
SKIN.NormalRed = Color( 165, 26, 65, 255)
SKIN.DarkRed = Color( 100, 44, 51, 255 )
SKIN.VeryDarkRed = Color( 37, 24, 29, 255 )
 
SKIN.BrightPurple = Color( 107, 63, 124, 255 )
SKIN.NormalPurple = Color( 49, 29, 57, 255)
SKIN.DarkPurple = Color( 34, 20, 39, 255 )
 
SKIN.BrightGray = Color( 197, 189, 180, 255 )
SKIN.NormalGray = Color( 155, 142, 126, 255)
SKIN.DarkGray = Color( 95, 85, 73, 255 )
 
 

 
-- Fuckaton of different corners, keypad, buttons, scrollbar, yadda yadda
SKIN.ButtonCornerLines=SKIN.BrightRed
SKIN.ButtonCornerLinesHighlight=SKIN.DarkRed
 
 
 
SKIN.bg_color_bright                    =               Color( 150, 150, 150, 175 )
SKIN.control_color                              =               Color( 40, 40, 40, 255 )
SKIN.colButtonBorder                    =               Color( 20, 20, 20, 255 )
 
SKIN.bg_color                                   =               Color( 50, 50, 50, 155 )
SKIN.control_color_bright               =               Color( 138, 170, 255, 235 )
 
 
// Text entry and drop down
SKIN.colTextEntryText                   =               SKIN.BrightText
        SKIN.colTextEntryBG                             =               SKIN.NormalGray
        SKIN.colTextEntryTextHighlight  =               Color( 255, 255, 255, 200 )
 
 
// List hover
SKIN.listview_hover                             =               SKIN.BrightRed
SKIN.listview_selected                  =               SKIN.NormalRed
 
SKIN.combobox_selected                  =               SKIN.listview_selected
 
 
SKIN.colOutline                                 =               Color( 225, 225, 235, 200 )
 
-- Unused?
SKIN.text_bright                                =               SKIN.BrightText
 
--??
SKIN.colButtonBorderHighlight   =               Color( 255, 255, 255, 50 )
 
 
// Pretty much all buttons
SKIN.control_color_active               =               Color( 150, 150, 150, 245 )
        SKIN.control_color_dark                 =               Color( 60, 0, 0, 255 )
        SKIN.control_color_highlight    =               Color( 120, 0, 0, 200 )
       
 
SKIN.colCategoryText                    =               SKIN.NormalText
        SKIN.fontCategoryHeader         =               "QTabLarge"
 
        --??
SKIN.panel_transback                    =               Color( 255, 255, 255, 50 )
 
 
SKIN.text_highlight                             =               Color( 200, 200, 225, 255 )
SKIN.colTextEntryBorder                 =               Color( 20, 20, 20, 255 )
SKIN.colButtonTextDisabled              =               Color( 1, 1, 1, 255 )
SKIN.bg_color_sleep                             =               Color( 50, 50, 50, 100 )
 
-- Tab buttons
-- We can do this here without sacrificing performance.
SKIN.colTab                                             =               Color(50,125,50,150)
        SKIN.colTabText                         =               Color(1,1,1,255)
       
SKIN.colTabInactive                             =               Color(25,50,25,150)
        SKIN.colTabTextInactive         =              Color(1,1,1,255)
-- Dont change, ita a very lame shadow :s
SKIN.colTabShadow                               =               Color(SKIN.BrightRed.r,SKIN.BrightRed.g,SKIN.BrightRed.b,50)
       
 
SKIN.colPropertySheet                   =               Color( 50, 50, 50, 200 )
SKIN.colNumberWangBG                    =               Color( 255, 240, 150, 255 )
 
-- For example the lines in tools list
SKIN.colCollapsibleCategory             =               Color( 255, 255, 255, 20 )
 
SKIN.bg_alt2                                    =               Color( 55, 55, 55, 255 )
 
SKIN.colMenuBG                                  =               Color(SKIN.DarkRed.r,SKIN.DarkRed.g,SKIN.DarkRed.b,230)
SKIN.colMenuBorder                              =               Color(SKIN.BrightRed.r,SKIN.BrightRed.g,SKIN.BrightRed.b,200)
 
SKIN.colButtonBorderShadow              =               Color( 5, 20, 50, 100 )
 
-- yeah, tooltip..
SKIN.tooltip                                    =               SKIN.BrightPBrown
 
SKIN.text_dark                                  =               Color( 1, 1, 1, 255 )
SKIN.text_normal                                =               Color( 25, 25, 25, 255 )
 
SKIN.bg_alt1                                    =               Color( 50, 50, 50, 255 )
 
 -- A lot of buttons
SKIN.colButtonText                              =               Color( 255, 255, 255, 255 )
 
SKIN.bg_color_dark                              =               Color( 25, 25, 25, 155 )
SKIN.colCategoryTextInactive    =               Color( 150, 150, 240, 255 )
 
 
 
SKIN.texGradient        = Material( "gui/gradient" )
SKIN.BGGradient                                 =               Material( "VGUI/hsv-brightness" ) -- lol :s TODO: Make own
SKIN.texGradientUp                              =               Material( "gui/gradient_up" )
SKIN.texGradientDown                    =               Material( "gui/gradient_down" )
 
SKIN.fontButton                                 = "QDefaultSmall"
SKIN.fontTab                                    = "QDefaultSmall"
SKIN.fontButton                                 = "QDefaultSmall"
SKIN.fontFrame                                  = "QDefaultSmall"
 
 
 
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
 
 
 
 
 SKIN.colOutline	= Color( 51, 51, 51, 225 )

// You can change the colours from the Default skin

SKIN.colPropertySheet 			= Color( 225, 225, 225, 255 )
SKIN.colTab			 			= SKIN.colPropertySheet
SKIN.colTabText		 			= Color( 1, 1, 1, 225 )
SKIN.colTabInactive				= Color( 1, 1, 1, 225 )
SKIN.colTabShadow				= Color( 0, 0, 0, 225 )
SKIN.fontButton					= "Default"
SKIN.fontTab					= "Default"
SKIN.bg_color 					= Color( 0, 0, 0, 225 )
SKIN.bg_color_sleep 			= Color( 225, 225, 225, 225 )
SKIN.bg_color_dark				= Color( 0, 0, 0, 225 )
SKIN.bg_color_bright			= Color( 225, 225, 225, 255 )
SKIN.listview_hover				= Color( 31, 31, 31, 225 )
SKIN.listview_selected			= Color( 0, 0, 0, 225 )
SKIN.control_color 				= Color( 225, 225, 225, 225 )
SKIN.control_color_highlight	= Color( 225, 225, 225, 255 )
SKIN.control_color_active 		= Color( 31, 31, 31, 225 )
SKIN.control_color_bright 		= Color( 31, 31, 31, 225 )
SKIN.control_color_dark 		= Color( 31, 31, 31, 255 )
SKIN.text_bright				= Color( 0, 0, 0, 255 )
SKIN.text_normal				= Color( 51, 51, 51, 225 )
SKIN.text_dark					= Color( 255, 225, 225, 255 )
SKIN.text_highlight				= Color( 0, 0, 0, 20 )
SKIN.colCategoryText			= Color( 51, 51, 51, 255 )
SKIN.colCategoryTextInactive	= Color( 31, 31, 31, 255 )
SKIN.fontCategoryHeader			= "TabLarge"
SKIN.colTextEntryTextHighlight	= Color( 31, 31, 31, 255 )
SKIN.colTextEntryTextHighlight	= Color( 31, 31, 31, 255 )
SKIN.colCategoryText			= Color( 255, 255, 255, 255 )
SKIN.colCategoryTextInactive	= Color( 225, 225, 225, 255 )
SKIN.fontCategoryHeader			= "TabLarge"
 
 SKIN.Colors = {}
 SKIN.Colors.Label = {}

  SKIN.Colors.Label.Bright = SKIN.text_bright
   SKIN.Colors.Label.Dark = SKIN.text_dark
 
 
 
 
/*---------------------------------------------------------
   DrawGenericBackground
---------------------------------------------------------*/
function SKIN:DrawGenericBackground( x, y, w, h, color )
 
        surface.SetDrawColor( color )
        --draw.RoundedBox( 2, x, y, w, h, color )
        surface.DrawRect( x, y, w, h )
       
end
 
/*---------------------------------------------------------
   DrawButtonBorder
---------------------------------------------------------*/
 
function SKIN:DrawButtonBorder( x, y, w, h, depressed )
       
        if ( !depressed ) then
                surface.SetDrawColor(self.ButtonCornerLinesHighlight)
        else
                surface.SetDrawColor(self.ButtonCornerLines)
        end
                surface.DrawOutlinedRect( x+1,y+1,w-2,h-2 )
       
 
end
 
/*---------------------------------------------------------
   DrawDisabledButtonBorder
---------------------------------------------------------*/
function SKIN:DrawDisabledButtonBorder( x, y, w, h, depressed )
 
        surface.SetDrawColor( 0, 0, 0, 150 )
        surface.DrawOutlinedRect( x, y, w, h )
       
end
 
 
/*---------------------------------------------------------
        Frame
---------------------------------------------------------*/
function SKIN:PaintFrame( panel )
 
        local color = self.bg_color
 
        self:DrawGenericBackground( 0, 0, panel:GetWide(), panel:GetTall(), color )
       
        surface.SetDrawColor( 0, 0, 0, 200 )
        surface.DrawRect( 0, 0, panel:GetWide(), 23 )
 
end
 
function SKIN:LayoutFrame( panel )
 
        panel.lblTitle:SetFont( self.fontFrame )
       
        panel.btnClose:SetPos( panel:GetWide() - 22, 4 )
        panel.btnClose:SetSize( 18, 18 )
       
        panel.lblTitle:SetPos( 8, 2 )
        panel.lblTitle:SetSize( panel:GetWide() - 25, 20 )
 
end
 
 
/*---------------------------------------------------------
        Button
---------------------------------------------------------*/
function SKIN:PaintButton( panel )
 
        local w, h = panel:GetSize()
 
     
       
                local col = self.control_color
               
                if ( panel:GetDisabled() ) then
                        col = self.control_color_dark
                elseif ( panel.Depressed or panel:IsDown() ) then
                        col = self.control_color_active
                elseif ( panel.Hovered ) then
                        col = self.control_color_highlight
                end
               
                surface.SetDrawColor( col.r, col.g, col.b, col.a )
                panel:DrawFilledRect()
                self:PaintOverButton(panel)
      
 
end
function SKIN:PaintOverButton( panel )
 
        local w, h = panel:GetSize()
       
       
                if ( panel:GetDisabled() ) then
                        self:DrawDisabledButtonBorder( 0, 0, w, h )
                else
                        self:DrawButtonBorder( 0, 0, w, h, panel.Depressed || panel:IsDown()  )
                end
    
 
end
 
 
function SKIN:SchemeButton( panel )
 
        panel:SetFont( self.fontButton )
       
        if ( panel:GetDisabled() ) then
                panel:SetTextColor( self.colButtonTextDisabled )
        else
                panel:SetTextColor( self.colButtonText )
        end
       
        DLabel.ApplySchemeSettings( panel )
 
end
 
/*---------------------------------------------------------
        SysButton
---------------------------------------------------------*/
function SKIN:PaintPanel( panel )
 
        if ( panel.m_bPaintBackground ) then
       
                local w, h = panel:GetSize()
                self:DrawGenericBackground( 0, 0, w, h, panel.m_bgColor or self.panel_transback )
               
        end    
 
end
 
/*---------------------------------------------------------
        SysButton
---------------------------------------------------------*/
function SKIN:PaintSysButton( panel )
 
        self:PaintButton( panel )
        self:PaintOverButton( panel ) // Border
 
end
 
function SKIN:SchemeSysButton( panel )
 
        panel:SetFont( "Marlett" )
        DLabel.ApplySchemeSettings( panel )
       
end
 
 
/*---------------------------------------------------------
        ImageButton
---------------------------------------------------------*/
function SKIN:PaintImageButton( panel )
 
        self:PaintButton( panel )
 
end
 
/*---------------------------------------------------------
        ImageButton
---------------------------------------------------------*/
function SKIN:PaintOverImageButton( panel )
 
        self:PaintOverButton( panel )
 
end
function SKIN:LayoutImageButton( panel )
 
        if ( panel.m_bBorder ) then
                panel.m_Image:SetPos( 1, 1 )
                panel.m_Image:SetSize( panel:GetWide()-2, panel:GetTall()-2 )
        else
                panel.m_Image:SetPos( 0, 0 )
                panel.m_Image:SetSize( panel:GetWide(), panel:GetTall() )
        end
 
end
 
/*---------------------------------------------------------
        PaneList
---------------------------------------------------------*/
function SKIN:PaintPanelList( panel )
 
        if ( panel.m_bBackground ) then
                draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall(), self.bg_color_dark )
        end
 
end
 
/*---------------------------------------------------------
        ScrollBar
---------------------------------------------------------*/
function SKIN:PaintVScrollBar( panel )
 
        surface.SetDrawColor( self.bg_color.r, self.bg_color.g, self.bg_color.b, self.bg_color.a )
        surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() )
 
end
function SKIN:LayoutVScrollBar( panel )
 
        local Wide = panel:GetWide()
        local Scroll = panel:GetScroll() / panel.CanvasSize
        local BarSize = math.max( panel:BarScale() * (panel:GetTall() - (Wide * 2)), 10 )
        local Track = panel:GetTall() - (Wide * 2) - BarSize
        Track = Track + 1
       
        Scroll = Scroll * Track
       
        panel.btnGrip:SetPos( 0, Wide + Scroll )
        panel.btnGrip:SetSize( Wide, BarSize )
       
        panel.btnUp:SetPos( 0, 0, Wide, Wide )
        panel.btnUp:SetSize( Wide, Wide )
       
        panel.btnDown:SetPos( 0, panel:GetTall() - Wide, Wide, Wide )
        panel.btnDown:SetSize( Wide, Wide )
 
end
 
/*---------------------------------------------------------
        ScrollBarGrip
---------------------------------------------------------*/
function SKIN:PaintScrollBarGrip( panel )
 
        surface.SetDrawColor( self.control_color.r, self.control_color.g, self.control_color.b, self.control_color.a )
        surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() )
 
        self:DrawButtonBorder( 0, 0, panel:GetWide(), panel:GetTall() )
 
end
 
/*---------------------------------------------------------
        ScrollBar
---------------------------------------------------------*/
function SKIN:PaintMenu( panel )
 
        surface.SetDrawColor( self.colMenuBG )
        panel:DrawFilledRect( 0, 0, w, h )
 
end
 
 
function SKIN:PaintOverMenu( panel )
 
        surface.SetDrawColor( self.colMenuBorder )
        panel:DrawOutlinedRect( 0, 0, w, h )
 
end
 
 
function SKIN:LayoutMenu( panel )
 
        local w = panel:GetMinimumWidth()
       
        // Find the widest one
        for k, pnl in pairs( panel.Panels ) do
       
                pnl:PerformLayout()
                w = math.max( w, pnl:GetWide() )
       
        end
 
        panel:SetWide( w )
       
        local y = 0
       
        for k, pnl in pairs( panel.Panels ) do
       
                pnl:SetWide( w )
                pnl:SetPos( 0, y )
                pnl:InvalidateLayout( true )
               
                y = y + pnl:GetTall()
       
        end
       
        panel:SetTall( y )
 
end
 
/*---------------------------------------------------------
        ScrollBar
---------------------------------------------------------*/
function SKIN:PaintMenuOption( panel )
 
        if ( panel.m_bBackground && panel.Hovered ) then
       
                local col = nil
               
                if ( panel.Depressed ) then
                        col = self.control_color_bright
                else
                        col = self.control_color_active
                end
               
                surface.SetDrawColor( col.r, col.g, col.b, col.a )
                surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() )
       
        end
       
end
function SKIN:LayoutMenuOption( panel )
 
        // This is totally messy. :/
 
        panel:SizeToContents()
 
        panel:SetWide( panel:GetWide() + 30 )
       
        local w = math.max( panel:GetParent():GetWide(), panel:GetWide() )
 
        panel:SetSize( w, 18 )
       
        if ( panel.SubMenuArrow ) then
       
                panel.SubMenuArrow:SetSize( panel:GetTall(), panel:GetTall() )
                panel.SubMenuArrow:CenterVertical()
                panel.SubMenuArrow:AlignRight()
               
        end
       
end
function SKIN:SchemeMenuOption( panel )
 
        panel:SetFGColor( 255, 255, 255, 255 )
       
end
 
/*---------------------------------------------------------
        TextEntry
---------------------------------------------------------*/
function SKIN:PaintTextEntry( panel )
 
        if ( panel.m_bBackground ) then
       
                surface.SetDrawColor( self.colTextEntryBG )
                --local htall=panel:GetTall()/2
                --surface.DrawRect( 0, 0, panel:GetWide(),htall )
               
                --surface.SetDrawColor( self.TextEntryBGDown )
                --surface.DrawRect( 0, htall, panel:GetWide(), htall )
               
               
                surface.SetMaterial( self.BGGradient )
                --surface.SetDrawColor( self.colTabInactive )
                surface.DrawTexturedRect( 0, 0, panel:GetWide(), panel:GetTall() )
        end
       
        panel:DrawTextEntryText( panel.m_colText, panel.m_colHighlight, panel.m_colCursor )
       
        if ( panel.m_bBorder ) then
       
                surface.SetDrawColor( self.colTextEntryBorder )
                surface.DrawOutlinedRect( 0, 0, panel:GetWide(), panel:GetTall() )
       
        end
 
       
end
function SKIN:SchemeTextEntry( panel )
 
        panel:SetTextColor( self.colTextEntryText )
        panel:SetHighlightColor( self.colTextEntryTextHighlight )
        panel:SetCursorColor( Color( 0, 0, 100, 255 ) )
 
end
 
/*---------------------------------------------------------
        Label
---------------------------------------------------------*/
function SKIN:PaintLabel( panel )
        return false
end
 
function SKIN:SchemeLabel( panel )
 
        local col = nil
 
        if ( panel.Hovered && panel:GetTextColorHovered() ) then
                col = panel:GetTextColorHovered()
        else
                col = panel:GetTextColor()
        end
       
        if ( col ) then
                panel:SetFGColor( col.r, col.g, col.b, col.a )
        else
                panel:SetFGColor( 200, 200, 200, 255 )
        end
 
end
 
function SKIN:LayoutLabel( panel )
 
        panel:ApplySchemeSettings()
       
        if ( panel.m_bAutoStretchVertical ) then
                panel:SizeToContentsY()
        end
       
end
 
/*---------------------------------------------------------
        CategoryHeader
---------------------------------------------------------
function SKIN:PaintCategoryHeader( panel )
               
end
 
function SKIN:SchemeCategoryHeader( panel )
       
        panel:SetTextInset( 5 )
        panel:SetFont( self.fontCategoryHeader )
       
        if ( panel:GetParent():GetExpanded() ) then
                panel:SetTextColor( self.colCategoryText )
        else
                panel:SetTextColor( self.colCategoryTextInactive )
        end
       
end
 */

 
/*---------------------------------------------------------
        Tab
---------------------------------------------------------*/
function SKIN:PaintTab( panel )
 
        // This adds a little shadow to the right which helps define the tab shape..
        draw.RoundedBox( 0, 0, 0, panel:GetWide(), panel:GetTall() + 8, self.colTabShadow )
       
        if ( panel:GetPropertySheet():GetActiveTab() == panel ) then
                draw.RoundedBox( 0, 1, 0, panel:GetWide()-2, panel:GetTall() + 8, self.colTab )
             
        else
        --      local halftall=(panel:GetTall() + 8)/2
                --draw.RoundedBox( 0, 0, 0, panel:GetWide()-1, panel:GetTall() + halftall, self.colTabInactive  )
                --draw.RoundedBox( 0, 0, halftall, panel:GetWide()-1, halftall, self.colTabInactiveBottom  )
                surface.SetMaterial( self.BGGradient )
                surface.SetDrawColor( self.colTabInactive )
                surface.DrawTexturedRect( 0, 0, panel:GetWide()-1, panel:GetTall() + 8 )

        end
       
end
function SKIN:SchemeTab( panel )
 
        panel:SetFont( self.fontTab )
 
        local ExtraInset = 10
 
        if ( panel.Image ) then
                ExtraInset = ExtraInset + panel.Image:GetWide()
        end
       
        panel:SetTextInset( ExtraInset )
        panel:SizeToContents()
        panel:SetSize( panel:GetWide() + 10, panel:GetTall() + 8 )
       
        local Active = panel:GetPropertySheet():GetActiveTab() == panel
       
        if ( Active ) then
        		print("actv")
                panel:SetTextColor( self.colTabText )
        else
                panel:SetTextColor( self.colTabTextInactive )
                	print("actv")
        end
       
        panel.BaseClass.ApplySchemeSettings( panel )
               
end
 
function SKIN:LayoutTab( panel )
 		//print("AAA")
        panel:SetTall( 22 )
 
        if ( panel.Image ) then
       
                local Active = panel:GetPropertySheet():GetActiveTab() == panel
               
                local Diff = panel:GetTall() - panel.Image:GetTall()
                panel.Image:SetPos( 7, Diff * 0.6 )
               
                if ( !Active ) then
                        panel.Image:SetImageColor( Color( 170, 170, 170, 155 ) )
                else
                        panel.Image:SetImageColor( Color( 255, 255, 255, 255 ) )
                end
       
        end    
       
end
 
 
 
/*---------------------------------------------------------
        PropertySheet
---------------------------------------------------------*/
function SKIN:PaintPropertySheet( panel )
 
        local ActiveTab = panel:GetActiveTab()
        local Offset = 0
        if ( ActiveTab ) then Offset = ActiveTab:GetTall() end
       
        // This adds a little shadow to the right which helps define the tab shape..
        draw.RoundedBox( 4, 0, Offset, panel:GetWide(), panel:GetTall()-Offset, self.colPropertySheet )
       
end
 
/*---------------------------------------------------------
        ListView
---------------------------------------------------------*/
function SKIN:PaintListView( panel )
 
        if ( panel.m_bBackground ) then
                surface.SetDrawColor( 50, 50, 50, 255 )
                panel:DrawFilledRect()
        end
       
end
       
/*---------------------------------------------------------
        ListViewLine
---------------------------------------------------------*/
 
       
function SKIN:PaintListViewLine( panel )
 
        local Col = nil
       
        if ( panel:IsSelected() ) then
       
                Col = self.listview_selected
               
        elseif ( panel.Hovered ) then
       
                Col = self.listview_hover
               
        elseif ( panel.m_bAlt ) then
       
                Col = self.bg_alt2
               
        else
       
                return
                               
        end
               
        surface.SetDrawColor( Col.r, Col.g, Col.b, Col.a )
        surface.SetMaterial(self.texGradient)
        surface.DrawTexturedRect( 0, 1, panel:GetWide(), panel:GetTall() -2)
       
end
 
 
/*---------------------------------------------------------
        ListViewLabel
---------------------------------------------------------*/
function SKIN:SchemeListViewLabel( panel )
 
        panel:SetTextInset( 3 )
        panel:SetTextColor( Color( 255, 255, 255, 255 ) )
 
end
 
 
/*---------------------------------------------------------
        ListViewLabel
---------------------------------------------------------*/
local Dark=Color( 0, 0, 0, 255 )
local Bright=Color( 255, 255, 255, 255 )
function SKIN:PaintListViewLabel( panel )
 
 
        local Col = nil
       
        if ( panel:GetParent():IsSelected() ) then
       
                panel:SetTextColor( Bright )
               
        elseif ( panel:GetParent().Hovered ) then
       
                panel:SetTextColor( Bright )
               
        else
       
                panel:SetTextColor( Bright )
                               
        end
               
end
 
 
 
/*---------------------------------------------------------
        Form
---------------------------------------------------------*/
function SKIN:PaintForm( panel )
 
        local color = self.bg_color_sleep
 
        self:DrawGenericBackground( 0, 9, panel:GetWide(), panel:GetTall()-9, self.bg_color )
 
end
function SKIN:SchemeForm( panel )
 
        panel.Label:SetFont( "TabLarge" )
        panel.Label:SetTextColor( Color( 255, 255, 255, 255 ) )
 
end
function SKIN:LayoutForm( panel )
 
end
 
 
/*---------------------------------------------------------
        MultiChoice
---------------------------------------------------------*/
function SKIN:LayoutMultiChoice( panel )
 
        panel.TextEntry:SetSize( panel:GetWide(), panel:GetTall() )
       
        panel.DropButton:SetSize( panel:GetTall(), panel:GetTall() )
        panel.DropButton:SetPos( panel:GetWide() - panel:GetTall(), 0 )
       
        panel.DropButton:SetZPos( 1 )
        panel.DropButton:SetDrawBackground( false )
        panel.DropButton:SetDrawBorder( false )
       
        panel.DropButton:SetTextColor( Color( 30, 100, 200, 255 ) )
        panel.DropButton:SetTextColorHovered( Color( 50, 150, 255, 255 ) )
       
end
 
 
/*
NumberWangIndicator
*/
 
function SKIN:DrawNumberWangIndicatorText( panel, wang, x, y, number, alpha )
 
        local alpha = math.Clamp( alpha ^ 0.5, 0, 1 ) * 255
        local col = self.text_dark
       
        // Highlight round numbers
        local dec = (wang:GetDecimals() + 1) * 10
        if ( number / dec == math.ceil( number / dec ) ) then
                col = self.text_highlight
        end
 
        draw.SimpleText( number, "Default", x, y, Color( col.r, col.g, col.b, alpha ) )
       
end
 
 
 
function SKIN:PaintNumberWangIndicator( panel )
       
        /*
       
                Please excuse the crudeness of this code.
       
        */
 
        if ( panel.m_bTop ) then
                surface.SetMaterial( self.texGradientUp )
        else
                surface.SetMaterial( self.texGradientDown )
        end
       
        surface.SetDrawColor( self.colNumberWangBG )
        surface.DrawTexturedRect( 0, 0, panel:GetWide(), panel:GetTall() )
       
        local wang = panel:GetWang()
        local CurNum = math.floor( wang:GetFloatValue() )
        local Diff = CurNum - wang:GetFloatValue()
               
        local InsetX = 3
        local InsetY = 5
        local Increment = wang:GetTall()
        local Offset = Diff * Increment
        local EndPoint = panel:GetTall()
        local Num = CurNum
        local NumInc = 1
       
        if ( panel.m_bTop ) then
       
                local Min = wang:GetMin()
                local Start = panel:GetTall() + Offset
                local End = Increment * -1
               
                CurNum = CurNum + NumInc
                for y = Start, Increment * -1, End do
       
                        CurNum = CurNum - NumInc
                        if ( CurNum < Min ) then break end
                                       
                        self:DrawNumberWangIndicatorText( panel, wang, InsetX, y + InsetY, CurNum, y / panel:GetTall() )
               
                end
       
        else
       
                local Max = wang:GetMax()
               
                for y = Offset - Increment, panel:GetTall(), Increment do
                       
                        self:DrawNumberWangIndicatorText( panel, wang, InsetX, y + InsetY, CurNum, 1 - ((y+Increment) / panel:GetTall()) )
                       
                        CurNum = CurNum + NumInc
                        if ( CurNum > Max ) then break end
               
                end
       
        end
       
 
end
 
function SKIN:LayoutNumberWangIndicator( panel )
 
        panel.Height = 200
 
        local wang = panel:GetWang()
        local x, y = wang:LocalToScreen( 0, wang:GetTall() )
       
        if ( panel.m_bTop ) then
                y = y - panel.Height - wang:GetTall()
        end
       
        panel:SetPos( x, y )
        panel:SetSize( wang:GetWide() - wang.Wanger:GetWide(), panel.Height)
 
end
 
/*---------------------------------------------------------
        CheckBox
---------------------------------------------------------*/
function SKIN:PaintCheckBox( panel )
 
        local w, h = panel:GetSize()
 
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawRect( 1, 1, w-2, h-2 )
 
        surface.SetDrawColor( 30, 30, 30, 255 )
        //=
        surface.DrawRect( 1, 0, w-2, 1 )
        surface.DrawRect( 1, h-1, w-2, 1 )
        //||
        surface.DrawRect( 0, 1, 1, h-2 )
        surface.DrawRect( w-1, 1, 1, h-2 )
       
        surface.DrawRect( 1, 1, 1, 1 )
        surface.DrawRect( w-2, 1, 1, 1 )
       
        surface.DrawRect( 1, h-2, 1, 1 )
        surface.DrawRect( w-2, h-2, 1, 1 )
 
end
 
function SKIN:SchemeCheckBox( panel )
 
        panel:SetTextColor( Color( 255, 0, 0, 255 ) )
        DButton.ApplySchemeSettings( panel )
       
end
 
 
 
/*---------------------------------------------------------
        Slider
---------------------------------------------------------*/
function SKIN:PaintSlider( panel )
 
end
 
 
/*---------------------------------------------------------
        NumSlider
---------------------------------------------------------*/
function SKIN:PaintNumSlider( panel )
 
        local w, h = panel:GetSize()
       
        self:DrawGenericBackground( 0, 0, w, h, Color( 255, 255, 255, 20 ) )
       
        surface.SetDrawColor( 0, 0, 0, 200 )
        surface.DrawRect( 3, h/2, w-6, 1 )
       
end
 
 
 
/*---------------------------------------------------------
        NumSlider
---------------------------------------------------------*/
function SKIN:SchemeSlider( panel )
 
        panel.Knob:SetImageColor( Color(200,54,230,255) )
       
end
 
 
 
 
/*---------------------------------------------------------
        NumSlider
---------------------------------------------------------*/
function SKIN:PaintComboBoxItem( panel )
 
        if ( panel:GetSelected() ) then
                local col = self.combobox_selected
                surface.SetDrawColor( col.r, col.g, col.b, col.a )
                panel:DrawFilledRect()
        end
 
end
 
function SKIN:SchemeComboBoxItem( panel )
        panel:SetTextColor( Color( 0, 0, 30, 255 ) )
end
 
/*---------------------------------------------------------
        ComboBox
---------------------------------------------------------*/
function SKIN:PaintComboBox( panel )
       
        surface.SetDrawColor( 255, 255, 255, 255 )
        panel:DrawFilledRect()
               
        surface.SetDrawColor( 0, 0, 0, 255 )
        panel:DrawOutlinedRect()
       
end
 
/*---------------------------------------------------------
        ScrollBar
---------------------------------------------------------*/
function SKIN:PaintBevel( panel )
 
        local w, h = panel:GetSize()
 
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w-1, h-1)
       
        surface.SetDrawColor( 0, 0, 0, 255 )
        surface.DrawOutlinedRect( 1, 1, w-1, h-1)
 
end
 
 
/*---------------------------------------------------------
        Tree
---------------------------------------------------------*/
function SKIN:PaintTree( panel )
 
        if ( panel.m_bBackground ) then
                surface.SetDrawColor( self.bg_color_bright.r, self.bg_color_bright.g, self.bg_color_bright.b, self.bg_color_bright.a )
                panel:DrawFilledRect()
        end
 
end
 
 
 
/*---------------------------------------------------------
        TinyButton
---------------------------------------------------------*/
function SKIN:PaintTinyButton( panel )
 
        if ( panel.m_bBackground ) then
       
                surface.SetDrawColor( 255, 255, 255, 255 )
                panel:DrawFilledRect()
       
        end
       
        if ( panel.m_bBorder ) then
 
                surface.SetDrawColor( 0, 0, 0, 255 )
                panel:DrawOutlinedRect()
       
        end
 
end
 
function SKIN:SchemeTinyButton( panel )
 
        panel:SetFont( "Default" )
       
        if ( panel:GetDisabled() ) then
                panel:SetTextColor( Color( 0, 100, 150, 50 ) )
        else
                panel:SetTextColor( Color( 0, 100, 200, 255 ) )
        end
       
        DLabel.ApplySchemeSettings( panel )
       
        panel:SetFont( "DefaultSmall" )
 
end
 
/*---------------------------------------------------------
        TinyButton
---------------------------------------------------------*/
function SKIN:PaintTreeNodeButton( panel )
 
        if ( panel.m_bSelected ) then
 
                surface.SetDrawColor( 50, 200, 255, 150 )
                panel:DrawFilledRect()
       
        elseif ( panel.Hovered ) then
 
                surface.SetDrawColor( 255, 255, 255, 100 )
                panel:DrawFilledRect()
       
        end
       
       
 
end
 
function SKIN:SchemeTreeNodeButton( panel )
 
        DLabel.ApplySchemeSettings( panel )
 
end
 
/*---------------------------------------------------------
        Tooltip
---------------------------------------------------------
function SKIN:PaintTooltip( panel )
 
        local w, h = panel:GetSize()
 
        self:DrawGenericBackground( 0, 0, w, h, self.tooltip )
       	if !panel.Contents then 
       		self.Contents = {}
       	end 
        panel:DrawArrow( 0, 0 )
 
 
end
 */
/*---------------------------------------------------------
        VoiceNotify
---------------------------------------------------------*/
 
function SKIN:PaintVoiceNotify( panel )
 
        local w, h = panel:GetSize()
       
        self:DrawGenericBackground( 0, 0, w, h, panel.Color )
        self:DrawGenericBackground( 1, 1, w-2, h-2, Color( 60, 60, 60, 240 ) )
 
end
 
function SKIN:SchemeVoiceNotify( panel )
 
        panel.LabelName:SetFont( "TabLarge" )
        panel.LabelName:SetContentAlignment( 4 )
        panel.LabelName:SetColor( color_white )
       
        panel:InvalidateLayout()
       
end
 
function SKIN:LayoutVoiceNotify( panel )
 
        panel:SetSize( 200, 40 )
        panel.Avatar:SetPos( 4, 4 )
        panel.Avatar:SetSize( 32, 32 )
       
        panel.LabelName:SetPos( 44, 0 )
        panel.LabelName:SizeToContents()
        panel.LabelName:CenterVertical()
 
end

derma.DefineSkin( "mercury3", "MERCURY_3", SKIN )
