



base.defineExports({
    name = "worldeditor",
    loadShared = function(worldeditor)
        -- TODO:
        -- Should defineComponent be implemented in the base mod maybe?
        worldeditor.defineComponent = defineComponent
    end,
    loadServer = function(worldeditor)
    end
})

