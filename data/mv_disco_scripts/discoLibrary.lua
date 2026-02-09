local mde = mods.multiverseDiscoEngine

local vter = mods.multiverse.vter
local lwl = mods.lightweight_lua
local dvsd = mods.discoVerseStaticDefinitions

local LOG_LEVEL = 3
local TAG = "mods.disco.core"

local DEFAULT_STARTING_POWER = 7
local DEFAULT_POWER_CAP = 25
local STARTING_ATTRIBUTE_VAULE = 2
local ATTRIBUTE_VAULE_SOFT_CAP = 7

--#region stat calcuation

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

function mde.getAutoShipStat(statName)
    local ownship = Hyperspace.ships.player
    local room = ownship.ship.vRoomList[ownship:GetSystemRoom(lwl.SYS_PILOT())]--For damage resist values
    local baseStat = ((Hyperspace.PowerManager.GetPowerManager(0):GetMaxPower() - DEFAULT_STARTING_POWER) * (ATTRIBUTE_VAULE_SOFT_CAP - STARTING_ATTRIBUTE_VAULE) / (DEFAULT_POWER_CAP - DEFAULT_STARTING_POWER)) + STARTING_ATTRIBUTE_VAULE
    if (statName == dvsd.s_logic.internalName) then
        baseStat = baseStat + 2 --n/a autoship bonus?
    elseif (statName == dvsd.s_encylopedia.internalName) then
        baseStat = baseStat + 1.5 --n/a autoship bonus?
    elseif (statName == dvsd.s_rhetoric.internalName) then
        --n/a
    elseif (statName == dvsd.s_drama.internalName) then
        --n/a
    elseif (statName == dvsd.s_conceptualization.internalName) then
        --n/a autoship bonus?
    elseif (statName == dvsd.s_visual_calculus.internalName) then
        baseStat = baseStat + ((ownship:GetSystemPowerMax(lwl.SYS_PILOT()) - 1 + ownship:GetSystemPowerMax(lwl.SYS_SENSORS())))
    elseif (statName == dvsd.s_volition.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_BATTERY())
    elseif (statName == dvsd.s_inland_empire.internalName) then
        baseStat = baseStat + ((500 - Hyperspace.playerVariables.stability) / 100)
    elseif (statName == dvsd.s_empathy.internalName) then
        baseStat = baseStat - .5 + ownship:GetSystemPowerMax(lwl.SYS_OXYGEN()) + ownship:GetSystemPowerMax(lwl.SYS_MEDBAY()) - Hyperspace.playerVariables.rep_general
    elseif (statName == dvsd.s_authority.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_DOORS())
    elseif (statName == dvsd.s_espirit_de_corps.internalName) then
        baseStat = baseStat - Hyperspace.playerVariables.rep_general --Reputaiton is negative
    elseif (statName == dvsd.s_suggestion.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_MIND()) --todo corruptor
    elseif (statName == dvsd.s_endurance.internalName) then
        baseStat = baseStat + (room.extend.hullDamageResistChance / 10)
    elseif (statName == dvsd.s_pain_threshold.internalName) then
        baseStat = baseStat + (room.extend.sysDamageResistChance / 10)
    elseif (statName == dvsd.s_physical_instrument.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_DRONES())
    elseif (statName == dvsd.s_electrochemistry.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_MIND()) + ownship:GetSystemPowerMax(lwl.SYS_TEMPORAL()) + ownship:GetSystemPowerMax(lwl.SYS_HACKING())
    elseif (statName == dvsd.s_shivers.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_SENSORS()) + ownship:GetSystemPowerMax(lwl.SYS_TEMPORAL())
    elseif (statName == dvsd.s_half_light.internalName) then
        baseStat = baseStat + ((ownship:GetSystemPowerMax(lwl.SYS_WEAPONS()) + ownship:GetSystemPowerMax(lwl.SYS_DRONES())) / 3) --todo turrets
    elseif (statName == dvsd.s_hand_eye_coordination.internalName) then
        baseStat = baseStat + (ownship:GetDodgeFactor() / 15) --45 evade for 3 bonus
    elseif (statName == dvsd.s_perception.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_SENSORS())
    elseif (statName == dvsd.s_reaction_speed.internalName) then
        baseStat = baseStat + (ownship:GetSystemPowerMax(lwl.SYS_PILOT() - 1) + (ownship:GetSystemPowerMax(lwl.SYS_ENGINES()) / 2))
    elseif (statName == dvsd.s_savoir_faire.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_CLOAKING()) + ownship:GetSystemPowerMax(lwl.SYS_PILOT())
    elseif (statName == dvsd.s_interfacing.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_HACKING()) + (ownship:GetSystemPowerMax(lwl.SYS_DRONES()) / 3)
    elseif (statName == dvsd.s_composure.internalName) then --ion resist chance
        baseStat = baseStat + (room.extend.ionDamageResistChance / 10)
    else
        if (statName == nil) then statName = "nil" end
        lwl.logError(TAG, "Invalid stat "..statName, LOG_LEVEL)
    end
    --lwl.logDebug(LOG_TAG, "autostat "..statName.." was "..baseStat, LOG_LEVEL)
    return baseStat
