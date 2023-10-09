

components.project("image", "drawable")
components.project("onDraw", "drawable")

components.project("animation", "drawable")
--[[
    technically we dont need to project `animation`, since
    animation sets .image component, and .image component is projected,
    but I feel like its cleaner to project it anyway.
]]

