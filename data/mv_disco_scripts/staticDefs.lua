mods.discoVerseStaticDefinitions = {}
local dvsd = mods.discoVerseStaticDefinitions

dvsd.CREW_STAT_DEFINITIONS = {
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
    --DARKEST DESIRE
    OBELISK_ROYAL = {INTELLECT=7, PSYCHE=6, PHYSIQUE=6, physical_instrument=1, MOTORICS=4, composure=3},
    DEEP_ONE = {INTELLECT=5, PSYCHE=4, PHYSIQUE=5, MOTORICS=4},
    DEEP_ONE_CULTIST = {INTELLECT=4, PSYCHE=4, PHYSIQUE=5, MOTORICS=4},
    THE_SCARRED = {INTELLECT=5, PSYCHE=6, PHYSIQUE=6, MOTORICS=4},
    THE_SCARRED_ASCENDED = {INTELLECT=5, PSYCHE=10, PHYSIQUE=6, MOTORICS=6},
    ENLIGHTENED_HORROR = {INTELLECT=3, PSYCHE=8, PHYSIQUE=6, MOTORICS=4},
    --PONY_ENGI = {INTELLECT=3, PSYCHE=4, PHYSIQUE=6, MOTORICS=4},
    --OUTER EXPANSION
    ACID_SOLDIER = {INTELLECT=4, PSYCHE=4, PHYSIQUE=5, MOTORICS=2},
    ACID_CAPTAIN = {INTELLECT=5, PSYCHE=4, PHYSIQUE=6, MOTORICS=3},
    ACID_BILL = {INTELLECT=6, PSYCHE=6, PHYSIQUE=7, MOTORICS=4},
    NECRO_ENGI = {INTELLECT=4, PSYCHE=4, PHYSIQUE=3, MOTORICS=4},
    NECRO_LICH = {INTELLECT=6, PSYCHE=4, PHYSIQUE=3, MOTORICS=6},
    NECRO_KING = {INTELLECT=8, PSYCHE=5, PHYSIQUE=3, MOTORICS=7},




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
    BUTLER_DRONE = {INTELLECT=3, PSYCHE=4, PHYSIQUE=5, MOTORICS=5},
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
    ROOMBA = {INTELLECT=2, PSYCHE=2, PHYSIQUE=2, MOTORICS=2},
	YINYANG_DRONE = {INTELLECT=2, PSYCHE=2, PHYSIQUE=6, MOTORICS=2},
	YINYANG_CHAOS_DRONE = {INTELLECT=2, PSYCHE=2, PHYSIQUE=7, MOTORICS=2},
	HOLO_DRONE = {INTELLECT=3, PSYCHE=3, PHYSIQUE=2, MOTORICS=2},
	HOLO_CHAOS_DRONE = {INTELLECT=3, PSYCHE=4, PHYSIQUE=3, MOTORICS=2},
	SURGEON_DRONE = {INTELLECT=4, PSYCHE=3, PHYSIQUE=4, MOTORICS=5},
	SURGEON_CHAOS_DRONE = {INTELLECT=5, PSYCHE=4, PHYSIQUE=5, MOTORICS=5}
    --PONY =
}
local CREW_STAT_DEFINITIONS = dvsd.CREW_STAT_DEFINITIONS


