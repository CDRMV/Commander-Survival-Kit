#****************************************************************************
#**
#**  File     :  /data/units/XRL0302/XRL0302_script.lua
#**  Author(s):  Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Cybran Mobile Bomb Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local Weapon = import('/lua/sim/Weapon.lua').Weapon

XRL0302 = Class(CWalkingLandUnit) {
    Weapons = {
        
        Suicide = Class(CMobileKamikazeBombWeapon) {        
			OnFire = function(self)			
				self.unit:Kill()
				CMobileKamikazeBombWeapon.OnFire(self)
			end,
        },
    },
	
	DoDeathWeapon = function(self)

    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		self:RemoveToggleCap('RULEUTC_ProductionToggle')
		if self:GetAIBrain().BrainType != 'Human' then
			LOG('AI: ADS activated') -- Activate the Automatic Detonation System for AI Support
            self:SetScriptBit('RULEUTC_SpecialToggle', true)
		else
			LOG('Human Player: ADS deactivated') -- Deactivate the Automatic Detonation System for Human Players
			self:SetScriptBit('RULEUTC_SpecialToggle', false)
        end
        self:RequestRefreshUI()
    end,
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
		if bit == 1 then
            self:GetWeaponByLabel'Suicide':OnFire()
        end
		if bit == 7 then 
			self.AutomaticDetonationThreadHandle = self:ForkThread(self.AutomaticDetonationThread)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
		if bit == 1 then
            self:GetWeaponByLabel'Suicide':OnFire()
        end
		if bit == 7 then 
			KillThread(self.AutomaticDetonationThreadHandle)
        end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
        self:DestroyAllDamageEffects()
		local army = self:GetArmy()

		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end

		CreateAttachedEmitter(self, 0, army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,0, army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 0, 1.0)
		explosion.CreateFlash( self, 0, 2.5, army )
		
		local position = self:GetPosition()
		local rotation = 6.28 * Random()
        DamageArea(self, position, 6, 1, 'TreeForce', true)
        DamageArea(self, position, 6, 1, 'TreeForce', true)
        CreateDecal(position, rotation, 'scorch_010_albedo', '', 'Albedo', 11, 11, 250, 120, army)
		self:CreateWreckage(overkillRatio or self.overkillRatio)
		
		local position = self:GetPosition()
		local Nanites = CreateUnitHPR('URFSSP05XX', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,

	
	AutomaticDetonationThread = function(self)
		while not self:IsDead() do
			local unitPos = self:GetPosition()
            #Get Enemy units in the area
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 4, 'Enemy')
            for _,unit in units do
				self:GetWeaponByLabel'Suicide':FireWeapon()
				self:Kill()
            end
            
            #Wait 2 seconds
            WaitSeconds(2)
		end	
    end,
}
TypeClass = XRL0302