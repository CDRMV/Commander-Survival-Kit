local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 

if DiskGetFileInfo('/lua/AI/CustomAIs_v2/ExtrasAI.lua') then
if import('/lua/AI/CustomAIs_v2/ExtrasAI.lua').AI.Name == 'AI Patch LOUD' and not import('/lua/AI/CustomAIs_v2/ExtrasAI.lua').AI.Name == 'AI Patch (Duncane)' then


SurfaceFormations = {
    'AttackFormation',
    'GrowthFormation',
	'ScatterFormation',
	'BlockFormation',
    'LOUDClusterFormation',
	'DMSCircleFormation',
}

AirFormations = {
    'AttackFormation',
    'GrowthFormation',
	'ScatterFormation',
	'BlockFormation',
	'LOUDClusterFormation',
	'DMSCircleFormation',
}

ComboFormations = {
    'AttackFormation',
    'GrowthFormation',
	'ScatterFormation',
	'BlockFormation',
	'DMSCircleFormation',
}




LOUDCEIL = math.ceil
LOUDCOS = math.cos
LOUDENTITY = EntityCategoryContains
LOUDFLOOR = math.floor
LOUDGETN = table.getn
LOUDINSERT = table.insert
LOUDMAX = math.max
LOUDMOD = math.mod
LOUDSIN = math.sin

RemainingCategory = { 'RemainingCategory', }



--================ LAND DATA ==============#


--=== LAND CATEGORIES ===#
AntiAir = ( categories.ANTIAIR - ( categories.EXPERIMENTAL + categories.DIRECTFIRE ) ) * categories.LAND
Artillery = ( categories.ARTILLERY + categories.INDIRECTFIRE - categories.ANTIAIR ) * categories.LAND
Construction = ( categories.COMMAND + categories.CONSTRUCTION + categories.ENGINEER ) * categories.LAND - categories.EXPERIMENTAL
DirectFire = (( categories.DIRECTFIRE - categories.CONSTRUCTION ) ) * categories.LAND
ShieldCat = categories.SHIELD + (categories.ANTIMISSILE * categories.TECH2)
SMDCat = categories.ANTIMISSILE * categories.TECH3
UtilityCat = (( ( categories.RADAR + categories.COUNTERINTELLIGENCE ) - categories.DIRECTFIRE ) + categories.SCOUT) * categories.LAND

DFElite = DirectFire * categories.ELITE
DFExp = DirectFire * categories.EXPERIMENTAL
DFTitan = DirectFire * categories.TITAN
DFHero = DirectFire * categories.HERO

--=== TECH LEVEL LAND CATEGORIES ===#
LandCategories = {
    Bot1 = (DirectFire * categories.TECH1) * categories.BOT - categories.SCOUT,
    Bot2 = (DirectFire * categories.TECH2) * categories.BOT - categories.SCOUT,
    Bot3 = (DirectFire * categories.TECH3) * categories.BOT - categories.SCOUT,

    Tank1 = (DirectFire * categories.TECH1) - categories.BOT - categories.SCOUT,
    Tank2 = (DirectFire * categories.TECH2) - categories.BOT - categories.SCOUT,
    Tank3 = (DirectFire * categories.TECH3) - categories.BOT - categories.SCOUT,

    Art1 = Artillery * categories.TECH1,
    Art2 = Artillery * categories.TECH2,
    Art3 = Artillery * (categories.TECH3 + categories.EXPERIMENTAL),

    AA = AntiAir,

    Com = Construction,

    Util = UtilityCat,

    Shields = ShieldCat,

    SMDS = SMDCat,

	Elite = DFElite,
	Titans = DFTitan,
	Heros = DFHero,
    Experimentals = DFExp,

    RemainingCategory = categories.LAND - ( DirectFire + Construction + Artillery + AntiAir + UtilityCat + DFExp + DFElite + DFTitan + DFHero + ShieldCat + SMDCat )
}

--=== SUB GROUP ORDERING ===#
Bots = { 'Bot3', 'Bot2', 'Bot1' }
Tanks = { 'Tank3', 'Tank2', 'Tank1' }
DF = { 'Tank3', 'Bot3', 'Tank2', 'Bot2', 'Tank1', 'Bot1' }
Art = { 'Art1', 'Art2', 'Art3' }
AA = { 'AA' }
Util = { 'Util' }
Com = { 'Com' }
Shield = { 'Shields','SMDS' }
Experimental = { 'Experimentals' }
Elite = { 'Elite' }
Titan = { 'Titans' }
Hero = { 'Heros' }
	
--=== LAND BLOCK TYPES =#
DFFirst = { Hero, Elite, Titan, Experimental, DF, Art, AA, Shield, Com, Util, RemainingCategory }
TankFirst = { Hero, Elite, Titan, Experimental, Tanks, Bots, Art, AA, Shield, Com, Util, RemainingCategory }
ShieldFirst = { Shield, AA, Art, DF, Com, Util, RemainingCategory }
AAFirst = { AA, DF, Art, Shield, Com, Util, RemainingCategory }
ArtFirst = { Art, AA, DF, Shield, Com, Util, RemainingCategory }
UtilFirst = { Util, AA, DF, Art, Shield, Com, Util, RemainingCategory }


--=== LAND BLOCKS ===#

--=== 3 Wide Growth Block / 6 Units
ThreeWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, },
	-- second row
    { DFFirst, DFFirst, DFFirst, },
}

--=== 4 Wide Growth Block / 16 Units
FourWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second row
    { UtilFirst, ShieldFirst, ShieldFirst, UtilFirst, },
	-- third row
    { UtilFirst, ShieldFirst, ShieldFirst, UtilFirst, },
    -- fourth Row
    { AAFirst, ArtFirst, ArtFirst, AAFirst,  },
}

--=== 5 Wide Growth Block/ 25 Units
FiveWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second row
    { DFFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst, },
    -- third row
    { UtilFirst, ShieldFirst, DFFirst, ShieldFirst,  UtilFirst, },
	-- fourth row
    { DFFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst, },
    -- fifth row
    { AAFirst, ArtFirst, DFFirst, ArtFirst, AAFirst, },
}

--=== 6 Wide Growth Block/ 36 Units
SixWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second row
    { DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst, },
    -- third row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst,  UtilFirst, },
    -- fourth row
    { AAFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, AAFirst, },
	-- fifth row
    { DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst, },
    -- sixth row
    { DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, DFFirst, },
}

--=== 7 Wide Growth Block/ 42 Units
SevenWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second Row
    { DFFirst, ShieldFirst, DFFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, },
    -- third row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, UtilFirst, },
    -- fourth row
    { AAFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, DFFirst, },
    -- fifth row
    { DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
    -- sixth row
    { UtilFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, UtilFirst, },
}

--=== 8 Wide Growth Block/ 56 Units
EightWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second Row
    { DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, },
    -- third row
    { DFFirst, UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, UtilFirst, DFFirst, },
    -- fourth row
    { DFFirst, AAFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, },
    -- fifth row
    { DFFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
    -- sixth row
    { UtilFirst, AAFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, AAFirst, UtilFirst, },
    -- seventh row
    { DFFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
}

--=== 9 Wide Growth Block/ 72 Units
NineWideGrowthFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, UtilFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second Row
    { DFFirst, DFFirst, ShieldFirst, DFFirst, AAFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, },
    -- third row
    { DFFirst, UtilFirst, AAFirst, DFFirst, ShieldFirst, DFFirst, AAFirst, UtilFirst, DFFirst, },
    -- fourth row
    { DFFirst, AAFirst, ShieldFirst, DFFirst, UtilFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, },
    -- fifth row
    { DFFirst, ArtFirst, AAFirst, ArtFirst, ShieldFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
    -- sixth row
    { UtilFirst, AAFirst, ShieldFirst, ArtFirst, UtilFirst, ArtFirst, ShieldFirst, AAFirst, UtilFirst, },
    -- seventh row
    { DFFirst, ArtFirst, AAFirst, ArtFirst, ShieldFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
    -- eighth row
    { DFFirst, ArtFirst, AAFirst, ArtFirst, ShieldFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
}

--=== Travelling Block
TravelSlot = { Experimental, Bots, Tanks, AA, Art, Shield, Util, Com }

TravelFormationBlock = {
    HomogenousRows = true,
    UtilBlocks = true,
    RowBreak = 0.25,
    { TravelSlot, TravelSlot, },
    { TravelSlot, TravelSlot, },
    { TravelSlot, TravelSlot, },
    { TravelSlot, TravelSlot, },
    { TravelSlot, TravelSlot, },
}

--=== 2 Row Attack Block - 8 units wide
TwoRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { UtilFirst, AAFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, AAFirst, UtilFirst },
}

--=== 2 Row Staggered Attack Block - 9 units wide
ThreeRowStaggeredAttackFormationBlock = {
    -- first row
    { ArtFirst, DFFirst, ArtFirst, DFFirst, ArtFirst, DFFirst, ArtFirst, DFFirst, ArtFirst },
    -- second row
    { UtilFirst, AAFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, AAFirst, UtilFirst, AAFirst },
}
    -- first row

--=== 3 Row Attack Block - 10 units wide
ThreeRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, UtilFirst, ShieldFirst, DFFirst },
    -- third row
    { DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, ArtFirst, AAFirst, DFFirst },  
}

--=== 4 Row Attack Block - 12 units wide
FourRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, UtilFirst, ShieldFirst, DFFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, UtilFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst },
    -- fourth row
    { AAFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, ArtFirst, UtilFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, AAFirst },   
}

--=== 5 Row Attack Block - 14 units wide
FiveRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { DFFirst, ShieldFirst, DFFirst, UtilFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, AAFirst, DFFirst, UtilFirst, DFFirst, DFFirst, DFFirst, DFFirst, AAFirst, DFFirst, AAFirst, DFFirst },
    -- fourth row
    { AAFirst, DFFirst, ShieldFirst, DFFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, UtilFirst, DFFirst, AAFirst, ShieldFirst, AAFirst },  
  	-- five row
    { ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst },  
}

--=== 6 Row Attack Block - 16 units wide
SixRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { DFFirst, ShieldFirst, DFFirst, UtilFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst },
    -- fourth row
    { DFFirst, ShieldFirst, UtilFirst, AAFirst, ShieldFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, UtilFirst, ShieldFirst, DFFirst },
  	-- fifth row
    { DFFirst, AAFirst, DFFirst, DFFirst, UtilFirst, DFFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, UtilFirst, DFFirst, DFFirst, AAFirst, DFFirst },  
  	-- sixth row
    { AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst },  
}

--=== 7 Row Attack Block - 18 units wide
SevenRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst },
    -- fourth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst },
  	-- fifth row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, UtilFirst },  
  	-- sixth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst },  
  	-- seventh row
    { ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst },  
}

--=== 8 Row Attack Block - 18 units wide
EightRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst },
    -- fourth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst },
  	-- fifth row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, AAFirst, UtilFirst },  
  	-- sixth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst },  
  	-- seventh row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, DFFirst, DFFirst, DFFirst },  
  	-- eight row
    { AAFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst },  
}

--=== 9 Row Attack Block - 18+ units wide
NineRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst },
    -- fourth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst },
  	-- fifth row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, AAFirst, UtilFirst },  
  	-- sixth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst },  
  	-- seventh row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, DFFirst, DFFirst, DFFirst },  
  	-- eight row
    { AAFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst },  
}

--================ AIR DATA ===============#

--=== AIR CATEGORIES ===#

StdAirUnits = categories.AIR - categories.EXPERIMENTAL - categories.TRANSPORTFOCUS + categories.uea0203
T4AirUnits = categories.AIR * categories.EXPERIMENTAL - categories.TRANSPORTFOCUS
TitanAirUnits = categories.AIR * categories.TITAN - categories.TRANSPORTFOCUS
HeroAirUnits = categories.AIR * categories.HERO - categories.TRANSPORTFOCUS
EliteAirUnits = categories.AIR * categories.ELITE - categories.TRANSPORTFOCUS
TransportationAir = categories.AIR * categories.TRANSPORTFOCUS


--=== TECH LEVEL AIR CATEGORIES ===#
-- this has been greatly simplified
AirCategories = { StdAirUnits = StdAirUnits, T4AirUnits = T4AirUnits, EliteAirUnits = EliteAirUnits, TitanAirUnits = TitanAirUnits, HeroAirUnits = HeroAirUnits}

--    RemainingCategory = categories.AIR - ( GroundAttackAir + TransportationAir + BomberAir + AAAir + AntiNavyAir + IntelAir + ExperimentalAir )
--    Ground2 = GroundAttackAir * categories.TECH2,
--    Ground3 = GroundAttackAir * categories.TECH3,
--    Bomb2 = BomberAir * categories.TECH2,
--    Bomb3 = BomberAir * categories.TECH3,
--    AA2 = AAAir * categories.TECH2,
--    AA3 = AAAir * categories.TECH3,
--    AN2 = AntiNavyAir * categories.TECH2,
--    AN3 = AntiNavyAir * categories.TECH3,
--    AIntel2 = IntelAir * categories.TECH2,
--    AIntel3 = IntelAir * categories.TECH3,


AirTransportCategories = {
    Trans1 = TransportationAir * categories.TECH1,
    Trans2 = TransportationAir * categories.TECH2,
    Trans3 = TransportationAir * categories.TECH3,
	Trans35 = TransportationAir * categories.ELITE,
	Trans4 = TransportationAir * categories.EXPERIMENTAL,
	Trans5 = TransportationAir * categories.TITAN,
	Trans6 = TransportationAir * categories.HERO,
}


--=== SUB GROUP ORDERING ===#
AirUnits = { 'StdAirUnits', 'T4AirUnits', 'EliteAirUnits', 'TitanAirUnits', 'HeroAirUnits', }
Transports = { 'Trans1', 'Trans2', 'Trans3', 'Trans35', 'Trans4', 'Trans5', 'Trans6', }

--local GroundAttack = {'Ground' }
--local Bombers = { 'Bomb' }
--local AntiAir = { 'AA' }
--local AntiNavy = {'AN' }
--local Intel = { 'AIntel' }
--local Remaining = { 'RemainingCategory' }

--=== Air Block Arrangement ===#

ChevronSlot = { AirUnits }
TransportSlot = { Transports }

InitialChevronBlock = {
    RepeatAllRows = false,
    HomogenousBlocks = true,
    ChevronSize = 3,
    { ChevronSlot },
    { ChevronSlot, ChevronSlot },
}

StaggeredChevronBlock = {
    RepeatAllRows = true,
    HomogenousBlocks = true,
    { ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, },
}


--=== Transport Formations ===#
TwoWideTransportGrowthFormation = {
    LineBreak = 1,
    { TransportSlot, TransportSlot, },    
    { TransportSlot, TransportSlot, },
}

ThreeWideTransportGrowthFormation = {
    LineBreak = 1,
    { TransportSlot, TransportSlot, TransportSlot, },    
    { TransportSlot, TransportSlot, TransportSlot, },
    { TransportSlot, TransportSlot, TransportSlot, },    
}

FourWideTransportGrowthFormation = {
    LineBreak = 1,
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, },    
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, },
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, },    
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, },    
}

FiveWideTransportGrowthFormation = {
    LineBreak = 1,
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, TransportSlot },    
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, TransportSlot },    
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, TransportSlot },    
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, TransportSlot },    
    { TransportSlot, TransportSlot, TransportSlot, TransportSlot, TransportSlot },    
}



--=========================================#
--============== NAVAL DATA ===============#

--=== BASIC GROUPS ===#

LightAttackNaval = categories.LIGHTBOAT
FrigateNaval = categories.FRIGATE
SubNaval = categories.SUBMARINE
DestroyerNaval = categories.DESTROYER
CruiserNaval = categories.CRUISER
BattleshipNaval = categories.BATTLESHIP
CarrierNaval = categories.CARRIER
--NukeSubNaval = categories.NUKE
MobileSonar = categories.MOBILESONAR
DefensiveBoat = categories.DEFENSIVEBOAT
RemainingNaval = categories.NAVAL - ( LightAttackNaval + FrigateNaval + SubNaval + DestroyerNaval + CruiserNaval + BattleshipNaval + CarrierNaval + DefensiveBoat + MobileSonar)

-- Naval formation blocks #####

NavalSpacing = 1.1

--[[
local StandardNavalBlock = {
    { { {0, 0}, }, { 'Carriers', 'Battleships', 'Cruisers', 'Destroyers', 'Frigates', 'Submarines' }, },
    { { {-1, 1.5}, {1, 1.5}, }, { 'Destroyers', 'Cruisers', 'Frigates', 'Submarines'}, },
    { { {-2.5, 0}, {2.5, 0}, }, { 'Cruisers', 'Battleships', 'Destroyers', 'Frigates', 'Submarines' }, },
    { { {-1, -1.5}, {1, -1.5}, }, { 'Frigates', 'Battleships', 'Submarines' }, },
    { { {-3, 2}, {3, 2}, {-3, 0}, {3, 0}, }, { 'Submarines', }, },
}
--]]

--=== PRIMARY SUB-GROUPS ===#

-- surface ships --
NavalCategories = {

    LightCount = LightAttackNaval,
    FrigateCount = FrigateNaval,
    CruiserCount = CruiserNaval,
    DestroyerCount = DestroyerNaval,
    BattleshipCount = BattleshipNaval,
    CarrierCount = CarrierNaval,
    --NukeSubCount = NukeSubNaval,
    MobileSonarCount = MobileSonar + DefensiveBoat,		

    RemainingCategory = RemainingNaval,
}

-- all submarines --
SubmarineCategories = {
    SubCount = SubNaval,
}


--=== SUB GROUPS ===#

Frigates = { 'FrigateCount', 'LightCount', }
Destroyers = { 'DestroyerCount', }
Cruisers = { 'CruiserCount', }
Battleships = { 'BattleshipCount', }
Subs = { 'SubCount', }
Space = { }
--local NukeSubs = { 'NukeSubCount', }
Carriers = { 'CarrierCount', }
Sonar = {'MobileSonarCount', }


--=== UNIT ORDERING ===#

FrigatesOnly = { Frigates }
FrigatesFirst = { Frigates, Destroyers, RemainingCategory }
DestroyersFirst = { Destroyers, Cruisers, RemainingCategory }
CruisersFirst = { Cruisers, Destroyers, Battleships, Sonar, RemainingCategory }
BattleshipsFirst = { Battleships, Cruisers, Destroyers, Carriers, Sonar, Frigates, RemainingCategory }
CarriersFirst = { Carriers, Battleships, Cruisers, Destroyers, Sonar, RemainingCategory }

Subs = { Subs, RemainingCategory }

SonarOnly = { Sonar, RemainingCategory }
SonarFirst = { Sonar, Frigates, Destroyers, Cruisers, Battleships, Carriers, RemainingCategory }


--========================================#
--======= Naval Growth Formations ========#
--========================================#

ThreeNavalGrowthFormation = {

    LineBreak = 0.3,
	
	{															FrigatesOnly,																	},
	{ 										FrigatesOnly, 		SonarOnly,			FrigatesOnly					 							},	
	{					FrigatesFirst,		Space,				DestroyersFirst,	Space,				FrigatesFirst							},
    { FrigatesOnly,		SonarFirst,			CruisersFirst,		Space,				CruisersFirst,		SonarFirst,			FrigatesOnly		},
    { 					DestroyersFirst,	Space, 				BattleshipsFirst,	Space,				CruisersFirst						 	},
	
}

FiveNavalGrowthFormation = {

    LineBreak = 0.3,

	{ FrigatesOnly, 	Space,	 			Space,				FrigatesOnly,		Space,				Space,				FrigatesOnly 		},	
	{ Space,			DestroyersFirst,	SonarOnly,			DestroyersFirst,	Space,				DestroyersFirst, 	Space				},
    { FrigatesFirst,	SonarFirst,			CruisersFirst,		SonarFirst,			CruisersFirst,		SonarFirst,			FrigatesFirst		},
    { Space, 			BattleshipsFirst,	Space,				BattleshipsFirst,	Space,	 			BattleshipsFirst,	Space		 		},
    { FrigatesFirst,	Space,			  	CarriersFirst,		Space,				BattleshipsFirst,	Space,				FrigatesFirst 		},
	{ Space,			DestroyersFirst,	SonarFirst,			DestroyersFirst,	SonarFirst,			DestroyersFirst,	Space				},	
}

SevenNavalGrowthFormation = {

    LineBreak = 0.28,
	{																				Space,																							},
    { FrigatesOnly,		Space,		 		Space, 				Space,		 		FrigatesOnly, 		Space,				Space,				Space,				FrigatesOnly	},
    { Space,			DestroyersFirst,	SonarFirst,			CruisersFirst,		Space,				CruisersFirst,		SonarFirst,	 		DestroyersFirst,	Space			},
	{ FrigatesOnly,		Space,				CruisersFirst,		Space,				BattleshipsFirst,	Space,				CruisersFirst,		Space,				FrigatesOnly	},
    { SonarOnly,		DestroyersFirst,	SonarOnly,			BattleshipsFirst,	Space,				BattleshipsFirst,	SonarOnly,			DestroyersFirst,	SonarOnly 		},
	{ FrigatesFirst,	Space,				DestroyersFirst,	Space,				CarriersFirst,		Space,				DestroyersFirst,	Space,				FrigatesFirst	},
    { SonarFirst,		CruisersFirst,		SonarFirst, 		BattleshipsFirst,	Space,				BattleshipsFirst,	SonarFirst,			CruisersFirst,		SonarFirst 		},
	{ FrigatesFirst,	SonarOnly,			BattleshipsFirst,	Space,				BattleshipsFirst,	Space,				BattleshipsFirst,	SonarOnly,			FrigatesFirst	},
	{ SonarFirst,		BattleshipsFirst,	SonarFirst,			CarriersFirst,		SonarFirst,			CarriersFirst,		SonarFirst,			BattleshipsFirst,	SonarFirst		},		
}


