#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0303/UAL0303_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit
local ADFLaserHighIntensityWeapon = import('/lua/aeonweapons.lua').ADFLaserHighIntensityWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')

CSKAL0400 = Class(AWalkingLandUnit) {    
    Weapons = {
        FrontTurret01 = Class(ADFLaserHighIntensityWeapon) {}
    },
    
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateAeonCommanderBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end,  
	
	OnCreate = function(self)
        AWalkingLandUnit.OnCreate(self)
        self:HideBone('Leg01_Turret', true)
        self:HideBone('Leg02_Turret', true)        
        self:HideBone('Leg03_Turret', true)   
        self:HideBone('Leg04_Turret', true) 
        self:HideBone('L_Turret01', true)
        self:HideBone('L_Turret02', true)        
        self:HideBone('R_Turret01', true)   
        self:HideBone('R_Turret02', true)    	   		
    end,
}

TypeClass = CSKAL0400