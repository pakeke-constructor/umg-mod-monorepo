
local LL = require("_libs.doubly_linked_list")



local MAX_CHATHISTORY_SIZE = 300 -- After this many messages, messages begin to be deleted.

local MESSAGE_DECAY_TIME = 5 -- after X seconds, messages will start to fade.
local MESSAGE_FADE_TIME = 0.5 -- how long it takes for msgs to fade.

local CHATBOX_START_X = 2
local CHATBOX_HEIGHT = 2
local MESSAGE_SEP = 4
local CHAT_WRAP_WIDTH = 300


local chatHistory = LL.new()


local function newMessageObject(msg)
    return {
        message = msg;
        time = timer.getTime()
    }
end



client.on("chatMessage", function(msg)
    -- TODO: Do colors and stuff here.
    chatHistory:pushf(newMessageObject(msg))
    if chatHistory:count() >= MAX_CHATHISTORY_SIZE then
        chatHistory:popl()
    end
end)




local HEIGHT_TEST_CHARS = "qwertyuiopasdfghjklzxcvbnm"


local curFont = graphics.getFont()
local curFontHeight = graphics.getFont():getHeight(HEIGHT_TEST_CHARS)
local curTime = timer.getTime()
local curHeight = CHATBOX_HEIGHT
local curScreenHeight = graphics.getHeight() / base.getUIScale()



local function drawMessage(msg, opacity)
    graphics.setColor(1,1,1,opacity)
    local _, wrappedtxt = curFont:getWrap(msg, CHAT_WRAP_WIDTH)
    local newlines = #wrappedtxt
    curHeight = curHeight + (newlines * (curFontHeight)) + MESSAGE_SEP
    local y = curScreenHeight - curHeight
    graphics.printf(msg, CHATBOX_START_X, y, CHAT_WRAP_WIDTH)
end


local function iterMessage(messageObj)
    local dt = curTime - messageObj.time
    if dt > MESSAGE_DECAY_TIME then
        if dt > (MESSAGE_DECAY_TIME + MESSAGE_FADE_TIME) then
            return false -- no more messages to be drawn.
            -- break iteration.
        else
            -- this message is fading:
            drawMessage(messageObj.message, 1-(dt-MESSAGE_DECAY_TIME)/MESSAGE_FADE_TIME)
            return true -- continue iter
        end
    else -- draw message at full opacity
        drawMessage(messageObj.message, 1)
        return true -- continue iter
    end
end



on("mainDrawUI", function()
    --[[
        draw the chat:
    ]]
    curTime = timer.getTime()
    curFont = graphics.getFont()
    curFontHeight = graphics.getFont():getHeight(HEIGHT_TEST_CHARS)
    curHeight = CHATBOX_HEIGHT
    curScreenHeight = graphics.getHeight() / base.getUIScale()
    
    graphics.push("all")
    chatHistory:foreach(iterMessage)
    graphics.pop()
end)



on("keypressed", function(k)
    if k == "z" then
        client.send("chatMessage", "hello there i am sending a veryyyyy long message to test the wrapping feature")
    end
end)

