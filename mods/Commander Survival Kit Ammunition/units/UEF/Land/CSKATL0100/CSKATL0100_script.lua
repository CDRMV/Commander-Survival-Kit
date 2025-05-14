#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0111/UEL0111_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Missile Launcher Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local AIUtils = import('/lua/ai/aiutilities.lua')
local TAmunitionWeapon = import('/mods/Commander Survival Kit Ammunition/lua/CSKAmmunitionWeapons.lua').TAmunitionWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone

CSKATL0100 = Class(TLandUnit) {

    Weapons = {
        
        Death = Class(TAmunitionWeapon) {   
     
			OnFire = function(self)			
				self.unit:Kill()
				TAmunitionWeapon.OnFire(self)
			end,
        },
    },

	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		AmmunitionMesh = '/mods/Commander Survival Kit Ammunition/Decorations/UEF/Ammunition_mesh'
		self.AmmunitionStorage = self:GetBlueprint().Economy.Ammunition.AmmunitionStorage
		self.MaxAmmunitionStorage = self:GetBlueprint().Economy.Ammunition.MaxAmmunitionStorage
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		self.Ammunition01 = import('/lua/sim/Entity.lua').Entity()
        self.Ammunition01:AttachBoneTo( -1, self, 'Ammunition1' )
        self.Ammunition01:SetMesh(AmmunitionMesh)
        self.Ammunition01:SetDrawScale(0.13)
        self.Ammunition01:SetVizToAllies('Intel')
        self.Ammunition01:SetVizToNeutrals('Intel')
        self.Ammunition01:SetVizToEnemies('Intel')
		self.Ammunition02 = import('/lua/sim/Entity.lua').Entity()
        self.Ammunition02:AttachBoneTo( -1, self, 'Ammunition2' )
        self.Ammunition02:SetMesh(AmmunitionMesh)
        self.Ammunition02:SetDrawScale(0.13)
        self.Ammunition02:SetVizToAllies('Intel')
        self.Ammunition02:SetVizToNeutrals('Intel')
        self.Ammunition02:SetVizToEnemies('Intel')
    end,
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self.AmmoRefuelThread = self:ForkThread(self.UnitsNeedsAmmoThread)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		KillThread(self.AmmoRefuelThread)
        end
    end,

	UnitsNeedsAmmoThread = function(self)
		while not self:IsDead() do
			local number = 0
            local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LAND + categories.MOBILE - categories.AMMUNITIONREFUELUNIT,
			self:GetPosition(), 
			15
			
			)
            for _,unit in units do
			if unit.CurrentAmmunition == nil and unit.MaxAmmunition == nil then
			
			else
			if self.AmmunitionStorage == 0 then 
			self:SetScriptBit('RULEUTC_WeaponToggle', false)
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self.Ammunition01:Destroy()
			else
			if unit.CurrentAmmunition < unit.MaxAmmunition then
			if self.AmmunitionStorage <= 75 and self.AmmunitionStorage >= 0 then 
			self.Ammunition02:Destroy()
			end
			unit.CurrentAmmunition = unit.CurrentAmmunition + 1
			Sync.CurrentAmmunition = unit.CurrentAmmunition
			self.AmmunitionStorage = self.AmmunitionStorage - 1
			Sync.CurrentAmmunitionStorage = self.AmmunitionStorage
			if number == 0 then
			FloatingEntityText(self:GetEntityId(), tostring(self.AmmunitionStorage) ..'/' .. tostring(self.MaxAmmunitionStorage))
			number = 1
			end
			end
			end
			end
			end
		WaitSeconds(1)	
		end	
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
        self:DestroyAllDamageEffects()
		local army = self:GetArmy()
		if self.AmmunitionStorage == 0 then 

		else
		self.Ammunition01:Destroy()
		self.Ammunition02:Destroy()
		CreateAttachedEmitter(self, 0, army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,0, army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 0, 1.0)
		explosion.CreateFlash( self, 0, 2.5, army )
		local FxDeath = EffectTemplate.TAPDSHit01
		local FxDeath2 = EffectTemplate.CMobileKamikazeBombExplosion
		for k, v in FxDeath do
            CreateEmitterAtBone(self,-2,army,v):ScaleEmitter(1)
        end  
		for k, v in FxDeath2 do
            CreateEmitterAtBone(self,-2,army,v):ScaleEmitter(1.5)
        end  
		
		local position = self:GetPosition()
		local rotation = 6.28 * Random()
        DamageArea(self, position, 6, 1, 'TreeForce', true)
        DamageArea(self, position, 6, 1, 'TreeForce', true)
        CreateDecal(position, rotation, 'scorch_010_albedo', '', 'Albedo', 11, 11, 250, 120, army)
		self:GetWeaponByLabel'Death':FireWeapon()
		end
		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		

		self:CreateWreckage(overkillRatio or self.overkillRatio)

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
}

TypeClass = CSKATL0100