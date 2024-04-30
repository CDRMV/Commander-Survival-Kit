#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0304/UEL0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Heavy Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local explosion = import('/lua/defaultexplosions.lua')
local TMobileAdvancedKamikazeBombWeapon = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').TMobileAdvancedKamikazeBombWeapon
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local Weapon = import('/lua/sim/Weapon.lua').Weapon

CSKTL0302 = Class(TLandUnit) {
    Weapons = {
        
        Suicide = Class(TMobileAdvancedKamikazeBombWeapon) {   
     
			OnFire = function(self)			
				#disable death weapon
				self.unit:SetDeathWeaponEnabled(false)
				TMobileAdvancedKamikazeBombWeapon.OnFire(self)
			end,
        },
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:AddToggleCap('RULEUTC_SpecialToggle')
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
        TLandUnit.OnScriptBitSet(self, bit)
		if bit == 7 then 
			self.AutomaticDetonationThreadHandle = self:ForkThread(self.AutomaticDetonationThread)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
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
	
		CreateAttachedEmitter(self, 'Cell', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'Cell', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'Cell', 1.0)
		explosion.CreateFlash( self, 'Cell', 2.5, army )
		local FxDeath = EffectTemplate.TAPDSHit01
		local FxDeath2 = EffectTemplate.CMobileKamikazeBombExplosion
		for k, v in FxDeath do
            CreateEmitterAtBone(self,-2,army,v):ScaleEmitter(1)
        end  
		for k, v in FxDeath2 do
            CreateEmitterAtBone(self,-2,army,v):ScaleEmitter(1.5)
        end  
		DamageArea(self, self:GetPosition(), 4, 1000, 'Normal', true)
		CreateDecal(self:GetPosition(), RandomFloat(0,2*math.pi), 'nuke_scorch_002_albedo', '', 'Albedo', 8, 8, 500, 500, army)
		self:HideBone('Cell', true)
		self:CreateWreckage(overkillRatio or self.overkillRatio)
		
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
	
	
	CreateWreckage = function (self, overkillRatio)
		self:HideBone('Cell', true)
        if overkillRatio and overkillRatio > 1.0 then
            return
        end
        local bp = self.Blueprint
        local fractionComplete = self:GetFractionComplete()
        if fractionComplete < 0.5 or ((bp.TechCategory == 'EXPERIMENTAL' or bp.CategoriesHash["STRUCTURE"]) and fractionComplete < 1) then
            return
        end
        return self:CreateWreckageProp(overkillRatio)
    end,

	
	AutomaticDetonationThread = function(self)
		while not self:IsDead() do
			local unitPos = self:GetPosition()
            #Get Enemy units in the area
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 4, 'Enemy')
            for _,unit in units do
                self:GetWeaponByLabel'Suicide':FireWeapon()
				
				-- The Version Check below is required to set up the DeathThread in FAF
				-- The DeathThread Function is not playing in FAF for some Reason so this Check fix it.
				if version < 3652 then
				
				else
					LOG('FAF Detected add DeathThread')
					self.DeathThreadHandle = self:ForkThread(self.DeathThread)
				end
            end
            
            #Wait 2 seconds
            WaitSeconds(2)
		end	
    end,
}

TypeClass = CSKTL0302