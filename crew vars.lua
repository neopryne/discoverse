local vter = mods.multiverse.vter
local lwl = mods.lightweight_lua

--[[
The goal of this is to create a system which can be used to inhect disco elysium-style checks/options into events.

lazy calculation of stat totals, only do it when they're being checked.
we're about to get colored text, too.
--]]

local HUMAN = {INTELLECT=3, logic=0, encylopedia=0, rhetoric=0, drama=0, conceptualization=0, visual_calculus=0, PSYCHE=3, volition=0, inland_empire=0, empathy=0, authority=0, espirit_de_corps=0, suggestion=0, PHYSIQUE=3, endurance=0, pain_threshold=0, physical_instrument=0, electrochemistry=0, shivers=0, half_light=0, MOTORICS=3, hand_eye_cordination=0, perception=0, reaction_speed=0, savoir_faire=0, interfacing=0, composure=0}
local HUMAN_ENGINEER = {INTELLECT=3, logic=1, encylopedia=1, conceptualization=1, PSYCHE=3, PHYSIQUE=3, MOTORICS=3, hand_eye_cordination=1, interfacing=1, composure=0}
local HUMAN_MEDIC = {INTELLECT=3, encylopedia=1, PSYCHE=3, empathy=1, PHYSIQUE=3, MOTORICS=3, hand_eye_cordination=1, interfacing=1, composure=1}
local HUMAN_SOLDIER = {INTELLECT=3, visual_calculus=1, PSYCHE=3, authority=1, espirit_de_corps=1, PHYSIQUE=3, endurance=1, pain_threshold=1, physical_instrument=1, half_light=1, MOTORICS=3, hand_eye_cordination=1, reaction_speed=1}
local HUMAN_MFK = {INTELLECT=6, PSYCHE=6, PHYSIQUE=6, MOTORICS=6}
local ENGI = {INTELLECT=4, logic=1, PSYCHE=3, empathy=-1, PHYSIQUE=1, MOTORICS=4, interfacing=1}
local ENGI_SEPERATIST = {INTELLECT=4, logic=1, PSYCHE=3, espirit_de_corps=-2, PHYSIQUE=1, MOTORICS=4, interfacing=1}
local ENGI_DEFENDER = {INTELLECT=4, logic=1, PSYCHE=3, PHYSIQUE=2, endurance=2, pain_threshold=2, MOTORICS=4, interfacing=1}
local ZOLTAN = {INTELLECT=3, PSYCHE=4, PHYSIQUE=2, MOTORICS=3}
local ROCK = {INTELLECT=3, PSYCHE=3, PHYSIQUE=4, endurance=1, pain_threshold=1, MOTORICS=2, composure=2}
local ROCK_OUTCAST = {INTELLECT=3, PSYCHE=3, espirit_de_corps=-1 PHYSIQUE=4, endurance=1, pain_threshold=1, MOTORICS=2, composure=2}
local ROCK_CULTIST = {INTELLECT=3, PSYCHE=3, inland_empire=1, PHYSIQUE=4, endurance=1, pain_threshold=1 MOTORICS=2, composure=2}
local ROCK_COMMANDO = {INTELLECT=3, PSYCHE=3, espirit_de_corps=1, PHYSIQUE=4, endurance=2, pain_threshold=1, MOTORICS=2, composure=2}
local ROCK_CRUSADER = {INTELLECT=3, PSYCHE=3, espirit_de_corps=1, PHYSIQUE=4, endurance=2, pain_threshold=1, MOTORICS=2}
local ROCK_PALADIN = {INTELLECT=3, PSYCHE=5, authority=2, espirit_de_corps=2, PHYSIQUE=6, endurance=3, pain_threshold=1, MOTORICS=2, composure=2}
local CRYSTAL =
local MANTIS =
local FREE_MANTIS =
local SLUG =
local SLUG_HEKTAR =
local SLUG_SABOTUER =
local SLUG_RANGER =
local SLUG_CLANSMAN =
local KNIGHT_OF_NIGHTS =
local ORCHID = {INTELLECT=3, PSYCHE=3, PHYSIQUE=3, electrochemistry=1, MOTORICS=3}
local ORCHID_PRAETOR = {INTELLECT=3, logic=1, encylopedia=1, rhetoric=1, drama=1, PSYCHE=4, empathy=-1, authority=1, PHYSIQUE=3, pain_threshold=-1, MOTORICS=3, composure=1}
local ORCHID_CARETAKER = {INTELLECT=3, encylopedia=1, rhetoric=1, conceptualization=1, visual_calculus=1, PSYCHE=3, empathy=1, PHYSIQUE=3, electrochemistry=1, MOTORICS=3, composure=1}
local VAMPWEED = {INTELLECT=3, PSYCHE=3, PHYSIQUE=3, electrochemistry=1, MOTORICS=3}
local ORCHID_CULTIVATOR = ORCHID_CARETAKER
local SHELL =
local LEECH =
local GAS_HATCHLING =
local GAS_ADULT =
local GAS_WEAVER =
local GAS_QUEEN =
local LIZARD =
local PONY =
local PONY =
local PONY =
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
local OBYN =
local BILLY = {INTELLECT=6, PSYCHE=6, PHYSIQUE=4, MOTORICS=4}
local NIGHTS = {INTELLECT=6, PSYCHE=8, PHYSIQUE=6, MOTORICS=6}
local SLOCKNOG = {INTELLECT=5, PSYCHE=6, PHYSIQUE=5, MOTORICS=6}
local IRWIN = {INTELLECT=5, PSYCHE=6, PHYSIQUE=7, MOTORICS=5}
local IRWIN_DEMON = {INTELLECT=5, PSYCHE=8, PHYSIQUE=9, MOTORICS=5}
local SYLVAN =
local TONY_SR = {INTELLECT=3, PSYCHE=2, PHYSIQUE=2, endurance=5, MOTORICS=2}--a sad sack of a man
local TYREDO = {INTELLECT=4, PSYCHE=3, PHYSIQUE=4, MOTORICS=5} --Just copy his stats to the bird to avoid dumb dillution
local ALKRAM = {INTELLECT=4, PSYCHE=5, PHYSIQUE=6, MOTORICS=7}
local ALKALI = {INTELLECT=7, PSYCHE=6, PHYSIQUE=4, MOTORICS=6}
local OOJ_MAJOO = {INTELLECT=5, PSYCHE=7, PHYSIQUE=6, MOTORICS=7}
local ANNOINTED = {INTELLECT=9, PSYCHE=9, PHYSIQUE=9, MOTORICS=9}
local BEACON_EATER = {INTELLECT=5, PSYCHE=7, PHYSIQUE=9, MOTORICS=7}
local DESSIUS = {INTELLECT=7, PSYCHE=9, PHYSIQUE=8, MOTORICS=7}
local GUNTPUT =
local METYUNT =
local WITHER =
local PONY =
local PONY =

