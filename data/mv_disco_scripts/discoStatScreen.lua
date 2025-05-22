--[[
rectangle of stats with values for each below the image.  


This just needs a button/hotkey to dismiss this screen

Can two files depend on each other?  Probably, idk how ballatro does it otherwise.
--]]

local xPos = 0
local yPos = 0
local iconHeight = 0
local iconWidth = 0
local xSpacing = 0
local ySpacing = 0


local isActive = false

--register all particles with brightness, and flip them when active or not.

function setActive(isActive)
    isActive = isActive
end

--uh space loop or something.


script.on_render_event(Defines.RenderEvents.MOUSE_CONTROL, function(mouseControl)
        --todo render the texts.
        
        
    end,
function(mouseControl) end)