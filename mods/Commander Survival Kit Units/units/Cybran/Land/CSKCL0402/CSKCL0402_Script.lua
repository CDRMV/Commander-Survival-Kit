#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0303/URL0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local cWeapons = import('/lua/cybranweapons.lua')
local CDFHeavyMicrowaveLaserGeneratorCom = cWeapons.CDFHeavyMicrowaveLaserGeneratorCom
local CDFHvyProtonCannonWeapon = cWeapons.CDFHvyProtonCannonWeapon
local CIFMissileLoaWeapon = cWeapons.CIFMissileLoaWeapon
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')
local utilities = import('/lua/Utilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local Entity = import('/lua/sim/Entity.lua').Entity
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone


CSKCL0402 = Class(CLandUnit) 
{
    PlayEndAnimDestructionEffects = false,

    Weapons = {
        MainGun = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},	
		MissileRack = Class(CIFMissileLoaWeapon) {},
		ParticleGun1 = Class(CDFHvyProtonCannonWeapon) {},
		ParticleGun2 = Class(CDFHvyProtonCannonWeapon) {},
		ParticleGun3 = Class(CDFHvyProtonCannonWeapon) {},
		ParticleGun4 = Class(CDFHvyProtonCannonWeapon) {},
    },
	
    
    OnStopBeingBuilt = function(self, builder, layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetWeaponEnabledByLabel('MainGun', false)
		self:SetWeaponEnabledByLabel('MissileRack', false)
		self:SetWeaponEnabledByLabel('ParticleGun1', false)
		self:SetWeaponEnabledByLabel('ParticleGun2', false)
		self:SetWeaponEnabledByLabel('ParticleGun3', false)
		self:SetWeaponEnabledByLabel('ParticleGun4', false)
		self:SetMaintenanceConsumptionInactive()
		self:SetScriptBit('RULEUTC_CloakToggle', true)
		self:RemoveToggleCap('RULEUTC_CloakToggle')
		self:SetCollisionShape( 'Box', 0, 1, 0, 0.9, 1.2, 0.9)
		--[[
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
		]]--
		local rotation = RandomFloat(0,2*math.pi)
		local size = RandomFloat(10.75,10.0)
		CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
		ForkThread( function()
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0.5)
		WaitFor(self.OpenAnimManip)
		self:SetImmobile(true)
		self:RemoveCommandCap('RULEUCC_Move')
		self:RemoveCommandCap('RULEUCC_Guard')
		self:RemoveCommandCap('RULEUCC_Patrol')
		self:SetWeaponEnabledByLabel('MainGun', true)
		self:SetWeaponEnabledByLabel('MissileRack', true)
		self:SetWeaponEnabledByLabel('ParticleGun1', true)
		self:SetWeaponEnabledByLabel('ParticleGun2', true)
		self:SetWeaponEnabledByLabel('ParticleGun3', true)
		self:SetWeaponEnabledByLabel('ParticleGun4', true)
		end
		)
    end,
	
	OnLayerChange = function(self, new, old)
        CLandUnit.OnLayerChange(self, new, old)
            if (new == 'Land') and (old != 'None') then
				self:AddToggleCap('RULEUTC_WeaponToggle')
            elseif (new == 'Seabed') then
				self:RemoveToggleCap('RULEUTC_WeaponToggle')
            end
    end,
	
	OnScriptBitSet = function(self, bit)
        CLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:SetWeaponEnabledByLabel('MainGun', false)
		self:SetWeaponEnabledByLabel('MissileRack', false)
		self:SetWeaponEnabledByLabel('ParticleGun1', false)
		self:SetWeaponEnabledByLabel('ParticleGun2', false)
		self:SetWeaponEnabledByLabel('ParticleGun3', false)
		self:SetWeaponEnabledByLabel('ParticleGun4', false)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		ForkThread( function()
						self:SetPaused(true)
						self:SetImmobile(true)
						self:SetUnSelectable(true)
						local rotation = RandomFloat(0,2*math.pi)
						local size = RandomFloat(10.75,10.0)
						self.Effect1 = CreateAttachedEmitter(self,'CSKCL0402',self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(5):SetEmitterParam('LIFETIME', 200)
						self.Trash:Add(self.Effect1)
						self.Effect2 = CreateAttachedEmitter(self,'CSKCL0402',self:GetArmy(), '/effects/emitters/dust_cloud_06_emit.bp'):ScaleEmitter(10):SetEmitterParam('LIFETIME', 200):OffsetEmitter(0,-1,0)
						self:ShakeCamera(200, 1, 0, 20)
						self.Trash:Add(self.Effect2)
						CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
						self.OpenAnimManip:SetRate(-0.5)
						WaitFor(self.OpenAnimManip)
						self.Worm = CreateSlider(self, 'B00', 0, -400, 0, 25)
                        self.Trash:Add(self.Worm)
						WaitFor(self.Worm)
						self:SetUnSelectable(false)
						self:SetDoNotTarget(true)
						self:AddCommandCap('RULEUCC_Move')
						self:AddCommandCap('RULEUCC_Guard')
						self:AddCommandCap('RULEUCC_Patrol')
						self:AddToggleCap('RULEUTC_WeaponToggle')
						self:SetImmobile(false)
						self:SetCollisionShape( 'Box', 0, 0, 0, 0, 0, 0)
						self:SetMaintenanceConsumptionInactive()
						self:AddToggleCap('RULEUTC_CloakToggle')
						self:SetScriptBit('RULEUTC_CloakToggle', false)
            end
        )
        end
    end,

    OnScriptBitClear = function(self, bit)
        CLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		ForkThread( function()
						self:SetMaintenanceConsumptionInactive()
						self:SetScriptBit('RULEUTC_CloakToggle', true)
						self:RemoveToggleCap('RULEUTC_CloakToggle')
						self:SetPaused(true)
						self:SetImmobile(true)
						self:SetUnSelectable(true)
						local rotation = RandomFloat(0,2*math.pi)
						local size = RandomFloat(10.75,10.0)
						self.Effect1 = CreateAttachedEmitter(self,'CSKCL0402',self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(5):SetEmitterParam('LIFETIME', 200)
						self.Trash:Add(self.Effect1)
						self.Effect2 = CreateAttachedEmitter(self,'CSKCL0402',self:GetArmy(), '/effects/emitters/dust_cloud_06_emit.bp'):ScaleEmitter(10):SetEmitterParam('LIFETIME', 200):OffsetEmitter(0,-1,0)
						self:ShakeCamera(200, 1, 0, 20)
						self.Trash:Add(self.Effect2)
						CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
						self.Worm = CreateSlider(self, 'B00', 0, 400, 0, 25)
                        self.Trash:Add(self.Worm)
						WaitFor(self.Worm)
                        self.OpenAnimManip:SetRate(0.5)
						WaitFor(self.OpenAnimManip)
						self:SetUnSelectable(false)
						self:SetDoNotTarget(false)
						self:RemoveCommandCap('RULEUCC_Move')
						self:RemoveCommandCap('RULEUCC_Guard')
						self:RemoveCommandCap('RULEUCC_Patrol')
						self:AddToggleCap('RULEUTC_WeaponToggle')
						self:SetCollisionShape( 'Box', 0, 1, 0, 0.9, 1.2, 0.9)
						self:AddCommandCap('RULEUCC_Attack')
						self:AddCommandCap('RULEUCC_RetaliateToggle')
						self:SetWeaponEnabledByLabel('MainGun', true)
						self:SetWeaponEnabledByLabel('MissileRack', true)
						self:SetWeaponEnabledByLabel('ParticleGun1', true)
						self:SetWeaponEnabledByLabel('ParticleGun2', true)
						self:SetWeaponEnabledByLabel('ParticleGun3', true)
						self:SetWeaponEnabledByLabel('ParticleGun4', true)
            end
        )
        end
    end,
	
	--[[
	CreateFirePlumes = function( self, army, bones, yBoneOffset )
        local proj, position, offset, velocity
        local basePosition = self:GetPosition()
        for k, vBone in bones do
            position = self:GetPosition(vBone)
            offset = utilities.GetDifferenceVector( position, basePosition )
            velocity = utilities.GetDirectionVector( position, basePosition ) # 
            velocity.x = velocity.x + utilities.GetRandomFloat(-0.3, 0.3)
            velocity.z = velocity.z + utilities.GetRandomFloat(-0.3, 0.3)
            velocity.y = velocity.y + utilities.GetRandomFloat( 0.0, 0.3)
            proj = self:CreateProjectile('/effects/entities/DestructionFirePlume01/DestructionFirePlume01_proj.bp', offset.x, offset.y + yBoneOffset, offset.z, velocity.x, velocity.y, velocity.z)
            proj:SetBallisticAcceleration(utilities.GetRandomFloat(-1, -2)):SetVelocity(utilities.GetRandomFloat(3, 4)):SetCollision(false)
            
            local emitter = CreateEmitterOnEntity(proj, army, '/effects/emitters/destruction_explosion_fire_plume_02_emit.bp')

            local lifetime = utilities.GetRandomFloat( 12, 22 )
        end
    end,
	]]--
	
	OnKilled = function(self, instigator, type, overkillRatio)
		if not self:IsBeingBuilt() then
		ForkThread( function()
		local army = self:GetArmy()
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'Head', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'Head', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'Head', 2.0)
		explosion.CreateFlash( self, 'Head', 4.5, army )
		self:HideBone("Head", true)
		--self:CreateFirePlumes( army, {'Head'}, 0 )
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'Head', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'Head', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'B13', 2.0)
		explosion.CreateFlash( self, 'B13', 4.5, army )
		self:HideBone("B13", false)
		--self:CreateFirePlumes( army, {'B13'}, 0 )
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'B13', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'B13', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'B12', 2.0)
		explosion.CreateFlash( self, 'B12', 4.5, army )
		self:HideBone("B12", false)
		--self:CreateFirePlumes( army, {'B12'}, 0 )
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'B12', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'B12', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'B11', 2.0)
		explosion.CreateFlash( self, 'B11', 4.5, army )
		self:HideBone("B11", false)
		--self:CreateFirePlumes( army, {'B11'}, 0 )
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'B11', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'B11', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'B10', 2.0)
		explosion.CreateFlash( self, 'B10', 4.5, army )
		self:HideBone("B10", false)
		--self:CreateFirePlumes( army, {'B10'}, 0 )
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'B10', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'B10', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'B09', 2.0)
		explosion.CreateFlash( self, 'B09', 4.5, army )
		self:HideBone("B09", false)
		--self:CreateFirePlumes( army, {'B09'}, 0 )
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'B09', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'B09', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'B08', 2.0)
		explosion.CreateFlash( self, 'B08', 4.5, army )
		self:HideBone("B08", false)
		--self:CreateFirePlumes( army, {'B08'}, 0 )
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'B08', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'B08', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'B07', 2.0)
		explosion.CreateFlash( self, 'B07', 4.5, army )
		self:HideBone("B07", false)
		--self:CreateFirePlumes( army, {'B07'}, 0 )
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'B07', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'B07', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'B06', 2.0)
		explosion.CreateFlash( self, 'B06', 4.5, army )
		self:HideBone("B06", false)
		--self:CreateFirePlumes( army, {'B06'}, 0 )
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'B06', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'B06', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'B05', 2.0)
		explosion.CreateFlash( self, 'B05', 4.5, army )
		self:HideBone("B05", false)
		--self:CreateFirePlumes( army, {'B05'}, 0 )
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'B05', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'B05', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'B04', 2.0)
		explosion.CreateFlash( self, 'B04', 4.5, army )
		self:HideBone("B04", false)
		--self:CreateFirePlumes( army, {'B04'}, 0 )
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'B04', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'B04', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'B03', 2.0)
		explosion.CreateFlash( self, 'B03', 4.5, army )
		self:HideBone("B03", false)
		--self:CreateFirePlumes( army, {'B03'}, 0 )
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'B03', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'B03', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'B02', 2.0)
		explosion.CreateFlash( self, 'B02', 4.5, army )
		self:HideBone("B02", false)
		--self:CreateFirePlumes( army, {'B02'}, 0 )
		WaitSeconds(1)
		CreateAttachedEmitter(self, 'B02', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'B02', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'B01', 2.0)
		explosion.CreateFlash( self, 'B01', 4.5, army )
		--self:CreateFirePlumes( army, {'B01'}, 0 )
		self:HideBone("B01", false)
		self:ForkThread(self.DeathThread, overkillRatio , instigator)
		end)
        end
    end,

}

TypeClass = CSKCL0402