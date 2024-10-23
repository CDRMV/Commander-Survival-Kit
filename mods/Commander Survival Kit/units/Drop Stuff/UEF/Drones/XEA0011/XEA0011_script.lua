#****************************************************************************
#**
#**  File     :  /cdimage/units/XEA3204/XEA3204_script.lua
#**  Author(s):  Dru Staltman
#**
#**  Summary  :  UEF CDR Pod Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon

XEA0011 = Class(TAirUnit) {
	EngineRotateBones = {'Jet_Front', 'Jet_Back',},
	
	Weapons = {
        Turret01 = Class(TDFRiotWeapon) {},
    },
	
    Parent = nil,

    SetParent = function(self, parent, podName)
        self.Parent = parent
        self.Pod = podName
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
        self.EngineManipulators = {}

        # create the engine thrust manipulators
        for key, value in self.EngineRotateBones do
            table.insert(self.EngineManipulators, CreateThrustController(self, "thruster", value))
        end

        # set up the thursting arcs for the engines
        for key,value in self.EngineManipulators do
            #                          XMAX, XMIN, YMAX,YMIN, ZMAX,ZMIN, TURNMULT, TURNSPEED
            value:SetThrustingParam( -0.0, 0.0, -0.25, 0.25, -0.1, 0.1, 1.0,      0.25 )
        end
        
        for k, v in self.EngineManipulators do
            self.Trash:Add(v)
        end

    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self.Parent:NotifyOfPodDeath(self.Pod)
        self.Parent = nil
        TAirUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
    
                
}

TypeClass = XEA0011