--============================================#
--========= Naval Attack Formations ==========#
--============================================#

FiveWideNavalAttackFormation = {

    LineBreak = 0.35,
	
	{ Space,			FrigatesOnly,		Space,				FrigatesOnly,		Space				},
	{ FrigatesFirst,	Space,				FrigatesFirst,		Space,				FrigatesFirst		},
	{ Space,			DestroyersFirst,	Space,				DestroyersFirst,	Space				},
	{ DestroyersFirst,	SonarFirst,			CarriersFirst,		SonarFirst,			DestroyersFirst		},
	{ Space,			BattleshipsFirst,	Space,				BattleshipsFirst,	Space				},

}

SevenWideNavalAttackFormation = {

    LineBreak = 0.3,

	{ FrigatesOnly, 	Space,	 			Space,				FrigatesOnly,		Space,				Space,				FrigatesOnly 		},	
	{ Space,			DestroyersFirst,	SonarOnly,			DestroyersFirst,	Space,				DestroyersFirst, 	Space				},
    { FrigatesFirst,	SonarFirst,			CruisersFirst,		SonarFirst,			CruisersFirst,		SonarFirst,			FrigatesFirst		},
    { Space, 			BattleshipsFirst,	Space,				BattleshipsFirst,	Space,	 			BattleshipsFirst,	Space		 		},
    { FrigatesFirst,	Space,			  	CarriersFirst,		Space,				BattleshipsFirst,	Space,				FrigatesFirst 		},
	{ Space,			DestroyersFirst,	SonarFirst,			DestroyersFirst,	SonarFirst,			DestroyersFirst,	Space				},	

}

NineWideNavalAttackFormation = {

    LineBreak = 0.28,
	
	{																				Space,																							},
    { FrigatesOnly,		Space,		 		Space, 				Space,		 		FrigatesOnly, 		Space,				Space,				Space,				FrigatesOnly	},
    { Space,			DestroyersFirst,	SonarFirst,			CruisersFirst,		Space,				CruisersFirst,		SonarFirst,	 		DestroyersFirst,	Space			},
	{ FrigatesOnly,		Space,				CruisersFirst,		Space,				BattleshipsFirst,	Space,				CruisersFirst,		Space,				FrigatesOnly	},
    { SonarOnly,		DestroyersFirst,	SonarOnly,			BattleshipsFirst,	Space,				BattleshipsFirst,	SonarOnly,			DestroyersFirst,	SonarOnly 		},
	{ FrigatesFirst,	Space,				DestroyersFirst,	Space,				CarriersFirst,		Space,				DestroyersFirst,	Space,				FrigatesFirst	},
    { SonarFirst,		CruisersFirst,		SonarFirst, 		BattleshipsFirst,	Space,				BattleshipsFirst,	SonarFirst,			CruisersFirst,		SonarFirst 		},
	{ FrigatesFirst,	SonarOnly,			BattleshipsFirst,	Space,				BattleshipsFirst,	Space,				BattleshipsFirst,	SonarOnly,			FrigatesFirst	},
	{ SonarFirst,		BattleshipsFirst,	SonarFirst,			CarriersFirst,		SonarFirst,			CarriersFirst,		SonarFirst,			BattleshipsFirst,	SonarFirst		},
	
}

--==============================================#
--============ Sub Growth Formations ===========#
--==============================================#

ThreeWideSubGrowthFormation = {

    LineBreak = 0.25,
	
    { Subs, Space, Subs },
    { Space, Subs, Space },    	
	
}

FiveWideSubGrowthFormation = {

    LineBreak = 0.25,
	
    { Subs, Space, Subs, Space, Subs },
    { Space, Subs, Space, Subs, Space },
	
}

SevenWideSubGrowthFormation = {

    LineBreak = 0.25,
	
    { Space, Subs, Space, Subs, Space, Subs, Space },
    { Subs, Space, Subs, Space, Subs, Space, Subs },
    { Space, Subs, Space, Subs, Space, Subs, Space },

}

NineWideSubGrowthFormation = {

    LineBreak = 0.25,
	
    { Space, Subs, Space, Subs, Space, Subs, Space },
    { Subs, Space, Subs, Space, Subs, Space, Subs },
    { Space, Subs, Space, Subs, Space, Subs, Space },
    { Subs, Space, Subs, Space, Subs, Space, Subs },	

}

--==============================================#
--============ Sub Attack Formations ===========#  
--==============================================#

FiveWideSubAttackFormation = {

    LineBreak = 0.25,
	
    { Subs, Subs, Subs, Subs, Subs },    

}

SevenWideSubAttackFormation = {

    LineBreak = 0.5,
	
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs },

}

NineWideSubAttackFormation = {

    LineBreak = 0.5,
	
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },

}


--============ Formation Pickers ============#
function PickBestTravelFormationIndex( typeName, distance )

    if typeName == 'AirFormations' then
	
        return 0;
		
    else
	
        return 1;
		
    end
	
end

function PickBestFinalFormationIndex( typeName, distance )

    return -1;
	
end


--================ THE GUTS ====================#
--============ Formation Functions =============#
--==============================================#
function AttackFormation( formationUnits )

    local FormationPos = {}

    local landUnitsList = CategorizeLandUnits( formationUnits )
	local seaUnitsList = CategorizeSeaUnits( formationUnits )
	local airUnitsList = CategorizeAirUnits( formationUnits )
	local TransportUnitsList = CategorizeTransportUnits( formationUnits )

    local UnitTotal = landUnitsList.UnitTotal or 0

	if UnitTotal > 0 then
	
		local landBlock
        local defaultspacing = 1.2
    
		if UnitTotal <= 16 then       -- 8 wide
			landBlock = TwoRowAttackFormationBlock

		elseif UnitTotal <= 27 then   -- 10 wide
			landBlock = ThreeRowStaggeredAttackFormationBlock
            defaultspacing = 1.2            
            
		elseif UnitTotal <= 30 then   -- 10 wide
			landBlock = ThreeRowAttackFormationBlock
            defaultspacing = 1.1            
            
		elseif UnitTotal <= 48 then   -- 12 wide
			landBlock = FourRowAttackFormationBlock
            defaultspacing = 1.02
            
		elseif UnitTotal <= 70 then   -- 14 wide
			landBlock = FiveRowAttackFormationBlock
            defaultspacing = 0.96
            
		elseif UnitTotal <= 96 then   -- 16 wide
			landBlock = SixRowAttackFormationBlock
            defaultspacing = 0.92
            
		elseif UnitTotal <= 126 then  -- 18 wide
			landBlock = SevenRowAttackFormationBlock
            defaultspacing = 0.90            
            
		elseif UnitTotal <= 160 then  -- 20 wide
			landBlock = EightRowAttackFormationBlock
            defaultspacing = 0.84            
		else
			landBlock = NineRowAttackFormationBlock
            defaultspacing = 0.82            
		end
    
		BlockBuilderLand(landUnitsList, landBlock, LandCategories, FormationPos, defaultspacing)
	
	end

    UnitTotal = seaUnitsList.UnitTotal or 0

	-- if there are sea units --
	if UnitTotal > 0 then
	
		local seaBlock
		local subBlock
		
		local subUnitsList = {}
		
		subUnitsList.UnitTotal = seaUnitsList.SubCount
		subUnitsList.SubCount = seaUnitsList.SubCount

		-- do submarine formations --
		if subUnitsList.UnitTotal > 0 then
		
			if subUnitsList.UnitTotal <= 3 then
		
				subBlock = ThreeWideSubGrowthFormation
			
			elseif subUnitsList.UnitTotal <= 6 then
		
				subBlock = FiveWideSubGrowthFormation
			
			else
		
				subBlock = NineWideSubAttackFormation
			
			end	
		
			BlockBuilderLand( subUnitsList, subBlock, SubmarineCategories, FormationPos, 0.7 )
            
            seaUnitsList.UnitTotal = seaUnitsList.UnitTotal - subUnitsList.UnitTotal
            seaUnitsList.SubCount = 0
			
		end

		-- remove the submarine count from the total count -- 
	    UnitTotal = UnitTotal - seaUnitsList.SubCount
		
		-- do surface unit formations --
		if UnitTotal > 0 then
		
			if UnitTotal <= 12 then
		
				seaBlock = FiveWideNavalAttackFormation
			
			elseif UnitTotal <= 28 then
		
				seaBlock = SevenWideNavalAttackFormation
			
			else
		
				seaBlock = NineWideNavalAttackFormation
			
			end
		
			BlockBuilderLand( seaUnitsList, seaBlock, NavalCategories, FormationPos, 0.90 )
			
		end
		
	end

	if airUnitsList.UnitTotal > 0 then
		BlockBuilderAir(airUnitsList, StaggeredChevronBlock, FormationPos)
	end

    UnitTotal = TransportUnitsList.UnitTotal or 0

	if UnitTotal > 0 then
	
		if UnitTotal <= 4 then
		
			BlockBuilderLand(TransportUnitsList, TwoWideTransportGrowthFormation, AirTransportCategories, FormationPos)
			
		elseif UnitTotal <= 9 then
		
			BlockBuilderLand(TransportUnitsList, ThreeWideTransportGrowthFormation, AirTransportCategories, FormationPos)
			
		elseif UnitTotal <= 16 then
		
			BlockBuilderLand(TransportUnitsList, FourWideTransportGrowthFormation, AirTransportCategories, FormationPos)			
			
		elseif UnitTotal <= 25 then
		
			BlockBuilderLand(TransportUnitsList, FiveWideTransportGrowthFormation, AirTransportCategories, FormationPos)
		end
	end	

    --LOG("*AI DEBUG ATTACK FORMATION is "..repr(FormationPos))
    
    return FormationPos
end

function GrowthFormation( formationUnits )

    local FormationPos = {}

    local landUnitsList = CategorizeLandUnits( formationUnits )
	local seaUnitsList = CategorizeSeaUnits( formationUnits )
    local airUnitsList = CategorizeAirUnits( formationUnits )
	local TransportUnitsList = CategorizeTransportUnits( formationUnits )

    local UnitTotal = landUnitsList.UnitTotal or 0

	if UnitTotal > 0 then
	
	    local landBlock
	
		if UnitTotal <= 6 then
		
			landBlock = ThreeWideGrowthFormationBlock
			
		elseif UnitTotal <= 16 then
		
			landBlock = FourWideGrowthFormationBlock
			
		elseif UnitTotal <= 25 then
		
			landBlock = FiveWideGrowthFormationBlock
			
		elseif UnitTotal <= 36 then
		
			landBlock = SixWideGrowthFormationBlock
			
		elseif UnitTotal <= 42 then
		
			landBlock = SevenWideGrowthFormationBlock
			
		elseif UnitTotal <= 56 then
		
			landBlock = EightWideGrowthFormationBlock
			
		else
		
			landBlock = NineWideGrowthFormationBlock
			
		end
	
		BlockBuilderLand(landUnitsList, landBlock, LandCategories, FormationPos)
		
	end
    
    UnitTotal = seaUnitsList.UnitTotal or 0
    
	-- if there are sea units --
	if UnitTotal > 0 then
	
		local seaBlock
		local subBlock
		
		local subUnitsList = {}
		
		subUnitsList.UnitTotal = seaUnitsList.SubCount
		subUnitsList.SubCount = seaUnitsList.SubCount

		-- do submarine formations --
		if subUnitsList.UnitTotal > 0 then
		
			if subUnitsList.UnitTotal <= 3 then
		
				subBlock = ThreeWideSubGrowthFormation
			
			elseif subUnitsList.UnitTotal <= 6 then
		
				subBlock = FiveWideSubGrowthFormation
			
			elseif subUnitsList.UnitTotal <= 10 then
		
				subBlock = SevenWideSubGrowthFormation
			
			else
			
				subBlock = NineWideSubGrowthFormation
				
			end
		
			BlockBuilderLand( subUnitsList, subBlock, SubmarineCategories, FormationPos, 0.7 )
            
            seaUnitsList.UnitTotal = seaUnitsList.UnitTotal - subUnitsList.UnitTotal
            seaUnitsList.SubCount = 0
			
		end

		-- remove the submarine count from the total count -- 
	    seaUnitsList.UnitTotal = seaUnitsList.UnitTotal - seaUnitsList.SubCount
        
        UnitTotal = seaUnitsList.UnitTotal or 0
		
		-- do surface unit formations --
		if UnitTotal > 0 then
		
			if UnitTotal <= 12 then
		
				seaBlock = ThreeNavalGrowthFormation
			
			elseif UnitTotal <= 24 then
		
				seaBlock = FiveNavalGrowthFormation
			
			else
		
				seaBlock = SevenNavalGrowthFormation
			
			end
		
			BlockBuilderLand( seaUnitsList, seaBlock, NavalCategories, FormationPos, 0.9 )
			
		end
		
	end
	
	if airUnitsList.UnitTotal > 0 then
	
		BlockBuilderAir(airUnitsList, StaggeredChevronBlock, FormationPos)
		
	end
    
    UnitTotal = TransportUnitsList.UnitTotal or 0
	
	if UnitTotal > 0 then
	
		if UnitTotal <= 4 then
		
			BlockBuilderLand(TransportUnitsList, TwoWideTransportGrowthFormation, AirTransportCategories, FormationPos)
			
		elseif UnitTotal <= 9 then
		
			BlockBuilderLand(TransportUnitsList, ThreeWideTransportGrowthFormation, AirTransportCategories, FormationPos)
			
		elseif UnitTotal <= 16 then
		
			BlockBuilderLand(TransportUnitsList, FourWideTransportGrowthFormation, AirTransportCategories, FormationPos)			
			
		elseif UnitTotal <= 25 then
		
			BlockBuilderLand(TransportUnitsList, FiveWideTransportGrowthFormation, AirTransportCategories, FormationPos)
			
		end
		
	end	
	
    return FormationPos
	
end

function BlockFormation( formationUnits )

    local LOUDFLOOR = LOUDFLOOR
    local LOUDMOD = LOUDMOD

    local smallUnitsList = {}
    local largeUnitsList = {}
    local smallUnits = 0
    local largeUnits = 0
    
    local footPrintSize

    for i,u in formationUnits do
	
        footPrintSize = u:GetFootPrintSize()

        if footPrintSize > 2.75 then
		
            largeUnitsList[largeUnits] = { u }
            largeUnits = largeUnits + 1
        else
		
            smallUnitsList[smallUnits] = { u }
            smallUnits = smallUnits + 1
        end
		
    end

    local FormationPos = {}
	local counter = 0
	
    local rotate = true
    local ALLUNITS = categories.ALLUNITS
    local width = LOUDCEIL( math.sqrt(smallUnits+largeUnits) )
    local length = (smallUnits+largeUnits) / width
    
    local adjIndex, offsetX, offsetY, Y

    -- Put small units (Size 1 through 3) in front of the formation
    for i in smallUnitsList do
	
		Y = LOUDFLOOR(i/width)
	
        offsetX = (( LOUDMOD(i,width)  - LOUDFLOOR(width* 0.5) ) * 1.5) + 1
        offsetY = ( Y - LOUDFLOOR(length* 0.5) ) * 1.5

		counter = counter + 1
        FormationPos[counter] = { offsetX, -offsetY, ALLUNITS, Y, rotate }
    end

    -- Put large units (Size >= 2.75) in the back of the formation
    for i in largeUnitsList do
	
        adjIndex = smallUnits + i
		Y = LOUDFLOOR(adjIndex/width)
		
        offsetX = (( LOUDMOD(adjIndex,width)  - LOUDFLOOR(width* 0.5) ) * 1.5) + 1
        offsetY = ( Y - LOUDFLOOR(length* 0.5) ) * 1.5

		counter = counter + 1
        FormationPos[counter] = { offsetX, -offsetY, ALLUNITS, Y, rotate }		
    end

    return FormationPos
	
end

-- local function for performing lerp
local function lerp( alpha, a, b )
    return a + ((b-a) * alpha)
end

function CircleFormation( formationUnits )

    local LOUDCOS = LOUDCOS
    local LOUDMAX = LOUDMAX
    local LOUDSIN = LOUDSIN

    local rotate = false
	
    local FormationPos = {}
	local counter = 0

    local ALLUNITS = categories.ALLUNITS
    local numUnits = LOUDGETN(formationUnits)
    local sizeMult = 2.0 + LOUDMAX(1.0, numUnits * 0.33)

    -- make circle around center point
    for i in formationUnits do
	
        offsetX = sizeMult * LOUDSIN( lerp( i/numUnits, 0.0, 6.28 ) )
        offsetY = sizeMult * LOUDCOS( lerp( i/numUnits, 0.0, 6.28 ) )
		
		counter = counter + 1
        FormationPos[counter] = { offsetX, offsetY, ALLUNITS, 0, rotate }
    end

    return FormationPos
end

function GuardFormation( formationUnits )

    local LOUDCOS = LOUDCOS
    local LOUDSIN = LOUDSIN
    local LOUDENTITY = LOUDENTITY
	
    local FormationPos = {}
	
    local NAVALTEST = categories.NAVAL * categories.MOBILE

    local naval = false
    local sizeMult = 3
    
    for k,v in formationUnits do
    
        if not v.Dead and LOUDENTITY( NAVALTEST, v ) then
        
            naval = true
            sizeMult = 8
            break
        end
        
    end

    local ALLUNITS = categories.ALLUNITS
	local counter = 0
    local ringChange = 5
    local rotate = false
    local unitCount = 1

    -- make circle around center point
    for i in formationUnits do
	
        if unitCount == ringChange then
		
            ringChange = ringChange + 5
			
            if naval then
			
                sizeMult = sizeMult + 8
				
            else
			
                sizeMult = sizeMult + 3
				
            end
			
            unitCount = 1
			
        end
		
        offsetX = sizeMult * LOUDSIN( lerp( unitCount/ringChange, 0.0, 6.28 ))
        offsetY = sizeMult * LOUDCOS( lerp( unitCount/ringChange, 0.0, 6.28 ))

		counter = counter + 1
		FormationPos[counter] = { offsetX - 10, offsetY, ALLUNITS, 0, rotate }
		
        unitCount = unitCount + 1
		
    end

    return FormationPos
end

function DMSCircleFormation( formationUnits )

    local LOUDCOS = LOUDCOS
    local LOUDMAX = LOUDMAX
    local LOUDSIN = LOUDSIN

    local rotate = false
	
    local FormationPos = {}
	local counter = 0

    local ALLUNITS = categories.ALLUNITS
    local numUnits = LOUDGETN(formationUnits)

	local sizeMult = LOUDMAX(1.0, numUnits * 0.2)

    --- make circle around center point
    for i in formationUnits do
	
        offsetX = sizeMult * LOUDSIN( lerp( i/numUnits, 0.0, 6.28 ) )
        offsetY = sizeMult * LOUDCOS( lerp( i/numUnits, 0.0, 6.28 ) )
		
		counter = counter + 1
        FormationPos[counter] = { offsetX, offsetY, ALLUNITS, 0, rotate }
    end

    return FormationPos
end

function LOUDClusterFormation( formationUnits )

	local LOUDCOS = LOUDCOS
	local LOUDSIN = LOUDSIN
	local LOUDMAX = LOUDMAX
	local LOUDGETN = LOUDGETN
	
    local rotate = false
	
    local FormationPos = {}
	local counter = 0

    local ALLUNITS = categories.ALLUNITS
    local numUnits = LOUDGETN(formationUnits)
    
    local offsetX, offsetY
    local ring = 0
    local ringChange = 1
    local unitCount = 0
    local sizeMult = 0
    
    -- make rings around center point
    for i in formationUnits do
       
		
        offsetX = sizeMult * LOUDSIN( lerp( unitCount/ringChange, 0.0, 6.28 ) )
        offsetY = sizeMult * LOUDCOS( lerp( unitCount/ringChange, 0.0, 6.28 ) )
		
		counter = counter + 1
        FormationPos[counter] = { offsetX, offsetY, ALLUNITS, 0, rotate }
		
        unitCount = unitCount + 1
		
		if unitCount == ringChange then
            numUnits = numUnits - ringChange
            
            ring = ring + 1
            ringChange = (ring * 5) + ring
            sizeMult = LOUDMAX(0, ringChange * 0.14)
			
            if ringChange > numUnits then
                ringChange = numUnits
            end
            unitCount = 0
        end
    end

    --LOG("*AI DEBUG LOUD CLUSTER is "..repr(FormationPos))
    
    return FormationPos
end

function ScatterFormation( formationUnits )

    local LOUDENTITY = LOUDENTITY
    local LOUDCOS = LOUDCOS
    local LOUDSIN = LOUDSIN

    local rotate = false
	
    local FormationPos = {}
    local count = 0
	
    local NAVALTEST = categories.NAVAL * categories.MOBILE

    local naval = false
    local sizeMult = 3
	
    for k,v in formationUnits do
	
        if not v.Dead and LOUDENTITY( NAVALTEST, v ) then
            naval = true
            sizeMult = 8
            break
			
        elseif v.Dead then
			formationUnits[v] = nil
		end

    end

    local ALLUNITS = categories.ALLUNITS
    local offsetX, offsetY
    local ringChange = 5
    local unitCount = 1

    -- make circle around center point
	
    for i in formationUnits do
	
        if unitCount == ringChange then
		
            ringChange = ringChange + 5
			
            if naval then
                sizeMult = sizeMult + 8
            else
                sizeMult = sizeMult + 3
            end
            unitCount = 1
        end
		
        offsetX = sizeMult * LOUDSIN( lerp( unitCount/ringChange, 0.0, 6.28 ))
        offsetY = sizeMult * LOUDCOS( lerp( unitCount/ringChange, 0.0, 6.28 ))

        count = count + 1
        FormationPos[count] = { offsetX, offsetY, ALLUNITS, 0, rotate }
        
        unitCount = unitCount + 1
		
    end

    return FormationPos
