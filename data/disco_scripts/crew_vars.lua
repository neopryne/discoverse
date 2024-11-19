mods.multiverseDiscoEngine = {}

local vter = mods.multiverse.vter
local lwl = mods.lightweight_lua

local global = Hyperspace.Global.GetInstance()
local soundControl = global:GetSoundControl()

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
local LOG_LEVEL = 3
local LOG_TAG = "mods.disco.core"

local HUMAN = {INTELLECT=3, logic=0, encylopedia=0, rhetoric=0, drama=0, conceptualization=0, visual_calculus=0, PSYCHE=3, volition=0, inland_empire=0, empathy=0, authority=0, espirit_de_corps=0, suggestion=0, PHYSIQUE=3, endurance=0, pain_threshold=0, physical_instrument=0, electrochemistry=0, shivers=0, half_light=0, MOTORICS=3, hand_eye_coordination=0, perception=0, reaction_speed=0, savoir_faire=0, interfacing=0, composure=0}
local HUMAN_ENGINEER = {INTELLECT=3, logic=1, encylopedia=1, conceptualization=1, PSYCHE=3, PHYSIQUE=3, MOTORICS=3, hand_eye_coordination=1, interfacing=1, composure=0}
local HUMAN_MEDIC = {INTELLECT=3, encylopedia=1, PSYCHE=3, empathy=1, PHYSIQUE=3, MOTORICS=3, hand_eye_coordination=1, interfacing=1, composure=1}
local HUMAN_SOLDIER = {INTELLECT=3, visual_calculus=1, PSYCHE=3, authority=1, espirit_de_corps=1, PHYSIQUE=3, endurance=1, pain_threshold=1, physical_instrument=1, half_light=1, MOTORICS=3, hand_eye_coordination=1, reaction_speed=1}
local HUMAN_MFK = {INTELLECT=6, PSYCHE=6, PHYSIQUE=6, MOTORICS=6}
local ENGI = {INTELLECT=4, logic=1, PSYCHE=3, empathy=-1, PHYSIQUE=1, MOTORICS=4, interfacing=1}
local ENGI_SEPERATIST = {INTELLECT=4, logic=1, PSYCHE=3, espirit_de_corps=-2, PHYSIQUE=1, MOTORICS=4, interfacing=1}
local ENGI_DEFENDER = {INTELLECT=4, logic=1, PSYCHE=3, PHYSIQUE=2, endurance=2, pain_threshold=2, MOTORICS=4, interfacing=1}
local ZOLTAN = {INTELLECT=3, PSYCHE=4, PHYSIQUE=2, MOTORICS=3}
local ROCK = {INTELLECT=3, PSYCHE=3, PHYSIQUE=4, endurance=1, pain_threshold=1, MOTORICS=2, composure=2}
local ROCK_OUTCAST = {INTELLECT=3, PSYCHE=3, espirit_de_corps=-1, PHYSIQUE=4, endurance=1, pain_threshold=1, MOTORICS=2, composure=2}
local ROCK_CULTIST = {INTELLECT=3, PSYCHE=3, inland_empire=1, PHYSIQUE=4, endurance=1, pain_threshold=1, MOTORICS=2, composure=2}
local ROCK_COMMANDO = {INTELLECT=3, PSYCHE=3, espirit_de_corps=1, PHYSIQUE=4, endurance=2, pain_threshold=1, MOTORICS=2, composure=2}
local ROCK_CRUSADER = {INTELLECT=3, PSYCHE=3, espirit_de_corps=1, PHYSIQUE=4, endurance=2, pain_threshold=1, MOTORICS=2}
local ROCK_PALADIN = {INTELLECT=3, PSYCHE=5, authority=2, espirit_de_corps=2, PHYSIQUE=6, endurance=3, pain_threshold=1, MOTORICS=2, composure=2}
local CRYSTAL = {INTELLECT=3, PSYCHE=4, PHYSIQUE=4, MOTORICS=3}
local CRYSTAL_SENTINAL = {INTELLECT=6, PSYCHE=6, PHYSIQUE=6, MOTORICS=6}
local CRYSTAL_LIBERATOR = {INTELLECT=6, PSYCHE=6, PHYSIQUE=6, MOTORICS=6}
local MANTIS = {INTELLECT=2, PSYCHE=2, PHYSIQUE=4, MOTORICS=1}
local FREE_MANTIS = {INTELLECT=2, PSYCHE=3, PHYSIQUE=4, MOTORICS=1}
local FREE_MANTIS_CHAOS = {INTELLECT=2, PSYCHE=3, PHYSIQUE=4, MOTORICS=1}
local FREE_MANTIS_WARLORD = {INTELLECT=3, PSYCHE=3, PHYSIQUE=5, MOTORICS=1}
local MANTIS_SUZERAIN = {INTELLECT=4, PSYCHE=3, PHYSIQUE=6, MOTORICS=2}
local MANTIS_BISHOP = {INTELLECT=4, PSYCHE=5, PHYSIQUE=7, MOTORICS=2}
local SLUG = {INTELLECT=4, PSYCHE=4, PHYSIQUE=3, MOTORICS=3}
local SLUG_HEKTAR = {INTELLECT=4, PSYCHE=4, PHYSIQUE=3, MOTORICS=3}
local SLUG_SABOTUER = {INTELLECT=4, PSYCHE=6, PHYSIQUE=5, MOTORICS=6}
local SLUG_RANGER = {INTELLECT=5, PSYCHE=6, PHYSIQUE=6, MOTORICS=6}
local SLUG_CLANSMAN = {INTELLECT=5, PSYCHE=5, PHYSIQUE=5, MOTORICS=5}
local KNIGHT_OF_NIGHTS = {INTELLECT=7, PSYCHE=7, PHYSIQUE=7, MOTORICS=7}
local ORCHID = {INTELLECT=3, PSYCHE=3, PHYSIQUE=3, electrochemistry=1, MOTORICS=3}
local ORCHID_PRAETOR = {INTELLECT=3, logic=1, encylopedia=1, rhetoric=1, drama=1, PSYCHE=4, empathy=-1, authority=1, PHYSIQUE=3, pain_threshold=-1, MOTORICS=3, composure=1}
local ORCHID_CARETAKER = {INTELLECT=3, encylopedia=1, rhetoric=1, conceptualization=1, visual_calculus=1, PSYCHE=3, empathy=1, PHYSIQUE=3, electrochemistry=1, MOTORICS=3, composure=1}
local VAMPWEED = {INTELLECT=3, PSYCHE=3, PHYSIQUE=3, electrochemistry=1, MOTORICS=3}
local ORCHID_CULTIVATOR = ORCHID_CARETAKER
local SHELL = {INTELLECT=5, PSYCHE=3, PHYSIQUE=2, MOTORICS=3}
local LEECH = {INTELLECT=3, PSYCHE=2, PHYSIQUE=2, MOTORICS=4}
local LANIUS = {INTELLECT=3, PSYCHE=3, PHYSIQUE=4, MOTORICS=4}
local GAS_HATCHLING = {INTELLECT=1, PSYCHE=2, PHYSIQUE=1, MOTORICS=0}
local GAS_ADULT = {INTELLECT=2, PSYCHE=4, PHYSIQUE=5, MOTORICS=1}
local GAS_WEAVER = {INTELLECT=5, PSYCHE=6, PHYSIQUE=4, MOTORICS=7}
local GAS_QUEEN = {INTELLECT=6, PSYCHE=7, PHYSIQUE=10, MOTORICS=6}
local LIZARD = {INTELLECT=2, PSYCHE=3, PHYSIQUE=4, MOTORICS=4}
local PONY = {INTELLECT=1, PSYCHE=4, PHYSIQUE=5, MOTORICS=4}
local PONY_TAMED = {INTELLECT=3, PSYCHE=4, PHYSIQUE=5, MOTORICS=4}
local PONY_CRYSTAL = {INTELLECT=4, PSYCHE=5, PHYSIQUE=5, MOTORICS=5}
local PONY_ENGI = {INTELLECT=3, PSYCHE=4, PHYSIQUE=6, MOTORICS=4}
local DEEP_ONE = {INTELLECT=5, PSYCHE=4, PHYSIQUE=5, MOTORICS=4}
local DEEP_ONE_CULTIST = {INTELLECT=4, PSYCHE=4, PHYSIQUE=5, MOTORICS=4}
local THE_SCARRED = {INTELLECT=5, PSYCHE=6, PHYSIQUE=6, MOTORICS=4}
local THE_SCARRED_ASCENDED = {INTELLECT=5, PSYCHE=10, PHYSIQUE=6, MOTORICS=6}
local ENLIGHTENED_HORROR = {INTELLECT=3, PSYCHE=8, PHYSIQUE=6, MOTORICS=4}
--local PONY_ENGI = {INTELLECT=3, PSYCHE=4, PHYSIQUE=6, MOTORICS=4}





