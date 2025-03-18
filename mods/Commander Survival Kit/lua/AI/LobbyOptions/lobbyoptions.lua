AIOpts = {
	{
        default = 1,
        label = "<LOC tooltipCSKLOBDropDefTitle>Drop Turrets and Devices",
        help = "<LOC tooltipCSKLOBDropDefDesc>Set Drop Turrets and Devices to be callable or not in this Match.",
        key = 'DropInclude',
		pref = 'DropInclude_Info',
        values = {
			{
                text = "<LOC Callable>Callable",
                help = "<LOC tooltipCSKLOBDropDefYDesc>Set Drop Turrets and Devices to be callable by the Fire Support Manager in this Match.",
                key = 1,
            },
            {
                text = "<LOC NotCallable>Not Callable",
                help = "<LOC tooltipCSKLOBDropDefNDesc>Set Drop Turrets and Devices to be not callable by the Fire Support Manager in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 1,
        label = "<LOC tooltipCSKLOBLandRefTitle>Land Reinforcements",
        help = "<LOC tooltipCSKLOBLandRefDef>Set Land Reinforcements to be callable or not in this Match.",
        key = 'LandRefInclude',
		pref = 'LandRefInclude_Info',
        values = {
			{
                text = "<LOC Callable>Callable",
                help = "<LOC tooltipCSKLOBLRefYDesc>Set Land Reinforcements to be callable by the Reinforcements Manager in this Match.",
                key = 1,
            },
            {
                text = "<LOC NotCallable>Not Callable",
                help = "<LOC tooltipCSKLOBLRefNDesc>Set Land Reinforcements to be not callable by the Reinforcements Manager in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 1,
        label = "<LOC tooltipCSKLOBAirRefTitle>Air Reinforcements",
        help = "<LOC tooltipCSKLOBAirRefDesc>Set Air Reinforcements to be callable or not in this Match.",
        key = 'AirRefInclude',
		pref = 'AirRefInclude_Info',
        values = {
			{
                text = "<LOC Callable>Callable",
                help = "<LOC tooltipCSKLOBARefYDesc>Set Air Reinforcements to be callable by the Reinforcements Manager in this Match.",
                key = 1,
            },
            {
                text = "<LOC NotCallable>Not Callable",
                help = "<LOC tooltipCSKLOBARefNDesc>Set Air Reinforcements to be not callable by the Reinforcements Manager in this Match.",
                key = 2,
            },			
        },
	},
		{
        default = 1,
        label = "<LOC tooltipCSKLOBNavalRefTitle>Naval Reinforcements",
        help = "<LOC tooltipCSKLOBNavalRefDesc>Set Naval Reinforcements to be callable or not in this Match.",
        key = 'NavalRefInclude',
		pref = 'NavalRefInclude_Info',
        values = {
			{
                text = "<LOC Callable>Callable",
                help = "<LOC tooltipCSKLOBNRefYDesc>Set Naval Reinforcements to be callable by the Reinforcements Manager in this Match.",
                key = 1,
            },
            {
                text = "<LOC NotCallable>Not Callable",
                help = "<LOC tooltipCSKLOBNRefNDesc>Set Naval Reinforcements to be not callable by the Reinforcements Manager in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 1,
        label = "<LOC tooltipCSKLOBASIncTitle>Air Strikes",
        help = "<LOC tooltipCSKLOBASIncDesc>Set Air Strikes to be callable or not in this Match.",
        key = 'AirStrikesInclude',
		pref = 'AirStrikesInclude',
        values = {
			{
                text = "<LOC Callable>Callable",
                help = "<LOC tooltipCSKLOBASYDesc>Set Air Strikes to be callable Fire Support Manager in this Match.",
                key = 1,
            },
            {
                text = "<LOC NotCallable>Not Callable",
                help = "<LOC tooltipCSKLOBASNDesc>Set Air Strikes to be not callable Fire Support Manager in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 2,
        label = "<LOC tooltipCSKLOBASMechTitle>Air Strike Mechanic",
        help = "<LOC tooltipCSKLOBASMechDesc>Set the Air Strike Mechanic to Fly full Route or Attack Marker Location.",
        key = 'AirStrikeMechanic',
		pref = 'AirStrikeMechanic',
        values = {
			{
                text = "<LOC FlyFullRoute>Fly full Route",
                help = "<LOC tooltipCSKLOBASMechRouteDesc>Let Air Strikes fly a fixed Route from Spawn Side to opposite of the Map. They will Drop their Bombs on the first enemy Units which cross thier Path.",
                key = 1,
            },
            {
                text = "<LOC AttackMarkerLoc>Attack Marker Location",
                help = "<LOC tooltipCSKLOBASMechMAttackDesc>Let Air Strikes attack the Location of the Marker to drop their Bombs. They fly Back to their Spawn Location and disappear once they have drop their Bombs.",
                key = 2,
            },			
        },
	},
	{
        default = 2,
        label = "<LOC tooltipCSKLOBPointStoreTitle>Point Storages",
        help = "<LOC tooltipCSKLOBPointStoreDesc>Set the Reinforcement and Tactical Point Storages to be buildable or not in this Match.",
        key = 'PointStorage',
		pref = 'PointStorage_Info',
        values = {
			{
                text = "<LOC Buildable>Buildable",
                help = "<LOC tooltipCSKLOBPointStoreYDesc>Set the Reinforcement and Tactical Point Storages to be buildable in this Match.",
                key = 1,
            },
            {
                text = "<LOC NotBuildable>Not buildable",
                help = "<LOC tooltipCSKLOBPointStoreNDesc>Set the Reinforcement and Tactical Point Storages to be not buildable in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 2,
        label = "<LOC tooltipCSKLOBEXRefTitle>Experimental Reinforcements",
        help = "<LOC tooltipCSKLOBEXRefDesc>Set the Experimental Reinforcements to be callable or not in this Match.",
        key = 'EXPRef',
		pref = 'EXPRef_Info',
        values = {
			{
                text = "<LOC Callable>Callable",
                help = "<LOC tooltipCSKLOBEXRefYDesc>Set the Experimental Reinforcements to be callable in this Match.",
                key = 1,
            },
            {
                text = "<LOC NotCallable>Not callable",
                help = "<LOC tooltipCSKLOBEXRefNDesc>Set the Experimental Reinforcements to be not callable in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 2,
        label = "<LOC tooltipCSKLOBHQCTitle>HQ Communication Center",
        help = "<LOC tooltipCSKLOBHQCDesc>Set the HQ Communication Center to be buildable or not and the access to the two Managers in this Match.",
        key = 'HQComCentersIncluded',
		pref = 'HQComCenters_Included',
        values = {
			{
                text = "<LOC Buildable>Buildable",
                help = "<LOC tooltipCSKLOBHQCYDesc>Set the HQ Communication Center to be buildable in this Match. Access to both Managers if builded only.",
                key = 1,
            },
            {
                text = "<LOC NotBuildable>Not Buildable",
                help = "<LOC tooltipCSKLOBHQCNDesc>Set the HQ Communication Center to be not buildable in this Match. Access to both Managers is always available.",
                key = 2,
            },			
        },
	},
	{
        default = 1,
        label = "<LOC tooltipCSKLOBPointGenCTitle>Point Generation Centers",
        help = "<LOC tooltipCSKLOBPointGenCDesc>Set the Point Generation Centers to be buildable or not in this Match.",
        key = 'CentersIncluded',
		pref = 'Centers_Included',
        values = {
			{
                text = "<LOC Buildable>Buildable",
                help = "<LOC tooltipCSKLOBPointGenCYDesc>Set the Point Generation Centers to be buildable in this Match.",
                key = 1,
            },
            {
                text = "<LOC NotBuildable>Not Buildable",
                help = "<LOC tooltipCSKLOBPointGenCNDesc>Set the Point Generation Centers to be not buildable in this Match.",
                key = 2,
            },			
        },
	},
	{
        default = 1,
        label = "<LOC tooltipCSKLOBKPRSystemTitle>Kill Point Reward System",
        help = "<LOC tooltipCSKLOBKPRSystemDesc>Enables or Disables the Kill Point Reward System in this Match.",
        key = 'KillPointsIncluded',
		pref = 'KillPoints_Included',
        values = {
			{
                text = "<LOC Enabled>Enabled",
                help = "<LOC tooltipCSKLOBKPRSystemYDesc>Enables the Kill Point Reward System in this Match.",
                key = 1,
            },
            {
                text = "<LOC Disabled>Disabled",
                help = "<LOC tooltipCSKLOBKPRSystemNDesc>Disables the Kill Point Reward System in this Match.",
                key = 2,
            },			
        },
	},	
    {
        default = 5,
        label = "<LOC tooltipCSKLOBRefTimeTitle>Reinforcements available in:",
        help = "<LOC tooltipCSKLOBRefTimeDesc>Set the wait time for the Reinforcement Point Generation in Minutes.",
        key = 'RefPoints',
		pref = 'Ref_Points',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC tooltipCSKLOBRefPGen5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC tooltipCSKLOBRefPGen10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC tooltipCSKLOBRefPGen15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC tooltipCSKLOBRefPGen20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC tooltipCSKLOBRefPGen25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC tooltipCSKLOBRefPGen30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC tooltipCSKLOBRefPGen35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC tooltipCSKLOBRefPGen40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC tooltipCSKLOBRefPGen45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC tooltipCSKLOBRefPGen50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC tooltipCSKLOBRefPGen55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },				
        },
    },
	{
        default = 3,
        label = "<LOC tooltipCSKLOBRefPGenInTitle>Reinforcement Point Generation Interval:",
        help = "<LOC tooltipCSKLOBRefPGenInDesc>Set the Interval for the Reinforcement Point Generation in Seconds.",
        key = 'RefPointsGenInt',
		pref = 'Ref_PointsGenInt',
        values = {
            {
                text = "<LOC Second1>1 Second",
                help = "<LOC tooltipCSKLOBREFPointGenInt1Desc>Set the Point Generation Interval to 1 Second",
                key = 1,
            },
            {
                text = "<LOC Second2>2 Seconds",
                help = "<LOC tooltipCSKLOBREFPointGenInt2Desc>Set the Point Generation Interval to 2 Seconds",
                key = 2,
            },
            {
                text = "<LOC Second3>3 Seconds",
                help = "<LOC tooltipCSKLOBREFPointGenInt3Desc>Set the Point Generation Interval to 3 Seconds",
                key = 3,
            },				
        },
    },
	{
        default = 2,
        label = "<LOC tooltipCSKLOBRefPGenRTitle>Reinforcement Point Generation Rate:",
        help = "<LOC tooltipCSKLOBRefPGenRDesc>Set the Generation Rate of the Reinforcement Points.",
        key = 'RefPointsGenRate',
		pref = 'Ref_PointsGenRate',
        values = {
			{
                text = "<LOC Deactivated>Deactivated",
                help = "<LOC tooltipCSKLOBREFPointGenR0Desc>Set the Point Generation Rate to 0 Point",
                key = 0,
            },
            {
                text = "<LOC Point1>1 Point",
                help = "<LOC tooltipCSKLOBREFPointGenR1Desc>Set the Point Generation Rate to 1 Point",
                key = 1,
            },
            {
                text = "<LOC Point2>2 Points",
                help = "<LOC tooltipCSKLOBREFPointGenR2Desc>Set the Point Generation Rate to 2 Points",
                key = 2,
            },
            {
                text = "<LOC Point3>3 Points",
                help = "<LOC tooltipCSKLOBREFPointGenR3Desc>Set the Point Generation Rate to 3 Points",
                key = 3,
            },				
        },
    },
	{
		default = 4,
        label = "<LOC tooltipCSKLOBMaxRefPointTitle>Maximal Reinforcement Points:",
        help = "<LOC tooltipCSKLOBMaxRefPointDesc>Set the Maximum of collectable Reinforcement Points.",
        key = 'RefPointsMax',
		pref = 'Ref_PointsMax',
        values = {
		    {
                text = "<LOC Points0>0 Points",
                help = "<LOC tooltipCSKLOBMaxRefPoint0Desc>Set the Point Maximum to 0 Points",
                key = 0,
            },
			{
                text = "<LOC Points1000>1000 Points",
                help = "<LOC tooltipCSKLOBMaxRefPoint1000Desc>Set the Point Maximum to 1000 Points",
                key = 1000,
            },
            {
                text = "<LOC Points2000>2000 Points",
                help = "<LOC tooltipCSKLOBMaxRefPoint2000Desc>Set the Point Maximum to 2000 Points",
                key = 2000,
            },
            {
                text = "<LOC Points3000>3000 Points",
                help = "<LOC tooltipCSKLOBMaxRefPoint3000Desc>Set the Point Maximum to 3000 Points",
                key = 3000,
            },
            {
                text = "<LOC Points4000>4000 Points",
                help = "<LOC tooltipCSKLOBMaxRefPoint4000Desc>Set the Point Maximum to 4000 Points",
                key = 4000,
            },	
            {
                text = "<LOC Points5000>5000 Points",
                help = "<LOC tooltipCSKLOBMaxRefPoint5000Desc>Set the Point Maximum to 5000 Points",
                key = 5000,
            },			
        },
    },
	{
        default = 5,
        label = "<LOC tooltipCSKLOBTacTimeTitle>Fire Support available in:",
        help = "<LOC tooltipCSKLOBTacTimeDesc>Set the wait time for the Tactical Point Generation in Minutes.",
        key = 'TacPoints',
		pref = 'Tac_Points',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC tooltipCSKLOBFSPGen5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC tooltipCSKLOBFSPGen10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC tooltipCSKLOBFSPGen15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC tooltipCSKLOBFSPGen20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC tooltipCSKLOBFSPGen25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC tooltipCSKLOBFSPGen30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC tooltipCSKLOBFSPGen35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC tooltipCSKLOBFSPGen40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC tooltipCSKLOBFSPGen45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC tooltipCSKLOBFSPGen50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC tooltipCSKLOBFSPGen55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },					
        },
    },
	{
        default = 3,
        label = "<LOC tooltipCSKLOBTacPGenInTitle>Tactical Point Generation Interval:",
        help = "<LOC tooltipCSKLOBTacPGenInDesc>Set the Interval for the Tactical Point Generation in Seconds.",
        key = 'TacPointsGenInt',
		pref = 'Tac_PointsGenInt',
        values = {
            {
                text = "<LOC Second1>1 Second",
                help = "<LOC tooltipCSKLOBTacPointGenInt1Desc>Set the Point Generation Interval to 1 Second",
                key = 1,
            },
            {
                text = "<LOC Second2>2 Seconds",
                help = "<LOC tooltipCSKLOBTacPointGenInt2Desc>Set the Point Generation Interval to 2 Seconds",
                key = 2,
            },
            {
                text = "<LOC Second3>3 Seconds",
                help = "<LOC tooltipCSKLOBTacPointGenInt3Desc>Set the Point Generation Interval to 3 Seconds",
                key = 3,
            },				
        },
    },
	{
        default = 2,
        label = "<LOC tooltipCSKLOBTacPGenRTitle>Tactical Point Generation Rate:",
        help = "<LOC tooltipCSKLOBTacPGenRDesc>Set the Generation Rate of the Tactical Points.",
        key = 'TacPointsGenRate',
		pref = 'Tac_PointsGenRate',
        values = {
			{
                text = "<LOC Deactivated>Deactivated",
                help = "<LOC tooltipCSKLOBTacPointGenR0Desc>Set the Point Generation Rate to 0 Point",
                key = 0,
            },
            {
                text = "<LOC Point1>1 Point",
                help = "<LOC tooltipCSKLOBTacPointGenR1Desc>Set the Point Generation Rate to 1 Point",
                key = 1,
            },
            {
                text = "<LOC Point2>2 Points",
                help = "<LOC tooltipCSKLOBTacPointGenR2Desc>Set the Point Generation Rate to 2 Points",
                key = 2,
            },
            {
                text = "<LOC Point3>3 Points",
                help = "<LOC tooltipCSKLOBTacPointGenR3Desc>Set the Point Generation Rate to 3 Points",
                key = 3,
            },				
        },
    },
	{
	default = 3,
        label = "<LOC tooltipCSKLOBMaxTacPointTitle>Maximal Tactical Points:",
        help = "<LOC tooltipCSKLOBMaxTacPointDesc>Set the Maximum of collectable Tactical Points.",
        key = 'TacPointsMax',
		pref = 'Tac_PointsMax',
        values = {
		    {
                text = "<LOC Points0>0 Points",
                help = "<LOC tooltipCSKLOBMaxTacPoint0Desc>Set the Point Maximum to 0 Points",
                key = 0,
            },
			{
                text = "<LOC Points1000>1000 Points",
                help = "<LOC tooltipCSKLOBMaxTacPoint1000Desc>Set the Point Maximum to 1000 Points",
                key = 1000,
            },
            {
                text = "<LOC Points2000>2000 Points",
                help = "<LOC tooltipCSKLOBMaxTacPoint2000Desc>Set the Point Maximum to 2000 Points",
                key = 2000,
            },
            {
                text = "<LOC Points3000>3000 Points",
                help = "<LOC tooltipCSKLOBMaxTacPoint3000Desc>Set the Point Maximum to 3000 Points",
                key = 3000,
            },
            {
                text = "<LOC Points4000>4000 Points",
                help = "<LOC tooltipCSKLOBMaxTacPoint4000Desc>Set the Point Maximum to 4000 Points",
                key = 4000,
            },	
            {
                text = "<LOC Points5000>5000 Points",
                help = "<LOC tooltipCSKLOBMaxTacPoint5000Desc>Set the Point Maximum to 5000 Points",
                key = 5000,
            },			
        },
    },
	{
        default = 2,
        label = "<LOC tooltipCSKLOBEXASIncTitle>Experimental Air Strikes",
        help = "<LOC tooltipCSKLOBEXASIncDesc>Set Experimental Air Strikes to be callable or not in this Match.",
        key = 'EXAirStrikesInclude',
		pref = 'EXAirStrikesInclude',
        values = {
			{
                text = "<LOC Callable>Callable",
                help = "<LOC tooltipCSKLOBEXASYDesc>Set Experimental Air Strikes to be callable by the Fire Support Manager in this Match.",
                key = 1,
            },
            {
                text = "<LOC NotCallable>Not Callable",
                help = "<LOC tooltipCSKLOBEXASNDesc>Set Experimental Air Strikes to be not callable by the Fire Support Manager in this Match.",
                key = 2,
            },			
        },
	},
}
