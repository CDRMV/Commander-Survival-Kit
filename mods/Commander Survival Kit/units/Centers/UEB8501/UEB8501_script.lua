#****************************************************************************
#** 
#**  File     :  /cdimage/units/XEC1301/XEC1301_script.lua 
#** 
#** 
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit

UEB8501 = Class(StructureUnit) {

    OnCreate = function(self)
        StructureUnit.OnCreate(self)
		
		self.WindowEntity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.WindowEntity:AttachBoneTo( -1, self, 'Spinner' )
        self.WindowEntity:SetMesh('/mods/Commander Survival Kit/effects/entities/Symbols/UEF/Tactical/Tactical_mesh')
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


TypeClass = UEB8501
