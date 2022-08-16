
local LinkedList = require("_libs.doubly_linked_list")



local MAX_CHATHISTORY_SIZE = 300 -- After this many messages, messages begin to be deleted.

local MESSAGE_DECAY_TIME = 5 -- after X seconds, messages will start to fade.
local MESSAGE_FADE_TIME = 0.5 -- how long it takes for msgs to fade.

local CHATBOX_START_X = 2
local CHATBOX_HEIGHT = 2
local MESSAGE_SEP = 10
local CHAT_WRAP_WIDTH = 300

local TARGET_CHAT_HEIGHT = 6 -- This number is actually quite arbitrary


local chatHistory = LinkedList.new()


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




local HEIGHT_TEST_CHARS = "abc"


local curFont = graphics.getFont()
local curFontHeight = graphics.getFont():getHeight(HEIGHT_TEST_CHARS)
local curTime = timer.getTime()
local curHeight = CHATBOX_HEIGHT
local curScreenHeight = graphics.getHeight() / base.getUIScale()
local curChatScale = TARGET_CHAT_HEIGHT / curFontHeight

local currMessage = ""


local function drawMessage(msg, opacity)
    -- TODO: Do different colors here.
    graphics.setColor(1,1,1,opacity)
    local scale = curChatScale
    local wrapWidth = CHAT_WRAP_WIDTH / scale
    local _, wrappedtxt = curFont:getWrap(msg, wrapWidth)
    local newlines = #wrappedtxt
    curHeight = curHeight + ((newlines * (curFontHeight)) + MESSAGE_SEP) * scale
    local y = curScreenHeight - curHeight
    graphics.printf(msg, CHATBOX_START_X, y, wrapWidth, "left", 0, scale,scale)
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
    curChatScale = TARGET_CHAT_HEIGHT / curFontHeight

    graphics.push("all")
    if #currMessage > 0 then
        drawMessage(currMessage, 1)
    end

    chatHistory:foreach(iterMessage)
    graphics.pop()
end)



local isTyping = false



keyboard.setKeyRepeat(true)


on("textinput", function(t)
    if isTyping then
        currMessage = currMessage .. t
    end
end)


on("keypressed", function(k)
    --[[
        TODO: Set keyboard blocking here!!!!
    ]]
    if k=="backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(currMessage, -1)
        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            currMessage = string.sub(currMessage, 1, byteoffset - 1)
        end
    elseif k == "return" then
        if isTyping then
            if #currMessage>0 then
                client.send("chatMessage", currMessage)
                currMessage = ''
            end
        end
        isTyping = not isTyping
    elseif k == "escape" then
        isTyping = false
    end
end)