end




--=========== LAND BLOCK BUILDING =================#
function BlockBuilderLand( unitsList, formationBlock, categoryTable, FormationPos, spacing, linespacing)

    local LOUDGETN = LOUDGETN
	local LOUDCEIL = LOUDCEIL
	local LOUDINSERT = LOUDINSERT
	local LOUDMOD = LOUDMOD
    
    local normalized_row_width, colSpot, colType, halfway_column_spot
	
	local function GetColSpot(rowLen, col)

        local LOUDFLOOR = LOUDFLOOR
        local LOUDMOD = LOUDMOD

		normalized_row_width = rowLen

		-- row width is normalized to the next even value
		if LOUDMOD(rowLen,2) == 1 then
	
			normalized_row_width = rowLen + 1
		end
		
		-- default to left unless current fill number is even then it's right
		colType = 'left'
	
		if LOUDMOD(col, 2) == 0 then
	
			colType = 'right'
		end
		
		-- which fill number we'on divided in half
		colSpot = LOUDFLOOR(col * 0.5)
	
		-- the spot number which is the centre spot
		halfway_column_spot = normalized_row_width * 0.5
		
		-- we're either left or right of the centre position by a certain amount
		if colType == 'left' then
	
			return halfway_column_spot - colSpot
		else
	
			return halfway_column_spot + colSpot
		end
	
	end

    -- between units --
    local spacing = spacing or .8
    
    -- between lines of units --
    -- this feature not yet implemented --
    -- LineBreak should still work if it's part of the data
    local linespacing = spacing or .8
	
    local numRows = LOUDGETN(formationBlock)
	
    local i = 1
    local whichRow = 1
    local whichCol = 1
	
    local currRowLen = LOUDGETN(formationBlock[whichRow])
    local inserted = false
    local formationLength = 0    
    local rowType = false
    
    local currColSpot, currSlot, HomogenousRows
    
    --LOG("*AI DEBUG BlockBuilderLand for "..unitsList.UnitTotal.." units using "..repr(unitsList) )

	-- loop thru all the units until all are done
    while unitsList.UnitTotal >= i do
	
		-- if at the end of row (current column > rowlength) then advance the row counter
        if whichCol > currRowLen then
		
			-- if we're at the last row of the formation then reset the row to 1
			-- the length of the formation is incremented by one PLUS the RowBreak value (this makes it a break between repetitions of the whole formation)
            if whichRow == numRows then
			
                whichRow = 1
				
                if formationBlock.RowBreak then
				
                    formationLength = formationLength + 1 + formationBlock.RowBreak
					
                else
				
                    formationLength = formationLength + 1
					
                end
				
			-- otherwise we're just onto the next row of the formation 
			-- the length of the formation is incremented by one PLUS the LineBreak value (LineBreak controls the spacing between rows of units)
            else
			
                whichRow = whichRow + 1
				
                if formationBlock.LineBreak then
				
                    formationLength = formationLength + 1 + formationBlock.LineBreak
					
                else
				
                    formationLength = formationLength + 1
					
                end
				
                rowType = false
				
            end
			
            whichCol = 1
			
            currRowLen = LOUDGETN(formationBlock[whichRow])
			
        end
		
		-- using the number of spots in a row, and which fill value we're on in this iteration - which spot we will use
		-- this routine fills the middle of the row and then right and then left and then right again and left again
        currColSpot = GetColSpot(currRowLen, whichCol)
		
		-- which categories will go into this spot in this row
        currSlot = formationBlock[whichRow][currColSpot]
		
        for _, unittype in currSlot do
        
            HomogenousRows = formationBlock.HomogenousRows
            
            local grp = false

            for _, group in unittype do
            
                grp = group
			
                if not HomogenousRows or (rowType == false or rowType == unittype) then
				
                    if unitsList[group] > 0 then
					
                        local xPos
						
                        if LOUDMOD( currRowLen, 2 ) == 0 then
						
                            xPos = LOUDCEIL(whichCol* 0.5) - .5
							
                            if not (LOUDMOD(whichCol, 2) == 0) then
							
                                xPos = xPos * -1
                            end
                        else
						
                            if whichCol == 1 then
							
                                xPos = 0
                            else
							
                                xPos = LOUDCEIL( ( (whichCol-1) * 0.5 ) )
								
                                if not (LOUDMOD(whichCol, 2) == 0) then
								
                                    xPos = xPos * -1
                                end
                            end
                        end
						
                        if HomogenousRows and not rowType then
						
                            rowType = unittype
                        end
						
						-- notice the use of whichRow to determine the movement delay between rows --
                        -- each successive row will start moving 1 tick later than the one ahead of it --
                        LOUDINSERT( FormationPos, { xPos * spacing, -formationLength, categoryTable[group], (whichRow-1), true} )

                        inserted = true
						
                        unitsList[group] = unitsList[group] - 1
						
                        break
                    end
                end
            end
		
			if inserted then
		
				i = i + 1
				inserted = false
				
				break

            end
			
        end
		
        whichCol = whichCol + 1
    end

    return FormationPos
end

--============ AIR BLOCK BUILDING =============#
function BlockBuilderAir(unitsList, airBlock, FormationPos)

	local LOUDGETN = LOUDGETN
	local LOUDINSERT = LOUDINSERT
	
    local numRows = LOUDGETN(airBlock)
    local i = 1
    local whichRow = 1
    local whichCol = 1
    local chevronPos = 1
    local currRowLen = LOUDGETN(airBlock[whichRow])
    
    local longestRow = 1
    local longestLength = 0
	
    while i < numRows do
        if LOUDGETN(airBlock[i]) > longestLength then
            longestLength = LOUDGETN(airBlock[i])
            longestRow = i
        end
        i = i + 1
    end
    
    local chevronSize = airBlock.ChevronSize or 5    
    local chevronType = false
    
    local formationLength = 0
    
    local spacing = 1.15
 
    i = 1
    
    local currSlot
    local inserted = false
    local xPos, yPos
    
    -- loop thru the unittypes found in UnitsList
    for _, cat in AirUnits do
    
        -- we have to reset all the control variables each loop to insure we
        -- get the 'overlaying' effect we're looking for
        i = 1
        
        whichRow = 1
        whichCol = 1
        
        chevronPos = 1
        currRowLen = LOUDGETN(airBlock[whichRow])
        chevronType = false
        
        formationLength = 0
        
        -- check if there are any in the unit count
        if unitsList[cat] > 0 then
            
            -- now we can execute the original code -- driven by the number of units in the category
            -- recylcing the formation each time
            while unitsList[cat] >= i do
            
                -- reset values if we've filled a chevron
                if chevronPos > chevronSize then
		
                    chevronPos = 1
                    chevronType = false
			
                    if whichCol == currRowLen then
			
                        if whichRow == numRows then
				
                            if airBlock.RepeatAllRows then
                                whichRow = 1
                                currRowLen = LOUDGETN(airBlock[whichRow])
                            end
					
                        else
                            whichRow = whichRow + 1
                            currRowLen = LOUDGETN(airBlock[whichRow])
                        end
				
                        formationLength = formationLength + 1
                        whichCol = 1
				
                    else
                        whichCol = whichCol + 1
                    end
                end
		
                currSlot = airBlock[whichRow][whichCol]

                xPos, yPos = GetChevronPosition(chevronPos, whichCol, currRowLen, formationLength)

                LOUDINSERT(FormationPos, {xPos*spacing, yPos*spacing, AirCategories[cat], 0, true})

                i = i + 1
		
                chevronPos = chevronPos + 1
            end
        end
    end

    return FormationPos
end


function GetChevronPosition(chevronPos, currCol, currRowLen, formationLen)

	local LOUDFLOOR = LOUDFLOOR
	local LOUDMOD = LOUDMOD
	
    local offset = LOUDFLOOR(chevronPos* 0.5) * .375
    local xPos = offset
	
    if LOUDMOD(chevronPos,2) == 0 then
        xPos = -1 * offset
    end
	
    local yPos = -offset
	
    yPos = yPos + ( formationLen * -1.5 )
	
    local firstBlockOffset = -2
	
    if LOUDMOD(currRowLen,2) == 1 then
        firstBlockOffset = -1
    end
	
    local blockOff = LOUDFLOOR(currCol* 0.5) * 2
	
    if LOUDMOD(currCol,2) == 1 then
        blockOff = -blockOff
    end
	
    xPos = xPos + blockOff + firstBlockOffset
	
    return xPos, yPos
end


--=========== NAVAL UNIT BLOCKS ============#
function NavalBlocks( unitsList, navyType )

    local Carriers = true
    local Battleships = true
    local Cruisers = true
    local Destroyers = true
    local unitNum = 1
	
	local FormationPos = {}
    local count = 0
	
    for i,v in navyType do
	
        for k,u in v[2] do
		
            if u == 'Carriers' and Carriers and unitsList.CarrierCount > 0 then
                for j, coord in v[1] do
                    if unitsList.CarrierCount ~= 0 then
                        count = count + 1
                        FormationPos[count] = { coord[1]*NavalSpacing, coord[2]*NavalSpacing, categories.NAVAL * categories.AIRSTAGINGPLATFORM * ( categories.TECH3 + categories.EXPERIMENTAL ), 0, true }
                        unitsList.CarrierCount = unitsList.CarrierCount - 1
                        unitNum = unitNum + 1
                    end
                end
                Carriers = false
                break
				
            elseif u == 'Battleships' and Battleships and unitsList.BattleshipCount > 0 then
                for j, coord in v[1] do
                    if unitsList.BattleshipCount ~= 0 then
                        count = count + 1
                        FormationPos[count] = { coord[1]*NavalSpacing, coord[2]*NavalSpacing, BattleshipNaval, 0, true }
                        unitsList.BattleshipCount = unitsList.BattleshipCount - 1
                        unitNum = unitNum + 1
                    end
                end
                Battleships = false
                break
				
            elseif u == 'Cruisers' and Cruisers and unitsList.CruiserCount > 0 then
                for j, coord in v[1] do
                    if unitsList.CruiserCount ~= 0 then
                        count = count + 1
                        FormationPos[count] = { coord[1]*NavalSpacing, coord[2]*NavalSpacing, CruiserNaval, 0, true }
                        unitNum = unitNum + 1
                        unitsList.CruiserCount = unitsList.CruiserCount - 1
                    end
                end
                Cruisers = false
                break
				
            elseif u == 'Destroyers' and Destroyers and unitsList.DestroyerCount > 0 then
                for j, coord in v[1] do
                    if unitsList.DestroyerCount > 0 then
                        count = count + 1
                        FormationPos[count] = { coord[1]*NavalSpacing, coord[2]*NavalSpacing, DestroyerNaval, 0, true }
                        unitNum = unitNum + 1
                        unitsList.DestroyerCount = unitsList.DestroyerCount - 1
                    end
                end
                Destroyers = false
                break
				
            elseif u == 'Frigates' and unitsList.FrigateCount > 0 then
                for j, coord in v[1] do
                    if unitsList.FrigateCount > 0 then
                        count = count + 1
                        FormationPos[count] = { coord[1]*NavalSpacing, coord[2]*NavalSpacing, FrigateNaval, 0, true }
                        unitNum = unitNum + 1
                        unitsList.FrigateCount = unitsList.FrigateCount - 1
                    end
                end
                break
				
            elseif u == 'Frigates' and unitsList.LightCount > 0 then
                for j,coord in v[1] do
                    if unitsList.LightCount > 0 then
                        count = count + 1
                        FormationPos[count] = { coord[1]*NavalSpacing, coord[2]*NavalSpacing, LightAttackNaval, 0, true }
                        unitNum = unitNum + 1
                        unitsList.LightCount = unitsList.LightCount - 1
                    end
                end
                break
				
            elseif u == 'Submarines' and unitsList.SubCount > 0 then
                for j,coord in v[1] do
                    if ( unitsList.SubCount + unitsList.NukeSubCount ) > 0 then
                        count = count + 1
                        FormationPos[count] = { coord[1]*NavalSpacing, coord[2]*NavalSpacing, SubNaval, 0, true }
                        unitNum = unitNum + 1
                        unitsList.SubCount = unitsList.SubCount - 1
                    end
                end
                break
				
            end
        end
    end

    local sideTable = { 0, -2, 2 }
    local sideIndex = 1
    local length = -6

    i = unitNum

    -- Figure out how many left we have to assign
    local numLeft = unitsList.UnitTotal - i + 1
    
    if numLeft == 2 then
        sideIndex = 2
    end

    while i <= unitsList.UnitTotal do
        if unitsList.CarrierCount > 0 then
            count = count + 1
            FormationPos[count] = { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, categories.NAVAL * categories.AIRSTAGINGPLATFORM * ( categories.TECH3 + categories.EXPERIMENTAL ), 0, true  }
            unitNum = unitNum + 1
            unitsList.CarrierCount = unitsList.CarrierCount - 1
            
        elseif unitsList.BattleshipCount > 0 then
            count = count + 1
            FormationPos[count] = { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, BattleshipNaval, 0, true }
            unitNum = unitNum + 1
            unitsList.BattleshipCount = unitsList.BattleshipCount - 1
            
        elseif unitsList.CruiserCount > 0 then
            count = count + 1
            FormationPos[count] = { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, CruiserNaval, 0, true }
            unitNum = unitNum + 1
            unitsList.CruiserCount = unitsList.CruiserCount - 1
            
        elseif unitsList.DestroyerCount > 0 then
            count = count + 1
            FormationPos[count] = { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, DestroyerNaval, 0, true }
            unitNum = unitNum + 1
            unitsList.DestroyerCount = unitsList.DestroyerCount - 1
            
        elseif unitsList.FrigateCount > 0 then
            count = count + 1
            FormationPos[count] = { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, FrigateNaval, 0, true }
            unitNum = unitNum + 1
            unitsList.FrigateCount = unitsList.FrigateCount - 1
            
        elseif unitsList.LightCount > 0 then
            count = count + 1
            FormationPos[count] = { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, LightAttackNaval, 0, true }
            unitNum = unitNum + 1
            unitsList.LightCount = unitsList.LightCount - 1
            
        elseif ( unitsList.SubCount + unitsList.NukeSubCount ) > 0 then
            count = count + 1
            FormationPos[count] = { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, SubNaval, 0, true }
            unitNum = unitNum + 1
            unitsList.SubCount = unitsList.SubCount - 1
            
        elseif ( unitsList.MobileSonarCount ) > 0 then
            count = count + 1
            FormationPos[count] = { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, MobileSonar + DefensiveBoat, 0, true }
            unitNum = unitNum + 1
            unitsList.MobileSonarCount = unitsList.MobileSonarCount - 1
            
        elseif ( unitsList.RemainingCategory ) > 0 then
            count = count + 1
            FormationPos[count] = { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, NavalCategories.RemainingCategory, 0, true } 
            unitNum = unitNum + 1
            unitsList.RemainingCategory = unitsList.RemainingCategory - 1
        end

        -- Figure out the next viable location for the naval unit
        numLeft = numLeft - 1
        sideIndex = sideIndex + 1
        if sideIndex == 4 then
            length = length - 2
            if numLeft == 2 then
                sideIndex = 2
            else
                sideIndex = 1
            end
        end

        i = i + 1
    end
    
    return FormationPos
end


--========= UNIT SORTING ==========#

-- OK - a great deal of data reduction here 
-- it was clear that while all these breakdowns of air units
-- by category and tier was nice - it was NOT being used in
-- any meaningful fashion - so we simplified it - reducing
-- data usage and processing
function CategorizeAirUnits( formationUnits )

    local LOUDENTITY = LOUDENTITY

    local unitsList = { StdAirUnits = 0, T4AirUnits = 0, EliteAirUnits = 0, TitanAirUnits = 0, HeroAirUnits = 0, UnitTotal = 0 }
	
    for i,u in formationUnits do
	
		if not u.Dead then
			
            for subcat,_ in AirCategories do
            
                if LOUDENTITY( AirCategories[subcat], u) then
                
                    unitsList[subcat] = unitsList[subcat] + 1
                    unitsList.UnitTotal = unitsList.UnitTotal + 1
                    break
                end
            end
		end
        
    end

    return unitsList
end

function CategorizeTransportUnits( formationUnits )

    local LOUDENTITY = LOUDENTITY

    local unitsList = { Trans1 = 0, Trans2 = 0, Trans3 = 0, Trans35 = 0, Trans4 = 0, Trans5 = 0, Trans6 = 0, UnitTotal = 0 }
	
    for i,u in formationUnits do
	
		if not u.Dead then
		
			for subcat,_ in AirTransportCategories do
			
				if LOUDENTITY(AirTransportCategories[subcat], u) then
				
					unitsList[subcat] = unitsList[subcat] + 1
					unitsList.UnitTotal = unitsList.UnitTotal + 1
					break                               
				end
			end			
		end
    end

    return unitsList
end

function CategorizeSeaUnits( formationUnits )

    local LOUDENTITY = LOUDENTITY

    local unitsList = { UnitTotal = 0, BattleshipCount = 0, CarrierCount = 0, CruiserCount = 0, DestroyerCount = 0, FrigateCount = 0, LightCount = 0, MobileSonarCount = 0, SubCount = 0, NukeSubCount = 0, RemainingCategory = 0 }

    for i,u in formationUnits do
	
		if not u.Dead then
		
			for navcat,_ in NavalCategories do
			
				if LOUDENTITY(NavalCategories[navcat], u) then
				
					unitsList[navcat] = unitsList[navcat] + 1
					unitsList.UnitTotal = unitsList.UnitTotal + 1
					break
				end
			end
		
			-- categorize subs
			for subcat,_ in SubmarineCategories do
			
				if LOUDENTITY(SubmarineCategories[subcat], u) then
				
					unitsList[subcat] = unitsList[subcat] + 1
					unitsList.UnitTotal = unitsList.UnitTotal + 1
					break                               
				end
			end
		end
    end
	
    return unitsList
end

function CategorizeLandUnits( formationUnits )

    local unitsList = { UnitTotal = 0 }
	
	local LOUDENTITY = LOUDENTITY
	
    for i,u in formationUnits do
	
		if not u.Dead then
		
			for landcat,_ in LandCategories do

				if LOUDENTITY(LandCategories[landcat], u) then
                
                    if unitsList[landcat] then
				
                        unitsList[landcat] = unitsList[landcat] + 1
                        unitsList.UnitTotal = unitsList.UnitTotal + 1
                        break
                        
                    else

                        unitsList[landcat] = 1
                        unitsList.UnitTotal = unitsList.UnitTotal + 1
                        break
                    end
                    
				end
			end
		end
    end

    return unitsList
end

end

else

SurfaceFormations = {
    'AttackFormation',
    'GrowthFormation',
}

AirFormations = {
    'AttackFormation',
    'GrowthFormation',
}

ComboFormations = {
    'AttackFormation',
    'GrowthFormation',
}

FormationPos = {} # list to be returned

#=========================================#
#================ LAND DATA ==============#
#=========================================#
RemainingCategory = { 'RemainingCategory', }

#=== LAND CATEGORIES ===#
DirectFire = (( categories.DIRECTFIRE - categories.CONSTRUCTION ) ) * categories.LAND
Construction = ( categories.COMMAND + categories.CONSTRUCTION + categories.ENGINEER ) * categories.LAND
Artillery = (( categories.ARTILLERY + categories.INDIRECTFIRE ) - categories.ANTIAIR ) * categories.LAND
AntiAir = ( categories.ANTIAIR - ( categories.EXPERIMENTAL + categories.DIRECTFIRE ) ) * categories.LAND
UtilityCat = (( ( categories.RADAR + categories.COUNTERINTELLIGENCE ) - categories.DIRECTFIRE ) + categories.SCOUT) * categories.LAND
DFExp = DirectFire * categories.EXPERIMENTAL
ShieldCat = categories.uel0307 + categories.ual0307 + categories.xsl0307