--Base crew get 12 total stats.  Elite/Unique can have more.
--todo get all the names for the keys of this table
global CREW_STAT_TABLE = {
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
    unique_cyra=nil,
    unique_tully= TULLY,
    unique_vance={INTELLECT=7, PSYCHE=7, PHYSIQUE=5, MOTORICS=7},
    unique_haynes=HAYNES,
    unique_jerry=JERRY,
    unique_jerry_gun=JERRY_GUN,
    unique_jerry_pony=JERRY_PONY,
    unique_jerry_pony_crystal=JERRY_PONY_CRYSTAL,
    unique_leah=LEAH,
    unique_leah_mfk=HUMAN_MFK,
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
    unique_tyerel
    unique_mayeb
    unique_ivar
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
    zoltan_osmian
    --Rock
    rock=ROCK,
    rock_outcast=ROCK_OUTCAST,
    rock_cultist=ROCK_CULTIST,
    rock_commando=ROCK_COMMANDO,
    rock_crusader=ROCK_CRUSADER,
    rock_paladin=ROCK_PALADIN,
    rock_elder
    unique_symbiote=SYMBIOTE,
    unique_vortigon=VORTIGON,
    unique_tuco=TUCO,
    unique_ariadne=ARIADNE,
    --Mantis
    mantis
    mantis_suzerain
    mantis_free
    mantis_free_chaos
    mantis_warlord
    mantis_bishop
    unique_kaz=KAZ,
    unique_freddy=FREDDY,
    unique_freddy_fedora=FREDDY,
    unique_freddy_jester=FREDDY,
    unique_freddy_sombrero=FREDDY,
    unique_freddy_twohats=FREDDY,
    --Crystal
    crystal=CRYSTAL,
    crystal_liberator
    crystal_sentinel
    unique_ruwen
    unique_dianesh
    unique_obyn
    nexus_obyn_cel
    --Slug
    slug=SLUG,
    slug_hektar=
    slug_hektar_box
    slug_saboteur
    slug_clansman
    slug_ranger
    slug_knight
    unique_billy
    unique_billy_box
    unique_nights
    unique_slocknog
    unique_irwin
    unique_irwin_demon
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
    unique_tyrdeo
    unique_tyrdeo_bird
    unique_alkram
    --Siren
    siren
    siren_harpy
    --Shell
    shell
    shell_scientist
    shell_mechanic
    shell_guardian
    shell_radiant
    unique_alkali
    --Lanius
    lanius
    lanius_welder
    lanius_augmented
    unique_anointed
    unique_eater
    --Ghost
    phantom
    phantom_alpha
    phantom_goul
    phantom_goul_alpha
    phantom_mare
    phantom_mare_alpha
    phantom_wraith
    phantom_wraith_alpha
    unique_dessius
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
    lizard
    unique_guntput
    unique_metyunt
    --Pony
    pony = PONY
    pony_tamed
    ponyc
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
    gnome
    --Judges
    unique_judge_thest
    unique_judge_corby
    unique_judge_wakeson
    --Dronesss
    a55
    gana
    battle --ion intruder
    drone_battle
    drone_yinyang
    drone_yinyang_chaos
    loot_separatist_1 --idk
    drone_battle2
    repairboarder
    repair
    divrepair
    butler
    drone_recon --unused?
    drone_recon_defense
    doctor
    surgeon
    surgeon_chaos
    manning
    manningenemy=nil
    drone_holodrone
    drone_holodrone_chaos
    drone_vamp_constructor
    drone_vamp_producer
    drone_vamp_grazier
    mender
    menderr
    director
    atom
    atomr
    roomba
    --Morph
    blob
    unique_ooj = OOJ_MAJOO
    unique_ooj_love = OOJ_MAJOO
    blobhuman=HUMAN
    blobzoltan=ZOLTAN
    blobrock=ROCK
    blobcrystal=CRYSTAL
    blobmantis=MANTIS
    blobfreemantis=FREE_MANTIS
    blobslug=SLUG
    bloborchid=ORCHID
    blobvampweed=VAMPWEED
    blobswarm=nil
    blobshell=SHELL
    blobleech=LEECH
    blobhatch=GAS_HATCHLING
    blobspider=GAS_ADULT
    blobweaver=GAS_WEAVER
    bloblizard=LIZARD
    blobpony=PONY
    blobsalt=ROCK
    techno
    technoengi
    technolanius
    technoancient
    technoavatar --idk
    technobattle  --they can do drones i guess
    technobattle2
    technoboarderion
    technorepair
    technodoctor
    technomanning
    technorecon
    technoconstructor
    technoproducer
    technograzier
    technoatom
    technodirector
    technomender
    technoa55
    technogana
    technoroomba
    gold
    goldsoldier = HUMAN_SOLDIER
    golddefend = ENGI_DEFENDER
    goldcrusader = ROCK_CRUSADER
    goldsentinel = CRYSTAL_SENTINAL
    goldsuzerain = MANTIS_SUZERAIN
    goldwarlord = FREE_MANTIS_WARLORD
    goldsabo = SLUG_SABOTUER
    goldwelder = LANIUS_WELDER
    goldpraetor = ORCHID_PRAETOR
    goldcultivator = ORCHID_CULTIVATOR
    goldtoxic --shell
    goldampere = LEECH_AMPERE
    goldroyal = OBELISK_ROYAL
    goldqueen = GAS_QUEEN
    --EE?
    eldritch_spawn
    --Forgotten Races
    snowman
    snowman_chaos
    fr_lavaman
    fr_commonwealth
    fr_spherax
    fr_unique_billvan
    fr_unique_billvan_box
    fr_unique_sammy
    fr_unique_sammy_buff --??
    fr_gozer
    fr_CE_avatar
    fr_errorman
    fr_sylvan_cel
    fr_obyn_cel
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
    fr_snowman_smart
    fr_unique_leah_legion
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
    fr_bonus_augustus
    fr_bonus_augustus_enemy
    fr_bonus_sally_hatchling = GAS_HATCHLING
    fr_bonus_sally_adult = GAS_ADULT
    fr_bonus_sally_weaver = GAS_WEAVER
    fr_bonus_prince
    fr_bonus_prince_jerry
    fr_bonus_tririac
    --FR Drones
    fr_atomc --blue
    fr_menderc
    fr_directorc
    fr_atomw --yellow
    fr_menderw
    fr_directorw
    --pink?
    fr_ghostly_battledrone
    fr_ghostly_battledrone_2
    fr_cleo_spawn = nil
    fr_technocwdirector
    fr_technocwmender
    fr_technocwatom
    fr_copper_battledrone_1
    fr_copper_battledrone_2
    --Diamonds
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
    
    --Darkest Desire
    --Deep Ones
    deepone
    deeponecultist
    unique_thescarred
    unique_thescarredascended
    --Something??
    enlightened_horror ----wtf are these??
    enlightened_horror_a
    enlightened_horror_b
    enlightened_horror_c
    enlightened_horror_ad
    enlightened_horror_ae
    enlightened_horror_af
    enlightened_horror_ag
    enlightened_horror_bd
    enlightened_horror_be
    enlightened_horror_bf
    enlightened_horror_bg
    enlightened_horror_cd
    enlightened_horror_ce
    enlightened_horror_cf
    enlightened_horror_cg
    enlightened_horror_adj
    enlightened_horror_aej
    enlightened_horror_afj
    enlightened_horror_agj
    enlightened_horror_bdj
    enlightened_horror_bej
    enlightened_horror_bfj
    enlightened_horror_bgj
    enlightened_horror_cdj
    enlightened_horror_cej
    enlightened_horror_cfj
    enlightened_horror_cgj
    ddnightmare_rift=nil
    ddnightmare_rift_a=nil
    ddnightmare_rift_b=nil
    ddnightmare_rift_c=nil
    ddnightmare_rift_ad=nil
    ddnightmare_rift_ae=nil
    ddnightmare_rift_af=nil
    ddnightmare_rift_ag=nil
    ddnightmare_rift_bd=nil
    ddnightmare_rift_be=nil
    ddnightmare_rift_bf=nil
    ddnightmare_rift_bg=nil
    ddnightmare_rift_cd=nil
    ddnightmare_rift_ce=nil
    ddnightmare_rift_cf=nil
    ddnightmare_rift_cg=nil
    ddnightmare_rift_adj=nil
    ddnightmare_rift_aej=nil
    ddnightmare_rift_afj=nil
    ddnightmare_rift_agj=nil
    ddnightmare_rift_bdj=nil
    ddnightmare_rift_bej=nil
    ddnightmare_rift_bfj=nil
    ddnightmare_rift_bgj=nil
    ddnightmare_rift_cdj=nil
    ddnightmare_rift_cej=nil
    ddnightmare_rift_cfj=nil
    ddnightmare_rift_cgj=nil
    spacetear=nil
    darkgodtendrils=nil
    nightmarish_crawler
    nightmarish_terror
    nightmarish_priest
    nightmarish_greaterpriest
    nightmarish_stalker
    nightmarish_engi
    nightmarish_greatercrawler
    nightmarish_mass
    nightmarish_greatermass
    nightmarish_martyr
    nightmarish_greatermartyr
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
    disparity_engirainbow_beacon
    
    --Hektar Expansion
    slug_hektar_elite
    modular_dronebattle_base_base --Eventually I'll replace this with individual ones.
    modular_dronebattle_base_bio
    modular_dronebattle_base_stun
    modular_dronebattle_base_lockdown
    modular_dronebattle_base_pierce
    modular_dronebattle_base_cooldown
    modular_dronebattle_accuracy_base
    modular_dronebattle_accuracy_bio
    modular_dronebattle_accuracy_stun
    modular_dronebattle_accuracy_lockdown
    modular_dronebattle_accuracy_pierce
    modular_dronebattle_accuracy_cooldown
    modular_dronebattle_fire_base
    modular_dronebattle_fire_bio
    modular_dronebattle_fire_stun
    modular_dronebattle_fire_lockdown
    modular_dronebattle_fire_pierce
    modular_dronebattle_fire_cooldown
    modular_dronebattle_hull_base
    modular_dronebattle_hull_bio
    modular_dronebattle_hull_stun
    modular_dronebattle_hull_lockdown
    modular_dronebattle_hull_pierce
    modular_dronebattle_hull_cooldown
    modular_dronebattle_power_base--battle2
    modular_dronebattle_power_bio
    modular_dronebattle_power_stun
    modular_dronebattle_power_lockdown
    modular_dronebattle_power_pierce
    modular_dronebattle_power_cooldown
    
    ARI_MECH
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
    
    
    easter_brick=ROCKMAN,
    easter_coomer=HUMAN_SOLDIER,
    easter_bubby=HUMAN_ENGINEER,
    easter_tommy=HUMAN_MEDIC
    easter_sunkist=PONY,
    easter_angel=GAS_QUEEN
}
--[[
{INTELLECT=3, logic=0, encylopedia=0, rhetoric=0, drama=0, conceptualization=0, visual_calculus=0, PSYCHE=3, volition=0, inland_empire=0, empathy=0, authority=0, espirit_de_corps=0, suggestion=0, PHYSIQUE=3, endurance=0, pain_threshold=0, physical_instrument=0, electrochemistry=0, shivers=0, half_light=0, MOTORICS=3, hand_eye_cordination=0, perception=0, reaction_speed=0, savoir_faire=0, interfacing=0, composure=0},
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
local s_logic="logic" --innate bonus
local s_encylopedia="encylopedia" --innate bonus
local s_rhetoric="rhetoric"
local s_drama="drama"
local s_conceptualization="conceptualization"
local s_visual_calculus="visual_calculus"
local s_volition="volition"
local s_inland_empire="inland_empire" --anomoly detector, 
local s_empathy="empathy" --innate penalty, does not scale
local s_authority="authority" --doors
local s_espirit_de_corps="espirit_de_corps"
local s_suggestion="suggestion" --bonus for mind control
local s_endurance="endurance" --hull resist
local s_pain_threshold="pain_threshold" --hull resist, system resist
local s_physical_instrument="physical_instrument"
local s_electrochemistry="electrochemistry" --mind control, hacking, temporal, the "weird" systems.
local s_shivers="shivers" --sensors, some augments
local s_half_light="half_light" --offensive system totals
local s_hand_eye_cordination="hand_eye_cordination" --evasion%
local s_perception="perception" --sensors, some augments
local s_reaction_speed="reaction_speed" --piloting, engines
local s_savoir_faire="savoir_faire" --cloaking, piloting
local s_interfacing="interfacing" --hacking bonus
local s_composure="composure" --system resist %
local s_INTELLECT="INTELLECT"
local s_PSYCHE="PSYCHE"
local s_PHYSIQUE="PHYSIQUE"
local s_MOTORICS="MOTORICS"
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
        logic={category=s_INTELLECT},
        encylopedia={category=s_INTELLECT}, --scaling
        rhetoric={category=s_INTELLECT},
        drama={category=s_INTELLECT},
        conceptualization={category=s_INTELLECT}, --scaling
        visual_calculus={category=s_INTELLECT},
        volition={category=s_PSYCHE},
        inland_empire={category=s_PSYCHE}, --scaling
        empathy={category=s_PSYCHE}, --scales with number of races on board
        authority={category=s_PSYCHE}, --no scaling, dillution based
        espirit_de_corps={category=s_PSYCHE}, --no scaling, dillution based
        suggestion={category=s_PSYCHE}, --no scaling, individual check
        endurance={category=s_PHYSIQUE}, --scaling
        pain_threshold={category=s_PHYSIQUE}, --scaling
        physical_instrument={category=s_PHYSIQUE}, --scaling
        electrochemistry={category=s_PHYSIQUE},
        shivers={category=s_PHYSIQUE},
        half_light={category=s_PHYSIQUE}, --scaling
        hand_eye_cordination={category=s_MOTORICS},
        perception={category=s_MOTORICS}, --scaling
        reaction_speed={category=s_MOTORICS},
        savoir_faire={category=s_MOTORICS},  --inverse scaling
        interfacing={category=s_MOTORICS}, --scaling
        composure={category=s_MOTORICS},
    }

--After you add an event, you can test it with \EVENT [EVENTNAME]

--what if two things modify the same event?
--That is to say, multiple checks on the same event?
--I mean, you should really be updating this mod if you're doing that, this mod should be near the bottom of the mod list.
--Define a function to use to modify the event, and the data to pass to it.
--key is the name of the event.
--the rest of this depends on the structure of events we get in the loop.
--everything for an option needs to be in its check table.  Each check table should be self sufficient.


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
    return crewStats[statCategory] + stat
end


local function getPrintableStatTable(crewMem)
    local crewStats = safeLoadCrewStats(crewMem:GetSpecies())
    --todo for after I get the basics working, this is nice to have
end

--starting reactor = 7, 3, ending reactor = 25, 7. 18 run, 4 rise
local DEFAULT_STARTING_POWER = 7
local DEFAULT_POWER_CAP = 25
local STARTING_ATTRIBUTE_VAULE = 3
local ATTRIBUTE_VAULE_SOFT_CAP = 7
function getAutoShipStat(statName)
    local ownship = Hyperspace.ships.player
    local shipGraph = Hyperspace.ShipGraph.GetShipInfo(0)
    local point = ownship:GetRandomRoomCenter()
    local slot = shipGraph:GetClosestSlot(point, 0, false)
    local room = ownship.ship.vRoomList[slot.roomId]--For damage resist values
    local baseStat = ((Hyperspace.PowerManager.GetPowerManager(0):GetMaxPower() - DEFAULT_STARTING_POWER) * (ATTRIBUTE_VAULE_SOFT_CAP - STARTING_ATTRIBUTE_VAULE) / (DEFAULT_POWER_CAP - DEFAULT_STARTING_POWER)) + STARTING_ATTRIBUTE_VAULE
    if (statName == s_logic) then
        baseStat = baseStat + 2
    elseif (statName == s_encylopedia) then
        baseStat = baseStat + 1.5
    elseif (statName == s_rhetoric) then
        --n/a
    elseif (statName == s_drama) then
        --n/a
    elseif (statName == s_conceptualization) then
        --n/a
    elseif (statName == s_visual_calculus) then
        baseStat = baseStat + ((ownship:GetSystemPowerMax(lwl.SYS_PILOT) + ownship:GetSystemPowerMax(lwl.SYS_SENSORS)) / 2)
    elseif (statName == s_volition) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_BATTERY)
    elseif (statName == s_inland_empire) then
        baseStat = baseStat + ((500 - Hyperspace.playerVariables.stability) / 100)
    elseif (statName == s_empathy) then
        baseStat = baseStat - 2 + ownship:GetSystemPowerMax(lwl.SYS_OXYGEN) --Unlikely to ever matter as if you have any crew this method doesn't get called.
    elseif (statName == s_authority) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_DOORS)
    elseif (statName == s_espirit_de_corps) then
        baseStat = baseStat - Hyperspace.playerVariables.rep_general --Reputaiton is negative
    elseif (statName == s_suggestion) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_MIND)
    elseif (statName == s_endurance) then
        baseStat = baseStat + (room.extend.hullDamageResistChance / 10)
    elseif (statName == s_pain_threshold) then
        baseStat = baseStat + (room.extend.sysDamageResistChance / 10)
    elseif (statName == s_physical_instrument) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_DRONES)
    elseif (statName == s_electrochemistry) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_MIND) + ownship:GetSystemPowerMax(lwl.SYS_TEMPORAL) + ownship:GetSystemPowerMax(lwl.SYS_HACKING)
    elseif (statName == s_shivers) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_SENSORS)
    elseif (statName == s_half_light) then
        baseStat = baseStat + ((ownship:GetSystemPowerMax(lwl.SYS_WEAPONS) + ownship:GetSystemPowerMax(lwl.SYS_DRONES)) / 3)
    elseif (statName == s_hand_eye_cordination) then
        baseStat = baseStat + (ownship:GetDodgeFactor() / 15) --45 evade for 3 bonus
    elseif (statName == s_perception) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_SENSORS)
    elseif (statName == s_reaction_speed) then
        baseStat = baseStat + ((ownship:GetSystemPowerMax(lwl.SYS_PILOT) + ownship:GetSystemPowerMax(lwl.SYS_ENGINES)) / 3)
    elseif (statName == s_savoir_faire) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_CLOAKING) + ownship:GetSystemPowerMax(lwl.SYS_PILOT)
    elseif (statName == s_interfacing) then
        baseStat = baseStat + ownship:GetSystemPowerMax(lwl.SYS_HACKING)
    elseif (statName == s_composure) then --ion resist chance
        baseStat = baseStat + (room.extend.ionDamageResistChance / 10)
    end
    
    return baseStat
