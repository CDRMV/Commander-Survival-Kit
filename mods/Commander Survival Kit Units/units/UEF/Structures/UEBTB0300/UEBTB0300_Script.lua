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

UEBTB0300 = Class(TStructureUnit) {
    Weapons = {
        PhasonBeam = Class(TDFLightningBeam) {
		    OnWeaponFired = function(self)
                TDFLightningBeam.OnWeaponFired(self)
                local wep = self.unit:GetWeaponByLabel('StunWeapon')
                self.targetaquired = self:GetCurrentTargetPos()
                if self.targetaquired then
                    wep:SetTargetGround(self.targetaquired)
                    self.unit:SetWeaponEnabledByLabel('StunWeapon', true)
                    wep:SetTargetGround(self.targetaquired)
                    wep:OnFire()
                end
            end,
	IdleState = State(TDFLightningBeam.IdleState) {
        Main = function(self)
            TDFLightningBeam.IdleState.Main(self)
        end,

        OnGotTarget = function(self)
            TDFLightningBeam.IdleState.OnGotTarget(self)
		 	self.BeamEffect1 = AttachBeamEntityToEntity(self.unit, 'Effect_B02_1', self.unit, 'Effect05', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect2 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B02_3', self.unit, 'Effect08', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect3 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B02_5', self.unit, 'Effect05.002', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect4 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B02_7', self.unit, 'Effect07', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect5 = AttachBeamEntityToEntity(self.unit, 'Effect07', self.unit, 'Muzzle7', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect6 = AttachBeamEntityToEntity(self.unit, 'Effect08', self.unit, 'Muzzle8', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect7 = AttachBeamEntityToEntity(self.unit, 'Effect05.002', self.unit, 'Muzzle6', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect8 = AttachBeamEntityToEntity(self.unit, 'Effect05', self.unit, 'Muzzle5', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')	
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
    end, 
		
		}, 
		
		AAPhasonBeam = Class(TDFLightningBeam) {
		IdleState = State(TDFLightningBeam.IdleState) {
        Main = function(self)
            TDFLightningBeam.IdleState.Main(self)
        end,

        OnGotTarget = function(self)
            TDFLightningBeam.IdleState.OnGotTarget(self)
		 	self.BeamEffect1 = AttachBeamEntityToEntity(self.unit, 'Effect_B02_1', self.unit, 'Effect05', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect2 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B02_3', self.unit, 'Effect08', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect3 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B02_5', self.unit, 'Effect05.002', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		 	self.BeamEffect4 = 	AttachBeamEntityToEntity(self.unit, 'Effect_B02_7', self.unit, 'Effect07', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect5 = AttachBeamEntityToEntity(self.unit, 'Effect07', self.unit, 'Muzzle7', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect6 = AttachBeamEntityToEntity(self.unit, 'Effect08', self.unit, 'Muzzle8', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect7 = AttachBeamEntityToEntity(self.unit, 'Effect05.002', self.unit, 'Muzzle6', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.BeamEffect8 = AttachBeamEntityToEntity(self.unit, 'Effect05', self.unit, 'Muzzle5', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')	
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
    end, 
		
		},
		StunWeapon = Class(CDFLaserHeavyWeapon){
            OnWeaponFired = function(self)
                CDFLaserHeavyWeapon.OnWeaponFired(self)
                self:SetWeaponEnabled(false)
            end,
        },
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetWeaponEnabledByLabel('AAPhasonBeam', false)
        self.Effect1 = CreateAttachedEmitter(self,'Effect1',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(2.0)
        self.Trash:Add(self.Effecct1)
		self.Effect2 = CreateAttachedEmitter(self,'Effect2',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(2.0)
        self.Trash:Add(self.Effecct2)
		self.Effect3 = CreateAttachedEmitter(self,'Effect_B02_1',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct3)
		self.Effect4 = CreateAttachedEmitter(self,'Effect_B02_3',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct4)
		self.Effect4 = CreateAttachedEmitter(self,'Effect_B02_5',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct4)
		self.Effect4 = CreateAttachedEmitter(self,'Effect_B02_7',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct4)
    end,
	
	OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		ForkThread( function()
		self:SetWeaponEnabledByLabel('PhasonBeam', false)
		self:SetWeaponEnabledByLabel('AAPhasonBeam', true)
		self:GetWeaponManipulatorByLabel('PhasonBeam'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('AAPhasonBeam'):GetHeadingPitch() )
            end
        )
        end
    end,

    OnScriptBitClear = function(self, bit)
        TStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		ForkThread( function()
		self:SetWeaponEnabledByLabel('PhasonBeam', true)
		self:SetWeaponEnabledByLabel('AAPhasonBeam', false)
		self:GetWeaponManipulatorByLabel('AAPhasonBeam'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('PhasonBeam'):GetHeadingPitch() )
            end
        )
        end
    end,
}

TypeClass = UEBTB0300