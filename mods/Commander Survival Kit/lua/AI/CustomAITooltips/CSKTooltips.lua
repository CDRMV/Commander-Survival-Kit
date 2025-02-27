#****************************************************************************
#**
#**  File     :  /lua/AI/CustomAITooltips/CSKTooltips.lua
#**  Author(s): CDRMV
#**
#**  Summary  : Utility File to insert the new Lobby Options Tooltips.
#**
#****************************************************************************

   ASSpawmFromCombo = {
	    text = "Origin",
        body = "Set the Spawn Origin of all callable Air Strikes.",
   }
   DSpawmFromCombo = {
	    text = "Origin",
        body = "Set the Spawn Origin of the Delivery Units for all callable Drop Defenses.",
   }
   LandRefSpawmFromCombo = {
	    text = "Origin",
        body = "Set the Spawn Origin of the Delivery Units for all callable Land Reinforcements.",
   }
   AirRefSpawmFromCombo = {
	    text = "Origin",
        body = "Set the Spawn Origin of all callable Air Reinforcements.",
   }
   NavalRefSpawmFromCombo = {
	    text = "Origin",
        body = "Set the Spawn Origin of the Delivery Units for all callable Naval Reinforcements.",
   }


TestCombo = {
		text = "Drop Turrets and Devices:",
		body = "Set Drop Turrets and Devices to be callable or not in this Match.",		
}

TestCombo2 = {
		text = "Land Reinforcements:",
		body = "Set Land Reinforcements to be callable or not in this Match.",		
}

TestCombo3 = {
		text = "Air Reinforcements:",
		body = "Set Air Reinforcements to be callable or not in this Match.",		
}

TestCombo4 = {
		text = "Naval Reinforcements:",
		body = "Set Naval Reinforcements to be callable or not in this Match.",		
}

TestCombo5 = {
		text = "Air Strikes:",
		body = "Set Air Strikes to be callable or not in this Match.",		
}

TestCombo6 = {
		text = "Air Strike Mechanic:",
		body = "Set the Air Strike Mechanic to Fly full Route or Attack Marker Location.",		
}

TestCombo7 = {
		text = "Point Storages:",
		body = "Set the Reinforcement and Tactical Point Storages to be buildable or not in this Match.",		
}

TestCombo8 = {
		text = "Experimental Reinforcements:",
		body = "Set the Experimental Reinforcements to be callable or not in this Match.",		
}

TestCombo9 = {
		text = "HQ Communication Center:",
		body = "Set the HQ Communication Center to be buildable or not and the access to the two Managers in this Match.",		
}

TestCombo10 = {
		text = "Point Generation Centers:",
		body = "Set the Point Generation Centers to be buildable or not in this Match.",		
}

TestCombo11 = {
		text = "Kill Point Reward System:",
		body = "Enables or Disables the Kill Point Reward System in this Match.",		
}

TestCombo12 = {
		text = "Reinforcements available in:",
		body = "Set the wait time for the Reinforcement Point Generation in Minutes.",		
}

TestCombo13 = {
		text = "Reinforcement Point Generation Interval:",
		body = "Set the Interval for the Reinforcement Point Generation in Seconds.",		
}

TestCombo14 = {
		text = "Reinforcement Point Generation Rate:",
		body = "Set the Generation Rate of the Reinforcement Points.",		
}

TestCombo15 = {
		text = "Maximal Reinforcement Points:",
		body = "Set the Maximum of collectable Reinforcement Points.",		
}

TestCombo16 = {
		text = "Fire Support available in:",
		body = "Set the wait time for the Tactical Point Generation in Minutes.",		
}

TestCombo17 = {
		text = "Fire Support Point Generation Interval:",
		body = "Set the Interval for the Tactical Point Generation in Seconds.",		
}

TestCombo18 = {
		text = "Fire Support Point Generation Rate:",
		body = "Set the Generation Rate of the Tactical Points.",		
}

TestCombo19 = {
		text = "Maximal Tactical Points:",
		body = "Set the Maximum of collectable Tactical Points.",		
}

TestCombo20 = {
		text = "Experimental Air Strikes:",
		body = "Set Experimental Air Strikes to be callable or not in this Match.",		
}


