mods.multiverseDiscoEngine = {}
local mde = mods.multiverseDiscoEngine

local vter = mods.multiverse.vter
local lwl = mods.lightweight_lua
local Brightness = mods.brightness

local LOG_LEVEL = 5
local LOG_TAG = "mods.disco.core"

local global = Hyperspace.Global.GetInstance()
local soundControl = global:GetSoundControl()
--Earcons pending check results
local queuedCheckAVList = {}

--Registered events
local DISCO_EVENTS_LIST = {}


--[[
The goal of this is to create a system which can be used to inhect disco elysium-style checks/options into events.

Stretch goal: have each ship get a unique pilot buff set.  That's insane, but works in theory at least.

lazy calculation of stat totals, only do it when they're being checked.
we're about to get colored text, too.
THE patching order shouldn't matter too much as this is all lua, but for safety put it after your content mods.

Something's negative sometimes, probably with my random number generation?   Like the room center?


Actually, this must be split into two parts.  The Multiverse Disco Engine, which goes at the very top as a library, and the Disco Content Packs, which go at the very end of your mod list, or at least below the mods with the events they're supposed to modify.

What I should release is the core, and a tiny mod that makes use of it as an example.

Issue: lua files get reloaded every so often, and can't be trusted to persist values.
Solution: an init variable that you check isn't false.  If it is, you make it true and append your items to the list here.

General mod order:
Multiverse
Libraries
Content
Meta content
QoL / Graphics
--]]


