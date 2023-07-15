#****************************************************************************
#** 
#**  File     :  /cdimage/units/UEC1301/UEC1301_script.lua 
#**  Author(s):  John Comes, David Tomandl 
#** 
#**  Summary  :  Earth Administrative Building, Ver1
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit

UEB8500 = Class(TStructureUnit) {

    OnCreate = function(self)
        TStructureUnit.OnCreate(self)
		
		self.WindowEntity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.WindowEntity:AttachBoneTo( -1, self, 'Spinner' )
        self.WindowEntity:SetMesh('/mods/Commander Survival Kit/effects/entities/Symbols/UEF/Reinforcement/Reinforcement_mesh')
        self.WindowEntity:SetDrawScale(0.25)
        self.WindowEntity:SetVizToAllies('Intel')
        self.WindowEntity:SetVizToNeutrals('Intel')
        self.WindowEntity:SetVizToEnemies('Intel')        
        self.Trash:Add(self.WindowEntity)
		
		--self.Effect1 = CreateAttachedEmitter(self,'Projector',self:GetArmy(), '/effects/emitters/aeon_t2power_ambient_02_emit.bp'):ScaleEmitter(0.5)
        --self.Trash:Add(self.Effecct1)
        self.Spinners = {
            Spinner1 = CreateRotator(self, 'Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(90),
        }
        for k, v in self.Spinners do
            self.Trash:Add(v)
        end
    end,

}


TypeClass = UEB8500

