#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2301/UEB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local TDFLightningBeam = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').TDFLightningBeam
local cWeapons = import('/lua/cybranweapons.lua')
local CDFLaserHeavyWeapon = cWeapons.CDFLaserHeavyWeapon
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
EmtBpPath = '/effects/emitters/'
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

UEBTB0400 = Class(TStructureUnit) {
	SphereEffectActiveMesh = '/effects/entities/Shield01/Shield01_mesh',
    Weapons = {
        LightningBeam = Class(TDFLightningBeam) {
	IdleState = State(TDFLightningBeam.IdleState) {
        Main = function(self)
            TDFLightningBeam.IdleState.Main(self)
        end,

        OnGotTarget = function(self)
            TDFLightningBeam.IdleState.OnGotTarget(self)
		 	self.BeamEffect1 = AttachBeamEntityToEntity(self.unit, 'Effect_B02_1', self.unit, 'Effect13', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect2 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B02_3', self.unit, 'Effect16', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect3 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B02_5', self.unit, 'Effect14', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect4 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B02_7', self.unit, 'Effect15', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
			self.BeamEffect5 = AttachBeamEntityToEntity(self.unit, 'Effect_B03_1', self.unit, 'Effect09', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect6 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B03_3', self.unit, 'Effect10', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect7 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B03_5', self.unit, 'Effect12', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect8 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B03_7', self.unit, 'Effect11', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect9 = AttachBeamEntityToEntity(self.unit, 'Effect07', self.unit, 'Muzzle7', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect10 = AttachBeamEntityToEntity(self.unit, 'Effect08', self.unit, 'Muzzle8', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect11 = AttachBeamEntityToEntity(self.unit, 'Effect05.002', self.unit, 'Muzzle6', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect12 = AttachBeamEntityToEntity(self.unit, 'Effect05', self.unit, 'Muzzle5', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')	
		self.BeamEffect13 = AttachBeamEntityToEntity(self.unit, 'Effect09', self.unit, 'Effect01', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect14 = AttachBeamEntityToEntity(self.unit, 'Effect10', self.unit, 'Effect02', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect15 = AttachBeamEntityToEntity(self.unit, 'Effect12', self.unit, 'Effect04', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect16 = AttachBeamEntityToEntity(self.unit, 'Effect11', self.unit, 'Effect03', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')	
		self.BeamEffect17 = AttachBeamEntityToEntity(self.unit, 'Effect13', self.unit, 'Effect05', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect18 = AttachBeamEntityToEntity(self.unit, 'Effect14', self.unit, 'Effect05.002', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect19 = AttachBeamEntityToEntity(self.unit, 'Effect15', self.unit, 'Effect07', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect20 = AttachBeamEntityToEntity(self.unit, 'Effect16', self.unit, 'Effect08', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect21 = AttachBeamEntityToEntity(self.unit, 'Effect01', self.unit, 'Muzzle1', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect22 = AttachBeamEntityToEntity(self.unit, 'Effect02', self.unit, 'Muzzle2', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect23 = AttachBeamEntityToEntity(self.unit, 'Effect04', self.unit, 'Muzzle4', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect24 = AttachBeamEntityToEntity(self.unit, 'Effect03', self.unit, 'Muzzle3', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
        end,
    },
	
	OnLostTarget = function(self)
		TDFLightningBeam.OnLostTarget(self)
			if self.BeamEffect1 == nil then
		
			else
				self.BeamEffect1:Destroy()
			end
			if self.BeamEffect2 == nil then
		
			else
				self.BeamEffect2:Destroy()
			end
			if self.BeamEffect3 == nil then
		
			else
				self.BeamEffect3:Destroy()
			end
			if self.BeamEffect4 == nil then
		
			else
				self.BeamEffect4:Destroy()
			end
			if self.BeamEffect5 == nil then
		
			else
				self.BeamEffect5:Destroy()
			end
			if self.BeamEffect6 == nil then
		
			else
				self.BeamEffect6:Destroy()
			end
			if self.BeamEffect7 == nil then
		
			else
				self.BeamEffect7:Destroy()
			end
			if self.BeamEffect8 == nil then
		
			else
				self.BeamEffect8:Destroy()
			end
			if self.BeamEffect9 == nil then
		
			else
				self.BeamEffect9:Destroy()
			end
			if self.BeamEffect10 == nil then
		
			else
				self.BeamEffect10:Destroy()
			end
			if self.BeamEffect11 == nil then
		
			else
				self.BeamEffect11:Destroy()
			end
			if self.BeamEffect12 == nil then
		
			else
				self.BeamEffect12:Destroy()
			end
			if self.BeamEffect13 == nil then
		
			else
				self.BeamEffect13:Destroy()
			end
			if self.BeamEffect14 == nil then
		
			else
				self.BeamEffect14:Destroy()
			end
			if self.BeamEffect15 == nil then
		
			else
				self.BeamEffect15:Destroy()
			end
			if self.BeamEffect16 == nil then
		
			else
				self.BeamEffect16:Destroy()
			end
			if self.BeamEffect17 == nil then
		
			else
				self.BeamEffect17:Destroy()
			end
			if self.BeamEffect18 == nil then
		
			else
				self.BeamEffect18:Destroy()
			end
			if self.BeamEffect19 == nil then
		
			else
				self.BeamEffect19:Destroy()
			end
			if self.BeamEffect20 == nil then
		
			else
				self.BeamEffect20:Destroy()
			end
			if self.BeamEffect21 == nil then
		
			else
				self.BeamEffect21:Destroy()
			end
			if self.BeamEffect22 == nil then
		
			else
				self.BeamEffect22:Destroy()
			end
			if self.BeamEffect23 == nil then
		
			else
				self.BeamEffect23:Destroy()
			end
			if self.BeamEffect24 == nil then
		
			else
				self.BeamEffect24:Destroy()
			end
    end, 
		
		}, 
		
	AAPhasonBeam = Class(TDFLightningBeam) {

	IdleState = State(TDFLightningBeam.IdleState) {
        Main = function(self)
            TDFLightningBeam.IdleState.Main(self)
        end,

        OnGotTarget = function(self)
            TDFLightningBeam.IdleState.OnGotTarget(self)
		 	self.BeamEffect1 = AttachBeamEntityToEntity(self.unit, 'Effect_B02_1', self.unit, 'Effect13', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect2 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B02_3', self.unit, 'Effect16', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect3 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B02_5', self.unit, 'Effect14', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect4 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B02_7', self.unit, 'Effect15', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
			self.BeamEffect5 = AttachBeamEntityToEntity(self.unit, 'Effect_B03_1', self.unit, 'Effect09', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect6 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B03_3', self.unit, 'Effect10', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect7 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B03_5', self.unit, 'Effect12', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect8 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B03_7', self.unit, 'Effect11', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect9 = AttachBeamEntityToEntity(self.unit, 'Effect07', self.unit, 'Muzzle7', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect10 = AttachBeamEntityToEntity(self.unit, 'Effect08', self.unit, 'Muzzle8', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect11 = AttachBeamEntityToEntity(self.unit, 'Effect05.002', self.unit, 'Muzzle6', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect12 = AttachBeamEntityToEntity(self.unit, 'Effect05', self.unit, 'Muzzle5', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')	
		self.BeamEffect13 = AttachBeamEntityToEntity(self.unit, 'Effect09', self.unit, 'Effect01', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect14 = AttachBeamEntityToEntity(self.unit, 'Effect10', self.unit, 'Effect02', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect15 = AttachBeamEntityToEntity(self.unit, 'Effect12', self.unit, 'Effect04', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect16 = AttachBeamEntityToEntity(self.unit, 'Effect11', self.unit, 'Effect03', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')	
		self.BeamEffect17 = AttachBeamEntityToEntity(self.unit, 'Effect13', self.unit, 'Effect05', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect18 = AttachBeamEntityToEntity(self.unit, 'Effect14', self.unit, 'Effect05.002', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect19 = AttachBeamEntityToEntity(self.unit, 'Effect15', self.unit, 'Effect07', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect20 = AttachBeamEntityToEntity(self.unit, 'Effect16', self.unit, 'Effect08', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect21 = AttachBeamEntityToEntity(self.unit, 'Effect01', self.unit, 'Muzzle1', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect22 = AttachBeamEntityToEntity(self.unit, 'Effect02', self.unit, 'Muzzle2', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect23 = AttachBeamEntityToEntity(self.unit, 'Effect04', self.unit, 'Muzzle4', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect24 = AttachBeamEntityToEntity(self.unit, 'Effect03', self.unit, 'Muzzle3', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
        end,
    },
	
	OnLostTarget = function(self)
		TDFLightningBeam.OnLostTarget(self)
			if self.BeamEffect1 == nil then
		
			else
				self.BeamEffect1:Destroy()
			end
			if self.BeamEffect2 == nil then
		
			else
				self.BeamEffect2:Destroy()
			end
			if self.BeamEffect3 == nil then
		
			else
				self.BeamEffect3:Destroy()
			end
			if self.BeamEffect4 == nil then
		
			else
				self.BeamEffect4:Destroy()
			end
			if self.BeamEffect5 == nil then
		
			else
				self.BeamEffect5:Destroy()
			end
			if self.BeamEffect6 == nil then
		
			else
				self.BeamEffect6:Destroy()
			end
			if self.BeamEffect7 == nil then
		
			else
				self.BeamEffect7:Destroy()
			end
			if self.BeamEffect8 == nil then
		
			else
				self.BeamEffect8:Destroy()
			end
			if self.BeamEffect9 == nil then
		
			else
				self.BeamEffect9:Destroy()
			end
			if self.BeamEffect10 == nil then
		
			else
				self.BeamEffect10:Destroy()
			end
			if self.BeamEffect11 == nil then
		
			else
				self.BeamEffect11:Destroy()
			end
			if self.BeamEffect12 == nil then
		
			else
				self.BeamEffect12:Destroy()
			end
			if self.BeamEffect13 == nil then
		
			else
				self.BeamEffect13:Destroy()
			end
			if self.BeamEffect14 == nil then
		
			else
				self.BeamEffect14:Destroy()
			end
			if self.BeamEffect15 == nil then
		
			else
				self.BeamEffect15:Destroy()
			end
			if self.BeamEffect16 == nil then
		
			else
				self.BeamEffect16:Destroy()
			end
			if self.BeamEffect17 == nil then
		
			else
				self.BeamEffect17:Destroy()
			end
			if self.BeamEffect18 == nil then
		
			else
				self.BeamEffect18:Destroy()
			end
			if self.BeamEffect19 == nil then
		
			else
				self.BeamEffect19:Destroy()
			end
			if self.BeamEffect20 == nil then
		
			else
				self.BeamEffect20:Destroy()
			end
			if self.BeamEffect21 == nil then
		
			else
				self.BeamEffect21:Destroy()
			end
			if self.BeamEffect22 == nil then
		
			else
				self.BeamEffect22:Destroy()
			end
			if self.BeamEffect23 == nil then
		
			else
				self.BeamEffect23:Destroy()
			end
			if self.BeamEffect24 == nil then
		
			else
				self.BeamEffect24:Destroy()
			end
    end, 
		
		}, 
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetWeaponEnabledByLabel('AAPhasonBeam', false)
		self:EnableShield()
        self.Effect1 = CreateAttachedEmitter(self,'Effect1',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(2.0)
        self.Trash:Add(self.Effecct1)
		self.Effect2 = CreateAttachedEmitter(self,'Effect2',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(2.0)
        self.Trash:Add(self.Effecct2)
		self.Effect3 = CreateAttachedEmitter(self,'Effect3',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(2.0)
        self.Trash:Add(self.Effecct1)
		self.Effect4 = CreateAttachedEmitter(self,'Effect2',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(2.0)
        self.Trash:Add(self.Effecct4)
		self.Effect5 = CreateAttachedEmitter(self,'Effect_B02_1',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct5)
		self.Effect6 = CreateAttachedEmitter(self,'Effect_B02_3',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct6)
		self.Effect7 = CreateAttachedEmitter(self,'Effect_B02_5',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct7)
		self.Effect8 = CreateAttachedEmitter(self,'Effect_B02_7',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct8)
		self.Effect9 = CreateAttachedEmitter(self,'Effect_B03_1',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct9)
		self.Effect10 = CreateAttachedEmitter(self,'Effect_B03_3',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct10)
		self.Effect11 = CreateAttachedEmitter(self,'Effect_B03_5',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct11)
		self.Effect12 = CreateAttachedEmitter(self,'Effect_B03_7',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct12)
    end,
	
	OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
		local value = 0
		if bit == 0 then 
			if value == 0 then
				value = 1
			else
			self:EnableShield()
			local Interval = 0
			local Size = 0
			local Radius = 1
			local army = self:GetAIBrain()
			local bp = self:GetBlueprint()
			self:ForkThread(function()
				SphereEffectEntity1 = import('/lua/sim/Entity.lua').Entity()
				SphereEffectEntity1:AttachBoneTo( -1, self, 'Effect2' )
				SphereEffectEntity1:SetMesh(self.SphereEffectActiveMesh)
				while Interval < 31 do
					WaitSeconds(0.01)
					if Interval == 30 then
						Interval = 0
						Size = 0
						Radius = 1
						DamageArea(self, self:GetPosition(), Radius, 1, 'Fire', false)
						DamageArea(self, self:GetPosition(), Radius, 1, 'Stun', false)
						SphereEffectEntity1:SetDrawScale(Size)
						break
					else
						Size = Size + 2
						SphereEffectEntity1:SetDrawScale(Size)
						DamageArea(self, self:GetPosition(), Radius, 15, 'Fire', false)
						DamageArea(self, self:GetPosition(), Radius, 15, 'Stun', false)
						Interval = Interval + 1
						Radius = Radius + 1
					end
				end
				SphereEffectEntity1:SetVizToAllies('Intel')
				SphereEffectEntity1:SetVizToNeutrals('Intel')
				SphereEffectEntity1:SetVizToEnemies('Intel')
				self.Trash:Add(self.SphereEffectEntity1)
			end)
			end
		end
        if bit == 1 then 
		ForkThread( function()
		self:SetWeaponEnabledByLabel('LightningBeam', false)
		self:SetWeaponEnabledByLabel('AAPhasonBeam', true)
		self:GetWeaponManipulatorByLabel('LightningBeam'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('AAPhasonBeam'):GetHeadingPitch() )
            end
        )
        end
    end,

    OnScriptBitClear = function(self, bit)
        TStructureUnit.OnScriptBitClear(self, bit)
		if bit == 0 then 
			self:EnableShield()
			local Interval = 0
			local Size = 0
			local Radius = 1
			local army = self:GetAIBrain()
			local bp = self:GetBlueprint()
			self:ForkThread(function()
				SphereEffectEntity1 = import('/lua/sim/Entity.lua').Entity()
				SphereEffectEntity1:AttachBoneTo( -1, self, 'Effect2' )
				SphereEffectEntity1:SetMesh(self.SphereEffectActiveMesh)
				while Interval < 31 do
					WaitSeconds(0.01)
					if Interval == 30 then
						Interval = 0
						Size = 0
						Radius = 1
						DamageArea(self, self:GetPosition(), Radius, 1, 'Fire', false)
						DamageArea(self, self:GetPosition(), Radius, 1, 'Stun', false)
						SphereEffectEntity1:SetDrawScale(Size)
						break
					else
						Size = Size + 2
						SphereEffectEntity1:SetDrawScale(Size)
						DamageArea(self, self:GetPosition(), Radius, 15, 'Fire', false)
						DamageArea(self, self:GetPosition(), Radius, 15, 'Stun', false)
						Interval = Interval + 1
						Radius = Radius + 1
					end
				end
				SphereEffectEntity1:SetVizToAllies('Intel')
				SphereEffectEntity1:SetVizToNeutrals('Intel')
				SphereEffectEntity1:SetVizToEnemies('Intel')
				self.Trash:Add(self.SphereEffectEntity1)
			end)
		end
        if bit == 1 then 
		ForkThread( function()
		self:SetWeaponEnabledByLabel('LightningBeam', true)
		self:SetWeaponEnabledByLabel('AAPhasonBeam', false)
		self:GetWeaponManipulatorByLabel('AAPhasonBeam'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('LightningBeam'):GetHeadingPitch() )
            end
        )
        end
    end,
	
	FxImpactLand = {
	EmtBpPath .. 'uef_t2_artillery_hit_01_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_02_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_03_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_04_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_05_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_06_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_07_emit.bp',
	},
	
	DeathThread = function( self, overkillRatio , instigator)  
		local army = self:GetArmy()
		if SphereEffectEntity1 then
		SphereEffectEntity1:Destroy()
		end
		
						for e, effect in self.FxImpactLand do 
				CreateEmitterAtEntity(self, army, effect):ScaleEmitter(0.5)
				end
    explosion.CreateFlash( self, 0, 1, army )
	DamageArea(self, self:GetPosition(), 1, 750, 'Fire', false, true)
	        local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
	        CreateDecal(position, orientation, 'Scorch_010_albedo', '', 'Albedo', 2, 2, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 2, 2, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 2, 2, 500, 600, army)
        self:DestroyAllDamageEffects()

        self:DestroyAllDamageEffects()
        self:CreateWreckage( overkillRatio )
		
		
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
}

TypeClass = UEBTB0400