Tooltips = { 
   SaveBtn = {
        title = "Save",
        description = "Save the current Configurations",
   },
   LoadBtn = {
        title = "Load",
        description = "Load the previously saved Configurations",
   },
   DoneBtn = {
        title = "Done",
        description = "Continue with the Mission and transfer all Configurations to the Code",
   }, 
   RefBtn = {
        title = "Reinforcement Manager",
        description = "Open/Hide the Layer Button Overview.",
   },
   FSBtn = {
        title = "Fire Support Manager",
        description = "Open/Hide the Fire Support Manager.",
   },
   LBtn = {
        title = "Land Reinforcement Manager",
        description = "Open/Hide the Land Reinforcement Manager.",
   },
   ABtn = {
        title = "Air Reinforcement Manager",
        description = "Open/Hide the Air Reinforcement Manager.",
   },
   NBtn = {
        title = "Naval Reinforcement Manager",
        description = "Open/Hide the Naval Reinforcement Manager.",
   },
   SBtn = {
        title = "Space Reinforcement Manager",
        description = "Open/Hide the Space Reinforcement Manager.",
   },
   DesNBtn = {
        title = "Naval Reinforcement Manager (Coming soon)",
        description = "Available in Version 2.0",
   },
   DesSBtn = {
        title = "Space Reinforcement Manager (Not available) ",
        description = "Requires the installation & activation of F.B.P. Orbital.",
   },
   FWBtn = {
        title = "Forward",
        description = "Go to the next Section Overview.",
   },
   BBtn = {
        title = "Back",
        description = "Go to the previous Section Overview.",
   },
   ASFWtn = {
        title = "Forward",
        description = "Go to the next Air Strike Overview.",
   },
   ASBBtn = {
        title = "Back",
        description = "Go to the previous Air Strike Overview.",
   },
   ArtFWtn = {
        title = "Forward",
        description = "Go to the next Artillery Overview.",
   },
   ArtBBtn = {
        title = "Back",
        description = "Go to the previous Artillery Overview.",
   },
   MFWtn = {
        title = "Forward",
        description = "Go to the next Missile Overview.",
   },
   MBBtn = {
        title = "Back",
        description = "Go to the previous Missile Overview.",
   },
   BFWtn = {
        title = "Forward",
        description = "Go to the next Beam Overview.",
   },
   BBBtn = {
        title = "Back",
        description = "Go to the previous Beam Overview.",
   },
   SPFWtn = {
        title = "Forward",
        description = "Go to the next Special Overview.",
   },
   SPBBtn = {
        title = "Back",
        description = "Go to the previous Special Overview.",
   },
   asboneBtn = {
        title = "Details:",
        description = "Calls in 1 Bomber.",
   },
   asbfiveBtn = {
        title = "Details:",
        description = "Calls in a squadron of 5 Bombers.",
   },
   asbtenBtn = {
        title = "Details:",
        description = "Calls in a squadron of 10 Bombers.",
   },
   asbfifteenBtn = {
        title = "Details:",
        description = "Calls in a squadron of 15 Bombers.",
   },
   HCBtn = {
        title = "Help",
        description = "Open/Hide the C.S.K. Helpcenter.",
   },
   
   LTBtn = {
        title = "How to call Land Reinforcements?",
        description = "Open/Hide the Tutorial Video Window.",
   },
   ATBtn = {
        title = "How to call Air Reinforcements?",
        description = "Open/Hide the Tutorial Video Window.",
   },
   STBtn = {
        title = "How to call Space Reinforcements?",
        description = "Open/Hide the Tutorial Video Window.",
   },
   ARTTBtn = {
        title = "How to call Artillery Barrages?",
        description = "Open/Hide the Tutorial Video Window.",
   },
   ASTBtn = {
        title = "How to call Air Strikes?",
        description = "Open/Hide the Tutorial Video Window.",
   },
   MTBtn = {
        title = "How to call Missile Barrages?",
        description = "Open/Hide the Tutorial Video Window.",
   },
   BTBtn = {
        title = "How to call Beam Barrages?",
        description = "Open/Hide the Tutorial Video Window.",
   },
   SPTBtn = {
        title = "How to call Special Weapon Barrages?",
        description = "Open/Hide the Tutorial Video Window.",
   },
   MPBtn = {
        title = "Play",
        description = "Play the Tutorial Video.",
   },
   MSBtn = {
        title = "Stop",
        description = "Stop the Tutorial Video.",
   },
	TacPointStorage = {
        title = "Tactical Point Storage",
        description = "Current and Maximum Tactical Point Values",
    }, 
	RefPointStorage = {
        title = "Command Point Storage",
        description = "Current and Maximum Command Point Values",
    }, 
	TacPointIncome = {
        title = "Tactical Point Income",
        description = "Display of generating Tactical Points per specific amount of Seconds",
    }, 
	RefPointIncome = {
        title = "Command Point Income",
        description = "Display of generating Command Points per specific amount of Seconds",
    }, 
	CSKMainPanel = {
        title = "[Hide/Show] Support Bar",
        description = "",
    }, 
	DropInclude_Info = {
        title = "Drop Turrets and Devices:",
        description = "Set Drop Turrets and Devices to be callable or not in this Match.",
    }, 
	AirStrikeMechanic = {
        title = "Air Strike Mechanic:",
        description = "Set the Air Strike Mechanic to Fly full Route or Attack Marker Location.",
    },
	AirStrikesInclude = {
        title = "Air Strikes:",
        description = "Set Air Strikes to be callable or not in this Match.",
    }, 
	EXAirStrikesInclude = {
        title = "Experimental Air Strikes:",
        description = "Set Experimental Air Strikes to be callable or not in this Match.",
    }, 
	PointStorage_Info = {
        title = "Point Storages:",
        description = "Set the Reinforcement and Tactical Point Storages to be buildable or not in this Match.",
    }, 
	AirRefInclude_Info = {
        title = "Air Reinforcements:",
        description = "Set the Air Reinforcements to be callable or not in this Match.",
    }, 
	LandRefInclude_Info = {
        title = "Land Reinforcements:",
        description = "Set the Land Reinforcements to be callable or not in this Match.",
    },
	NavalRefInclude_Info = {
        title = "Naval Reinforcements:",
        description = "Set the Naval Reinforcements to be callable or not in this Match.",
    }, 	
	EXPRef_Info = {
        title = "Experimental Reinforcements:",
        description = "Set the Experimental Reinforcements to be callable or not in this Match.",
    }, 
	HQComCenters_Included = {
        title = "HQ Communication Center:",
        description = "Set the HQ Communication Center to be buildable or not and the access to the two Managers in this Match.",
    },   
	Centers_Included = {
        title = "Point Generation Centers:",
        description = "Set the Point Generation Centers to be buildable or not in this Match.",
    }, 
	KillPoints_Included = {
        title = "Kill Point Reward System:",
        description = "Enables or Disables the Kill Point Reward System in this Match.",
    },
	Ref_Points = {
        title = "Reinforcements available in:",
        description = "Set the wait time for the Reinforcement Point Generation in Minutes.",
    },
	Tac_Points = {
        title = "Fire Support available in:",
        description = "Set the wait time for the Tactical Point Generation in Minutes.",
    },
	lob_DropInclude_1 = {
        title = "Drop Turrets and Devices:",
        description = "Set Drop Turrets and Devices to be callable by the Fire Support Manager in this Match.",
    }, 
	lob_DropInclude_2 = {
        title = "Drop Turrets and Devices:",
        description = "Set Drop Turrets and Devices to be not callable by the Fire Support Manager in this Match.",
    }, 
	lob_RefPoints_300 = {
        title = "Reinforcements available in:",
        description = "Set the Wait Time to 5 Minutes.",
    },
	lob_RefPoints_600 = {
        title = "Reinforcements available in:",
        description = "Set the Wait Time to 10 Minutes.",
    },
	lob_RefPoints_900 = {
        title = "Reinforcements available in:",
        description = "Set the Wait Time to 15 Minutes.",
    },
	lob_RefPoints_1200 = {
        title = "Reinforcements available in:",
        description = "Set the Wait Time to 20 Minutes.",
    },
	lob_RefPoints_1500 = {
        title = "Reinforcements available in:",
        description = "Set the Wait Time to 25 Minutes.",
    },
	lob_RefPoints_1800 = {
        title = "Reinforcements available in:",
        description = "Set the Wait Time to 30 Minutes.",
    },
	lob_RefPoints_2100 = {
        title = "Reinforcements available in:",
        description = "Set the Wait Time to 35 Minutes.",
    },
	lob_RefPoints_2400 = {
        title = "Reinforcements available in:",
        description = "Set the Wait Time to 40 Minutes.",
    },
	lob_RefPoints_2700 = {
        title = "Reinforcements available in:",
        description = "Set the Wait Time to 45 Minutes.",
    },
	lob_RefPoints_3000 = {
        title = "Reinforcements available in:",
        description = "Set the Wait Time to 50 Minutes.",
    },
	lob_RefPoints_3300 = {
        title = "Reinforcements available in:",
        description = "Set the Wait Time to 55 Minutes.",
    },
	lob_RefPoints_3600 = {
        title = "Reinforcements available in:",
        description = "Set the Wait Time to 60 Minutes.",
    },
	lob_TacPoints_300 = {
        title = "Fire Support available in:",
        description = "Set the Wait Time to 5 Minutes.",
    },
	lob_TacPoints_600 = {
        title = "Fire Support available in:",
        description = "Set the Wait Time to 10 Minutes.",
    },
	lob_TacPoints_900 = {
        title = "Fire Support available in:",
        description = "Set the Wait Time to 15 Minutes.",
    },
	lob_TacPoints_1200 = {
        title = "Fire Support available in:",
        description = "Set the Wait Time to 20 Minutes.",
    },
	lob_TacPoints_1500 = {
        title = "Fire Support available in:",
        description = "Set the Wait Time to 25 Minutes.",
    },
	lob_TacPoints_1800 = {
        title = "Fire Support available in:",
        description = "Set the Wait Time to 30 Minutes.",
    },
	lob_TacPoints_2100 = {
        title = "Fire Support available in:",
        description = "Set the Wait Time to 35 Minutes.",
    },
	lob_TacPoints_2400 = {
        title = "Fire Support available in:",
        description = "Set the Wait Time to 40 Minutes.",
    },
	lob_TacPoints_2700 = {
        title = "Fire Support available in:",
        description = "Set the Wait Time to 45 Minutes.",
    },
	lob_TacPoints_3000 = {
        title = "Fire Support available in:",
        description = "Set the Wait Time to 50 Minutes.",
    },
	lob_TacPoints_3300 = {
        title = "Fire Support available in:",
        description = "Set the Wait Time to 55 Minutes.",
    },
	lob_TacPoints_3600 = {
        title = "Fire Support available in:",
        description = "Set the Wait Time to 60 Minutes.",
    },
	Ref_PointsGenInt = {
        title = "Reinforcement Point Generation Interval:",
        description = "Set the Interval for the Reinforcement Point Generation in Seconds.",
    },
	Ref_PointsGenRate = {
        title = "Reinforcement Point Generation Rate:",
        description = "Set the Generation Rate of the Reinforcement Points.",
    },
	Tac_PointsGenInt = {
        title = "Tactical Point Generation Interval:",
        description = "Set the Interval for the Tactical Point Generation in Seconds.",
    },
	Tac_PointsGenRate = {
        title = "Tactical Point Generation Rate:",
        description = "Set the Generation Rate of the Tactical Points.",
    },
	lob_PointStorage_1 = {
        title = "Point Storages:",
        description = "Set the Reinforcement and Tactical Point Storages to be buildable in this Match.",
    }, 
	lob_PointStorage_2 = {
        title = "Point Storages:",
        description = "Set the Reinforcement and Tactical Point Storages to be not buildable in this Match.",
    }, 
	lob_AirStrikeMechanic_1 = {
        title = "Air Strike Mechanic:",
        description = "Let Air Strikes fly a fixed Route from Spawn Side to opposite of the Map. They will Drop their Bombs on the first enemy Units which cross thier Path.",
    },
	lob_AirStrikeMechanic_2 = {
        title = "Air Strike Mechanic:",
        description = "Let Air Strikes attack the Location of the Marker to drop their Bombs. They fly Back to their Spawn Location and disappear once they have drop their Bombs.",
    },
	lob_AirStrikesInclude_1 = {
        title = "Air Strikes:",
        description = "Set Air Strikes to be callable by the Fire Support Manager in this Match.",
    },
	lob_AirStrikesInclude_2 = {
        title = "Air Strikes:",
        description = "Set Air Strikes to be not callable by the Fire Support Manager in this Match.",
    },
	lob_EXAirStrikesInclude_1 = {
        title = "Experimental Air Strikes:",
        description = "Set Experimental Air Strikes to be callable by the Fire Support Manager in this Match.",
    },
	lob_EXAirStrikesInclude_2 = {
        title = "Experimental Air Strikes:",
        description = "Set Experimental Air Strikes to be not callable by the Fire Support Manager in this Match.",
    },
	lob_AirRefInclude_1 = {
        title = "Air Reinforcements:",
        description = "Set Air Reinforcements to be callable by the Reinforcements Manager in this Match.",
    },
	lob_AirRefInclude_2 = {
        title = "Air Reinforcements:",
        description = "Set Air Reinforcements to be not callable by the Reinforcements Manager in this Match.",
    },
	lob_LandRefInclude_1 = {
        title = "Land Reinforcements:",
        description = "Set Land Reinforcements to be callable by the Reinforcements Manager in this Match.",
    },
	lob_LandRefInclude_2 = {
        title = "Land Reinforcements:",
        description = "Set Land Reinforcements to be not callable by the Reinforcements Manager in this Match.",
    },
	lob_NavalRefInclude_1 = {
        title = "Naval Reinforcements:",
        description = "Set Naval Reinforcements to be callable by the Reinforcements Manager in this Match.",
    },
	lob_NavalRefInclude_2 = {
        title = "Naval Reinforcements:",
        description = "Set Naval Reinforcements to be not callable by the Reinforcements Manager in this Match.",
    },
	lob_EXPRef_1 = {
        title = "Experimental Reinforcements:",
        description = "Set Experimental Reinforcements to be callable by the Reinforcements Manager in this Match.",
    },
	lob_EXPRef_2 = {
        title = "Experimental Reinforcements:",
        description = "Set Experimental Reinforcements to be not callable by the Reinforcements Manager in this Match.",
    },
	lob_HQComCentersIncluded_1 = {
        title = "HQ Communication Center:",
        description = "Set the HQ Communication Center to be buildable in this Match. Access to both Managers if builded only.",
    },
	lob_HQComCentersIncluded_2 = {
        title = "HQ Communication Center:",
        description = "Set the HQ Communication Center to be not buildable in this Match. Access to both Managers is always available.",
    },
	lob_CentersIncluded_1 = {
        title = "Point Generation Centers:",
        description = "Set the Point Generation Centers to be buildable in this Match.",
    },
	lob_CentersIncluded_2 = {
        title = "Point Generation Centers:",
        description = "Set the Point Generation Centers to be not buildable in this Match.",
    },
	lob_KillPointsIncluded_1 = {
        title = "Kill Point Reward System:",
        description = "Enables the Kill Point Reward System in this Match.",
    },
	lob_KillPointsIncluded_2 = {
        title = "Kill Point Reward System:",
        description = "Disables the Kill Point Reward System in this Match.",
    },
	
	lob_RefPointsGenInt_1 = {
        title = "Reinforcement Point Generation Interval:",
        description = "Set the Interval to 1 Second.",
    },
	lob_RefPointsGenInt_2 = {
        title = "Reinforcement Point Generation Interval:",
        description = "Set the Interval to 2 Seconds.",
    },
	lob_RefPointsGenInt_3 = {
        title = "Reinforcement Point Generation Interval:",
        description = "Set the Interval to 3 Seconds.",
    },
	lob_RefPointsGenRate_0 = {
        title = "Reinforcement Point Generation Rate:",
        description = "Set the Generation Rate to 0 Point.",
    },
	lob_RefPointsGenRate_1 = {
        title = "Reinforcement Point Generation Rate:",
        description = "Set the Generation Rate to 1 Point.",
    },
	lob_RefPointsGenRate_2 = {
        title = "Reinforcement Point Generation Rate:",
        description = "Set the Generation Rate to 2 Points.",
    },
	lob_RefPointsGenRate_3 = {
        title = "Reinforcement Point Generation Rate:",
        description = "Set the Generation Rate to 3 Points.",
    },
	lob_TacPointsGenInt_1 = {
        title = "Tactical Point Generation Interval:",
        description = "Set the Interval to 1 Second.",
    },
	lob_TacPointsGenInt_2 = {
        title = "Tactical Point Generation Interval:",
        description = "Set the Interval to 2 Seconds.",
    },
	lob_TacPointsGenInt_3 = {
        title = "Tactical Point Generation Interval:",
        description = "Set the Interval to 3 Seconds.",
    },
	lob_TacPointsGenRate_0 = {
        title = "Tactical Point Generation Rate:",
        description = "Set the Generation Rate to 0 Point.",
    },
	lob_TacPointsGenRate_1 = {
        title = "Tactical Point Generation Rate:",
        description = "Set the Generation Rate to 1 Point.",
    },
	lob_TacPointsGenRate_2 = {
        title = "Tactical Point Generation Rate:",
        description = "Set the Generation Rate to 2 Points.",
    },
	lob_TacPointsGenRate_3 = {
        title = "Tactical Point Generation Rate:",
        description = "Set the Generation Rate to 3 Points.",
    },
	Ref_PointsMax = {
        title = "Maximum collectable Reinforcement Points:",
        description = "Set the Maximum of collectable Reinforcement Points.",
    },
	Tac_PointsMax = {
        title = "Maximum collectable Tactical Points:",
        description = "Set the Maximum of collectable Tactical Points.",
    },
	lob_RefPointsMax_0 = {
        title = "Maximum collectable Reinforcement Points:",
        description = "Set the Maximum to 0 collectable Points.",
    },
	lob_RefPointsMax_1000 = {
        title = "Maximum collectable Reinforcement Points:",
        description = "Set the Maximum to 1000 collectable Points.",
    },
	lob_RefPointsMax_2000 = {
        title = "Maximum collectable Reinforcement Points:",
        description = "Set the Maximum to 2000 collectable Points.",
    },
	lob_RefPointsMax_3000 = {
        title = "Maximum collectable Reinforcement Points:",
        description = "Set the Maximum to 3000 collectable Points.",
    },
	lob_RefPointsMax_4000 = {
        title = "Maximum collectable Reinforcement Points:",
        description = "Set the Maximum to 4000 collectable Points.",
    },
	lob_RefPointsMax_5000 = {
        title = "Maximum collectable Reinforcement Points:",
        description = "Set the Maximum to 5000 collectable Points.",
    },
	lob_TacPointsMax_0 = {
        title = "Maximum collectable Tactical Points:",
        description = "Set the Maximum to 0 collectable Points.",
    },
	lob_TacPointsMax_1000 = {
        title = "Maximum collectable Tactical Points:",
        description = "Set the Maximum to 1000 collectable Points.",
    },
	lob_TacPointsMax_2000 = {
        title = "Maximum collectable Tactical Points:",
        description = "Set the Maximum to 2000 collectable Points.",
    },
	lob_TacPointsMax_3000 = {
        title = "Maximum collectable Tactical Points:",
        description = "Set the Maximum to 3000 collectable Points.",
    },
	lob_TacPointsMax_4000 = {
        title = "Maximum collectable Tactical Points:",
        description = "Set the Maximum to 4000 collectable Points.",
    },
	lob_TacPointsMax_5000 = {
        title = "Maximum collectable Tactical Points:",
        description = "Set the Maximum to 5000 collectable Points.",
    },
}

