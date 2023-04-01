
return {
    grid = {
        width = 64, 
        height = 64
    },

    drawDepth = -400,

    imageTiling = grids.generatePathTiling({
        isolated = "road_isolated",
        vertical = "road_vertical",
        horizontal = "road_horizontal",
        diagonal = "road_diagonal"
    }),

    init = base.initializers.initXY;
}


