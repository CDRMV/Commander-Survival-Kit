LobbyGlobalOptions = {
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
        default = 1,
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
}
