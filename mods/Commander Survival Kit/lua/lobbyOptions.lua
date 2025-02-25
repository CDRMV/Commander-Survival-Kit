
do

teamOptions =
{
    {
        default = 1,
        label = "<LOC lobui_0088>Spawn",
        help = "<LOC lobui_0089>Determine what positions players spawn on the map",
        key = 'TeamSpawn',
        pref = 'Lobby_Team_Spawn',
        values = {
            {
                text = "<LOC lobui_0090>Random",
                help = "<LOC lobui_0091>Spawn everyone in random locations",
                key = 'random',
            },
            {
                text = "<LOC lobui_0092>Fixed",
                help = "<LOC lobui_0093>Spawn everyone in fixed locations (determined by slot)",
                key = 'fixed',
            },
        },
    },
    {
        default = 1,
        label = "<LOC lobui_0096>Team",
        help = "<LOC lobui_0097>Determines if players may switch teams while in game",
        key = 'TeamLock',
        pref = 'Lobby_Team_Lock',
        values = {
            {
                text = "<LOC lobui_0098>Locked",
                help = "<LOC lobui_0099>Teams are locked once play begins",
                key = 'locked',
            },
            {
                text = "<LOC lobui_0100>Unlocked",
                help = "<LOC lobui_0101>Players may switch teams during play",
                key = 'unlocked',
            },
        },
    },
}