--Uniques
local TULLY = {INTELLECT=7, PSYCHE=7, PHYSIQUE=5, MOTORICS=7}
local HAYNES = {INTELLECT=9, PSYCHE=7, PHYSIQUE=5, electrochemistry=4, MOTORICS=6, perception=3, interfacing=-1, composure=2}
local JERRY = {INTELLECT=3, PSYCHE=3, empathy=6, PHYSIQUE=3, MOTORICS=3}
local JERRY_GUN = {INTELLECT=3, PSYCHE=3, empathy=6, PHYSIQUE=9, electrochemistry=-5, MOTORICS=9}
local JERRY_PONY = {INTELLECT=3, PSYCHE=3, empathy=6, PHYSIQUE=10, MOTORICS=10} --TODO REPLACE
local JERRY_PONY_CRYSTAL = {INTELLECT=3, PSYCHE=3, empathy=6, PHYSIQUE=10, MOTORICS=11}
local ELLIE = {INTELLECT=3, PSYCHE=1, PHYSIQUE=5, MOTORICS=5}
local STEPHAN = {INTELLECT=3, PSYCHE=4, PHYSIQUE=5, MOTORICS=5}
local LEAH = {INTELLECT=3, PSYCHE=4, PHYSIQUE=3, MOTORICS=3}
local TURZIL = {INTELLECT=7, logic=1, encylopedia=1, rhetoric=1, PSYCHE=7, volition=1, authority=2, espirit_de_corps=2, PHYSIQUE=6, electrochemistry=-2, shivers=-2, MOTORICS=7, interfacing=1}
local DEVORAK = {INTELLECT=4, PSYCHE=6, authority=1, PHYSIQUE=5, endurance=1, pain_threshold=9, physical_instrument=1, half_light=1, MOTORICS=7}
local ANURAK = {INTELLECT=4, visual_calculus=0, PSYCHE=7, empathy=1, PHYSIQUE=5, electrochemistry=1, MOTORICS=4, composure=2}
local KAZ = {INTELLECT=5, visual_calculus=2, PSYCHE=5, PHYSIQUE=7, MOTORICS=9} --the greatest thief in the multiverse
local FREDDY = {INTELLECT=8, PSYCHE=8, PHYSIQUE=6, MOTORICS=6}
local SYMBIOTE = {INTELLECT=4, PSYCHE=4, PHYSIQUE=5, MOTORICS=2}
local VORTIGON = {INTELLECT=4, PSYCHE=4, PHYSIQUE=8, MOTORICS=4}
local TUCO = {INTELLECT=3, PSYCHE=4, PHYSIQUE=6, MOTORICS=3}
local ARIADNE = {INTELLECT=6, PSYCHE=6, PHYSIQUE=6, MOTORICS=4}
local RUWEN = {INTELLECT=7, PSYCHE=6, PHYSIQUE=5, MOTORICS=4}
local DIANESH = {INTELLECT=7, PSYCHE=6, PHYSIQUE=5, MOTORICS=4}
local OBYN = {INTELLECT=5, PSYCHE=6, PHYSIQUE=6, MOTORICS=4}
local BILLY = {INTELLECT=6, PSYCHE=6, PHYSIQUE=4, MOTORICS=4}
local NIGHTS = {INTELLECT=6, PSYCHE=8, PHYSIQUE=6, MOTORICS=6}
local SLOCKNOG = {INTELLECT=5, PSYCHE=6, PHYSIQUE=5, MOTORICS=6}
local IRWIN = {INTELLECT=5, PSYCHE=6, PHYSIQUE=7, MOTORICS=5}
local IRWIN_DEMON = {INTELLECT=5, PSYCHE=8, PHYSIQUE=9, MOTORICS=5}
local SYLVAN = {INTELLECT=8, PSYCHE=11, PHYSIQUE=10, MOTORICS=9}
local TONY_SR = {INTELLECT=3, PSYCHE=2, PHYSIQUE=2, endurance=5, MOTORICS=2}--a sad sack of a man
local TYREDO = {INTELLECT=4, PSYCHE=3, PHYSIQUE=4, MOTORICS=5} --Just copy his stats to the bird to avoid dumb dillution
local ALKRAM = {INTELLECT=4, PSYCHE=5, PHYSIQUE=6, MOTORICS=7}
local ALKALI = {INTELLECT=7, PSYCHE=6, PHYSIQUE=4, MOTORICS=6}
local OOJ_MAJOO = {INTELLECT=5, PSYCHE=7, PHYSIQUE=6, MOTORICS=7}
local ANNOINTED = {INTELLECT=9, PSYCHE=9, PHYSIQUE=9, MOTORICS=9}
local BEACON_EATER = {INTELLECT=5, PSYCHE=7, PHYSIQUE=9, MOTORICS=7}
local DESSIUS = {INTELLECT=7, PSYCHE=9, PHYSIQUE=8, MOTORICS=7}
local GUNTPUT = {INTELLECT=4, PSYCHE=7, PHYSIQUE=6, MOTORICS=7}
local METYUNT = {INTELLECT=5, PSYCHE=4, PHYSIQUE=4, MOTORICS=4}
local WITHER = {INTELLECT=6, PSYCHE=6, PHYSIQUE=6, MOTORICS=3}
local TYEREL = {INTELLECT=6, PSYCHE=6, PHYSIQUE=6, MOTORICS=5}
local MAYEB = {INTELLECT=5, encylopedia=1, rhetoric=1, conceptualization=1, visual_calculus=1, PSYCHE=5, empathy=1, PHYSIQUE=3, electrochemistry=1, MOTORICS=4, composure=1}
local IVAR = {INTELLECT=4, PSYCHE=5, PHYSIQUE=5, MOTORICS=4}
local THEST = {INTELLECT=6, PSYCHE=10, PHYSIQUE=6, MOTORICS=6}
local CORBY = {INTELLECT=10, PSYCHE=6, PHYSIQUE=6, MOTORICS=6}
local WAKESON = {INTELLECT=6, PSYCHE=6, PHYSIQUE=10, MOTORICS=6}
--local PONY =
local BATTLE_DRONE = {INTELLECT=3, PSYCHE=4, PHYSIQUE=5, MOTORICS=4}
local BATTLE_DRONE_2 = {INTELLECT=3, PSYCHE=4, PHYSIQUE=7, MOTORICS=5}
local ION_INTRUDER = {INTELLECT=3, PSYCHE=5, PHYSIQUE=6, MOTORICS=5}
local REPAIR_DRONE = {INTELLECT=3, PSYCHE=3, PHYSIQUE=3, MOTORICS=4}
local DOCTOR_DRONE = {INTELLECT=6, PSYCHE=5, PHYSIQUE=3, MOTORICS=5}
local MANAGER_DRONE = {INTELLECT=4, PSYCHE=3, PHYSIQUE=2, MOTORICS=2}
local RECON_DRONE = {INTELLECT=2, PSYCHE=2, PHYSIQUE=2, MOTORICS=5}
local CONSTRUCTOR_DRONE = {INTELLECT=2, PSYCHE=2, PHYSIQUE=3, MOTORICS=4}
local PRODUCER_DRONE = {INTELLECT=2, PSYCHE=4, PHYSIQUE=3, MOTORICS=2}
local GRAZIER_DRONE = {INTELLECT=2, PSYCHE=2, PHYSIQUE=5, MOTORICS=2}
local ATOM_DRONE = {INTELLECT=2, PSYCHE=2, PHYSIQUE=3, physical_instrument=5, MOTORICS=5}
local DIRECTOR_DRONE = {INTELLECT=6, PSYCHE=5, PHYSIQUE=3, MOTORICS=3}
local MENDER_DRONE = {INTELLECT=5, PSYCHE=3, PHYSIQUE=3, MOTORICS=7}
local A5540L3 = {INTELLECT=8, PSYCHE=7, PHYSIQUE=7, MOTORICS=5}
local GANA_DRONE = {INTELLECT=7, PSYCHE=6, PHYSIQUE=6, MOTORICS=5}
local ROOMBA = {INTELLECT=2, PSYCHE=2, PHYSIQUE=2, MOTORICS=2}
--local PONY =



