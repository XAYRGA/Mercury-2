local function debug(...)
    MsgC(Mercury.Config.Colors.Default,"[HG] ")
    MsgN(...)
end

local function searchFileRecursive(dirb)
    local files = {}
    local function getFiles(dir)
        local fil,directories = file.Find( dir.."/*", "DATA" )
        for _, fdir in pairs(directories) do
                getFiles(dir.."/"..fdir)
        end
        
        for k,v in pairs(fil) do
            files[#files + 1] = dir.."/"..v
        end
    end 
    getFiles(dirb)
    --PrintTable(files)
    return files
end


local function backupVFS(folder,outfile) 
    debug("Scanning VFS...")
    local files = searchFileRecursive(folder)
    debug("VFS Has " .. #files .. " entries");
    debug(" - > COMPACT VFS")

    local fco = 0
    local fhnd = file.Open(outfile,"wb","DATA");
    fhnd:WriteLong(#files)
    local fileCount = #files
    local b = coroutine.create(function(a)
        local s,e = pcall(function () 
            for k,v in pairs(files) do 

                local compressedName = util.Compress(v)
                fhnd:WriteByte(#compressedName)
                fhnd:Write(compressedName) 
            
                local b = file.Read(v,"DATA")

                fhnd:WriteLong(#b)
                local fileCompressed = util.Compress(b) 
                fhnd:WriteLong(#fileCompressed)
                fhnd:Write(fileCompressed)          
         
         
                fco = fco + 1
                if (fco==200) then 
                    fhnd:Flush()
                    fco = 0 
                    debug("compacting " .. v .. " (" .. k .. "/" .. fileCount .. ")"  )    
                    timer.Simple(0.05,function()
                        coroutine.resume(a,a)
                    end)
                    coroutine.yield(a)
                end 
            end     
        end)
        print(s,e)
        fhnd:Flush()
        fhnd:Close()
    end)
    coroutine.resume(b,b)
end 


local function wpath(pth,cnt)
    local dir = string.Explode("/",pth)
    local fname = dir[#dir]
    table.remove(dir,#dir)
    if #dir[1] < 2 then 
        table.remove(dir,1)
    end    
    
    local addit = ""
    for k,v in pairs(dir) do
        addit = addit .. v .. "/"
        if !file.Exists(addit,"DATA") then 
            file.CreateDir(addit)
          
        end
    end
    --mc.writeLine("Write " .. pth)
    file.Write(pth,cnt)
end


local function unpackVFS(fil,folder) 
    if (!file.Exists(fil,"DATA")) then 
        return false,"File doesn't exist: " .. fil
    end  
    print(fil)
    local fhnd = file.Open(fil,"rb","DATA");
    local fileCount = fhnd:ReadLong()
    local fco = 0
    local b = coroutine.create(function(a)
        local s,e = pcall(function () 
            for i=1, fileCount do 
                local cnanmesize = fhnd:ReadByte()
                local cname = util.Decompress(fhnd:Read(cnanmesize))

                local uncompressedSize = fhnd:ReadLong();
                local compressedSize = fhnd:ReadLong()
                local data = fhnd:Read(compressedSize)
                local final_data = util.Decompress(data)
                --print(cname)
                wpath(cname,final_data)

                fco = fco + 1
                if (fco==200) then 
                    fhnd:Flush()
                    fco = 0 
                    debug("decompacting" .. v .. " (" .. k .. "/" .. fileCount .. ")"  )    
                    timer.Simple(0.05,function()
                        coroutine.resume(a,a)
                    end)
                    coroutine.yield(a)
                end 
            end     
        end)
        print(s,e)
        fhnd:Flush()
        fhnd:Close()
    end)
    coroutine.resume(b,b)
end 



MCMD = {
    ["Command"] = "vfst",
    ["Verb"] = "vfst",
    ["RconUse"] = true,
    ["Useage"] = "vfst",
    ["UseImmunity"] =  false,
    ["HasMenu"] = true,
    ["Category"] = "System",
    ["UseCustomPrivCheck"] = false,
    ["PlayerTarget"] = false,
    ["AllowWildcard"] = false
}

local function callfunc(caller, args)
    if (IsValid(caller)) then 
        return false, "Only RCON can use this command"
    end
    if args[1]=="pack" then 
        backupVFS(args[2], args[3])        
    elseif args[1]=="unpack" then 
        unpackVFS(args[2], args[3])        
    end 
    return false," "
end

Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)