globalOpts = {
    {
        default = 2,
        label = "<LOC lobui_0102>Unit Cap",
        help = "<LOC lobui_0103>Set the maximum number of units that can be in play",
        key = 'UnitCap',
        pref = 'Lobby_Gen_Cap',
        values = {
            {
                text = "<LOC lobui_0170>250",
                help = "<LOC lobui_0171>250 units per player may be in play",
                key = '250',
            },
            {
                text = "<LOC lobui_0172>500",
                help = "<LOC lobui_0173>500 units per player may be in play",
                key = '500',
            },
            {
                text = "<LOC lobui_0174>750",
                help = "<LOC lobui_0175>750 units per player may be in play",
                key = '750',
            },
            {
                text = "<LOC lobui_0235>1000",
                help = "<LOC lobui_0236>1000 units per player may be in play",
                key = '1000',
            },
        },
    },
    {
        default = 1,
        label = "<LOC lobui_0112>Fog of War",
        help = "<LOC lobui_0113>Set up how fog of war will be visualized",
        key = 'FogOfWar',
        pref = 'Lobby_Gen_Fog',
        values = {
            {
                text = "<LOC lobui_0114>Explored",
                help = "<LOC lobui_0115>Terrain revealed, but units still need recon data",
                key = 'explored',
            },
            {
                text = "<LOC lobui_0118>None",
                help = "<LOC lobui_0119>All terrain and units visible",
                key = 'none',
            },
        },
    },
    {
        default = 1,
        label = "<LOC lobui_0120>Victory Condition",
        help = "<LOC lobui_0121>Determines how a victory can be achieved",
        key = 'Victory',
        pref = 'Lobby_Gen_Victory',
        values = {
            {
                text = "<LOC lobui_0122>Assassination",
                help = "<LOC lobui_0123>Game ends when commander is destroyed",
                key = 'demoralization',
            },
            {
                text = "<LOC lobui_0124>Supremacy",
                help = "<LOC lobui_0125>Game ends when all structures, commanders and engineers are destroyed",
                key = 'domination',
            },
            {
                text = "<LOC lobui_0126>Annihilation",
                help = "<LOC lobui_0127>Game ends when all units are destroyed",
                key = 'eradication',
            },
            {
                text = "<LOC lobui_0128>Sandbox",
                help = "<LOC lobui_0129>Game never ends",
                key = 'sandbox',
            },
        },
    },
    {
        default = 2,
        label = "<LOC lobui_0242>Timeouts",
        help = "<LOC lobui_0243>Sets the number of timeouts each player can request",
        key = 'Timeouts',
        pref = 'Lobby_Gen_Timeouts',
        mponly = true,
        values = {
            {
                text = "<LOC lobui_0244>None",
                help = "<LOC lobui_0245>No timeouts are allowed",
                key = '0',
            },
            {
                text = "<LOC lobui_0246>Three",
                help = "<LOC lobui_0247>Each player has three timeouts",
                key = '3',
            },
            {
                text = "<LOC lobui_0248>Infinite",
                help = "<LOC lobui_0249>There is no limit on timeouts",
                key = '-1',
            },
        },
    },
    {
        default = 1,
        label = "<LOC lobui_0258>Game Speed",
        help = "<LOC lobui_0259>Set the game speed",
        key = 'GameSpeed',
        pref = 'Lobby_Gen_GameSpeed',
        values = {
            {
                text = "<LOC lobui_0260>Normal",
                help = "<LOC lobui_0261>Fixed at the normal game speed (+0)",
                key = 'normal',
            },
            {
                text = "<LOC lobui_0262>Fast",
                help = "<LOC lobui_0263>Fixed at a fast game speed (+4)",
                key = 'fast',
            },
            {
                text = "<LOC lobui_0264>Adjustable",
                help = "<LOC lobui_0265>Adjustable in-game",
                key = 'adjustable',
            },
        },
    },
    {
        default = 1,
        label = "<LOC lobui_0208>Cheating",
        help = "<LOC lobui_0209>Enable cheat codes",
        key = 'CheatsEnabled',
        pref = 'Lobby_Gen_CheatsEnabled',
        values = {
            {
                text = "<LOC _Off>Off",
                help = "<LOC lobui_0210>Cheats disabled",
                key = 'false',
            },
            {
                text = "<LOC _On>On",
                help = "<LOC lobui_0211>Cheats enabled",
                key = 'true',
            },
        },
    },
    {
        default = 1,
        label = "<LOC lobui_0291>Civilians",
        help = "<LOC lobui_0292>Set how civilian units are used",
        key = 'CivilianAlliance',
        pref = 'Lobby_Gen_Civilians',
        values = {
            {
                text = "<LOC lobui_0293>Enemy",
                help = "<LOC lobui_0294>Civilians are enemies of players",
                key = 'enemy',
            },
            {
                text = "<LOC lobui_0295>Neutral",
                help = "<LOC lobui_0296>Civilians are neutral to players",
                key = 'neutral',
            },
            {
                text = "<LOC lobui_0297>None",
                help = "<LOC lobui_0298>No Civilians on the battlefield",
                key = 'removed',
            },
        },
    },
    {
        default = 1,
        label = "<LOC lobui_0310>Prebuilt Units",
        help = "<LOC lobui_0311>Set whether the game starts with prebuilt units or not",
        key = 'PrebuiltUnits',
        pref = 'Lobby_Prebuilt_Units',
        values = {
            {
                text = "<LOC lobui_0312>Off",
                help = "<LOC lobui_0313>No prebuilt units",
                key = 'Off',
            },
            {
                text = "<LOC lobui_0314>On",
                help = "<LOC lobui_0315>Prebuilt units set",
                key = 'On',
            },
        },
    },
    {
        default = 1,
        label = "<LOC lobui_0316>No Rush Option",
        help = "<LOC lobui_0317>Enforce No Rush rules for a certain period of time",
        key = 'NoRushOption',
        pref = 'Lobby_NoRushOption',
        values = {
            {
                text = "<LOC lobui_0318>Off",
                help = "<LOC lobui_0319>Rules not enforced",
                key = 'Off',
            },
            {
                text = "<LOC lobui_0320>5",
                help = "<LOC lobui_0321>Rules enforced for 5 mins",
                key = '5',
            },
            {
                text = "<LOC lobui_0322>10",
                help = "<LOC lobui_0323>Rules enforced for 10 mins",
                key = '10',
            },
            {
                text = "<LOC lobui_0324>20",
                help = "<LOC lobui_0325>Rules enforced for 20 mins",
                key = '20',
            },
        },
    },
	{
        default = 1,
        label = "Drop Turrets and Devices",
        help = "Set Drop Turrets and Devices to be callable or not in this Match.",
        key = 'DropInclude',
		pref = 'DropInclude_Info',
        values = {
			{
                text = "Callable",
                help = "Set Drop Turrets and Devices to be callable by the Fire Support Manager in this Match.",
                key = 1,
            },
            {
                text = "Not Callable",
                help = "Set Drop Turrets and Devices to be not callable by the Fire Support Manager in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 1,
        label = "Land Reinforcements",
        help = "Set Land Reinforcements to be callable or not in this Match.",
        key = 'LandRefInclude',
		pref = 'LandRefInclude_Info',
        values = {
			{
                text = "Callable",
                help = "Set Land Reinforcements to be callable by the Reinforcements Manager in this Match.",
                key = 1,
            },
            {
                text = "Not Callable",
                help = "Set Land Reinforcements to be not callable by the Reinforcements Manager in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 1,
        label = "Air Reinforcements",
        help = "Set Air Reinforcements to be callable or not in this Match.",
        key = 'AirRefInclude',
		pref = 'AirRefInclude_Info',
        values = {
			{
                text = "Callable",
                help = "Set Air Reinforcements to be callable by the Reinforcements Manager in this Match.",
                key = 1,
            },
            {
                text = "Not Callable",
                help = "Set Air Reinforcements to be not callable by the Reinforcements Manager in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 1,
        label = "Naval Reinforcements",
        help = "Set Naval Reinforcements to be callable or not in this Match.",
        key = 'NavalRefInclude',
		pref = 'NavalRefInclude_Info',
        values = {
			{
                text = "Callable",
                help = "Set Naval Reinforcements to be callable by the Reinforcements Manager in this Match.",
                key = 1,
            },
            {
                text = "Not Callable",
                help = "Set Naval Reinforcements to be not callable by the Reinforcements Manager in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 1,
        label = "Air Strikes",
        help = "Set Air Strikes to be callable or not in this Match.",
        key = 'AirStrikesInclude',
		pref = 'AirStrikesInclude',
        values = {
			{
                text = "Callable",
                help = "Set Air Strikes to be callable Fire Support Manager in this Match.",
                key = 1,
            },
            {
                text = "Not Callable",
                help = "Set Air Strikes to be not callable Fire Support Manager in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 2,
        label = "Air Strike Mechanic",
        help = "Set the Air Strike Mechnaic to Fly full Route or Attack Marker Location.",
        key = 'AirStrikeMechanic',
		pref = 'AirStrikeMechanic',
        values = {
			{
                text = "Fly full Route",
                help = "Let Air Strikes fly a fixed Route from Spawn Side to opposite of the Map. They will Drop their Bombs on the first enemy Units which cross thier Path.",
                key = 1,
            },
            {
                text = "Attack Marker Location",
                help = "Let Air Strikes attack the Location of the Marker to drop their Bombs. They fly Back to their Spawn Location and disappear once they have drop their Bombs.",
                key = 2,
            },			
        },
	},
	{
        default = 2,
        label = "Point Storages",
        help = "Set the Reinforcement and Tactical Storages to be buildable or not in this Match.",
        key = 'PointStorage',
		pref = 'PointStorage_Info',
        values = {
			{
                text = "Buildable",
                help = "Set the Reinforcement and Tactical Storages to be buildable in this Match.",
                key = 1,
            },
            {
                text = "Not buildable",
                help = "Set the Reinforcement and Tactical Storages to be not buildable in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 2,
        label = "Experimental Reinforcements",
        help = "Set the Experimental Reinforcements to be callable or not in this Match.",
        key = 'EXPRef',
		pref = 'EXPRef_Info',
        values = {
			{
                text = "Callable",
                help = "Set the Experimental Reinforcements to be callable in this Match.",
                key = 1,
            },
            {
                text = "Not callable",
                help = "Set the Experimental Reinforcements to be not callable in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 2,
        label = "HQ Communication Center",
        help = "Set the HQ Communication Center to be buildable or not and the access to the two Managers in this Match.",
        key = 'HQComCentersIncluded',
		pref = 'HQComCenters_Included',
        values = {
			{
                text = "Buildable",
                help = "Set the HQ Communication Center to be buildable in this Match. Access to both Managers if builded only.",
                key = 1,
            },
            {
                text = "Not Buildable",
                help = "Set the HQ Communication Center to be not buildable in this Match. Access to both Managers is always available.",
                key = 2,
            },			
        },
	},
	{
        default = 1,
        label = "Point Generation Centers",
        help = "Set the Point Generation Centers to be buildable or not in this Match.",
        key = 'CentersIncluded',
		pref = 'Centers_Included',
        values = {
			{
                text = "Buildable",
                help = "Set the Point Generation Centers to be buildable in this Match.",
                key = 1,
            },
            {
                text = "Not Buildable",
                help = "Set the Point Generation Centers to be not buildable in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 1,
        label = "Kill Point Reward System",
        help = "Enables or Disables the Kill Point Reward System in this Match.",
        key = 'KillPointsIncluded',
		pref = 'KillPoints_Included',
        values = {
			{
                text = "Enabled",
                help = "Enables the Kill Point Reward System in this Match.",
                key = 1,
            },
            {
                text = "Disabled",
                help = "Disables the Kill Point Reward System in this Match.",
                key = 2,
            },			
        },
	},	
    {
        default = 5,
        label = "Reinforcements available in:",
        help = "Set the wait time for the Reinforcement Point Generation in Minutes.",
        key = 'RefPoints',
		pref = 'Ref_Points',
        values = {
            {
                text = "5 Minutes",
                help = "Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "10 Minutes",
                help = "Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "15 Minutes",
                help = "Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "20 Minutes",
                help = "Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "25 Minutes",
                help = "Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "30 Minutes",
                help = "Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "35 Minutes",
                help = "Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "40 Minutes",
                help = "Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "45 Minutes",
                help = "Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "50 Minutes",
                help = "Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "55 Minutes",
                help = "Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "60 Minutes",
                help = "Set the Wait Time to 60 Minutes",
                key = 3600,
            },				
        },
    },
	{
        default = 3,
        label = "Reinforcement Point Generation Interval:",
        help = "Set the Interval for the Reinforcement Point Generation in Seconds.",
        key = 'RefPointsGenInt',
		pref = 'Ref_PointsGenInt',
        values = {
            {
                text = "1 Second",
                help = "Set the Point Generation Interval to 1 Second",
                key = 1,
            },
            {
                text = "2 Seconds",
                help = "Set the Point Generation Interval to 2 Seconds",
                key = 2,
            },
            {
                text = "3 Seconds",
                help = "Set the Point Generation Interval to 3 Seconds",
                key = 3,
            },				
        },
    },
	{
        default = 2,
        label = "Reinforcement Point Generation Rate:",
        help = "Set the Generation Rate of the Reinforcement Points.",
        key = 'RefPointsGenRate',
		pref = 'Ref_PointsGenRate',
        values = {
			{
                text = "Deactivated",
                help = "Set the Point Generation Rate to 0 Point",
                key = 0,
            },
            {
                text = "1 Point",
                help = "Set the Point Generation Rate to 1 Point",
                key = 1,
            },
            {
                text = "2 Points",
                help = "Set the Point Generation Rate to 2 Points",
                key = 2,
            },
            {
                text = "3 Points",
                help = "Set the Point Generation Rate to 3 Points",
                key = 3,
            },				
        },
    },
	{
		default = 4,
        label = "Maximal Reinforcement Points:",
        help = "Set the Maximum of collectable Reinforcement Points.",
        key = 'RefPointsMax',
		pref = 'Ref_PointsMax',
        values = {
		    {
                text = "0 Points",
                help = "Set the Point Maximum to 0 Points",
                key = 0,
            },
			{
                text = "1000 Points",
                help = "Set the Point Maximum to 1000 Points",
                key = 1000,
            },
            {
                text = "2000 Points",
                help = "Set the Point Maximum to 2000 Points",
                key = 2000,
            },
            {
                text = "3000 Points",
                help = "Set the Point Maximum to 3000 Points",
                key = 3000,
            },
            {
                text = "4000 Points",
                help = "Set the Point Maximum to 4000 Points",
                key = 4000,
            },	
            {
                text = "5000 Points",
                help = "Set the Point Maximum to 5000 Points",
                key = 5000,
            },				
        },
    },
	{
        default = 5,
        label = "Fire Support available in:",
        help = "Set the wait time for the Tactical Point Generation in Minutes.",
        key = 'TacPoints',
		pref = 'Tac_Points',
        values = {
            {
                text = "5 Minutes",
                help = "Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "10 Minutes",
                help = "Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "15 Minutes",
                help = "Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "20 Minutes",
                help = "Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "25 Minutes",
                help = "Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "30 Minutes",
                help = "Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "35 Minutes",
                help = "Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "40 Minutes",
                help = "Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "45 Minutes",
                help = "Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "50 Minutes",
                help = "Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "55 Minutes",
                help = "Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "60 Minutes",
                help = "Set the Wait Time to 60 Minutes",
                key = 3600,
            },					
        },
    },
	{
        default = 3,
        label = "Fire Support Point Generation Interval:",
        help = "Set the Interval for the Tactical Point Generation in Seconds.",
        key = 'TacPointsGenInt',
		pref = 'Tac_PointsGenInt',
        values = {
            {
                text = "1 Second",
                help = "Set the Point Generation Interval to 1 Second",
                key = 1,
            },
            {
                text = "2 Seconds",
                help = "Set the Point Generation Interval to 2 Seconds",
                key = 2,
            },
            {
                text = "3 Seconds",
                help = "Set the Point Generation Interval to 3 Seconds",
                key = 3,
            },				
        },
    },
	{
        default = 2,
        label = "Fire Support Point Generation Rate:",
        help = "Set the Generation Rate of the Tactical Points.",
        key = 'TacPointsGenRate',
		pref = 'Tac_PointsGenRate',
        values = {
			{
                text = "Deactivated",
                help = "Set the Point Generation Rate to 0 Point",
                key = 0,
            },
            {
                text = "1 Point",
                help = "Set the Point Generation Rate to 1 Point",
                key = 1,
            },
            {
                text = "2 Points",
                help = "Set the Point Generation Rate to 2 Points",
                key = 2,
            },
            {
                text = "3 Points",
                help = "Set the Point Generation Rate to 3 Points",
                key = 3,
            },				
        },
    },
	{
	default = 2,
        label = "Maximal Tactical Points:",
        help = "Set the Maximum of collectable Tactical Points.",
        key = 'TacPointsMax',
		pref = 'Tac_PointsMax',
        values = {
		    {
                text = "0 Points",
                help = "Set the Point Maximum to 0 Points",
                key = 0,
            },
			{
                text = "1000 Points",
                help = "Set the Point Maximum to 1000 Points",
                key = 1000,
            },
            {
                text = "2000 Points",
                help = "Set the Point Maximum to 2000 Points",
                key = 2000,
            },
            {
                text = "3000 Points",
                help = "Set the Point Maximum to 3000 Points",
                key = 3000,
            },
            {
                text = "4000 Points",
                help = "Set the Point Maximum to 4000 Points",
                key = 4000,
            },	
            {
                text = "5000 Points",
                help = "Set the Point Maximum to 5000 Points",
                key = 5000,
            },				
        },
    },
	{
        default = 2,
        label = "Experimental Air Strikes",
        help = "Set Experimental Air Strikes to be callable or not in this Match.",
        key = 'EXAirStrikesInclude',
		pref = 'EXAirStrikesInclude',
        values = {
			{
                text = "Callable",
                help = "Set Experimental Air Strikes to be callable by the Fire Support Manager in this Match.",
                key = 1,
            },
            {
                text = "Not Callable",
                help = "Set Experimental Air Strikes to be not callable by the Fire Support Manager in this Match.",
                key = 2,
            },			
        },
	},
}


end