#=== TECH LEVEL LAND CATEGORIES ===#
LandCategories = {
    Bot1 = (DirectFire * categories.TECH1) * categories.BOT - categories.SCOUT,
    Bot2 = (DirectFire * categories.TECH2) * categories.BOT - categories.SCOUT,
    Bot3 = (DirectFire * categories.TECH3) * categories.BOT - categories.SCOUT,
	Bot35 = (DirectFire * categories.ELITE) * categories.BOT - categories.SCOUT,
    Bot4 = (DirectFire * categories.EXPERIMENTAL) * categories.BOT - categories.SCOUT,
	Bot5 = (DirectFire * categories.HERO) * categories.BOT - categories.SCOUT,
    Bot6 = (DirectFire * categories.TITAN) * categories.BOT - categories.SCOUT,

    Tank1 = (DirectFire * categories.TECH1) - categories.BOT - categories.SCOUT,
    Tank2 = (DirectFire * categories.TECH2) - categories.BOT - categories.SCOUT,
    Tank3 = (DirectFire * categories.TECH3) - categories.BOT - categories.SCOUT,
	Tank35 = (DirectFire * categories.ELITE) - categories.BOT - categories.SCOUT,
    Tank4 = (DirectFire * categories.EXPERIMENTAL) - categories.BOT - categories.SCOUT,
    Tank5 = (DirectFire * categories.HERO) - categories.BOT - categories.SCOUT,
	Tank6 = (DirectFire * categories.TITAN) - categories.BOT - categories.SCOUT,
		
    Art1 = Artillery * categories.TECH1,
    Art2 = Artillery * categories.TECH2,
    Art3 = Artillery * categories.TECH3,
	Art35 = Artillery * categories.ELITE,
    Art4 = Artillery * categories.EXPERIMENTAL,
	Art5 = Artillery * categories.HERO,
	Art6 = Artillery * categories.TITAN,

    AA1 = AntiAir * categories.TECH1,
    AA2 = AntiAir * categories.TECH2,
    AA3 = AntiAir * categories.TECH3,
	AA35 = AntiAir * categories.ELITE,
	AA4 = AntiAir * categories.EXPERIMENTAL,
	AA5 = AntiAir * categories.HERO,
	AA6 = AntiAir * categories.TITAN,

    Com1 = Construction * categories.TECH1,
    Com2 = Construction * categories.TECH2,
    Com3 = Construction - (categories.TECH1 + categories.TECH2 + categories.EXPERIMENTAL),
	Com35 = Construction * categories.ELITE,
    Com4 = Construction * categories.EXPERIMENTAL,
	Com5 = Construction * categories.HERO,
	Com6 = Construction * categories.TITAN,
	
    Util1 = (UtilityCat * categories.TECH1) + categories.OPERATION,
    Util2 = UtilityCat * categories.TECH2,
    Util3 = UtilityCat * categories.TECH3,
	Util35 = UtilityCat * categories.ELITE,
    Util4 = UtilityCat * categories.EXPERIMENTAL,
	Util5 = UtilityCat * categories.HERO,
    Util6 = UtilityCat * categories.TITAN,

    Shields = ShieldCat,		
		
    Experimentals = DFExp,

    RemainingCategory = categories.LAND - ( DirectFire + Construction + Artillery + AntiAir + UtilityCat + DFExp + ShieldCat )
}

#=== SUB GROUP ORDERING ===#
Bots = { 'Bot6', 'Bot5', 'Bot4', 'Bot35', 'Bot3', 'Bot2', 'Bot1', }
Tanks = { 'Tank6', 'Tank5', 'Tank4', 'Tank35', 'Tank3', 'Tank2', 'Tank1', }
DF = { 'Tank6', 'Bot6', 'Tank5', 'Bot5', 'Tank4', 'Bot4', 'Tank35', 'Bot35', 'Tank3', 'Bot3', 'Tank2', 'Bot2', 'Tank1', 'Bot1',}
Art = { 'Art6', 'Art5', 'Art4', 'Art35', 'Art3', 'Art2', 'Art1', }
T1Art = { 'Art1', 'Art2', 'Art3', 'Art35', 'Art4', 'Art5', 'Art6',}
AA = { 'AA6', 'AA5', 'AA4', 'AA35', 'AA3', 'AA2', 'AA1', }
Util = { 'Util6', 'Util5', 'Util4', 'Util35', 'Util3', 'Util2', 'Util1', }
Com = { 'Com6', 'Com5', 'Com4', 'Com35', 'Com3', 'Com2', 'Com1', }
Shield = { 'Shields', }
Experimental = { 'Experimentals', }
	
#=== LAND BLOCK TYPES =#
DFFirst = { Experimental, DF, T1Art, AA, Shield, Com, Util, RemainingCategory }
TankFirst = { Experimental, Tanks, Bots, Art, AA, Shield, Com, Util, RemainingCategory }
ShieldFirst = { Shield, AA, T1Art, DF, Com, Util, RemainingCategory }
AAFirst = { AA, DF, T1Art, Art, Shield, Com, Util, RemainingCategory }
ArtFirst = { Art, AA, DF, Shield, Com, Util, RemainingCategory }
T1ArtFirst = { T1Art, AA, DF, Shield, Com, Util, RemainingCategory }
UtilFirst = { Util, AA, T1Art, DF, Shield, Com, Util, RemainingCategory }


#=== LAND BLOCKS ===#

#=== 3 Wide Attack Block / 3 Units ===#
ThreeWideAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, },
}

#=== 4 Wide Attack Block / 12 Units ===#
FourWideAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, DFFirst, },
    ## second row
    { UtilFirst, ShieldFirst, ShieldFirst, UtilFirst, },
    ## third Row
    { AAFirst, ArtFirst, ArtFirst, AAFirst,  },
}

#=== 5 Wide Attack Block ===#
FiveWideAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    ## second row
    { DFFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, },
    ## third row
    { UtilFirst, ShieldFirst, DFFirst, ShieldFirst,  UtilFirst, },
    ## fourth row
    { AAFirst, DFFirst, ArtFirst, DFFirst, AAFirst, },
}

#=== 6 Wide Attack Block ===#
SixWideAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    ## second row
    { DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, },
    ## third row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst,  UtilFirst, },
    ## fourth row
    { AAFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, AAFirst, },
    ## fifth row
    { DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, DFFirst, },
}

#=== 7 Wide Attack Block ===#
SevenWideAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    ## second Row
    { DFFirst, ShieldFirst, DFFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, },
    ## third row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, UtilFirst, },
    ## fourth row
    { AAFirst, ShieldFirst, AAFirst, T1ArtFirst, ShieldFirst, AAFirst, DFFirst, },
    ## fifth row
    { DFFirst, AAFirst, T1ArtFirst, T1ArtFirst, AAFirst, T1ArtFirst, DFFirst, },
    ## sixth row
    { UtilFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, UtilFirst, },
}

#=== 8 Wide Attack Block ===#
EightWideAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    ## second Row
    { DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, },
    ## third row
    { UtilFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, UtilFirst, },
    ## fourth row
    { DFFirst, AAFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, },
    ## fifth row
    { DFFirst, T1ArtFirst, AAFirst, T1ArtFirst, T1ArtFirst, AAFirst, T1ArtFirst, DFFirst, },
    ## sixth row
    { UtilFirst, AAFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, AAFirst, UtilFirst, },
    ## seventh row
    { DFFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
}

#=== Travelling Block ===#
TravelSlot = { Experimental, Bots, Tanks, AA, Art, Shield, Util, Com }
TravelFormationBlock = {
    HomogenousRows = true,
    UtilBlocks = true,
    RowBreak = 0.5,
    { TravelSlot, TravelSlot, },
    { TravelSlot, TravelSlot, },
    { TravelSlot, TravelSlot, },
    { TravelSlot, TravelSlot, },
    { TravelSlot, TravelSlot, },
}

#=== 2 Row Attack Block - 8 units wide ===#
TwoRowAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    ## second row
    { UtilFirst, AAFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, AAFirst, UtilFirst },
}

#=== 3 Row Attack Block - 10 units wide ===#
ThreeRowAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    ## second row
    { UtilFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, AAFirst, ShieldFirst, UtilFirst },
    ## third row
    { DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, ArtFirst, AAFirst, DFFirst },  
}

#=== 4 Row Attack Block - 12 units wide ===#
FourRowAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    ## second row
    { UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst },
    ## third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst },
    ## fourth row
    { AAFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, AAFirst },   
}

#=== 5 Row Attack Block - 14 units wide ===#
FiveRowAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    ## second row
    { UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst },
    ## third row
    { DFFirst, AAFirst, DFFirst, AAFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, AAFirst, DFFirst, AAFirst, DFFirst },
    ## fourth row
    { AAFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, AAFirst },  
  	## five row
    { ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst },  
}

#=== 6 Row Attack Block - 16 units wide ===#
SixRowAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    ## second row
    { UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst },
    ## third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst },
    ## fourth row
    { AAFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, AAFirst },
  	## fifth row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, UtilFirst },  
  	## sixth row
    { AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst },  
}

#=== 7 Row Attack Block - 18 units wide ===#
SevenRowAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    ## second row
    { UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst },
    ## third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst },
    ## fourth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst },
  	## fifth row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, UtilFirst },  
  	## sixth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst },  
  	## seventh row
    { ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst },  
}

#=== 8 Row Attack Block - 18 units wide ===#
EightRowAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    ## second row
    { UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst },
    ## third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst },
    ## fourth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst },
  	## fifth row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, AAFirst, UtilFirst },  
  	## sixth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst },  
  	## seventh row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, DFFirst, DFFirst, DFFirst },  
  	## eight row
    { AAFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst },  
}

#=== 9 Row Attack Block - 18+ units wide ===#
NineRowAttackFormationBlock = {
    ## first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    ## second row
    { UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst },
    ## third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst },
    ## fourth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst },
  	## fifth row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, AAFirst, UtilFirst },  
  	## sixth row
    { AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, AAFirst },  
  	## seventh row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, DFFirst, DFFirst, DFFirst },  
  	## eight row
    { AAFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst },  
}
#=========================================#
#================ AIR DATA ===============#
#=========================================#

#=== AIR CATEGORIES ===#
GroundAttackAir = ( categories.AIR * categories.GROUNDATTACK ) - categories.ANTIAIR
TransportationAir = categories.AIR * categories.TRANSPORTATION - categories.GROUNDATTACK
BomberAir = categories.AIR * categories.BOMBER
AAAir = categories.AIR * categories.ANTIAIR
AntiNavyAir = categories.AIR * categories.ANTINAVY
IntelAir = categories.AIR * ( categories.SCOUT + categories.RADAR )
ExperimentalAir = categories.AIR * categories.EXPERIMENTAL
TitanAir = categories.AIR * categories.TITAN
HeroAir = categories.AIR * categories.HERO
EliteAir = categories.AIR * categories.ELITE

#=== TECH LEVEL AIR CATEGORIES ===#
AirCategories = {
    Ground1 = GroundAttackAir * categories.TECH1,
    Ground2 = GroundAttackAir * categories.TECH2,
    Ground3 = GroundAttackAir * categories.TECH3,

    Trans1 = TransportationAir * categories.TECH1,
    Trans2 = TransportationAir * categories.TECH2,
    Trans3 = TransportationAir* categories.TECH3,

    Bomb1 = BomberAir * categories.TECH1,
    Bomb2 = BomberAir * categories.TECH2,
    Bomb3 = BomberAir * categories.TECH3,

    AA1 = AAAir * categories.TECH1,
    AA2 = AAAir * categories.TECH2,
    AA3 = AAAir * categories.TECH3,

    AN1 = AntiNavyAir * categories.TECH1,
    AN2 = AntiNavyAir * categories.TECH2,
    AN3 = AntiNavyAir * categories.TECH3,

    AIntel1 = IntelAir * categories.TECH1,
    AIntel2 = IntelAir * categories.TECH2,
    AIntel3 = IntelAir * categories.TECH3,

    AExper = ExperimentalAir,
	ATitan = TitanAir,
	AHero = HeroAir,
	AElite = EliteAir,

    RemainingCategory = categories.AIR - ( GroundAttackAir + TransportationAir + BomberAir + AAAir + AntiNavyAir + IntelAir + ExperimentalAir + TitanAir + HeroAir + EliteAir)
}

#=== SUB GROUP ORDERING ===#
GroundAttack = { 'Ground3', 'Ground2', 'Ground1', }
Transports = { 'Trans3', 'Trans2', 'Trans1', }
Bombers = { 'Bomb3', 'Bomb2', 'Bomb1', }
AntiAir = { 'AA3', 'AA2', 'AA1', }
AntiNavy = { 'AN3', 'AN2', 'AN1', }
Intel = { 'AIntel3', 'AIntel2', 'AIntel1', }
ExperAir = { 'AExper', }
TitaAir = { 'ATitan', }
HerAir = { 'AHero', }
EliAir = { 'AElite', }

#=== Air Block Arrangement ===#
ChevronSlot = { AntiAir, EliAir, HerAir, TitaAir, ExperAir, AntiNavy, GroundAttack, Bombers, Intel, Transports, RemainingCategory }
InitialChevronBlock = {
    RepeatAllRows = false,
    HomogenousBlocks = true,
    ChevronSize = 3,
    { ChevronSlot },
    { ChevronSlot, ChevronSlot },
}

StaggeredChevronBlock = {
    RepeatAllRows = true,
    HomogenousBlocks = true,
    { ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, },
}



#=========================================#
#============== NAVAL DATA ===============#
#=========================================#

LightAttackNaval = categories.LIGHTBOAT
FrigateNaval = categories.FRIGATE
SubNaval = categories.T1SUBMARINE + categories.T2SUBMARINE
DestroyerNaval = categories.DESTROYER
CruiserNaval = categories.CRUISER
BattleshipNaval = categories.BATTLESHIP
CarrierNaval = categories.NAVALCARRIER
NukeSubNaval = categories.NUKESUB
MobileSonar = categories.MOBILESONAR
DefensiveBoat = categories.DEFENSIVEBOAT
RemainingNaval = categories.NAVAL - ( LightAttackNaval + FrigateNaval + SubNaval + DestroyerNaval + CruiserNaval + BattleshipNaval +
                        CarrierNaval + NukeSubNaval + DefensiveBoat + MobileSonar)

#### Naval formation blocks #####
NavalSpacing = 1.2
StandardNavalBlock = {
    { { {0, 0}, }, { 'Carriers', 'Battleships', 'Cruisers', 'Destroyers', 'Frigates', 'Submarines' }, },
    { { {-1, 1.5}, {1, 1.5}, }, { 'Destroyers', 'Cruisers', 'Frigates', 'Submarines'}, },
    { { {-2.5, 0}, {2.5, 0}, }, { 'Cruisers', 'Battleships', 'Destroyers', 'Frigates', 'Submarines' }, },
    { { {-1, -1.5}, {1, -1.5}, }, { 'Frigates', 'Battleships', 'Submarines' }, },
    { { {-3, 2}, {3, 2}, {-3, 0}, {3, 0}, }, { 'Submarines', }, },
}

#=== TECH LEVEL LAND CATEGORIES ===#
NavalCategories = {
    LightCount = LightAttackNaval,
    FrigateCount = FrigateNaval,

    CruiserCount = CruiserNaval,
    DestroyerCount = DestroyerNaval,

    BattleshipCount = BattleshipNaval,
    CarrierCount = CarrierNaval,

    NukeSubCount = NukeSubNaval,
    MobileSonarCount = MobileSonar + DefensiveBoat,		
		
    RemainingCategory = RemainingNaval,
}

SubCategories = {
    SubCount = SubNaval,
}

#=== SUB GROUP ORDERING ===#
Frigates = { 'FrigateCount', 'LightCount', }
Destroyers = { 'DestroyerCount', }
Cruisers = { 'CruiserCount', }
Battleships = { 'BattleshipCount', }
Subs = { 'SubCount', }
NukeSubs = { 'NukeSubCount', }
Carriers = { 'CarrierCount', }
Sonar = {'MobileSonarCount', }

#=== LAND BLOCK TYPES =#
FrigatesFirst = { Frigates, Destroyers, Battleships, Cruisers, Carriers, NukeSubs, Sonar, RemainingCategory }
DestroyersFirst = { Destroyers, Frigates, Battleships, Cruisers, Carriers, NukeSubs, Sonar, RemainingCategory }
CruisersFirst = { Cruisers, Carriers, Battleships, Destroyers, Frigates, NukeSubs, Sonar, RemainingCategory }
BattleshipsFirst = { Battleships, Destroyers, Frigates, Cruisers, Carriers, NukeSubs, Sonar, RemainingCategory }
CarriersFirst = { Carriers, Cruisers, Battleships, Destroyers, Frigates, NukeSubs, Sonar, RemainingCategory }
Subs = { Subs, NukeSubs, RemainingCategory }
SonarFirst = { Sonar, Carriers, Cruisers, Battleships, Destroyers, Frigates, NukeSubs, Sonar, RemainingCategory }

#=== LAND BLOCKS ===#

#=== Three Naval Growth Formation Block ==#
ThreeNavalGrowthFormation = {
    LineBreak = 0.5,
    ## first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, },
    ## second row
    { DestroyersFirst, SonarFirst, DestroyersFirst, },
    ## third row
    { DestroyersFirst, CruisersFirst, DestroyersFirst, },
}

#=== Five Naval Growth Formation Block ==#
FiveNavalGrowthFormation = {
    LineBreak = 0.5,
    ## first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst },
    ## second row
    { FrigatesFirst, SonarFirst, DestroyersFirst, SonarFirst, FrigatesFirst },
    ## third row
    { DestroyersFirst, SonarFirst, BattleshipsFirst, SonarFirst, DestroyersFirst },
    ## fourth row
    { DestroyersFirst, SonarFirst, CarriersFirst, SonarFirst, DestroyersFirst },
    ## fifth row
    { DestroyersFirst, SonarFirst, CarriersFirst, SonarFirst, DestroyersFirst },

}

#=== Seven Naval Growth Formation Block ==#
SevenNavalGrowthFormation = {
    LineBreak = 0.5,
    ## first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst },
    ## second row
    { FrigatesFirst, FrigatesFirst, SonarFirst, DestroyersFirst, SonarFirst, FrigatesFirst, FrigatesFirst },
    ## third row
    { DestroyersFirst, DestroyersFirst, SonarFirst, BattleshipsFirst, SonarFirst, DestroyersFirst, DestroyersFirst },
    ## fourth row
    { DestroyersFirst, BattleshipsFirst, SonarFirst, CarriersFirst, SonarFirst, BattleshipsFirst, DestroyersFirst },
    ## fifth row
    { DestroyersFirst, CruisersFirst, SonarFirst, BattleshipsFirst, SonarFirst, CruisersFirst, DestroyersFirst },
    ## sixth row
    { DestroyersFirst, CruisersFirst, SonarFirst, CarriersFirst, SonarFirst, CruisersFirst, DestroyersFirst },
    ## seventh row
    { DestroyersFirst, CruisersFirst, SonarFirst, CarriersFirst, SonarFirst, CruisersFirst, DestroyersFirst },        
}

#==============================================#
#============ Naval Attack Formation===========#
#==============================================#

#=== Five Wide Naval Attack Formation Block ==#
FiveWideNavalAttackFormation = {
    LineBreak = 0.5,
    ## first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst},
    ## second row
    { DestroyersFirst, SonarFirst, CarriersFirst, SonarFirst, DestroyersFirst},
}

#=== Seven Wide Naval Attack Formation Block ==#
SevenWideNavalAttackFormation = {
    LineBreak = 0.5,
    ## first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, },
    ## second row
    { DestroyersFirst, BattleshipsFirst, SonarFirst, BattleshipsFirst, SonarFirst, BattleshipsFirst, DestroyersFirst},
		## third row
    { DestroyersFirst, CruisersFirst, CarriersFirst, CarriersFirst, CruisersFirst, CruisersFirst, DestroyersFirst},    
}

#=== Nine Wide Naval Attack Formation Block ==#
NineWideNavalAttackFormation = {
    LineBreak = 0.5,
    ## first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst },
    ## second row
    { DestroyersFirst, DestroyersFirst, SonarFirst, BattleshipsFirst, BattleshipsFirst, BattleshipsFirst, SonarFirst, DestroyersFirst, DestroyersFirst },
    ## third row
    { DestroyersFirst, CruisersFirst, SonarFirst, CarriersFirst, CarriersFirst, CarriersFirst, SonarFirst, CruisersFirst, DestroyersFirst },
}

#==============================================#
#============ Sub Growth Formation===========#
#==============================================#
#=== Three Wide Growth Subs Formation ===#
ThreeWideSubGrowthFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, },    
    { Subs, Subs, Subs, },
}

#=== Five Wide Subs Formation ===#
FiveWideSubGrowthFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, Subs, Subs,},
    { Subs, Subs, Subs, Subs, Subs,},
    { Subs, Subs, Subs, Subs, Subs,},
}

#=== Seven Wide Subs Formation ===#
SevenWideSubGrowthFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, Subs, Subs,},
    { Subs, Subs, Subs, Subs, Subs,},
    { Subs, Subs, Subs, Subs, Subs,},
    { Subs, Subs, Subs, Subs, Subs,},    
}


#==============================================#
#============ Sub Attack Formation===========#  
#==============================================#

#=== Five Wide Subs Formation ===#
FiveWideSubAttackFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, Subs, Subs },    
    { Subs, Subs, Subs, Subs, Subs },
}

#=== Seven Wide Subs Formation ===#
SevenWideSubAttackFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs },
}

#=== Nine Wide Subs Formation ===#
NineWideSubAttackFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },    
}

EightNavalFormation = {
    LineBreak = 0.5,
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst },
    ## second row
    { DestroyersFirst, CruisersFirst, CruisersFirst, BattleshipsFirst, BattleshipsFirst, CruisersFirst, CruisersFirst, DestroyersFirst },
    ## third row
    { DestroyersFirst, BattleshipsFirst, CruisersFirst, CruisersFirst, CruisersFirst, CruisersFirst, BattleshipsFirst, DestroyersFirst },
    ## fourth row
    { DestroyersFirst, CruisersFirst, CarriersFirst, CarriersFirst, CarriersFirst, CarriersFirst, CruisersFirst, DestroyersFirst },
}

EightNavalSubFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs },
}

#============ Formation Pickers ============#
function PickBestTravelFormationIndex( typeName, distance )
    if typeName == 'AirFormations' then
        return 0;
    else
        return 1;
    end
end

function PickBestFinalFormationIndex( typeName, distance )
    return -1;
end