end

--todo maybe return deep copy instead?
local function safeLoadCrewStats(species)
    local crewStats = dvsd.CREW_STAT_TABLE[species]
    if (crewStats == nil) then
        --make something up, can change this
        crewStats = dvsd.CREW_STAT_DEFINITIONS.HUMAN
    end
    return crewStats
end

local function skillBonus(crewmem, skillId)
    return crewmem:GetSkillLevel(skillId) - 1
end

local function getSpeciesStat(crewmem, statName)
    local species = crewmem:GetSpecies()
    local crewStats = safeLoadCrewStats(species) --todo reports this returns nil with unknown crew [alister]
    local stat = crewStats[statName]
    if (stat == nil) then
        stat = 0
    end
    local statCategory = dvsd.TRAIT_DEFINITIONS[statName].category.internalName
    local mainStat = crewStats[statCategory]
    if (mainStat == nil) then
        lwl.logError(TAG, "Main stat for "..species.." was nil!"..statCategory, LOG_LEVEL)
        mainStat = 0
    end
    lwl.logInfo(TAG, statName.." for "..species..": "..mainStat.."+"..stat, LOG_LEVEL)
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

function mde.getHighestStatSource(statName)
    local highest = {stat=mde.getAutoShipStat(statName), race="none_autoship"}
    
    local crewList = lwl.getAllMemberCrew(Hyperspace.ships.player)
    --Iterate over player ship
    for i=1,#crewList do
        local crewmem = crewList[i]
        local crewStat = getSpeciesStat(crewmem, statName)
        local species = crewmem:GetSpecies()
        local race = crewmem.extend:GetDefinition().race
        if crewStat > highest.stat then
            highest.stat = crewStat
            highest.species = species
            highest.race = race
        end
    end

    local statCategory = dvsd.TRAIT_DEFINITIONS[statName].category.internalName
    highest.stat = highest.stat + Hyperspace.playerVariables["DISCO_BOOST_"..statCategory] --Flat attribute boosts.
    return highest
end
--#endregion


--#region API

---comment
---@param statName string the name of the stat
---@return number the highest stat value among your ship and crew.
function mde.getStat(statName)
    return mde.getHighestStatSource(statName).stat
end

--#region Utils

function mde.calculate_probabilities(num_dice, sides)
    if num_dice == 0 then
        return {[0] = 1}  -- Base case: only one outcome with a sum of 0
    end
    -- Get probabilities for one less die
    local prev_probs = mde.calculate_probabilities(num_dice - 1, sides)
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
function mde.probability_greater_than(num_dice, sides, target)
    local probs = mde.calculate_probabilities(num_dice, sides)
    local total_prob = 0
    for sum, prob in pairs(probs) do
        if sum > target then
            total_prob = total_prob + prob
        end
    end
    return math.ceil(total_prob * 100)
end

function mde.skillFromName(skillName)
    local traitDef = dvsd.TRAIT_DEFINITIONS[skillName]
    if (traitDef == nil) then
        error("Disco Engine: Invalid skill "..skillName)
    end
    local skilDef = traitDef.definition
    return skilDef
end

--#endregion


--#endregion