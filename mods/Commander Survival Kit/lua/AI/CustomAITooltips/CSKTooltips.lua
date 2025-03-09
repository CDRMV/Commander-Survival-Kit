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
        body = "<LOC SetASOrigin>Set the Spawn Origin of all callable Air Strikes.",
   }
   DSpawmFromCombo = {
	    text = "Origin",
        body = "<LOC SetDOrigin>Set the Spawn Origin of the Delivery Units for all callable Drop Defenses.",
   }
   LandRefSpawmFromCombo = {
	    text = "Origin",
        body = "<LOC SetLRefOrigin>Set the Spawn Origin of the Delivery Units for all callable Land Reinforcements.",
   }
   AirRefSpawmFromCombo = {
	    text = "Origin",
        body = "<LOC SetARefOrigin>Set the Spawn Origin of all callable Air Reinforcements.",
   }
   NavalRefSpawmFromCombo = {
	    text = "Origin",
        body = "<LOC SetNRefOrigin>Set the Spawn Origin of the Delivery Units for all callable Naval Reinforcements.",
   }


TestCombo = {
		text = "<LOC tooltipCSKLOBDropDefTitle>Drop Turrets and Devices:",
		body = "<LOC tooltipCSKLOBDropDefDesc>Set Drop Turrets and Devices to be callable or not in this Match.",		
}

TestCombo2 = {
		text = "<LOC tooltipCSKLOBLandRefTitle>Land Reinforcements:",
		body = "<LOC tooltipCSKLOBLandRefDef>Set Land Reinforcements to be callable or not in this Match.",		
}

TestCombo3 = {
		text = "<LOC tooltipCSKLOBAirRefTitle>Air Reinforcements:",
		body = "<LOC tooltipCSKLOBAirRefDesc>Set Air Reinforcements to be callable or not in this Match.",		
}

TestCombo4 = {
		text = "<LOC tooltipCSKLOBNavalRefTitle>Naval Reinforcements:",
		body = "<LOC tooltipCSKLOBNavalRefDesc>Set Naval Reinforcements to be callable or not in this Match.",		
}

TestCombo5 = {
		text = "<LOC tooltipCSKLOBASIncTitle>Air Strikes:",
		body = "<LOC tooltipCSKLOBASIncDesc>Set Air Strikes to be callable or not in this Match.",		
}

TestCombo6 = {
		text = "<LOC tooltipCSKLOBASMechTitle>Air Strike Mechanic:",
		body = "<LOC tooltipCSKLOBASMechDesc>Set the Air Strike Mechanic to Fly full Route or Attack Marker Location.",		
}

TestCombo7 = {
		text = "<LOC tooltipCSKLOBPointStoreTitle>Point Storages:",
		body = "<LOC tooltipCSKLOBPointStoreDesc>Set the Reinforcement and Tactical Point Storages to be buildable or not in this Match.",		
}

TestCombo8 = {
		text = "<LOC tooltipCSKLOBEXRefTitle>Experimental Reinforcements:",
		body = "<LOC tooltipCSKLOBEXRefDesc>Set the Experimental Reinforcements to be callable or not in this Match.",		
}

TestCombo9 = {
		text = "<LOC tooltipCSKLOBHQCTitle>HQ Communication Center:",
		body = "<LOC tooltipCSKLOBHQCDesc>Set the HQ Communication Center to be buildable or not and the access to the two Managers in this Match.",		
}

TestCombo10 = {
		text = "<LOC tooltipCSKLOBPointGenCTitle>Point Generation Centers:",
		body = "<LOC tooltipCSKLOBPointGenCDesc>Set the Point Generation Centers to be buildable or not in this Match.",		
}

TestCombo11 = {
		text = "<LOC tooltipCSKLOBKPRSystemTitle>Kill Point Reward System:",
		body = "<LOC tooltipCSKLOBKPRSystemDesc>Enables or Disables the Kill Point Reward System in this Match.",		
}

TestCombo12 = {
		text = "<LOC tooltipCSKLOBRefTimeTitle>Reinforcements available in:",
		body = "<LOC tooltipCSKLOBRefTimeDesc>Set the wait time for the Reinforcement Point Generation in Minutes.",		
}

TestCombo13 = {
		text = "<LOC tooltipCSKLOBRefPGenInTitle>Reinforcement Point Generation Interval:",
		body = "<LOC tooltipCSKLOBRefPGenInDesc>Set the Interval for the Reinforcement Point Generation in Seconds.",		
}

TestCombo14 = {
		text = "<LOC tooltipCSKLOBRefPGenRTitle>Reinforcement Point Generation Rate:",
		body = "<LOC tooltipCSKLOBRefPGenRDesc>Set the Generation Rate of the Reinforcement Points.",		
}

TestCombo15 = {
		text = "<LOC tooltipCSKLOBMaxRefPointTitle>Maximal Reinforcement Points:",
		body = "<LOC tooltipCSKLOBMaxRefPointDesc>Set the Maximum of collectable Reinforcement Points.",		
}

TestCombo16 = {
		text = "<LOC tooltipCSKLOBTacTimeTitle>Fire Support available in:",
		body = "<LOC tooltipCSKLOBTacTimeDesc>Set the wait time for the Tactical Point Generation in Minutes.",		
}

TestCombo17 = {
		text = "<LOC tooltipCSKLOBTacPGenInTitle>Tactical Point Generation Interval:",
		body = "<LOC tooltipCSKLOBTacPGenInDesc>Set the Interval for the Tactical Point Generation in Seconds.",		
}

TestCombo18 = {
		text = "<LOC tooltipCSKLOBTacPGenRTitle>Tactical Point Generation Rate:",
		body = "<LOC tooltipCSKLOBTacPGenRDesc>Set the Generation Rate of the Tactical Points.",		
}

TestCombo19 = {
		text = "<LOC tooltipCSKLOBMaxTacPointTitle>Maximal Tactical Points:",
		body = "<LOC tooltipCSKLOBMaxTacPointDesc>Set the Maximum of collectable Tactical Points.",		
}

TestCombo20 = {
		text = "<LOC tooltipCSKLOBEXASIncTitle>Experimental Air Strikes:",
		body = "<LOC tooltipCSKLOBEXASIncDesc>Set Experimental Air Strikes to be callable or not in this Match.",		
}


