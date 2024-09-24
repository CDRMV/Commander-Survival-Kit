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

UAB8502 = Class(StructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		self.Entity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.Entity:AttachBoneTo( -1, self, 'L_Spinner01' )
        self.Entity:SetMesh('/mods/Commander Survival Kit/effects/entities/Symbols/Aeon/Reinforcement/Reinforcement_mesh')
        self.Entity:SetDrawScale(0.25)
        self.Entity:SetVizToAllies('Intel')
        self.Entity:SetVizToNeutrals('Intel')
        self.Entity:SetVizToEnemies('Intel')   

		self.Entity2 = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.Entity2:AttachBoneTo( -1, self, 'L_Spinner02' )
        self.Entity2:SetMesh('/mods/Commander Survival Kit/effects/entities/Symbols/Aeon/Tactical/Tactical_mesh')
        self.Entity2:SetDrawScale(0.25)
        self.Entity2:SetVizToAllies('Intel')
        self.Entity2:SetVizToNeutrals('Intel')
        self.Entity2:SetVizToEnemies('Intel')  
		
		self.Entity3 = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.Entity3:AttachBoneTo( -1, self, 'R_Spinner01' )
        self.Entity3:SetMesh('/mods/Commander Survival Kit/effects/entities/Symbols/Aeon/Reinforcement/Reinforcement_mesh')
        self.Entity3:SetDrawScale(0.25)
        self.Entity3:SetVizToAllies('Intel')
        self.Entity3:SetVizToNeutrals('Intel')
        self.Entity3:SetVizToEnemies('Intel')   

		self.Entity4 = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.Entity4:AttachBoneTo( -1, self, 'R_Spinner02' )
        self.Entity4:SetMesh('/mods/Commander Survival Kit/effects/entities/Symbols/Aeon/Tactical/Tactical_mesh')
        self.Entity4:SetDrawScale(0.25)
        self.Entity4:SetVizToAllies('Intel')
        self.Entity4:SetVizToNeutrals('Intel')
        self.Entity4:SetVizToEnemies('Intel')  


        self.Spinners = {
            Spinner1 = CreateRotator(self, 'L_Spinner01', 'y', nil, 0, 60, 360):SetTargetSpeed(90),
			Spinner2 = CreateRotator(self, 'L_Spinner02', 'y', nil, 0, 60, 360):SetTargetSpeed(90),
			Spinner3 = CreateRotator(self, 'R_Spinner01', 'y', nil, 0, 60, 360):SetTargetSpeed(-90),
			Spinner4 = CreateRotator(self, 'R_Spinner02', 'y', nil, 0, 60, 360):SetTargetSpeed(-90),
        }
        for k, v in self.Spinners do
            self.Trash:Add(v)
        end	
		
		Sync.HQComCenterDetected = true

    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
		self.Entity:Destroy()
		self.Entity2:Destroy()
		self.Entity3:Destroy()
		self.Entity4:Destroy()
		Sync.HQComCenterDetected = false
		self:ForkThread(self.DeathThread, overkillRatio , instigator)
    end,

	OnReclaimed = function(self, reclaimer)
        self:DoUnitCallbacks('OnReclaimed', reclaimer)
		self.Entity:Destroy()
		self.Entity2:Destroy()
		self.Entity3:Destroy()
		self.Entity4:Destroy()
		Sync.HQComCenterDetected = false
        self.CreateReclaimEndEffects(reclaimer, self)
        self:Destroy()
    end,

}


TypeClass = UAB8502