#================ THE GUTS ====================#
#============ Formation Functions =============#
#==============================================#
function AttackFormation( formationUnits )
    FormationPos = {}

    local landUnitsList = CategorizeLandUnits( formationUnits )
    local landBlock
    if landUnitsList.UnitTotal <= 16 then # 8 wide
        landBlock = TwoRowAttackFormationBlock
    elseif landUnitsList.UnitTotal <= 30 then # 10 wide
        landBlock = ThreeRowAttackFormationBlock
    elseif landUnitsList.UnitTotal <= 48 then # 12 wide
        landBlock = FourRowAttackFormationBlock
    elseif landUnitsList.UnitTotal <= 70 then # 14 wide
        landBlock = FiveRowAttackFormationBlock
    elseif landUnitsList.UnitTotal <= 96 then # 16 wide
        landBlock = SixRowAttackFormationBlock
    elseif landUnitsList.UnitTotal <= 126 then # 18 wide
        landBlock = SevenRowAttackFormationBlock
    elseif landUnitsList.UnitTotal <= 160 then # 20 wide
        landBlock = EightRowAttackFormationBlock
    else
        landBlock = NineRowAttackFormationBlock
    end
    BlockBuilderLand(landUnitsList, landBlock, LandCategories)

    local seaUnitsList = CategorizeSeaUnits( formationUnits )
    seaUnitsList.UnitTotal = seaUnitsList.UnitTotal - seaUnitsList.SubCount
    local seaBlock
    local subBlock
    local subUnitsList = {}
    subUnitsList.UnitTotal = seaUnitsList.SubCount
    subUnitsList.SubCount = seaUnitsList.SubCount
    local seaCounter = seaUnitsList.UnitTotal
    if seaUnitsList.UnitTotal < subUnitsList.UnitTotal then
        seaCounter = subUnitsList.UnitTotal
    end
    if seaCounter <= 10 then
        seaBlock = FiveWideNavalAttackFormation
        subBlock = FiveWideSubGrowthFormation
    elseif seaCounter <= 25 then
        seaBlock = SevenWideNavalAttackFormation
        subBlock = SevenWideSubAttackFormation
    elseif seaCounter <= 50 then
        seaBlock = NineWideNavalAttackFormation
        subBlock = NineWideSubAttackFormation
    else
        seaBlock = NineWideNavalAttackFormation
        subBlock = NineWideSubAttackFormation
    end
    BlockBuilderLand( seaUnitsList, seaBlock, NavalCategories, 1.5 )
    BlockBuilderLand( subUnitsList, subBlock, SubCategories, 1.5 )

    local airUnitsList = CategorizeAirUnits( formationUnits )
    BlockBuilderAir(airUnitsList, StaggeredChevronBlock)

    return FormationPos
end

function GrowthFormation( formationUnits )
    FormationPos = {}

    local landUnitsList = CategorizeLandUnits( formationUnits )
    local landBlock
    if landUnitsList.UnitTotal <= 3 then
        landBlock = ThreeWideAttackFormationBlock
    elseif landUnitsList.UnitTotal <= 12 then
        landBlock = FourWideAttackFormationBlock
    elseif landUnitsList.UnitTotal <= 20 then
        landBlock = FiveWideAttackFormationBlock
    elseif landUnitsList.UnitTotal <= 30 then
        landBlock = SixWideAttackFormationBlock
    elseif landUnitsList.UnitTotal <= 42 then
        landBlock = SevenWideAttackFormationBlock
    elseif landUnitsList.UnitTotal <= 56 then
        landBlock = EightWideAttackFormationBlock
    else
        landBlock = EightWideAttackFormationBlock
    end
    BlockBuilderLand(landUnitsList, landBlock, LandCategories)

    local seaUnitsList = CategorizeSeaUnits( formationUnits )
    seaUnitsList.UnitTotal = seaUnitsList.UnitTotal - seaUnitsList.SubCount
    local seaBlock
    local subBlock
    local subUnitsList = {}
    subUnitsList.UnitTotal = seaUnitsList.SubCount
    subUnitsList.SubCount = seaUnitsList.SubCount
    local seaCounter = seaUnitsList.UnitTotal
    if seaUnitsList.UnitTotal < subUnitsList.UnitTotal then
        seaCounter = subUnitsList.UnitTotal
    end
    if seaCounter <= 9 then
        seaBlock = ThreeNavalGrowthFormation
        subBlock = ThreeWideSubGrowthFormation
    elseif seaCounter <= 25 then
        seaBlock = FiveNavalGrowthFormation
        subBlock = FiveWideSubGrowthFormation
    elseif seaCounter <= 49 then
        seaBlock = SevenNavalGrowthFormation
        subBlock = SevenWideSubGrowthFormation
    else
        seaBlock = SevenNavalGrowthFormation
        subBlock = SevenWideSubGrowthFormation
    end
    BlockBuilderLand( seaUnitsList, seaBlock, NavalCategories, 1.5 )
    BlockBuilderLand( subUnitsList, subBlock, SubCategories, 1.5 )

    local airUnitsList = CategorizeAirUnits( formationUnits )
    BlockBuilderAir(airUnitsList, StaggeredChevronBlock)

    return FormationPos
end

function BlockFormation( formationUnits )
    local rotate = true
    local smallUnitsList = {}
    local largeUnitsList = {}
    local smallUnits = 0
    local largeUnits = 0

    for i,u in formationUnits do
        local footPrintSize = u:GetFootPrintSize()
        if footPrintSize > 3  then
            largeUnitsList[largeUnits] = { u }
            largeUnits = largeUnits + 1
        else
            smallUnitsList[smallUnits] = { u }
            smallUnits = smallUnits + 1
        end
    end

    local FormationPos = {}
    local n = smallUnits + largeUnits
    local width = math.ceil(math.sqrt(n))
    local length = n / width

    # Put small units (Size 1 through 3) in front of the formation
    for i in smallUnitsList do
        local offsetX = (( math.mod(i,width)  - math.floor(width/2) ) * 2) + 1
        local offsetY = ( math.floor(i/width) - math.floor(length/2) ) * 2
        local delay = 0.1 + (math.floor(i/width) * 3)
        table.insert(FormationPos, { offsetX, -offsetY, categories.ALLUNITS, delay, rotate })
    end

    # Put large units (Size >= 4) in the back of the formation
    for i in largeUnitsList do
        local adjIndex = smallUnits + i
        local offsetX = (( math.mod(adjIndex,width)  - math.floor(width/2) ) * 2) + 1
        local offsetY = ( math.floor(adjIndex/width) - math.floor(length/2) ) * 2
        local delay = 0.1 + (math.floor(adjIndex/width) * 3)
        table.insert(FormationPos, { offsetX, -offsetY, categories.ALLUNITS, delay, rotate })
    end

    return FormationPos
end


function lerp( alpha, a, b )
    return a + ((b-a) * alpha)
end

function CircleFormation( formationUnits )
    local rotate = false
    local FormationPos = {}
    local numUnits = table.getn(formationUnits)
    local sizeMult = 2.0 + math.max(1.0, numUnits / 3.0)

    # make circle around center point
    for i in formationUnits do
        offsetX = sizeMult * math.sin( lerp( i/numUnits, 0.0, math.pi * 2.0 ) )
        offsetY = sizeMult * math.cos( lerp( i/numUnits, 0.0, math.pi * 2.0 ) )
        table.insert(FormationPos, { offsetX, offsetY, categories.ALLUNITS, 0, rotate })
    end

    return FormationPos
end

function GuardFormation( formationUnits )
    local rotate = false
    local FormationPos = {}
    local numUnits = table.getn(formationUnits)

    local naval = false
    local sizeMult = 3
    for k,v in formationUnits do
        if not v:IsDead() and EntityCategoryContains( categories.NAVAL * categories.MOBILE, v ) then
            naval = true
            sizeMult = 8
            break
        end
    end

    local ringChange = 5
    local unitCount = 1

    # make circle around center point
    for i in formationUnits do
        if unitCount == ringChange then
            ringChange = ringChange + 5
            if naval then
                sizeMult = sizeMult + 8
            else
                sizeMult = sizeMult + 3
            end
            unitCount = 1
        end
        offsetX = sizeMult * math.sin( lerp( unitCount/ringChange, 0.0, math.pi * 2.0 )) -- + math.pi / 16 )
        offsetY = sizeMult * math.cos( lerp( unitCount/ringChange, 0.0, math.pi * 2.0 )) -- + math.pi / 16 )
        #LOG('*FORMATION DEBUG: X=' .. offsetX .. ', Y=' .. offsetY )
        table.insert(FormationPos, { offsetX - 10, offsetY, categories.ALLUNITS, 0, rotate })
        unitCount = unitCount + 1
    end

    return FormationPos
end




#=========== LAND BLOCK BUILDING =================#
function BlockBuilderLand(unitsList, formationBlock, categoryTable, spacing)
    spacing = spacing or 1
    local numRows = table.getn(formationBlock)
    local i = 1
    local whichRow = 1
    local whichCol = 1
    local currRowLen = table.getn(formationBlock[whichRow])
    local rowType = false
    local formationLength = 0
    local inserted = false
    while unitsList.UnitTotal >= i do
        if whichCol > currRowLen then
            if whichRow == numRows then
                whichRow = 1
                if formationBlock.RowBreak then
                    formationLength = formationLength + 1 + formationBlock.RowBreak
                else
                    formationLength = formationLength + 1
                end
            else
                whichRow = whichRow + 1
                if formationBlock.LineBreak then
                    formationLength = formationLength + 1 + formationBlock.LineBreak
                else
                    formationLength = formationLength + 1
                end
                rowType = false
            end
            whichCol = 1
            currRowLen = table.getn(formationBlock[whichRow])
        end
        local currColSpot = GetColSpot(currRowLen, whichCol) # Translate whichCol to correct spot in row
        local currSlot = formationBlock[whichRow][currColSpot]
        for numType, type in currSlot do
            if inserted then
                break
            end
            for numGroup, group in type do
                if not formationBlock.HomogenousRows or (rowType == false or rowType == type) then
                    if unitsList[group] > 0 then
                        #local xPos = (math.ceil(whichCol/2)/2) - 0.25
                        local xPos
                        if math.mod( currRowLen, 2 ) == 0 then
                            xPos = math.ceil(whichCol/2) - .5
                            if not (math.mod(whichCol, 2) == 0) then
                                xPos = xPos * -1
                            end
                        else
                            if whichCol == 1 then
                                xPos = 0
                            else
                                xPos = math.ceil( ( (whichCol-1) /2 ) )
                                if not (math.mod(whichCol, 2) == 0) then
                                    xPos = xPos * -1
                                end
                            end
                        end
                        if formationBlock.HomogenousRows and not rowType then
                            rowType = type
                        end
                        table.insert(FormationPos, {xPos*spacing, -formationLength*spacing, categoryTable[group], formationLength, true})
                        inserted = true
                        unitsList[group] = unitsList[group] - 1
                        break
                    end
                end
            end
        end
        if inserted then
            i = i + 1
            inserted = false
        end
        whichCol = whichCol + 1
    end
    return FormationPos
end

function GetColSpot(rowLen, col)
    local len = rowLen
    if math.mod(rowLen,2) == 1 then
        len = rowLen + 1
    end
    local colType = 'left'
    if math.mod(col, 2) == 0 then
        colType = 'right'
    end
    local colSpot = math.floor(col / 2)
    local halfSpot = len/2
    if colType == 'left' then
        return halfSpot - colSpot
    else
        return halfSpot + colSpot
    end
end





#============ AIR BLOCK BUILDING =============#
function BlockBuilderAir(unitsList, airBlock)
    local numRows = table.getn(airBlock)
    local i = 1
    local whichRow = 1
    local whichCol = 1
    local chevronPos = 1
    local currRowLen = table.getn(airBlock[whichRow])
    local longestRow = 1
    local longestLength = 0
    local chevronSize = airBlock.ChevronSize or 5
    while i < numRows do
        if table.getn(airBlock[i]) > longestLength then
            longestLength = table.getn(airBlock[i])
            longestRow = i
        end
        i = i + 1
    end
    local chevronType = false
    local formationLength = 0
    local spacing = 1

    if unitsList.AExper > 0 then
        spacing = 2
    end
    
    i = 1
    while unitsList.UnitTotal >= i do
        if chevronPos > chevronSize then
            chevronPos = 1
            chevronType = false
            if whichCol == currRowLen then
                if whichRow == numRows then
                    if airBlock.RepeatAllRows then
                        whichRow = 1
                        currRowLen = table.getn(airBlock[whichRow])
                    end
                else
                    whichRow = whichRow + 1
                    currRowLen = table.getn(airBlock[whichRow])
                end
                formationLength = formationLength + 1
                whichCol = 1
            else
                whichCol = whichCol + 1
            end
        end
        local currSlot = airBlock[whichRow][whichCol]
        local inserted = false
        for numType, type in currSlot do
            if inserted then
                break
            end
            for numGroup, group in type do
                if not airBlock.HomogenousBlocks or chevronType == false or chevronType == type then
                    if unitsList[group] > 0 then
                        local xPos, yPos = GetChevronPosition(chevronPos, whichCol, currRowLen, formationLength)
                        if airBlock.HomogenousBlocks and not chevronType then
                            chevronType = type
                        end
                        table.insert(FormationPos, {xPos*spacing, yPos*spacing, AirCategories[group], yPos, true})
                        unitsList[group] = unitsList[group] - 1
                        inserted = true
                        break
                    end
                end
            end
        end
        if inserted then
            i = i + 1
        end
        chevronPos = chevronPos + 1
    end
    return FormationPos
end

function GetChevronPosition(chevronPos, currCol, currRowLen, formationLen)
    local offset = math.floor(chevronPos/2) * .375
    local xPos = offset
    if math.mod(chevronPos,2) == 0 then
        xPos = -1 * offset
    end
    local yPos = -offset
    yPos = yPos + ( formationLen * -1.5 )
    local firstBlockOffset = -2
    if math.mod(currRowLen,2) == 1 then
        firstBlockOffset = -1
    end
    local blockOff = math.floor(currCol/2) * 2
    if math.mod(currCol,2) == 1 then
        blockOff = -blockOff
    end
    xPos = xPos + blockOff + firstBlockOffset
    return xPos, yPos
end





#=========== NAVAL UNIT BLOCKS ============#
function NavalBlocks( unitsList, navyType )
    local Carriers = true
    local Battleships = true
    local Cruisers = true
    local Destroyers = true
    local unitNum = 1
    for i,v in navyType do
        for k,u in v[2] do
            if u == 'Carriers' and Carriers and unitsList.CarrierCount > 0 then
                for j, coord in v[1] do
                    if unitsList.CarrierCount ~= 0 then
                        table.insert(FormationPos, { coord[1]*NavalSpacing, coord[2]*NavalSpacing, categories.NAVAL * categories.AIRSTAGINGPLATFORM * ( categories.TECH3 + categories.EXPERIMENTAL ), 0, true })
                        unitsList.CarrierCount = unitsList.CarrierCount - 1
                        unitNum = unitNum + 1
                    end
                end
                Carriers = false
                break
            elseif u == 'Battleships' and Battleships and unitsList.BattleshipCount > 0 then
                for j, coord in v[1] do
                    if unitsList.BattleshipCount ~= 0 then
                        table.insert(FormationPos, { coord[1]*NavalSpacing, coord[2]*NavalSpacing, BattleshipNaval, 0, true })
                        unitsList.BattleshipCount = unitsList.BattleshipCount - 1
                        unitNum = unitNum + 1
                    end
                end
                Battleships = false
                break
            elseif u == 'Cruisers' and Cruisers and unitsList.CruiserCount > 0 then
                for j, coord in v[1] do
                    if unitsList.CruiserCount ~= 0 then
                        table.insert(FormationPos, { coord[1]*NavalSpacing, coord[2]*NavalSpacing, CruiserNaval, 0, true })
                        unitNum = unitNum + 1
                        unitsList.CruiserCount = unitsList.CruiserCount - 1
                    end
                end
                Cruisers = false
                break
            elseif u == 'Destroyers' and Destroyers and unitsList.DestroyerCount > 0 then
                for j, coord in v[1] do
                    if unitsList.DestroyerCount > 0 then
                        table.insert(FormationPos, { coord[1]*NavalSpacing, coord[2]*NavalSpacing, DestroyerNaval, 0, true })
                        unitNum = unitNum + 1
                        unitsList.DestroyerCount = unitsList.DestroyerCount - 1
                    end
                end
                Destroyers = false
                break
            elseif u == 'Frigates' and unitsList.FrigateCount > 0 then
                for j, coord in v[1] do
                    if unitsList.FrigateCount > 0 then
                        table.insert(FormationPos, { coord[1]*NavalSpacing, coord[2]*NavalSpacing, FrigateNaval, 0, true })
                        unitNum = unitNum + 1
                        unitsList.FrigateCount = unitsList.FrigateCount - 1
                    end
                end
                break
            elseif u == 'Frigates' and unitsList.LightCount > 0 then
                for j,coord in v[1] do
                    if unitsList.LightCount > 0 then
                        table.insert(FormationPos, { coord[1]*NavalSpacing, coord[2]*NavalSpacing, LightAttackNaval, 0, true })
                        unitNum = unitNum + 1
                        unitsList.LightCount = unitsList.LightCount - 1
                    end
                end
                break
            elseif u == 'Submarines' and unitsList.SubCount > 0 then
                for j,coord in v[1] do
                    if ( unitsList.SubCount + unitsList.NukeSubCount ) > 0 then
                        table.insert(FormationPos, { coord[1]*NavalSpacing, coord[2]*NavalSpacing, SubNaval + NukeSubNaval, 0, true })
                        unitNum = unitNum + 1
                        unitsList.SubCount = unitsList.SubCount - 1
                    end
                end
                break
            end
        end
    end

    local sideTable = { 0, -2, 2 }
    local sideIndex = 1
    local length = -3

    i = unitNum

    # Figure out how many left we have to assign
    local numLeft = unitsList.UnitTotal - i + 1
    if numLeft == 2 then
        sideIndex = 2
    end

    while i <= unitsList.UnitTotal do
        if unitsList.CarrierCount > 0 then
            table.insert(FormationPos, { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, categories.NAVAL * categories.AIRSTAGINGPLATFORM * ( categories.TECH3 + categories.EXPERIMENTAL ), 0, true  })
            unitNum = unitNum + 1
            unitsList.CarrierCount = unitsList.CarrierCount - 1
        elseif unitsList.BattleshipCount > 0 then
            table.insert(FormationPos, { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, BattleshipNaval, 0, true })
            unitNum = unitNum + 1
            unitsList.BattleshipCount = unitsList.BattleshipCount - 1
        elseif unitsList.CruiserCount > 0 then
            table.insert(FormationPos, { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, CruiserNaval, 0, true })
            unitNum = unitNum + 1
            unitsList.CruiserCount = unitsList.CruiserCount - 1
        elseif unitsList.DestroyerCount > 0 then
            table.insert(FormationPos, { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, DestroyerNaval, 0, true })
            unitNum = unitNum + 1
            unitsList.DestroyerCount = unitsList.DestroyerCount - 1
        elseif unitsList.FrigateCount > 0 then
            table.insert(FormationPos, { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, FrigateNaval, 0, true })
            unitNum = unitNum + 1
            unitsList.FrigateCount = unitsList.FrigateCount - 1
        elseif unitsList.LightCount > 0 then
            table.insert(FormationPos, { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, LightAttackNaval, 0, true })
            unitNum = unitNum + 1
            unitsList.LightCount = unitsList.LightCount - 1
        elseif ( unitsList.SubCount + unitsList.NukeSubCount ) > 0 then
            table.insert(FormationPos, { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, SubNaval + NukeSubNaval, 0, true })
            unitNum = unitNum + 1
            unitsList.SubCount = unitsList.SubCount - 1
        elseif ( unitsList.MobileSonarCount ) > 0 then
            table.insert(FormationPos, { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, MobileSonar + DefensiveBoat, 0, true } )
            unitNum = unitNum + 1
            unitsList.MobileSonarCount = unitsList.MobileSonarCount - 1
        elseif ( unitsList.RemainingCategory ) > 0 then
            table.insert(FormationPos, { sideTable[sideIndex]*NavalSpacing, length*NavalSpacing, NavalCategories.RemainingCategory, 0, true } )
            unitNum = unitNum + 1
            unitsList.RemainingCategory = unitsList.RemainingCategory - 1
        end

        # Figure out the next viable location for the naval unit
        numLeft = numLeft - 1
        sideIndex = sideIndex + 1
        if sideIndex == 4 then
            length = length - 2
            if numLeft == 2 then
                sideIndex = 2
            else
                sideIndex = 1
            end
        end

        i = i + 1
    end
    return FormationPos
end



#========= UNIT SORTING ==========#
function CategorizeAirUnits( formationUnits )
    local unitsList = {
        #### Air Lists
        Ground1 = 0, Ground2 = 0, Ground3 = 0,
        Trans1 = 0, Trans2 = 0, Trans3 = 0,
        Bomb1 = 0, Bomb2 = 0, Bomb3 = 0,
        AA1 = 0, AA2 = 0, AA3 = 0,
        AN1 = 0, AN2 = 0, AN3 = 0,
        AIntel1 = 0, AIntel2 = 0, AIntel3 = 0,
        AExper = 0, AElite = 0, AHero = 0,  ATitan=0,
        RemainingCategory = 0,
        UnitTotal = 0,
    }
    for i,u in formationUnits do
        for aircat,_ in AirCategories do
            if EntityCategoryContains(AirCategories[aircat], u) then
                unitsList[aircat] = unitsList[aircat] + 1
                if AirCategories[aircat] == "RemainingCategory" then
                    LOG('*FORMATION DEBUG: Missed unit: ' .. u:GetUnitId())
                end
                unitsList.UnitTotal = unitsList.UnitTotal + 1
                break
            end
        end   
    end
    #LOG('UnitsList=', repr(unitsList))
    return unitsList
end

