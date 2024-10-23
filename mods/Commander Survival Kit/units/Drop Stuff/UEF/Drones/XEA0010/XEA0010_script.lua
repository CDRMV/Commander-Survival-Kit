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
local CreateDefaultBuildBeams2 = import('/lua/EffectUtilities.lua').CreateDefaultBuildBeams2

XEA0010 = Class(TAirUnit) {
	EngineRotateBones = {'Jet_Front', 'Jet_Back',},
	
    Parent = nil,

    SetParent = function(self, parent, podName)
        self.Parent = parent
        self.Pod = podName
    end,
	
	CreateBuildEffects = function( self, unitBeingBuilt, order )
        local UpgradesFrom = unitBeingBuilt:GetBlueprint().General.UpgradesFrom
        # If we are assisting an upgrading unit, or repairing a unit, play seperate effects
        if (order == 'Repair' and not unitBeingBuilt:IsBeingBuilt()) or (UpgradesFrom and UpgradesFrom != 'none' and self:IsUnitState('Guarding'))then
            CreateDefaultBuildBeams2( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
        end           
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

TypeClass = XEA0010