end

local function getNonDroneCrew(shipManager)
    local crewList = getAllMemberCrew(Hyperspace.ships.player)
    --uh, remove drone crew.
    return crewList
end

--nothing uses this raw
local function getSumStat(statName)
    local valueSum = 0
    local crewList = getAllMemberCrew(Hyperspace.ships.player)
    if (#crewList == 0) then
        valueSum = getAutoShipStat(statName)
    else
        --Iterate over player ship
        for i=1,#crewList do
            crewmem = crewList[i]
            valueSum = valueSum + getSpeciesStat(crewmem:GetSpecies(), statName)
        end
        
        --Then add your captain values
        valueSum = valueSum + getSpeciesStat("PLAYER", statName)
    end
    return valueSum
end

local function getAverageStat(statName)
    local totalStats = getSumStat(statName)
    local numCrew = #getAllMemberCrew(Hyperspace.ships.player)
    return totalStats / (numCrew + 1)
end

local function getStat(statName)
    return getAverageStat(statName)
end


--As a baseline, you have a 4332 statblock randomly assigned with one proficiency as Captain.
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

--PRE_CREATE_CHOICEBOX is what I want to manipulate choices.
--If I can edit the choices on the fly, this lets me inject changes with lua which is so what I want.
--And I can do the disco stuff on choice triggers, probably.


--TODO I might reduce these levels.
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

--ill see if i want inverse checks.
local function activeCheck(stat, amount)
    return (math.random(1,6) + math.random(1,6) + getStat(stat) >= amount)
end

local function passiveCheck(stat, amount)
    return (getStat(stat) + 6 >= amount)
end


--attribute values for guns?


--Lua button to check your attributes

--lua events that pop up out of combat
--lua events that pop up in combat, based on the ship you're fighting.
--These need to be very rare

--I want a symbol that interprets itself.
--Not just that it is the language, but the hardware as well.

--I _could_ do this in XML but that sounds like a huge pain.  Serioulsy not worth it, better to luify events than try to stoop to XML's featureless syntax.
--todo move this to lwl
local function printEvent(locationEvent)
    
end

global DISCO_EVENTS_LIST = {EXAMPLE_EVENT_NAME={checks={{passive=true, skill=s_volition, value=10}, {passive=false, skill=s_reaction_speed, value=13}}}
    
    
    }

local function appendChoices(locationEvent)
    local checks = DISCO_EVENTS_LIST[locationEvent.eventName]
    for i = 1,#checks do
        local check = checks[i]
        if (check.passive) then
            if (passiveCheck(check.skill, check.value)) then
                --for passive, append if it passes
            end
        else
            --append active checks to the list.  These have two events for pass and fail that they can trigger.  It picks one of them and uses it.  unless I get a way to append two possibilities for an event?
            
        end
    end
end

--uh, it's actually unclear to me if this works currently.  like hs might just not support it right now.
script.on_internal_event(Defines.InternalEvents.PRE_CREATE_CHOICEBOX, function(locationEvent)
        --this should go in its own file for exensibility
        print("pre event ", locationEvent.eventName)
            --locationEvent:GetChoices()
            --basically requires you make a new locaiton event and a choice to select it.
        if (locationEvent.eventName == "something") then
            --run check
            --do append
        elseif (locationEvent.eventName == "other thing") then
            
        end
        end)




--[[

You come to a space station.  There appear to be actual ghosts here.
Someone is fighting them, if you clear out the ghosts for him, he's like, oh, I guess I'm done here.  If you don't have a ghost crew, he joins you.
If you do have a ghost on your crew, you get some extra text and 



--deep ones
ᵃⁿ ᵒᵐᵉⁿ ʳᵒᵗᵃᵗᵉˢ. You f e e l like you are being w a t c h e d. ʸᵒᵘ ᵃʳᵉ 

Who's eyes are those eyes?

> A dead man walking.
>> Combat, all omen crew.
> Nobody I want to meet.
    authority, 12
        Whatever's here isn't getting any purchase on you.
        You feel your mind 
    Storage check
> Those eyes are god's eyes.
        You feel something open in-- outside of youʳˢᵉˡᶠ .  It strains at the edges of ˡᵉᵗ ᵐᵉ ᶦⁿ your ˡᵉᵗ ᵐᵉ ᶦⁿ mind, ˡᵉᵗ ᵐᵉ ᶦⁿ and you ʟᴇᴛ ᴍᴇ ɪɴ...
        > Let it in
        > Let it in
            Opening your perception to it, you find a new crewmate beside you.  It doesn't seem to say much, but somehow you know its name.
            Omen crew.
        > (green) Shove it out // volition 10, only shows on success.
            auth 16
                With a tremendous effort, you shove the thing out of your mind.  There's something here that wasn't before, but it's quickly falling apart.  You collect what you can from it.
                cont.
                    You're exhausted, like a post-workout burn, but you feel like if this ever returned, you could do it again. +1 Psyche flat buff.
                You strain your mind right back at this unknown intruder, but are rebuffed and thrown backwards.  It manifests in front of you in an explosion of metal and psychic energy.  Despite your opposition, it does not appear hostile, though the violent apperation caused some damage to the hull.  Breach, 1 hull damage.



--rebel sector?
--an f22 crashes into your ship, 3 hull, breach, fight, ally ASB
As you warp in, you see a ship beset by a swarm of tiny fighters.  You can't track their erratic movements and one of them crashes into your ship!  It seems jittery and confused.
--Engines 6 lets you evade this, hidden.
    1 hull, breach.
    (mind control)
    You use the mind control to placate the thing, putting it in a trance like state.  It conveys that it wants to destroy the larger ship.
        Well what are we waiting for?  Fire!
        Tell it you can't help.
            It hangs its head and requests to be thrown off the ship.
                Space it.
                
    Continue.
        You are unable to communicate with the construct before it launches itself bodily around your ship, knocking itself out and damaging your [SYSTEM] --ill need like six of these
        --random system damage

















--]]










