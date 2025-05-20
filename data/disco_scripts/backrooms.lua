local lwl = mods.lightweight_lua
local lwui = mods.lightweight_user_interface

--You found this in your hangar one day; it exerts the faintest tug on the fringes of your perception.  Ghost aren't real, but this thing might be actually haunted...

--The other part of this is that the doors map is kind of wrong.  The ship is big and empty, and some of the doors make you get lost in the void.

--When you load an event, it loads the ENTIRE event tree, so this can softlock you because it only checks on first loading the event.
--  wait what?  No it shouldnt...  fix this.

local STABILITY_THRESHOLD = 700
local EFFECT_DARKNESS = {noteThreshold=3}
local SPOOKY_EFFECTS = {EFFECT_DARKNESS}

local mFavor = 0 --your reputation with the backrooms
local mNotesCompleted = 0

--Part of a mod to make a ship that drives you insane . This will sometimes make checks fail to appear . It will also sometimes make checks succeed when they should not.
--This chance is based on your reputation with _some_ faction.  General for now.
--A fog that comes over your rooms and makes them unclickable.

--[[
Colored icon snippits you can find, and if you click your system rooms in the right order, it gives you a thing and unlocks a new level of madness, slenderman style.
Center of screen, large expanding vertical container with oob horiz containers rendering icons.
--]]
local function createNote(system)
    return {found=false, system=system)
end
local function createOrder(color, numbers)
    local order = {color=color}
    for _,number in numbers do
        table.insert(order, createNote(number))
    end
    return order    
end
--local noteOrder = {createNote(1), createNote(1), createNote(1), createNote(1), color=todopurple}

--A button that when you hover it shows the notes you've found

local purpleOrder = createOrder(purple, {lwl.SYS_DOORS(), lwl.SYS_SENSORS(), lwl.SYS_TELEPORTER(), lwl.SYS_OXYGEN()})
local greenOrder = createOrder(purple, {lwl.SYS_ENGINES(), lwl.SYS_BATTERY(), lwl.SYS_PILOT(), lwl.SYS_SENSORS()})
local orangeOrder = createOrder(purple, {lwl.SYS_WEAPONS(), lwl.SYS_ENGINES(), lwl.SYS_SHIELDS(), lwl.SYS_PILOT()})
local goldOrder = createOrder(purple, {lwl.SYS_DOORS(), lwl.SYS_DOORS(), lwl.SYS_DOORS(), lwl.SYS_MEDBAY()})
local orderList = {}




--I guess these are text boxes colored so I can print the icons?  Actually idk if the icons are in text or like where they are.
local function noteVisibilityFunction()
    return getNote(item.order, item.note).found --and showNotesHovered()
end


--todo make this scale with 1+ scaled note completion.
--scales from 0% at full stability to (base 10%) at 0 stability
local function shouldActivate()
    --if 700 or above, never activate.
    return math.random() >= (1 - (.1 * ((STABILITY_THRESHOLD - Hyperspace.playerVariables.stability) / STABILITY_THRESHOLD)))
end

local function getFavor()
    return (math.random() >= (.5 - mFavor))
end

--Used for preventing things from rendering 
local function forceCrash()
    local emptySet = {}
    local ohNo = emptySet[1]
end


--Makes choices appear and disappear at random
local function alterChoices(locationEvent)
    local choices = locationEvent:GetChoices()

    --lwl.dumpObject(choices[1])
    for choice in vter(choices) do
        local activated = shouldActivate()
        print("activated: ", activated)
        --print("printing ", choices[1])
        print("requirement: ", choice.text, choice.requirement.min_level, choice.requirement.max_level, choice.requirement.blue, choice.requirement.max_group)
        
        if (activated) then
            if (getFavor()) then --weal
                choice.requirement.min_level = 0
            else --woe
                choice.requirement.min_level = 9
            end
        end
        print("requirement: ", choice.text, choice.requirement.min_level, choice.requirement.max_level, choice.requirement.blue, choice.requirement.max_group)
    end
end

script.on_internal_event(Defines.InternalEvents.PRE_CREATE_CHOICEBOX, function(locationEvent)
        --this should go in its own file for exensibility
        print("pre event ", locationEvent.eventName)
        alterChoices(locationEvent)
    end)


--flickers crew names
--save all crew names
--set names to empty string
local savedCrewNames = {}

script.on_internal_event(Defines.InternalEvents.ON_TICK, function()
        
    end)





--rearranges door rooms
--remember to save the master list of doors in case of fallback

local DARKNESS = 0 --literal screen darkness
local twilight = 0 --higher is more likely to start darkness

script.on_internal_event(Defines.InternalEvents.ON_TICK, function()
        --render black rect of size SCREEN_SIZE, alpha DARKNESS
        
    end)




--slowly darken the screen over time when no mouse movement occurs.  Stock type function determines if this is can start triggering.

