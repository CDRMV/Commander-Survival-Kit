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
		self:RemoveCommandCap('RULEUCC_Transport')
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:EnableShield()
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
		self:RemoveCommandCap('RULEUCC_Transport')
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:EnableShield()
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
		local location = self:GetPosition()
		local id = self:GetEntityId()
		local SurfaceHeight = GetSurfaceHeight(location[1], location[3]) -- Get Water layer
		local TerrainHeight = GetTerrainHeight(location[1], location[3]) -- Get Land Layer
		local mainbp = self:GetBlueprint()
		LOG("Water: ", SurfaceHeight)
		LOG("Land: ", TerrainHeight)
		if bit == 0 then 
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorOpen.sca'):SetRate(1)

		self:EnableShield()
			if self:TransportHasAvailableStorage() then
				-- Lets check for Land Units in a Range of 8 to storage them
				local checkcategories = categories.LAND + categories.TECH1 + categories.MOBILE
				local units = self:GetAIBrain():GetUnitsAroundPoint(checkcategories, self:GetPosition(), 8, 'Ally')
				for _, v in units do
					if not v.Dead and v:IsUnitState('Guarding') then
					    self:AddUnitToStorage(v)
					end
				end
			else
				FloatingEntityText(id, 'No avaiable Storage Slots (Maximum is 10)')	
				self:TransportDetachAllUnits(true)
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
		Dooropen:Destroy()
		local Doorclosing = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorClosing.sca'):SetRate(1)		
		else	
		end	
        if bit == 1 then 
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorOpen.sca'):SetRate(1)
			LOG('Test')
        if self.Dead then return end 

        local cargo = self:GetCargo()
        for _, unit in cargo do
		LOG('cargo: ', cargo)
		local bp = unit:GetBlueprint()
		local MeshBlueprint = bp.Display.MeshBlueprint
		local UniformScale = bp.Display.UniformScale
		unit:SetMesh(MeshBlueprint)
		unit:SetDrawScale(UniformScale)
		unit:DetachFrom(true)
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
		Dooropen:Destroy()
		local Doorclosing = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorClosing.sca'):SetRate(1)	
		end
		if bit == 2 then 
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorOpen.sca'):SetRate(1)
		self:TransportDetachAllUnits(true)
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
		Dooropen:Destroy()
		local Doorclosing = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorClosing.sca'):SetRate(1)	
		end
    end,
	
	OnScriptBitClear = function(self, bit)
        StructureUnit.OnScriptBitSet(self, bit)
		local location = self:GetPosition()
		local id = self:GetEntityId()
		local SurfaceHeight = GetSurfaceHeight(location[1], location[3]) -- Get Water layer
		local TerrainHeight = GetTerrainHeight(location[1], location[3]) -- Get Land Layer
		local mainbp = self:GetBlueprint()
		LOG("Water: ", SurfaceHeight)
		LOG("Land: ", TerrainHeight)
		if bit == 0 then 
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorOpen.sca'):SetRate(1)

		self:EnableShield()
			if self:TransportHasAvailableStorage() then
				-- Lets check for Land Units in a Range of 8 to storage them
				local checkcategories = categories.LAND + categories.TECH1 + categories.MOBILE
				local units = self:GetAIBrain():GetUnitsAroundPoint(checkcategories, self:GetPosition(), 8, 'Ally')
				for _, v in units do
					if not v.Dead and v:IsUnitState('Guarding') then
					    self:AddUnitToStorage(v)
					end
				end
			else
				FloatingEntityText(id, 'No avaiable Storage Slots (Maximum is 10)')	
				self:TransportDetachAllUnits(true)
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
		Dooropen:Destroy()
		local Doorclosing = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorClosing.sca'):SetRate(1)		
		else	
		end	
        if bit == 1 then 
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorOpen.sca'):SetRate(1)
			LOG('Test')
        if self.Dead then return end 

        local cargo = self:GetCargo()
        for _, unit in cargo do
		LOG('cargo: ', cargo)
		local bp = unit:GetBlueprint()
		local MeshBlueprint = bp.Display.MeshBlueprint
		local UniformScale = bp.Display.UniformScale
		unit:SetMesh(MeshBlueprint)
		unit:SetDrawScale(UniformScale)
		unit:DetachFrom(true)
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
		Dooropen:Destroy()
		local Doorclosing = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorClosing.sca'):SetRate(1)	
		end
		if bit == 2 then 
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorOpen.sca'):SetRate(1)
		self:TransportDetachAllUnits(true)
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
		Dooropen:Destroy()
		local Doorclosing = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Structures/UEBTB0102/UEBTB0102_DoorClosing.sca'):SetRate(1)	
		end
    end,

}


TypeClass = UEBTB0102

