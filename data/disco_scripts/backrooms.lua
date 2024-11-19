--You found this in your hangar one day; it exerts the faintest tug on the fringes of your perception.  Ghost aren't real, but this thing might be actually haunted...

--The other part of this is that the doors map is kind of wrong.  The ship is big and empty, and some of the doors make you get lost in the void.

--When you load an event, it loads the ENTIRE event tree, so this can softlock you because it only checks on first loading the event.
--  wait what?  No it shouldnt...  fix this.

local FAVOR = 0
--Part of a mod to make a ship that drives you insane . This will sometimes make checks fail to appear . It will also sometimes make checks succeed when they should not.
--This chance is based on your reputation with _some_ faction.  General for now.

local function appendChoices(locationEvent)
    local choices = locationEvent:GetChoices()

    --lwl.dumpObject(choices[1])
    for choice in vter(choices) do
        activated = (math.random() >= .95)
        print("activated: ", activated)
        --print("printing ", choices[1])
        print("requirement: ", choice.text, choice.requirement.min_level, choice.requirement.max_level, choice.requirement.blue, choice.requirement.max_group)
        
        if (activated) then
            weal = (math.random() >= (.5 - FAVOR))
            if (weal) then
                choice.requirement.min_level = 1 --should make this not appear
            else --woe
                choice.requirement.min_level = 9
            end
        end
        print("requirement: ", choice.text, choice.requirement.min_level, choice.requirement.max_level, choice.requirement.blue, choice.requirement.max_group)
    end


script.on_internal_event(Defines.InternalEvents.PRE_CREATE_CHOICEBOX, function(locationEvent)
        --this should go in its own file for exensibility
        print("pre event ", locationEvent.eventName)
        appendChoices(locationEvent)
    end)