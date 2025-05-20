local mde = {} --API stub to make the code copying work
local MAX_GROUP_START

--Don't mess with this stuff, see the bottom of the script.
--You should make sure the event names used for active checks are unique to your mod, as usual with events.
--This script assumes you are appending choices to an existing event.  If you're making a new event, make that first and then add disco choices with this.
--This is 
local EVENT_STRING = [[
<mod:findName type="event" name="%s">
%s
</mod:findName>
]]

local PASSIVE_CHECK_STRING = [[
	<!--Passive Check-->
	<mod-append:choice req="pilot" lvl="1" max_group="%d" blue="false" hidden="true">
		<text>%s</text>
		<event>
			--Fill out the event with your desired effect
		</event>
	</mod-append:choice>
]]

local ACTIVE_CHECK_STRING = [[
	<!--Active Check-->
	<mod-append:choice req="pilot" lvl="1" max_group="%d" blue="true" hidden="true">
		<text>%s</text>
		<event name="%s">
			--Fill out the event with your desired effect
		</event>
	</mod-append:choice>
	<mod-append:choice req="pilot" lvl="1" max_group="%d" blue="false" hidden="true">
		<text>%s</text>
		<event name="%s">
			--Fill out the event with your desired effect
		</event>
	</mod-append:choice>
]]

local function passiveCheckFormat(maxGroup, choiceText)
    return string.format(PASSIVE_CHECK_STRING, maxGroup, choiceText)
end

local function activeCheckFormat(maxGroup, choiceText, successEventName, failureEventName)
    return string.format(ACTIVE_CHECK_STRING, maxGroup, choiceText, successEventName, maxGroup + 1, choiceText, failureEventName)
end

--Put this into the append file with the same name as the event you're modifying.
local function buildXmlEvent(event)
    local maxGroup = MAX_GROUP_START
    local checkList = ""
    for i = 1,#event do
        local check = event[i]
        if (check.passive) then
            checkList = checkList..passiveCheckFormat(maxGroup, check.placeholderChoiceText)
            maxGroup = maxGroup + 1
        else
            checkList = checkList..activeCheckFormat(maxGroup, check.placeholderChoiceText, check.successEventName, check.failureEventName)
            maxGroup = maxGroup + 2
        end
    end
    return string.format(EVENT_STRING, event.name, checkList)
end

local function generateXml(eventList)
    local output = ""
    for i =1,#eventList do
        output = output..buildXmlEvent(eventList[i])
    end
    return output
end

--These are copies of the DiscoVerseEngine versions, as this file can not have dependencies.
function mde.buildEvent(eventName)
    return {name=eventName}
end

function mde.buildPassiveCheck(skill, difficultyValue, placeholderChoiceText, replacementChoiceText)
    return {placeholderChoiceText=placeholderChoiceText, passive=true, skill=skill, value=difficultyValue, replacementChoiceText=replacementChoiceText}
end

function mde.buildActiveCheck(skill, difficultyValue, initialChoiceText, replacementChoiceText, successEventName, failureEventName)
    return {passive=false, skill=skill, value=difficultyValue, placeholderChoiceText=initialChoiceText, replacementChoiceText=replacementChoiceText, successEventName=successEventName, failureEventName=failureEventName}
end

------------DOWN HERE---------------------
--All appends for a given event must have different max_groups.  FM is 620-ish, I claim 640-649.-->
--!!! replace this value !!!
MAX_GROUP_START = 210

--[[
Put the events you want to change here, run this file to print the complete XML,
 and then paste each event into the .extend file corresponding to the file where the original event exists.
This will modify the chosen event, adding in your new raw DiscoVerse choices.
You then need to also tell the DiscoVerse engine about these events as seen in exampleUsage.lua.
If you have followed these instructions, you should be able to do this by cloning exampleUsage.lua into your project,
    and then copying the code in the EVENT CODE HERE section of functionBody into the same section of appendEvents().
You can then test your events with \EVENT [EVENT_NAME] in the FTL console.
]]
local function functionBody()
    local eventList = {}
    --EVENT CODE HERE V
    
    -- --[[EXAMPLE CODE
    local event1 = mde.buildEvent("TEST_HYPERSPACE_QUEST")
    table.insert(event1, mde.buildPassiveCheck("volition", 10, "mde_passive_1", "yuhp"))
    table.insert(event1, mde.buildActiveCheck("reaction_speed", 9, "mde_active_1", "Try yor lukk",
            "MDE_TEST_REACTION_SUCCES", "MDE_TEST_REACTION_FAILURE"))
    table.insert(eventList, event1)--]]
    
    --EVENT CODE HERE ^
    print(generateXml(eventList))
end
functionBody()