local CREW_STAT_DEFINITIONS = {

    HUMAN = {INTELLECT=3, logic=0, encylopedia=0, rhetoric=0, drama=0, conceptualization=0, visual_calculus=0, PSYCHE=3, volition=0, inland_empire=0, empathy=0, authority=0, espirit_de_corps=0, suggestion=0, PHYSIQUE=3, endurance=0, pain_threshold=0, physical_instrument=0, electrochemistry=0, shivers=0, half_light=0, MOTORICS=3, hand_eye_coordination=0, perception=0, reaction_speed=0, savoir_faire=0, interfacing=0, composure=0},
    HUMAN_ENGINEER = {INTELLECT=3, logic=1, encylopedia=1, conceptualization=1, PSYCHE=3, PHYSIQUE=3, MOTORICS=3, hand_eye_coordination=1, interfacing=1, composure=0},
    HUMAN_MEDIC = {INTELLECT=3, encylopedia=1, PSYCHE=3, empathy=1, PHYSIQUE=3, MOTORICS=3, hand_eye_coordination=1, interfacing=1, composure=1},
    HUMAN_SOLDIER = {INTELLECT=3, visual_calculus=1, PSYCHE=3, authority=1, espirit_de_corps=1, PHYSIQUE=3, endurance=1, pain_threshold=1, physical_instrument=1, half_light=1, MOTORICS=3, hand_eye_coordination=1, reaction_speed=1},
    HUMAN_MFK = {INTELLECT=6, PSYCHE=6, PHYSIQUE=6, MOTORICS=6},
    ENGI = {INTELLECT=4, logic=1, PSYCHE=3, empathy=-1, PHYSIQUE=1, MOTORICS=4, interfacing=1},
    ENGI_SEPERATIST = {INTELLECT=4, logic=1, PSYCHE=3, espirit_de_corps=-2, PHYSIQUE=1, MOTORICS=4, interfacing=1},
    ENGI_DEFENDER = {INTELLECT=4, logic=1, PSYCHE=3, PHYSIQUE=2, endurance=2, pain_threshold=2, MOTORICS=4, interfacing=1},
    ZOLTAN = {INTELLECT=3, PSYCHE=4, PHYSIQUE=2, MOTORICS=3},
    ROCK = {INTELLECT=3, PSYCHE=3, PHYSIQUE=4, endurance=1, pain_threshold=1, MOTORICS=2, composure=2},
    ROCK_OUTCAST = {INTELLECT=3, PSYCHE=3, espirit_de_corps=-1, PHYSIQUE=4, endurance=1, pain_threshold=1, MOTORICS=2, composure=2},
    ROCK_CULTIST = {INTELLECT=3, PSYCHE=3, inland_empire=1, PHYSIQUE=4, endurance=1, pain_threshold=1, MOTORICS=2, composure=2},
    ROCK_COMMANDO = {INTELLECT=3, PSYCHE=3, espirit_de_corps=1, PHYSIQUE=4, endurance=2, pain_threshold=1, MOTORICS=2, composure=2},
    ROCK_CRUSADER = {INTELLECT=3, PSYCHE=3, espirit_de_corps=1, PHYSIQUE=4, endurance=2, pain_threshold=1, MOTORICS=2},
    ROCK_PALADIN = {INTELLECT=3, PSYCHE=5, authority=2, espirit_de_corps=2, PHYSIQUE=6, endurance=3, pain_threshold=1, MOTORICS=2, composure=2},
    CRYSTAL = {INTELLECT=3, PSYCHE=4, PHYSIQUE=4, MOTORICS=3},
    CRYSTAL_SENTINAL = {INTELLECT=6, PSYCHE=6, PHYSIQUE=6, MOTORICS=6},
    CRYSTAL_LIBERATOR = {INTELLECT=6, PSYCHE=6, PHYSIQUE=6, MOTORICS=6},
    MANTIS = {INTELLECT=2, PSYCHE=2, PHYSIQUE=4, MOTORICS=1},
    FREE_MANTIS = {INTELLECT=2, PSYCHE=3, PHYSIQUE=4, MOTORICS=1},
    FREE_MANTIS_CHAOS = {INTELLECT=2, PSYCHE=3, PHYSIQUE=4, MOTORICS=1},
    FREE_MANTIS_WARLORD = {INTELLECT=3, PSYCHE=3, PHYSIQUE=5, MOTORICS=1},
    MANTIS_SUZERAIN = {INTELLECT=4, PSYCHE=3, PHYSIQUE=6, MOTORICS=2},
    MANTIS_BISHOP = {INTELLECT=4, PSYCHE=5, PHYSIQUE=7, MOTORICS=2},
    SLUG = {INTELLECT=4, PSYCHE=4, PHYSIQUE=3, MOTORICS=3},
    SLUG_HEKTAR = {INTELLECT=4, PSYCHE=4, PHYSIQUE=3, MOTORICS=3},
    SLUG_SABOTUER = {INTELLECT=4, PSYCHE=6, PHYSIQUE=5, MOTORICS=6},
    SLUG_RANGER = {INTELLECT=5, PSYCHE=6, PHYSIQUE=6, MOTORICS=6},
    SLUG_CLANSMAN = {INTELLECT=5, PSYCHE=5, PHYSIQUE=5, MOTORICS=5},
    KNIGHT_OF_NIGHTS = {INTELLECT=7, PSYCHE=7, PHYSIQUE=7, MOTORICS=7},
    ORCHID = {INTELLECT=3, PSYCHE=3, PHYSIQUE=3, electrochemistry=1, MOTORICS=3},
    ORCHID_PRAETOR = {INTELLECT=3, logic=1, encylopedia=1, rhetoric=1, drama=1, PSYCHE=4, empathy=-1, authority=1, PHYSIQUE=3, pain_threshold=-1, MOTORICS=3, composure=1},
    ORCHID_CARETAKER = {INTELLECT=3, encylopedia=1, rhetoric=1, conceptualization=1, visual_calculus=1, PSYCHE=3, empathy=1, PHYSIQUE=3, electrochemistry=1, MOTORICS=3, composure=1},
    VAMPWEED = {INTELLECT=3, PSYCHE=3, PHYSIQUE=3, electrochemistry=1, MOTORICS=3},
    ORCHID_CULTIVATOR = {INTELLECT=3, encylopedia=1, rhetoric=1, conceptualization=1, visual_calculus=1, PSYCHE=3, empathy=1, PHYSIQUE=3, electrochemistry=1, MOTORICS=3, composure=1},
    SHELL = {INTELLECT=5, PSYCHE=3, PHYSIQUE=2, electrochemistry=2, MOTORICS=3},
    SHELL_SCIENTIST = {INTELLECT=6, PSYCHE=3, PHYSIQUE=2, electrochemistry=2, MOTORICS=3},
    SHELL_MECHANIC = {INTELLECT=5, PSYCHE=3, PHYSIQUE=2, electrochemistry=1, MOTORICS=4},
    SHELL_GUARDIAN = {INTELLECT=5, PSYCHE=3, PHYSIQUE=5, electrochemistry=2, MOTORICS=3},
    SHELL_RADIANT = {INTELLECT=5, PSYCHE=5, PHYSIQUE=4, electrochemistry=2, MOTORICS=5},
    LEECH = {INTELLECT=3, PSYCHE=2, PHYSIQUE=2, MOTORICS=4, composure=-1},
    AMPERE = {INTELLECT=3, PSYCHE=2, PHYSIQUE=3, MOTORICS=4, composure=-1},
    SIREN = {INTELLECT=3, PSYCHE=4, inland_empire=2, PHYSIQUE=3, MOTORICS=3},
    HARPY = {INTELLECT=3, PSYCHE=5, inland_empire=3, PHYSIQUE=4, MOTORICS=3},
    LANIUS = {INTELLECT=3, PSYCHE=3, PHYSIQUE=4, MOTORICS=4},
    WELDER = {INTELLECT=3, PSYCHE=3, PHYSIQUE=4, MOTORICS=5},
    AUGMENTED = {INTELLECT=5, PSYCHE=3, PHYSIQUE=4, MOTORICS=4},
    GHOST = {INTELLECT=3, PSYCHE=3, PHYSIQUE=3, MOTORICS=3},
    GHOST_BIG = {INTELLECT=4, PSYCHE=4, PHYSIQUE=5, MOTORICS=3},
    GAS_HATCHLING = {INTELLECT=1, PSYCHE=2, PHYSIQUE=1, MOTORICS=0},
    GAS_ADULT = {INTELLECT=2, PSYCHE=4, PHYSIQUE=5, MOTORICS=1},
    GAS_WEAVER = {INTELLECT=5, PSYCHE=6, PHYSIQUE=4, MOTORICS=7},
    GAS_VENOM = {INTELLECT=2, PSYCHE=3, PHYSIQUE=4, electrochemistry=2, MOTORICS=4},
    GAS_QUEEN = {INTELLECT=6, PSYCHE=7, PHYSIQUE=10, MOTORICS=6},
    LIZARD = {INTELLECT=2, PSYCHE=3, PHYSIQUE=4, MOTORICS=4},
    PONY = {INTELLECT=1, PSYCHE=4, PHYSIQUE=5, MOTORICS=4},
    PONY_TAMED = {INTELLECT=3, PSYCHE=4, PHYSIQUE=5, MOTORICS=4},
    PONY_CRYSTAL = {INTELLECT=4, PSYCHE=5, PHYSIQUE=5, MOTORICS=5},
    PONY_ENGI = {INTELLECT=3, PSYCHE=4, PHYSIQUE=6, MOTORICS=4},
    COGNITIVE = {INTELLECT=3, PSYCHE=0, PHYSIQUE=6, MOTORICS=4},
    COGNITIVE_AUTOMATED = {INTELLECT=3, PSYCHE=4, PHYSIQUE=6, MOTORICS=4},
    COGNITIVE_ADVANCED = {INTELLECT=8, PSYCHE=0, PHYSIQUE=6, MOTORICS=4},
    COGNITIVE_ADVANCED_AUTOMATED = {INTELLECT=8, PSYCHE=4, PHYSIQUE=6, MOTORICS=4},
    OBELISK = {INTELLECT=6, PSYCHE=4, PHYSIQUE=6, MOTORICS=4},
    OBELISK_ROYAL = {INTELLECT=7, PSYCHE=6, PHYSIQUE=6, physical_instrument=1, MOTORICS=4, composure=3},
    DEEP_ONE = {INTELLECT=5, PSYCHE=4, PHYSIQUE=5, MOTORICS=4},
    DEEP_ONE_CULTIST = {INTELLECT=4, PSYCHE=4, PHYSIQUE=5, MOTORICS=4},
    THE_SCARRED = {INTELLECT=5, PSYCHE=6, PHYSIQUE=6, MOTORICS=4},
    THE_SCARRED_ASCENDED = {INTELLECT=5, PSYCHE=10, PHYSIQUE=6, MOTORICS=6},
    ENLIGHTENED_HORROR = {INTELLECT=3, PSYCHE=8, PHYSIQUE=6, MOTORICS=4},
    --PONY_ENGI = {INTELLECT=3, PSYCHE=4, PHYSIQUE=6, MOTORICS=4},





    --Uniques
    TULLY = {INTELLECT=7, PSYCHE=7, PHYSIQUE=5, MOTORICS=7},
    HAYNES = {INTELLECT=9, PSYCHE=7, PHYSIQUE=5, electrochemistry=4, MOTORICS=6, perception=3, interfacing=-1, composure=2},
    JERRY = {INTELLECT=3, PSYCHE=3, empathy=6, PHYSIQUE=3, MOTORICS=3},
    JERRY_GUN = {INTELLECT=3, PSYCHE=3, empathy=6, PHYSIQUE=9, electrochemistry=-5, MOTORICS=9},
    JERRY_PONY = {INTELLECT=3, PSYCHE=3, empathy=6, PHYSIQUE=10, MOTORICS=10}, --TODO REPLACE
    JERRY_PONY_CRYSTAL = {INTELLECT=3, PSYCHE=3, empathy=6, PHYSIQUE=10, MOTORICS=11},
    ELLIE = {INTELLECT=3, PSYCHE=1, PHYSIQUE=5, MOTORICS=5},
    STEPHAN = {INTELLECT=3, PSYCHE=4, PHYSIQUE=5, MOTORICS=5},
    LEAH = {INTELLECT=3, PSYCHE=4, PHYSIQUE=3, MOTORICS=3},
    TURZIL = {INTELLECT=7, logic=1, encylopedia=1, rhetoric=1, PSYCHE=7, volition=1, authority=2, espirit_de_corps=2, PHYSIQUE=6, electrochemistry=-2, shivers=-2, MOTORICS=7, interfacing=1},
    DEVORAK = {INTELLECT=4, PSYCHE=6, authority=1, PHYSIQUE=5, endurance=1, pain_threshold=9, physical_instrument=1, half_light=1, MOTORICS=7},
    ANURAK = {INTELLECT=4, visual_calculus=0, PSYCHE=7, empathy=1, PHYSIQUE=5, electrochemistry=1, MOTORICS=4, composure=2},
    KAZ = {INTELLECT=5, visual_calculus=2, PSYCHE=5, PHYSIQUE=7, MOTORICS=9}, --the greatest thief in the multiverse
    FREDDY = {INTELLECT=8, PSYCHE=8, PHYSIQUE=6, MOTORICS=6},
    SYMBIOTE = {INTELLECT=4, PSYCHE=4, PHYSIQUE=5, MOTORICS=2},
    VORTIGON = {INTELLECT=4, PSYCHE=4, PHYSIQUE=8, MOTORICS=4},
    TUCO = {INTELLECT=3, PSYCHE=4, PHYSIQUE=6, MOTORICS=3},
    ARIADNE = {INTELLECT=6, PSYCHE=6, PHYSIQUE=6, MOTORICS=4},
    RUWEN = {INTELLECT=7, PSYCHE=6, PHYSIQUE=5, MOTORICS=4},
    DIANESH = {INTELLECT=7, PSYCHE=6, PHYSIQUE=5, MOTORICS=4},
    OBYN = {INTELLECT=5, PSYCHE=6, PHYSIQUE=6, MOTORICS=4},
    BILLY = {INTELLECT=6, PSYCHE=6, PHYSIQUE=4, MOTORICS=4},
    NIGHTS = {INTELLECT=6, PSYCHE=8, PHYSIQUE=6, MOTORICS=6},
    SLOCKNOG = {INTELLECT=5, PSYCHE=6, PHYSIQUE=5, MOTORICS=6},
    IRWIN = {INTELLECT=5, PSYCHE=6, PHYSIQUE=7, MOTORICS=5},
    IRWIN_DEMON = {INTELLECT=5, PSYCHE=8, PHYSIQUE=9, MOTORICS=5},
    SYLVAN = {INTELLECT=8, PSYCHE=11, PHYSIQUE=10, MOTORICS=9},
    TONY_SR = {INTELLECT=3, PSYCHE=2, PHYSIQUE=2, endurance=5, MOTORICS=2},--a sad sack of a man
    TYREDO = {INTELLECT=4, PSYCHE=3, PHYSIQUE=4, MOTORICS=5}, --Just copy his stats to the bird to avoid dumb dillution
    ALKRAM = {INTELLECT=4, PSYCHE=5, PHYSIQUE=6, MOTORICS=7},
    ALKALI = {INTELLECT=7, PSYCHE=6, PHYSIQUE=4, MOTORICS=6},
    OOJ_MAJOO = {INTELLECT=5, PSYCHE=7, PHYSIQUE=6, MOTORICS=7},
    ANNOINTED = {INTELLECT=9, PSYCHE=9, PHYSIQUE=9, MOTORICS=9},
    BEACON_EATER = {INTELLECT=5, PSYCHE=7, PHYSIQUE=9, MOTORICS=7},
    DESSIUS = {INTELLECT=7, PSYCHE=9, PHYSIQUE=8, MOTORICS=7},
    GUNTPUT = {INTELLECT=4, PSYCHE=7, PHYSIQUE=6, MOTORICS=7},
    METYUNT = {INTELLECT=5, PSYCHE=4, PHYSIQUE=4, MOTORICS=4},
    WITHER = {INTELLECT=6, PSYCHE=6, PHYSIQUE=6, MOTORICS=3},
    TYEREL = {INTELLECT=6, PSYCHE=6, PHYSIQUE=6, MOTORICS=5},
    MAYEB = {INTELLECT=5, encylopedia=1, rhetoric=1, conceptualization=1, visual_calculus=1, PSYCHE=5, empathy=1, PHYSIQUE=3, electrochemistry=1, MOTORICS=4, composure=1},
    IVAR = {INTELLECT=4, PSYCHE=5, PHYSIQUE=5, MOTORICS=4},
    THEST = {INTELLECT=6, PSYCHE=10, PHYSIQUE=6, MOTORICS=6},
    CORBY = {INTELLECT=10, PSYCHE=6, PHYSIQUE=6, MOTORICS=6},
    WAKESON = {INTELLECT=6, PSYCHE=6, PHYSIQUE=10, MOTORICS=6},
    --PONY =
    BATTLE_DRONE = {INTELLECT=3, PSYCHE=4, PHYSIQUE=5, MOTORICS=4},
    BATTLE_DRONE_2 = {INTELLECT=3, PSYCHE=4, PHYSIQUE=7, MOTORICS=5},
    ION_INTRUDER = {INTELLECT=3, PSYCHE=5, PHYSIQUE=6, MOTORICS=5},
    REPAIR_DRONE = {INTELLECT=3, PSYCHE=3, PHYSIQUE=3, MOTORICS=4},
    DOCTOR_DRONE = {INTELLECT=6, PSYCHE=5, PHYSIQUE=3, MOTORICS=5},
    MANAGER_DRONE = {INTELLECT=4, PSYCHE=3, PHYSIQUE=2, MOTORICS=2},
    RECON_DRONE = {INTELLECT=2, PSYCHE=2, PHYSIQUE=2, MOTORICS=5},
    CONSTRUCTOR_DRONE = {INTELLECT=2, PSYCHE=2, PHYSIQUE=3, MOTORICS=4},
    PRODUCER_DRONE = {INTELLECT=2, PSYCHE=4, PHYSIQUE=3, MOTORICS=2},
    GRAZIER_DRONE = {INTELLECT=2, PSYCHE=2, PHYSIQUE=5, MOTORICS=2},
    ATOM_DRONE = {INTELLECT=2, PSYCHE=2, PHYSIQUE=3, physical_instrument=5, MOTORICS=5},
    DIRECTOR_DRONE = {INTELLECT=6, PSYCHE=5, PHYSIQUE=3, MOTORICS=3},
    MENDER_DRONE = {INTELLECT=5, PSYCHE=3, PHYSIQUE=3, MOTORICS=7},
    A5540L3 = {INTELLECT=8, PSYCHE=7, PHYSIQUE=7, MOTORICS=5},
    GANA_DRONE = {INTELLECT=7, PSYCHE=6, PHYSIQUE=6, MOTORICS=5},
    ROOMBA = {INTELLECT=2, PSYCHE=2, PHYSIQUE=2, MOTORICS=2}
    --PONY =
}



