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
local AIUtils = import('/lua/ai/aiutilities.lua')
local TAmunitionWeapon = import('/mods/Commander Survival Kit Ammunition/lua/CSKAmmunitionWeapons.lua').TAmunitionWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone

CSKATL0300 = Class(TLandUnit) {

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
		self.Ammunition03 = import('/lua/sim/Entity.lua').Entity()
        self.Ammunition03:AttachBoneTo( -1, self, 'Ammunition3' )
        self.Ammunition03:SetMesh(AmmunitionMesh)
        self.Ammunition03:SetDrawScale(0.13)
        self.Ammunition03:SetVizToAllies('Intel')
        self.Ammunition03:SetVizToNeutrals('Intel')
        self.Ammunition03:SetVizToEnemies('Intel')
		self.Ammunition04 = import('/lua/sim/Entity.lua').Entity()
        self.Ammunition04:AttachBoneTo( -1, self, 'Ammunition4' )
        self.Ammunition04:SetMesh(AmmunitionMesh)
        self.Ammunition04:SetDrawScale(0.13)
        self.Ammunition04:SetVizToAllies('Intel')
        self.Ammunition04:SetVizToNeutrals('Intel')
        self.Ammunition04:SetVizToEnemies('Intel')
		self.Ammunition05 = import('/lua/sim/Entity.lua').Entity()
        self.Ammunition05:AttachBoneTo( -1, self, 'Ammunition5' )
        self.Ammunition05:SetMesh(AmmunitionMesh)
        self.Ammunition05:SetDrawScale(0.13)
        self.Ammunition05:SetVizToAllies('Intel')
        self.Ammunition05:SetVizToNeutrals('Intel')
        self.Ammunition05:SetVizToEnemies('Intel')
		self.Ammunition06 = import('/lua/sim/Entity.lua').Entity()
        self.Ammunition06:AttachBoneTo( -1, self, 'Ammunition6' )
        self.Ammunition06:SetMesh(AmmunitionMesh)
        self.Ammunition06:SetDrawScale(0.13)
        self.Ammunition06:SetVizToAllies('Intel')
        self.Ammunition06:SetVizToNeutrals('Intel')
        self.Ammunition06:SetVizToEnemies('Intel')
		self.Ammunition07 = import('/lua/sim/Entity.lua').Entity()
        self.Ammunition07:AttachBoneTo( -1, self, 'Ammunition7' )
        self.Ammunition07:SetMesh(AmmunitionMesh)
        self.Ammunition07:SetDrawScale(0.13)
        self.Ammunition07:SetVizToAllies('Intel')
        self.Ammunition07:SetVizToNeutrals('Intel')
        self.Ammunition07:SetVizToEnemies('Intel')
		self.Ammunition08 = import('/lua/sim/Entity.lua').Entity()
        self.Ammunition08:AttachBoneTo( -1, self, 'Ammunition8' )
        self.Ammunition08:SetMesh(AmmunitionMesh)
        self.Ammunition08:SetDrawScale(0.13)
        self.Ammunition08:SetVizToAllies('Intel')
        self.Ammunition08:SetVizToNeutrals('Intel')
        self.Ammunition08:SetVizToEnemies('Intel')
		self.Ammunition09 = import('/lua/sim/Entity.lua').Entity()
        self.Ammunition09:AttachBoneTo( -1, self, 'Ammunition9' )
        self.Ammunition09:SetMesh(AmmunitionMesh)
        self.Ammunition09:SetDrawScale(0.13)
        self.Ammunition09:SetVizToAllies('Intel')
        self.Ammunition09:SetVizToNeutrals('Intel')
        self.Ammunition09:SetVizToEnemies('Intel')
		self.Ammunition010 = import('/lua/sim/Entity.lua').Entity()
        self.Ammunition010:AttachBoneTo( -1, self, 'Ammunition10' )
        self.Ammunition010:SetMesh(AmmunitionMesh)
        self.Ammunition010:SetDrawScale(0.13)
        self.Ammunition010:SetVizToAllies('Intel')
        self.Ammunition010:SetVizToNeutrals('Intel')
        self.Ammunition010:SetVizToEnemies('Intel')
		self.Ammunition011 = import('/lua/sim/Entity.lua').Entity()
        self.Ammunition011:AttachBoneTo( -1, self, 'Ammunition11' )
        self.Ammunition011:SetMesh(AmmunitionMesh)
        self.Ammunition011:SetDrawScale(0.13)
        self.Ammunition011:SetVizToAllies('Intel')
        self.Ammunition011:SetVizToNeutrals('Intel')
        self.Ammunition011:SetVizToEnemies('Intel')
		self.Ammunition012 = import('/lua/sim/Entity.lua').Entity()
        self.Ammunition012:AttachBoneTo( -1, self, 'Ammunition12' )
        self.Ammunition012:SetMesh(AmmunitionMesh)
        self.Ammunition012:SetDrawScale(0.13)
        self.Ammunition012:SetVizToAllies('Intel')
        self.Ammunition012:SetVizToNeutrals('Intel')
        self.Ammunition012:SetVizToEnemies('Intel')
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
			if self.AmmunitionStorage <= 495 and self.AmmunitionStorage >= 450 then 
			self.Ammunition012:Destroy()
			end
			if self.AmmunitionStorage <= 450 and self.AmmunitionStorage >= 405 then 
			self.Ammunition011:Destroy()
			end
			if self.AmmunitionStorage <= 405 and self.AmmunitionStorage >= 360 then 
			self.Ammunition010:Destroy()
			end
			if self.AmmunitionStorage <= 360 and self.AmmunitionStorage >= 315  then 
			self.Ammunition09:Destroy()
			end
			if self.AmmunitionStorage <= 315 and self.AmmunitionStorage >= 270 then 
			self.Ammunition08:Destroy()
			end
			if self.AmmunitionStorage <= 270 and self.AmmunitionStorage >= 225 then 
			self.Ammunition07:Destroy()
			end
			if self.AmmunitionStorage <= 225 and self.AmmunitionStorage >= 180  then 
			self.Ammunition06:Destroy()
			end
			if self.AmmunitionStorage <= 180 and self.AmmunitionStorage >= 135 then 
			self.Ammunition05:Destroy()
			end
			if self.AmmunitionStorage <= 135 and self.AmmunitionStorage >= 90 then 
			self.Ammunition04:Destroy()
			end
			if self.AmmunitionStorage <= 90 and self.AmmunitionStorage >= 45  then 
			self.Ammunition03:Destroy()
			end
			if self.AmmunitionStorage <= 45 and self.AmmunitionStorage >= 0 then 
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
		self.Ammunition03:Destroy()
		self.Ammunition04:Destroy()
		self.Ammunition05:Destroy()
		self.Ammunition06:Destroy()
		self.Ammunition07:Destroy()
		self.Ammunition08:Destroy()
		self.Ammunition09:Destroy()
		self.Ammunition010:Destroy()
		self.Ammunition011:Destroy()
		self.Ammunition012:Destroy()
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

TypeClass = CSKATL0300