--Base crew get 12 total stats.  Elite/Unique can have more.
--todo get all the names for the keys of this table
dvsd.CREW_STAT_TABLE = {
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
    unique_tully=CREW_STAT_DEFINITIONS.TULLY,
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
    drone_battle=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    drone_yinyang=CREW_STAT_DEFINITIONS.YINYANG_DRONE,
    drone_yinyang_chaos=CREW_STAT_DEFINITIONS.YINYANG_CHAOS_DRONE,
    loot_separatist_1=CREW_STAT_DEFINITIONS.BATTLE_DRONE_2,
    drone_battle2=CREW_STAT_DEFINITIONS.BATTLE_DRONE_2,
    repairboarder=CREW_STAT_DEFINITIONS.REPAIR_DRONE,
    repair=CREW_STAT_DEFINITIONS.REPAIR_DRONE,
    divrepair=CREW_STAT_DEFINITIONS.REPAIR_DRONE,
    butler=CREW_STAT_DEFINITIONS.BUTLER_DRONE,
    drone_recon=CREW_STAT_DEFINITIONS.RECON_DRONE,
    drone_recon_defense=CREW_STAT_DEFINITIONS.RECON_DRONE,
    doctor=CREW_STAT_DEFINITIONS.DOCTOR_DRONE,
    surgeon=CREW_STAT_DEFINITIONS.SURGEON_DRONE,
    surgeon_chaos=CREW_STAT_DEFINITIONS.SURGEON_CHAOS_DRONE,
    manning=CREW_STAT_DEFINITIONS.MANAGER_DRONE,
    manningenemy=CREW_STAT_DEFINITIONS.MANAGER_DRONE,
    drone_holodrone=CREW_STAT_DEFINITIONS.HOLO_DRONE,
    drone_holodrone_chaos=CREW_STAT_DEFINITIONS.HOLO_CHAOS_DRONE,
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
    fr_golden_diamond={INTELLECT=4, PSYCHE=3, PHYSIQUE=5, endurance=2, pain_threshold=1, physical_instrument=-1, MOTORICS=3, reaction_speed=-2, interfacing=-1},
    fr_copper_diamond={INTELLECT=5, drama=-2, PSYCHE=2, PHYSIQUE=3, MOTORICS=4},
    fr_adamantine_diamond={INTELLECT=3, PSYCHE=3, PHYSIQUE=4, endurance=2, pain_threshold=2, shivers=1, MOTORICS=3, composure=1},
    fr_golden_operator={INTELLECT=4, PSYCHE=3, PHYSIQUE=5, endurance=2, pain_threshold=1, physical_instrument=-1, MOTORICS=3, reaction_speed=-2, interfacing=-1},
    fr_copper_operator={INTELLECT=4, logic=1, encylopedia=1, PSYCHE=3, PHYSIQUE=2, MOTORICS=5, reaction_speed=-1, savoir_faire=-2},
    fr_adamantine_operator={INTELLECT=4, logic=1, encylopedia=1, conceptualization=1, visual_calculus=0, PSYCHE=3, PHYSIQUE=2, MOTORICS=5, composure=-5},
    fr_techno_operator={INTELLECT=4, logic=2, encylopedia=2, PSYCHE=4, PHYSIQUE=4, endurance=1, pain_threshold=1, MOTORICS=4, composure=-4}, --morph of all three
    --Elemental Lanius
    fr_golden_lanius_1={INTELLECT=3, PSYCHE=4, PHYSIQUE=4, MOTORICS=4},
    fr_golden_lanius_2={INTELLECT=4, PSYCHE=6, PHYSIQUE=5, MOTORICS=4},
    fr_golden_lanius_3={INTELLECT=5, PSYCHE=8, PHYSIQUE=6, MOTORICS=4},
    fr_copper_lanius={INTELLECT=4, PSYCHE=4, PHYSIQUE=4, MOTORICS=3},
    fr_adamantine_lanius={INTELLECT=4, PSYCHE=3, empathy=-2, PHYSIQUE=4, half_light=3, MOTORICS=4},
    --morph
    fr_blob_diamond={INTELLECT=4, PSYCHE=4, PHYSIQUE=5, MOTORICS=3},
    --Insurrection+ Selection
        --[[
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
    
    --Morph
    blobdeepone=CREW_STAT_DEFINITIONS.DEEP_ONE,
    --[[
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
    slug_hektar_elite=CREW_STAT_DEFINITIONS.SLUG_HEKTAR,--eh. they're not _that elite.
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
    --]]
    --TNE
    tne_drone_twin=CREW_STAT_DEFINITIONS.BATTLE_DRONE,
    tne_drone_twin_2=CREW_STAT_DEFINITIONS.BATTLE_DRONE_2,
    --[[
    tne_drone_pod
    tne_drone_peace
    tne_drone_exothermic
    tne_drone_vent
    tne_drone_discharge
    tne_drone_shipwrecker
    --]]
    
    --AEA
    aea_acid_soldier=ACID_SOLDIER,
    aea_acid_captain=ACID_CAPTAIN,
    aea_acid_bill=ACID_BILL,
    aea_necro_engi=NECRO_ENGI,
    aea_necro_lich=NECRO_LICH,
    aea_necro_king=NECRO_KING,
    --[[
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
dvsd.s_logic={name="Logic", internalName="logic"} --innate bonus
dvsd.s_encylopedia={name="Encylopedia", internalName="encylopedia"} --innate bonus
dvsd.s_rhetoric={name="Rhetoric", internalName="rhetoric"}
dvsd.s_drama={name="Drama", internalName="drama"}
dvsd.s_conceptualization={name="Conceptualization", internalName="conceptualization"}
dvsd.s_visual_calculus={name="Visual Calculus", internalName="visual_calculus"}
dvsd.s_volition={name="Volition", internalName="volition"}
dvsd.s_inland_empire={name="Inland Empire", internalName="inland_empire"} --anomoly detector, 
dvsd.s_empathy={name="Empathy", internalName="empathy"} --innate penalty, does not scale
dvsd.s_authority={name="Authority", internalName="authority"} --doors
dvsd.s_espirit_de_corps={name="Espirit de Corps", internalName="espirit_de_corps"}
dvsd.s_suggestion={name="Suggestion", internalName="suggestion"} --bonus for mind control
dvsd.s_endurance={name="Endurance", internalName="endurance"} --hull resist
dvsd.s_pain_threshold={name="Pain Threshold", internalName="pain_threshold"} --hull resist, system resist
dvsd.s_physical_instrument={name="Physical Instrument", internalName="physical_instrument"}
dvsd.s_electrochemistry={name="Electrochemistry", internalName="electrochemistry"} --mind control, hacking, temporal, the "weird" systems.
dvsd.s_shivers={name="Shivers", internalName="shivers"} --sensors, some augments
dvsd.s_half_light={name="Half Light", internalName="half_light"} --offensive system totals
dvsd.s_hand_eye_coordination={name="Hand-Eye Coordination", internalName="hand_eye_coordination"} --evasion%
dvsd.s_perception={name="Perception", internalName="perception"} --sensors, some augments
dvsd.s_reaction_speed={name="Reaction Speed", internalName="reaction_speed"} --piloting, engines
dvsd.s_savoir_faire={name="Savoir Faire", internalName="savoir_faire"} --cloaking, piloting
dvsd.s_interfacing={name="Interfacing", internalName="interfacing"} --hacking bonus
dvsd.s_composure={name="Composure", internalName="composure"} --system resist %

dvsd.s_INTELLECT={name="Intellect", internalName="INTELLECT", color=Graphics.GL_Color(.447, .592, .82, 1), eventColor="1C5CC8"}
dvsd.s_PSYCHE={name="Psyche", internalName="PSYCHE", color=Graphics.GL_Color(.537, .486, .754, 1), eventColor="897CC0"}
dvsd.s_PHYSIQUE={name="Physique", internalName="PHYSIQUE", color=Graphics.GL_Color(.682, .188, .258, 1), eventColor="AE3042"}
dvsd.s_MOTORICS={name="Motorics", internalName="MOTORICS", color=Graphics.GL_Color(.792, .635, .227, 1), eventColor="E8C744"}

dvsd.CHECK_DIFFICULTY_NAMES = {nil, nil, nil, nil, nil, TRIVIAL_NAME, TRIVIAL_NAME, EASY_NAME, EASY_NAME, MEDIUM_NAME, MEDIUM_NAME, CHALLENGING_NAME, FORMIDABLE_NAME, LEGENDARY_NAME, HEROIC_NAME, GODLY_NAME, IMPOSSIBLE_NAME, IMPOSSIBLE_NAME, IMPOSSIBLE_NAME}

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
dvsd.TRAIT_CATEGORIES = {
    dvsd.s_INTELLECT,
    dvsd.s_PSYCHE,
    dvsd.s_PHYSIQUE,
    dvsd.s_MOTORICS,
}

dvsd.TRAIT_DEFINITIONS = {
        logic={category=dvsd.s_INTELLECT, definition=dvsd.s_logic},
        encylopedia={category=dvsd.s_INTELLECT, definition=dvsd.s_encylopedia}, --scaling
        rhetoric={category=dvsd.s_INTELLECT, definition=dvsd.s_rhetoric},
        drama={category=dvsd.s_INTELLECT, definition=dvsd.s_drama},
        conceptualization={category=dvsd.s_INTELLECT, definition=dvsd.s_conceptualization}, --scaling
        visual_calculus={category=dvsd.s_INTELLECT, definition=dvsd.s_visual_calculus},
        volition={category=dvsd.s_PSYCHE, definition=dvsd.s_volition},
        inland_empire={category=dvsd.s_PSYCHE, definition=dvsd.s_inland_empire}, --scaling
        empathy={category=dvsd.s_PSYCHE, definition=dvsd.s_empathy}, --scales with number of races on board
        authority={category=dvsd.s_PSYCHE, definition=dvsd.s_authority}, --no scaling, dillution based
        espirit_de_corps={category=dvsd.s_PSYCHE, definition=dvsd.s_espirit_de_corps}, --no scaling, dillution based
        suggestion={category=dvsd.s_PSYCHE, definition=dvsd.s_suggestion}, --no scaling, individual check
        endurance={category=dvsd.s_PHYSIQUE, definition=dvsd.s_endurance}, --scaling
        pain_threshold={category=dvsd.s_PHYSIQUE, definition=dvsd.s_pain_threshold}, --scaling
        physical_instrument={category=dvsd.s_PHYSIQUE, definition=dvsd.s_physical_instrument}, --scaling
        electrochemistry={category=dvsd.s_PHYSIQUE, definition=dvsd.s_electrochemistry},
        shivers={category=dvsd.s_PHYSIQUE, definition=dvsd.s_shivers},
        half_light={category=dvsd.s_PHYSIQUE, definition=dvsd.s_half_light}, --scaling
        hand_eye_coordination={category=dvsd.s_MOTORICS, definition=dvsd.s_hand_eye_coordination},
        perception={category=dvsd.s_MOTORICS, definition=dvsd.s_perception}, --scaling
        reaction_speed={category=dvsd.s_MOTORICS, definition=dvsd.s_reaction_speed},
        savoir_faire={category=dvsd.s_MOTORICS, definition=dvsd.s_savoir_faire},  --inverse scaling
        interfacing={category=dvsd.s_MOTORICS, definition=dvsd.s_interfacing}, --scaling
        composure={category=dvsd.s_MOTORICS, definition=dvsd.s_composure},
    }

function dvsd.getSkillCategory(skill)
    return dvsd.TRAIT_DEFINITIONS[skill.internalName].category
end

local function rgbToHex(r, g, b)
    -- Clamp values to [0,1] in case of rounding errors
    local function clamp(x)
        return math.max(0, math.min(1, x))
    end

    -- Scale from [0,1] to [0,255] and round
    local r255 = math.floor(clamp(r) * 255 + 0.5)
    local g255 = math.floor(clamp(g) * 255 + 0.5)
    local b255 = math.floor(clamp(b) * 255 + 0.5)

    -- Format as hex string
    return string.format("%02X%02X%02X", r255, g255, b255)
end