-- Par Gauthier

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

local function start()
    local handle = getobj.handle("Seq 17")
    local info = gma.show.property.get(handle, "info")

    feedback(info)
end

return start
