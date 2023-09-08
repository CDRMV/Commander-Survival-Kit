#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0304/UEL0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Heavy Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local Modpath = '/mods/Commander Survival Kit Units/effects/emitters/'
local AIUtils = import('/lua/ai/aiutilities.lua')
CSKTL0300 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
        },
		Rocket = Class(TDFGaussCannonWeapon) {
        },
    },
	
	OnCreate = function(self)
        TLandUnit.OnCreate(self)
		self:RemoveCommandCap('RULEUCC_Transport')
		self:EnableShield()
    end,
	
	OnLayerChange = function(self, new, old)
        TLandUnit.OnLayerChange(self, new, old)
        if self:GetBlueprint().Display.AnimationWater then
            if self.TerrainLayerTransitionThread then
                self.TerrainLayerTransitionThread:Destroy()
                self.TerrainLayerTransitionThread = nil
            end
            if (new == 'Land') and (old != 'None') then
				self:AddToggleCap('RULEUTC_WeaponToggle')
				self:AddToggleCap('RULEUTC_ShieldToggle')
				self:AddToggleCap('RULEUTC_JammingToggle')
                self.TerrainLayerTransitionThread = self:ForkThread(self.TransformThread, false)
            elseif (new == 'Water') then
				self:RemoveToggleCap('RULEUTC_WeaponToggle')
				self:RemoveToggleCap('RULEUTC_ShieldToggle')
				self:RemoveToggleCap('RULEUTC_JammingToggle')
                self.TerrainLayerTransitionThread = self:ForkThread(self.TransformThread, true)
            end
        end
    end,

    TransformThread = function(self, water)
        
        if not self.TransformManipulator then
            self.TransformManipulator = CreateAnimator(self)
            self.Trash:Add( self.TransformManipulator )
        end

        if water then
            self.TransformManipulator:PlayAnim(self:GetBlueprint().Display.AnimationWater)
            self.TransformManipulator:SetRate(1)
            self.TransformManipulator:SetPrecedence(0)
        else
            self.TransformManipulator:SetRate(-1)
            self.TransformManipulator:SetPrecedence(0)
            WaitFor(self.TransformManipulator)
            self.TransformManipulator:Destroy()
            self.TransformManipulator = nil
        end
    end,
	
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
		local location = self:GetPosition()
		local id = self:GetEntityId()
		local SurfaceHeight = GetSurfaceHeight(location[1], location[3]) -- Get Water layer
		local TerrainHeight = GetTerrainHeight(location[1], location[3]) -- Get Land Layer
		local mainbp = self:GetBlueprint()
		LOG("Water: ", SurfaceHeight)
		LOG("Land: ", TerrainHeight)
		if bit == 0 then 
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorOpen.sca'):SetRate(1)

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
            end
		Dooropen:Destroy()
		local Doorclosing = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorClosing.sca'):SetRate(1)		
		else	
		end	
        if bit == 1 then 
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorOpen.sca'):SetRate(1)
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
		Dooropen:Destroy()
		local Doorclosing = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorClosing.sca'):SetRate(1)	
		end
		if bit == 2 then 
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorOpen.sca'):SetRate(1)
		self:TransportDetachAllUnits(true)
		Dooropen:Destroy()
		local Doorclosing = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorClosing.sca'):SetRate(1)	
		end
    end,
	
	OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
		local location = self:GetPosition()
		local id = self:GetEntityId()
		local SurfaceHeight = GetSurfaceHeight(location[1], location[3]) -- Get Water layer
		local TerrainHeight = GetTerrainHeight(location[1], location[3]) -- Get Land Layer
		local mainbp = self:GetBlueprint()
		LOG("Water: ", SurfaceHeight)
		LOG("Land: ", TerrainHeight)
		if bit == 0 then 
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorOpen.sca'):SetRate(1)

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
            end
		Dooropen:Destroy()
		local Doorclosing = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorClosing.sca'):SetRate(1)		
		else	
		end	
        if bit == 1 then 
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorOpen.sca'):SetRate(1)
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
		Dooropen:Destroy()
		local Doorclosing = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorClosing.sca'):SetRate(1)	
		end
		if bit == 2 then 
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorOpen.sca'):SetRate(1)
		self:TransportDetachAllUnits(true)
		Dooropen:Destroy()
		local Doorclosing = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0300/CSKTL0300_DoorClosing.sca'):SetRate(1)	
		end
    end,
	
	
	--[[
	OnScriptBitSet = function(self, bit)
        if bit == 1 then 
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			local location = self:GetPosition()
			self:ForkThread(function()  
			WaitSeconds(1)	
			local SmokeUnit = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(3)	
			local SmokeUnit2 = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(3)	
			local SmokeUnit3 = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(20) -- Sets the Reloadtime of the Ability
			self:AddToggleCap('RULEUTC_WeaponToggle')		
			end)			
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 1 then 
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			local location = self:GetPosition()
			self:ForkThread(function()  
			WaitSeconds(1)	
			local SmokeUnit = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(3)	
			local SmokeUnit2 = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(3)	
			local SmokeUnit3 = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(20) -- Sets the Reloadtime of the Ability
			self:AddToggleCap('RULEUTC_WeaponToggle')		
			end)	
        end
    end,
	
	--]]
}

TypeClass = CSKTL0300