function CategorizeSeaUnits( formationUnits)
    local unitsList = {
        #### Naval Lists
        UnitTotal = 0,
        CarrierCount = 0,
        BattleshipCount = 0,
        DestroyerCount = 0,
        CruiserCount = 0,
        FrigateCount = 0,
        LightCount = 0,
        SubCount = 0,
        NukeSubCount = 0,
        MobileSonarCount = 0,
        RemainingCategory = 0,
    }
    #== NAVAL UNITS ==#
    for i,u in formationUnits do
        for navcat,_ in NavalCategories do
            if EntityCategoryContains(NavalCategories[navcat], u) then
                unitsList[navcat] = unitsList[navcat] + 1
                if NavalCategories[navcat] == "RemainingCategory" then
                    LOG('*FORMATION DEBUG: Missed unit: ' .. u:GetUnitId())
                end
                unitsList.UnitTotal = unitsList.UnitTotal + 1
                break
            end
        end
        #categorize subs
        for subcat,_ in SubCategories do
            if EntityCategoryContains(SubCategories[subcat], u) then
                unitsList[subcat] = unitsList[subcat] + 1
                if SubCategories[subcat] == "RemainingCategory" then
                    LOG('*FORMATION DEBUG: Missed unit: ' .. u:GetUnitId())
                end 
                unitsList.UnitTotal = unitsList.UnitTotal + 1
                break                               
            end
        end
    end
    return unitsList
end

function CategorizeLandUnits( formationUnits )
    local unitsList = {
        #### Land Numbers
        Bot1 = 0, Bot2 = 0, Bot3 = 0, Bot35 = 0, Bot4 = 0, Bot5 = 0, Bot6 = 0,
        Tank1 = 0, Tank2 = 0, Tank3 = 0, Tank35 = 0, Tank4 = 0, Tank5 = 0, Tank6 = 0,
        Art1 = 0, Art2 = 0, Art3 = 0, Art35 = 0, Art4 = 0, Art5 = 0, Art6 = 0,
        AA1 = 0, AA2 = 0, AA3 = 0, AA35 = 0, AA4 = 0, AA5 = 0, AA6 = 0,
        Com1 = 0, Com2 = 0, Com3 = 0, Com35 = 0, Com4 = 0, Com5 = 0, Com6 = 0,
        Util1 = 0, Util2 = 0, Util3 = 0, Util35 = 0, Util4 = 0, Util5 = 0, Util6 = 0,
        Shields = 0,
        Experimentals = 0,
        UnitTotal = 0,
        RemainingCategory = 0,
    }
    for i,u in formationUnits do
        for landcat,_ in LandCategories do
            if EntityCategoryContains(LandCategories[landcat], u) then
                unitsList[landcat] = unitsList[landcat] + 1
                if LandCategories[landcat] == "RemainingCategory" then
                    LOG('*FORMATION DEBUG: Missed unit: ' .. u:GetUnitId())
                end
                unitsList.UnitTotal = unitsList.UnitTotal + 1
                break
            end
        end
        
    end

    return unitsList
end

end


else	


-- Basic create formation scripts

---@alias UnitFormations 'AttackFormation' | 'GrowthFormation' | 'NoFormation' | 'None' | 'none'


SurfaceFormations = {
    'AttackFormation',
    'GrowthFormation',
}

AirFormations = {
    'AttackFormation',
    'GrowthFormation',
}

ComboFormations = {
    'AttackFormation',
    'GrowthFormation',
}

FormationPos = {} -- list to be returned
FormationCache = {}
MaxCacheSize = 30

---@param formationUnits Unit[]
---@param formationType UnitFormations
---@return boolean
function GetCachedResults(formationUnits, formationType)
    local cache = FormationCache[formationType]
    if not cache then
        return false
    end

    local unitCount = table.getn(formationUnits)
    for _, data in cache do
        if data.UnitCount == unitCount then
            local match = true
            for i = 0, unitCount - 1, 1 do -- These indices are 0-based.
                if data.Units[i] ~= formationUnits[i] then
                    match = false
                    break
                end
            end
            if match then
                return data.Results
            end
        end
    end

    return false
end

---@param results TLaserBotProjectile
---@param formationUnits Unit[]
---@param formationType UnitFormations
function CacheResults(results, formationUnits, formationType)
    if not FormationCache[formationType] then
        FormationCache[formationType] = {}
    end

    local cache = FormationCache[formationType]
    if table.getn(cache) >= MaxCacheSize then
        table.remove(cache)
    end
    table.insert(cache, 1, {Results = results, Units = formationUnits, UnitCount = table.getn(formationUnits)})
end

-- =========================================
-- ================ LAND DATA ==============
-- =========================================
RemainingCategory = { 'RemainingCategory', }

-- === LAND CATEGORIES ===
DirectFire = (categories.DIRECTFIRE - (categories.CONSTRUCTION + categories.SNIPER + categories.WEAKDIRECTFIRE)) * categories.LAND
Sniper = categories.SNIPER * categories.LAND
Artillery = (categories.ARTILLERY + categories.INDIRECTFIRE - categories.SNIPER) * categories.LAND
AntiAir = (categories.ANTIAIR - (categories.EXPERIMENTAL + categories.DIRECTFIRE + categories.SNIPER + Artillery)) * categories.LAND
Construction = ((categories.COMMAND + categories.CONSTRUCTION + categories.ENGINEER) - (DirectFire + Sniper + Artillery)) * categories.LAND
UtilityCat = (((categories.RADAR + categories.COUNTERINTELLIGENCE) - categories.DIRECTFIRE) + categories.SCOUT) * categories.LAND
ShieldCat = categories.uel0307 + categories.ual0307 + categories.xsl0307

-- === TECH LEVEL LAND CATEGORIES ===
LandCategories = {
    Shields = ShieldCat,

    Bot1 = (DirectFire * categories.TECH1) * categories.BOT - categories.SCOUT,
    Bot2 = (DirectFire * categories.TECH2) * categories.BOT - categories.SCOUT,
    Bot3 = (DirectFire * categories.TECH3) * categories.BOT - categories.SCOUT,
	Bot35 = (DirectFire * categories.ELITE) * categories.BOT - categories.SCOUT,
    Bot4 = (DirectFire * categories.EXPERIMENTAL) * categories.BOT - categories.SCOUT,
	Bot5 = (DirectFire * categories.HERO) * categories.BOT - categories.SCOUT,
    Bot6 = (DirectFire * categories.TITAN) * categories.BOT - categories.SCOUT,

    Tank1 = (DirectFire * categories.TECH1) - categories.BOT - categories.SCOUT,
    Tank2 = (DirectFire * categories.TECH2) - categories.BOT - categories.SCOUT,
    Tank3 = (DirectFire * categories.TECH3) - categories.BOT - categories.SCOUT,
	Tank35 = (DirectFire * categories.ELITE) - categories.BOT - categories.SCOUT,
    Tank4 = (DirectFire * categories.EXPERIMENTAL) - categories.BOT - categories.SCOUT,
    Tank5 = (DirectFire * categories.HERO) - categories.BOT - categories.SCOUT,
	Tank6 = (DirectFire * categories.TITAN) - categories.BOT - categories.SCOUT,
		
    Sniper1 = (Sniper * categories.TECH1) - categories.SCOUT,
    Sniper2 = (Sniper * categories.TECH2) - categories.SCOUT,
    Sniper3 = (Sniper * categories.TECH3) - categories.SCOUT,
	Sniper35 = (Sniper * categories.ELITE) - categories.SCOUT,
    Sniper4 = (Sniper * categories.EXPERIMENTAL) - categories.SCOUT,
    Sniper5 = (Sniper * categories.HERO) - categories.SCOUT,
	Sniper6 = (Sniper * categories.TITAN) - categories.SCOUT,
		
    Art1 = Artillery * categories.TECH1,
    Art2 = Artillery * categories.TECH2,
    Art3 = Artillery * categories.TECH3,
	Art35 = Artillery * categories.ELITE,
    Art4 = Artillery * categories.EXPERIMENTAL,
	Art5 = Artillery * categories.HERO,
	Art6 = Artillery * categories.TITAN,

    AA1 = AntiAir * categories.TECH1,
    AA2 = AntiAir * categories.TECH2,
    AA3 = AntiAir * categories.TECH3,
	AA35 = AntiAir * categories.ELITE,
	AA4 = AntiAir * categories.EXPERIMENTAL,
	AA5 = AntiAir * categories.HERO,
	AA6 = AntiAir * categories.TITAN,

    Com1 = Construction * categories.TECH1,
    Com2 = Construction * categories.TECH2,
    Com3 = Construction - (categories.TECH1 + categories.TECH2 + categories.EXPERIMENTAL),
	Com35 = Construction * categories.ELITE,
    Com4 = Construction * categories.EXPERIMENTAL,
	Com5 = Construction * categories.HERO,
	Com6 = Construction * categories.TITAN,
	
    Util1 = (UtilityCat * categories.TECH1) + categories.OPERATION,
    Util2 = UtilityCat * categories.TECH2,
    Util3 = UtilityCat * categories.TECH3,
	Util35 = UtilityCat * categories.ELITE,
    Util4 = UtilityCat * categories.EXPERIMENTAL,
	Util5 = UtilityCat * categories.HERO,
    Util6 = UtilityCat * categories.TITAN,

    RemainingCategory = categories.LAND - (DirectFire + Sniper + Construction + Artillery + AntiAir + UtilityCat + ShieldCat)
}

-- === SUB GROUP ORDERING ===
Bots = { 'Bot6', 'Bot5', 'Bot4', 'Bot35', 'Bot3', 'Bot2', 'Bot1', }
Tanks = { 'Tank6', 'Tank5', 'Tank4', 'Tank35', 'Tank3', 'Tank2', 'Tank1', }
DF = { 'Tank6', 'Bot6', 'Tank5', 'Bot5', 'Tank4', 'Bot4', 'Tank35', 'Bot35', 'Tank3', 'Bot3', 'Tank2', 'Bot2', 'Tank1', 'Bot1', }
Art = { 'Art6', 'Sniper6', 'Art5', 'Sniper5', 'Art4', 'Sniper4', 'Art35', 'Sniper35', 'Art3', 'Sniper3', 'Art2', 'Sniper2', 'Art1', 'Sniper1', }
T1Art = { 'Sniper1', 'Art1', 'Sniper2', 'Art2', 'Sniper3', 'Art3', 'Sniper35', 'Art35', 'Sniper4', 'Art4', 'Sniper5', 'Art5', 'Sniper6', 'Art6',}
AA = { 'AA6', 'AA5', 'AA4', 'AA35', 'AA3', 'AA2', 'AA1', }
Util = { 'Util6', 'Util5', 'Util4', 'Util35', 'Util3', 'Util2', 'Util1', }
Com = { 'Com6', 'Com5', 'Com4', 'Com35', 'Com3', 'Com2', 'Com1', }
Shield = { 'Shields', }

-- === LAND BLOCK TYPES =
DFFirst = { DF, T1Art, AA, Shield, Com, Util, RemainingCategory }
ShieldFirst = { Shield, AA, DF, T1Art, Com, Util, RemainingCategory }
AAFirst = { AA, DF, T1Art, Shield, Com, Util, RemainingCategory }
ArtFirst = { Art, DF, AA, Shield, Com, Util, RemainingCategory }
T1ArtFirst = { T1Art, DF, AA, Shield, Com, Util, RemainingCategory }
UtilFirst = { Util, AA, Shield, DF, T1Art, Com, RemainingCategory }


-- === LAND BLOCKS ===

-- === 3 Wide Attack Block / 3 Units ===
ThreeWideAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, },
}

-- === 4 Wide Attack Block / 12 Units ===
FourWideAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second row
    { UtilFirst, ShieldFirst, ShieldFirst, UtilFirst, },
    -- third Row
    { AAFirst, ArtFirst, ArtFirst, AAFirst,  },
}

-- === 5 Wide Attack Block ===
FiveWideAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second row
    { DFFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, },
    -- third row
    { UtilFirst, ShieldFirst, DFFirst, ShieldFirst,  UtilFirst, },
    -- fourth row
    { AAFirst, DFFirst, ArtFirst, DFFirst, AAFirst, },
}

-- === 6 Wide Attack Block ===
SixWideAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second row
    { DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, },
    -- third row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst,  UtilFirst, },
    -- fourth row
    { AAFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, AAFirst, },
    -- fifth row
    { DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, DFFirst, },
}

-- === 7 Wide Attack Block ===
SevenWideAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second Row
    { DFFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, },
    -- third row
    { DFFirst, UtilFirst, AAFirst, DFFirst, AAFirst, UtilFirst, DFFirst, },
    -- fourth row
    { DFFirst, ShieldFirst, AAFirst, T1ArtFirst, AAFirst, ShieldFirst, DFFirst, },
    -- fifth row
    { DFFirst, T1ArtFirst, AAFirst, ShieldFirst, AAFirst, T1ArtFirst, DFFirst, },
    -- sixth row
    { ArtFirst, UtilFirst, ArtFirst, AAFirst, ArtFirst, UtilFirst, ArtFirst, },
}

-- === 8 Wide Attack Block ===
EightWideAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, },
    -- second Row
    { DFFirst, ShieldFirst, DFFirst, ShieldFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, },
    -- third row
    { DFFirst, UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, UtilFirst, DFFirst, },
    -- fourth row
    { DFFirst, ShieldFirst, T1ArtFirst, AAFirst, AAFirst, T1ArtFirst, ShieldFirst, DFFirst, },
    -- fifth row
    { DFFirst, T1ArtFirst, AAFirst, T1ArtFirst, T1ArtFirst, AAFirst, T1ArtFirst, DFFirst, },
    -- sixth row
    { DFFirst, ShieldFirst, UtilFirst, ShieldFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst, },
    -- seventh row
    { DFFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, },
}

-- === 2 Row Attack Block - 8 units wide ===
TwoRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { AAFirst, UtilFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, UtilFirst, AAFirst },
}

-- === 3 Row Attack Block - 10 units wide ===
ThreeRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { AAFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst, ShieldFirst, AAFirst },
    -- third row
    { DFFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, DFFirst },
}

-- === 4 Row Attack Block - 12 units wide ===
FourRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { DFFirst, ShieldFirst, DFFirst, UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst },
    -- third row
    { DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst },
    -- fourth row
    { AAFirst, ShieldFirst, DFFirst, ArtFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, ArtFirst, DFFirst, ShieldFirst, AAFirst },
}

-- === 5 Row Attack Block - 14 units wide ===
FiveRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { UtilFirst, ShieldFirst, DFFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst, ShieldFirst, UtilFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, AAFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, AAFirst, DFFirst, AAFirst, DFFirst },
    -- fourth row
    { AAFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst },
    -- five row
    { ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst },
}

-- === 6 Row Attack Block - 16 units wide ===
SixRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { UtilFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, UtilFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst },
    -- fourth row
    { AAFirst, ShieldFirst, AAFirst, DFFirst, AAFirst, AAFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, AAFirst, AAFirst, DFFirst, AAFirst, ShieldFirst, AAFirst },
    -- fifth row
    { DFFirst, AAFirst, DFFirst, UtilFirst, ShieldFirst, DFFirst, DFFirst, AAFirst, AAFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst, DFFirst, AAFirst, DFFirst },
    -- sixth row
    { AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst },
}

-- === 7 Row Attack Block - 18 units wide ===
SevenRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { UtilFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst, ShieldFirst, DFFirst, ShieldFirst, UtilFirst },
    -- third row
    { DFFirst, DFFirst, AAFirst, DFFirst, AAFirst, DFFirst, DFFirst, DFFirst, AAFirst, AAFirst, DFFirst, DFFirst, DFFirst, AAFirst, DFFirst, AAFirst, DFFirst, DFFirst },
    -- fourth row
    { DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, DFFirst },
    -- fifth row
    { UtilFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, UtilFirst },
    -- sixth row
    { DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, UtilFirst, DFFirst, ShieldFirst, AAFirst, AAFirst, ShieldFirst, DFFirst, UtilFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst },
    -- seventh row
    { ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst },
}

-- === 8 Row Attack Block - 20 units wide ===
EightRowAttackFormationBlock = {
    -- first row
    { DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst, DFFirst },
    -- second row
    { DFFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, UtilFirst, ShieldFirst, DFFirst },
    -- third row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst },
    -- fourth row
    { DFFirst, ShieldFirst, DFFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, ShieldFirst, DFFirst, DFFirst, ShieldFirst, AAFirst, ShieldFirst, DFFirst, ShieldFirst, AAFirst, DFFirst, ShieldFirst, DFFirst },
    -- fifth row
    { DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, AAFirst, AAFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst, DFFirst, AAFirst, DFFirst },
    -- sixth row
    { UtilFirst, ShieldFirst, ArtFirst, ShieldFirst, ArtFirst, UtilFirst, ShieldFirst, ArtFirst, ShieldFirst, AAFirst, AAFirst, ShieldFirst, ArtFirst, ShieldFirst, UtilFirst, ArtFirst, ShieldFirst, ArtFirst, ShieldFirst, UtilFirst },
    -- seventh row
    { DFFirst, AAFirst, DFFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, ArtFirst, ArtFirst, AAFirst, ArtFirst, DFFirst, AAFirst, DFFirst },
    -- eight row
    { AAFirst, ShieldFirst, ArtFirst, AAFirst, ShieldFirst, ArtFirst, ShieldFirst, AAFirst, ShieldFirst, ArtFirst, ArtFirst, ShieldFirst, AAFirst, ShieldFirst, ArtFirst, ShieldFirst, AAFirst, ArtFirst, ShieldFirst, AAFirst },
}

-- =========================================
-- ================ AIR DATA ===============
-- =========================================

-- === AIR CATEGORIES ===
GroundAttackAir = (categories.AIR * categories.GROUNDATTACK) - categories.ANTIAIR
TransportationAir = categories.AIR * categories.TRANSPORTATION - categories.GROUNDATTACK
BomberAir = categories.AIR * categories.BOMBER
AAAir = categories.AIR * categories.ANTIAIR
AntiNavyAir = categories.AIR * categories.ANTINAVY
IntelAir = categories.AIR * (categories.SCOUT + categories.RADAR)
ExperimentalAir = categories.AIR * categories.EXPERIMENTAL
TitanAir = categories.AIR * categories.TITAN
HeroAir = categories.AIR * categories.HERO
EliteAir = categories.AIR * categories.ELITE
EngineerAir = categories.AIR * categories.ENGINEER

-- === TECH LEVEL AIR CATEGORIES ===
AirCategories = {
    Ground1 = GroundAttackAir * categories.TECH1,
    Ground2 = GroundAttackAir * categories.TECH2,
    Ground3 = GroundAttackAir * categories.TECH3,
		
    Trans1 = TransportationAir * categories.TECH1,
    Trans2 = TransportationAir * categories.TECH2,
    Trans3 = TransportationAir* categories.TECH3,

    Bomb1 = BomberAir * categories.TECH1,
    Bomb2 = BomberAir * categories.TECH2,
    Bomb3 = BomberAir * categories.TECH3,

    AA1 = AAAir * categories.TECH1,
    AA2 = AAAir * categories.TECH2,
    AA3 = AAAir * categories.TECH3,

    AN1 = AntiNavyAir * categories.TECH1,
    AN2 = AntiNavyAir * categories.TECH2,
    AN3 = AntiNavyAir * categories.TECH3,

    AIntel1 = IntelAir * categories.TECH1,
    AIntel2 = IntelAir * categories.TECH2,
    AIntel3 = IntelAir * categories.TECH3,


	AElite = EliteAir,
    AExper = ExperimentalAir,
	ATitan = TitanAir,
	AHero = HeroAir,

    AEngineer = EngineerAir,

    RemainingCategory = categories.AIR - (GroundAttackAir + TransportationAir + BomberAir + AAAir + AntiNavyAir + IntelAir + ExperimentalAir + EngineerAir + EliteAir + TitanAir + HeroAir)
}

-- === SUB GROUP ORDERING ===
GroundAttack = { 'Ground3', 'Ground2', 'Ground1', }
Transports = { 'Trans3', 'Trans2', 'Trans1', }
Bombers = { 'Bomb3', 'Bomb2', 'Bomb1', }
T3Bombers = {'Bomb3',}
AntiAir = { 'AA3', 'AA2', 'AA1', }
AntiNavy = { 'AN3', 'AN2', 'AN1', }
Intel = { 'AIntel3', 'AIntel2', 'AIntel1', }
EliAir = { 'AElite'}
ExperAir = { 'AExper'}
TitaAir = { 'ATitan'}
HerAir = { 'AHero'}
EngAir = { 'AEngineer', }

-- === Air Block Arrangement ===
ChevronSlot = { AntiAir, HerAir, TitaAir, ExperAir, EliAir, AntiNavy, GroundAttack, Bombers, Intel, Transports, EngAir, RemainingCategory }
StratSlot = { T3Bombers }

AttackChevronBlock = {
    RepeatAllRows = false,
    HomogenousBlocks = true,
    { ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, }, -- 1 -> 3 at 20 units
    { ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, }, -- 3 -> 5 at 60 units
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, }, -- 5 -> 7 at 170 units
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, }, -- 7 -> 9 at 390 units
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, }, -- 9 -> 11 at 760 units
}

GrowthChevronBlock = {
    RepeatAllRows = false,
    HomogenousBlocks = true,
    { ChevronSlot, },
    { ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, }, -- 1 -> 3 at 25 units
    { ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, }, -- 3 -> 5 at 95 units
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, }, -- 5 -> 7 at 255 units
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, },
    { ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, ChevronSlot, }, -- 7 -> 9 at 545 units
}



-- =========================================
-- ============== NAVAL DATA ===============
-- =========================================

