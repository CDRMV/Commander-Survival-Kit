#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0202/URL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local ModWeaponsFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local CDFLaserIridiumWeapon = ModWeaponsFile.CDFLaserIridiumWeapon
local CANNaniteTorpedoWeapon = import('/lua/cybranweapons.lua').CANNaniteTorpedoWeapon
local CAANanoDartWeapon = import('/lua/cybranweapons.lua').CAANanoDartWeapon
local CIFSmartCharge = import('/lua/cybranweapons.lua').CIFSmartCharge


CSKCL0308 = Class(CLandUnit) {
    Weapons = {
      MainGun = Class(CDFLaserIridiumWeapon) {},
	  LandTorpedoLauncher = Class(CAANanoDartWeapon) {},
	  UnderWaterTorpedoLauncher = Class(CANNaniteTorpedoWeapon) {},
	  Dummy = Class(CANNaniteTorpedoWeapon) {},
	  AntiTorpedo = Class(CIFSmartCharge) {},
	},
	
	OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
		if layer == 'Land'then
		self:SetWeaponEnabledByLabel('LandTorpedoLauncher', true)
		local Land = self:GetWeaponManipulatorByLabel('LandTorpedoLauncher')  
		local Seabed = self:GetWeaponManipulatorByLabel('UnderWaterTorpedoLauncher')   
        Land:SetHeadingPitch(Seabed:GetHeadingPitch())
        Seabed:SetHeadingPitch(0, 0)	
		self:SetWeaponEnabledByLabel('UnderWaterTorpedoLauncher', false)
		self:SetWeaponEnabledByLabel('AntiTorpedo', false)
        elseif layer == 'Seabed' then
		self:SetWeaponEnabledByLabel('UnderWaterTorpedoLauncher', true)
		local Land = self:GetWeaponManipulatorByLabel('LandTorpedoLauncher')  
		local Seabed = self:GetWeaponManipulatorByLabel('UnderWaterTorpedoLauncher')   
        Seabed:SetHeadingPitch(Land:GetHeadingPitch())
        Land:SetHeadingPitch(0, 0)	
		self:SetWeaponEnabledByLabel('LandTorpedoLauncher', false)
		self:SetWeaponEnabledByLabel('AntiTorpedo', true)
        end
    end,

	OnLayerChange = function(self, new, old)
        CLandUnit.OnLayerChange(self, new, old)
        if (new == 'Land') and (old != 'None') then
		self:SetWeaponEnabledByLabel('LandTorpedoLauncher', true)
		local Land = self:GetWeaponManipulatorByLabel('LandTorpedoLauncher')  
		local Seabed = self:GetWeaponManipulatorByLabel('UnderWaterTorpedoLauncher')   
        Land:SetHeadingPitch(Seabed:GetHeadingPitch())
        Seabed:SetHeadingPitch(0, 0)	
		self:SetWeaponEnabledByLabel('UnderWaterTorpedoLauncher', false)
		self:SetWeaponEnabledByLabel('AntiTorpedo', false)
        elseif (new == 'Seabed') then
		self:SetWeaponEnabledByLabel('UnderWaterTorpedoLauncher', true)
		local Land = self:GetWeaponManipulatorByLabel('LandTorpedoLauncher')  
		local Seabed = self:GetWeaponManipulatorByLabel('UnderWaterTorpedoLauncher')   
        Seabed:SetHeadingPitch(Land:GetHeadingPitch())
        Land:SetHeadingPitch(0, 0)	
		self:SetWeaponEnabledByLabel('LandTorpedoLauncher', false)
		self:SetWeaponEnabledByLabel('AntiTorpedo', true)
        end
    end,
}

TypeClass = CSKCL0308