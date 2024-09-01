#****************************************************************************
#** 
#**  Author(s):  CDRMV 
#** 
#**  Summary  :  UEF Bunker Script 
#** 
#**  Copyright © 2023 Commander Survival Kit.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local CDFLaserPulseLightWeapon = import('/lua/cybranweapons.lua').CDFLaserPulseLightWeapon

URBCB0102 = Class(StructureUnit) {		 

    Weapons = {
        MainGun01 = Class(CDFLaserPulseLightWeapon) {},
        MainGun02 = Class(CDFLaserPulseLightWeapon) {},
        MainGun03 = Class(CDFLaserPulseLightWeapon) {},
        MainGun04 = Class(CDFLaserPulseLightWeapon) {},
        MainGun05 = Class(CDFLaserPulseLightWeapon) {},
        MainGun06 = Class(CDFLaserPulseLightWeapon) {},
        MainGun07 = Class(CDFLaserPulseLightWeapon) {},
        MainGun08 = Class(CDFLaserPulseLightWeapon) {},
		MainGun09 = Class(CDFLaserPulseLightWeapon) {},
    },
	

    OnCreate = function(self)
        StructureUnit.OnCreate(self)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:SetWeaponEnabledByLabel('MainGun01', false)
		self:SetWeaponEnabledByLabel('MainGun02', false)
		self:SetWeaponEnabledByLabel('MainGun03', false)
		self:SetWeaponEnabledByLabel('MainGun04', false)
		self:SetWeaponEnabledByLabel('MainGun05', false)
		self:SetWeaponEnabledByLabel('MainGun06', false)
		self:SetWeaponEnabledByLabel('MainGun07', false)
		self:SetWeaponEnabledByLabel('MainGun08', false)
		self:SetWeaponEnabledByLabel('MainGun09', false)
    end,
	
	OnStopBeingBuilt = function(self)
        StructureUnit.OnStopBeingBuilt(self)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:SetWeaponEnabledByLabel('MainGun01', false)
		self:SetWeaponEnabledByLabel('MainGun02', false)
		self:SetWeaponEnabledByLabel('MainGun03', false)
		self:SetWeaponEnabledByLabel('MainGun04', false)
		self:SetWeaponEnabledByLabel('MainGun05', false)
		self:SetWeaponEnabledByLabel('MainGun06', false)
		self:SetWeaponEnabledByLabel('MainGun07', false)
		self:SetWeaponEnabledByLabel('MainGun08', false)
		self:SetWeaponEnabledByLabel('MainGun09', false)
    end,
	
	OnTransportOrdered = function(self)
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/Cybran/Structures/URBCB0102/URBCB0102_DoorOpen.sca'):SetRate(1)
    end,
	
	OnTransportAttach = function(self, attachBone, unit)
		self:AddCommandCap('RULEUCC_Attack')
		self:AddCommandCap('RULEUCC_Stop')
		self:AddCommandCap('RULEUCC_RetaliateToggle')
		self:SetWeaponEnabledByLabel('MainGun01', true)
		self:SetWeaponEnabledByLabel('MainGun02', true)
		self:SetWeaponEnabledByLabel('MainGun03', true)
		self:SetWeaponEnabledByLabel('MainGun04', true)
		self:SetWeaponEnabledByLabel('MainGun05', true)
		self:SetWeaponEnabledByLabel('MainGun06', true)
		self:SetWeaponEnabledByLabel('MainGun07', true)
		self:SetWeaponEnabledByLabel('MainGun08', true)
		self:SetWeaponEnabledByLabel('MainGun09', true)
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/Cybran/Structures/URBCB0102/URBCB0102_DoorOpen.sca')
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
		self:SetWeaponEnabledByLabel('MainGun01', false)
		self:SetWeaponEnabledByLabel('MainGun02', false)
		self:SetWeaponEnabledByLabel('MainGun03', false)
		self:SetWeaponEnabledByLabel('MainGun04', false)
		self:SetWeaponEnabledByLabel('MainGun05', false)
		self:SetWeaponEnabledByLabel('MainGun06', false)
		self:SetWeaponEnabledByLabel('MainGun07', false)
		self:SetWeaponEnabledByLabel('MainGun08', false)
		self:SetWeaponEnabledByLabel('MainGun09', false)
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/Cybran/Structures/URBCB0102/URBCB0102_DoorOpen.sca'):SetRate(1)
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


TypeClass = URBCB0102

