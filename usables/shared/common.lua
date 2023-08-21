

local common = {}



function common.getHoldItem(ent)
    if not ent.inventory then
        return nil
    end
    if not (ent.holdItemX and ent.holdItemY) then
        return nil
    end

    local ix, iy = ent.holdItemX, ent.holdItemY
    return ent.inventory:get(ix, iy)
end





return common
