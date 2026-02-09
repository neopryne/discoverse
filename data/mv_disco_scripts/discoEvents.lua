--The events need to be defined in XML, which isn't ideal, but it works.
--Active checks need two xml events, one will be disabled based on the check result.  Blue value indicates if it is for a success or not.
--max_group must be different for each option for an event.  I'm using the 640 block, forgemaster uses 620-ish, pick something for yourself if you're using this.
--Every check is a red check here (can't be retried).
--You must put events with no check between active->passive checks.  This can be a small continue box.
--All other combinations work fine, but active->passive has a conflict with what wants to render.

--[[
    See example usage file
--]]
local mde = mods.multiverseDiscoEngine

local vter = mods.multiverse.vter
local lwl = mods.lightweight_lua
local Brightness = mods.brightness
local dvsd = mods.discoVerseStaticDefinitions

local LOG_LEVEL = 3
local TAG = "mods.disco.core"

local CHROMAKEY_DELAY = 12.33 --show dice and overlay
local FADE_OUT_START = 28
local ACTIVE_EFFECT_FADE_TIME = 1 --seconds, for Brightness
local DICE_Y = 100
local DIE_1_X = ((1280 / 2) - 20)
local DIE_2_X = ((1280 / 2) + 20)
local INFINITESIMAL = .0001

local mQueuedCheckAVList = {} --Earcons pending check results (and dice faces)
local mDiscoEventsList = {} --Registered events
local mCurrentCard
local mCurrentDice = {}
local mCurrentOverlay

local mHaveCreatedParticles
local mActiveCheckTimerStarted = false
local mEventTimer = 0
local mCurrentAVCheck
local mAttemptedChecks = {}

local forceValue = nil

local mSuspendedText = nil
local mTextboxUpdateReady = false

if not lwl then
    error("Lightweight Lua was not patched, or was patched after Multiverse Disco Engine.  Install it properly or face undefined behavior.")
end

--[[
The goal of this is to create a system which can be used to inhect disco elysium-style checks/options into events.
Stretch goal: have each ship get a unique pilot buff set.  That's insane, but works in theory at least.

Something's negative sometimes, probably with my random number generation?   Like the room center?  idk if this still happens.


Actually, this must be split into two parts.  The Multiverse Disco Engine, which goes at the very top as a library,
 and the Disco Content Packs, which go at the very end of your mod list, or at least below the mods with the events they're supposed to modify.

General mod order:
Multiverse
Libraries
Content
Meta content
QoL / Graphics
'Patch Last' mods


todo: This shouldn't average your crew, it should use the highest value amongst your crew or your ship.  In the stat screen, it should show you who is providing
your current value for a given stat.
If it's your ship, it uses the sector map ship icon.
--]]

--oh, this is for red checks, and not currently implemented.
local function wasAttempted(check)
    --print("checking check ", ""..check.skill..check.value)
    -- for _,value in ipairs(mAttemptedChecks) do
    --     if (value == ""..check.skill..check.value) then
    --         return true
    --     end
    -- end

    --todo I don't remember what this did, but markAttempted is disabled, so it isn't doing it currently.
    return false
end

local function markAttempted(checkAvList)
    print("attempted check ", ""..checkAvList.skill..checkAvList.targetValue)
    table.insert(mAttemptedChecks, ""..checkAvList.skill..checkAvList.targetValue)
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



--#region Event Checks

--ill see if i want inverse checks.
local function activeCheck(skillCheck, forceTo)
    local statName = skillCheck.skill
    local amount = skillCheck.value
    local firstDie = math.random(1,6)
    local secondDie = math.random(1,6)
    local statValue = mde.getStat(statName)
    local totalValue = firstDie + secondDie + statValue
    --print("Active check: ", statName, " ", amount, " Rolls ", firstDie, secondDie, statValue, totalValue)
    --Snakeyes always fails.  Boxcars always succeeds.
    if (totalValue == 2) then
        return false
    elseif (totalValue == 12) then
        return true
    end
    local checkSuccess = (totalValue >= amount)
    if forceTo ~= nil then
        checkSuccess = forceTo
    end

    local eventName
    if checkSuccess then --Event names are needed to queue up the AV effect for when they get selected.  Hacky, but I don't know how to hook it right.
        eventName = skillCheck.successEventName
    else
        eventName = skillCheck.failureEventName
    end
    
    mQueuedCheckAVList[eventName] = {success=checkSuccess, skill=skillCheck.skill, firstDie=firstDie,
        secondDie=secondDie, totalValue=totalValue, targetValue=amount}
    return checkSuccess
end

local function passiveCheck(statName, amount)--todo actually use this
    --print("Passive check: ", statName, " ", amount, " Value ", (getStat(statName) + 6))
    return (mde.getStat(statName) + 6 >= amount)
end

local function resetActiveCheck() --render card is cleaning up this, need ot reorder.
    lwl.logInfo(TAG, "resetActiveCheck")
    --print("resetActiveCheck")
    if mCurrentOverlay then
        mCurrentOverlay.paused = false
    end
    mEventTimer = 0
    mActiveCheckTimerStarted = false
    mHaveCreatedParticles = false
end

local function destroyDice()
    lwl.logInfo(TAG, "destroyDice")
    --print("destroyDice")
    for _,die in ipairs(mCurrentDice) do
        Brightness.destroy_particle(die)
    end
    mCurrentDice = {}
end

local function cleanUpParticles()
    if (mCurrentCard ~= nil) then
        lwl.logInfo(TAG, "destroy current card")
        --print("destroy current card")
        Brightness.destroy_particle(mCurrentCard)
    end
    destroyDice()
    resetActiveCheck()
end

local function renderCard(skillName)
    lwl.logInfo(TAG, "renderCard")
    cleanUpParticles()
    --Time doesn't tick on this layer while events are up. todo newest brightness.
    local xPos
    if Hyperspace.ships(1) then
        xPos = 837
    else
        xPos = 990
    end
    mCurrentCard = Brightness.create_particle("particles/attributes/"..skillName, 1, INFINITESIMAL, Hyperspace.Pointf(xPos, 330), 0, nil, "MOUSE_CONTROL_PRE")
end

local function playPassiveSuccess(check)
    local skillCategory = dvsd.TRAIT_DEFINITIONS[check.skill].category
    if (skillCategory == dvsd.s_MOTORICS) then
        Hyperspace.Sounds:PlaySoundMix("disco_motorics", 5, false)
    elseif (skillCategory == dvsd.s_PSYCHE) then
        Hyperspace.Sounds:PlaySoundMix("disco_psyche", 5, false)
    elseif (skillCategory == dvsd.s_PHYSIQUE) then
        Hyperspace.Sounds:PlaySoundMix("disco_physique", 5, false)
    elseif (skillCategory == dvsd.s_INTELLECT) then
        Hyperspace.Sounds:PlaySoundMix("disco_intellect", 5, false)
    else
        error("Invalid category ", skillCategory)
    end
end

--attribute values for guns?
--lua events that pop up out of combat
--lua events that pop up in combat, based on the ship you're fighting.
--These need to be very rare

--I want a symbol that interprets itself.
--Not just that it is the language, but the hardware as well.

local function passiveText(skillCheck)
    local skill = mde.skillFromName(skillCheck.skill)
    local colorString = dvsd.getSkillCategory(skill).eventColor
    --print("Category name:", dvsd.getSkillCategory(skill).name)
    return "[style[color:"..colorString.."]]"..skill.name.." ["..dvsd.CHECK_DIFFICULTY_NAMES[skillCheck.value]..": Success] -- "..skillCheck.replacementChoiceText.."[[/style]]"
end

local function activeText(skillCheck)
    local skill = mde.skillFromName(skillCheck.skill)
    local colorString = dvsd.getSkillCategory(skill).eventColor
    local successChance = mde.probability_greater_than(2, 6, skillCheck.value - mde.getStat(skillCheck.skill))
    successChance = math.max(3, math.min(successChance, 97)) --Bounded by crits
    return "[style[color:"..colorString.."]]".."["..skill.name.." - "..dvsd.CHECK_DIFFICULTY_NAMES[skillCheck.value].." "..skillCheck.value..", "..successChance.."%] -- "..skillCheck.replacementChoiceText.."[[/style]]"
end

--piloting is what you should choose for your check.  1=success, 8=failure, you don't see it.
local function appendChoices(locationEvent)
    local skillChecks = mDiscoEventsList[locationEvent.eventName]
    if skillChecks == nil then return end
    --print("Checks: ",lwl.dumpObject(skillChecks))
    local choices = locationEvent:GetChoices()
    --find the associated entry for each choice and apply it.
    for i = 1,#skillChecks do --iterate over choices, replace keywords with strings.
        local skillCheck = skillChecks[i]
        --print("Check: ",lwl.dumpObject(skillCheck))
        if (skillCheck.passive) then
            local passiveSuccess = passiveCheck(skillCheck.skill, skillCheck.value)
            --print("passive check found.")
            for choice in vter(choices) do
                --print(choice.text.data, skillCheck.placeholderChoiceText, choice.text.data == skillCheck.placeholderChoiceText, passiveSuccess)
                --print("Successp? ", passiveSuccess and (choice.text.data == skillCheck.placeholderChoiceText))
                if (choice.text.data == skillCheck.placeholderChoiceText) then
                    if (passiveSuccess) then
                        playPassiveSuccess(skillCheck)
                        renderCard(skillCheck.skill)
                        choice.text.data = passiveText(skillCheck)
                        choice.requirement.min_level = 1
                    else
                        choice.requirement.min_level = 9 --shouldn't see the event in this case.
                    end
                end
            end
        else --active
            local activeSuccess = activeCheck(skillCheck, forceValue) --todo this should return the whole check, not success value.
            if forceValue ~= nil then
                --print("Forced success to be ", forceValue)
                activeSuccess = forceValue
                forceValue = nil
            end
            --print("active check found.")
            for choice in vter(choices) do
                --print(choice.text.data, skillCheck.placeholderChoiceText, choice.text.data == skillCheck.placeholderChoiceText)
                if (choice.text.data == skillCheck.placeholderChoiceText) then
                    --These ones always show up, and it's a matter of if it succeeds.  Ideally I would't have to do this in xml, it takes two events for each active check.
                    choice.text.data = activeText(skillCheck)
                    local shouldDisplay = (not wasAttempted(skillCheck)) and (activeSuccess == choice.requirement.blue)
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
    --print(lwl.dumpObject(mDiscoEventsList))
end
--#endregion
--#region API
function mde.registerEventList(eventList)
    for i = 1,#eventList do
        registerEvent(eventList[i])
    end
end

function mde.buildEvent(eventName)
    return {name=eventName}
end


---@param skill string
---@param difficultyValue integer
---@param placeholderChoiceText string
---@param replacementChoiceText string
---@return table
function mde.buildPassiveCheck(skill, difficultyValue, placeholderChoiceText, replacementChoiceText)
    return {placeholderChoiceText=placeholderChoiceText, passive=true, skill=skill, value=difficultyValue, replacementChoiceText=replacementChoiceText}
end

---comment
---@param skill string
---@param difficultyValue integer
---@param placeholderChoiceText string
---@param replacementChoiceText string
---@param successEventName string
---@param failureEventName string
---@return table
function mde.buildActiveCheck(skill, difficultyValue, placeholderChoiceText, replacementChoiceText, successEventName, failureEventName)
    return {passive=false, skill=skill, value=difficultyValue, placeholderChoiceText=placeholderChoiceText, replacementChoiceText=replacementChoiceText, successEventName=successEventName, failureEventName=failureEventName}
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



--#region -------------------------------------UI------------------------------------------------
local function renderCheckResult(locationEvent)
    mCurrentAVCheck = mQueuedCheckAVList[locationEvent.eventName]
    print("All events:", lwl.dumpObject(mQueuedCheckAVList))
    mQueuedCheckAVList[locationEvent.eventName] = nil
    --The check was a success, but it saved failure.
    print("renderCheckResult ", mCurrentAVCheck, locationEvent.eventName)
    if mCurrentAVCheck ~= nil then
        --markAttempted(mCurrentAVCheck) TODO put this back when done testing
        if (mCurrentAVCheck.success) then
            Hyperspace.Sounds:PlaySoundMix("disco_check_success", 5, false)
        else
            Hyperspace.Sounds:PlaySoundMix("disco_check_fail", 5, false)
        end
        renderCard(mCurrentAVCheck.skill)
        --lifetime?
        local die1Rolling = Brightness.create_particle("particles/random_"..math.random(1,3), 6, .11, Hyperspace.Pointf(DIE_1_X, DICE_Y), 0, nil, "MOUSE_CONTROL_PRE")
        local die2Rolling = Brightness.create_particle("particles/random_"..math.random(1,3), 6, .13, Hyperspace.Pointf(DIE_2_X, DICE_Y), 0, nil, "MOUSE_CONTROL_PRE")
        table.insert(mCurrentDice, die1Rolling)
        table.insert(mCurrentDice, die2Rolling)
        for _,die in ipairs(mCurrentDice) do
            die.persists = true
            die.playDuringGamePause = true
        end
        mActiveCheckTimerStarted = true
        print("started", mActiveCheckTimerStarted)

        local checkSkill = mde.skillFromName(mCurrentAVCheck.skill)
        local colorString = dvsd.getSkillCategory(checkSkill).eventColor
        local resultString
        local checkString = "[style[color:"..colorString.."]]"..checkSkill.name.."[[/style]]".."[style[color:a8a8a8]] ["..dvsd.CHECK_DIFFICULTY_NAMES[mCurrentAVCheck.targetValue]..": "
        local checkStringPost = "] ("..math.floor(mCurrentAVCheck.totalValue).." vs "..mCurrentAVCheck.targetValue..") --[[/style]]\n"
        --Skill name [CheckLevel: result] (num vs goal) --
        if mCurrentAVCheck.success then
            resultString = "Success"
        else
            resultString = "Failure"
        end
        mSuspendedText = checkString..resultString..checkStringPost..locationEvent.text:GetText()
        locationEvent.text.data = "[style[color:"..colorString.."]]"..checkSkill.name.."[[/style]]".."[style[color:a8a8a8]] ["..dvsd.CHECK_DIFFICULTY_NAMES[mCurrentAVCheck.targetValue].."][[/style]]"
        locationEvent.text.isLiteral = true
    end
end

lwl.safe_script.on_internal_event("mde actice check render", Defines.InternalEvents.ON_TICK, function()
    --print("ticking", Hyperspace.ships(0) ~= nil, mActiveCheckTimerStarted)
    if not Hyperspace.ships(0) then return end
    if mActiveCheckTimerStarted then
        --print("Time now:", mEventTimer)
        mEventTimer = mEventTimer + (Hyperspace.FPS.SpeedFactor * 16 / 10)
        if not mHaveCreatedParticles and mEventTimer > CHROMAKEY_DELAY then
            --print("creating particles")
            local overlayString
            --Skill name [CheckLevel: result] (num vs goal) --
            if mCurrentAVCheck.success then
                overlayString = "particles/success"
            else
                overlayString = "particles/failure"
            end
            --dice before particles, they run before these are created.
            -- and are destroyed when these are.
            --Put at the beginning of the event, in colored text, the result of the check.
            mCurrentOverlay = Brightness.create_particle(overlayString, 10, ACTIVE_EFFECT_FADE_TIME, Hyperspace.Pointf(lwl.SCREEN_WIDTH / 2, lwl.SCREEN_HEIGHT / 2), 0, nil, "MOUSE_CONTROL_PRE")
            local die1 = Brightness.create_particle("particles/faces/d6_"..mCurrentAVCheck.firstDie, 1, INFINITESIMAL, Hyperspace.Pointf(DIE_1_X, DICE_Y), 0, nil, "MOUSE_CONTROL_PRE")
            local die2 = Brightness.create_particle("particles/faces/d6_"..mCurrentAVCheck.secondDie, 1, INFINITESIMAL, Hyperspace.Pointf(DIE_2_X, DICE_Y), 0, nil, "MOUSE_CONTROL_PRE")
            destroyDice()
            table.insert(mCurrentDice, die1)
            table.insert(mCurrentDice, die2)
            mCurrentOverlay.paused = true
            mCurrentOverlay.playDuringGamePause = true
            mHaveCreatedParticles = true
            --todo fill the values here.
            if not mSuspendedText then error("DiscoCore: No text ready to render!") end
            mTextboxUpdateReady = true
        elseif mEventTimer >= FADE_OUT_START then
            --print("fading overlay")
            resetActiveCheck()
        end
    end
end)

lwl.safe_script.on_render_event("disco events delay result", Defines.RenderEvents.CHOICE_BOX, function(choiceBox)
    if mSuspendedText then
        if mTextboxUpdateReady then
            mTextboxUpdateReady = false
            choiceBox.mainText = mSuspendedText
            mSuspendedText = nil
        end
        return Defines.Chain.PREEMPT
    end
end,
function() end)

lwl.safe_script.on_internal_event("mde jump reset", Defines.InternalEvents.JUMP_LEAVE, function()
    mAttemptedChecks = {}
end)
--#endregion
--#region Main Event Loop
script.on_internal_event(Defines.InternalEvents.PRE_CREATE_CHOICEBOX, function(locationEvent)
        cleanUpParticles()
        renderCheckResult(locationEvent)
        appendChoices(locationEvent)
    end)
--#endregion
--#region ------------------------------DEBUG METHODS---------------------------------------
function disco_force_success()
    forceValue = true
end

function disco_force_fail()
    forceValue = false
end
--#endregion