LightAttackNaval = categories.LIGHTBOAT
FrigateNaval = categories.FRIGATE
SubNaval = categories.T1SUBMARINE + categories.T2SUBMARINE + (categories.TECH3 * categories.SUBMERSIBLE * categories.ANTINAVY * categories.NAVAL - categories.NUKE)
DestroyerNaval = categories.DESTROYER
CruiserNaval = categories.CRUISER
BattleshipNaval = categories.BATTLESHIP
CarrierNaval = categories.NAVALCARRIER
NukeSubNaval = categories.NUKESUB - SubNaval
MobileSonar = categories.MOBILESONAR
DefensiveBoat = categories.DEFENSIVEBOAT
RemainingNaval = categories.NAVAL - (LightAttackNaval + FrigateNaval + SubNaval + DestroyerNaval + CruiserNaval + BattleshipNaval +
                        CarrierNaval + NukeSubNaval + DefensiveBoat + MobileSonar)


-- === TECH LEVEL LAND CATEGORIES ===
NavalCategories = {
    LightCount = LightAttackNaval,
    FrigateCount = FrigateNaval,

    CruiserCount = CruiserNaval,
    DestroyerCount = DestroyerNaval,

    BattleshipCount = BattleshipNaval,
    CarrierCount = CarrierNaval,

    NukeSubCount = NukeSubNaval,
    MobileSonarCount = MobileSonar + DefensiveBoat,

    RemainingCategory = RemainingNaval,
}

SubCategories = {
    SubCount = SubNaval,
}

-- === SUB GROUP ORDERING ===
Frigates = { 'FrigateCount', 'LightCount', }
Destroyers = { 'DestroyerCount', }
Cruisers = { 'CruiserCount', }
Battleships = { 'BattleshipCount', }
Subs = { 'SubCount', }
NukeSubs = { 'NukeSubCount', }
Carriers = { 'CarrierCount', }
Sonar = {'MobileSonarCount', }

-- === NAVAL BLOCK TYPES =
FrigatesFirst = { Frigates, Destroyers, Battleships, Cruisers, Carriers, NukeSubs, Sonar, RemainingCategory }
DestroyersFirst = { Destroyers, Frigates, Battleships, Cruisers, Carriers, NukeSubs, Sonar, RemainingCategory }
CruisersFirst = { Cruisers, Carriers, Battleships, Destroyers, Frigates, NukeSubs, Sonar, RemainingCategory }
LargestFirstDF = { Battleships, Carriers, Destroyers, Cruisers, Frigates, NukeSubs, Sonar, RemainingCategory }
SmallestFirstDF = { Frigates, Destroyers, Cruisers, Sonar, Battleships, Carriers, NukeSubs, RemainingCategory }
LargestFirstAA = { Carriers, Battleships, Cruisers, Destroyers, Frigates, NukeSubs, Sonar, RemainingCategory }
SmallestFirstAA = { Cruisers, Frigates, Destroyers, Sonar, Carriers, Battleships, NukeSubs, RemainingCategory }
Subs = { Subs, NukeSubs, RemainingCategory }
SonarFirst = { Sonar, Carriers, Cruisers, Battleships, Destroyers, Frigates, NukeSubs, Sonar, RemainingCategory }

-- === NAVAL BLOCKS ===

-- === Three Naval Growth Formation Block ==
ThreeNavalGrowthFormation = {
    LineBreak = 0.5,
    -- first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst },
    -- second row
    { LargestFirstDF, SonarFirst, LargestFirstDF },
    -- third row
    { DestroyersFirst, CruisersFirst, DestroyersFirst },
}

-- === Five Naval Growth Formation Block ==
FiveNavalGrowthFormation = {
    LineBreak = 0.5,
    -- first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst },
    -- second row
    { FrigatesFirst, LargestFirstDF, DestroyersFirst, LargestFirstDF, FrigatesFirst },
    -- third row
    { DestroyersFirst, SmallestFirstDF, SonarFirst, SmallestFirstDF, DestroyersFirst },
    -- fourth row
    { DestroyersFirst, LargestFirstAA, CruisersFirst, LargestFirstAA, DestroyersFirst },
    -- fifth row
    { DestroyersFirst, SmallestFirstAA, CruisersFirst, SmallestFirstAA, DestroyersFirst },

}

-- === Seven Naval Growth Formation Block ==
SevenNavalGrowthFormation = {
    LineBreak = 0.5,
    -- first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst },
    -- second row
    { FrigatesFirst, SmallestFirstDF, DestroyersFirst, DestroyersFirst, DestroyersFirst, SmallestFirstDF, FrigatesFirst },
    -- third row
    { DestroyersFirst, DestroyersFirst, LargestFirstDF, SonarFirst, LargestFirstDF, DestroyersFirst, DestroyersFirst },
    -- fourth row
    { DestroyersFirst, SmallestFirstAA, SmallestFirstAA, CruisersFirst, SmallestFirstAA, SmallestFirstAA, DestroyersFirst },
    -- fifth row
    { DestroyersFirst, CruisersFirst, LargestFirstAA, DestroyersFirst, LargestFirstAA, CruisersFirst, DestroyersFirst },
    -- sixth row
    { DestroyersFirst, SmallestFirstAA, SmallestFirstAA, SonarFirst, SmallestFirstAA, SmallestFirstAA, DestroyersFirst },
    -- seventh row
    { DestroyersFirst, CruisersFirst, LargestFirstDF, CruisersFirst, LargestFirstDF, CruisersFirst, DestroyersFirst },
}

-- === Nine Naval Growth Formation Block ==
NineNavalGrowthFormation = {
    LineBreak = 0.5,
    -- first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst },
    -- second row
    { FrigatesFirst, LargestFirstDF, SonarFirst, LargestFirstDF, DestroyersFirst, LargestFirstDF, SonarFirst, LargestFirstDF, FrigatesFirst },
    -- third row
    { SmallestFirstDF, DestroyersFirst, SmallestFirstAA, SmallestFirstAA, SonarFirst, SmallestFirstAA, SmallestFirstAA, DestroyersFirst, SmallestFirstDF },
    -- fourth row
    { DestroyersFirst, LargestFirstAA, CruisersFirst, LargestFirstAA, CruisersFirst, LargestFirstAA, CruisersFirst, LargestFirstAA, DestroyersFirst },
    -- fifth row
    { DestroyersFirst, DestroyersFirst, SmallestFirstAA, SmallestFirstAA, CruisersFirst, SmallestFirstAA, SmallestFirstAA, DestroyersFirst, DestroyersFirst },
}

-- ==============================================
-- ============ Naval Attack Formation===========
-- ==============================================

-- === Five Wide Naval Attack Formation Block ==
FiveWideNavalAttackFormation = {
    LineBreak = 0.5,
    -- first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst},
    -- second row
    { DestroyersFirst, LargestFirstDF, CruisersFirst, LargestFirstDF, DestroyersFirst},
}

-- === Seven Wide Naval Attack Formation Block ==
SevenWideNavalAttackFormation = {
    LineBreak = 0.5,
    -- first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst },
    -- second row
    { DestroyersFirst, SonarFirst, LargestFirstDF, DestroyersFirst, LargestFirstDF, SonarFirst, DestroyersFirst },
    -- third row
    { SmallestFirstDF, SmallestFirstAA, SmallestFirstDF, CruisersFirst, SmallestFirstDF, SmallestFirstAA, SmallestFirstDF },
}

-- === Nine Wide Naval Attack Formation Block ==
NineWideNavalAttackFormation = {
    LineBreak = 0.5,
    -- first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst },
    -- second row
    { DestroyersFirst, LargestFirstDF, SonarFirst, LargestFirstDF, DestroyersFirst, LargestFirstDF, SonarFirst, LargestFirstDF, DestroyersFirst },
    -- third row
    { SmallestFirstDF, DestroyersFirst, SmallestFirstAA, SmallestFirstAA, SonarFirst, SmallestFirstAA, SmallestFirstAA, DestroyersFirst, SmallestFirstDF },
    -- fourth row
    { DestroyersFirst, SmallestFirstDF, CruisersFirst, LargestFirstAA, CruisersFirst, LargestFirstAA, CruisersFirst, SmallestFirstDF, DestroyersFirst },
}

-- === Eleven Wide Naval Attack Formation Block ==
ElevenWideNavalAttackFormation = {
    LineBreak = 0.5,
    -- first row
    { FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst, FrigatesFirst },
    -- second row
    { DestroyersFirst, DestroyersFirst, LargestFirstDF, SmallestFirstDF, LargestFirstDF, DestroyersFirst, LargestFirstDF, SmallestFirstDF, LargestFirstDF, DestroyersFirst, DestroyersFirst },
    -- third row
    { SmallestFirstDF, DestroyersFirst, SmallestFirstAA, SmallestFirstAA, SmallestFirstAA, SonarFirst, SmallestFirstAA, SmallestFirstAA, SmallestFirstAA, DestroyersFirst, SmallestFirstDF },
    -- fourth row
    { DestroyersFirst, SmallestFirstAA, LargestFirstDF, SonarFirst, LargestFirstAA, CruisersFirst, LargestFirstAA, SonarFirst, LargestFirstDF, SmallestFirstAA, DestroyersFirst },
}

-- ==============================================
-- ============ Sub Growth Formation===========
-- ==============================================
-- === Four Wide Growth Subs Formation ===
FourWideSubGrowthFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs },
}

-- === Six Wide Subs Formation ===
SixWideSubGrowthFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs },
}

-- === Eight Wide Subs Formation ===
EightWideSubGrowthFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
}


-- ==============================================
-- ============ Sub Attack Formation===========
-- ==============================================

-- === Four Wide Subs Formation ===
FourWideSubAttackFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs },
}

-- === Six Wide Subs Formation ===
SixWideSubAttackFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs },
}

-- === Eight Wide Subs Formation ===
EightWideSubAttackFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
}

-- === Ten Wide Subs Formation ===
TenWideSubAttackFormation = {
    LineBreak = 0.5,
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
    { Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs, Subs },
}

-- ============ Formation Pickers ============
---@param typeName string
---@param distance Vector
---@return number
function PickBestTravelFormationIndex(typeName, distance)
    if typeName == 'AirFormations' then
        return 0;
    else
        return 1;
    end
end

---@param typeName string
---@param distance Vector
---@return number
function PickBestFinalFormationIndex(typeName, distance)
    return -1;
end

-- ================ THE GUTS ====================
-- ============ Formation Functions =============
-- ==============================================
---@param formationUnits Unit[]
---@return table
function AttackFormation(formationUnits)
    local cachedResults = GetCachedResults(formationUnits, 'AttackFormation')
    if cachedResults then
        return cachedResults
    end

    FormationPos = {}

    local unitsList = CategorizeUnits(formationUnits)
    local landUnitsList = unitsList.Land
    local landBlock
    if landUnitsList.AreaTotal <= 16 then -- 8 wide
        landBlock = TwoRowAttackFormationBlock
    elseif landUnitsList.AreaTotal <= 30 then -- 10 wide
        landBlock = ThreeRowAttackFormationBlock
    elseif landUnitsList.AreaTotal <= 48 then -- 12 wide
        landBlock = FourRowAttackFormationBlock
    elseif landUnitsList.AreaTotal <= 70 then -- 14 wide
        landBlock = FiveRowAttackFormationBlock
    elseif landUnitsList.AreaTotal <= 96 then -- 16 wide
        landBlock = SixRowAttackFormationBlock
    elseif landUnitsList.AreaTotal <= 126 then -- 18 wide
        landBlock = SevenRowAttackFormationBlock
    else -- 20 wide
        landBlock = EightRowAttackFormationBlock
    end
    BlockBuilderLand(landUnitsList, landBlock, LandCategories, 1)

    local seaUnitsList = unitsList.Naval
    local subUnitsList = unitsList.Subs
    local seaArea = seaUnitsList.AreaTotal
    local subArea = subUnitsList.AreaTotal
    local seaBlock
    local subBlock

    if seaArea <= 10 and subArea <= 8 then
        seaBlock = FiveWideNavalAttackFormation
        subBlock = FourWideSubAttackFormation
    elseif seaArea <= 21 and subArea <= 18 then
        seaBlock = SevenWideNavalAttackFormation
        subBlock = SixWideSubAttackFormation
    elseif seaArea <= 36 and subArea <= 32 then
        seaBlock = NineWideNavalAttackFormation
        subBlock = EightWideSubAttackFormation
    else
        seaBlock = ElevenWideNavalAttackFormation
        subBlock = TenWideSubAttackFormation
    end
    BlockBuilderLand(seaUnitsList, seaBlock, NavalCategories, 1)
    BlockBuilderLand(subUnitsList, subBlock, SubCategories, 1)
    BlockBuilderAir(unitsList.Air, AttackChevronBlock, 1)

    CacheResults(FormationPos, formationUnits, 'AttackFormation')
    return FormationPos
end

---@param formationUnits Unit[]
---@return table
function GrowthFormation(formationUnits)
    local cachedResults = GetCachedResults(formationUnits, 'GrowthFormation')
    if cachedResults then
        return cachedResults
    end

    FormationPos = {}

    local unitsList = CategorizeUnits(formationUnits)
    local landUnitsList = unitsList.Land
    local landBlock
    if landUnitsList.AreaTotal <= 3 then
        landBlock = ThreeWideAttackFormationBlock
    elseif landUnitsList.AreaTotal <= 12 then
        landBlock = FourWideAttackFormationBlock
    elseif landUnitsList.AreaTotal <= 20 then
        landBlock = FiveWideAttackFormationBlock
    elseif landUnitsList.AreaTotal <= 30 then
        landBlock = SixWideAttackFormationBlock
    elseif landUnitsList.AreaTotal <= 42 then
        landBlock = SevenWideAttackFormationBlock
    else
        landBlock = EightWideAttackFormationBlock
    end
    BlockBuilderLand(landUnitsList, landBlock, LandCategories, 1)

    local seaUnitsList = unitsList.Naval
    local subUnitsList = unitsList.Subs
    local seaArea = seaUnitsList.AreaTotal
    local subArea = subUnitsList.AreaTotal
    local seaBlock
    local subBlock

    if seaArea <= 9 and subArea <= 12 then
        seaBlock = ThreeNavalGrowthFormation
        subBlock = FourWideSubGrowthFormation
    elseif seaArea <= 25 and subArea <= 20 then
        seaBlock = FiveNavalGrowthFormation
        subBlock = FourWideSubGrowthFormation
    elseif seaArea <= 49 and subArea <= 42 then
        seaBlock = SevenNavalGrowthFormation
        subBlock = SixWideSubGrowthFormation
    else
        seaBlock = NineNavalGrowthFormation
        subBlock = EightWideSubGrowthFormation
    end
    BlockBuilderLand(seaUnitsList, seaBlock, NavalCategories, 1)
    BlockBuilderLand(subUnitsList, subBlock, SubCategories, 1)

    if unitsList.Air.Bomb3[1] then
        local count = unitsList.Air.Bomb3[1].Count
        local oldAirArea = unitsList.Air.AreaTotal
        local oldUnitTotal = unitsList.Air.UnitTotal

        unitsList.Air.AreaTotal = count
        unitsList.Air.UnitTotal = count

        BlockBuilderAirT3Bombers(unitsList.Air, 1.5) --strats formation

        --strats are already in formation so we remove them from table and adjust all parameters.
        unitsList.Air.Bomb3 = {}
        unitsList.Air.AreaTotal = oldAirArea - count
        unitsList.Air.UnitTotal = oldUnitTotal - count

        BlockBuilderAir(unitsList.Air, GrowthChevronBlock, 1)
    else
        BlockBuilderAir(unitsList.Air, GrowthChevronBlock, 1)
    end


    CacheResults(FormationPos, formationUnits, 'GrowthFormation')
    return FormationPos
end

---@param formationUnits Unit[]
---@return table
function GuardFormation(formationUnits)
    -- Not worth caching GuardFormation because it's almost never called repeatedly with the same units.
    local FormationPos = {}

    local shieldCategory = ShieldCat
    local nonShieldCategory = categories.ALLUNITS - shieldCategory
    local footprintCounts = {}
    local remainingUnits = table.getn(formationUnits)
    local remainingShields = 0
    for _, u in formationUnits do
        if EntityCategoryContains(ShieldCat, u) then
            remainingShields = remainingShields + 1
        end

        local fs = u:GetBlueprint().Footprint.SizeMax
        footprintCounts[fs] = (footprintCounts[fs] or 0) + 1
    end

    local numSizes = 0
    for _ in footprintCounts do
        numSizes = numSizes + 1
    end

    local largestFootprint = 0
    local smallestFootprint = 9999
    local minCount = remainingUnits / numSizes -- This could theoretically divide by 0, but it wouldn't be a problem because the result would never be used.
    for fs, count in footprintCounts do
        largestFootprint = math.max(largestFootprint, fs)
        if count >= minCount then
            smallestFootprint = math.min(smallestFootprint, fs)
        end
    end

    local ringSpacing = (smallestFootprint + 2) / (largestFootprint + 2) -- A distance of 1 in formation coordinates is translated to (largestFootprint + 2) world units.
    local rotate = false
    local sizeMult = 0
    local ringChange = 0
    local ringCount = 1
    local unitCount = 1
    local shieldsInRing = 0
    local unitsPerShield = 0
    local nextShield = 0

    -- Form concentric circles around the assisted unit
    -- Most of the numbers after this point are arbitrary. Don't go looking for the significance of 0.19 or the like because there is none.
    while remainingUnits > 0 do
        if unitCount > ringChange then
            unitCount = 1
            ringCount = ringCount + 1
            sizeMult = ringCount * ringSpacing
            ringChange = ringCount * 6
            if remainingUnits < ringChange * 1.167 then
                ringChange = remainingUnits -- It looks better to squeeze a few more units into the last ring than add a ring with only one or two units.
            end

            if ringCount == 2 or remainingShields >= (remainingUnits + ringChange + 6) * 0.19 then
                shieldsInRing = math.min(ringChange / 2, remainingShields)
            elseif remainingShields >= (remainingUnits + ringChange + 6) * 0.13 then
                shieldsInRing = math.min(ringChange / 3, remainingShields)
            else
                shieldsInRing = 0
            end
            shieldsInRing = math.max(shieldsInRing, remainingShields - (remainingUnits - ringChange))

            if shieldsInRing > 0 then
                unitsPerShield = ringChange / shieldsInRing
                nextShield = unitsPerShield - 0.01 -- Rounding error could result in missing a shield if nextShield is supposed to equal ringChange.
            end
        end
        local ringPosition = unitCount / ringChange * math.pi * 2.0
        offsetX = sizeMult * math.sin(ringPosition)
        offsetY = -sizeMult * math.cos(ringPosition)
        if shieldsInRing > 0 and unitCount >= nextShield then
            table.insert(FormationPos, { offsetX, offsetY, shieldCategory, 0, rotate })
            remainingShields = remainingShields - 1
            nextShield = nextShield + unitsPerShield
        else
            table.insert(FormationPos, { offsetX, offsetY, nonShieldCategory, 0, rotate })
        end
        unitCount = unitCount + 1
        remainingUnits = remainingUnits - 1
    end

    return FormationPos
end

-- =========== LAND BLOCK BUILDING =================
---@param unitsList table
---@param formationBlock any
---@param categoryTable EntityCategory[]
---@param spacing? number defaults to 1
---@return table
function BlockBuilderLand(unitsList, formationBlock, categoryTable, spacing)
    spacing = (spacing or 1) * unitsList.Scale
    local numRows = table.getn(formationBlock)
    local rowNum = 1
    local whichRow = 1
    local whichCol = 1
    local currRowLen = table.getn(formationBlock[whichRow])
    local rowModifier = GetLandRowModifer(unitsList, categoryTable, currRowLen)
    currRowLen = currRowLen - rowModifier
    local evenRowLen = math.mod(currRowLen, 2) == 0
    local rowType = false
    local formationLength = 0
    local inserted = false
    local occupiedSpaces = {}

    while unitsList.UnitTotal > 0 do
        if whichCol > currRowLen then
            rowNum = rowNum + 1
            if whichRow == numRows then
                whichRow = 1
            else
                whichRow = whichRow + 1
            end
            formationLength = formationLength + 1 + (formationBlock.LineBreak or 0)
            whichCol = 1
            rowType = false
            currRowLen = table.getn(formationBlock[whichRow])
            if occupiedSpaces[rowNum] then
                rowModifier = 0
            else
                rowModifier = GetLandRowModifer(unitsList, categoryTable, currRowLen)
            end
            currRowLen = currRowLen - rowModifier
            evenRowLen = math.mod(currRowLen, 2) == 0
        end

        if occupiedSpaces[rowNum] and occupiedSpaces[rowNum][whichCol] then
            whichCol = whichCol + 1
            continue
        end

        local currColSpot = GetColSpot(currRowLen + rowModifier, whichCol + rowModifier) -- Translate whichCol to correct spot in row
        local currSlot = formationBlock[whichRow][currColSpot]
        for _, type in currSlot do
            if inserted then
                break
            end
            for _, group in type do
                if not formationBlock.HomogenousRows or (rowType == false or rowType == type) then
                    local fs = 0
                    local size = 0
                    local evenSize = true
                    local groupData = nil
                    for k, v in unitsList[group] do
                        size = unitsList.FootprintSizes[k]
                        evenSize = math.mod(size, 2) == 0
                        if v.Count > 0 then
                            if size > 1 and IsLandSpaceOccupied(occupiedSpaces, size, rowNum, whichCol, currRowLen, unitsList.UnitTotal) then
                                continue
                            end
                            fs = k
                            groupData = v
                            break
                        end
                    end
                    if groupData then
                        local offsetX = 0
                        local offsetY = 0

                        if size > 1 then
                            if whichCol == 1 and evenRowLen and evenSize then
                                offsetX = -0.5
                            else
                                offsetX = (size - 1) / 2
                            end
                            offsetY = (size - 1) / 2 * (1 + (formationBlock.LineBreak or 0))

                            OccupyLandSpace(occupiedSpaces, size, rowNum, whichCol, currRowLen)
                        end

                        local xPos
                        if evenRowLen then
                            xPos = math.ceil(whichCol/2) - .5 + offsetX
                            if not (math.mod(whichCol, 2) == 0) then
                                xPos = xPos * -1
                            end
                        else
                            if whichCol == 1 then
                                xPos = 0
                            else
                                xPos = math.ceil(((whichCol-1) /2)) + offsetX
                                if not (math.mod(whichCol, 2) == 0) then
                                    xPos = xPos * -1
                                end
                            end
                        end

                        if formationBlock.HomogenousRows and not rowType then
                            rowType = type
                        end

                        table.insert(FormationPos, {xPos * spacing, (-formationLength - offsetY) * spacing, groupData.Filter, formationLength, true})
                        inserted = true

                        groupData.Count = groupData.Count - 1
                        if groupData.Count <= 0 then
                            unitsList[group][fs] = nil
                        end
                        break
                    end
                end
            end
        end
        if inserted then
            unitsList.UnitTotal = unitsList.UnitTotal - 1
            inserted = false
        end
        whichCol = whichCol + 1
    end

    return FormationPos