DropDefOriginComboTooltips = {
        {
            text = "North",
			body = "Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Drop Defenses to the North Side of the Map.",
        },
        {
            text = "East",
			body = "Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Drop Defenses to the East Side of the Map.",
        },
        {
            text = "South",
			body = "Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Drop Defenses to the South Side of the Map.",
        },
        {
            text = "West",
			body = "Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Drop Defenses to the West Side of the Map.",
        },
        {
            text = "Random",
			body = "Let the Delivery Cargo Gunships of all callable Drop Defenses Spawn from any Side of the Map randomly.",
        },
}


AirStrikeOriginComboTooltips = {
        {
            text = "North",
			body = "Sets the Spawn Origin of all callable Air Strikes to the North Side of the Map.",
        },
        {
            text = "East",
			body = "Sets the Spawn Origin of all callable Air Strikes to the East Side of the Map.",
        },
        {
            text = "South",
			body = "Sets the Spawn Origin of callable all Air Strikes to the South Side of the Map.",
        },
        {
            text = "West",
			body = "Sets the Spawn Origin of callable all Air Strikes to the West Side of the Map.",
        },
        {
            text = "Random",
			body = "Let all callable Air Strikes Spawn from any Side of the Map randomly.",
        },
}

LandRefOriginComboTooltips = {
        {
            text = "North",
			body = "Sets the Spawn Origin for the Delivery Cargo Gunships and Cargo Planes of all callable Land Reinforcements to the North Side of the Map.",
        },
        {
            text = "East",
			body = "Sets the Spawn Origin for the Delivery Cargo Gunships and Cargo Planes of all callable Land Reinforcements to the East Side of the Map.",
        },
        {
            text = "South",
			body = "Sets the Spawn Origin for the Delivery Cargo Gunships and Cargo Planes of all callable Land Reinforcements to the South Side of the Map.",
        },
        {
            text = "West",
			body = "Sets the Spawn Origin for the Delivery Cargo Gunships and Cargo Planes of all callable Land Reinforcements to the West Side of the Map.",
        },
        {
            text = "Random",
			body = "Let all Delivery Cargo Gunships and Cargo Planes of all callable Land Reinforcements Spawn from any Side of the Map randomly.",
        },
}

