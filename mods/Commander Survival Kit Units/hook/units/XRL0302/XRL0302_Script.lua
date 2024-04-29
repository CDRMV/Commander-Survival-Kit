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
				#disable death weapon
				self.unit:SetDeathWeaponEnabled(false)
				CMobileKamikazeBombWeapon.OnFire(self)
			end,
        },
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		self:SetScriptBit('RULEUTC_SpecialToggle', true)
        self:RequestRefreshUI()
    end,
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
		if bit == 7 then 
			self.AutomaticDetonationThreadHandle = self:ForkThread(self.AutomaticDetonationThread)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
		if bit == 7 then 
			KillThread(self.AutomaticDetonationThreadHandle)
        end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  

        self:DestroyAllDamageEffects()
		local army = self:GetArmy()
		
        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end

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
		local FxDeath = EffectTemplate.CMobileKamikazeBombExplosion
		for k, v in FxDeath do
            CreateEmitterAtBone(self,-2,army,v)
        end  
		DamageArea(self, self:GetPosition(), 4, 500, 'Normal', true)
		CreateDecal(self:GetPosition(), RandomFloat(0,2*math.pi), 'nuke_scorch_001_albedo', '', 'Albedo', 8, 8, 500, 500, army)
		self:CreateWreckage(overkillRatio or self.overkillRatio)
		
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,

	
	AutomaticDetonationThread = function(self)
		while not self:IsDead() do
			local unitPos = self:GetPosition()
            #Get Enemy units in the area
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 4, 'Enemy')
            for _,unit in units do
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
TypeClass = XRL0302