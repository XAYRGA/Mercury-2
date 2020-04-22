    
surface.CreateFont( "m3RAD", {
    font = "CloseCaption_Bold", 
    size = 20, 
    weight = 9000, 
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

surface.CreateFont( "m3RAD_Big", {
    font = "CloseCaption_Bold", 
    size = 20, 
    weight = 9000, 
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

surface.CreateFont( "m3RAD_HUGE", {
    font = "CloseCaption_Bold", 
    size = 50, 
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

surface.CreateFont( "m3RAD_ERROR", {
    font = "CloseCaption_Bold", 
    size = 350, 
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

    function draw.TextRotated( text, x, y, color, font, ang )
            render.PushFilterMag( TEXFILTER.ANISOTROPIC )
            render.PushFilterMin( TEXFILTER.ANISOTROPIC )
            surface.SetFont( font )
            surface.SetTextColor( color )
            surface.SetTextPos( 0, 0 )
            local textWidth, textHeight = surface.GetTextSize( text )
            local rad = -math.rad( ang )
            local halvedPi = math.pi / 2
            x = x - ( math.sin( rad + halvedPi ) * textWidth / 2 + math.sin( rad ) * textHeight / 2 )
            y = y - ( math.cos( rad + halvedPi ) * textWidth / 2 + math.cos( rad ) * textHeight / 2 )
            local m = Matrix()
            m:SetAngles( Angle( 0, ang, 0 ) )
            m:SetTranslation( Vector( x, y, 0 ) )
            cam.PushModelMatrix( m )
                surface.DrawText( text )
            cam.PopModelMatrix()
            render.PopFilterMag()
            render.PopFilterMin()
    end


    local RAD = 450
    local siwoosh = 500
    
    local SubMenu = {
   
    }
    
    local showing = false;
    local slice_size = 360 / #SubMenu
    local cnt = #SubMenu
    local mousedown = false
    local history = {}
    local OpenTable = {}
    local select_text = ""
    local select_color = Color(255,255,255)
    local mnuerror = false
    
    RadialMenu = {}
    
    
    
    
    function RadialMenu.Update(stable,back)
        SubMenu = stable
        slice_size = 360/ #SubMenu
        cnt = #SubMenu
          for k,v in pairs(SubMenu) do 
             v.selected = false
          end
        local largest_entry = 0
        local radialadd = 0
        for k,v in pairs(stable) do
            if #v.text > largest_entry then
                largest_entry = #v.text
            end
            if v.radialadd then
                radialadd = radialadd + v.radialadd
            end
        end
        RAD = (4 * largest_entry + (cnt * 7)) + radialadd
        swioosh = 500
        if not back then
            history[#history + 1] = stable
        end
      
    end
 
    function RadialMenu.SetOpenTable(tal)
        OpenTable = tal    
    end
    
    function RadialMenu.Open()
        showing = true
        gui.EnableScreenClicker(true)
        RadialMenu.Update(OpenTable)
        select_color = Color(255,255,255)
        select_text = "No selection"
    end
    function RadialMenu.Error()
        mnuerror = true showing = false 
    end
    function RadialMenu.Close()
        history = {}
        showing = false
        gui.EnableScreenClicker(false)
        mnuerror= false
    end
    
    function RadialMenu.GoBack()
        if history[#history - 1] then 
            RadialMenu.Update(history[#history  - 1],true)
            table.remove(history,#history)
        end
    end
    
    concommand.Add("+m3rad",RadialMenu.Open)
    concommand.Add("-m3rad",RadialMenu.Close)
    
    local function slopeang(a,b,aa,bb)
            local targ = (math.atan2( (bb - b) , ( aa - a) ) / 3.14) * 180
            if targ < 0 then 
                targ = targ + 360
            end
            
            return  targ
    end

    local function CENTER_OFFSET() 
        local sy,sx = input.GetCursorPos()
        return sy - ScrW()/2, sx - ScrH()/2
    end
    
    hook.Add("HUDPaint","MercuryRadial",function()
        if input.IsMouseDown(MOUSE_LEFT)==false then 
            mouse_down = false
        end
         if input.IsMouseDown(MOUSE_RIGHT)==false then 
            mouse_down_right = false
        end
        if showing then 
             swioosh = swioosh^(4/5)
            local RAD = RAD + (swioosh - 1) * 10
            local centerx, centery = ScrW() / 2, ScrH() / 2
            local radiusx = RAD 
            local radiusy = radiusx


            surface.SetDrawColor(Color(255, 255, 255, 100 ))
            for i = 0, math.pi * 2, 1 / math.max(radiusx, radiusy) do --double pi equals to a circle.
                      surface.DrawRect( centerx + math.sin(i) * radiusx, centery + math.cos(i) * radiusy, 1, 1)
            end

            surface.SetMaterial(Material("sprites/sent_ball"))
            local shadow_color = table.Copy(select_color)
            shadow_color.a = (shadow_color.a / 3) * (1 / swioosh)
            surface.SetDrawColor(shadow_color)
            surface.DrawTexturedRect( (ScrW() /2 ) - RAD  , (ScrH() / 2) - RAD , RAD * 2, RAD * 2) 
            
           // surface.DrawCircle( ScrW() /2 , ScrH() / 2, RAD , Color(0,0,0,100))
            local degrees = slopeang(0 , 0 ,CENTER_OFFSET()  ) 
            for k,v in pairs(SubMenu) do 
                local calor = Color(255,255,0)
                if v.decolor then 
                    calor = v.decolor
                end
               // print(((k-1) * slice_size) - slice_size)
                if degrees > ((k-1) * slice_size) - slice_size / 2 and degrees < ((k-1) * slice_size) + slice_size / 2 then 
                 
                        
                    calor = Color(255,0,0)
                    
                    if (not v.selected) then 
                        v.selected = true
                        surface.PlaySound("buttons/button22.wav") 
                        select_text = v.text
                        if v.decolor then 
                             select_color = v.decolor
                             else
                            select_color = Color(255,255,255)
                          
                        end
                    end
                    
                elseif (k-1)==0 and (360 - degrees) < slice_size / 2 then  // no negative angles.  have to account for first slice
                
                    calor = Color(255,0,0)    
                
                   if (not v.selected) then 
                        v.selected = true
                        surface.PlaySound("buttons/button22.wav") 
                         select_text = v.text
                           if v.decolor then 
                             select_color = v.decolor
                            else
                            select_color = Color(255,255,255)
                           end
                    end
                    
                    
                else
                    v.selected = false
                end
                if v.selected==true then
                    if input.IsMouseDown(MOUSE_LEFT) and not mouse_down then 
                        if v.onselect then 
                            v:onselect()
                            if not v.selectsound then 
                                surface.PlaySound("mercury/mercury_ok.ogg")
                            end
                        end
                        mouse_down = true
                    end
                    if input.IsMouseDown(MOUSE_RIGHT) and not mouse_down_right then 
                        if v.onselectright then
                            v:onselectright()
                            surface.PlaySound("mercury/mercury_ster_switch.ogg")
                        end
                        mouse_down_right = true
                    end
                
                end
            
                
                
                local font = "m3RAD"
                if v.font then 
                    font = v.font 
                end 

                
                //draw.TextRotated(v.text, (ScrW() / 2 ) + (math.cos( (k -1) * ((2*math.pi) / cnt) ) *RAD), (ScrH() / 2) + (math.sin( (k-1) *((2*math.pi) / cnt) ) * RAD) ,calor,"m3RAD", 0) // draw.TextRotated(v.text, (ScrW() / 2 ) + (math.cos(k)*RAD), (ScrH() / 2) + (math.sin( k ) * RAD) ,calor,"m3RAD", 0)
                draw.TextRotated(v.text, (ScrW() / 2 ) + (math.cos( (swioosh -1) + (k -1) * ((2*math.pi) / cnt) ) *RAD) + 2, (ScrH() / 2) + (math.sin( (swioosh - 1) +  (k-1) *((2*math.pi) / cnt) ) * RAD) + 2 ,Color(0,0,0,255), font  , 0) // draw.TextRotated(v.text, (ScrW() / 2 ) + (math.cos(k)*RAD), (ScrH() / 2) + (math.sin( k ) * RAD) ,calor,"m3RAD", 0)
                draw.TextRotated(v.text, (ScrW() / 2 ) + (math.cos( (swioosh - 1) +  (k -1) * ((2*math.pi) / cnt) ) *RAD), (ScrH() / 2) + (math.sin( (swioosh - 1) +  (k-1) *((2*math.pi) / cnt) ) * RAD) ,calor,font , 0) // draw.TextRotated(v.text, (ScrW() / 2 ) + (math.cos(k)*RAD), (ScrH() / 2) + (math.sin( k ) * RAD) ,calor,"m3RAD", 0)
               
            //print(CENTER_OFFSET())
        end       
        surface.SetDrawColor(Color(255,0,0))
        surface.DrawLine(ScrW() /2 , ScrH() /2 , gui.MousePos())
       // draw.TextRotated(slopeang(0 , 0 ,CENTER_OFFSET()  ), (ScrW() / 2 ) , (ScrH() / 2) + 10 ,Color(255,0,0),"ChatFont", 0)
        
        
        draw.TextRotated(select_text, (ScrW() / 2 ) + 2 , (ScrH() / 2) + 2  ,Color(1,1,1),"m3RAD_Big", 0)
        draw.TextRotated(select_text, (ScrW() / 2 ) , (ScrH() / 2)  ,select_color,"m3RAD_Big", 0)
     end   
    if mnuerror == true then
            local centerx, centery = ScrW() / 2, ScrH() / 2
            local radiusx = RAD 
            local radiusy = radiusx
            surface.SetDrawColor(Color(255, 255, 255, 100))
            for i = 0, math.pi * 2, 1 / math.max(radiusx, radiusy) do --double pi equals to a circle.
                      surface.DrawRect( centerx + math.sin(i) * radiusx, centery + math.cos(i) * radiusy, 1, 1)
            end
                if math.sin(CurTime() * 15) > 0 then 
                 draw.TextRotated("!", (ScrW() / 2 ) , (ScrH() / 2)  ,Color(255,0,0),"m3RAD_ERROR", 0)
                end
                
    end
         
    end)

    hook.Add("HUDPaint","MercuryRadialLoad",function()
    local QuickCommandsTable = {}
    
    local QuickCommandsAllowedCommands = {
        ["slay"] = true,
        ["explode"] = true,
        ["sslay"] = true,
        ["gag"] = function(object)
            local timestab = {}
            local function DoBan(self)
                             
                                surface.PlaySound("mercury/mercury_info.ogg")
                                net.Start("Mercury:Commands")
                                            net.WriteString("gag")
                                            net.WriteTable({object.player,self.data})
                                net.SendToServer()
                
            end
            timestab[1] = {text = "Session" , font = nil , radialadd = 20, data = "",decolor = nil, onselect =DoBan ,onselectright = function(self) RadialMenu.GoBack() end}
            timestab[2] = {text = "Permanent" , font = nil , radialadd = 20, data = true,decolor = nil, onselect =DoBan ,onselectright = function(self) RadialMenu.GoBack() end}
                
            surface.PlaySound("mercury/mercury_error.ogg") 
            RadialMenu.Update(timestab)
        end,
        ["ungag"] = true,
        ["mute"] = true,
        ["unmute"] = true,
        ["cleanup"] = true,
        ["kick"] = true,
        ["gold"] = true,
        ["ungold"] = true,
        ["goto"] = true,
        ["tp"] = true,
        ["bring"] = true,
        ["noclip"] = true,
        ["freezeall"] = false,
        ["freezemap"] = false,
        ["freezeallof"] = true,
        ["return"] = false,
        ["Radial Menu"] = 0,

         
        ban = function(object)
            local timestab = {}
            local function DoBan(self)
                             
                                surface.PlaySound("mercury/mercury_info.ogg")
                                net.Start("Mercury:Commands")
                                            net.WriteString("ban")
                                            net.WriteTable({object.player,self.data,"Quick ban via menu"})
                                net.SendToServer()
                
            end
            for I=1,6 do
                timestab[I] = {text = tostring(I*10) , font = nil , radialadd = 5, data = I*10,decolor = nil, onselect =DoBan ,onselectright = function(self) RadialMenu.GoBack() end}
            end
            
            timestab[7] = {text = "PERMANENT" , font = nil , radialadd = 5, data = 0,decolor = nil, onselect =DoBan ,onselectright = function(self) RadialMenu.GoBack() end}
                
            surface.PlaySound("mercury/mercury_error.ogg") 
            RadialMenu.Update(timestab)
        end,
    }

    
    local function fastPlayerSelect(data,onselect)
        local sdl2 = {}
         for k,v in pairs(player.GetAll()) do 
                            //if LocalPlayer():CanTarget(v)
                            sdl2[#sdl2 + 1] =  {text = v:Nick(),font = nil,selectsound = true,  radialadd = 2, data = v,decolor = team.GetColor(v:Team()), onselect = function(me)
                                
                                onselect( {
                                    player = me.data,
                                    command = data
                                })
                            end, onselectright = function() RadialMenu.GoBack() end}
                            
         end
        RadialMenu.Update(sdl2)
                                  
    end
    
    for k,v in SortedPairs(QuickCommandsAllowedCommands) do 
        if v==true then 
            if LocalPlayer():HasPrivilege(k) then 
            QuickCommandsTable[#QuickCommandsTable + 1] = {text = k,font = nil, radialadd = 2, data = k,decolor = nil, onselect = function(me)
                             fastPlayerSelect(me.data,function(data)
                                  surface.PlaySound("mercury/mercury_info.ogg")
                                  net.Start("Mercury:Commands")
                                            net.WriteString(me.data)
                                            print(data)
                                            PrintTable(data)
                                         net.WriteTable({data.player})
                                  net.SendToServer()
                             end)
                            
                            end, onselectright = function(self) RadialMenu.GoBack() end}
            end
        end
        
        if type(v)=="function" then 
        if LocalPlayer():HasPrivilege(k) then
            QuickCommandsTable[#QuickCommandsTable + 1] = {text = k,font = nil, radialadd = 2, data = v,decolor = nil, onselect = function(me)
                                fastPlayerSelect(me.data,function(data)  
                                    print(data.player)
                                    data.command(data)
                                end)
                                
                            end, onselectright = function(self) RadialMenu.GoBack() end}
        end
        end
        
        if v==false then
            if LocalPlayer():HasPrivilege(k) then
                  QuickCommandsTable[#QuickCommandsTable + 1] = {text = k,font = nil, radialadd = 2, selectsound = true, data = k,decolor = nil, onselect = function(me)
                            
                                  surface.PlaySound("mercury/mercury_info.ogg")
                                  net.Start("Mercury:Commands")
                                            net.WriteString(me.data)
                                  net.SendToServer()
                            
                            
                            end, onselectright = function(self) RadialMenu.GoBack() end}
            end       
        end
        
         if v==0 then
        QuickCommandsTable[#QuickCommandsTable + 1] = {text = "Radial Menu",font = nil, radialadd = 2, selectsound = true, data = k,decolor = Color(255,0,255), onselect = function(me)
             surface.PlaySound("mercury/mercury_error.ogg")             
            local DefaultTable = {}
           DefaultTable[1] =  {text = "Quick Commands", font = "m3RAD_HUGE" , radialadd = 50, data = nil,decolor = nil, onselect = function(self) RadialMenu.Update(QuickCommandsTable) end, onselectright = function(self)  RadialMenu.GoBack()  end}
            DefaultTable[2] =  {text = "Radial Settings", font = "m3RAD_HUGE", radialadd = 50, data = nil,decolor = nil, onselect = function(self) end, onselectright = function(self)  RadialMenu.GoBack()  end}
            DefaultTable[3] =  {text = "Something", font = "m3RAD_HUGE", radialadd = 50, data = nil,decolor = nil, onselect = function(self) RadialMenu.Error() end, onselectright = function(self)  RadialMenu.GoBack()  end}
            RadialMenu.Update(DefaultTable)
            end, onselectright = function(self) RadialMenu.GoBack() end}
            
        end
    end
    
    
    local DefaultTable = QuickCommandsTable

    
    
    
    
    
    RadialMenu.SetOpenTable(DefaultTable)
    hook.Remove("HUDPaint","MercuryRadialLoad")
    end)