AirRefOriginComboTooltips = {
        {
            text = "North",
			body = "Sets the Spawn Origin of all callable Air Reinforcements to the North Side of the Map.",
        },
        {
            text = "East",
			body = "Sets the Spawn Origin of all callable Air Reinforcements to the East Side of the Map.",
        },
        {
            text = "South",
			body = "Sets the Spawn Origin of all callable Air Reinforcements to the South Side of the Map.",
        },
        {
            text = "West",
			body = "Sets the Spawn Origin of all callable Air Reinforcements to the West Side of the Map.",
        },
        {
            text = "Random",
			body = "Let all callable Air Reinforcements Spawn from any Side of the Map randomly.",
        },
}

NavalOriginComboTooltips = {
        {
            text = "North",
			body = "Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Naval Reinforcements to the North Side of the Map.",
        },
        {
            text = "East",
			body = "Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Naval Reinforcements to the East Side of the Map.",
        },
        {
            text = "South",
			body = "Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Naval Reinforcements to the South Side of the Map.",
        },
        {
            text = "West",
			body = "Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Naval Reinforcements to the West Side of the Map.",
        },
        {
            text = "Random",
			body = "Let all Delivery Cargo Gunships of all callable Naval Reinforcements Spawn from any Side of the Map randomly.",
        },
}


