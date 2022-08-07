


return {
    MOVE_TYPE_LIST = {
        "circle", --     will circle around target entity
        "follow", -- moves directly towards target entity
        "flee", -- moves directly away from target entity
        "kite", --   trys to stay a fixed distance from target entity
        "random", -- moves in a random direction. Stops for X seconds, then repeats.
        "randomFollow", -- moves in a random direction near target entity. Stops for X seconds, then repeats.
        "none" --   no movement
    };

    MOVE_TYPES = {
        circle = true;
        
        follow = true;
        flee = true;
        
        kite = true;

        random = true;
        
        randomFollow = true;
        none = true;
    };
}
