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
		self:RemoveCommandCap('RULEUCC_Transport')
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
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorOpen.sca', false):SetRate(1)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:RemoveCommandCap('RULEUCC_Transport')
		self:SetWeaponEnabledByLabel('Riotgun01', false)
		self:SetWeaponEnabledByLabel('Riotgun02', false)
		self:SetWeaponEnabledByLabel('Riotgun03', false)
		self:SetWeaponEnabledByLabel('Riotgun04', false)
		self:SetWeaponEnabledByLabel('Riotgun05', false)
		self:SetWeaponEnabledByLabel('Riotgun06', false)
		self:SetWeaponEnabledByLabel('Riotgun07', false)
		self:SetWeaponEnabledByLabel('Riotgun08', false)
    end,
	
	
	OnScriptBitSet = function(self, bit)
        StructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
				-- Lets check for Land Units in a Range of 8 to storage them
				local location = self:GetPosition()
				local bp = self:GetBlueprint()
				local maxstorage = bp.Transport.StorageSlots
				LOG('maxstorage: ', maxstorage)
				local units = self:GetAIBrain():GetUnitsAroundPoint(categories.TECH1, self:GetPosition(), 8, 'Ally') 
				for _, v in units do
				local CheckUnit = v:GetGuardedUnit()
				if EntityCategoryContains(categories.ENGINEER, v) == true then
				
				else
				if not v.Dead and v:GetGuardedUnit()then
				if EntityCategoryContains(categories.BUNKER, CheckUnit) == true then
				IssueMove(v, location)
				v:AttachBoneTo(0, self, 0)
				end
				end
				end
				end
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
		self.OpenAnimManip:SetRate(-1)
		end
    end,
	
	OnScriptBitClear = function(self, bit)
        StructureUnit.OnScriptBitSet(self, bit)
		local location = self:GetPosition()
        if bit == 1 then 
		self.OpenAnimManip:SetRate(1)
		LOG('Test')
        if self.Dead then return end 

        local cargo = self:GetCargo()
        for k, unit in cargo do
		LOG('cargo: ', cargo)
		local bp = unit:GetBlueprint()
		local MeshBlueprint = bp.Display.MeshBlueprint
		local UniformScale = bp.Display.UniformScale
		unit:SetMesh(MeshBlueprint)
		unit:SetDrawScale(UniformScale)
		unit:DetachFrom(true)
		Warp(unit, location)
        end
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
		end
    end,

}


TypeClass = UEBTB0102