--Base crew get 12 total stats.  Elite/Unique can have more.
--todo get all the names for the keys of this table
CREW_STAT_TABLE = {
    PLAYER={},
    --human has all of the traits for copying purposes, lowercase numbers are modifiers so human has 3s across the board.
    human=CREW_STAT_DEFINITIONS.HUMAN,
    human_humanoid=CREW_STAT_DEFINITIONS.HUMAN,
    human_engineer=CREW_STAT_DEFINITIONS.HUMAN_ENGINEER,
    human_medic=CREW_STAT_DEFINITIONS.HUMAN_MEDIC,
    human_rebel_medic=CREW_STAT_DEFINITIONS.HUMAN_MEDIC,
    human_soldier=CREW_STAT_DEFINITIONS.HUMAN_SOLDIER,
    human_technician=CREW_STAT_DEFINITIONS.HUMAN_ENGINEER,
    human_mfk=CREW_STAT_DEFINITIONS.HUMAN_MFK,
    human_legion={INTELLECT=7, PSYCHE=7, PHYSIQUE=7,  MOTORICS=7},
    human_legion_pyro={INTELLECT=7, PSYCHE=7, drama=1, PHYSIQUE=7, half_light=1, MOTORICS=7},
    unique_cyra=CREW_STAT_DEFINITIONS.HUMAN_MFK,--TODO
    unique_tully=CREW_STAT_DEFINITIONS. TULLY,
    unique_vance={INTELLECT=7, PSYCHE=7, PHYSIQUE=5, MOTORICS=7},
    unique_haynes=CREW_STAT_DEFINITIONS.HAYNES,
    unique_jerry=CREW_STAT_DEFINITIONS.JERRY,
    unique_jerry_gun=CREW_STAT_DEFINITIONS.JERRY_GUN,
    unique_jerry_pony=CREW_STAT_DEFINITIONS.JERRY_PONY,
    unique_jerry_pony_crystal=CREW_STAT_DEFINITIONS.JERRY_PONY_CRYSTAL,
    unique_leah=CREW_STAT_DEFINITIONS.LEAH,
    unique_leah_mfk=CREW_STAT_DEFINITIONS.HUMAN_MFK,--TODO
    unique_ellie=CREW_STAT_DEFINITIONS.ELLIE,
    unique_ellie_stephan=CREW_STAT_DEFINITIONS.STEPHAN,
    unique_ellie_lvl1={INTELLECT=3, PSYCHE=1, PHYSIQUE=5, MOTORICS=5},
    unique_ellie_lvl2={INTELLECT=3, PSYCHE=1, PHYSIQUE=6, MOTORICS=5},
    unique_ellie_lvl3={INTELLECT=3, PSYCHE=0, PHYSIQUE=6, MOTORICS=6},
    unique_ellie_lvl4={INTELLECT=3, PSYCHE=-1, PHYSIQUE=7, MOTORICS=6},
    unique_ellie_lvl5={INTELLECT=3, PSYCHE=-2, PHYSIQUE=8, MOTORICS=6},
    unique_ellie_lvl6={INTELLECT=3, PSYCHE=-3, PHYSIQUE=9, MOTORICS=6},
    human_angel={INTELLECT=6, PSYCHE=7, PHYSIQUE=6, MOTORICS=7},
    --Orchid
    orchid=CREW_STAT_DEFINITIONS.ORCHID,
    orchid_caretaker=CREW_STAT_DEFINITIONS.ORCHID_CARETAKER,
    orchid_praetor=CREW_STAT_DEFINITIONS.ORCHID_PRAETOR,
    orchid_vampweed=CREW_STAT_DEFINITIONS.VAMPWEED,
    orchid_cultivator=CREW_STAT_DEFINITIONS.ORCHID_CULTIVATOR,
    unique_tyerel=CREW_STAT_DEFINITIONS.TYEREL,
    unique_mayeb=CREW_STAT_DEFINITIONS.MAYEB,
    unique_ivar=CREW_STAT_DEFINITIONS.IVAR,
    --Engi
    engi=CREW_STAT_DEFINITIONS.ENGI,
    engi_separatist=CREW_STAT_DEFINITIONS.ENGI_SEPERATIST,
    engi_separatist_nano=CREW_STAT_DEFINITIONS.ENGI_SEPERATIST,
    engi_defender=CREW_STAT_DEFINITIONS.ENGI_DEFENDER,
    unique_turzil=CREW_STAT_DEFINITIONS.TURZIL,
    --Zoltan
    zoltan=CREW_STAT_DEFINITIONS.ZOLTAN,
    zoltan_monk={INTELLECT=3, conceptualization=1, PSYCHE=3, volition=1, inland_empire=2, empathy=1, suggestion=1, PHYSIQUE=3, pain_threshold=1, physical_instrument=1, electrochemistry=0, shivers=1, half_light=-2, MOTORICS=3, composure=2},
    zoltan_peacekeeper={INTELLECT=3, logic=0, PSYCHE=4, inland_empire=-1, PHYSIQUE=3, physical_instrument=1, half_light=1, MOTORICS=3, reaction_speed=1, composure=1},
    zoltan_devotee={INTELLECT=3, rhetoric=1, drama=1, PSYCHE=3, volition=2, PHYSIQUE=3, physical_instrument=1, half_light=1, MOTORICS=3, reaction_speed=1, composure=-1}, --duskbringer
    zoltan_martyr={INTELLECT=3, rhetoric=1, drama=1, PSYCHE=3, volition=2, PHYSIQUE=3, physical_instrument=1, half_light=1, MOTORICS=3, reaction_speed=1, composure=-1},
    unique_devorak=CREW_STAT_DEFINITIONS.DEVORAK,
    unique_anurak=CREW_STAT_DEFINITIONS.ANURAK,
    zoltan_osmian=CREW_STAT_DEFINITIONS.ZOLTAN,--IDK
    --Rock
    rock=CREW_STAT_DEFINITIONS.ROCK,
    rock_outcast=CREW_STAT_DEFINITIONS.ROCK_OUTCAST,
    rock_cultist=CREW_STAT_DEFINITIONS.ROCK_CULTIST,
    rock_commando=CREW_STAT_DEFINITIONS.ROCK_COMMANDO,
    rock_crusader=CREW_STAT_DEFINITIONS.ROCK_CRUSADER,
    rock_paladin=CREW_STAT_DEFINITIONS.ROCK_PALADIN,
    --rock_elder=CREW_STAT_DEFINITIONS.,
    unique_symbiote=CREW_STAT_DEFINITIONS.SYMBIOTE,
    unique_vortigon=CREW_STAT_DEFINITIONS.VORTIGON,
    unique_tuco=CREW_STAT_DEFINITIONS.TUCO,
    unique_ariadne=CREW_STAT_DEFINITIONS.ARIADNE,
    --Mantis
    mantis=CREW_STAT_DEFINITIONS.MANTIS,
    mantis_suzerain=CREW_STAT_DEFINITIONS.MANTIS_SUZERAIN,
    mantis_free=CREW_STAT_DEFINITIONS.FREE_MANTIS,
    mantis_free_chaos=CREW_STAT_DEFINITIONS.FREE_MANTIS_CHAOS,
    mantis_warlord=CREW_STAT_DEFINITIONS.FREE_MANTIS_WARLORD,
    mantis_bishop=CREW_STAT_DEFINITIONS.MANTIS_BISHOP,
    unique_kaz=CREW_STAT_DEFINITIONS.KAZ,
    unique_freddy=CREW_STAT_DEFINITIONS.FREDDY,
    unique_freddy_fedora=CREW_STAT_DEFINITIONS.FREDDY,
    unique_freddy_jester=CREW_STAT_DEFINITIONS.FREDDY,
    unique_freddy_sombrero=CREW_STAT_DEFINITIONS.FREDDY,
    unique_freddy_twohats=CREW_STAT_DEFINITIONS.FREDDY,
    --Crystal
    crystal=CREW_STAT_DEFINITIONS.CRYSTAL,
    crystal_liberator=CREW_STAT_DEFINITIONS.CRYSTAL_LIBERATOR,
    crystal_sentinel=CREW_STAT_DEFINITIONS.CRYSTAL_SENTINAL,
    unique_ruwen=CREW_STAT_DEFINITIONS.RUWEN,
    unique_dianesh=CREW_STAT_DEFINITIONS.DIANESH,
    unique_obyn=CREW_STAT_DEFINITIONS.OBYN,
    nexus_obyn_cel=CREW_STAT_DEFINITIONS.OBYN,
    --Slug
    slug=CREW_STAT_DEFINITIONS.SLUG,
    slug_hektar=CREW_STAT_DEFINITIONS.SLUG_HEKTAR,
    slug_hektar_box=CREW_STAT_DEFINITIONS.SLUG_HEKTAR,
    slug_saboteur=CREW_STAT_DEFINITIONS.SLUG_SABOTUER,
    slug_clansman=CREW_STAT_DEFINITIONS.SLUG_CLANSMAN,
    slug_ranger=CREW_STAT_DEFINITIONS.SLUG_RANGER,
    slug_knight=CREW_STAT_DEFINITIONS.KNIGHT_OF_NIGHTS,
    unique_billy=CREW_STAT_DEFINITIONS.BILLY,
    unique_billy_box=CREW_STAT_DEFINITIONS.BILLY,
    unique_nights=CREW_STAT_DEFINITIONS.NIGHTS,
    unique_slocknog=CREW_STAT_DEFINITIONS.SLOCKNOG,
    unique_irwin=CREW_STAT_DEFINITIONS.IRWIN,
    unique_irwin_demon=CREW_STAT_DEFINITIONS.IRWIN_DEMON,
    unique_sylvan=CREW_STAT_DEFINITIONS.SYLVAN,
    --todo I don't know enough about these, giving them all sylvan stats for now.
    nexus_sylvan_cel=CREW_STAT_DEFINITIONS.SYLVAN,
    nexus_sylvan_gman=CREW_STAT_DEFINITIONS.SYLVAN,
    bucket=CREW_STAT_DEFINITIONS.SYLVAN,
    sylvanrick=CREW_STAT_DEFINITIONS.SYLVAN,
    sylvansans=CREW_STAT_DEFINITIONS.SYLVAN,
    saltpapy=CREW_STAT_DEFINITIONS.SYLVAN,
    sylvanleah=CREW_STAT_DEFINITIONS.SYLVAN,
    sylvanrebel=CREW_STAT_DEFINITIONS.SYLVAN,
    dylan=CREW_STAT_DEFINITIONS.SYLVAN,
    nexus_pants=CREW_STAT_DEFINITIONS.SYLVAN,
    prime=CREW_STAT_DEFINITIONS.SYLVAN,--TODO
    sylvan1d=CREW_STAT_DEFINITIONS.SYLVAN,
    sylvanclan=CREW_STAT_DEFINITIONS.SYLVAN,
    beans=CREW_STAT_DEFINITIONS.SYLVAN,
    --Leech
    leech=CREW_STAT_DEFINITIONS.LEECH,
    leech_ampere=CREW_STAT_DEFINITIONS.AMPERE,
    unique_tonysr=CREW_STAT_DEFINITIONS.TONY_SR,
    unique_tyrdeo=CREW_STAT_DEFINITIONS.TYREDO,
    unique_tyrdeo_bird=CREW_STAT_DEFINITIONS.TYREDO,
    unique_alkram=CREW_STAT_DEFINITIONS.ALKRAM,
    --Siren
    siren=CREW_STAT_DEFINITIONS.SIREN,
    siren_harpy=CREW_STAT_DEFINITIONS.HARPY,
    --Shell
    shell=CREW_STAT_DEFINITIONS.SHELL,
    shell_scientist=CREW_STAT_DEFINITIONS.SHELL_SCIENTIST,
    shell_mechanic=CREW_STAT_DEFINITIONS.SHELL_MECHANIC,
    shell_guardian=CREW_STAT_DEFINITIONS.SHELL_GUARDIAN,
    shell_radiant=CREW_STAT_DEFINITIONS.SHELL_RADIANT,
    unique_alkali=CREW_STAT_DEFINITIONS.ALKALI,
    --Lanius
    lanius=CREW_STAT_DEFINITIONS.LANIUS,
    lanius_welder=CREW_STAT_DEFINITIONS.WELDER,
    lanius_augmented=CREW_STAT_DEFINITIONS.AUGMENTED,
    unique_anointed=CREW_STAT_DEFINITIONS.ANNOINTED,
    unique_eater=CREW_STAT_DEFINITIONS.BEACON_EATER,
    --Ghost
    phantom=CREW_STAT_DEFINITIONS.GHOST,
    phantom_alpha=CREW_STAT_DEFINITIONS.GHOST_BIG,
    phantom_goul=CREW_STAT_DEFINITIONS.GHOST,
    phantom_goul_alpha=CREW_STAT_DEFINITIONS.GHOST_BIG,
    phantom_mare=CREW_STAT_DEFINITIONS.GHOST,
    phantom_mare_alpha=CREW_STAT_DEFINITIONS.GHOST_BIG,
    phantom_wraith=CREW_STAT_DEFINITIONS.GHOST,
    phantom_wraith_alpha=CREW_STAT_DEFINITIONS.GHOST_BIG,
    unique_dessius=CREW_STAT_DEFINITIONS.DESSIUS,
    --[[
    gbeleanor
    gbscoleri
    gbslimer
    gbpsych
    gbvinz
    gbzuul
    --]]
    --Spider
    spider=CREW_STAT_DEFINITIONS.GAS_ADULT,
    spider_weaver=CREW_STAT_DEFINITIONS.GAS_WEAVER,
    spider_hatch=CREW_STAT_DEFINITIONS.GAS_HATCHLING,
    unique_queen=CREW_STAT_DEFINITIONS.GAS_QUEEN, --El spidro guigante
    spider_venom=CREW_STAT_DEFINITIONS.GAS_VENOM,
    spider_venom_chaosm=CREW_STAT_DEFINITIONS.GAS_VENOM,
    tinybug=nil,
    --Lizard thing
    lizard=CREW_STAT_DEFINITIONS.LIZARD,
    unique_guntput=CREW_STAT_DEFINITIONS.GUNTPUT,
    unique_metyunt=CREW_STAT_DEFINITIONS.METYUNT,
    --Pony
    pony=CREW_STAT_DEFINITIONS.PONY,
    pony_tamed=CREW_STAT_DEFINITIONS.PONY_TAMED,
    ponyc=CREW_STAT_DEFINITIONS.PONY_CRYSTAL,
    pony_engi=CREW_STAT_DEFINITIONS.PONY_ENGI,
    pony_engi_nano=CREW_STAT_DEFINITIONS.PONY_ENGI,
    pony_engi_chaos=CREW_STAT_DEFINITIONS.PONY_ENGI,
    pony_engi_nano_chaos=CREW_STAT_DEFINITIONS.PONY_ENGI,
    --Cognitive
    cognitive=CREW_STAT_DEFINITIONS.COGNITIVE,
    cognitive_automated=CREW_STAT_DEFINITIONS.COGNITIVE_AUTOMATED,
    cognitive_advanced=CREW_STAT_DEFINITIONS.COGNITIVE_ADVANCED,
    cognitive_advanced_automated=CREW_STAT_DEFINITIONS.COGNITIVE_ADVANCED_AUTOMATED,
    --todo FR cogs
    --Obelisk
    obelisk=CREW_STAT_DEFINITIONS.OBELISK,
    obelisk_royal=CREW_STAT_DEFINITIONS.OBELISK_ROYAL,
    unique_wither=CREW_STAT_DEFINITIONS.WITHER,
    -- :)
    --[[eldritch_cat
    eldritch_thing
    eldritch_thing_noclone
    eldritch_thing_weak
    gnome--]]
    --Judges
    unique_judge_thest=CREW_STAT_DEFINITIONS.THEST,
    unique_judge_corby=CREW_STAT_DEFINITIONS.CORBY,
    unique_judge_wakeson=CREW_STAT_DEFINITIONS.WAKESON,
    --Dronesss
    a55=CREW_STAT_DEFINITIONS.A5540L3,
    gana=CREW_STAT_DEFINITIONS.GANA_DRONE,
    battle=CREW_STAT_DEFINITIONS.ION_INTRUDER,
    drone_battle=CREW_STAT_DEFINITIONS.BATTLE_DRONE,--[[
    drone_yinyang
    drone_yinyang_chaos
    loot_separatist_1 --idk
    drone_battle2=CREW_STAT_DEFINITIONS.BATTLE_DRONE_2,
    repairboarder
    repair
    divrepair
    butler
    drone_recon=CREW_STAT_DEFINITIONS.RECON_DRONE,
    drone_recon_defense=CREW_STAT_DEFINITIONS.RECON_DRONE,
    doctor=CREW_STAT_DEFINITIONS.DOCTOR_DRONE,
    surgeon
    surgeon_chaos
    manning
    manningenemy=nil,
    drone_holodrone
    drone_holodrone_chaos--]]
    drone_vamp_constructor=CREW_STAT_DEFINITIONS.CONSTRUCTOR_DRONE,
    drone_vamp_producer=CREW_STAT_DEFINITIONS.PRODUCER_DRONE,
    drone_vamp_grazier=CREW_STAT_DEFINITIONS.GRAZIER_DRONE,
    mender=CREW_STAT_DEFINITIONS.MENDER_DRONE,
    menderr=CREW_STAT_DEFINITIONS.MENDER_DRONE,
    director=CREW_STAT_DEFINITIONS.DIRECTOR_DRONE,
    atom=CREW_STAT_DEFINITIONS.ATOM_DRONE,
    atomr=CREW_STAT_DEFINITIONS.ATOM_DRONE,
    roomba=CREW_STAT_DEFINITIONS.ROOMBA,
    --Morph
    blob={INTELLECT=3, PSYCHE=3, PHYSIQUE=3, MOTORICS=3},
    unique_ooj=CREW_STAT_DEFINITIONS.OOJ_MAJOO,
    unique_ooj_love=CREW_STAT_DEFINITIONS.OOJ_MAJOO,
    blobhuman=CREW_STAT_DEFINITIONS.HUMAN,
    blobzoltan=CREW_STAT_DEFINITIONS.ZOLTAN,
    blobrock=CREW_STAT_DEFINITIONS.ROCK,
    blobcrystal=CREW_STAT_DEFINITIONS.CRYSTAL,
    blobmantis=CREW_STAT_DEFINITIONS.MANTIS,
    blobfreemantis=CREW_STAT_DEFINITIONS.FREE_MANTIS,
    blobslug=CREW_STAT_DEFINITIONS.SLUG,
    bloborchid=CREW_STAT_DEFINITIONS.ORCHID,
    blobvampweed=CREW_STAT_DEFINITIONS.VAMPWEED,
    blobswarm=nil,
    blobshell=CREW_STAT_DEFINITIONS.SHELL,
    blobleech=CREW_STAT_DEFINITIONS.LEECH,
    blobhatch=CREW_STAT_DEFINITIONS.GAS_HATCHLING,
    blobspider=CREW_STAT_DEFINITIONS.GAS_ADULT,
    blobweaver=CREW_STAT_DEFINITIONS.GAS_WEAVER,
    bloblizard=CREW_STAT_DEFINITIONS.LIZARD,
    blobpony=CREW_STAT_DEFINITIONS.PONY,
    blobsalt=CREW_STAT_DEFINITIONS.ROCK,
    techno={INTELLECT=4, PSYCHE=3, PHYSIQUE=3, MOTORICS=4},
    technoengi=CREW_STAT_DEFINITIONS.ENGI,
    technolanius=CREW_STAT_DEFINITIONS.LANIUS,
    --technoancient
    --technoavatar --idk
    technobattle=CREW_STAT_DEFINITIONS.BATTLE_DRONE,  --they can do drones i guess
    technobattle2=CREW_STAT_DEFINITIONS.BATTLE_DRONE_2,
    technoboarderion=CREW_STAT_DEFINITIONS.ION_INTRUDER,
    technorepair=CREW_STAT_DEFINITIONS.REPAIR_DRONE,
    technodoctor=CREW_STAT_DEFINITIONS.DOCTOR_DRONE,
    technomanning=CREW_STAT_DEFINITIONS.MANAGER_DRONE,
    technorecon=CREW_STAT_DEFINITIONS.RECON_DRONE,
    technoconstructor=CREW_STAT_DEFINITIONS.CONSTRUCTOR_DRONE,
    technoproducer=CREW_STAT_DEFINITIONS.PRODUCER_DRONE,
    technograzier=CREW_STAT_DEFINITIONS.GRAZIER_DRONE,
    technoatom=CREW_STAT_DEFINITIONS.ATOM_DRONE,
    technodirector=CREW_STAT_DEFINITIONS.DIRECTOR_DRONE,
    technomender=CREW_STAT_DEFINITIONS.MENDER_DRONE,
    technoa55=CREW_STAT_DEFINITIONS.A5540L3,
    technogana=CREW_STAT_DEFINITIONS.GANA_DRONE,
    technoroomba=CREW_STAT_DEFINITIONS.ROOMBA,
    gold={INTELLECT=4, PSYCHE=4, PHYSIQUE=4, MOTORICS=4},
    goldsoldier=CREW_STAT_DEFINITIONS.HUMAN_SOLDIER,
    golddefend=CREW_STAT_DEFINITIONS.ENGI_DEFENDER,
    goldcrusader=CREW_STAT_DEFINITIONS.ROCK_CRUSADER,
    goldsentinel=CREW_STAT_DEFINITIONS.CRYSTAL_SENTINAL,
    goldsuzerain=CREW_STAT_DEFINITIONS.MANTIS_SUZERAIN,
    goldwarlord=CREW_STAT_DEFINITIONS.FREE_MANTIS_WARLORD,
    goldsabo=CREW_STAT_DEFINITIONS.SLUG_SABOTUER,
    goldwelder=CREW_STAT_DEFINITIONS.LANIUS_WELDER,
    goldpraetor=CREW_STAT_DEFINITIONS.ORCHID_PRAETOR,
    goldcultivator=CREW_STAT_DEFINITIONS.ORCHID_CULTIVATOR,
    --goldtoxic --shell
    goldampere=CREW_STAT_DEFINITIONS.LEECH_AMPERE,
    goldroyal=CREW_STAT_DEFINITIONS.OBELISK_ROYAL,
    goldqueen=CREW_STAT_DEFINITIONS.GAS_QUEEN,
    --EE?
    --[[
    eldritch_spawn
    --Forgotten Races
    snowman=CREW_STAT_DEFINITIONS.SNOWMAN,
    snowman_chaos=CREW_STAT_DEFINITIONS.SNOWMAN_CHAOS,
    fr_lavaman=CREW_STAT_DEFINITIONS.LAVAMAN,
    fr_commonwealth
    fr_spherax
    fr_unique_billvan=CREW_STAT_DEFINITIONS.SYLVAN,
    fr_unique_billvan_box=CREW_STAT_DEFINITIONS.SYLVAN,
    fr_unique_sammy=CREW_STAT_DEFINITIONS.SAMMY,
    fr_unique_sammy_buff=CREW_STAT_DEFINITIONS.SAMMY,
    
    fr_gozer
    fr_CE_avatar
    fr_errorman
    fr_sylvan_cel=CREW_STAT_DEFINITIONS.SYLVAN
    fr_obyn_cel=CREW_STAT_DEFINITIONS.OBYN
    fr_withered
    fr_enhanced
    fr_proto_cognitive
    fr_proto_cognitive_automated
    fr_experimental_cognitive
    fr_experimental_cognitive_automated
    fr_unique_mantis_queen --laarkip
    fr_salt
    fr_zoltan_osmian_hologram_weak
    fr_wither_hologram
    fr_specter
    fr_ghostly_drone
    fr_snowman_smart--]]
    fr_unique_leah_legion=CREW_STAT_DEFINITIONS.HUMAN_MFK,--EH
    --[[
    fr_reborn_g
    fr_reborn_aleenor
    fr_reborn_cleo
    fr_reborn_slimer
    fr_reborn_phys
    fr_reborn_vin
    fr_reborn_zulu
    fr_reformed_smoke
    fr_reformed_chills
    fr_reformed_pok
    fr_reformed_charror
    fr_reformed_leo
    fr_reformed_searak
    fr_watcher
    --]]
    fr_ghost_tully=CREW_STAT_DEFINITIONS.TULLY,
    fr_ghost_haynes=CREW_STAT_DEFINITIONS.HAYNES,
    fr_ghost_jerry=CREW_STAT_DEFINITIONS.JERRY,
    fr_ghost_ellie=CREW_STAT_DEFINITIONS.ELLIE,
    fr_ghost_stephan=CREW_STAT_DEFINITIONS.STEPHAN,
    fr_ghost_turzil=CREW_STAT_DEFINITIONS.TURZIL,
    fr_ghost_devorak=CREW_STAT_DEFINITIONS.DEVORAK,
    fr_ghost_anurak=CREW_STAT_DEFINITIONS.ANURAK,
    fr_ghost_kaz=CREW_STAT_DEFINITIONS.KAZ,
    fr_ghost_freddy=CREW_STAT_DEFINITIONS.FREDDY,
    fr_ghost_symbiote=CREW_STAT_DEFINITIONS.SYMBIOTE,
    fr_ghost_vortigon=CREW_STAT_DEFINITIONS.VORTIGON,
    fr_ghost_tuco=CREW_STAT_DEFINITIONS.TUCO,
    fr_ghost_ariadne=CREW_STAT_DEFINITIONS.ARIADNE,
    fr_ghost_ruwen=CREW_STAT_DEFINITIONS.RUWEN,
    fr_ghost_dianesh=CREW_STAT_DEFINITIONS.DIANESH,
    fr_ghost_obyn=CREW_STAT_DEFINITIONS.OBYN,
    fr_ghost_billy=CREW_STAT_DEFINITIONS.BILLY,
    fr_ghost_billy_box=CREW_STAT_DEFINITIONS.BILLY,
    fr_ghost_nights=CREW_STAT_DEFINITIONS.NIGHTS,
    fr_ghost_slocknog=CREW_STAT_DEFINITIONS.SLOCKNOG,
    fr_ghost_irwin=CREW_STAT_DEFINITIONS.IRWIN,
    fr_ghost_sylvan=CREW_STAT_DEFINITIONS.SYLVAN,
    fr_ghost_tonysr=CREW_STAT_DEFINITIONS.TONY_SR,
    fr_ghost_tyrdeo=CREW_STAT_DEFINITIONS.TYREDO,
    fr_ghost_alkram=CREW_STAT_DEFINITIONS.ALKRAM,
    fr_ghost_alkali=CREW_STAT_DEFINITIONS.ALKALI,
    fr_ghost_ooj=CREW_STAT_DEFINITIONS.OOJ_MAJOO,
    fr_ghost_anointed=CREW_STAT_DEFINITIONS.ANNOINTED,
    fr_ghost_eater=CREW_STAT_DEFINITIONS.BEACON_EATER,
    fr_ghost_dessius=CREW_STAT_DEFINITIONS.DESSIUS,
    fr_ghost_queen=CREW_STAT_DEFINITIONS.GAS_QUEEN,
    fr_ghost_guntput=CREW_STAT_DEFINITIONS.GUNTPUT,
    fr_ghost_metyunt=CREW_STAT_DEFINITIONS.METYUNT,
    fr_ghost_wither=CREW_STAT_DEFINITIONS.WITHER,
    --[[
    fr_bonus_augustus
    fr_bonus_augustus_enemy
    fr_bonus_sally_hatchling=CREW_STAT_DEFINITIONS.GAS_HATCHLING,
    fr_bonus_sally_adult=CREW_STAT_DEFINITIONS.GAS_ADULT,
    fr_bonus_sally_weaver=CREW_STAT_DEFINITIONS.GAS_WEAVER,
    fr_bonus_prince
    fr_bonus_prince_jerry
    fr_bonus_tririac
    --]]
    --FR Drones
    fr_atomc=CREW_STAT_DEFINITIONS.ATOM_DRONE,
    fr_menderc=CREW_STAT_DEFINITIONS.MENDER_DRONE,
    fr_directorc=CREW_STAT_DEFINITIONS.DIRECTOR_DRONE,
    fr_atomw=CREW_STAT_DEFINITIONS.ATOM_DRONE, --yellow
    fr_menderw=CREW_STAT_DEFINITIONS.MENDER_DRONE,
    fr_directorw=CREW_STAT_DEFINITIONS.DIRECTOR_DRONE,
    --pink?
    fr_ghostly_battledrone=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    fr_ghostly_battledrone_2=CREW_STAT_DEFINITIONS.BATTLE_DRONE_2,
    fr_cleo_spawn=nil,
    fr_technocwdirector=CREW_STAT_DEFINITIONS.DIRECTOR_DRONE,
    fr_technocwmender=CREW_STAT_DEFINITIONS.MENDER_DRONE,
    fr_technocwatom=CREW_STAT_DEFINITIONS.ATOM_DRONE,
    fr_copper_battledrone_1=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    fr_copper_battledrone_2=CREW_STAT_DEFINITIONS.BATTLE_DRONE_2,
    --Diamonds
    --[[
    fr_golden_diamond
    fr_copper_diamond
    fr_adamantine_diamond
    fr_golden_operator
    fr_copper_operator
    fr_adamantine_operator
    fr_techno_operator
    --Elemental Lanius
    fr_golden_lanius_1
    fr_golden_lanius_2
    fr_golden_lanius_3
    fr_copper_lanius
    fr_adamantine_lanius
    --morph
    fr_blob_diamond
    --Insurrection+ Selection
    ips_holo
    ips_unique_sona
    
    ips_drone_manner
    ips_technomanner
    cooking
    --]]
    
    --Darkest Desire
    --Deep Ones
    deepone=CREW_STAT_DEFINITIONS.DEEP_ONE,
    deeponecultist=CREW_STAT_DEFINITIONS.DEEP_ONE_CULTIST,
    unique_thescarred=CREW_STAT_DEFINITIONS.THE_SCARRED,
    unique_thescarredascended=CREW_STAT_DEFINITIONS.THE_SCARRED_ASCENDED,
    enlightened_horror=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,----like hektar, not doing all these right now.
    enlightened_horror_a=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_b=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_c=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_ad=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_ae=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_af=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_ag=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_bd=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_be=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_bf=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_bg=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_cd=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_ce=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_cf=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_cg=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_adj=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_aej=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_afj=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_agj=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_bdj=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_bej=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_bfj=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_bgj=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_cdj=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_cej=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_cfj=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    enlightened_horror_cgj=CREW_STAT_DEFINITIONS.ENLIGHTENED_HORROR,
    ddnightmare_rift=nil,
    ddnightmare_rift_a=nil,
    ddnightmare_rift_b=nil,
    ddnightmare_rift_c=nil,
    ddnightmare_rift_ad=nil,
    ddnightmare_rift_ae=nil,
    ddnightmare_rift_af=nil,
    ddnightmare_rift_ag=nil,
    ddnightmare_rift_bd=nil,
    ddnightmare_rift_be=nil,
    ddnightmare_rift_bf=nil,
    ddnightmare_rift_bg=nil,
    ddnightmare_rift_cd=nil,
    ddnightmare_rift_ce=nil,
    ddnightmare_rift_cf=nil,
    ddnightmare_rift_cg=nil,
    ddnightmare_rift_adj=nil,
    ddnightmare_rift_aej=nil,
    ddnightmare_rift_afj=nil,
    ddnightmare_rift_agj=nil,
    ddnightmare_rift_bdj=nil,
    ddnightmare_rift_bej=nil,
    ddnightmare_rift_bfj=nil,
    ddnightmare_rift_bgj=nil,
    ddnightmare_rift_cdj=nil,
    ddnightmare_rift_cej=nil,
    ddnightmare_rift_cfj=nil,
    ddnightmare_rift_cgj=nil,
    spacetear=nil,
    darkgodtendrils=nil,
    nightmarish_crawler=nil,--TODO MAYBE ILL ADD THESE
    nightmarish_terror=nil,
    nightmarish_priest=nil,
    nightmarish_greaterpriest=nil,
    nightmarish_stalker=nil,
    nightmarish_engi=nil,
    nightmarish_greatercrawler=nil,
    nightmarish_mass=nil,
    nightmarish_greatermass=nil,
    nightmarish_martyr=nil,
    nightmarish_greatermartyr=nil,
    --[[
    --Morph
    blobdeepone
    happyholidays
    happyholidays_healing
    --Engi
    disparity_liberator
    ddseraph_engi
    ddseraph_arbiter
    disparity_broodmother
    disparity_engidefault
    disparity_engidefault_beacon
    disparity_engispeed
    disparity_engispeed_beacon
    disparity_engiattack
    disparity_engiattack_beacon
    disparity_engidefense
    disparity_engidefense_beacon
    disparity_engihazard
    disparity_engihazard_beacon
    unique_thehunger
    disparity_thehunger_beacon
    disparity_engirainbow_beacon--]]
    
    --Hektar Expansion
    slug_hektar_elite=CREW_STAT_DEFINITIONS.SLUG_HEKTAR,--eh
    modular_dronebattle_base_base=CREW_STAT_DEFINITIONS.BATTLE_DRONE, --Eventually I'll replace this with individual ones.
    modular_dronebattle_base_bio=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_base_stun=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_base_lockdown=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_base_pierce=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_base_cooldown=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_accuracy_base=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_accuracy_bio=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_accuracy_stun=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_accuracy_lockdown=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_accuracy_pierce=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_accuracy_cooldown=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_fire_base=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_fire_bio=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_fire_stun=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_fire_lockdown=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_fire_pierce=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_fire_cooldown=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_hull_base=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_hull_bio=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_hull_stun=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_hull_lockdown=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_hull_pierce=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_hull_cooldown=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    modular_dronebattle_power_base=CREW_STAT_DEFINITIONS.BATTLE_DRONE_2,--battle2
    modular_dronebattle_power_bio=CREW_STAT_DEFINITIONS.BATTLE_DRONE_2,
    modular_dronebattle_power_stun=CREW_STAT_DEFINITIONS.BATTLE_DRONE_2,
    modular_dronebattle_power_lockdown=CREW_STAT_DEFINITIONS.BATTLE_DRONE_2,
    modular_dronebattle_power_pierce=CREW_STAT_DEFINITIONS.BATTLE_DRONE_2,
    modular_dronebattle_power_cooldown=CREW_STAT_DEFINITIONS.BATTLE_DRONE_2,
    
    --ARI_MECH  I don't know what the fuck that thing is
    --[[
    mutant
    clone_soldier
    
    drone_extinguisher
    drone_battery
    drone_overcharger
    
    --TNE
    tne_drone_twin
    tne_drone_twin_2
    tne_drone_pod
    tne_drone_peace
    tne_drone_exothermic
    tne_drone_vent
    tne_drone_discharge
    tne_drone_shipwrecker
    
    --AEA
    aea_acid_soldier
    aea_acid_captain
    aea_acid_bill
    aea_necro_engi
    aea_necro_lich
    aea_necro_king --
    aea_old_1
    aea_old_unique_1
    aea_old_unique_2
    aea_old_unique_3
    aea_old_unique_4
    aea_old_unique_5
    aea_bird_avali
    aea_bird_illuminant
    aea_bird_unique
    --]]
    fff_f22={INTELLECT=3, logic=0, encylopedia=0, rhetoric=0, drama=0, conceptualization=0, visual_calculus=1, PSYCHE=2, volition=0, inland_empire=0, empathy=0, authority=0, espirit_de_corps=3, suggestion=0, PHYSIQUE=4, endurance=0, pain_threshold=1, physical_instrument=0, electrochemistry=0, shivers=0, half_light=-1, MOTORICS=2, hand_eye_coordination=-1, perception=0, reaction_speed=8, savoir_faire=0, interfacing=0, composure=-2},
    fff_buffer={INTELLECT=3, logic=0, encylopedia=0, rhetoric=-1, drama=3, conceptualization=3, visual_calculus=0, PSYCHE=4, volition=0, inland_empire=0, empathy=0, authority=0, espirit_de_corps=0, suggestion=0, PHYSIQUE=3, endurance=0, pain_threshold=0, physical_instrument=0, electrochemistry=0, shivers=0, half_light=0, MOTORICS=3, hand_eye_coordination=0, perception=0, reaction_speed=0, savoir_faire=0, interfacing=0, composure=1},
    fff_omen={INTELLECT=3, logic=0, encylopedia=0, rhetoric=0, drama=0, conceptualization=0, visual_calculus=0, PSYCHE=3, volition=1, inland_empire=4, empathy=0, authority=0, espirit_de_corps=0, suggestion=0, PHYSIQUE=3, endurance=2, pain_threshold=1, physical_instrument=0, electrochemistry=0, shivers=2, half_light=0, MOTORICS=1, hand_eye_coordination=0, perception=4, reaction_speed=0, savoir_faire=0, interfacing=3, composure=3},
    easter_brick=CREW_STAT_DEFINITIONS.ROCKMAN,
    easter_coomer=CREW_STAT_DEFINITIONS.HUMAN_SOLDIER,
    easter_bubby=CREW_STAT_DEFINITIONS.HUMAN_ENGINEER,
    easter_tommy=CREW_STAT_DEFINITIONS.HUMAN_MEDIC,
    easter_sunkist=CREW_STAT_DEFINITIONS.PONY,
    easter_angel=CREW_STAT_DEFINITIONS.GAS_QUEEN
}
--[[
{INTELLECT=3, logic=0, encylopedia=0, rhetoric=0, drama=0, conceptualization=0, visual_calculus=0, PSYCHE=3, volition=0, inland_empire=0, empathy=0, authority=0, espirit_de_corps=0, suggestion=0, PHYSIQUE=3, endurance=0, pain_threshold=0, physical_instrument=0, electrochemistry=0, shivers=0, half_light=0, MOTORICS=3, hand_eye_coordination=0, perception=0, reaction_speed=0, savoir_faire=0, interfacing=0, composure=0}
--]]