TestCombo1ComboTooltips = {
	{
		text = "Callable",
		body = "Set Drop Turrets and Devices to be callable by the Fire Support Manager in this Match.",
	},
	{
		text = "Not Callable",
		body = "Set Drop Turrets and Devices to be not callable by the Fire Support Manager in this Match.",
	},			
}

TestCombo2ComboTooltips = {
	{
		text = "Callable",
		body = "Set Land Reinforcements to be callable by the Reinforcements Manager in this Match.",
	},
	{
		text = "Not Callable",
		body = "Set Land Reinforcements to be not callable by the Reinforcements Manager in this Match.",
	},			
}
TestCombo3ComboTooltips = {
	{
		text = "Callable",
		body = "Set Air Reinforcements to be callable by the Reinforcements Manager in this Match.",
	},
	{
		text = "Not Callable",
		body = "Set Air Reinforcements to be not callable by the Reinforcements Manager in this Match.",
	},			
}

TestCombo4ComboTooltips = {
	{
		text = "Callable",
		body = "Set Naval Reinforcements to be callable by the Reinforcements Manager in this Match.",
	},
	{
		text = "Not Callable",
		body = "Set Naval Reinforcements to be not callable by the Reinforcements Manager in this Match.",
	},			
}

TestCombo5ComboTooltips = {
	{
		text = "Callable",
		body = "Set Air Strikes to be callable Fire Support Manager in this Match.",
	},
	{
		text = "Not Callable",
		body = "Set Air Strikes to be not callable Fire Support Manager in this Match.",
	},			
}

