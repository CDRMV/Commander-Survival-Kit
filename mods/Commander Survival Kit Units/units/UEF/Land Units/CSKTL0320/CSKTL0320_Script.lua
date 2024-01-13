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
		Riotgun02 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		MissileWeapon = Class(TIFCruiseMissileUnpackingLauncher) 
        {
            FxMuzzleFlash = {'/effects/emitters/terran_mobile_missile_launch_01_emit.bp'},
        },
    },
	
	OnStopBeingBuilt = function(self, builder, layer)
        TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetWeaponEnabledByLabel('MainGun', false)
        local Spinner = CreateRotator(self, 'Drill', 'z', nil, 0, 60, 360):SetTargetSpeed(120)
		local checkcategories = categories.ANTIUNDERGROUND
		self:ForkThread(function()
		        while self and not self.Dead do
                local pos = self:GetPosition()
                local units = self:GetAIBrain():GetUnitsAroundPoint(checkcategories, self:GetPosition(), 30, 'Enemy')
				self:AddToggleCap('RULEUTC_WeaponToggle')
                for _, unit in units do
                    if unit and not unit.Dead and unit ~= self then
						local value = unit:GetScriptBit(3)
						LOG(value)
						if value == true then
						self:AddToggleCap('RULEUTC_WeaponToggle')
						self:SetScriptBit(3, false)
						self:RemoveToggleCap('RULEUTC_WeaponToggle')
						else
						self:AddToggleCap('RULEUTC_WeaponToggle')
						self:SetScriptBit(3, true)
						self:RemoveToggleCap('RULEUTC_WeaponToggle')
						end
                    end
                end

                WaitSeconds(5)
				end	
		end)
		ForkThread( function()
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0.5)
		WaitFor(self.OpenAnimManip)
		self:SetWeaponEnabledByLabel('MainGun', true)
		end
		)
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
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
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
						self:SetWeaponEnabledByLabel('MainGun', false)
						self:SetWeaponEnabledByLabel('Riotgun01', false)
						self:SetWeaponEnabledByLabel('Riotgun02', false)
						self:SetWeaponEnabledByLabel('MissileWeapon', false)
                        self.OpenAnimManip:SetRate(-1)
						WaitFor(self.OpenAnimManip)
						self.Worm = CreateSlider(self, 'Chassis', 0, -50, 0, 25)
                        self.Trash:Add(self.Worm)
						WaitFor(self.Worm)
						self:SetUnSelectable(false)
						self:SetDoNotTarget(true)
						self:AddToggleCap('RULEUTC_WeaponToggle')
            end
        )
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
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
						self.Worm = CreateSlider(self, 'Chassis', 0, 50, 0, 25)
                        self.Trash:Add(self.Worm)
						WaitFor(self.Worm)
                        self.OpenAnimManip:SetRate(0.5)
						self:SetWeaponEnabledByLabel('MainGun', true)
						self:SetWeaponEnabledByLabel('Riotgun01', true)
						self:SetWeaponEnabledByLabel('Riotgun02', true)
						self:SetWeaponEnabledByLabel('MissileWeapon', true)
						self:SetUnSelectable(false)
						self:SetDoNotTarget(false)
						self:AddToggleCap('RULEUTC_WeaponToggle')
            end
        )
        end
    end,
}

TypeClass = CSKTL0320