--[[What we really need are metatextual commands.  Full power to say what you want in the most powerful and compact and exensible/reusible way possible.
this is the idea behind lisp, and the way that lisp evolves into the new age.  I think this was what people were getting at with macros, but couldn't say it properly yet.
At least, I didn't understand what they were saying.  I think I can state it clearer now.


--The quote operator may be the single most powerful thing, but let's add some more. ~evaluates what's passed to it once, and treats the result as a string for use in code.
--Trivial
--`Trivial



--]]
local TRIVIAL_NAME = "Trivial"
local EASY_NAME = "Easy"
local MEDIUM_NAME = "Medium"
local CHALLENGING_NAME = "Challenging"
local FORMIDABLE_NAME = "Formidable"
local LEGENDARY_NAME = "Legendary"
local HEROIC_NAME = "Heroic"
local GODLY_NAME = "Godly"
local IMPOSSIBLE_NAME = "Impossible"

--autoships scale on reactor power primarilly, 
--static string defs 
local s_logic={name="Logic", internalName="logic"} --innate bonus
local s_encylopedia={name="Encylopedia", internalName="encylopedia"} --innate bonus
local s_rhetoric={name="Rhetoric", internalName="rhetoric"}
local s_drama={name="Drama", internalName="drama"}
local s_conceptualization={name="Conceptualization", internalName="conceptualization"}
local s_visual_calculus={name="Visual Calculus", internalName="visual_calculus"}
local s_volition={name="Volition", internalName="volition"}
local s_inland_empire={name="Inland Empire", internalName="inland_empire"} --anomoly detector, 
local s_empathy={name="Empathy", internalName="empathy"} --innate penalty, does not scale
local s_authority={name="Authority", internalName="authority"} --doors
local s_espirit_de_corps={name="Espirit de Corps", internalName="espirit_de_corps"}
local s_suggestion={name="Suggestion", internalName="suggestion"} --bonus for mind control
local s_endurance={name="Endurance", internalName="endurance"} --hull resist
local s_pain_threshold={name="Pain Threshold", internalName="pain_threshold"} --hull resist, system resist
local s_physical_instrument={name="Physical Instrument", internalName="physical_instrument"}
local s_electrochemistry={name="Electrochemistry", internalName="electrochemistry"} --mind control, hacking, temporal, the "weird" systems.
local s_shivers={name="Shivers", internalName="shivers"} --sensors, some augments
local s_half_light={name="Half Light", internalName="half_light"} --offensive system totals
local s_hand_eye_coordination={name="Hand-Eye Coordination", internalName="hand_eye_coordination"} --evasion%
local s_perception={name="Perception", internalName="perception"} --sensors, some augments
local s_reaction_speed={name="Reaction Speed", internalName="reaction_speed"} --piloting, engines
local s_savoir_faire={name="Savoir Faire", internalName="savoir_faire"} --cloaking, piloting
local s_interfacing={name="Interfacing", internalName="interfacing"} --hacking bonus
local s_composure={name="Composure", internalName="composure"} --system resist %
local s_INTELLECT={name="Intellect", internalName="INTELLECT"}
local s_PSYCHE={name="Psyche", internalName="PSYCHE"}
local s_PHYSIQUE={name="Physique", internalName="PHYSIQUE"}
local s_MOTORICS={name="Motorics", internalName="MOTORICS"}

local CHECK_DIFFICULTY_NAMES = {nil, nil, nil, nil, nil, TRIVIAL_NAME, TRIVIAL_NAME, EASY_NAME, EASY_NAME, MEDIUM_NAME, MEDIUM_NAME, CHALLENGING_NAME, FORMIDABLE_NAME, LEGENDARY_NAME, HEROIC_NAME, GODLY_NAME, IMPOSSIBLE_NAME, IMPOSSIBLE_NAME, IMPOSSIBLE_NAME}
--[[
    Trivial : 6-7
    Easy : 8-9
    Medium : 10-11
    Challenging : 12
    Formidable : 13
    Legendary : 14
    Heroic : 15
    Godly : 16
    Impossible : 18-20
    --]]

--numeric influence is how much the trait scales with how many crew you have.
--expectedCrewNum -- below this number, scaling is negative
--the issue with this idea is it will make some kinds of checks way easier.
--Because you'd need like three super elite crew to be better than 8 humans. 4.5 in everything.  That feels about right.
--So I think I just give all of the checks like a +.1 for each crew beyond the third.  * (.7 + numcrew)
--I think I can just give the special crew way better bonuses to offset this.
--I think that 7/8/9 is a good top end for the best unique crew.
--Like Tully would be like 6 6 8 7 or something
--prime reaper 9 7 9 9
local TRAIT_DEFINITIONS = {
        logic={category=s_INTELLECT, definition=s_logic},
        encylopedia={category=s_INTELLECT, definition=s_encylopedia}, --scaling
        rhetoric={category=s_INTELLECT, definition=s_rhetoric},
        drama={category=s_INTELLECT, definition=s_drama},
        conceptualization={category=s_INTELLECT, definition=s_conceptualization}, --scaling
        visual_calculus={category=s_INTELLECT, definition=s_visual_calculus},
        volition={category=s_PSYCHE, definition=s_volition},
        inland_empire={category=s_PSYCHE, definition=s_inland_empire}, --scaling
        empathy={category=s_PSYCHE, definition=s_empathy}, --scales with number of races on board
        authority={category=s_PSYCHE, definition=s_authority}, --no scaling, dillution based
        espirit_de_corps={category=s_PSYCHE, definition=s_espirit_de_corps}, --no scaling, dillution based
        suggestion={category=s_PSYCHE, definition=s_suggestion}, --no scaling, individual check
        endurance={category=s_PHYSIQUE, definition=s_endurance}, --scaling
        pain_threshold={category=s_PHYSIQUE, definition=s_pain_threshold}, --scaling
        physical_instrument={category=s_PHYSIQUE, definition=s_physical_instrument}, --scaling
        electrochemistry={category=s_PHYSIQUE, definition=s_electrochemistry},
        shivers={category=s_PHYSIQUE, definition=s_shivers},
        half_light={category=s_PHYSIQUE, definition=s_half_light}, --scaling
        hand_eye_coordination={category=s_MOTORICS, definition=s_hand_eye_coordination},
        perception={category=s_MOTORICS, definition=s_perception}, --scaling
        reaction_speed={category=s_MOTORICS, definition=s_reaction_speed},
        savoir_faire={category=s_MOTORICS, definition=s_savoir_faire},  --inverse scaling
        interfacing={category=s_MOTORICS, definition=s_interfacing}, --scaling
        composure={category=s_MOTORICS, definition=s_composure},
    }


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
    local traitDef = TRAIT_DEFINITIONS[skillName]
    if (traitDef == nil) then
        lwl.logError(LOG_TAG, "Invalid skill "..skillName, LOG_LEVEL)
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
local DEFAULT_STARTING_POWER = 7
local DEFAULT_POWER_CAP = 25
local STARTING_ATTRIBUTE_VAULE = 3
local ATTRIBUTE_VAULE_SOFT_CAP = 7
function getAutoShipStat(statName)
    local ownship = Hyperspace.ships.player
    local shipGraph = Hyperspace.ShipGraph.GetShipInfo(0)
    local pointf = ownship:GetRandomRoomCenter() --if some rooms have better stats, cool.
    local point = Hyperspace.Point(pointf.x, pointf.y)
    local slot = shipGraph:GetClosestSlot(point, 0, false)
    local room = ownship.ship.vRoomList[slot.roomId]--For damage resist values
    local baseStat = ((Hyperspace.PowerManager.GetPowerManager(0):GetMaxPower() - DEFAULT_STARTING_POWER) * (ATTRIBUTE_VAULE_SOFT_CAP - STARTING_ATTRIBUTE_VAULE) / (DEFAULT_POWER_CAP - DEFAULT_STARTING_POWER)) + STARTING_ATTRIBUTE_VAULE
    if (statName == s_logic.internalName) then
        baseStat = baseStat + 2
    elseif (statName == s_encylopedia.internalName) then
        baseStat = baseStat + 1.5
    elseif (statName == s_rhetoric.internalName) then
        --n/a
    elseif (statName == s_drama.internalName) then
        --n/a
    elseif (statName == s_conceptualization.internalName) then
        --n/a
    elseif (statName == s_visual_calculus.internalName) then
        baseStat = baseStat + ((ownship:GetSystemPowerMax(lwl.SYS_PILOT()) + ownship:GetSystemPowerMax(lwl.SYS_SENSORS())) / 2)
    elseif (statName == s_volition.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_BATTERY())
    elseif (statName == s_inland_empire.internalName) then
        baseStat = baseStat + ((500 - Hyperspace.playerVariables.stability) / 100)
    elseif (statName == s_empathy.internalName) then
        baseStat = baseStat - 2 + ownship:GetSystemPowerMax(lwl.SYS_OXYGEN())
    elseif (statName == s_authority.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_DOORS())
    elseif (statName == s_espirit_de_corps.internalName) then
        baseStat = baseStat - Hyperspace.playerVariables.rep_general --Reputaiton is negative
    elseif (statName == s_suggestion.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_MIND())
    elseif (statName == s_endurance.internalName) then
        baseStat = baseStat + (room.extend.hullDamageResistChance / 10)
    elseif (statName == s_pain_threshold.internalName) then
        baseStat = baseStat + (room.extend.sysDamageResistChance / 10)
    elseif (statName == s_physical_instrument.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_DRONES())
    elseif (statName == s_electrochemistry.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_MIND()) + ownship:GetSystemPowerMax(lwl.SYS_TEMPORAL()) + ownship:GetSystemPowerMax(lwl.SYS_HACKING())
    elseif (statName == s_shivers.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_SENSORS())
    elseif (statName == s_half_light.internalName) then
        baseStat = baseStat + ((ownship:GetSystemPowerMax(lwl.SYS_WEAPONS()) + ownship:GetSystemPowerMax(lwl.SYS_DRONES())) / 3)
    elseif (statName == s_hand_eye_coordination.internalName) then
        baseStat = baseStat + (ownship:GetDodgeFactor() / 15) --45 evade for 3 bonus
    elseif (statName == s_perception.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_SENSORS())
    elseif (statName == s_reaction_speed.internalName) then
        baseStat = baseStat + ((ownship:GetSystemPowerMax(lwl.SYS_PILOT()) + ownship:GetSystemPowerMax(lwl.SYS_ENGINES())) / 3)
    elseif (statName == s_savoir_faire.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_CLOAKING()) + ownship:GetSystemPowerMax(lwl.SYS_PILOT())
    elseif (statName == s_interfacing.internalName) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_HACKING())
    elseif (statName == s_composure.internalName) then --ion resist chance
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
    local crewStats = CREW_STAT_TABLE[species]
    if (crewStats == nil) then
        --make something up, can change this
        crewStats = HUMAN
    end
    return crewStats
end

local function getSpeciesStat(species, statName)
    local crewStats = safeLoadCrewStats(species)
    local stat = crewStats[statName]
    if (stat == nil) then
        stat = 0
    end
    local statCategory = TRAIT_DEFINITIONS[statName].category.internalName
    local mainStat = crewStats[statCategory]
    if (mainStat == nil) then
        lwl.logError(LOG_TAG, "Main stat for "..species.." was nil!"..statCategory, LOG_LEVEL)
        mainStat = 0
    end
    lwl.logInfo(LOG_TAG, statName.." for "..species..": "..mainStat.."+"..stat, LOG_LEVEL)
    return mainStat + stat
end


local function getPrintableStatTable(crewMem)
    local crewStats = safeLoadCrewStats(crewMem:GetSpecies())
    --todo for after I get the basics working, this is nice to have
end

--todo idk
local function getNonDroneCrew(shipManager)
    local crewList = lwl.getAllMemberCrew(Hyperspace.ships.player)
    --uh, remove drone crew.
    return crewList
end

--nothing uses this raw
local function getSumStat(statName)
    local valueSum = 0
    local crewList = lwl.getAllMemberCrew(Hyperspace.ships.player)
    --Iterate over player ship
    for i=1,#crewList do
        crewmem = crewList[i]
        valueSum = valueSum + getSpeciesStat(crewmem:GetSpecies(), statName)
    end
    
    --Then add your captain values
    --valueSum = valueSum + getSpeciesStat("PLAYER", statName)--currently always zero, might add later.
    valueSum = valueSum + getAutoShipStat(statName)
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
    local names = {INTELLECT, PSYCHE, PHYSIQUE, MOTORICS}
    for i = 1, #stats do
        stat = table.remove(stats, math.random(1, #stats))
        local name = names[i]
        CREW_STAT_TABLE.PLAYER[names[i]] = stat --I think this works.
    end
    CREW_STAT_TABLE.PLAYER[lwl.getRandomKey(TRAIT_DEFINITIONS)] = 1
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

local CURRENT_CARD
local function cleanUpCards()
    if (CURRENT_CARD ~= nil) then
        Brightness.destroy_particle(CURRENT_CARD)
    end
end

local function renderCard(skillName)
    cleanUpCards()
    --Time doesn't tick on this layer while events are up.
    CURRENT_CARD = Brightness.create_particle("particles/attributes/"..skillName, 1, 0.01, Hyperspace.Pointf(990, 330), 0, nil, "MOUSE_CONTROL_PRE")
end

local function playPassiveSuccess(check)
    local skillCategory = TRAIT_DEFINITIONS[check.skill].category
    if (skillCategory == s_MOTORICS) then
        soundControl:PlaySoundMix("disco_motorics", 3, false)
    elseif (skillCategory == s_PSYCHE) then
        soundControl:PlaySoundMix("disco_psyche", 3, false)
    elseif (skillCategory == s_PHYSIQUE) then
        soundControl:PlaySoundMix("disco_physique", 3, false)
    elseif (skillCategory == s_INTELLECT) then
        soundControl:PlaySoundMix("disco_intellect", 3, false)
    else
        lwl.logError(LOG_TAG, "Invalid category "..skillCategory, LOG_LEVEL)
    end
end

local function renderCheckResult(locationEvent)
    local check = queuedCheckAVList[locationEvent.eventName]
    --print("renderCheckResult ", check)
    if check ~= nil then
        if (check.success) then
            soundControl:PlaySoundMix("disco_check_success", 5, false)
        else
            soundControl:PlaySoundMix("disco_check_fail", 5, false)
        end
        renderCard(check.skill)
    end
    queuedCheckAVList = {}
end

--attribute values for guns?
--Lua button to check your attributes
--lua events that pop up out of combat
--lua events that pop up in combat, based on the ship you're fighting.
--These need to be very rare

--I want a symbol that interprets itself.
--Not just that it is the language, but the hardware as well.

local function passiveText(skillCheck)
    return skillFromName(skillCheck.skill).name.." ["..CHECK_DIFFICULTY_NAMES[skillCheck.value]..": Success] -- "..skillCheck.replacementChoiceText
end

local function activeText(skillCheck)
    local successChance = probability_greater_than(2, 6, skillCheck.value - getStat(skillCheck.skill))
    successChance = math.max(3, math.min(successChance, 97)) --Bounded by crits
    return "["..skillFromName(skillCheck.skill).name.." - "..CHECK_DIFFICULTY_NAMES[skillCheck.value].." "..skillCheck.value..", "..successChance.."%] -- "..skillCheck.replacementChoiceText
end

--piloting is what you should choose for your check.  1=success, 8=failure, you don't see it.
local function appendChoices(locationEvent)
    local skillChecks = DISCO_EVENTS_LIST[locationEvent.eventName]
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
            queuedCheckAVList[skillCheck.successEventName] = {success=true, skill=skillCheck.skill}
            queuedCheckAVList[skillCheck.failureEventName] = {success=false, skill=skillCheck.skill}
            for choice in vter(choices) do
                --print(choice.text.data, skillCheck.placeholderChoiceText, choice.text.data == skillCheck.placeholderChoiceText)
                if (choice.text.data == skillCheck.placeholderChoiceText) then
                    --These ones always show up, and it's a matter of if it succeeds.  Ideally I would't have to do this in xml, it takes two events for each active check.
                    choice.text.data = activeText(skillCheck)
                    shouldDisplay = (activeSuccess == choice.requirement.blue)
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

--The events need to be defined in XML, which isn't ideal, but it works.
--Active checks need two xml events, one will be disabled based on the check result.  Blue value indicates if it is for a success or not.
--max_group must be different for each option for an event.  I'm using the 640 block, forgemaster uses 620-ish, pick something for yourself if you're using this.
--Every check is a red check here.

--[[
    See example usage file



--]]


--Should only be called with events created by mods.multiverseDiscoEngine.buildEvent
local function registerEvent(event)
    if (DISCO_EVENTS_LIST[event.name] == nil) then
        DISCO_EVENTS_LIST[event.name] = event
    else
        --append checks to existing event.
        lwl.logInfo(TAG, "Event "..event.name.." already exists, appending.", LOG_LEVEL)
        for i = 1,#event do
            table.insert(DISCO_EVENTS_LIST[event.eventName], event[i])
        end
    end
    print(lwl.dumpObject(DISCO_EVENTS_LIST))
end

function mde.registerEventList(eventList)
    for i = 1,#eventList do
        registerEvent(eventList[i])
    end
end

--[[
    Add new crew you've made to the disco stat table.  You can also use this to overwrite existing crew's values if you want with the optional force argument.
    Basic crew are around 12-13 major stat points, elite crew around 16-22, super elite 24-28, and uniques vary wildly.  You can look at the existing table for examples.
    This is just a guideline, and if there's something you want your crew to be really good at, go for it, because it's going to get diluted by all the other crew onboard.

    Stat block format:
    {INTELLECT=3, logic=0, encylopedia=0, rhetoric=0, drama=0, conceptualization=0, visual_calculus=0, PSYCHE=3, volition=0, inland_empire=0, empathy=0, authority=0, espirit_de_corps=0, suggestion=0, PHYSIQUE=3, endurance=0, pain_threshold=0, physical_instrument=0, electrochemistry=0, shivers=0, half_light=0, MOTORICS=3, hand_eye_coordination=0, perception=0, reaction_speed=0, savoir_faire=0, interfacing=0, composure=0}
--]]
function mods.multiverseDiscoEngine.appendCrew(crewName, statBlock, force)
    if (not force and CREW_STAT_TABLE[crewName] ~= nil) then
        lwl.logWarn(TAG, crewName.." is already defined, skipping.", LOG_LEVEL)
        return
    end
    CREW_STAT_TABLE[crewName] = statBlock
end

--[[ Main Event Loop ]]--
script.on_internal_event(Defines.InternalEvents.PRE_CREATE_CHOICEBOX, function(locationEvent)
        cleanUpCards()
        renderCheckResult(locationEvent)
        appendChoices(locationEvent)
    end)

