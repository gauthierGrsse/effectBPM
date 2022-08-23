-- Par Gauthier GUERISSE
-- Beta 1.0
-- Variable :
local speedMaster = 1
local haveSystemMonitorFeedback = false

local handle
local cueNbr
local info

-- Shortcut
local cmd = gma.cmd
local setvar = gma.show.setvar
local getvar = gma.show.getvar
local sleep = gma.sleep
local confirm = gma.gui.confirm
local msgbox = gma.gui.msgbox
local textinput = gma.textinput
local progress = gma.gui.progress
local getobj = gma.show.getobj
local property = gma.show.property

local function feedback(text)
    gma.feedback("Plugin trackshow : " .. text)
end

local function echo(text)
    gma.echo("Plugin trackshow : " .. text)
end

local function error(text)
    gma.gui.msgbox("Plugin trackshow ERREUR", text)
    feedback("Trackshow plugin ERROR : " .. text)
end

-- modify tracking for sequence of selected exec
-- show sequence number in command line feedback
-- create a variable $numerodesequence you can use for something else
--
-- created par Glad, modified par Bentoylight with help from Cédric

local selectedSequence = function()
    local seq
    local get = gma.show.getobj
    local h = get.handle('Cue') ------ 'cue' is current active cue on selected exec
    if h and get.class(h) == 'CMD_CUE' then
        seq = get.parent(h)
        num = get.number(seq)
        gma.show.setvar("numerodesequence", num)
        return num
    end

    return false
end

local function haveCueBpmInfo(cue)
    local handle = getobj.handle("Sequence " .. selectedSequence())

    local info = property.get(getobj.child(getobj.child(handle, cue), 0), "info")

    if string.find(info, 'bpm="') then
        return true
    end
    return false
end

local function bpmInfo(cue)
    local handle = getobj.handle("Sequence " .. selectedSequence())
    local info = property.get(getobj.child(getobj.child(handle, cue), 0), "info")

    local temp = string.sub(info, string.find(info, 'bpm="') + 5)
    return string.sub(temp, 0, string.find(temp, '"') - 1)
end

local function start()
    while true do
        local cue = tonumber(getvar("selectedexeccue"))
        while (not haveCueBpmInfo(cue)) and cue > 0 do
            cue = cue - 1
            if haveSystemMonitorFeedback then
                feedback('Research in cue ' .. cue)
            end
        end
        if cue == 0 then
            -- pas de bpm dans la seq
        else
            cmd('Assign SpecialMaster 3.1 At '.. bpmInfo(cue))
            if haveSystemMonitorFeedback then
                feedback('BPM Set')
            end
        end

        sleep(1)
    end
end

return start
