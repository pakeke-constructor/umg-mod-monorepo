


return {
    grid = {
        width = 15, -- we are 16 pixels -1,
        height = 15 -- so we dont get weird leaky artefacts when scaling.
    },

    drawDepth = -400,

    imageTiling = grids.generateFloorTiling({
        isolated = "grasspatch_solo",
        fill = "grasspatch_fill",
        topleftFill = "grasspatch_topleft_fill",
        topleftEmpty = "grasspatch_topleft_empty",
        left = "grasspatch_left",
        top = "grasspatch_top",
    }),

    init = base.entityHelper.initPosition
}


