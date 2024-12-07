#
# Terran Napalm Carpet Bomb
#
local TNapalmCarpetBombProjectile = import('/lua/terranprojectiles.lua').TNapalmCarpetBombProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local GetRandomInt = import('/lua/utilities.lua').GetRandomInt
EmtBpPath = '/effects/emitters/'
local SingleBeamProjectile = import('/lua/sim/defaultprojectiles.lua').SingleBeamProjectile
local RandF = import('/lua/utilities.lua').GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Shield = import('/lua/shield.lua').Shield
local Unit = import('/lua/sim/Unit.lua').Unit

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TConstructionUnit = import('/lua/terranunits.lua').TConstructionUnit
local TWalkingLandUnit = import('/lua/terranunits.lua').TWalkingLandUnit
local TerranWeaponFile = import('/lua/terranweapons.lua')
local Buff = import('/lua/sim/Buff.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')

MNA_PARA_LINF0000 = Class(SingleBeamProjectile) {
    
			
			
    OnCreate = function(self)
		SingleBeamProjectile.OnCreate(self)
            --local location = self:GetPosition('AttachPoint')
			--local paratrooper = CreateUnitHPR('MNA_ADIV_PARALINF0000', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
            --paratrooper:AttachTo(self, 'AttachPoint')
			--self.Manip = CreateAnimator(paratrooper)
			--self.Manip:PlayAnim('/mods/CTO/units/AU_INFANTRY_ANIMATIONS/AU_INFANTRY_ANIMATIONS_PARACHUTE_01.sca', false):SetRate(1.0)
    end,
	

	
	
	
    OnImpact = function(self, TargetType, targetEntity)	
            local location = self:GetPosition('AttachPoint')
			local chute = CreateUnitHPR('Paracute_Dummy_02', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			self.Manip:PlayAnim('/mods/Commander Survival Kit Units/projectiles/Parachutes/Parachute/Paracute_Dummy_02/Paracute_Dummy_02_PARACHUTE_LAND_01.sca', false):SetRate(1.0)	
        self:DetachAll('AttachPoint',false)
		SingleBeamProjectile.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = MNA_PARA_LINF0000
