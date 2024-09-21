#****************************************************************************
#** 
#**  File     :  /cdimage/units/UAC1501/UAC1501_script.lua 
#**  Author(s):  John Comes, David Tomandl 
#** 
#**  Summary  :  Aeon Manufacturing Center, Ver1
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit

URB8504 = Class(StructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		self.Entity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.Entity:AttachBoneTo( -1, self, 'Spinner' )
        self.Entity:SetMesh('/mods/Commander Survival Kit/effects/entities/Symbols/Cybran/Tactical/Tactical_mesh')
        self.Entity:SetDrawScale(0.25)
        self.Entity:SetVizToAllies('Intel')
        self.Entity:SetVizToNeutrals('Intel')
        self.Entity:SetVizToEnemies('Intel')   



        self.Spinners = {
            Spinner1 = CreateRotator(self, 'Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(90),
        }
        for k, v in self.Spinners do
            self.Trash:Add(v)
        end	
		
		--Sync.HQComCenterDetected = true

    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
		self.Entity:Destroy()
		--Sync.HQComCenterDetected = false
		self:ForkThread(self.DeathThread, overkillRatio , instigator)
    end,



}


TypeClass = URB8504