--Base crew get 12 total stats.  Elite/Unique can have more.
--todo get all the names for the keys of this table
CREW_STAT_TABLE = {
    PLAYER={},
    --human has all of the traits for copying purposes, lowercase numbers are modifiers so human has 3s across the board.
    human=HUMAN,
    human_humanoid=HUMAN,
    human_engineer=HUMAN_ENGINEER,
    human_medic=HUMAN_MEDIC,
    human_rebel_medic=HUMAN_MEDIC,
    human_soldier=HUMAN_SOLDIER,
    human_technician=HUMAN_ENGINEER,
    human_mfk=HUMAN_MFK,
    human_legion={INTELLECT=7, PSYCHE=7, PHYSIQUE=7,  MOTORICS=7},
    human_legion_pyro={INTELLECT=7, PSYCHE=7, drama=1, PHYSIQUE=7, half_light=1, MOTORICS=7},
    unique_cyra=HUMAN_MFK,--TODO
    unique_tully= TULLY,
    unique_vance={INTELLECT=7, PSYCHE=7, PHYSIQUE=5, MOTORICS=7},
    unique_haynes=HAYNES,
    unique_jerry=JERRY,
    unique_jerry_gun=JERRY_GUN,
    unique_jerry_pony=JERRY_PONY,
    unique_jerry_pony_crystal=JERRY_PONY_CRYSTAL,
    unique_leah=LEAH,
    unique_leah_mfk=HUMAN_MFK,--TODO
    unique_ellie=ELLIE,
    unique_ellie_stephan=STEPHAN,
    unique_ellie_lvl1={INTELLECT=3, PSYCHE=1, PHYSIQUE=5, MOTORICS=5},
    unique_ellie_lvl2={INTELLECT=3, PSYCHE=1, PHYSIQUE=6, MOTORICS=5},
    unique_ellie_lvl3={INTELLECT=3, PSYCHE=0, PHYSIQUE=6, MOTORICS=6},
    unique_ellie_lvl4={INTELLECT=3, PSYCHE=-1, PHYSIQUE=7, MOTORICS=6},
    unique_ellie_lvl5={INTELLECT=3, PSYCHE=-2, PHYSIQUE=8, MOTORICS=6},
    unique_ellie_lvl6={INTELLECT=3, PSYCHE=-3, PHYSIQUE=9, MOTORICS=6},
    human_angel={INTELLECT=6, PSYCHE=7, PHYSIQUE=6, MOTORICS=7},
    --Orchid
    orchid=ORCHID,
    orchid_caretaker=ORCHID_CARETAKER,
    orchid_praetor=ORCHID_PRAETOR,
    orchid_vampweed=VAMPWEED,
    orchid_cultivator=ORCHID_CULTIVATOR,
    unique_tyerel=TYEREL,
    unique_mayeb=MAYEB,
    unique_ivar=IVAR,
    --Engi
    engi=ENGI,
    engi_separatist=ENGI_SEPERATIST,
    engi_separatist_nano=ENGI_SEPERATIST,
    engi_defender=ENGI_DEFENDER,
    unique_turzil=TURZIL,
    --Zoltan
    zoltan=ZOLTAN,
    zoltan_monk={INTELLECT=3, conceptualization=1, PSYCHE=3, volition=1, inland_empire=2, empathy=1, suggestion=1, PHYSIQUE=3, pain_threshold=1, physical_instrument=1, electrochemistry=0, shivers=1, half_light=-2, MOTORICS=3, composure=2},
    zoltan_peacekeeper={INTELLECT=3, logic=0, PSYCHE=4, inland_empire=-1, PHYSIQUE=3, physical_instrument=1, half_light=1, MOTORICS=3, reaction_speed=1, composure=1},
    zoltan_devotee={INTELLECT=3, rhetoric=1, drama=1, PSYCHE=3, volition=2, PHYSIQUE=3, physical_instrument=1, half_light=1, MOTORICS=3, reaction_speed=1, composure=-1}, --duskbringer
    zoltan_martyr={INTELLECT=3, rhetoric=1, drama=1, PSYCHE=3, volition=2, PHYSIQUE=3, physical_instrument=1, half_light=1, MOTORICS=3, reaction_speed=1, composure=-1},
    unique_devorak=DEVORAK,
    unique_anurak=ANURAK,
    zoltan_osmian=ZOLTAN,--IDK
    --Rock
    rock=ROCK,
    rock_outcast=ROCK_OUTCAST,
    rock_cultist=ROCK_CULTIST,
    rock_commando=ROCK_COMMANDO,
    rock_crusader=ROCK_CRUSADER,
    rock_paladin=ROCK_PALADIN,
    --rock_elder=,
    unique_symbiote=SYMBIOTE,
    unique_vortigon=VORTIGON,
    unique_tuco=TUCO,
    unique_ariadne=ARIADNE,
    --Mantis
    mantis=MANTIS,
    mantis_suzerain=MANTIS_SUZERAIN,
    mantis_free=FREE_MANTIS,
    mantis_free_chaos=FREE_MANTIS_CHAOS,
    mantis_warlord=FREE_MANTIS_WARLORD,
    mantis_bishop=MANTIS_BISHOP,
    unique_kaz=KAZ,
    unique_freddy=FREDDY,
    unique_freddy_fedora=FREDDY,
    unique_freddy_jester=FREDDY,
    unique_freddy_sombrero=FREDDY,
    unique_freddy_twohats=FREDDY,
    --Crystal
    crystal=CRYSTAL,--[[
    crystal_liberator
    crystal_sentinel
    unique_ruwen
    unique_dianesh
    unique_obyn
    nexus_obyn_cel
    --Slug
    slug=SLUG,
    slug_hektar=SLUG_HEKTAR,
    slug_hektar_box=SLUG_HEKTAR,
    slug_saboteur=SLUG_SABOTUER,
    slug_clansman=SLUG_CLANSMAN,
    slug_ranger=SLUG_RANGER,
    slug_knight=KNIGHT_OF_NIGHTS,
    unique_billy=BILLY,
    unique_billy_box=BILLY,
    unique_nights=NIGHTS,
    unique_slocknog=SLOCKNOG,
    unique_irwin=IRWIN,
    unique_irwin_demon=IRWIN_DEMON,
    unique_sylvan=SYLVAN,
    --todo I don't know enough about these, giving them all sylvan stats for now.
    nexus_sylvan_cel=SYLVAN,
    nexus_sylvan_gman=SYLVAN,
    bucket=SYLVAN,
    sylvanrick=SYLVAN,
    sylvansans=SYLVAN,
    saltpapy=SYLVAN,
    sylvanleah=SYLVAN,
    sylvanrebel=SYLVAN,
    dylan=SYLVAN,
    nexus_pants=SYLVAN,
    prime=SYLVAN,--TODO
    sylvan1d=SYLVAN,
    sylvanclan=SYLVAN,
    beans=SYLVAN,
    --Leech
    leech=LEECH
    leech_ampere
    unique_tonysr=TONY_SR
    unique_tyrdeo=TYREDO
    unique_tyrdeo_bird=TYREDO
    unique_alkram=ALKRAM
    --Siren
    siren
    siren_harpy
    --Shell
    shell
    shell_scientist
    shell_mechanic
    shell_guardian
    shell_radiant
    unique_alkali = ALKALI
    --Lanius
    lanius =
    lanius_welder
    lanius_augmented
    unique_anointed = ANNOINTED
    unique_eater = BEACON_EATER
    --Ghost
    phantom
    phantom_alpha
    phantom_goul
    phantom_goul_alpha
    phantom_mare
    phantom_mare_alpha
    phantom_wraith
    phantom_wraith_alpha
    unique_dessius = DESSIUS
    gbeleanor
    gbscoleri
    gbslimer
    gbpsych
    gbvinz
    gbzuul
    --Spider
    spider = GAS_ADULT
    spider_weaver = GAS_WEAVER
    spider_hatch = GAS_HATCHLING
    unique_queen = GAS_QUEEN --El spidro guigante
    spider_venom
    spider_venom_chaos
    tinybug
    --Lizard thing
    lizard = LIZARD,
    unique_guntput = GUNTPUT,
    unique_metyunt = METYUNT,
    --Pony
    pony = PONY,
    pony_tamed = PONY_TAMED,
    ponyc = PONY_CRYSTAL,
    pony_engi
    pony_engi_nano
    pony_engi_chaos
    pony_engi_nano_chaos
    --Cognitive
    cognitive
    cognitive_automated
    cognitive_advanced
    cognitive_advanced_automated
    --todo FR cogs
    --Obelisk
    obelisk
    obelisk_royal
    unique_wither
    -- :)
    eldritch_cat
    eldritch_thing
    eldritch_thing_noclone
    eldritch_thing_weak
    gnome--]]
    --Judges
    unique_judge_thest=THEST,
    unique_judge_corby=CORBY,
    unique_judge_wakeson=WAKESON,
    --Dronesss
    a55=A5540L3,
    gana=GANA_DRONE,
    battle=ION_INTRUDER,
    drone_battle=BATTLE_DRONE,--[[
    drone_yinyang
    drone_yinyang_chaos
    loot_separatist_1 --idk
    drone_battle2=BATTLE_DRONE_2,
    repairboarder
    repair
    divrepair
    butler
    drone_recon=RECON_DRONE,
    drone_recon_defense=RECON_DRONE,
    doctor=DOCTOR_DRONE,
    surgeon
    surgeon_chaos
    manning
    manningenemy=nil,
    drone_holodrone
    drone_holodrone_chaos--]]
    drone_vamp_constructor=CONSTRUCTOR_DRONE,
    drone_vamp_producer=PRODUCER_DRONE,
    drone_vamp_grazier=GRAZIER_DRONE,
    mender=MENDER_DRONE,
    menderr=MENDER_DRONE,
    director=DIRECTOR_DRONE,
    atom=ATOM_DRONE,
    atomr=ATOM_DRONE,
    roomba=ROOMBA,
    --Morph
    blob={INTELLECT=3, PSYCHE=3, PHYSIQUE=3, MOTORICS=3},
    unique_ooj = OOJ_MAJOO,
    unique_ooj_love = OOJ_MAJOO,
    blobhuman=HUMAN,
    blobzoltan=ZOLTAN,
    blobrock=ROCK,
    blobcrystal=CRYSTAL,
    blobmantis=MANTIS,
    blobfreemantis=FREE_MANTIS,
    blobslug=SLUG,
    bloborchid=ORCHID,
    blobvampweed=VAMPWEED,
    blobswarm=nil,
    blobshell=SHELL,
    blobleech=LEECH,
    blobhatch=GAS_HATCHLING,
    blobspider=GAS_ADULT,
    blobweaver=GAS_WEAVER,
    bloblizard=LIZARD,
    blobpony=PONY,
    blobsalt=ROCK,
    techno={INTELLECT=4, PSYCHE=3, PHYSIQUE=3, MOTORICS=4},
    technoengi=ENGI,
    technolanius=LANIUS,
    --technoancient
    --technoavatar --idk
    technobattle=BATTLE_DRONE,  --they can do drones i guess
    technobattle2=BATTLE_DRONE_2,
    technoboarderion=ION_INTRUDER,
    technorepair=REPAIR_DRONE,
    technodoctor=DOCTOR_DRONE,
    technomanning=MANAGER_DRONE,
    technorecon=RECON_DRONE,
    technoconstructor=CONSTRUCTOR_DRONE,
    technoproducer=PRODUCER_DRONE,
    technograzier=GRAZIER_DRONE,
    technoatom=ATOM_DRONE,
    technodirector=DIRECTOR_DRONE,
    technomender=MENDER_DRONE,
    technoa55=A5540L3,
    technogana=GANA_DRONE,
    technoroomba=ROOMBA,
    gold={INTELLECT=4, PSYCHE=4, PHYSIQUE=4, MOTORICS=4},
    goldsoldier = HUMAN_SOLDIER,
    golddefend = ENGI_DEFENDER,
    goldcrusader = ROCK_CRUSADER,
    goldsentinel = CRYSTAL_SENTINAL,
    goldsuzerain = MANTIS_SUZERAIN,
    goldwarlord = FREE_MANTIS_WARLORD,
    goldsabo = SLUG_SABOTUER,
    goldwelder = LANIUS_WELDER,
    goldpraetor = ORCHID_PRAETOR,
    goldcultivator = ORCHID_CULTIVATOR,
    --goldtoxic --shell
    goldampere = LEECH_AMPERE,
    goldroyal = OBELISK_ROYAL,
    goldqueen = GAS_QUEEN,
    --EE?
    --[[
    eldritch_spawn
    --Forgotten Races
    snowman=SNOWMAN,
    snowman_chaos=SNOWMAN_CHAOS,
    fr_lavaman=LAVAMAN,
    fr_commonwealth
    fr_spherax
    fr_unique_billvan=SYLVAN,
    fr_unique_billvan_box=SYLVAN,
    fr_unique_sammy=SAMMY,
    fr_unique_sammy_buff=SAMMY,
    
    fr_gozer
    fr_CE_avatar
    fr_errorman
    fr_sylvan_cel=SYLVAN
    fr_obyn_cel=OBYN
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
    fr_unique_leah_legion=HUMAN_MFK,--EH
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
    fr_ghost_tully=TULLY,
    fr_ghost_haynes=HAYNES,
    fr_ghost_jerry=JERRY,
    fr_ghost_ellie=ELLIE,
    fr_ghost_stephan=STEPHAN,
    fr_ghost_turzil=TURZIL,
    fr_ghost_devorak=DEVORAK,
    fr_ghost_anurak=ANURAK,
    fr_ghost_kaz=KAZ,
    fr_ghost_freddy=FREDDY,
    fr_ghost_symbiote=SYMBIOTE,
    fr_ghost_vortigon=VORTIGON,
    fr_ghost_tuco=TUCO,
    fr_ghost_ariadne=ARIADNE,
    fr_ghost_ruwen=RUWEN,
    fr_ghost_dianesh=DIANESH,
    fr_ghost_obyn=OBYN,
    fr_ghost_billy=BILLY,
    fr_ghost_billy_box=BILLY,
    fr_ghost_nights=NIGHTS,
    fr_ghost_slocknog=SLOCKNOG,
    fr_ghost_irwin=IRWIN,
    fr_ghost_sylvan=SYLVAN,
    fr_ghost_tonysr=TONY_SR,
    fr_ghost_tyrdeo=TYREDO,
    fr_ghost_alkram=ALKRAM,
    fr_ghost_alkali=ALKALI,
    fr_ghost_ooj=OOJ_MAJOO,
    fr_ghost_anointed=ANNOINTED,
    fr_ghost_eater=BEACON_EATER,
    fr_ghost_dessius=DESSIUS,
    fr_ghost_queen=GAS_QUEEN,
    fr_ghost_guntput=GUNTPUT,
    fr_ghost_metyunt=METYUNT,
    fr_ghost_wither=WITHER,
    --[[
    fr_bonus_augustus
    fr_bonus_augustus_enemy
    fr_bonus_sally_hatchling = GAS_HATCHLING,
    fr_bonus_sally_adult = GAS_ADULT,
    fr_bonus_sally_weaver = GAS_WEAVER,
    fr_bonus_prince
    fr_bonus_prince_jerry
    fr_bonus_tririac
    --]]
    --FR Drones
    fr_atomc=ATOM_DRONE,
    fr_menderc=MENDER_DRONE,
    fr_directorc=DIRECTOR_DRONE,
    fr_atomw=ATOM_DRONE, --yellow
    fr_menderw=MENDER_DRONE,
    fr_directorw=DIRECTOR_DRONE,
    --pink?
    fr_ghostly_battledrone=BATTLE_DRONE,
    fr_ghostly_battledrone_2=BATTLE_DRONE_2,
    fr_cleo_spawn = nil,
    fr_technocwdirector=DIRECTOR_DRONE,
    fr_technocwmender=MENDER_DRONE,
    fr_technocwatom=ATOM_DRONE,
    fr_copper_battledrone_1=BATTLE_DRONE,
    fr_copper_battledrone_2=BATTLE_DRONE_2,
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
    deepone=DEEP_ONE,
    deeponecultist=DEEP_ONE_CULTIST,
    unique_thescarred=THE_SCARRED,
    unique_thescarredascended=THE_SCARRED_ASCENDED,
    enlightened_horror=ENLIGHTENED_HORROR,----like hektar, not doing all these right now.
    enlightened_horror_a=ENLIGHTENED_HORROR,
    enlightened_horror_b=ENLIGHTENED_HORROR,
    enlightened_horror_c=ENLIGHTENED_HORROR,
    enlightened_horror_ad=ENLIGHTENED_HORROR,
    enlightened_horror_ae=ENLIGHTENED_HORROR,
    enlightened_horror_af=ENLIGHTENED_HORROR,
    enlightened_horror_ag=ENLIGHTENED_HORROR,
    enlightened_horror_bd=ENLIGHTENED_HORROR,
    enlightened_horror_be=ENLIGHTENED_HORROR,
    enlightened_horror_bf=ENLIGHTENED_HORROR,
    enlightened_horror_bg=ENLIGHTENED_HORROR,
    enlightened_horror_cd=ENLIGHTENED_HORROR,
    enlightened_horror_ce=ENLIGHTENED_HORROR,
    enlightened_horror_cf=ENLIGHTENED_HORROR,
    enlightened_horror_cg=ENLIGHTENED_HORROR,
    enlightened_horror_adj=ENLIGHTENED_HORROR,
    enlightened_horror_aej=ENLIGHTENED_HORROR,
    enlightened_horror_afj=ENLIGHTENED_HORROR,
    enlightened_horror_agj=ENLIGHTENED_HORROR,
    enlightened_horror_bdj=ENLIGHTENED_HORROR,
    enlightened_horror_bej=ENLIGHTENED_HORROR,
    enlightened_horror_bfj=ENLIGHTENED_HORROR,
    enlightened_horror_bgj=ENLIGHTENED_HORROR,
    enlightened_horror_cdj=ENLIGHTENED_HORROR,
    enlightened_horror_cej=ENLIGHTENED_HORROR,
    enlightened_horror_cfj=ENLIGHTENED_HORROR,
    enlightened_horror_cgj=ENLIGHTENED_HORROR,
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
    slug_hektar_elite=SLUG_HEKTAR,--eh
    modular_dronebattle_base_base=BATTLE_DRONE, --Eventually I'll replace this with individual ones.
    modular_dronebattle_base_bio=BATTLE_DRONE,
    modular_dronebattle_base_stun=BATTLE_DRONE,
    modular_dronebattle_base_lockdown=BATTLE_DRONE,
    modular_dronebattle_base_pierce=BATTLE_DRONE,
    modular_dronebattle_base_cooldown=BATTLE_DRONE,
    modular_dronebattle_accuracy_base=BATTLE_DRONE,
    modular_dronebattle_accuracy_bio=BATTLE_DRONE,
    modular_dronebattle_accuracy_stun=BATTLE_DRONE,
    modular_dronebattle_accuracy_lockdown=BATTLE_DRONE,
    modular_dronebattle_accuracy_pierce=BATTLE_DRONE,
    modular_dronebattle_accuracy_cooldown=BATTLE_DRONE,
    modular_dronebattle_fire_base=BATTLE_DRONE,
    modular_dronebattle_fire_bio=BATTLE_DRONE,
    modular_dronebattle_fire_stun=BATTLE_DRONE,
    modular_dronebattle_fire_lockdown=BATTLE_DRONE,
    modular_dronebattle_fire_pierce=BATTLE_DRONE,
    modular_dronebattle_fire_cooldown=BATTLE_DRONE,
    modular_dronebattle_hull_base=BATTLE_DRONE,
    modular_dronebattle_hull_bio=BATTLE_DRONE,
    modular_dronebattle_hull_stun=BATTLE_DRONE,
    modular_dronebattle_hull_lockdown=BATTLE_DRONE,
    modular_dronebattle_hull_pierce=BATTLE_DRONE,
    modular_dronebattle_hull_cooldown=BATTLE_DRONE,
    modular_dronebattle_power_base=BATTLE_DRONE_2,--battle2
    modular_dronebattle_power_bio=BATTLE_DRONE_2,
    modular_dronebattle_power_stun=BATTLE_DRONE_2,
    modular_dronebattle_power_lockdown=BATTLE_DRONE_2,
    modular_dronebattle_power_pierce=BATTLE_DRONE_2,
    modular_dronebattle_power_cooldown=BATTLE_DRONE_2,
    
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
    easter_brick=ROCKMAN,
    easter_coomer=HUMAN_SOLDIER,
    easter_bubby=HUMAN_ENGINEER,
    easter_tommy=HUMAN_MEDIC,
    easter_sunkist=PONY,
    easter_angel=GAS_QUEEN
}
--[[
{INTELLECT=3, logic=0, encylopedia=0, rhetoric=0, drama=0, conceptualization=0, visual_calculus=0, PSYCHE=3, volition=0, inland_empire=0, empathy=0, authority=0, espirit_de_corps=0, suggestion=0, PHYSIQUE=3, endurance=0, pain_threshold=0, physical_instrument=0, electrochemistry=0, shivers=0, half_light=0, MOTORICS=3, hand_eye_coordination=0, perception=0, reaction_speed=0, savoir_faire=0, interfacing=0, composure=0},
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
--Getter methods to preserve final values.
function mods.multiverseDiscoEngine.KEY_LOGIC() return s_logic.internalName end
function mods.multiverseDiscoEngine.KEY_ENCYLOPEDIA() return s_encylopedia.internalName end
function mods.multiverseDiscoEngine.KEY_RHETORIC() return s_rhetoric.internalName end
function mods.multiverseDiscoEngine.KEY_DRAMA() return s_drama.internalName end
function mods.multiverseDiscoEngine.KEY_CONCEPTUALIZATION() return s_conceptualization.internalName end
function mods.multiverseDiscoEngine.KEY_VISUAL_CALCULUS() return s_visual_calculus.internalName end
function mods.multiverseDiscoEngine.KEY_VOLITION() return s_volition.internalName end
function mods.multiverseDiscoEngine.KEY_INLAND_EMPIRE() return s_inland_empire.internalName end
function mods.multiverseDiscoEngine.KEY_EMPATHY() return s_empathy.internalName end
function mods.multiverseDiscoEngine.KEY_AUTHORITY() return s_authority.internalName end
function mods.multiverseDiscoEngine.KEY_ESPIRIT_DE_CORPS() return s_espirit_de_corps.internalName end
function mods.multiverseDiscoEngine.KEY_SUGGESTION() return s_suggestion.internalName end
function mods.multiverseDiscoEngine.KEY_ENDURANCE() return s_endurance.internalName end
function mods.multiverseDiscoEngine.KEY_PAIN_THRESHOLD() return s_pain_threshold.internalName end
function mods.multiverseDiscoEngine.KEY_PHYSICAL_INSTRUMENT() return s_physical_instrument.internalName end
function mods.multiverseDiscoEngine.KEY_ELECTROCHEMISTRY() return s_electrochemistry.internalName end
function mods.multiverseDiscoEngine.KEY_SHIVERS() return s_shivers.internalName end
function mods.multiverseDiscoEngine.KEY_HALF_LIGHT() return s_half_light.internalName end
function mods.multiverseDiscoEngine.KEY_HAND_EYE_COORDINATION() return s_hand_eye_coordination.internalName end
function mods.multiverseDiscoEngine.KEY_PERCEPTION() return s_perception.internalName end
function mods.multiverseDiscoEngine.KEY_REACTION_SPEED() return s_reaction_speed.internalName end
function mods.multiverseDiscoEngine.KEY_SAVOIR_FAIRE() return s_savoir_faire.internalName end
function mods.multiverseDiscoEngine.KEY_INTERFACING() return s_interfacing.internalName end
function mods.multiverseDiscoEngine.KEY_COMPOSURE() return s_composure.internalName end


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



local queuedCheckAVList = {STORAGE_CHECK_LAB_FFF_F22_THERMAL_IMAGING_REACTION_SUCCES={success=true, skill=s_reaction_speed},
        STORAGE_CHECK_LAB_FFF_F22_THERMAL_IMAGING_REACTION_FAILURE={success=false, skill=s_reaction_speed}}
    
    

local DISCO_EVENTS_LIST = {
    STORAGE_CHECK_LAB_FFF_F22_THERMAL_IMAGING={
        {og_text="special storage version", passive=true, skill=s_volition, value=10, text="yuhp"}, 
        {og_text="special storage active", passive=false, skill=s_reaction_speed, value=9, text="Try yor lukk", successEventName="STORAGE_CHECK_LAB_FFF_F22_THERMAL_IMAGING_REACTION_SUCCES", failureEventName="STORAGE_CHECK_LAB_FFF_F22_THERMAL_IMAGING_REACTION_FAILURE"}}}


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
    local statCategory = TRAIT_DEFINITIONS[statName]
    local mainStat = crewStats[statCategory]
    if (mainStat == nil) then
        mainStat = 0
    end
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
    valueSum = valueSum + getSpeciesStat("PLAYER", statName)--currently always zero, might add later.
    valueSum = valueSum + getAutoShipStat(statName)
    return valueSum
end

local function getAverageStat(statName)
    local totalStats = getSumStat(statName)
    local numCrew = #lwl.getAllMemberCrew(Hyperspace.ships.player)
    return totalStats / (numCrew + 1) --+2 if I include the captain at some point
end

--
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
    print("Active check: ", statName, " ", amount, " Rolls ", firstDie, secondDie, statValue, totalValue)
    --Snakeyes always fails.  Boxcars always succeeds.
    if (firstDie == 1 and secondDie == 1) then
        return false
    elseif (firstDie == 6 and secondDie == 6) then
        return true
    end
    return (totalValue >= amount)
end

local function passiveCheck(statName, amount)
    print("Passive check: ", statName, " ", amount, " Value ", (getStat(statName) + 6))
    return (getStat(statName) + 6 >= amount)
end


local function renderCard(skill)
    --todo brightness, needs to have a global option.
    --these should dismiss the start of each skill check.
end

local function playPassiveSuccess(check)
    local skillCategory = TRAIT_DEFINITIONS[check.skill.internalName].category
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

--attribute values for guns?
--Lua button to check your attributes
--lua events that pop up out of combat
--lua events that pop up in combat, based on the ship you're fighting.
--These need to be very rare

--I want a symbol that interprets itself.
--Not just that it is the language, but the hardware as well.

local function passiveText(skillCheck)
    return skillCheck.skill.name.." ["..CHECK_DIFFICULTY_NAMES[skillCheck.value]..": Success] -- "..skillCheck.text
end

local function activeText(skillCheck)
    local successChance = probability_greater_than(2, 6, skillCheck.value - getStat(skillCheck.skill.internalName))
    return "["..skillCheck.skill.name.." - "..CHECK_DIFFICULTY_NAMES[skillCheck.value].." "..skillCheck.value..", "..successChance.."%] -- "..skillCheck.text
end

--piloting is what you should choose for your check.  1=success, 8=failure, you don't see it.
local function appendChoices(locationEvent)
    local skillChecks = DISCO_EVENTS_LIST[locationEvent.eventName]
    if skillChecks == nil then return end
    local choices = locationEvent:GetChoices()
    --find the associated entry for each choice and apply it.
    for i = 1,#skillChecks do --iterate over choices, replace keywords with strings.
        local skillCheck = skillChecks[i]
        --todo check av nonsense.  At very least audio + printing the result.
        local activeSuccess = activeCheck(skillCheck.skill.internalName, skillCheck.value)
        local passiveSuccess = true--passiveCheck(skillCheck.skill.internalName, skillCheck.value)
        if (skillCheck.passive) then
            print("passive check found.")
            for choice in vter(choices) do
                print(choice.text.data, skillCheck.og_text, choice.text.data == skillCheck.og_text, passiveSuccess)
                print("Successp? ", passiveSuccess and (choice.text.data == skillCheck.og_text))
                if (choice.text.data == skillCheck.og_text) then
                    if (passiveSuccess) then
                        playPassiveSuccess(skillCheck)
                        choice.requirement.blue = true
                        choice.text.data = passiveText(skillCheck)
                        choice.requirement.min_level = 1
                    else
                        choice.requirement.min_level = 9 --shouldn't see the event in this case.
                    end
                end
            end
        else --active
            print("active check found.")
            queuedCheckAVList[skillCheck.successEventName] = {success=true, skill=skillCheck.skill}
            queuedCheckAVList[skillCheck.failureEventName] = {success=false, skill=skillCheck.skill}
            for choice in vter(choices) do
                print(choice.text.data, skillCheck.og_text, choice.text.data == skillCheck.og_text)
                if (choice.text.data == skillCheck.og_text) then
                    --These ones always show up, and it's a matter of if it succeeds.  Ideally I would't have to do this in xml, it takes two events for each active check.
                    choice.text.data = activeText(skillCheck)
                    shouldDisplay = (activeSuccess == choice.requirement.blue)
                    print("Success? ", activeSuccess, choice.requirement.blue, shouldDisplay)
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


--Should only be called with events created by mods.multiverseDiscoEngine.buildEvent
function mods.multiverseDiscoEngine.registerEvent(event)
    if (DISCO_EVENTS_LIST[event.eventName] == nil) then
        DISCO_EVENTS_LIST[event.eventName] = event
    end
end

--Constructs an event with a single skill check you can register in the global table.  You also need to make a matching XML choice.
--Choices are located by their text, so you will need to put something unique there, and replace it with what you actually want people to see
--skill is mde.KEY_[SKILL]()
--Do not edit the values returned by this.  If you need to add more choices, use appendCheck.
function mods.multiverseDiscoEngine.buildEvent(eventName, initialChoiceText, isPassive, skill, value, replacementChoiceText)
    local event = {name=eventName, {}}
    mods.multiverseDiscoEngine.appendCheck(event, initialChoiceText, isPassive, skill, difficultyValue, replacementChoiceText)
end

--Use this if you want to add multiple checks to a single event.  Remember, the XML max_groups must all be different or they won't show up.
--todo account for multiple things adding to the same event.  Not the same check, those must be defined for each mod.
function mods.multiverseDiscoEngine.appendCheck(event, initialChoiceText, isPassive, skill, difficultyValue, replacementChoiceText)
    local newCheck = {og_text=initialChoiceText, passive=isPassive, skill=TRAIT_DEFINITIONS[skill].definition, value=difficultyValue, text=replacementChoiceText}
    table.insert(event[1], newCheck)
    return event
end


script.on_internal_event(Defines.InternalEvents.PRE_CREATE_CHOICEBOX, function(locationEvent)
        --this should go in its own file for exensibility
        --print("pre event ", locationEvent.eventName)
        --lwl.printEvent(locationEvent)
        renderCheckResult(locationEvent)
        appendChoices(locationEvent)
    end)

