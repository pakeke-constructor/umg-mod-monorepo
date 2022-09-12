
local Board = require("server.board")



local matchmaking = {}



local teams


function matchmaking.startGame()
    teams = {}
    for rgbTeam, _ in Board.iterBoards() do
        table.insert(teams, rgbTeam)
    end
end





function matchmaking.isPVE(turn)
    local mod = turn % 3
    return mod ~= 0
end





function matchmaking.makeMatches()
    --[[
        match = {
            board = Board(),
            home = rgbTeam1,
            away = rgbTeam2
        }

        or, if there's a bye:

        match = {board = Board(), bye = true}
    ]]
    local len = #teams 
    
    local matchMakeBuffer = {}

    local teamMatched = {} -- [rgbTeam] -> true/false if been matched or not
    local teamsCopy = {}
    for _, rgbTeam in ipairs(teams)do
        table.insert(teamsCopy, rgbTeam)
    end
    table.shuffle(teamsCopy)

    for i=1, len-1, 2 do
        local t1 = teamsCopy[i]
        local t2 = teamsCopy[2]
        if t1 and t2 then
            teamMatched[t1]=true
            teamMatched[t2]=true
            local match = {
                board = Board.getBoard(t1),
                home = t1,
                away = t2,
            }
            table.insert(matchMakeBuffer, match)
        end
    end

    for _, team in ipairs(teams)do
        if not teamMatched[team] then
            -- if the team hasn't been matched, then its a bye.
            table.insert(matchMakeBuffer, {
                board = Board.getBoard(team),
                bye = true
            })
        end
    end

    return matchMakeBuffer
end



return matchmaking
