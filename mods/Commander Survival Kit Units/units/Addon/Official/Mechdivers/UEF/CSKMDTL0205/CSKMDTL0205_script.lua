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
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

CSKMDTL0205 = Class(TLandUnit) {

    Weapons = {
        MainGun = Class(TDFRiotWeapon) {
		FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
    },

	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		BotMesh = '/mods/Commander Survival Kit Units/Decorations/T1Bot_mesh'
		self.Bot = import('/lua/sim/Entity.lua').Entity()
        self.Bot:AttachBoneTo( -1, self, 'Attachpoint' )
        self.Bot:SetMesh(BotMesh)
        self.Bot:SetDrawScale(0.0625)
        self.Bot:SetVizToAllies('Intel')
        self.Bot:SetVizToNeutrals('Intel')
        self.Bot:SetVizToEnemies('Intel')
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		self.Bot:Destroy()
        self:DestroyAllDamageEffects()
		local army = self:GetArmy()

		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		
		self:CreateWreckage(overkillRatio or self.overkillRatio)
		local RandomNumber = math.random(1, 2)
		if RandomNumber == 2 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		local Nanites = CreateUnitHPR('UEL0106', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		end
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
	
}

TypeClass = CSKMDTL0205