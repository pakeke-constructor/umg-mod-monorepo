

local play = require("client.play")


local sound = {}



local playSoundTc = typecheck.assert("string", "number?", "number?", "string?")

function sound.playSound(name, volume, pitch, effect)
    playSoundTc(name, volume, pitch, effect)
    play.playSound(name, volume, pitch, effect)
end

function sound.playMusic(name, start_time, music_volume_modifier)
    play.playMusic(name, start_time, music_volume_modifier)
end


umg.expose("sound", sound)
