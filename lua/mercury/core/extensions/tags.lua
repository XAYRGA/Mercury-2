local title_limit = 96
if CLIENT then 
	local namefont = "NameplatesBig"
	local sidfont = "NameplatesSteamID"
	local shrinkcal = 666
	local minshrink = 0.78


	surface.CreateFont( "NameplatesBig", {
		font = "Tehoma",
		size = 25,
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


	surface.CreateFont( "NameplatesSteamID", {
		font = "Tehoma",
		size = 21,
		weight = 400,
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


	surface.CreateFont( "NameplatesBig3D", {
		font = "Tehoma",
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


	surface.CreateFont( "NameplatesSteamID3D", {
		font = "Tehoma",
		size = 25,
		weight = 400,
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


	local rda = file.Read("tcw_nametag_cfg.txt","DATA")
	local cfg = {
	        enabled = true,
	        three_dee = false
	    
	    }
	if rda and #rda > 0 then 
	    cfg = util.JSONToTable(rda)
	end

	local function savecfg()
	    file.Write("tcw_nametag_cfg.txt",util.TableToJSON(cfg))
	end

	local function setnametags(b)
	    cfg.enabled = b
	    savecfg()
	end

	local function set3d(b)
	    cfg.three_dee = b
	    savecfg()
	end


	hook.Add( "HUDPaint", "2d rotation test", function()
	 if cfg.enabled and not cfg.three_dee then 
	    local w, h = ScrW(), ScrH()
	    local t = RealTime()*50
	    local lply = LocalPlayer()
	    surface.SetFont("NameplatesBig")
	    local nw,nh = surface.GetTextSize("H")
	    
	     
	        for k,plr in pairs(player.GetAll()) do 
	            
	            local basepos = plr:GetPos()
             if basepos!=Vector(0,0,0) then 
	            local dist = lply:GetPos():Distance(plr:GetPos())
	             
	            local textpos = (basepos + Vector(0,0,120)):ToScreen()
	            
	            local circlepos = (basepos + Vector(0,0, 72 / 2)):ToScreen()
	            
	            local scl =  math.Clamp( (shrinkcal / dist), minshrink,1   )
	            local mat = Matrix()
	            mat:Translate( Vector(textpos.x  , textpos.y ) )
	            	
	            mat:Scale( Vector( 1, 1, 1 ) * scl )
	            mat:Translate( -Vector(textpos.x  , textpos.y ))
	            
	            cam.PushModelMatrix( mat )
	            draw.DrawText( plr:Nick() , namefont ,textpos.x + 1  , textpos.y + 1, Color(1,1,1) , TEXT_ALIGN_CENTER, 0 ) 
	            draw.DrawText( plr:Nick() , namefont,textpos.x  , textpos.y, team.GetColor(plr:Team()), TEXT_ALIGN_CENTER, 0 ) 
	                
	            local col =  plr:GetNWVector("titlepcolor",Vector(255,255,255))
				draw.DrawText( plr:GetNWString("title","") , sidfont ,textpos.x + 1  , (textpos.y + ((nh) * -0.85)) + 1, Color(1,1,1) , TEXT_ALIGN_CENTER, 0 ) 
             			draw.DrawText( plr:GetNWString("title","") , sidfont,textpos.x  , textpos.y + (nh)*-0.85,Color(col.r,col.g,col.b)  , TEXT_ALIGN_CENTER, 0 )

             				            local colsfx =  plr:GetNWVector("suffixpcolor",Vector(255,255,255))
				draw.DrawText( plr:GetNWString("suffix","") , sidfont ,textpos.x + 1  , (textpos.y + ((nh) )) + 1, Color(1,1,1) , TEXT_ALIGN_CENTER, 0 ) 
             			draw.DrawText( plr:GetNWString("suffix","") , sidfont,textpos.x  , textpos.y + (nh),Color(colsfx.r,colsfx.g,colsfx.b)  , TEXT_ALIGN_CENTER, 0 )
	                
	                
	            cam.PopModelMatrix()
            end
	        end
	    end
	end )

	local function DrawName( ply )
		if cfg.enabled and cfg.three_dee then 

			for k,ply in pairs(player.GetAll()) do 
					if ply:Alive()and ply:GetPos()!=Vector(0,0,0) then 
	         
					local offset = Vector( 0, 0, 85 )
					local ang = LocalPlayer():EyeAngles()
					local pos = ply:GetPos() + offset + ang:Up()
	         
					ang:RotateAroundAxis( ang:Forward(), 90 )
					ang:RotateAroundAxis( ang:Right(), 90 )
	         
					cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
	
						draw.DrawText( ply:GetName(), "NameplatesBig3D", 2, -50, team.GetColor(ply:Team()) , TEXT_ALIGN_CENTER )
	         
					local col =  ply:GetNWVector("titlepcolor",Vector(255,255,255))
					draw.DrawText( ply:GetNWString("title","") , "NameplatesSteamID3D", 2, 2, Color(col.r,col.g,col.b) , TEXT_ALIGN_CENTER )
					cam.End3D2D()
    end
			end
		end
	end
	hook.Add( "PostDrawTranslucentRenderables", "DrawName", DrawName )

	concommand.Add("nametags_three_dee",function()
	 set3d(  not cfg.three_dee)
	end)

	concommand.Add("nametags_toggle",function()
	    setnametags( not cfg.enabled )
	end)

else
	
	if not file.IsDir( "titles", "DATA" ) then
		file.CreateDir("titles")
	end
	
	local function savetitle(P,T)
		local FileName = "titles/" .. P:UniqueID() .. ".txt"
		file.Write(FileName,util.TableToJSON(T))
	end


	local function savesuffix(P,T)
		local FileName = "suffixes/" .. P:UniqueID() .. ".txt"
		file.Write(FileName,util.TableToJSON(T))
	end

	hook.Add("PlayerSay","TitleFUCK!!!",function(P,T)
		local exp = string.Explode(" ",T)
		if exp[1]=="!title" then 
			local col = exp[2]

			if !col then 
				P:ChatPrint("Format is !title R,G,B text")
				return T
			end

			if !exp[3] then 
				P:ChatPrint("Format is !title R,G,B text")
				return T
			end

			local tstr = ""
			tstr = table.concat(exp," ",3)

			if #tstr > title_limit then 
				P:ChatPrint("Length limit is " .. title_limit .. " characters.")
				return T
			end

			local REAL_COLOR = Vector(unpack(string.Explode(",",col)))

			local svtab  = {
				title = tstr ,
				color = REAL_COLOR
			}

			P:SetNWVector("titlepcolor",REAL_COLOR)
			P:SetNWString("title",tstr)
			savetitle(P,svtab)
		end

		if exp[1]=="!suffix" then 
			local col = exp[2]

			if !col then 
				P:ChatPrint("Format is !suffix R,G,B text")
				return T
			end

			if !exp[3] then 
				P:ChatPrint("Format is !suffix R,G,B text")
				return T
			end

			local tstr = ""
			tstr = table.concat(exp," ",3)

			if #tstr > title_limit then 
				P:ChatPrint("Length limit is " .. title_limit .. " characters.")
				return T
			end

			local REAL_COLOR = Vector(unpack(string.Explode(",",col)))

			local svtab  = {
				title = tstr ,
				color = REAL_COLOR
			}

			P:SetNWVector("suffixpcolor",REAL_COLOR)
			P:SetNWString("suffix",tstr)
			savesuffix(P,svtab)
		end
	end)

	hook.Add("PlayerSpawn","LoadTitle",function(P)
		local FileName = "titles/" .. P:UniqueID() .. ".txt"
		
		if file.Exists( FileName, "DATA" ) then
		local titleData = util.JSONToTable( file.Read( FileName, "DATA" ) )

			
			P:SetNWVector("titlepcolor",titleData.color)
			P:SetNWString("title",titleData.title)

		end


		local FileName = "suffixes/" .. P:UniqueID() .. ".txt"
		
		if file.Exists( FileName, "DATA" ) then
		local titleData = util.JSONToTable( file.Read( FileName, "DATA" ) )

			
			P:SetNWVector("suffixpcolor",titleData.color)
			P:SetNWString("suffix",titleData.title)

		end





	end)

end
