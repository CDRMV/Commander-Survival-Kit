#****************************************************************************
#**
#**  File     :  /lua/AI/CustomAITooltips/CSKTooltips.lua
#**  Author(s): CDRMV
#**
#**  Summary  : Utility File to insert the new Lobby Options Tooltips.
#**
#****************************************************************************

Tooltips = {    
	Ref_Points = {
        title = "Reinforcements available in:",
        description = "Set the wait time for the Reinforcement Point Generation in Minutes.",
    },
	Tac_Points = {
        title = "Fire Support available in:",
        description = "Set the wait time for the Tactical Point Generation in Minutes.",
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
	lob_RefPointsMax_2500 = {
        title = "Maximum collectable Reinforcement Points:",
        description = "Set the Maximum to 2500 collectable Points.",
    },
	lob_RefPointsMax_3000 = {
        title = "Maximum collectable Reinforcement Points:",
        description = "Set the Maximum to 3000 collectable Points.",
    },
	lob_RefPointsMax_3500 = {
        title = "Maximum collectable Reinforcement Points:",
        description = "Set the Maximum to 3500 collectable Points.",
    },
	lob_RefPointsMax_4000 = {
        title = "Maximum collectable Reinforcement Points:",
        description = "Set the Maximum to 4000 collectable Points.",
    },
	lob_RefPointsMax_4500 = {
        title = "Maximum collectable Reinforcement Points:",
        description = "Set the Maximum to 4500 collectable Points.",
    },
	lob_RefPointsMax_5000 = {
        title = "Maximum collectable Reinforcement Points:",
        description = "Set the Maximum to 5000 collectable Points.",
    },
	lob_TacPointsMax_1300 = {
        title = "Maximum collectable Tactical Points:",
        description = "Set the Maximum to 1300 collectable Points.",
    },
	lob_TacPointsMax_1600 = {
        title = "Maximum collectable Tactical Points:",
        description = "Set the Maximum to 1600 collectable Points.",
    },
	lob_TacPointsMax_2000 = {
        title = "Maximum collectable Tactical Points:",
        description = "Set the Maximum to 2000 collectable Points.",
    },
	lob_TacPointsMax_2300 = {
        title = "Maximum collectable Tactical Points:",
        description = "Set the Maximum to 2300 collectable Points.",
    },
	lob_TacPointsMax_2600 = {
        title = "Maximum collectable Tactical Points:",
        description = "Set the Maximum to 2600 collectable Points.",
    },
	lob_TacPointsMax_3000 = {
        title = "Maximum collectable Tactical Points:",
        description = "Set the Maximum to 3000 collectable Points.",
    },
}