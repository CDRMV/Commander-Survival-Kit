#****************************************************************************
#** 
#**  Author(s):  CDRMV 
#** 
#**  Summary  :  UEF Bunker Script 
#** 
#**  Copyright © 2023 Commander Survival Kit.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

UEBTB0102 = Class(StructureUnit) {		 

    Weapons = {
        Riotgun01 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun02 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun03 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun04 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun05 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun06 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun07 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Riotgun08 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
    },
	

    OnCreate = function(self)
        StructureUnit.OnCreate(self)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:SetWeaponEnabledByLabel('Riotgun01', false)
		self:SetWeaponEnabledByLabel('Riotgun02', false)
		self:SetWeaponEnabledByLabel('Riotgun03', false)
		self:SetWeaponEnabledByLabel('Riotgun04', false)
		self:SetWeaponEnabledByLabel('Riotgun05', false)
		self:SetWeaponEnabledByLabel('Riotgun06', false)
		self:SetWeaponEnabledByLabel('Riotgun07', false)
		self:SetWeaponEnabledByLabel('Riotgun08', false)
    end,
	
	OnStopBeingBuilt = function(self)
        StructureUnit.OnStopBeingBuilt(self)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:SetWeaponEnabledByLabel('Riotgun01', false)
		self:SetWeaponEnabledByLabel('Riotgun02', false)
		self:SetWeaponEnabledByLabel('Riotgun03', false)
		self:SetWeaponEnabledByLabel('Riotgun04', false)
		self:SetWeaponEnabledByLabel('Riotgun05', false)
		self:SetWeaponEnabledByLabel('Riotgun06', false)
		self:SetWeaponEnabledByLabel('Riotgun07', false)
		self:SetWeaponEnabledByLabel('Riotgun08', false)
    end,
	
	OnTransportOrdered = function(self)
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorOpen.sca'):SetRate(1)
    end,
	
	OnTransportAttach = function(self, attachBone, unit)
		self:AddCommandCap('RULEUCC_Attack')
		self:AddCommandCap('RULEUCC_Stop')
		self:AddCommandCap('RULEUCC_RetaliateToggle')
		self:SetWeaponEnabledByLabel('Riotgun01', true)
		self:SetWeaponEnabledByLabel('Riotgun02', true)
		self:SetWeaponEnabledByLabel('Riotgun03', true)
		self:SetWeaponEnabledByLabel('Riotgun04', true)
		self:SetWeaponEnabledByLabel('Riotgun05', true)
		self:SetWeaponEnabledByLabel('Riotgun06', true)
		self:SetWeaponEnabledByLabel('Riotgun07', true)
		self:SetWeaponEnabledByLabel('Riotgun08', true)
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorOpen.sca')
		StructureUnit.OnTransportAttach(self, attachBone, unit)
		self:ForkThread( 
		function()
		unit:HideBone( 0, true )
		WaitSeconds(1)
		Dooropen:SetRate(-1)
		end
        )
    end,

    OnTransportDetach = function(self, attachBone, unit)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:SetWeaponEnabledByLabel('Riotgun01', false)
		self:SetWeaponEnabledByLabel('Riotgun02', false)
		self:SetWeaponEnabledByLabel('Riotgun03', false)
		self:SetWeaponEnabledByLabel('Riotgun04', false)
		self:SetWeaponEnabledByLabel('Riotgun05', false)
		self:SetWeaponEnabledByLabel('Riotgun06', false)
		self:SetWeaponEnabledByLabel('Riotgun07', false)
		self:SetWeaponEnabledByLabel('Riotgun08', false)
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorOpen.sca'):SetRate(1)
        local pos
        if not self.Dying then
            pos = unit:GetPosition()
        end
        StructureUnit.OnTransportDetach(self, attachBone, unit)
        if not self.Dying then
            self:ForkThread( 
                function()
                    WaitTicks(1)
                    local height = GetTerrainHeight(pos[1],pos[3])
						unit:ShowBone( 0, true )
                        Warp(unit, {pos[1], height, pos[3]})
						local units = {}
						units[1] = unit
						for i, Unit in units do
						IssueGuard({Unit}, self)
						end
						WaitSeconds(0.5)
						Dooropen:SetRate(-1)
                end
            )
        end
    end,
	


}


TypeClass = UEBTB0102

