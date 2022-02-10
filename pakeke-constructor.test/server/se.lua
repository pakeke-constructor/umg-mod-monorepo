

local s = "qwertyuiopasdfghjklzxcvbnm"
for i=1, #s do
    local char = s:sub(i,i)
    server.on(char, function(uname, ii)
        print("keypress from " .. uname .." on button "..char .." with counter: " .. tostring(ii))
    end)
end

