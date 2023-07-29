
local GRAY = {0.7,0.7,0.7}
local WHITE = {1,1,1}


local frames = {1,2,3,4,5,4,3,2,1}
for i=1, #frames do
    frames[i] = "button" .. tostring(frames[i])
end


return {
    image = "button1",

    onUpdate = function(ent)
        if client then
            if rendering.isHovered(ent) then
                ent.color = ent.hoverColor or GRAY
            else
                ent.color = ent.normalColor or WHITE
            end
        end
    end,

    onClick = function(ent, username, button)
        if button == 1 and username == ent.rgbTeam then
            if client then
                -- TODO: play sound here
                rendering.animateEntity(ent, frames, 0.15)
                if ent.onClickClient then
                    ent:onClickClient()
                end
            elseif server then
                if ent.onClickServer then
                    ent:onClickServer()
                end
            end
        end
    end,


    init = function(ent, x, y)
        base.initializers.initXY(ent,x,y)
    end
}


