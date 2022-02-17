

--[[

Monkeypatch graphics library

]]


function graphics.emit(psys, ...)

end


function graphics.animate(frames, ...)

end


function graphics.shockwave()

end


graphics.camera = require(path .. ".camera")


local function unhide(e)
    e.hidden = false
end


function graphics.hide(ent, n)
    ent.hidden = true
    if n then
        await(unhide, n)
    else

    end
end

