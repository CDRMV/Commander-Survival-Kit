#****************************************************************************
#** 
#**  File     :  /cdimage/units/XEC1401/XEC1401_script.lua 
#** 
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').FactoryUnit

UEBTB0304 = Class(StructureUnit) {

    OnCreate = function(self)
        StructureUnit.OnCreate(self)
		
		self:AddBuildRestriction(categories.UEF * categories.BUILTBYTIER1FACTORY)	
        self:HideBone('Spinner1', true)
		self:HideBone('Spinner2', true)
		self:HideBone('Spinner3', true)
		self:HideBone('Spinner4', true)
    end,
	
	OnStopBeingBuild = function(self)
        StructureUnit.OnStopBeingBuilt(self)
		self:AddBuildRestriction(categories.UEF * categories.BUILTBYTIER1FACTORY)	
        self:HideBone('Spinner1', true)
		self:HideBone('Spinner2', true)
		self:HideBone('Spinner3', true)
		self:HideBone('Spinner4', true)
    end,
	
	    
    OnScriptBitSet = function(self, bit)
        StructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		local Targetposition = self:GetRallyPoint()
		CreateUnitHPR('UEAR0350', self:GetArmy(), Targetposition[1], Targetposition[2], Targetposition[3], 0, 0, 0)
        end
    end,

    OnScriptBitClear = function(self, bit)
        StructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		local Targetposition = self:GetRallyPoint()
		CreateUnitHPR('UEAR0350', self:GetArmy(), Targetposition[1], Targetposition[2], Targetposition[3], 0, 0, 0)
        end
    end,
	

}


TypeClass = UEBTB0304

