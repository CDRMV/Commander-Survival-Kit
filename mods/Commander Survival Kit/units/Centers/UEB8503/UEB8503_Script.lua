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

UEB8503 = Class(StructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		self.Entity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.Entity:AttachBoneTo( -1, self, 'Spinner' )
        self.Entity:SetMesh('/mods/Commander Survival Kit/effects/entities/Symbols/UEF/Reinforcement/Reinforcement_mesh')
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
		
		Sync.ReinforcementPointStorageCountLVL1 = true

    end,
	    
	OnDestroy = function(self)
		if self.Entity == nil then
		else
		self.Entity:Destroy()
		end
        self.Dead = true

        if self:GetFractionComplete() < 1 then
            self:SendNotifyMessage('cancelled')
        end


        -- Destroy everything added to the trash
        self.Trash:Destroy()
        

        ChangeState(self, self.DeadState)
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
		self.Entity:Destroy()
		Sync.ReinforcementPointStorageCountLVL1 = false
		self:ForkThread(self.DeathThread, overkillRatio , instigator)
    end,
	
	OnReclaimed = function(self, reclaimer)
        self:DoUnitCallbacks('OnReclaimed', reclaimer)
		self.Entity:Destroy()
		Sync.ReinforcementPointStorageCountLVL1 = false
        self.CreateReclaimEndEffects(reclaimer, self)
        self:Destroy()
    end,



}


TypeClass = UEB8503

