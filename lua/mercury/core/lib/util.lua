////////Mercury Utility library//////
///////Contains Misc functions required for all systems to function/////

Mercury.Util = {}
metaplayer = FindMetaTable("Player")
function metaplayer:ChatPrintMars(table)
	net.Start("Mercury:ChatPrint")
		net.WriteTable(table)
	net.Send(self)
end

function Mercury.Util.Broadcast(table)
	net.Start("Mercury:ChatPrint")
		net.WriteTable(table)
	net.Send(player.GetAll())
end
 
function Mercury.Util.SendMessage(cli,table)
	net.Start("Mercury:ChatPrint")
		net.WriteTable(table)
	net.Send(cli)
end

function Mercury.Util.StringArguments(strang)
	
    local sptab = string.Explode(" ",strang)
    local retab = {}
    local QUOTE_OPEN = false
    local justtriggered = false
    for k,v in pairs(sptab) do
    	v = string.Trim(v)
    	justtriggered = false // for open quote trigger, makes sure that the quote was not JUST opened,so this way it doesn't close on single words in quotes because prople will do that.
        if v[1]==[["]] and QUOTE_OPEN==false then QUOTE_OPEN = true retab[#retab + 1] = "" justtriggered = true end // Detected open quote, throw trigger open.
        if QUOTE_OPEN!=true then 
        	  local gax = v
              gax =  string.Trim(gax,[[ ]]) // still garbage cleaning
              gax =  string.Trim(gax,[["]]) // ^

              retab[#retab + 1] = gax

        end
        if QUOTE_OPEN==true then 
           retab[#retab] =  retab[#retab] .. " " .. v
           if v[#v]==[["]] or v[1]==[["]] and justtriggered~=true then

                QUOTE_OPEN = false
           
                retab[#retab] =  string.Trim(retab[#retab],[[ ]]) //snip off space
                retab[#retab] =  string.Trim(retab[#retab],[["]]) //snip off quots.
           end
        end
    end
    for k,v in pairs(retab) do //Trim off any excess garbage that inexplicably gets fucked into the table
    	    retab[k] =  string.Trim(retab[k],[[ ]]) 
            retab[k] =  string.Trim(retab[k],[["]])
            retab[k] =  string.Trim(retab[k],[[ ]]) 
            retab[k] =  string.Trim(retab[k],[["]])
    end
    
    return retab
end

Mercury.Util.AbstractifyText = Mercury.Util.StringArguments