end

---@param unitsList table
---@param categoryTable EntityCategory[]
---@param currRowLen number
---@return number
function GetLandRowModifer(unitsList, categoryTable, currRowLen)
    if unitsList.UnitTotal >= currRowLen or math.mod(unitsList.UnitTotal, 2) == math.mod(currRowLen, 2) then
        return 0
    end

    local sizeTotal = 0
    for group, _ in categoryTable do
        for fs, data in unitsList[group] do
            sizeTotal = sizeTotal + unitsList.FootprintSizes[fs] * data.Count
        end
    end
    if sizeTotal < currRowLen then -- This doesn't allow for large units hanging over the sides, but it's too hard to handle that correctly.
        return 1
    else
        return 0
    end
end

---@param occupiedSpaces boolean[][]
---@param size number
---@param rowNum number
---@param whichCol number
---@param currRowLen number
---@param remainingUnits number
---@return boolean
function IsLandSpaceOccupied(occupiedSpaces, size, rowNum, whichCol, currRowLen, remainingUnits)
    local evenRowLen = math.mod(currRowLen, 2) == 0
    local evenSize = math.mod(size, 2) == 0

    if whichCol == 1 and (not evenRowLen) and evenSize and remainingUnits > 1 then -- Don't put an even-sized unit in the middle of an odd-length row unless it's the last unit
        return true
    end
    if whichCol > currRowLen - math.floor(size / 2) * 2 and size <= math.floor(currRowLen / 2) then -- Don't put a large unit at the end of a row unless the row is too narrow
        return true
    end
    for y = 0, size - 1, 1 do
        local yPos = rowNum + y
        if not occupiedSpaces[yPos] then
            continue
        end
        if whichCol == 1 and evenRowLen == evenSize then
            for x = 0, size - 1, 1 do
                if occupiedSpaces[yPos][whichCol + x] then
                    return true
                end
            end
        else
            for x = 0, (size - 1) * 2, 2 do
                if occupiedSpaces[yPos][whichCol + x] then
                    return true
                end
            end
        end
    end
    return false
end

---@param occupiedSpaces boolean[][]
---@param size number
---@param rowNum number
---@param whichCol number
---@param currRowLen number
function OccupyLandSpace(occupiedSpaces, size, rowNum, whichCol, currRowLen)
    local evenRowLen = math.mod(currRowLen, 2) == 0
    local evenSize = math.mod(size, 2) == 0

    for y = 0, size - 1, 1 do
        local yPos = rowNum + y
        if not occupiedSpaces[yPos] then
            occupiedSpaces[yPos] = {}
        end
        if whichCol == 1 and evenRowLen == evenSize then
            for x = 0, size - 1, 1 do
                occupiedSpaces[yPos][whichCol + x] = true
            end
        else
            for x = 0, (size - 1) * 2, 2 do
                occupiedSpaces[yPos][whichCol + x] = true
            end
        end
    end
end

---@param rowLen number
---@param col number
---@return number
function GetColSpot(rowLen, col)
    local len = rowLen
    if math.mod(rowLen, 2) == 1 then
        len = rowLen + 1
    end
    local colType = 'left'
    if math.mod(col, 2) == 0 then
        colType = 'right'
    end
    local colSpot = math.floor(col / 2)
    local halfSpot = len/2
    if colType == 'left' then
        return halfSpot - colSpot
    else
        return halfSpot + colSpot
    end
end

-- ============ AIR BLOCK BUILDING =============
---@param unitsList table
---@param airBlock any
---@param spacing? number defaults to 1
---@return table
function BlockBuilderAir(unitsList, airBlock, spacing)
    spacing = (spacing or 1) * unitsList.Scale
    local numRows = table.getn(airBlock)
    local whichRow = 1
    local whichCol = 1
    local chevronPos = 1
    local currRowLen = table.getn(airBlock[whichRow])
    local chevronSize = airBlock.ChevronSize or 5
    local chevronType = false
    local formationLength = 0

    if unitsList.AreaTotal > unitsList.UnitTotal then -- If there are any units of size > 1 deal with them here
        local largeUnitPositions = GetLargeAirPositions(unitsList, airBlock)
        for _, data in largeUnitPositions do
            local currSlot = airBlock[data.row][data.col]
            for _, type in currSlot do
                for _, group in type do
                    for fs, groupData in unitsList[group] do
                        size = unitsList.FootprintSizes[fs]
                        if groupData.Count > 0 and size == data.size then
                            table.insert(FormationPos, {data.xPos * spacing, data.yPos * spacing, groupData.Filter, 0, true})
                            groupData.Count = groupData.Count - 1
                            if groupData.Count <= 0 then
                                unitsList[group][fs] = nil
                            end
                            unitsList.UnitTotal = unitsList.UnitTotal - 1
                            break
                        end
                    end
                end
            end
        end
    end

    if unitsList.UnitTotal < chevronSize and math.mod(unitsList.UnitTotal, 2) == 0 then
        chevronPos = 2
    end

    while unitsList.UnitTotal > 0 do
        if chevronPos > chevronSize then
            if unitsList.UnitTotal < chevronSize and math.mod(unitsList.UnitTotal, 2) == 0 then
                chevronPos = 2
            else
                chevronPos = 1
            end
            chevronType = false
            if whichCol >= currRowLen or unitsList.UnitTotal < chevronSize or unitsList.UnitTotal < chevronSize * 2 and math.mod(whichCol, 2) == 1 then
                if whichRow >= numRows then
                    if airBlock.RepeatAllRows then
                        whichRow = 1
                        currRowLen = table.getn(airBlock[whichRow])
                    end
                else
                    whichRow = whichRow + 1
                    currRowLen = table.getn(airBlock[whichRow])
                end
                formationLength = formationLength + 1
                whichCol = 1
            else
                whichCol = whichCol + 1
            end
        end

        local currSlot = airBlock[whichRow][whichCol]
        local inserted = false
        for _, type in currSlot do
            if inserted then
                break
            end
            for _, group in type do
                if not airBlock.HomogenousBlocks or chevronType == false or chevronType == type then
                    local fs = 0
                    local groupData = nil
                    for k, v in unitsList[group] do
                        if v.Count > 0 then
                            fs = k
                            groupData = v
                            break
                        end
                    end
                    if groupData then
                        local xPos, yPos = GetChevronPosition(chevronPos, whichCol, formationLength)
                        if airBlock.HomogenousBlocks and not chevronType then
                            chevronType = type
                        end
                        table.insert(FormationPos, {xPos * spacing, yPos * spacing, groupData.Filter, 0, true})
                        inserted = true

                        groupData.Count = groupData.Count - 1
                        if groupData.Count <= 0 then
                            unitsList[group][fs] = nil
                        end
                        break
                    end
                end
            end
        end
        if inserted then
            unitsList.UnitTotal = unitsList.UnitTotal - 1
        end
        chevronPos = chevronPos + 1
    end
    return FormationPos
end

---@param unitsList table
---@param spacing number? number defaults to 1
---@return table
function BlockBuilderAirT3Bombers(unitsList, spacing)
    --This is modified copy of BlockBuilderAir(). This function is used only for t3 bombers.
    --Some parts can be improved, but I just want stable and working version, so I did minimum adjustments and that's it.

    spacing = (spacing or 1) * unitsList.Scale
    local airBlock = {}

    if unitsList.Bomb3[1].Count > 20 then
        airBlock = {
            RepeatAllRows = false,
            HomogenousBlocks = true,
            {StratSlot}, --flight leader
            {StratSlot,StratSlot,StratSlot}, -- 3 lines
        }
    else
        airBlock = {
            RepeatAllRows = false,
            HomogenousBlocks = true,
            {StratSlot}, --flight leader
            {StratSlot,StratSlot}, -- 2 lines
        }
    end

    local numRows = table.getn(airBlock)
    local whichRow = 1
    local whichCol = 1
    local chevronPos = 1
    local currRowLen = table.getn(airBlock[whichRow])
    local chevronSize = 1
    local chevronType = false
    local formationLength = 0


    if unitsList.UnitTotal < chevronSize and math.mod(unitsList.UnitTotal, 2) == 0 then
        chevronPos = 2
    end

    while unitsList.UnitTotal > 0 do
        if chevronPos > chevronSize then
            if unitsList.UnitTotal < chevronSize and math.mod(unitsList.UnitTotal, 2) == 0 then
                chevronPos = 2
            else
                chevronPos = 1
            end
            chevronType = false
            if whichCol >= currRowLen or unitsList.UnitTotal < chevronSize or unitsList.UnitTotal < chevronSize * 2 and math.mod(whichCol, 2) == 1 then
                if whichRow >= numRows then
                    if airBlock.RepeatAllRows then
                        whichRow = 1
                        currRowLen = table.getn(airBlock[whichRow])
                    end
                else
                    whichRow = whichRow + 1
                    currRowLen = table.getn(airBlock[whichRow])
                end
                formationLength = formationLength + 1
                whichCol = 1
            else
                whichCol = whichCol + 1
            end
        end

        local currSlot = airBlock[whichRow][whichCol]
        local inserted = false
        for _, type in currSlot do
            if inserted then
                break
            end
            for _, group in type do
                if not airBlock.HomogenousBlocks or chevronType == false or chevronType == type then
                    local fs = 0
                    local groupData = nil
                    for k, v in unitsList[group] do
                        if v.Count > 0 then
                            fs = k
                            groupData = v
                            break
                        end
                    end
                    if groupData then
                        local xPos, yPos = GetChevronPosition(chevronPos, whichCol, formationLength)
                        if airBlock.HomogenousBlocks and not chevronType then
                            chevronType = type
                        end
                        table.insert(FormationPos, {xPos * spacing, yPos * spacing, groupData.Filter, 0, true})
                        inserted = true

                        groupData.Count = groupData.Count - 1
                        if groupData.Count <= 0 then
                            unitsList[group][fs] = nil
                        end
                        break
                    end
                end
            end
        end
        if inserted then
            unitsList.UnitTotal = unitsList.UnitTotal - 1
        end
        chevronPos = chevronPos + 1
    end
    return FormationPos
end

---@param unitsList table
---@param airBlock any
---@return table
function GetLargeAirPositions(unitsList, airBlock)
    local sizeCounts = {}
    for fs, count in unitsList.FootprintCounts do
        local size = unitsList.FootprintSizes[fs]
        if size > 1 then
            sizeCounts[size] = (sizeCounts[size] or 0) + count
        end
    end

    local numRows = table.getn(airBlock)
    local whichRow = 0
    local whichCol = 0
    local currRowLen = 0
    local wideRow = false
    local formationLength = -1
    local results = {}
    local numResults = 0
    for size, count in sizeCounts do
        local radius = size / 2
        while count > 0 do
            if whichCol >= currRowLen or count == 1 then
                if whichRow >= numRows then
                    if airBlock.RepeatAllRows then
                        whichRow = 1
                        currRowLen = table.getn(airBlock[whichRow])
                    end
                else
                    whichRow = whichRow + 1
                    currRowLen = table.getn(airBlock[whichRow])
                end
                formationLength = formationLength + 1
                whichCol = 1
                local x, y = GetChevronPosition(1, currRowLen, formationLength)
                wideRow = math.abs(x) >= radius
            else
                whichCol = whichCol + 2
            end

            if count == 2 and whichCol == 1 and wideRow then
                continue
            end

            local xPos, yPos = GetChevronPosition(1, whichCol, formationLength)
            if whichCol ~= 1 and math.abs(xPos) < radius then
                continue
            end

            -- Exponential complexity isn't fun but this should run in under 0.03 seconds on a slow CPU with 500 CZARs.
            local blocked = false
            for i = numResults, 1, -1 do -- Don't change this to a simple forward loop or it can take 15x as long with large numbers.
                local data = results[i]
                if VDist2(xPos, yPos, data.xPos, data.yPos) < radius + data.size / 2 then
                    blocked = true
                    break
                end
            end
            if not blocked then
                table.insert(results, {row = whichRow, col = whichCol, xPos = xPos, yPos = yPos, size = size})
                count = count - 1
                numResults = numResults + 1
                if whichCol ~= 1 then
                    table.insert(results, {row = whichRow, col = whichCol - 1, xPos = -xPos, yPos = yPos, size = size})
                    count = count - 1
                    numResults = numResults + 1
                end
            end
        end
    end
    return results
end

---@param chevronPos Vector
---@param currCol number
---@param formationLen number
---@return number xPos
---@return number yPos
function GetChevronPosition(chevronPos, currCol, formationLen)
    local offset = math.floor(chevronPos / 2)
    local xPos = offset * 0.5
    if math.mod(chevronPos, 2) == 0 then
        xPos = -xPos
    end
    local column = math.floor(currCol / 2)
    local yPos = (-offset + column * column) * 0.86603
    yPos = yPos - formationLen * 1.73205
    local blockOff = math.floor(currCol / 2) * 2.5
    if math.mod(currCol, 2) == 1 then
        blockOff = -blockOff
    end
    xPos = xPos + blockOff
    return xPos, yPos
end

-- ========= UNIT SORTING ==========
---@param unitsList table
---@return any
function CalculateSizes(unitsList)
    local largestFootprint = 1
    local smallestFootprints = {}

    local typeGroups = {
        Land = {
            GridSizeFraction = 2.75,
            GridSizeAbsolute = 2,
            MinSeparationFraction = 2.25,
            Types = {'Land'}
        },

        Air = {
            GridSizeFraction = 1.3,
            GridSizeAbsolute = 2,
            MinSeparationFraction = 1,
            Types = {'Air'}
        },

        Sea = {
            GridSizeFraction = 1.75,
            GridSizeAbsolute = 4,
            MinSeparationFraction = 1.15,
            Types = {'Naval', 'Subs'}
        },
    }

    for group, data in typeGroups do
        local groupFootprintCounts = {}
        local largestForGroup = 1
        local numSizes = 0
        local unitTotal = 0
        for _, type in data.Types do
            unitTotal = unitTotal + unitsList[type].UnitTotal
            for fs, count in unitsList[type].FootprintCounts do
                groupFootprintCounts[fs] = (groupFootprintCounts[fs] or 0) + count
                largestFootprint = math.max(largestFootprint, fs)
                largestForGroup = math.max(largestForGroup, fs)
                numSizes = numSizes + 1
            end
        end

        smallestFootprints[group] = largestForGroup
        if numSizes > 0 then
            local minCount = unitTotal / 2
            local smallerUnitCount = 0
            for fs, count in groupFootprintCounts do
                smallerUnitCount = smallerUnitCount + count
                if smallerUnitCount >= minCount then
                    smallestFootprints[group] = fs -- Base the grid size on the median unit size to avoid a few small units shrinking a formation of large untis
                    break
                end
            end
        end
    end

    for group, data in typeGroups do
        local gridSize = math.max(smallestFootprints[group] * data.GridSizeFraction, smallestFootprints[group] + data.GridSizeAbsolute)
        for _, type in data.Types do
            local unitData = unitsList[type]

             -- A distance of 1 in formation coordinates translates to (largestFootprint + 2) in world coordinates.
             -- Unfortunately the engine separates land/naval units from air units and calls the formation function separately for both groups.
             -- That means if a CZAR and some light tanks are selected together, the tank formation will be scaled by the CZAR's size and we can't compensate.
            unitData.Scale = gridSize / (largestFootprint + 2)

            for fs, count in unitData.FootprintCounts do
                local size = math.ceil(fs * data.MinSeparationFraction / gridSize)
                unitData.FootprintSizes[fs] = size
                unitData.AreaTotal = unitData.AreaTotal + count * size * size
            end
        end
    end

    return unitsList
end

---@param formationUnits Unit[]
---@return table
function CategorizeUnits(formationUnits)
    local unitsList = {
        Land = {
            Bot1 = {}, Bot2 = {}, Bot3 = {}, Bot35 = {}, Bot4 = {}, Bot5 = {}, Bot6 = {},
            Tank1 = {}, Tank2 = {}, Tank3 = {}, Tank35 = {}, Tank4 = {}, Tank5 = {}, Tank6 = {},
            Sniper1 = {}, Sniper2 = {}, Sniper3 = {}, Sniper35 = {}, Sniper4 = {}, Sniper5 = {}, Sniper6 = {},
            Art1 = {}, Art2 = {}, Art3 = {}, Art35 = {}, Art4 = {}, Art5 = {}, Art6 = {},
            AA1 = {}, AA2 = {}, AA3 = {}, AA35 = {}, AA4 = {}, AA5 = {}, AA6 = {},
            Com1 = {}, Com2 = {}, Com3 = {}, Com35 = {}, Com4 = {}, Com5 = {}, Com6 = {},
            Util1 = {}, Util2 = {}, Util3 = {}, Util35 = {}, Util4 = {}, Util5 = {}, Util6 = {},
            Shields = {},
            RemainingCategory = {},

            UnitTotal = 0,
            AreaTotal = 0,
            FootprintCounts = {},
            FootprintSizes = {},
        },

        Air = {
            Ground1 = {}, Ground2 = {}, Ground3 = {},
            Trans1 = {}, Trans2 = {}, Trans3 = {},
            Bomb1 = {}, Bomb2 = {}, Bomb3 = {},
            AA1 = {}, AA2 = {}, AA3 = {},
            AN1 = {}, AN2 = {}, AN3 = {},
            AIntel1 = {}, AIntel2 = {}, AIntel3 = {},
			AElite = {},
            AExper = {},
			ATitan = {},
			AHero = {},
            AEngineer = {},
            RemainingCategory = {},

            UnitTotal = 0,
            AreaTotal = 0,
            FootprintCounts = {},
            FootprintSizes = {},
        },

        Naval = {
            CarrierCount = {},
            BattleshipCount = {},
            DestroyerCount = {},
            CruiserCount = {},
            FrigateCount = {},
            LightCount = {},
            NukeSubCount = {},
            MobileSonarCount = {},
            RemainingCategory = {},

            UnitTotal = 0,
            AreaTotal = 0,
            FootprintCounts = {},
            FootprintSizes = {},
        },

        Subs = {
            SubCount = {},

            UnitTotal = 0,
            AreaTotal = 0,
            FootprintCounts = {},
            FootprintSizes = {},
        },
    }

    local categoryTables = {Land = LandCategories, Air = AirCategories, Naval = NavalCategories, Subs = SubCategories}

    -- Loop through each unit to get its category and size
    for _, u in formationUnits do
        local identified = false
        for type, table in categoryTables do
            for cat, _ in table do
                if EntityCategoryContains(table[cat], u) then
                    local bp = u:GetBlueprint()
                    local fs = math.max(bp.Footprint.SizeX, bp.Footprint.SizeZ)
                    local id = bp.BlueprintId

                    if not unitsList[type][cat][fs] then
                        unitsList[type][cat][fs] = {Count = 0, Categories = {}}
                    end
                    unitsList[type][cat][fs].Count = unitsList[type][cat][fs].Count + 1
                    unitsList[type][cat][fs].Categories[id] = categories[id]
                    unitsList[type].FootprintCounts[fs] = (unitsList[type].FootprintCounts[fs] or 0) + 1

                    if cat == "RemainingCategory" then
                        LOG('*FORMATION DEBUG: Unit ' .. tostring(u:GetBlueprint().BlueprintId) .. ' does not match any ' .. type .. ' categories.')
                    end
                    unitsList[type].UnitTotal = unitsList[type].UnitTotal + 1
                    identified = true
                    break
                end
            end

            if identified then
                break
            end
        end
        if not identified then
            WARN('*FORMATION DEBUG: Unit ' .. u.UnitId .. ' was excluded from the formation because its layer could not be determined.')
        end
    end

    -- Loop through each category and combine the types within into a single filter category for each size
    for type, table in categoryTables do
        for cat, _ in table do
            if unitsList[type][cat] then
                for fs, data in unitsList[type][cat] do
                    local filter = nil
                    for _, category in data.Categories do
                        if not filter then
                            filter = category
                        else
                            filter = filter + category
                        end
                    end
                    unitsList[type][cat][fs] = {Count = data.Count, Filter = filter}
                end
            end
        end
    end

    CalculateSizes(unitsList)

    return unitsList
end




-- FAF doesn't need the Rotation Patch, because it has the Functions already included.

end

