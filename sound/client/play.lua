

local play = {}



local availableSourceClones = setmetatable({
    -- hasher of:
    --  {  [src] = set()   }
    -- to allow us to play the same sound
    -- multiple times at the same time
}, {__index = function(t,k) t[k] = objects.Set() return t[k] end})




local function getFreeSource(src)
    if not src:isPlaying() then
        return src
    else
        local srcSet = availableSourceClones[src]
        assert(srcSet, "srcSet was nil, why? (src: " .. tostring(src) .." )")
        for _, clone in ipairs(srcSet) do
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
    return client.getSFXVolume() * client.getMasterVolume()
end

local function musicVol()
    return client.getMusicVolume() * client.getMasterVolume()
end


local function useEffects()
    return love.audio.isEffectsSupported()
end



local function playSound(src, vol, pitch, effect)
    src = getFreeSource(src)
    if effect and useEffects() then
        src:setEffect(effect)
    end
    vol = math.min(1, vol) * sfxVol()
    src:setVolume(vol)
    src:setPitch(pitch)
    
    love.audio.play( src )
end





function play.playSound(name, volume, pitch, effect)
    --[[
        name : string
        volume : 0 no sound   ->   1 max vol
        pitch : number
        effect : string
    ]]
    volume = volume or 1
    pitch = pitch or 1

    playSound(client.assets.sounds[name], volume, pitch, effect)
end




local current_music = nil

local current_music_volume_modifier = 1


function play.playMusic(name, start_time, music_volume_modifier)
    assert(client.assets.sounds[name], "unknown music:  "..name)
    local src = client.assets.sounds[name]
    
    if current_music then
        current_music:stop()
    end

    current_music_volume_modifier = music_volume_modifier or 1
    current_music = src

    src:setLooping(true)
    src:seek(start_time or 0)
    src:setVolume(musicVol())
    love.audio.play(src)
end


umg.on("@update", function()
    if current_music then
        current_music:setVolume(musicVol() * current_music_volume_modifier)
        if not current_music:isPlaying() then
            current_music:seek(0) -- loop music
            current_music:play()
        end
    end
end)



return play

