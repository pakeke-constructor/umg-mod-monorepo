

local Set = require("other.set")


local sound = {}




local availableSourceClones = setmetatable({
    -- hasher of:
    --  {  [src] = set()   }
    -- to allow us to play the same sound
    -- multiple times at the same time
}, {__index = function(t,k) t[k] = Set() return t[k] end})




local function getFreeSource(src)
    if not src:isPlaying() then
        return src
    else
        local srcSet = availableSourceClones[src]
        assert(srcSet, "srcSet was nil, why? (src: " .. tostring(src) .." )")
        for _, clone in srcSet:iter() do
            if not clone:isPlaying() then
                return clone
            end
        end
        local newSrcClone = src:clone()
        availableSourceClones[src]:add(newSrcClone)
        return newSrcClone
    end
end


local function sfxVol()
    return audio.getSFXVolume() * audio.getMasterVolume()
end

local function musicVol()
    return audio.getMusicVolume() * audio.getMasterVolume()
end



local function playSound(src, vol, pitch, effect, vol_v, p_v)
    src = getFreeSource(src)
    if effect then
        src:setEffect(effect)
    end
    vol = math.min(1, vol + vol_v * math.sin(math.random() * 6.282)) * sfxVol()
    src:setVolume(vol)
    src:setPitch (pitch + p_v * math.sin(math.random() * 6.282))
    
    audio.play( src )
end





function sound.playSound(name, volume, pitch, effect, volume_variance,  pitch_variance)
    --[[
        name : string
        volume : 0 no sound   ->   1 max vol
        volume_variance : 0.2 => sound vol will vary by 0.2 (default 0)
        pitch_variance  : 0.1 => pitch will vary by 0.1     (default 0)
    ]]
    volume = volume or 1
    pitch = pitch or 1
    volume_variance = volume_variance or 0
    pitch_variance = pitch_variance or 0

    playSound(assets.sounds[name], volume, pitch, effect, volume_variance, pitch_variance)
end




local current_music = nil

local current_music_volume_modifier = 1


function sound.playMusic(name, start_time, music_volume_modifier)
    assert(assets.sounds[name], "unknown music:  "..name)
    local src = assets.sounds[name]
    
    if current_music then
        current_music:stop()
    end

    current_music_volume_modifier = music_volume_modifier or 1
    current_music = src

    src:setLooping(true)
    src:seek(start_time or 0)
    src:setVolume(musicVol())
    audio.play(src)
end


on("update", function()
    if current_music then
        current_music:setVolume(musicVol() * current_music_volume_modifier)
        if not current_music:isPlaying() then
            current_music:seek(0) -- loop music
            current_music:play()
        end
    end
end)



return sound


