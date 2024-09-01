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
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TIFCruiseMissileUnpackingLauncher = import('/lua/terranweapons.lua').TIFCruiseMissileUnpackingLauncher

CSKTL0320 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
        },
		Riotgun01 = Class(TDFMachineGunWeapon) {
        },
		Riotgun02 = Class(TDFMachineGunWeapon) {
        },
		GatlingGun = Class(TDFGaussCannonWeapon) {
		FxMuzzleFlashScale = 0.15,
        },
		MissileWeapon = Class(TIFCruiseMissileUnpackingLauncher) 
        {
            FxMuzzleFlash = {'/effects/emitters/terran_mobile_missile_launch_01_emit.bp'},
        },
    },
	
	OnStopBeingBuilt = function(self, builder, layer)
        TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetMaintenanceConsumptionInactive()
		self:SetScriptBit('RULEUTC_CloakToggle', true)
		self:RemoveToggleCap('RULEUTC_CloakToggle')
		self:SetCollisionShape( 'Box', 0, 1, 0, 0.9, 1.2, 0.9)
		self:SetWeaponEnabledByLabel('MainGun', false)
        self.Spinner = CreateRotator(self, 'Drill', 'z', nil, 0, 60, 360):SetTargetSpeed(0)
		ForkThread( function()
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0.5)
		WaitFor(self.OpenAnimManip)
		self:SetWeaponEnabledByLabel('MainGun', true)
		end
		)
    end,
	
	OnMotionHorzEventChange = function(self, new, old)
        TLandUnit.OnMotionHorzEventChange(self, new, old)
		ForkThread( function()
				while true do
                if( old == 'Stopped' ) and not self.Dead then
				local value = self:GetScriptBit(3)
				if value == true then
				self:RemoveCommandCap('RULEUCC_Attack')
				self:RemoveCommandCap('RULEUCC_RetaliateToggle')
				self:SetWeaponEnabledByLabel('MainGun', false)
				self:SetWeaponEnabledByLabel('Riotgun01', false)
				self:SetWeaponEnabledByLabel('Riotgun02', false)
				self:SetWeaponEnabledByLabel('GatlingGun', false)
				self:SetWeaponEnabledByLabel('MissileWeapon', false)
				CreateSplatOnBone(self, {0,0,0}, 'CSKTL0320', '/mods/Commander Survival Kit Units/Textures/worm_splat.dds', 5, 5.5, 100, 15, self:GetArmy())
				else
				CreateSplatOnBone(self, {0,0,0}, 'CSKTL0320', 'tank_treads_albedo', 2.4, 2.4, 100, 15, self:GetArmy())
				end
                elseif( new == 'Stopped' ) then
				break
                end
				WaitSeconds(1)
				end
		end)		
    end,
	
	OnLayerChange = function(self, new, old)
        TLandUnit.OnLayerChange(self, new, old)
            if (new == 'Land') and (old != 'None') then
				self:AddToggleCap('RULEUTC_WeaponToggle')
            elseif (new == 'Seabed') then
				self:RemoveToggleCap('RULEUTC_WeaponToggle')
            end
    end,
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self.Spinner:SetTargetSpeed(120)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:SetWeaponEnabledByLabel('MainGun', false)
		self:SetWeaponEnabledByLabel('Riotgun01', false)
		self:SetWeaponEnabledByLabel('Riotgun02', false)
		self:SetWeaponEnabledByLabel('GatlingGun', false)
		self:SetWeaponEnabledByLabel('MissileWeapon', false)
		ForkThread( function()
						self:SetUnSelectable(true)
						local rotation = RandomFloat(0,2*math.pi)
						local size = RandomFloat(5.75,5.0)
						self.Effect1 = CreateAttachedEmitter(self,'CSKTL0320',self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(2):SetEmitterParam('LIFETIME', 200)
						self.Trash:Add(self.Effect1)
						self.Effect2 = CreateAttachedEmitter(self,'CSKTL0320',self:GetArmy(), '/effects/emitters/dust_cloud_06_emit.bp'):ScaleEmitter(5):SetEmitterParam('LIFETIME', 200):OffsetEmitter(0,-1,0)
						self:ShakeCamera(200, 1, 0, 20)
						self.Trash:Add(self.Effect2)
						CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
                        self.OpenAnimManip:SetRate(-1)
						WaitFor(self.OpenAnimManip)
						self.Rotator1 = CreateRotator(self, 'Chassis', 'X', 20, 40, 0, 0)
						self.Worm = CreateSlider(self, 'Chassis', 0, -50, 0, 25)
                        self.Trash:Add(self.Worm)
						WaitFor(self.Worm)
						self:SetUnSelectable(false)
						self:SetDoNotTarget(true)
						self:AddToggleCap('RULEUTC_WeaponToggle')
						self:SetCollisionShape( 'Box', 0, 0, 0, 0, 0, 0)
						self:SetMaintenanceConsumptionInactive()
						self:AddToggleCap('RULEUTC_CloakToggle')
						self:SetScriptBit('RULEUTC_CloakToggle', false)
						self.Rotator1:Destroy()
						self:SetIntelRadius('Vision', 5)
            end
        )
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		ForkThread( function()
						self:SetMaintenanceConsumptionInactive()
						self:SetScriptBit('RULEUTC_CloakToggle', true)
						self:RemoveToggleCap('RULEUTC_CloakToggle')
						self:SetUnSelectable(true)
						local rotation = RandomFloat(0,2*math.pi)
						local size = RandomFloat(5.75,5.0)
						self.Effect1 = CreateAttachedEmitter(self,'CSKTL0320',self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(2):SetEmitterParam('LIFETIME', 200)
						self.Trash:Add(self.Effect1)
						self.Effect2 = CreateAttachedEmitter(self,'CSKTL0320',self:GetArmy(), '/effects/emitters/dust_cloud_06_emit.bp'):ScaleEmitter(5):SetEmitterParam('LIFETIME', 200):OffsetEmitter(0,-1,0)
						self:ShakeCamera(200, 1, 0, 20)
						self.Trash:Add(self.Effect2)
						CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
						self.Rotator1 = CreateRotator(self, 'Chassis', 'X', -20, 40, 0, 0)
						self.Worm = CreateSlider(self, 'Chassis', 0, 50, 0, 25)
                        self.Trash:Add(self.Worm)
						WaitFor(self.Worm)
                        self.OpenAnimManip:SetRate(0.5)
						self:SetUnSelectable(false)
						self:SetDoNotTarget(false)
						self:AddToggleCap('RULEUTC_WeaponToggle')
						self:SetCollisionShape( 'Box', 0, 1, 0, 0.9, 1.2, 0.9)
						self:AddCommandCap('RULEUCC_Attack')
						self:AddCommandCap('RULEUCC_RetaliateToggle')
						self:SetWeaponEnabledByLabel('MainGun', true)
						self:SetWeaponEnabledByLabel('Riotgun01', true)
						self:SetWeaponEnabledByLabel('Riotgun02', true)
						self:SetWeaponEnabledByLabel('GatlingGun', true)
						self:SetWeaponEnabledByLabel('MissileWeapon', true)
						self.Rotator1:Destroy()
						self.Spinner:SetTargetSpeed(0)
						self:SetIntelRadius('Vision', 26)
            end
        )
        end
    end,
}

TypeClass = CSKTL0320