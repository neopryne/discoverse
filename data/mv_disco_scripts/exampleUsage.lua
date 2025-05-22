--[[
An example of how to register events with the DiscoVerse engine.
Follow the instructions in xmlEventGeneration.lua.
]]
local mde = mods.multiverseDiscoEngine

--You should make sure the event names you use for active checks are unique to your mod to avoid conflicts.
local function appendEvents()
    local eventList = {}
    --EVENT CODE HERE V
    
    -- --[[EXAMPLE CODE
    local event1 = mde.buildEvent("TEST_HYPERSPACE_QUEST")
    table.insert(event1, mde.buildPassiveCheck("volition", 10, "mde_passive_1", "yuhp"))
    table.insert(event1, mde.buildActiveCheck("reaction_speed", 9, "mde_active_1", "Try yor lukk",
            "MDE_TEST_REACTION_SUCCESS", "MDE_TEST_REACTION_FAILURE"))
    table.insert(eventList, event1)--]]
    
    --EVENT CODE HERE ^
    mde.registerEventList(eventList)
end
appendEvents()