TestCombo6ComboTooltips = {
	{
		text = "Fly full Route",
		body = "Let Air Strikes fly a fixed Route from Spawn Side to opposite of the Map. They will Drop their Bombs on the first enemy Units which cross thier Path.",
	},
	{
		text = "Attack Marker Location",
		body = "Let Air Strikes attack the Location of the Marker to drop their Bombs. They fly Back to their Spawn Location and disappear once they have drop their Bombs.",
	},			
}

TestCombo7ComboTooltips = {
	{
		text = "Buildable",
		body = "Set the Reinforcement and Tactical Storages to be buildable in this Match.",
	},
	{
		text = "Not buildable",
		body = "Set the Reinforcement and Tactical Storages to be not buildable in this Match.",
	},			
}

TestCombo8ComboTooltips = {
	{
		text = "Callable",
		body = "Set the Experimental Reinforcements to be callable in this Match.",
	},
	{
		text = "Not Callable",
		body = "Set the Experimental Reinforcements to be not callable in this Match.",
	},			
}

TestCombo9ComboTooltips = {
	{
		text = "Buildable",
		body = "Set the HQ Communication Center to be buildable in this Match. Access to both Managers if builded only.",
	},
	{
		text = "Not buildable",
		body = "Set the HQ Communication Center to be not buildable in this Match. Access to both Managers is always available.",
	},			
}


