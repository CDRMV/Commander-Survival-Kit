#****************************************************************************
#** 
#**  File     :  /cdimage/units/UAC1501/UAC1501_script.lua 
#**  Author(s):  John Comes, David Tomandl 
#** 
#**  Summary  :  Aeon Manufacturing Center, Ver1
#** 
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit

UAB8504c = Class(StructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		self.Entity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.Entity:AttachBoneTo( -1, self, 'Spinner' )
        self.Entity:SetMesh('/mods/Commander Survival Kit/effects/entities/Symbols/Aeon/Tactical/Tactical_mesh')
        self.Entity:SetDrawScale(0.25)
        self.Entity:SetVizToAllies('Intel')
        self.Entity:SetVizToNeutrals('Intel')
        self.Entity:SetVizToEnemies('Intel')   



        self.Spinners = {
            Spinner1 = CreateRotator(self, 'Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(90),
			Spinner3 = CreateRotator(self, 'Spinner3', 'y', nil, 0, 60, 360):SetTargetSpeed(-90),
			Spinner2 = CreateRotator(self, 'Spinner2', 'y', nil, 0, 60, 360):SetTargetSpeed(30),
        }
        for k, v in self.Spinners do
            self.Trash:Add(v)
        end	
		
		Sync.TacticalPointStorageCountLVL3 = true

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
		Sync.TacticalPointStorageCountLVL3 = false
		self:ForkThread(self.DeathThread, overkillRatio , instigator)
    end,

	OnReclaimed = function(self, reclaimer)
        self:DoUnitCallbacks('OnReclaimed', reclaimer)
		self.Entity:Destroy()
		Sync.TacticalPointStorageCountLVL3 = false
        self.CreateReclaimEndEffects(reclaimer, self)
        self:Destroy()
    end,

}


TypeClass = UAB8504c
