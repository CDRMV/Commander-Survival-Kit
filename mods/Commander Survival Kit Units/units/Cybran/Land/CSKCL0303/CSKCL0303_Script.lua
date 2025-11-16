#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0303/URL0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local cWeapons = import('/lua/cybranweapons.lua')
local CDFLaserDisintegratorWeapon = cWeapons.CDFLaserDisintegratorWeapon01
local CDFLaserPulseLightWeapon = import('/lua/cybranweapons.lua').CDFLaserPulseLightWeapon
local CIFMissileLoaWeapon = cWeapons.CIFMissileLoaWeapon

CSKCL0303 = Class(CWalkingLandUnit) 
{

    Weapons = {
		MainGun = Class(CDFLaserDisintegratorWeapon) {},
		MissileRack = Class(CIFMissileLoaWeapon) {},
		MissileRack2 = Class(CIFMissileLoaWeapon) {
		    OnWeaponFired = function(self)
				self:ForkThread(function()
                self.unit:RemoveTacticalSiloAmmo(5)
				WaitSeconds(8)
				if self.unit:GetTacticalSiloAmmoCount() == 0 then
				self.unit:GiveTacticalSiloAmmo(5)
				end
				end)
            end,
		},	
		Bite = Class(CDFLaserPulseLightWeapon) {
           -- FxMuzzleFlash = EffectTemplate.CElectronBolterMuzzleFlash01,
           -- FxMuzzleFlashScale = 0.4,
            OnWeaponFired = function(self)
                self.unit:BiteAnimation()
            end,
        },
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		local wep1 = self:GetWeaponByLabel('Bite')
		wep1:SetWeaponEnabled(false)	
		local wep2 = self:GetWeaponByLabel('MainGun')
		wep2:SetWeaponEnabled(true)
		local wep3 = self:GetWeaponByLabel('MissileRack')
		wep3:SetWeaponEnabled(true)
		local wep4 = self:GetWeaponByLabel('MissileRack2')
		wep4:SetWeaponEnabled(false)
		self:SetAutoMode(true)
    end,
	
	BiteAnimation = function(self)
        self:ForkThread(function()
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
            self.AnimationManipulator:SetRate(1.6)      
            self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationBite, true)

            WaitSeconds(1.01)
            self.AnimationManipulator:Destroy() 
        end)     
    end,
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		local wep1 = self:GetWeaponByLabel('Bite')
		wep1:SetWeaponEnabled(true)	
		local wep2 = self:GetWeaponByLabel('MainGun')
		wep2:SetWeaponEnabled(false)
		if GetScriptBit('RULEUTC_SpecialToggle') == true then
		self:SetAutoMode(false)
		local wep3 = self:GetWeaponByLabel('MissileRack')
		wep3:SetWeaponEnabled(false)
		local wep4 = self:GetWeaponByLabel('MissileRack2')
		wep4:SetWeaponEnabled(true)
		self:SetAutoMode(false)
		else
		local wep3 = self:GetWeaponByLabel('MissileRack')
		wep3:SetWeaponEnabled(true)
		local wep4 = self:GetWeaponByLabel('MissileRack2')
		wep4:SetWeaponEnabled(false)
		self:SetAutoMode(true)
		end
        self:GetWeaponManipulatorByLabel('Bite'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('MainGun'):GetHeadingPitch() )
		self.CheckCloseTargetsThreadHandle = self:ForkThread(self.CheckCloseTargetsThread)
		elseif bit == 7 then
		self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
		self:RemoveCommandCap('RULEUCC_Tactical')
		local wep3 = self:GetWeaponByLabel('MissileRack')
		wep3:SetWeaponEnabled(false)
		local wep4 = self:GetWeaponByLabel('MissileRack2')
		wep4:SetWeaponEnabled(true)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
		KillThread(self.CheckCloseTargetsThreadHandle)
        if bit == 1 then 
		self:AddToggleCap('RULEUTC_SpecialToggle')
		local wep1 = self:GetWeaponByLabel('Bite')
		wep1:SetWeaponEnabled(false)	
		local wep2 = self:GetWeaponByLabel('MainGun')
		wep2:SetWeaponEnabled(true)
		if GetScriptBit('RULEUTC_SpecialToggle') == true then
		local wep3 = self:GetWeaponByLabel('MissileRack')
		wep3:SetWeaponEnabled(false)
		local wep4 = self:GetWeaponByLabel('MissileRack2')
		wep4:SetWeaponEnabled(true)
		self:SetAutoMode(false)
		else
		local wep3 = self:GetWeaponByLabel('MissileRack')
		wep3:SetWeaponEnabled(true)
		local wep4 = self:GetWeaponByLabel('MissileRack2')
		wep4:SetWeaponEnabled(false)
		self:SetAutoMode(true)
		end
        self:GetWeaponManipulatorByLabel('MainGun'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('Bite'):GetHeadingPitch() )
		elseif bit == 7 then
		self:AddCommandCap('RULEUCC_SiloBuildTactical')
		self:AddCommandCap('RULEUCC_Tactical')
		local wep3 = self:GetWeaponByLabel('MissileRack')
		wep3:SetWeaponEnabled(true)
		local wep4 = self:GetWeaponByLabel('MissileRack2')
		wep4:SetWeaponEnabled(false)
        end
    end,
	
	CheckCloseTargetsThread = function(self)
		local unitPos = self:GetPosition()
        while not self:IsDead() do
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 4, 'Enemy')
			if units[1] == nil then
						
			else
			IssueClearCommands({self})
			end
            WaitSeconds(5)
        end
    end,
	
}

TypeClass = CSKCL0303