TestCombo10ComboTooltips = {
	{
		text = "Buildable",
		body = "Set the Point Generation Centers to be buildable in this Match.",
	},
	{
		text = "Not buildable",
		body = "Set the Point Generation Centers to be not buildable in this Match.",
	},			
}

TestCombo11ComboTooltips = {
	{
		text = "Enabled",
		body = "Enables the Kill Point Reward System in this Match.",
	},
	{
		text = "Disabled",
		body = "Disables the Kill Point Reward System in this Match.",
	},			
}

TestCombo12ComboTooltips = {
            {
                text = "5 Minutes",
                body = "Set the Wait Time to 5 Minutes",
            },
            {
                text = "10 Minutes",
                body = "Set the Wait Time to 10 Minutes",
            },
            {
                text = "15 Minutes",
                body = "Set the Wait Time to 15 Minutes",
            },
            {
                text = "20 Minutes",
                body = "Set the Wait Time to 20 Minutes",
            },
            {
                text = "25 Minutes",
                body = "Set the Wait Time to 25 Minutes",
            },
            {
                text = "30 Minutes",
                body = "Set the Wait Time to 30 Minutes",
            },
            {
                text = "35 Minutes",
                body = "Set the Wait Time to 35 Minutes",
            },
            {
                text = "40 Minutes",
                body = "Set the Wait Time to 40 Minutes",
            },
            {
                text = "45 Minutes",
                body = "Set the Wait Time to 45 Minutes",
            },
            {
                text = "50 Minutes",
                body = "Set the Wait Time to 50 Minutes",
            },
            {
                text = "55 Minutes",
                body = "Set the Wait Time to 55 Minutes",
            },
            {
                text = "60 Minutes",
                body = "Set the Wait Time to 60 Minutes",
            },			
}

