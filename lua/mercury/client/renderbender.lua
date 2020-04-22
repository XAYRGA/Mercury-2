if !_RB_PARTICLE_EMITTERS then 
    _RB_PARTICLE_EMITTERS = {}
end

if !_RB_PARTICLE_EMITTERS_C then 
    _RB_PARTICLE_EMITTERS_C = {}
end

local s = tostring({})
local RenderBenderLoc = string.sub(s,6)

EMETA = FindMetaTable("Entity")

if ParticleEmitterOld then 
    ParticleEmitter = ParticleEmitterOld
end
ParticleEmitterOld = ParticleEmitter


function ParticleEmitter(...)
    local pe = ParticleEmitterOld(...)
    _RB_PARTICLE_EMITTERS[#_RB_PARTICLE_EMITTERS + 1] = pe
    return pe
end

if EMETA.OldCreateParticleEffect then 
    EMETA.CreateParticleEffect = EMETA.OldCreateParticleEffect
end


EMETA.OldCreateParticleEffect = EMETA.CreateParticleEffect

function EMETA:CreateParticleEffect(...)
    local pe = self:OldCreateParticleEffect(...)
    _RB_PARTICLE_EMITTERS_C[#_RB_PARTICLE_EMITTERS_C + 1] = {particle = pe,pend = CurTime() + RENDERBENDER_CYCLE_LIMIT}
    return pe
end


if OldCreateParticleSystem  then
    CreateParticleSystem = OldCreateParticleSystem
end

OldCreateParticleSystem = CreateParticleSystem


function CreateParticleSystem(...)
    local pe = OldCreateParticleSystem(...)
    _RB_PARTICLE_EMITTERS_C[#_RB_PARTICLE_EMITTERS_C + 1] = {particle = pe,pend = CurTime() + RENDERBENDER_CYCLE_LIMIT}
    return pe
end

local on = false
local nfc = 0
local val = 0
local valc = 0
local ne = 0
RENDERBENDER_DEBUG = false
RENDERBENDER_CYCLE_LIMIT = 30

function RenderBenderDebugHud()
    if RENDERBENDER_DEBUG then 
        val = 0
        valc = 0
        for k,v in pairs(_RB_PARTICLE_EMITTERS) do 
            if IsValid(v) then 
                val = val + 1
            end 
        end 

        for k,v in pairs(_RB_PARTICLE_EMITTERS_C) do 
            if IsValid(v["particle"]) then 
                valc = valc + 1
            end 
        end 


        draw.DrawText("CLuaParticle " ..  val, "ChatFont", 1 , (ScrH() * 0.07) + 10, Color(255, 0, 0, 255),TEXT_ALIGN_LEFT)
        
        draw.DrawText("CNewParticleEffect " .. valc, "ChatFont", 1 , (ScrH() * 0.07) + 50, Color(255, 0, 0, 255),TEXT_ALIGN_LEFT)

        draw.DrawText("Queued to be removed next cycle " .. nfc, "ChatFont", 1 , (ScrH() * 0.07) + 80, Color(255, 255, 0, 255),TEXT_ALIGN_LEFT)

        draw.DrawText("Current cycle non-expired " .. ne .. " on cycle " .. FrameNumber(), "ChatFont", 1 , (ScrH() * 0.07) + 110, Color(255, 255, 0, 255),TEXT_ALIGN_LEFT)



    end
end


hook.Add("HUDPaint","DrawEntities",RenderBenderDebugHud)

// hook.Remove("HUDPaint","DrawEntities")
timer.Create("RenderProtect",1,0,function()
    nfc = 0
    ne = 0
    for k,v in pairs(_RB_PARTICLE_EMITTERS_C) do
        if IsValid(v["particle"]) and v["pend"] < (CurTime()) then
            if v["particle"]:IsFinished() then 
                v["particle"]:StopEmissionAndDestroyImmediately()
                table.remove(_RB_PARTICLE_EMITTERS_C,k)
            else 
                nfc = nfc + 1
                v["particle"]:StopEmission()
            end 
        elseif not IsValid(v["particle"]) then
            table.remove(_RB_PARTICLE_EMITTERS_C,k)
        else 
            ne = ne + 1
        end
    
    end

end)


concommand.Add("renderbender_debug_on",function()
    RENDERBENDER_DEBUG = true 
end)


concommand.Add("renderbender_debug_off",function()
    RENDERBENDER_DEBUG = false
end)

