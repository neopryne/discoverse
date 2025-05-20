--The events need to be defined in XML, which isn't ideal, but it works.
--Active checks need two xml events, one will be disabled based on the check result.  Blue value indicates if it is for a success or not.
--max_group must be different for each option for an event.  I'm using the 640 block, forgemaster uses 620-ish, pick something for yourself if you're using this.
--Every check is a red check here (can't be retried).

--[[
    See example usage file
--]]
mods.multiverseDiscoEngine = {}
local mde = mods.multiverseDiscoEngine

local vter = mods.multiverse.vter
local lwl = mods.lightweight_lua
local lwui = mods.lightweight_user_interface
local Brightness = mods.brightness
local dvsd = mods.discoVerseStaticDefinitions

local LOG_LEVEL = 3
local LOG_TAG = "mods.disco.core"

local DEFAULT_STARTING_POWER = 7
local DEFAULT_POWER_CAP = 25
local STARTING_ATTRIBUTE_VAULE = 3
local ATTRIBUTE_VAULE_SOFT_CAP = 7

local mQueuedCheckAVList = {} --Earcons pending check results
local mDiscoEventsList = {} --Registered events
local mCurrentCard

--[[
The goal of this is to create a system which can be used to inhect disco elysium-style checks/options into events.
Stretch goal: have each ship get a unique pilot buff set.  That's insane, but works in theory at least.

we're about to get colored text, too.

Something's negative sometimes, probably with my random number generation?   Like the room center?


Actually, this must be split into two parts.  The Multiverse Disco Engine, which goes at the very top as a library,
 and the Disco Content Packs, which go at the very end of your mod list, or at least below the mods with the events they're supposed to modify.

General mod order:
Multiverse
Libraries
Content
Meta content
QoL / Graphics
'Patch Last' mods
--]]

local function calculate_probabilities(num_dice, sides)
    if num_dice == 0 then
        return {[0] = 1}  -- Base case: only one outcome with a sum of 0
    end
    -- Get probabilities for one less die
    local prev_probs = calculate_probabilities(num_dice - 1, sides)
    local new_probs = {}
    -- Compute probabilities for the current number of dice
    for sum, prob in pairs(prev_probs) do
        for roll = 1, sides do
            local new_sum = sum + roll
            new_probs[new_sum] = (new_probs[new_sum] or 0) + prob / sides
        end
    end
    return new_probs
end

-- Function to calculate the probability of exceeding a target sum
local function probability_greater_than(num_dice, sides, target)
    local probs = calculate_probabilities(num_dice, sides)
    local total_prob = 0
    for sum, prob in pairs(probs) do
        if sum > target then
            total_prob = total_prob + prob
        end
    end
    return math.ceil(total_prob * 100)
end

local function skillFromName(skillName)
    local traitDef = dvsd.TRAIT_DEFINITIONS[skillName]
    if (traitDef == nil) then
        error("Disco Engine: Invalid skill "..skillName)
    end
    local skilDef = traitDef.definition
    return skilDef
end

--After you add an event, you can test it with \EVENT [EVENTNAME]

--what if two things modify the same event?
--That is to say, multiple checks on the same event?
--I mean, you should really be updating this mod if you're doing that, this mod should be near the bottom of the mod list.
--Define a function to use to modify the event, and the data to pass to it.
--key is the name of the event.
--the rest of this depends on the structure of events we get in the loop.
--everything for an option needs to be in its check table.  Each check table should be self sufficient.

--starting reactor = 7, 3, ending reactor = 25, 7. 18 run, 4 rise

function mde.getAutoShipStat(statName)
    local ownship = Hyperspace.ships.player
    local shipGraph = Hyperspace.ShipGraph.GetShipInfo(0)
    local pointf = ownship:GetRandomRoomCenter() --if some rooms have better stats, cool.
    local point = Hyperspace.Point(pointf.x, pointf.y)
    local slot = shipGraph:GetClosestSlot(point, 0, false)
    local room = ownship.ship.vRoomList[slot.roomId]--For damage resist values
    local baseStat = ((Hyperspace.PowerManager.GetPowerManager(0):GetMaxPower() - DEFAULT_STARTING_POWER) * (ATTRIBUTE_VAULE_SOFT_CAP - STARTING_ATTRIBUTE_VAULE) / (DEFAULT_POWER_CAP - DEFAULT_STARTING_POWER)) + STARTING_ATTRIBUTE_VAULE
    if (statName == dvsd.s_logic.internalName) then
        baseStat = baseStat + 2
    elseif (statName == dvsd.s_encylopedia.internalName) then
        baseStat = baseStat + 1.5
    elseif (statName == dvsd.s_rhetoric.internalName) then
        --n/a
    elseif (statName == dvsd.s_drama.internalName) then
        --n/a
    elseif (statName == dvsd.s_conceptualization.internalName) then
        --n/a
    elseif (statName == dvsd.s_visual_calculus.internalName) then
        baseStat = baseStat + ((ownship:GetSystemPowerMax(lwl.SYS_PILOT()) + ownship:GetSystemPowerMax(lwl.SYS_SENSORS())) / 2)
    elseif (statName == dvsd.s_volition.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_BATTERY())
    elseif (statName == dvsd.s_inland_empire.internalName) then
        baseStat = baseStat + ((500 - Hyperspace.playerVariables.stability) / 100)
    elseif (statName == dvsd.s_empathy.internalName) then
        baseStat = baseStat - 2 + ownship:GetSystemPowerMax(lwl.SYS_OXYGEN())
    elseif (statName == dvsd.s_authority.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_DOORS())
    elseif (statName == dvsd.s_espirit_de_corps.internalName) then
        baseStat = baseStat - Hyperspace.playerVariables.rep_general --Reputaiton is negative
    elseif (statName == dvsd.s_suggestion.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_MIND())
    elseif (statName == dvsd.s_endurance.internalName) then
        baseStat = baseStat + (room.extend.hullDamageResistChance / 10)
    elseif (statName == dvsd.s_pain_threshold.internalName) then
        baseStat = baseStat + (room.extend.sysDamageResistChance / 10)
    elseif (statName == dvsd.s_physical_instrument.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_DRONES())
    elseif (statName == dvsd.s_electrochemistry.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_MIND()) + ownship:GetSystemPowerMax(lwl.SYS_TEMPORAL()) + ownship:GetSystemPowerMax(lwl.SYS_HACKING())
    elseif (statName == dvsd.s_shivers.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_SENSORS())
    elseif (statName == dvsd.s_half_light.internalName) then
        baseStat = baseStat + ((ownship:GetSystemPowerMax(lwl.SYS_WEAPONS()) + ownship:GetSystemPowerMax(lwl.SYS_DRONES())) / 3)
    elseif (statName == dvsd.s_hand_eye_coordination.internalName) then
        baseStat = baseStat + (ownship:GetDodgeFactor() / 15) --45 evade for 3 bonus
    elseif (statName == dvsd.s_perception.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_SENSORS())
    elseif (statName == dvsd.s_reaction_speed.internalName) then
        baseStat = baseStat + ((ownship:GetSystemPowerMax(lwl.SYS_PILOT()) + ownship:GetSystemPowerMax(lwl.SYS_ENGINES())) / 3)
    elseif (statName == dvsd.s_savoir_faire.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_CLOAKING()) + ownship:GetSystemPowerMax(lwl.SYS_PILOT())
    elseif (statName == dvsd.s_interfacing.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_HACKING())
    elseif (statName == dvsd.s_composure.internalName) then --ion resist chance
        baseStat = baseStat + (room.extend.ionDamageResistChance / 10)
    else
        if (statName == nil) then statName = "nil" end
        lwl.logError(LOG_TAG, "Invalid stat "..statName, LOG_LEVEL)
    end
    --lwl.logDebug(LOG_TAG, "autostat "..statName.." was "..baseStat, LOG_LEVEL)
    return baseStat
end

--todo maybe return deep copy instead?
local function safeLoadCrewStats(species)
    local crewStats = dvsd.CREW_STAT_TABLE[species]
    if (crewStats == nil) then
        --make something up, can change this
        crewStats = HUMAN
    end
    return crewStats
end

local function skillBonus(crewmem, skillId)
    return crewmem:GetSkillLevel(skillId) - 1
end

local function getSpeciesStat(crewmem, statName)
    local species = crewmem:GetSpecies()
    local crewStats = safeLoadCrewStats(species)
    local stat = crewStats[statName]
    if (stat == nil) then
        stat = 0
    end
    local statCategory = dvsd.TRAIT_DEFINITIONS[statName].category.internalName
    local mainStat = crewStats[statCategory]
    if (mainStat == nil) then
        lwl.logError(LOG_TAG, "Main stat for "..species.." was nil!"..statCategory, LOG_LEVEL)
        mainStat = 0
    end
    lwl.logInfo(LOG_TAG, statName.." for "..species..": "..mainStat.."+"..stat, LOG_LEVEL)
    local skillStat = 0
    --Weapons, Repairs, Fighting, Shields, Piloting, Engines
    if (statName == dvsd.s_logic.internalName) then
        skillStat = skillStat + skillBonus(crewmem, lwl.SKILL_REPAIR())
    elseif (statName == dvsd.s_encylopedia.internalName) then
        --
    elseif (statName == dvsd.s_rhetoric.internalName) then
        --n/a
    elseif (statName == dvsd.s_drama.internalName) then
        --n/a
    elseif (statName == dvsd.s_conceptualization.internalName) then
        skillStat = skillStat + skillBonus(crewmem, lwl.SKILL_REPAIR())
    elseif (statName == dvsd.s_visual_calculus.internalName) then
        skillStat = skillStat + skillBonus(crewmem, lwl.SKILL_PILOT())
        skillStat = skillStat + skillBonus(crewmem, lwl.SKILL_WEAPONS())
    elseif (statName == dvsd.s_volition.internalName) then
        
    elseif (statName == dvsd.s_inland_empire.internalName) then
        --pilot?
    elseif (statName == dvsd.s_empathy.internalName) then
        
    elseif (statName == dvsd.s_authority.internalName) then
        --pilot?
    elseif (statName == dvsd.s_espirit_de_corps.internalName) then
        
    elseif (statName == dvsd.s_suggestion.internalName) then
        
    elseif (statName == dvsd.s_endurance.internalName) then
        skillStat = skillStat + skillBonus(crewmem, lwl.SKILL_REPAIR())
    elseif (statName == dvsd.s_pain_threshold.internalName) then
        skillStat = skillStat + skillBonus(crewmem, lwl.SKILL_COMBAT())
    elseif (statName == dvsd.s_physical_instrument.internalName) then
        skillStat = skillStat + skillBonus(crewmem, lwl.SKILL_COMBAT())
    elseif (statName == dvsd.s_electrochemistry.internalName) then
        
    elseif (statName == dvsd.s_shivers.internalName) then
        
    elseif (statName == dvsd.s_half_light.internalName) then
        
    elseif (statName == dvsd.s_hand_eye_coordination.internalName) then
        skillStat = skillStat + skillBonus(crewmem, lwl.SKILL_WEAPONS())
        skillStat = skillStat + skillBonus(crewmem, lwl.SKILL_REPAIR())
    elseif (statName == dvsd.s_perception.internalName) then
        
    elseif (statName == dvsd.s_reaction_speed.internalName) then
        skillStat = skillStat + skillBonus(crewmem, lwl.SKILL_PILOT())
    elseif (statName == dvsd.s_savoir_faire.internalName) then
        
    elseif (statName == dvsd.s_interfacing.internalName) then
        skillStat = skillStat + skillBonus(crewmem, lwl.SKILL_ENGINES())
        skillStat = skillStat + skillBonus(crewmem, lwl.SKILL_SHIELDS())
        skillStat = skillStat + skillBonus(crewmem, lwl.SKILL_REPAIR())
    elseif (statName == dvsd.s_composure.internalName) then
        
    end
    return mainStat + stat + skillStat
end


local function getPrintableStatTable(crewMem)
    local crewStats = safeLoadCrewStats(crewMem:GetSpecies())
    --todo for after I get the basics working, this is nice to have
end

--helper function
local function getSumStat(statName)
    local valueSum = 0
    local crewList = lwl.getAllMemberCrew(Hyperspace.ships.player)
    --Iterate over player ship
    for i=1,#crewList do
        local crewmem = crewList[i]
        valueSum = valueSum + getSpeciesStat(crewmem, statName)
    end
    
    --Then add your captain values
    --valueSum = valueSum + getSpeciesStat("PLAYER", statName)--currently always zero, might add later.
    --Then your ship stats
    valueSum = valueSum + mde.getAutoShipStat(statName)
    return valueSum
end

local function getAverageStat(statName)
    local totalStats = getSumStat(statName)
    local numCrew = #lwl.getAllMemberCrew(Hyperspace.ships.player)
    return totalStats / (numCrew + 1) --+2 if I include the captain at some point
end

local function getStat(statName)
    return getAverageStat(statName)
end

--As a baseline, you have a 4332 statblock randomly assigned with one proficiency as Captain.  So player stats should start off with nothing.  Don't call this.
--Eventually I might define ship-specific bonuses that also scale with reactor.  This version is outmoded though.
local function initPlayerStats()
    local stats = {4, 3, 3, 2}
    local names = {dvsd.INTELLECT, dvsd.PSYCHE, dvsd.PHYSIQUE, dvsd.MOTORICS}
    for i = 1, #stats do
        local stat = table.remove(stats, math.random(1, #stats))
        local name = names[i]
        dvsd.CREW_STAT_TABLE.PLAYER[names[i]] = stat --I think this works.
    end
    dvsd.CREW_STAT_TABLE.PLAYER[lwl.getRandomKey(dvsd.TRAIT_DEFINITIONS)] = 1
end

--ill see if i want inverse checks.
local function activeCheck(statName, amount)
    local firstDie = math.random(1,6)
    local secondDie = math.random(1,6)
    local statValue = getStat(statName)
    local totalValue = firstDie + secondDie + statValue
    --print("Active check: ", statName, " ", amount, " Rolls ", firstDie, secondDie, statValue, totalValue)
    --Snakeyes always fails.  Boxcars always succeeds.
    if (totalValue == 2) then
        return false
    elseif (totalValue == 12) then
        return true
    end
    return (totalValue >= amount)
end

local function passiveCheck(statName, amount)
    --print("Passive check: ", statName, " ", amount, " Value ", (getStat(statName) + 6))
    return (getStat(statName) + 6 >= amount)
end

local function cleanUpCards()
    if (mCurrentCard ~= nil) then
        Brightness.destroy_particle(mCurrentCard)
    end
end

local function renderCard(skillName)
    cleanUpCards()
    --Time doesn't tick on this layer while events are up.
    mCurrentCard = Brightness.create_particle("particles/attributes/"..skillName, 1, 0.01, Hyperspace.Pointf(990, 330), 0, nil, "MOUSE_CONTROL_PRE")
end

local function playPassiveSuccess(check)
    local skillCategory = dvsd.TRAIT_DEFINITIONS[check.skill].category
    if (skillCategory == dvsd.s_MOTORICS) then
        Hyperspace.Sounds:PlaySoundMix("disco_motorics", 10, false)
    elseif (skillCategory == dvsd.s_PSYCHE) then
        Hyperspace.Sounds:PlaySoundMix("disco_psyche", 10, false)
    elseif (skillCategory == dvsd.s_PHYSIQUE) then
        Hyperspace.Sounds:PlaySoundMix("disco_physique", 10, false)
    elseif (skillCategory == dvsd.s_INTELLECT) then
        Hyperspace.Sounds:PlaySoundMix("disco_intellect", 10, false)
    else
        error("Invalid category ", skillCategory)
    end
end

local function renderCheckResult(locationEvent)
    local check = mQueuedCheckAVList[locationEvent.eventName]
    --print("renderCheckResult ", check)
    if check ~= nil then
        if (check.success) then
            Hyperspace.Sounds:PlaySoundMix("disco_check_success", 5, false)
        else
            Hyperspace.Sounds:PlaySoundMix("disco_check_fail", 5, false)
        end
        renderCard(check.skill)
    end
    mQueuedCheckAVList = {}
end

--attribute values for guns?
--Lua button to check your attributes
--lua events that pop up out of combat
--lua events that pop up in combat, based on the ship you're fighting.
--These need to be very rare

--I want a symbol that interprets itself.
--Not just that it is the language, but the hardware as well.

local function passiveText(skillCheck)
    return skillFromName(skillCheck.skill).name.." ["..dvsd.CHECK_DIFFICULTY_NAMES[skillCheck.value]..": Success] -- "..skillCheck.replacementChoiceText
end

local function activeText(skillCheck)
    local successChance = probability_greater_than(2, 6, skillCheck.value - getStat(skillCheck.skill))
    successChance = math.max(3, math.min(successChance, 97)) --Bounded by crits
    return "["..skillFromName(skillCheck.skill).name.." - "..dvsd.CHECK_DIFFICULTY_NAMES[skillCheck.value].." "..skillCheck.value..", "..successChance.."%] -- "..skillCheck.replacementChoiceText
end

--piloting is what you should choose for your check.  1=success, 8=failure, you don't see it.
local function appendChoices(locationEvent)
    local skillChecks = mDiscoEventsList[locationEvent.eventName]
    if skillChecks == nil then return end
    print("Check: ",lwl.dumpObject(skillChecks))
    local choices = locationEvent:GetChoices()
    --find the associated entry for each choice and apply it.
    for i = 1,#skillChecks do --iterate over choices, replace keywords with strings.
        local skillCheck = skillChecks[i]
        print("Check: ",lwl.dumpObject(skillCheck))
        --todo check av nonsense.  At very least audio + printing the result.
        local activeSuccess = activeCheck(skillCheck.skill, skillCheck.value)
        local passiveSuccess = true--passiveCheck(skillCheck.skill, skillCheck.value)
        if (skillCheck.passive) then
            --print("passive check found.")
            for choice in vter(choices) do
                --print(choice.text.data, skillCheck.placeholderChoiceText, choice.text.data == skillCheck.placeholderChoiceText, passiveSuccess)
                --print("Successp? ", passiveSuccess and (choice.text.data == skillCheck.placeholderChoiceText))
                if (choice.text.data == skillCheck.placeholderChoiceText) then
                    if (passiveSuccess) then
                        playPassiveSuccess(skillCheck)
                        renderCard(skillCheck.skill)
                        choice.requirement.blue = true
                        choice.text.data = passiveText(skillCheck)
                        choice.requirement.min_level = 1
                    else
                        choice.requirement.min_level = 9 --shouldn't see the event in this case.
                    end
                end
            end
        else --active
            --print("active check found.")
            mQueuedCheckAVList[skillCheck.successEventName] = {success=true, skill=skillCheck.skill}
            mQueuedCheckAVList[skillCheck.failureEventName] = {success=false, skill=skillCheck.skill}
            for choice in vter(choices) do
                --print(choice.text.data, skillCheck.placeholderChoiceText, choice.text.data == skillCheck.placeholderChoiceText)
                if (choice.text.data == skillCheck.placeholderChoiceText) then
                    --These ones always show up, and it's a matter of if it succeeds.  Ideally I would't have to do this in xml, it takes two events for each active check.
                    choice.text.data = activeText(skillCheck)
                    local shouldDisplay = (activeSuccess == choice.requirement.blue)
                    --print("Success? ", activeSuccess, choice.requirement.blue, shouldDisplay)
                    if (shouldDisplay) then
                        --todo somehow make a trigger for when you select this.
                        choice.requirement.blue = true
                        choice.text.data = activeText(skillCheck)
                        choice.requirement.min_level = 1
                    else
                        choice.requirement.min_level = 9
                    end
                end
            end
        end
    end
end

--Should only be called with events created by mods.multiverseDiscoEngine.buildEvent
local function registerEvent(event)
    if (mDiscoEventsList[event.name] == nil) then
        mDiscoEventsList[event.name] = event
    else
        --append checks to existing event.
        lwl.logInfo(TAG, "Event "..event.name.." already exists, appending.", LOG_LEVEL)
        for i = 1,#event do
            table.insert(mDiscoEventsList[event.eventName], event[i])
        end
    end
    print(lwl.dumpObject(mDiscoEventsList))
end

function mde.registerEventList(eventList)
    for i = 1,#eventList do
        registerEvent(eventList[i])
    end
end

function mde.buildEvent(eventName)
    return {name=eventName}
end

function mde.buildPassiveCheck(skill, difficultyValue, placeholderChoiceText, replacementChoiceText)
    return {placeholderChoiceText=placeholderChoiceText, passive=true, skill=skill, value=difficultyValue, replacementChoiceText=replacementChoiceText}
end

function mde.buildActiveCheck(skill, difficultyValue, initialChoiceText, replacementChoiceText, successEventName, failureEventName)
    return {passive=false, skill=skill, value=difficultyValue, placeholderChoiceText=initialChoiceText, replacementChoiceText=replacementChoiceText, successEventName=successEventName, failureEventName=failureEventName}
end

--[[
    Add new crew you've made to the disco stat table.  You can also use this to overwrite existing crew's values if you want with the optional force argument.
    Basic crew are around 12-13 major stat points, elite crew around 16-22, super elite 24-28, and uniques vary wildly.  You can look at the existing table for examples.
    This is just a guideline, and if there's something you want your crew to be really good at, go for it, because it's going to get diluted by all the other crew onboard.

    Stat block format:
    {INTELLECT=3, logic=0, encylopedia=0, rhetoric=0, drama=0, conceptualization=0, visual_calculus=0, PSYCHE=3, volition=0, inland_empire=0, empathy=0, authority=0, espirit_de_corps=0, suggestion=0, PHYSIQUE=3, endurance=0, pain_threshold=0, physical_instrument=0, electrochemistry=0, shivers=0, half_light=0, MOTORICS=3, hand_eye_coordination=0, perception=0, reaction_speed=0, savoir_faire=0, interfacing=0, composure=0}
--]]
function mods.multiverseDiscoEngine.appendCrew(crewName, statBlock, force)
    if (not force and dvsd.CREW_STAT_TABLE[crewName] ~= nil) then
        lwl.logWarn(TAG, crewName.." is already defined, skipping.", LOG_LEVEL)
        return
    end
    dvsd.CREW_STAT_TABLE[crewName] = statBlock
end

--[[ Main Event Loop ]]--
script.on_internal_event(Defines.InternalEvents.PRE_CREATE_CHOICEBOX, function(locationEvent)
        cleanUpCards()
        renderCheckResult(locationEvent)
        appendChoices(locationEvent)
    end)

---------------------------------------UI------------------------------------------------
---Open issues: no sound
local function NOOP() end

local mGuiMode = 0 -- 1=stats, 2= crew, 0= normal

local function statScreenToggle()
    if mGuiMode == 0 then
        mGuiMode = 1
    else
        mGuiMode = 0
    end
end

local function statScreenSwitch()
    if mGuiMode == 1 then
        mGuiMode = 2
    elseif mGuiMode == 2 then
        mGuiMode = 1
    end
end

script.on_internal_event(Defines.InternalEvents.ON_KEY_DOWN, function(Key)
    --esc makes this 0
    if Key == 27 then
        if mGuiMode ~= 0 then
            mGuiMode = 0
            return Defines.Chain.PREEMPT
        end
    elseif Key == 9 then
        statScreenSwitch()
    end
end)

--todo this should probably be its own class.
local function inGame()
    local commandGui = Hyperspace.Global.GetInstance():GetCApp().gui
    return Hyperspace.ships(0) and (Hyperspace.ships(0).iCustomizeMode == 0) and not commandGui.menu_pause
end
local function statScreenVisibility()
        return inGame and mGuiMode == 1
end
local function crewScreenVisibility()
    return inGame and mGuiMode == 2
end
local function eitherScreenVisibility()
    return statScreenVisibility() or crewScreenVisibility()
end



local MAIN_LAYER = "MOUSE_CONTROL_PRE"
local DISCO_TRAIT_RATIO = (368/512)
local imageHeight = 135
local imageWidth = imageHeight * DISCO_TRAIT_RATIO
local textHeight = 20
local mTraitBoxes = {}

--The render function of the containers is off.  Idk what's up with it.
local backgroundFilter = lwui.buildObject(0, 0, 1280, 720, eitherScreenVisibility, lwui.solidRectRenderFunction(Graphics.GL_Color(0, 0, .0, .5)))
local backgroundFilter2 = lwui.buildObject(0, 0, 1280, 720, eitherScreenVisibility, lwui.solidRectRenderFunction(Graphics.GL_Color(.303, .284, .055, .9)))
local backgroundFilter3 = lwui.buildObject(0, 0, 1280, 720, eitherScreenVisibility, lwui.solidRectRenderFunction(Graphics.GL_Color(.23, .097, .39, .55)))
lwui.addTopLevelObject(backgroundFilter, MAIN_LAYER)
lwui.addTopLevelObject(backgroundFilter2, MAIN_LAYER)
lwui.addTopLevelObject(backgroundFilter3, MAIN_LAYER)
local statRowsContainer = lwui.buildVerticalContainer(183, 9, 900, 1, statScreenVisibility, lwui.solidRectRenderFunction(Graphics.GL_Color(.024, .131, .292, .6)), {}, false, true, 0)
for _,category in ipairs(dvsd.TRAIT_CATEGORIES) do
    --The height of this row needs to be exactly right.
    local currentRow = lwui.buildHorizontalContainer(0, 0, 1, imageHeight + (textHeight * 2), statScreenVisibility, NOOP, {}, true, false, 15)
    local rowTitleText = lwui.buildFixedTextBox(0, 0, imageWidth, imageWidth,
        statScreenVisibility, NOOP, 30)
    rowTitleText.text = category.name
    rowTitleText.textColor = category.color
    currentRow.addObject(rowTitleText)
    for _,trait in pairs(dvsd.TRAIT_DEFINITIONS) do
        if trait.category == category then
            local traitContainer = lwui.buildVerticalContainer(0, 0, imageWidth, 1, statScreenVisibility, NOOP, {}, true, false, 0)
            traitContainer.addObject(lwui.buildObject(0, 0, imageWidth, imageHeight,
                statScreenVisibility, lwui.spriteRenderFunction("attributes/"..trait.definition.internalName..".png")))
            local traitText = lwui.buildFixedTextBox(0, 0, imageWidth, textHeight,
                statScreenVisibility, NOOP, 30)
            traitText.text = trait.definition.name
            traitText.textColor = category.color
            local traitValue = lwui.buildFixedTextBox(0, 0, imageWidth, textHeight,
                statScreenVisibility, NOOP, 30)
            --traitValue.textColor = category.color
            mTraitBoxes[trait.definition.internalName] = traitValue
            traitContainer.addObject(traitText)
            traitContainer.addObject(traitValue)
            currentRow.addObject(traitContainer)
        end
    end
    statRowsContainer.addObject(currentRow)
end
lwui.addTopLevelObject(statRowsContainer, MAIN_LAYER)


-----------Crew Screen--------------
--Actually I decided I didn't want this
--[[
local statScreen = lwui.buildObject(0, 0, 300, 400,
    statScreenVisibility, lwui.solidRectRenderFunction(Graphics.GL_Color(1, 1, 1, 1)))
lwui.addTopLevelObject(statScreen, "MOUSE_CONTROL_PRE")]]

local switchScreenButton = lwui.buildButton(1218, 585, 30, 30, --disco icon?
    eitherScreenVisibility, lwui.solidRectRenderFunction(Graphics.GL_Color(1, 0, 0, 1)), statScreenSwitch, NOOP)

local statScreenButtonIcons = {"d6_6.png", "d6_1.png"}
local function statScreenButtonIndex()
    if mGuiMode == 0 then
        return 1
    else
        return 2
    end
end
local statScreenButton = lwui.buildButton(1218, 625, 30, 30, --disco icon?
    inGame, lwui.dynamicSpriteRenderFunction(statScreenButtonIcons, statScreenButtonIndex), statScreenToggle, NOOP)
--lwui.addTopLevelObject(switchScreenButton, MAIN_LAYER)
lwui.addTopLevelObject(statScreenButton, MAIN_LAYER)

script.on_internal_event(Defines.InternalEvents.ON_TICK, function()
    for key,box in pairs(mTraitBoxes) do
        box.text = "      "..(math.floor(getAverageStat(key)*100)/100) --two decimal places
    end
end)