TestCombo13ComboTooltips = {
	{
		text = "1 Second",
		body = "Set the Point Generation Interval to 1 Second",
	},
	{
		text = "2 Seconds",
		body = "Set the Point Generation Interval to 2 Seconds",
	},	
	{
		text = "3 Seconds",
		body = "Set the Point Generation Interval to 3 Seconds",
	},	
}

TestCombo14ComboTooltips = {
	{
		text = "Deactivated",
		body = "Set the Point Generation Rate to 0 Point",
	},
	{
		text = "1 Point",
		body = "Set the Point Generation Rate to 1 Point",
	},
	{
		text = "2 Points",
		body = "Set the Point Generation Rate to 2 Points",
	},	
	{
		text = "3 Points",
		body = "Set the Point Generation Rate to 3 Point",
	},	
}

TestCombo15ComboTooltips = {
	{
		text = "0 Points",
		body = "Set the Point Maximum to 0 Points",
	},
	{
		text = "1000 Points",
		body = "Set the Point Maximum to 1000 Points",
	},
	{
		text = "2000 Pointss",
		body = "Set the Point Maximum to 2000 Points",
	},	
	{
		text = "3000 Points",
		body = "Set the Point Maximum to 3000 Points",
	},	
	{
		text = "4000 Points",
		body = "Set the Point Maximum to 5000 Points",
	},	
	{
		text = "5000 Points",
		body = "Set the Point Maximum to 4000 Points",
	},	
}

TestCombo16ComboTooltips = {
            {
                text = "5 Minutes",
                body = "Set the Wait Time to 5 Minutes",
            },
            {
                text = "10 Minutes",
                body = "Set the Wait Time to 10 Minutes",
            },
            {
                text = "15 Minutes",
                body = "Set the Wait Time to 15 Minutes",
            },
            {
                text = "20 Minutes",
                body = "Set the Wait Time to 20 Minutes",
            },
            {
                text = "25 Minutes",
                body = "Set the Wait Time to 25 Minutes",
            },
            {
                text = "30 Minutes",
                body = "Set the Wait Time to 30 Minutes",
            },
            {
                text = "35 Minutes",
                body = "Set the Wait Time to 35 Minutes",
            },
            {
                text = "40 Minutes",
                body = "Set the Wait Time to 40 Minutes",
            },
            {
                text = "45 Minutes",
                body = "Set the Wait Time to 45 Minutes",
            },
            {
                text = "50 Minutes",
                body = "Set the Wait Time to 50 Minutes",
            },
            {
                text = "55 Minutes",
                body = "Set the Wait Time to 55 Minutes",
            },
            {
                text = "60 Minutes",
                body = "Set the Wait Time to 60 Minutes",
            },			
}

TestCombo17ComboTooltips = {
	{
		text = "1 Second",
		body = "Set the Point Generation Interval to 1 Second",
	},
	{
		text = "2 Seconds",
		body = "Set the Point Generation Interval to 2 Seconds",
	},	
	{
		text = "3 Seconds",
		body = "Set the Point Generation Interval to 3 Seconds",
	},	
}

TestCombo18ComboTooltips = {
	{
		text = "Deactivated",
		body = "Set the Point Generation Rate to 0 Point",
	},
	{
		text = "1 Point",
		body = "Set the Point Generation Rate to 1 Point",
	},
	{
		text = "2 Points",
		body = "Set the Point Generation Rate to 2 Points",
	},	
	{
		text = "3 Points",
		body = "Set the Point Generation Rate to 3 Point",
	},	
}

TestCombo19ComboTooltips = {
	{
		text = "0 Points",
		body = "Set the Point Maximum to 0 Points",
	},
	{
		text = "1000 Points",
		body = "Set the Point Maximum to 1000 Points",
	},
	{
		text = "2000 Pointss",
		body = "Set the Point Maximum to 2000 Points",
	},	
	{
		text = "3000 Points",
		body = "Set the Point Maximum to 3000 Points",
	},	
	{
		text = "4000 Points",
		body = "Set the Point Maximum to 5000 Points",
	},	
	{
		text = "5000 Points",
		body = "Set the Point Maximum to 4000 Points",
	},	
}

TestCombo20ComboTooltips = {
	{
		text = "Callable",
		body = "Set the Experimental Air Strikes to be callable in this Match.",
	},
	{
		text = "Not Callable",
		body = "Set the Experimental Air Strikes to be not callable in this Match.",
	},			
}