Tooltips = { 
 SaveBtn = {
        title = "<LOC tooltipCSKSaveTitle>Save",
        description = "<LOC tooltipCSKSaveDesc>Save the current Configurations",
   },
   LoadBtn = {
        title = "<LOC tooltipCSKLoadTitle>Load",
        description = "<LOC tooltipCSKLoadDesc>Load the previously saved Configurations",
   },
   DoneBtn = {
        title = "<LOC tooltipCSKDoneTitle>Done",
        description = "<LOC tooltipCSKDoneDesc>Continue with the Mission and transfer all Configurations to the Code",
   }, 
   RefBtn = {
        title = "<LOC tooltipCSKRefManagerTitle>Reinforcement Manager",
        description = "<LOC tooltipCSKRefManagerDesc>Open/Hide the Layer Button Overview.",
   },
   FSBtn = {
        title = "<LOC tooltipCSKFSManagerTitle>Fire Support Manager",
        description = "<LOC tooltipCSKFSManagerDesc>Open/Hide the Fire Support Manager.",
   },
   LBtn = {
        title = "<LOC tooltipCSKLandRefManagerTitle>Land Reinforcement Manager",
        description = "<LOC tooltipCSKLandRefManagerDesc>Open/Hide the Land Reinforcement Manager.",
   },
   ABtn = {
        title = "<LOC tooltipCSKAirRefManagerTitle>Air Reinforcement Manager",
        description = "<LOC tooltipCSKAirRefManagerDesc>Open/Hide the Air Reinforcement Manager.",
   },
   NBtn = {
        title = "<LOC tooltipCSKNavalRefManagerTitle>Naval Reinforcement Manager",
        description = "<LOC tooltipCSKNavalRefManagerDesc>Open/Hide the Naval Reinforcement Manager.",
   },
   SBtn = {
        title = "<LOC tooltipCSKSpaceRefManagerTitle>Space Reinforcement Manager",
        description = "<LOC tooltipCSKSpaceRefManagerDesc>Open/Hide the Space Reinforcement Manager.",
   },
   DesNBtn = {
        title = "<LOC tooltipCSKDesNavalRefManagerTitle>Naval Reinforcement Manager (Coming soon)",
        description = "<LOC tooltipCSKDesNavalRefManagerDesc>Available in Version 2.0",
   },
   DesSBtn = {
        title = "<LOC tooltipCSKDesSpaceRefManagerTitle>Space Reinforcement Manager (Not available) ",
        description = "<LOC tooltipCSKDesSpaceRefManagerDesc>Requires the installation & activation of F.B.P. Orbital.",
   },
   TechFWBtn = {
        title = "<LOC tooltipCSKTechFWTitle>Forward",
        description = "<LOC tooltipCSKTechFWDesc>Go to the next Tech Level Section Overview.",
   },
   TechBBtn = {
        title = "<LOC tooltipCSKTechBBTitle>Back",
        description = "<LOC tooltipCSKTechBBDesc>Go to the previous Tech Level Section Overview.",
   },
   FWBtn = {
        title = "<LOC tooltipCSKFWTitle>Forward",
        description = "<LOC tooltipCSKFWDesc>Go to the next Section Overview.",
   },
   BBtn = {
        title = "<LOC tooltipCSKBBTitle>Back",
        description = "<LOC tooltipCSKBBDesc>Go to the previous Section Overview.",
   },
   ASFWtn = {
        title = "<LOC tooltipCSKASFWTitle>Forward",
        description = "<LOC tooltipCSKASFWDesc>Go to the next Air Strike Overview.",
   },
   ASBBtn = {
        title = "<LOC tooltipCSKASBBTitle>Back",
        description = "<LOC tooltipCSKASBBTitle>Go to the previous Air Strike Overview.",
   },
   ArtFWtn = {
        title = "<LOC tooltipCSKARTFWTitle>Forward",
        description = "<LOC tooltipCSKARTFWDesc>Go to the next Artillery Overview.",
   },
   ArtBBtn = {
        title = "<LOC tooltipCSKARTBBTitle>Back",
        description = "<LOC tooltipCSKARTBBDesc>Go to the previous Artillery Overview.",
   },
   MFWtn = {
        title = "<LOC tooltipCSKMFWTitle>Forward",
        description = "<LOC tooltipCSKMFWDesc>Go to the next Missile Overview.",
   },
   MBBtn = {
        title = "<LOC tooltipCSKMBBTitle>Back",
        description = "<LOC tooltipCSKMBBDesc>Go to the previous Missile Overview.",
   },
   BFWtn = {
        title = "<LOC tooltipCSKBFWTitle>Forward",
        description = "<LOC tooltipCSKBFWDesc>Go to the next Beam Overview.",
   },
   BBBtn = {
        title = "<LOC tooltipCSKBBBTitle>Back",
        description = "<LOC tooltipCSKBBBDesc>Go to the previous Beam Overview.",
   },
   SPFWtn = {
        title = "<LOC tooltipCSKSPFWTitle>Forward",
        description = "<LOC tooltipCSKSPFWDesc>Go to the next Special Overview.",
   },
   SPBBtn = {
        title = "<LOC tooltipCSKSPBBTitle>Back",
        description = "<LOC tooltipCSKSPBBDesc>Go to the previous Special Overview.",
   },
   HCBtn = {
        title = "<LOC tooltipCSKHelpTitle>Help",
        description = "<LOC tooltipCSKHelpDesc>Open/Hide the C.S.K. Helpcenter.",
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
   LTBtn = {
        title = "<LOC tooltipCSKHelpLandRefTitle>How to call Land Reinforcements?",
        description = "<LOC tooltipCSKHelpLandRefDesc>Open/Hide the Tutorial Video Window.",
   },
   ATBtn = {
        title = "<LOC tooltipCSKHelpAirRefTitle>How to call Air Reinforcements?",
        description = "<LOC tooltipCSKHelpAirRefDesc>Open/Hide the Tutorial Video Window.",
   },
   NTBtn = {
        title = "<LOC tooltipCSKHelpNavalRefTitle>How to call Naval Reinforcements?",
        description = "<LOC tooltipCSKHelpNavalRefDesc>Open/Hide the Tutorial Video Window.",
   },
   STBtn = {
        title = "<LOC tooltipCSKHelpSpaceRefTitle>How to call Space Reinforcements?",
        description = "<LOC tooltipCSKHelpSpaceRefDesc>Open/Hide the Tutorial Video Window.",
   },
   ARTTBtn = {
        title = "<LOC tooltipCSKHelpArtTitle>How to call Artillery Barrages?",
        description = "<LOC tooltipCSKHelpArtDesc>Open/Hide the Tutorial Video Window.",
   },
   ASTBtn = {
        title = "<LOC tooltipCSKHelpASTitle>How to call Air Strikes?",
        description = "<LOC tooltipCSKHelpASDesc>Open/Hide the Tutorial Video Window.",
   },
   MTBtn = {
        title = "<LOC tooltipCSKHelpMTitle>How to call Missile Barrages?",
        description = "<LOC tooltipCSKHelpMDesc>Open/Hide the Tutorial Video Window.",
   },
   BTBtn = {
        title = "<LOC tooltipCSKHelpBTitle>How to call Beam Barrages?",
        description = "<LOC tooltipCSKHelpBDesc>Open/Hide the Tutorial Video Window.",
   },
   SPTBtn = {
        title = "<LOC tooltipCSKHelpSPTitle>How to call Special Weapon Barrages?",
        description = "<LOC tooltipCSKHelpSPDesc>Open/Hide the Tutorial Video Window.",
   },
   MPBtn = {
        title = "<LOC tooltipCSKHelpPlayTitle>Play",
        description = "<LOC tooltipCSKHelpPlayDesc>Play the Tutorial Video.",
   },
   MSBtn = {
        title = "<LOC tooltipCSKHelpStopTitle>Stop",
        description = "<LOC tooltipCSKHelpStopDesc>Stop the Tutorial Video.",
   },
	TacPointStorage = {
        title = "<LOC tooltipCSKTacPointStoreTitle>Tactical Point Storage",
        description = "<LOC tooltipCSKTacPointStoreDesc>Current and Maximum Tactical Point Values",
    }, 
	RefPointStorage = {
        title = "<LOC tooltipCSKRefPointStoreTitle>Reinforcement Point Storage",
        description = "<LOC tooltipCSKRefPointStoreDesc>Current and Maximum Reinforcement Point Values",
    }, 
	TacPointIncome = {
        title = "<LOC tooltipCSKTacPointIncomeTitle>Tactical Point Income",
        description = "<LOC tooltipCSKTacPointIncomeDesc>Display of generating Tactical Points per specific amount of Seconds",
    }, 
	RefPointIncome = {
        title = "<LOC tooltipCSKRefPointIncomeTitle>Reinforcement Point Income",
        description = "<LOC tooltipCSKRefPointIncomeDesc>Display of generating Reinforcement Points per specific amount of Seconds",
    }, 
	CSKMainPanel = {
        title = "<LOC tooltipCSKSupportPanelTitle>[Hide/Show] Support Bar",
        description = "",
    }, 
	DropInclude_Info = {
        title = "<LOC tooltipCSKLOBDropDefTitle>Drop Turrets and Devices:",
        description = "<LOC tooltipCSKLOBDropDefDesc>Set Drop Turrets and Devices to be callable or not in this Match.",
    }, 
	AirStrikeMechanic = {
        title = "<LOC tooltipCSKLOBASMechTitle>Air Strike Mechanic:",
        description = "<LOC tooltipCSKLOBASMechDesc>Set the Air Strike Mechanic to Fly full Route or Attack Marker Location.",
    },
	AirStrikesInclude = {
        title = "<LOC tooltipCSKLOBASIncTitle>Air Strikes:",
        description = "<LOC tooltipCSKLOBASIncDesc>Set Air Strikes to be callable or not in this Match.",
    }, 
	EXAirStrikesInclude = {
        title = "<LOC tooltipCSKLOBEXASIncTitle>Experimental Air Strikes:",
        description = "<LOC tooltipCSKLOBEXASIncDesc>Set Experimental Air Strikes to be callable or not in this Match.",
    }, 
	PointStorage_Info = {
        title = "<LOC tooltipCSKLOBPointStoreTitle>Point Storages:",
        description = "<LOC tooltipCSKLOBPointStoreDesc>Set the Reinforcement and Tactical Point Storages to be buildable or not in this Match.",
    }, 
	AirRefInclude_Info = {
        title = "<LOC tooltipCSKLOBAirRefTitle>Air Reinforcements:",
        description = "<LOC tooltipCSKLOBAirRefDesc>Set the Air Reinforcements to be callable or not in this Match.",
    }, 
	LandRefInclude_Info = {
        title = "<LOC tooltipCSKLOBLandRefTitle>Land Reinforcements:",
        description = "<LOC tooltipCSKLOBLandRefDef>Set the Land Reinforcements to be callable or not in this Match.",
    },
	NavalRefInclude_Info = {
        title = "<LOC tooltipCSKLOBNavalRefTitle>Naval Reinforcements:",
        description = "<LOC tooltipCSKLOBNavalRefDesc>Set the Naval Reinforcements to be callable or not in this Match.",
    }, 	
	EXPRef_Info = {
        title = "<LOC tooltipCSKLOBEXRefTitle>Experimental Reinforcements:",
        description = "<LOC tooltipCSKLOBEXRefDesc>Set the Experimental Reinforcements to be callable or not in this Match.",
    }, 
	HQComCenters_Included = {
        title = "<LOC tooltipCSKLOBHQCTitle>HQ Communication Center:",
        description = "<LOC tooltipCSKLOBHQCDesc>Set the HQ Communication Center to be buildable or not and the access to the two Managers in this Match.",
    },   
	Centers_Included = {
        title = "<LOC tooltipCSKLOBPointGenCTitle>Point Generation Centers:",
        description = "<LOC tooltipCSKLOBPointGenCDesc>Set the Point Generation Centers to be buildable or not in this Match.",
    }, 
	KillPoints_Included = {
        title = "<LOC tooltipCSKLOBKPRSystemTitle>Kill Point Reward System:",
        description = "<LOC tooltipCSKLOBKPRSystemDesc>Enables or Disables the Kill Point Reward System in this Match.",
    },
	Ref_Points = {
        title = "<LOC tooltipCSKLOBRefTimeTitle>Reinforcements available in:",
        description = "<LOC tooltipCSKLOBRefTimeDesc>Set the wait time for the Reinforcement Point Generation in Minutes.",
    },
	Tac_Points = {
        title = "<LOC tooltipCSKLOBTacTimeTitle>Fire Support available in:",
        description = "<LOC tooltipCSKLOBTacTimeDesc>Set the wait time for the Tactical Point Generation in Minutes.",
    },
	lob_DropInclude_1 = {
        title = "<LOC tooltipCSKLOBDropDefYTitle>Drop Turrets and Devices:",
        description = "<LOC tooltipCSKLOBDropDefYDesc>Set Drop Turrets and Devices to be callable by the Fire Support Manager in this Match.",
    }, 
	lob_DropInclude_2 = {
        title = "<LOC tooltipCSKLOBDropDefNTitle>Drop Turrets and Devices:",
        description = "<LOC tooltipCSKLOBDropDefNDesc>Set Drop Turrets and Devices to be not callable by the Fire Support Manager in this Match.",
    }, 
	lob_RefPoints_300 = {
        title = "<LOC tooltipCSKLOBRefPGen5Title>Reinforcements available in:",
        description = "<LOC tooltipCSKLOBRefPGen5Desc>Set the Wait Time to 5 Minutes.",
    },
	lob_RefPoints_600 = {
        title = "<LOC tooltipCSKLOBRefPGen10Title>Reinforcements available in:",
        description = "<LOC tooltipCSKLOBRefPGen10Desc>Set the Wait Time to 10 Minutes.",
    },
	lob_RefPoints_900 = {
        title = "<LOC tooltipCSKLOBRefPGen15Title>Reinforcements available in:",
        description = "<LOC tooltipCSKLOBRefPGen15Desc>Set the Wait Time to 15 Minutes.",
    },
	lob_RefPoints_1200 = {
        title = "<LOC tooltipCSKLOBRefPGen20Title>Reinforcements available in:",
        description = "<LOC tooltipCSKLOBRefPGen20Desc>Set the Wait Time to 20 Minutes.",
    },
	lob_RefPoints_1500 = {
        title = "<LOC tooltipCSKLOBRefPGen25Title>Reinforcements available in:",
        description = "<LOC tooltipCSKLOBRefPGen25Desc>Set the Wait Time to 25 Minutes.",
    },
	lob_RefPoints_1800 = {
        title = "<LOC tooltipCSKLOBRefPGen30Title>Reinforcements available in:",
        description = "<LOC tooltipCSKLOBRefPGen30Desc>Set the Wait Time to 30 Minutes.",
    },
	lob_RefPoints_2100 = {
        title = "<LOC tooltipCSKLOBRefPGen35Title>Reinforcements available in:",
        description = "<LOC tooltipCSKLOBRefPGen35Desc>Set the Wait Time to 35 Minutes.",
    },
	lob_RefPoints_2400 = {
        title = "<LOC tooltipCSKLOBRefPGen40Title>Reinforcements available in:",
        description = "<LOC tooltipCSKLOBRefPGen45Desc>Set the Wait Time to 40 Minutes.",
    },
	lob_RefPoints_2700 = {
        title = "<LOC tooltipCSKLOBRefPGen45Title>Reinforcements available in:",
        description = "<LOC tooltipCSKLOBRefPGen45Desc>Set the Wait Time to 45 Minutes.",
    },
	lob_RefPoints_3000 = {
        title = "<LOC tooltipCSKLOBRefPGen50Title>Reinforcements available in:",
        description = "<LOC tooltipCSKLOBRefPGen50Desc>Set the Wait Time to 50 Minutes.",
    },
	lob_RefPoints_3300 = {
        title = "<LOC tooltipCSKLOBRefPGen55Title>Reinforcements available in:",
        description = "<LOC tooltipCSKLOBRefPGen55Desc>Set the Wait Time to 55 Minutes.",
    },
	lob_RefPoints_3600 = {
        title = "<LOC tooltipCSKLOBRefPGen60Title>Reinforcements available in:",
        description = "<LOC tooltipCSKLOBRefPGen60Desc>Set the Wait Time to 60 Minutes.",
    },
	lob_TacPoints_300 = {
        title = "<LOC tooltipCSKLOBFSPGen5Title>Fire Support available in:",
        description = "<LOC tooltipCSKLOBFSPGen5Desc>Set the Wait Time to 5 Minutes.",
    },
	lob_TacPoints_600 = {
        title = "<LOC tooltipCSKLOBFSPGen10Title>Fire Support available in:",
        description = "<LOC tooltipCSKLOBFSPGen10Desc>Set the Wait Time to 10 Minutes.",
    },
	lob_TacPoints_900 = {
        title = "<LOC tooltipCSKLOBFSPGen15Title>Fire Support available in:",
        description = "<LOC tooltipCSKLOBFSPGen15Desc>Set the Wait Time to 15 Minutes.",
    },
	lob_TacPoints_1200 = {
        title = "<LOC tooltipCSKLOBFSPGen20Title>Fire Support available in:",
        description = "<LOC tooltipCSKLOBFSPGen20Desc>Set the Wait Time to 20 Minutes.",
    },
	lob_TacPoints_1500 = {
        title = "<LOC tooltipCSKLOBFSPGen25Title>Fire Support available in:",
        description = "<LOC tooltipCSKLOBFSPGen25Desc>Set the Wait Time to 25 Minutes.",
    },
	lob_TacPoints_1800 = {
        title = "<LOC tooltipCSKLOBFSPGen30Title>Fire Support available in:",
        description = "<LOC tooltipCSKLOBFSPGen30Desc>Set the Wait Time to 30 Minutes.",
    },
	lob_TacPoints_2100 = {
        title = "<LOC tooltipCSKLOBFSPGen35Title>Fire Support available in:",
        description = "<LOC tooltipCSKLOBFSPGen35Desc>Set the Wait Time to 35 Minutes.",
    },
	lob_TacPoints_2400 = {
        title = "<LOC tooltipCSKLOBFSPGen40Title>Fire Support available in:",
        description = "<LOC tooltipCSKLOBFSPGen40Desc>Set the Wait Time to 40 Minutes.",
    },
	lob_TacPoints_2700 = {
        title = "<LOC tooltipCSKLOBFSPGen45Title>Fire Support available in:",
        description = "<LOC tooltipCSKLOBFSPGen45Desc>Set the Wait Time to 45 Minutes.",
    },
	lob_TacPoints_3000 = {
        title = "<LOC tooltipCSKLOBFSPGen50Title>Fire Support available in:",
        description = "<LOC tooltipCSKLOBFSPGen50Desc>Set the Wait Time to 50 Minutes.",
    },
	lob_TacPoints_3300 = {
        title = "<LOC tooltipCSKLOBFSPGen55Title>Fire Support available in:",
        description = "<LOC tooltipCSKLOBFSPGen55Desc>Set the Wait Time to 55 Minutes.",
    },
	lob_TacPoints_3600 = {
        title = "<LOC tooltipCSKLOBFSPGen60Title>Fire Support available in:",
        description = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 60 Minutes.",
    },
	Ref_PointsGenInt = {
        title = "<LOC tooltipCSKLOBRefPGenInTitle>Reinforcement Point Generation Interval:",
        description = "<LOC tooltipCSKLOBRefPGenInDesc>Set the Interval for the Reinforcement Point Generation in Seconds.",
    },
	Ref_PointsGenRate = {
        title = "<LOC tooltipCSKLOBRefPGenRTitle>Reinforcement Point Generation Rate:",
        description = "<LOC tooltipCSKLOBRefPGenRDesc>Set the Generation Rate of the Reinforcement Points.",
    },
	Tac_PointsGenInt = {
        title = "<LOC tooltipCSKLOBTacPGenInTitle>Tactical Point Generation Interval:",
        description = "<LOC tooltipCSKLOBTacPGenInDesc>Set the Interval for the Tactical Point Generation in Seconds.",
    },
	Tac_PointsGenRate = {
        title = "<LOC tooltipCSKLOBTacPGenRTitle>Tactical Point Generation Rate:",
        description = "<LOC tooltipCSKLOBTacPGenRDesc>Set the Generation Rate of the Tactical Points.",
    },
	lob_PointStorage_1 = {
        title = "<LOC tooltipCSKLOBPointStoreYTitle>Point Storages:",
        description = "<LOC tooltipCSKLOBPointStoreYDesc>Set the Reinforcement and Tactical Point Storages to be buildable in this Match.",
    }, 
	lob_PointStorage_2 = {
        title = "<LOC tooltipCSKLOBPointStoreNTitle>Point Storages:",
        description = "<LOC tooltipCSKLOBPointStoreNDesc>Set the Reinforcement and Tactical Point Storages to be not buildable in this Match.",
    }, 
	lob_AirStrikeMechanic_1 = {
        title = "<LOC tooltipCSKLOBASMechRouteTitle>Air Strike Mechanic:",
        description = "<LOC tooltipCSKLOBASMechRouteDesc>Let Air Strikes fly a fixed Route from Spawn Side to opposite of the Map. They will Drop their Bombs on the first enemy Units which cross thier Path.",
    },
	lob_AirStrikeMechanic_2 = {
        title = "<LOC tooltipCSKLOBASMechMAttackTitle>Air Strike Mechanic:",
        description = "<LOC tooltipCSKLOBASMechMAttackDesc>Let Air Strikes attack the Location of the Marker to drop their Bombs. They fly Back to their Spawn Location and disappear once they have drop their Bombs.",
    },
	lob_AirStrikesInclude_1 = {
        title = "<LOC tooltipCSKLOBASYTitle>Air Strikes:",
        description = "<LOC tooltipCSKLOBASYDesc>Set Air Strikes to be callable by the Fire Support Manager in this Match.",
    },
	lob_AirStrikesInclude_2 = {
        title = "<LOC tooltipCSKLOBASNTitle>Air Strikes:",
        description = "<LOC tooltipCSKLOBASNDesc>Set Air Strikes to be not callable by the Fire Support Manager in this Match.",
    },
	lob_EXAirStrikesInclude_1 = {
        title = "<LOC tooltipCSKLOBEXASYTitle>Experimental Air Strikes:",
        description = "<LOC tooltipCSKLOBEXASYDesc>Set Experimental Air Strikes to be callable by the Fire Support Manager in this Match.",
    },
	lob_EXAirStrikesInclude_2 = {
        title = "<LOC tooltipCSKLOBEXASNTitle>Experimental Air Strikes:",
        description = "<LOC tooltipCSKLOBEXASNDesc>Set Experimental Air Strikes to be not callable by the Fire Support Manager in this Match.",
    },
	lob_AirRefInclude_1 = {
        title = "<LOC tooltipCSKLOBARefYTitle>Air Reinforcements:",
        description = "<LOC tooltipCSKLOBARefYDesc>Set Air Reinforcements to be callable by the Reinforcements Manager in this Match.",
    },
	lob_AirRefInclude_2 = {
        title = "<LOC tooltipCSKLOBARefNTitle>Air Reinforcements:",
        description = "<LOC tooltipCSKLOBARefNDesc>Set Air Reinforcements to be not callable by the Reinforcements Manager in this Match.",
    },
	lob_LandRefInclude_1 = {
        title = "<LOC tooltipCSKLOBLRefYTitle>Land Reinforcements:",
        description = "<LOC tooltipCSKLOBLRefYDesc>Set Land Reinforcements to be callable by the Reinforcements Manager in this Match.",
    },
	lob_LandRefInclude_2 = {
        title = "<LOC tooltipCSKLOBLRefNTitle>Land Reinforcements:",
        description = "<LOC tooltipCSKLOBLRefNDesc>Set Land Reinforcements to be not callable by the Reinforcements Manager in this Match.",
    },
	lob_NavalRefInclude_1 = {
        title = "<LOC tooltipCSKLOBNRefYTitle>Naval Reinforcements:",
        description = "<LOC tooltipCSKLOBNRefYDesc>Set Naval Reinforcements to be callable by the Reinforcements Manager in this Match.",
    },
	lob_NavalRefInclude_2 = {
        title = "<LOC tooltipCSKLOBNRefNTitle>Naval Reinforcements:",
        description = "<LOC tooltipCSKLOBNRefNDesc>Set Naval Reinforcements to be not callable by the Reinforcements Manager in this Match.",
    },
	lob_EXPRef_1 = {
        title = "<LOC tooltipCSKLOBEXRefYTitle>Experimental Reinforcements:",
        description = "<LOC tooltipCSKLOBEXRefYDesc>Set Experimental Reinforcements to be callable by the Reinforcements Manager in this Match.",
    },
	lob_EXPRef_2 = {
        title = "<LOC tooltipCSKLOBEXRefNTitle>Experimental Reinforcements:",
        description = "<LOC tooltipCSKLOBEXRefNDesc>Set Experimental Reinforcements to be not callable by the Reinforcements Manager in this Match.",
    },
	lob_HQComCentersIncluded_1 = {
        title = "<LOC tooltipCSKLOBHQCYTitle>HQ Communication Center:",
        description = "<LOC tooltipCSKLOBHQCYDesc>Set the HQ Communication Center to be buildable in this Match. Access to both Managers if builded only.",
    },
	lob_HQComCentersIncluded_2 = {
        title = "<LOC tooltipCSKLOBHQCNTitle>HQ Communication Center:",
        description = "<LOC tooltipCSKLOBHQCNDesc>Set the HQ Communication Center to be not buildable in this Match. Access to both Managers is always available.",
    },
	lob_CentersIncluded_1 = {
        title = "<LOC tooltipCSKLOBPointGenCYTitle>Point Generation Centers:",
        description = "<LOC tooltipCSKLOBPointGenCYDesc>Set the Point Generation Centers to be buildable in this Match.",
    },
	lob_CentersIncluded_2 = {
        title = "<LOC tooltipCSKLOBPointGenCNTitle>Point Generation Centers:",
        description = "<LOC tooltipCSKLOBPointGenCNDesc>Set the Point Generation Centers to be not buildable in this Match.",
    },
	lob_KillPointsIncluded_1 = {
        title = "<LOC tooltipCSKLOBKPRSystemYTitle>Kill Point Reward System:",
        description = "<LOC tooltipCSKLOBKPRSystemYDesc>Enables the Kill Point Reward System in this Match.",
    },
	lob_KillPointsIncluded_2 = {
        title = "<LOC tooltipCSKLOBKPRSystemNTitle>Kill Point Reward System:",
        description = "<LOC tooltipCSKLOBKPRSystemNDesc>Disables the Kill Point Reward System in this Match.",
    },
	
	lob_RefPointsGenInt_1 = {
        title = "<LOC tooltipCSKLOBREFPointGenInt1Title>Reinforcement Point Generation Interval:",
        description = "<LOC tooltipCSKLOBREFPointGenInt1Desc>Set the Interval to 1 Second.",
    },
	lob_RefPointsGenInt_2 = {
        title = "<LOC tooltipCSKLOBREFPointGenInt2Title>Reinforcement Point Generation Interval:",
        description = "<LOC tooltipCSKLOBREFPointGenInt2Desc>Set the Interval to 2 Seconds.",
    },
	lob_RefPointsGenInt_3 = {
        title = "<LOC tooltipCSKLOBREFPointGenInt3Title>Reinforcement Point Generation Interval:",
        description = "<LOC tooltipCSKLOBREFPointGenInt3Desc>Set the Interval to 3 Seconds.",
    },
	lob_RefPointsGenRate_0 = {
        title = "<LOC tooltipCSKLOBREFPointGenR0Title>Reinforcement Point Generation Rate:",
        description = "<LOC tooltipCSKLOBREFPointGenR0Desc>Set the Generation Rate to 0 Point.",
    },
	lob_RefPointsGenRate_1 = {
        title = "<LOC tooltipCSKLOBREFPointGenR1Title>Reinforcement Point Generation Rate:",
        description = "<LOC tooltipCSKLOBREFPointGenR1Desc>Set the Generation Rate to 1 Point.",
    },
	lob_RefPointsGenRate_2 = {
        title = "<LOC tooltipCSKLOBREFPointGenR2Title>Reinforcement Point Generation Rate:",
        description = "<LOC tooltipCSKLOBREFPointGenR2Desc>Set the Generation Rate to 2 Points.",
    },
	lob_RefPointsGenRate_3 = {
        title = "<LOC tooltipCSKLOBREFPointGenR3Title>Reinforcement Point Generation Rate:",
        description = "<LOC tooltipCSKLOBREFPointGenR3Desc>Set the Generation Rate to 3 Points.",
    },
	lob_TacPointsGenInt_1 = {
        title = "<LOC tooltipCSKLOBTacPointGenInt1Title>Tactical Point Generation Interval:",
        description = "<LOC tooltipCSKLOBTacPointGenInt1Desc>Set the Interval to 1 Second.",
    },
	lob_TacPointsGenInt_2 = {
        title = "<LOC tooltipCSKLOBTacPointGenInt2Title>Tactical Point Generation Interval:",
        description = "<LOC tooltipCSKLOBTacPointGenInt2Desc>Set the Interval to 2 Seconds.",
    },
	lob_TacPointsGenInt_3 = {
        title = "<LOC tooltipCSKLOBTacPointGenInt3Title>Tactical Point Generation Interval:",
        description = "<LOC tooltipCSKLOBTacPointGenInt3Desc>Set the Interval to 3 Seconds.",
    },
	lob_TacPointsGenRate_0 = {
        title = "<LOC tooltipCSKLOBTacPointGenR0Title>Tactical Point Generation Rate:",
        description = "<LOC tooltipCSKLOBTacPointGenR0Desc>Set the Generation Rate to 0 Point.",
    },
	lob_TacPointsGenRate_1 = {
        title = "<LOC tooltipCSKLOBTacPointGenR1Title>Tactical Point Generation Rate:",
        description = "<LOC tooltipCSKLOBTacPointGenR1Desc>Set the Generation Rate to 1 Point.",
    },
	lob_TacPointsGenRate_2 = {
        title = "<LOC tooltipCSKLOBTacPointGenR2Title>Tactical Point Generation Rate:",
        description = "<LOC tooltipCSKLOBTacPointGenR2Desc>Set the Generation Rate to 2 Points.",
    },
	lob_TacPointsGenRate_3 = {
        title = "<LOC tooltipCSKLOBTacPointGenR3Title>Tactical Point Generation Rate:",
        description = "<LOC tooltipCSKLOBTacPointGenR3Desc>Set the Generation Rate to 3 Points.",
    },
	Ref_PointsMax = {
        title = "<LOC tooltipCSKLOBMaxRefPointTitle>Maximum collectable Reinforcement Points:",
        description = "<LOC tooltipCSKLOBMaxRefPointDesc>Set the Maximum of collectable Reinforcement Points.",
    },
	Tac_PointsMax = {
        title = "<LOC tooltipCSKLOBMaxTacPointTitle>Maximum collectable Tactical Points:",
        description = "<LOC tooltipCSKLOBMaxTacPointDesc>Set the Maximum of collectable Tactical Points.",
    },
	lob_RefPointsMax_0 = {
        title = "<LOC tooltipCSKLOBMaxRefPoint0Title>Maximum collectable Reinforcement Points:",
        description = "<LOC tooltipCSKLOBMaxRefPoint0Desc>Set the Maximum to 0 collectable Points.",
    },
	lob_RefPointsMax_1000 = {
        title = "<LOC tooltipCSKLOBMaxRefPoint1000Title>Maximum collectable Reinforcement Points:",
        description = "<LOC tooltipCSKLOBMaxRefPoint1000Desc>Set the Maximum to 1000 collectable Points.",
    },
	lob_RefPointsMax_2000 = {
        title = "<LOC tooltipCSKLOBMaxRefPoint2000Title>Maximum collectable Reinforcement Points:",
        description = "<LOC tooltipCSKLOBMaxRefPoint2000Desc>Set the Maximum to 2000 collectable Points.",
    },
	lob_RefPointsMax_3000 = {
        title = "<LOC tooltipCSKLOBMaxRefPoint3000Title>Maximum collectable Reinforcement Points:",
        description = "<LOC tooltipCSKLOBMaxRefPoint3000Desc>Set the Maximum to 3000 collectable Points.",
    },
	lob_RefPointsMax_4000 = {
        title = "<LOC tooltipCSKLOBMaxRefPoint4000Title>Maximum collectable Reinforcement Points:",
        description = "<LOC tooltipCSKLOBMaxRefPoint4000Desc>Set the Maximum to 4000 collectable Points.",
    },
	lob_RefPointsMax_5000 = {
        title = "<LOC tooltipCSKLOBMaxRefPoint5000Title>Maximum collectable Reinforcement Points:",
        description = "<LOC tooltipCSKLOBMaxRefPoint5000Desc>Set the Maximum to 5000 collectable Points.",
    },
	lob_TacPointsMax_0 = {
        title = "<LOC tooltipCSKLOBMaxTacPoint0Title>Maximum collectable Tactical Points:",
        description = "<LOC tooltipCSKLOBMaxTacPoint0Desc>Set the Maximum to 0 collectable Points.",
    },
	lob_TacPointsMax_1000 = {
        title = "<LOC tooltipCSKLOBMaxTacPoint1000Title>Maximum collectable Tactical Points:",
        description = "<LOC tooltipCSKLOBMaxTacPoint1000Desc>Set the Maximum to 1000 collectable Points.",
    },
	lob_TacPointsMax_2000 = {
        title = "<LOC tooltipCSKLOBMaxTacPoint2000Title>Maximum collectable Tactical Points:",
        description = "<LOC tooltipCSKLOBMaxTacPoint2000Desc>Set the Maximum to 2000 collectable Points.",
    },
	lob_TacPointsMax_3000 = {
        title = "<LOC tooltipCSKLOBMaxTacPoint3000Title>Maximum collectable Tactical Points:",
        description = "<LOC tooltipCSKLOBMaxTacPoint3000Desc>Set the Maximum to 3000 collectable Points.",
    },
	lob_TacPointsMax_4000 = {
        title = "<LOC tooltipCSKLOBMaxTacPoint4000Title>Maximum collectable Tactical Points:",
        description = "<LOC tooltipCSKLOBMaxTacPoint4000Desc>Set the Maximum to 4000 collectable Points.",
    },
	lob_TacPointsMax_5000 = {
        title = "<LOC tooltipCSKLOBMaxTacPoint5000Title>Maximum collectable Tactical Points:",
        description = "<LOC tooltipCSKLOBMaxTacPoint5000Desc>Set the Maximum to 5000 collectable Points.",
    },
}

DropDefOriginComboTooltips = {
        {
            text = "<LOC North>North",
			body = "<LOC DDNorthDesc>Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Drop Defenses to the North Side of the Map.",
        },
        {
            text = "<LOC East>East",
			body = "<LOC DDEastDesc>Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Drop Defenses to the East Side of the Map.",
        },
        {
            text = "<LOC South>South",
			body = "<LOC DDSouthDesc>Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Drop Defenses to the South Side of the Map.",
        },
        {
            text = "<LOC West>West",
			body = "<LOC DDWestDesc>Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Drop Defenses to the West Side of the Map.",
        },
        {
            text = "<LOC Random>Random",
			body = "<LOC DDRandomDesc>Let the Delivery Cargo Gunships of all callable Drop Defenses Spawn from any Side of the Map randomly.",
        },
}


AirStrikeOriginComboTooltips = {
        {
            text = "<LOC North>North",
			body = "<LOC ASNorthDesc>Sets the Spawn Origin of all callable Air Strikes to the North Side of the Map.",
        },
        {
            text = "<LOC East>East",
			body = "<LOC ASEastDesc>Sets the Spawn Origin of all callable Air Strikes to the East Side of the Map.",
        },
        {
            text = "<LOC South>South",
			body = "<LOC ASSouthDesc>Sets the Spawn Origin of callable all Air Strikes to the South Side of the Map.",
        },
        {
            text = "<LOC West>West",
			body = "<LOC ASWestDesc>Sets the Spawn Origin of callable all Air Strikes to the West Side of the Map.",
        },
        {
            text = "<LOC Random>Random",
			body = "<LOC ASRandomDesc>Let all callable Air Strikes Spawn from any Side of the Map randomly.",
        },
}

LandRefOriginComboTooltips = {
        {
            text = "<LOC North>North",
			body = "<LOC LRefNorthDesc>Sets the Spawn Origin for the Delivery Cargo Gunships and Cargo Planes of all callable Land Reinforcements to the North Side of the Map.",
        },
        {
            text = "<LOC East>East",
			body = "<LOC LRefEastDesc>Sets the Spawn Origin for the Delivery Cargo Gunships and Cargo Planes of all callable Land Reinforcements to the East Side of the Map.",
        },
        {
            text = "<LOC South>South",
			body = "<LOC LRefSouthDesc>Sets the Spawn Origin for the Delivery Cargo Gunships and Cargo Planes of all callable Land Reinforcements to the South Side of the Map.",
        },
        {
            text = "<LOC West>West",
			body = "<LOC LRefWestDesc>Sets the Spawn Origin for the Delivery Cargo Gunships and Cargo Planes of all callable Land Reinforcements to the West Side of the Map.",
        },
        {
            text = "<LOC Random>Random",
			body = "<LOC LRefRandomDesc>Let all Delivery Cargo Gunships and Cargo Planes of all callable Land Reinforcements Spawn from any Side of the Map randomly.",
        },
}

AirRefOriginComboTooltips = {
        {
            text = "<LOC North>North",
			body = "<LOC ARefNorthDesc>Sets the Spawn Origin of all callable Air Reinforcements to the North Side of the Map.",
        },
        {
            text = "<LOC East>East",
			body = "<LOC ARefEastDesc>Sets the Spawn Origin of all callable Air Reinforcements to the East Side of the Map.",
        },
        {
            text = "<LOC South>South",
			body = "<LOC ARefSouthDesc>Sets the Spawn Origin of all callable Air Reinforcements to the South Side of the Map.",
        },
        {
            text = "<LOC West>West",
			body = "<LOC ARefWestDesc>Sets the Spawn Origin of all callable Air Reinforcements to the West Side of the Map.",
        },
        {
            text = "<LOC Random>Random",
			body = "<LOC ARefRandomDesc>Let all callable Air Reinforcements Spawn from any Side of the Map randomly.",
        },
}

NavalOriginComboTooltips = {
        {
            text = "<LOC North>North",
			body = "<LOC NRefNorthDesc>Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Naval Reinforcements to the North Side of the Map.",
        },
        {
            text = "<LOC East>East",
			body = "<LOC NRefEastDesc>Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Naval Reinforcements to the East Side of the Map.",
        },
        {
            text = "<LOC South>South",
			body = "<LOC NRefSouthDesc>Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Naval Reinforcements to the South Side of the Map.",
        },
        {
            text = "<LOC West>West",
			body = "<LOC NRefWestDesc>Sets the Spawn Origin for the Delivery Cargo Gunships of all callable Naval Reinforcements to the West Side of the Map.",
        },
        {
            text = "<LOC Random>Random",
			body = "<LOC NRefRandomDesc>Let all Delivery Cargo Gunships of all callable Naval Reinforcements Spawn from any Side of the Map randomly.",
        },
}


TestCombo1ComboTooltips = {
	{
		text = "<LOC Callable>Callable",
		body = "<LOC tooltipCSKLOBDropDefYDesc>Set Drop Turrets and Devices to be callable by the Fire Support Manager in this Match.",
	},
	{
		text = "<LOC NotCallable>Not Callable",
		body = "<LOC tooltipCSKLOBDropDefNDesc>Set Drop Turrets and Devices to be not callable by the Fire Support Manager in this Match.",
	},			
}

TestCombo2ComboTooltips = {
	{
		text = "<LOC Callable>Callable",
		body = "<LOC tooltipCSKLOBLRefYDesc>Set Land Reinforcements to be callable by the Reinforcements Manager in this Match.",
	},
	{
		text = "<LOC NotCallable>Not Callable",
		body = "<LOC tooltipCSKLOBLRefNDesc>Set Land Reinforcements to be not callable by the Reinforcements Manager in this Match.",
	},			
}
TestCombo3ComboTooltips = {
	{
		text = "<LOC Callable>Callable",
		body = "<LOC tooltipCSKLOBARefYDesc>Set Air Reinforcements to be callable by the Reinforcements Manager in this Match.",
	},
	{
		text = "<LOC NotCallable>Not Callable",
		body = "<LOC tooltipCSKLOBARefNDesc>Set Air Reinforcements to be not callable by the Reinforcements Manager in this Match.",
	},			
}

TestCombo4ComboTooltips = {
	{
		text = "<LOC Callable>Callable",
		body = "<LOC tooltipCSKLOBNRefYDesc>Set Naval Reinforcements to be callable by the Reinforcements Manager in this Match.",
	},
	{
		text = "<LOC NotCallable>Not Callable",
		body = "<LOC tooltipCSKLOBNRefNDesc>Set Naval Reinforcements to be not callable by the Reinforcements Manager in this Match.",
	},			
}

TestCombo5ComboTooltips = {
	{
		text = "<LOC Callable>Callable",
		body = "<LOC tooltipCSKLOBASYDesc>Set Air Strikes to be callable Fire Support Manager in this Match.",
	},
	{
		text = "<LOC NotCallable>Not Callable",
		body = "<LOC tooltipCSKLOBASNDesc>Set Air Strikes to be not callable Fire Support Manager in this Match.",
	},			
}

TestCombo6ComboTooltips = {
	{
		text = "<LOC tooltipCSKLOBASMechRouteTitle>Fly full Route",
		body = "<LOC tooltipCSKLOBASMechRouteDesc>Let Air Strikes fly a fixed Route from Spawn Side to opposite of the Map. They will Drop their Bombs on the first enemy Units which cross thier Path.",
	},
	{
		text = "<LOC tooltipCSKLOBASMechMAttackTitle>Attack Marker Location",
		body = "<LOC tooltipCSKLOBASMechMAttackDesc>Let Air Strikes attack the Location of the Marker to drop their Bombs. They fly Back to their Spawn Location and disappear once they have drop their Bombs.",
	},			
}

TestCombo7ComboTooltips = {
	{
		text = "<LOC Buildable>Buildable",
		body = "<LOC tooltipCSKLOBPointStoreYDesc>Set the Reinforcement and Tactical Point Storages to be buildable in this Match.",
	},
	{
		text = "<LOC NotBuildable>Not buildable",
		body = "<LOC tooltipCSKLOBPointStoreNDesc>Set the Reinforcement and Tactical Point Storages to be not buildable in this Match.",
	},			
}

TestCombo8ComboTooltips = {
	{
		text = "<LOC Callable>Callable",
		body = "<LOC tooltipCSKLOBEXRefYDesc>Set the Experimental Reinforcements to be callable in this Match.",
	},
	{
		text = "<LOC NotCallable>Not Callable",
		body = "<LOC tooltipCSKLOBEXRefNDesc>Set the Experimental Reinforcements to be not callable in this Match.",
	},			
}

TestCombo9ComboTooltips = {
	{
		text = "<LOC Buildable>",
		body = "<LOC tooltipCSKLOBHQCYDesc>Set the HQ Communication Center to be buildable in this Match. Access to both Managers if builded only.",
	},
	{
		text = "<LOC NotBuildable>Not buildable",
		body = "<LOC tooltipCSKLOBHQCNDesc>Set the HQ Communication Center to be not buildable in this Match. Access to both Managers is always available.",
	},			
}


TestCombo10ComboTooltips = {
	{
		text = "<LOC Buildable>",
		body = "<LOC tooltipCSKLOBPointGenCYDesc>Set the Point Generation Centers to be buildable in this Match.",
	},
	{
		text = "<LOC NotBuildable>Not buildable",
		body = "<LOC tooltipCSKLOBPointGenCNDesc>Set the Point Generation Centers to be not buildable in this Match.",
	},			
}

TestCombo11ComboTooltips = {
	{
		text = "<LOC Enabled>Enabled",
		body = "<LOC tooltipCSKLOBKPRSystemYDesc>Enables the Kill Point Reward System in this Match.",
	},
	{
		text = "<LOC Disabled>Disabled",
		body = "<LOC tooltipCSKLOBKPRSystemNDesc>Disables the Kill Point Reward System in this Match.",
	},			
}

TestCombo12ComboTooltips = {
            {
                text = "<LOC Min5>5 Minutes",
                body = "<LOC tooltipCSKLOBRefPGen5Desc>Set the Wait Time to 5 Minutes",
            },
            {
                text = "<LOC Min10>10 Minutes",
                body = "<LOC tooltipCSKLOBRefPGen10Desc>Set the Wait Time to 10 Minutes",
            },
            {
                text = "<LOC Min15>15 Minutes",
                body = "<LOC tooltipCSKLOBRefPGen15Desc>Set the Wait Time to 15 Minutes",
            },
            {
                text = "<LOC Min20>20 Minutes",
                body = "<LOC tooltipCSKLOBRefPGen20Desc>Set the Wait Time to 20 Minutes",
            },
            {
                text = "<LOC Min25>25 Minutes",
                body = "<LOC tooltipCSKLOBRefPGen25Desc>Set the Wait Time to 25 Minutes",
            },
            {
                text = "<LOC Min30>30 Minutes",
                body = "<LOC tooltipCSKLOBRefPGen30Desc>Set the Wait Time to 30 Minutes",
            },
            {
                text = "<LOC Min35>35 Minutes",
                body = "<LOC tooltipCSKLOBRefPGen35Desc>Set the Wait Time to 35 Minutes",
            },
            {
                text = "<LOC Min40>40 Minutes",
                body = "<LOC tooltipCSKLOBRefPGen40Desc>Set the Wait Time to 40 Minutes",
            },
            {
                text = "<LOC Min45>45 Minutes",
                body = "<LOC tooltipCSKLOBRefPGen45Desc>Set the Wait Time to 45 Minutes",
            },
            {
                text = "<LOC Min50>50 Minutes",
                body = "<LOC tooltipCSKLOBRefPGen50Desc>Set the Wait Time to 50 Minutes",
            },
            {
                text = "<LOC Min55>55 Minutes",
                body = "<LOC tooltipCSKLOBRefPGen55Desc>Set the Wait Time to 55 Minutes",
            },
            {
                text = "<LOC Min60>60 Minutes",
                body = "<LOC tooltipCSKLOBRefPGen60Desc>Set the Wait Time to 60 Minutes",
            },			
}

TestCombo13ComboTooltips = {
	{
		text = "<LOC Second1>1 Second",
		body = "<LOC tooltipCSKLOBREFPointGenInt1Desc>Set the Point Generation Interval to 1 Second",
	},
	{
		text = "<LOC Second2>2 Seconds",
		body = "<LOC tooltipCSKLOBREFPointGenInt2Desc>Set the Point Generation Interval to 2 Seconds",
	},	
	{
		text = "<LOC Second3>3 Seconds",
		body = "<LOC tooltipCSKLOBREFPointGenInt3Desc>Set the Point Generation Interval to 3 Seconds",
	},	
}

TestCombo14ComboTooltips = {
	{
		text = "<LOC Deactivated>Deactivated",
		body = "<LOC tooltipCSKLOBREFPointGenR0Desc>Set the Point Generation Rate to 0 Point",
	},
	{
		text = "<LOC Point1>1 Point",
		body = "<LOC tooltipCSKLOBREFPointGenR1Desc>Set the Point Generation Rate to 1 Point",
	},
	{
		text = "<LOC Point2>2 Points",
		body = "<LOC tooltipCSKLOBREFPointGenR2Desc>Set the Point Generation Rate to 2 Points",
	},	
	{
		text = "<LOC Point3>3 Points",
		body = "<LOC tooltipCSKLOBREFPointGenR3Desc>Set the Point Generation Rate to 3 Point",
	},	
}

TestCombo15ComboTooltips = {
	{
		text = "<LOC Points0>0 Points",
		body = "<LOC tooltipCSKLOBMaxRefPoint0Desc>Set the Point Maximum to 0 Points",
	},
	{
		text = "<LOC Points1000>1000 Points",
		body = "<LOC tooltipCSKLOBMaxRefPoint1000Desc>Set the Point Maximum to 1000 Points",
	},
	{
		text = "<LOC Points2000>2000 Pointss",
		body = "<LOC tooltipCSKLOBMaxRefPoint2000Desc>Set the Point Maximum to 2000 Points",
	},	
	{
		text = "<LOC Points3000>3000 Points",
		body = "<LOC tooltipCSKLOBMaxRefPoint3000Desc>Set the Point Maximum to 3000 Points",
	},	
	{
		text = "<LOC Points4000>4000 Points",
		body = "<LOC tooltipCSKLOBMaxRefPoint4000Desc>Set the Point Maximum to 4000 Points",
	},	
	{
		text = "<LOC Points5000>5000 Points",
		body = "<LOC tooltipCSKLOBMaxRefPoint5000Desc>Set the Point Maximum to 5000 Points",
	},	
}

TestCombo16ComboTooltips = {
            {
                text = "<LOC Min5>5 Minutes",
                body = "<LOC tooltipCSKLOBFSPGen5Desc>Set the Wait Time to 5 Minutes",
            },
            {
                text = "<LOC Min10>10 Minutes",
                body = "<LOC tooltipCSKLOBFSPGen10Desc>Set the Wait Time to 10 Minutes",
            },
            {
                text = "<LOC Min15>15 Minutes",
                body = "<LOC tooltipCSKLOBFSPGen15Desc>Set the Wait Time to 15 Minutes",
            },
            {
                text = "<LOC Min20>20 Minutes",
                body = "<LOC tooltipCSKLOBFSPGen20Desc>Set the Wait Time to 20 Minutes",
            },
            {
                text = "<LOC Min25>25 Minutes",
                body = "<LOC tooltipCSKLOBFSPGen25Desc>Set the Wait Time to 25 Minutes",
            },
            {
                text = "<LOC Min30>30 Minutes",
                body = "<LOC tooltipCSKLOBFSPGen30Desc>Set the Wait Time to 30 Minutes",
            },
            {
                text = "<LOC Min35>35 Minutes",
                body = "<LOC tooltipCSKLOBFSPGen35Desc>Set the Wait Time to 35 Minutes",
            },
            {
                text = "<LOC Min40>40 Minutes",
                body = "<LOC tooltipCSKLOBFSPGen40Desc>Set the Wait Time to 40 Minutes",
            },
            {
                text = "<LOC Min45>45 Minutes",
                body = "<LOC tooltipCSKLOBFSPGen45Desc>Set the Wait Time to 45 Minutes",
            },
            {
                text = "<LOC Min50>50 Minutes",
                body = "<LOC tooltipCSKLOBFSPGen50Desc>Set the Wait Time to 50 Minutes",
            },
            {
                text = "<LOC Min55>55 Minutes",
                body = "<LOC tooltipCSKLOBFSPGen55Desc>Set the Wait Time to 55 Minutes",
            },
            {
                text = "<LOC Min60>60 Minutes",
                body = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 60 Minutes",
            },			
}

TestCombo17ComboTooltips = {
	{
		text = "<LOC Second1>1 Second",
		body = "<LOC tooltipCSKLOBTacPointGenInt1Desc>Set the Point Generation Interval to 1 Second",
	},
	{
		text = "<LOC Second2>2 Seconds",
		body = "<LOC tooltipCSKLOBTacPointGenInt2Desc>Set the Point Generation Interval to 2 Seconds",
	},	
	{
		text = "<LOC Second3>3 Seconds",
		body = "<LOC tooltipCSKLOBTacPointGenInt3Desc>Set the Point Generation Interval to 3 Seconds",
	},	
}

TestCombo18ComboTooltips = {
	{
		text = "<LOC Deactivated>Deactivated",
		body = "<LOC tooltipCSKLOBTacPointGenR0Desc>Set the Point Generation Rate to 0 Point",
	},
	{
		text = "<LOC Point1>1 Point",
		body = "<LOC tooltipCSKLOBTacPointGenR1Desc>Set the Point Generation Rate to 1 Point",
	},
	{
		text = "<LOC Point2>2 Points",
		body = "<LOC tooltipCSKLOBTacPointGenR2Desc>Set the Point Generation Rate to 2 Points",
	},	
	{
		text = "<LOC Point3>3 Points",
		body = "<LOC tooltipCSKLOBTacPointGenR3Desc>Set the Point Generation Rate to 3 Point",
	},	
}

TestCombo19ComboTooltips = {
	{
		text = "<LOC Points0>0 Points",
		body = "<LOC tooltipCSKLOBMaxTacPoint0Desc>Set the Point Maximum to 0 Points",
	},
	{
		text = "<LOC Points1000>1000 Points",
		body = "<LOC tooltipCSKLOBMaxTacPoint1000Desc>Set the Point Maximum to 1000 Points",
	},
	{
		text = "<LOC Points2000>2000 Pointss",
		body = "<LOC tooltipCSKLOBMaxTacPoint2000Desc>Set the Point Maximum to 2000 Points",
	},	
	{
		text = "<LOC Points3000>3000 Points",
		body = "<LOC tooltipCSKLOBMaxTacPoint3000Desc>Set the Point Maximum to 3000 Points",
	},	
	{
		text = "<LOC Points4000>4000 Points",
		body = "<LOC tooltipCSKLOBMaxTacPoint4000Desc>Set the Point Maximum to 4000 Points",
	},	
	{
		text = "<LOC Points5000>5000 Points",
		body = "<LOC tooltipCSKLOBMaxTacPoint5000Desc>Set the Point Maximum to 5000 Points",
	},	
}

TestCombo20ComboTooltips = {
	{
		text = "<LOC Callable>Callable",
		body = "<LOC tooltipCSKLOBEXASYDesc>Set the Experimental Air Strikes to be callable in this Match.",
	},
	{
		text = "<LOC NotCallable>Not Callable",
		body = "<LOC tooltipCSKLOBEXASNDesc>Set the Experimental Air Strikes to be not callable in this Match.",
	},			
}
