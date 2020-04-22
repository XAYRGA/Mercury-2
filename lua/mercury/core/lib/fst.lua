
print("FastFast loaded.")

local fst_struct = {}
fst = {}
local function out( myfst, ... )
    if fst.debug then 
        MsgC(Color(200,150,200),"[fst2] ")
        MsgN( tostring(myfst), ... )
    end
end

local function address_of(obj)
    local asd = string.Explode(":",tostring(obj))
    return asd[2]
end


fst_struct.ftable = {}
fst_struct.h_end = 0
fst_struct.file_obj = nil
fst_struct.compressed = false 

function fst_struct:ReadFile(idx)
    local ft = self.ftable
    //local ft_addr = address_of(ft)
    //out(self, " check ftab ",ft_addr)
    local fo = self.file_object
    //out(self, " check fobj ",address_of(fo))
    if !ft[idx] then 
        out(self,idx," doesn't exist.")
        return false,"File doesn't exist."
    end
    local info = ft[idx]
   // local ifo_addr = address_of(info)
    // out(self," got file node at ",ifo_addr)
    fo:Seek(self.h_end +  info.offset)
  
    local content = fo:Read(info.size)

    if self.compressed then 
        content = util.Decompress(content)
    end
    out(self," Read ",idx," ", string.format("0x%X - 0x%X",info.offset + self.h_end,info.size))
    return true,content    
end

function fst_struct:GetFileTable()
    local adl = {}
    for k,v in pairs(self.ftable) do 
        adl[#adl + 1] = k 

    end 
    return adl 
end

function fst_struct:Close()
    self.file_obj:Close()
    self.file_obj = nil
    self.ftable = {}
    self = nil
    return true
end


function fst.OpenFST(fst,compressed)
    local fstfile = file.Open(fst,"rb","DATA")
    assert(not !fstfile,"Could not open file.")
    assert(fstfile:Read(3)=="FST","File does not have FST header.")
    local header_length = fstfile:ReadLong() //  + 0x004
    local file_entries = fstfile:ReadLong() // + 0x004
    local FET = {}
    
    for i=1,file_entries do 
        local name_len = fstfile:ReadShort() // 0x002 READ NFNAME MAX 0xFF
        local name = fstfile:Read(name_len) // 0xNAMELEN MAX 0xFF
        local node_size = fstfile:ReadLong() // 0x004 FILENODE DATALEN 
        local node_location = fstfile:ReadLong() // 0x004 NODE OFFSET FROM header_len
        
        FET[name] = {size = node_size, offset = node_location}
    end
    
    
    local ret = {}
    local bxl = table.Copy(fst_struct)
    bxl.compressed = compressed
    bxl.file_object = fstfile
    bxl.h_end = header_length + 7 // + 0x007
    bxl.ftable = FET
    setmetatable(ret,{__index = bxl,__tostring = function()
        return "LuaFSTObject [" ..  fst .. "]" // TOSTRING OBJ 
    end})
    return ret
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
            print(addit)
        end
    end
    file.Write(pth,cnt)
end

