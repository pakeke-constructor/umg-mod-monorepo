
return {
    DEFAULT_FRICTION = 6;
    FRICTION_CONSTANT = 1.9;

    DEFAULT_SPEED = 200;

    DEFAULT_ZOOM = 3;
    SCREEN_LEIGHWAY = 400; -- used by graphics.isOnScreen

    DEFAULT_UI_SCALE = 3;

    MAX_DT = 0.16,
    MIN_DT = -0.16,
    
    SYNC_LEIGHWAY = 0.5; -- Can be 0.5 position of a difference before 
                         -- an update is passed.
    
    PLAYER_MOVE_LEIGHWAY = 0.3 -- percentage player move leighway.
    -- This essentially means that some players can "cheat", and move
    -- faster.  However it also means that legitimate players won't get lagged back
}


