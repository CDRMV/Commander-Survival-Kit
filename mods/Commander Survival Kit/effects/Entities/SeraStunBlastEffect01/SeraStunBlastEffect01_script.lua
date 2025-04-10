

local NullShell = import("/lua/sim/defaultprojectiles.lua").NullShell
local Modpath = '/mods/Commander Survival Kit/effects/emitters/'

SeraStunBlastEffect01 = Class(NullShell) {

	OnCreate = function(self)
		NullShell.OnCreate(self)
		self.Effect = CreateEmitterAtEntity( self, -1, Modpath .. 'serastun_cloud_01_emit.bp' ):ScaleEmitter(0)
		self.Effect2 = CreateEmitterAtEntity( self, -1, Modpath .. 'serastun_cloud_02_emit.bp' ):ScaleEmitter(0)
		self:ForkThread(self.EffectThread)
	end,

	EffectThread = function(self)
		local pos = self:GetPosition()
		local scale = 0.01
		local shockwavescale = 0
		local emitterscale = 0
		while true do
		local scaleChange = 100 * scale
		shockwavescale = shockwavescale + 0.05
		emitterscale = emitterscale + 0.02
		self:StunThread(shockwavescale)
		self.Effect:ScaleEmitter(emitterscale)
		self.Effect2:ScaleEmitter(emitterscale)
		DamageRing(self, pos, 0.01, shockwavescale, 1, 'Force', true, true)
		self:SetScaleVelocity(scaleChange, scaleChange, scaleChange)
		WaitSeconds(0.001)
		end

	end,
	
	StunThread = function(self, radius)
			local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK-Units" then return mod.location end end end
			local CSKUnitsPath = GetCSKUnitsPath()
            local enemyunits = nil
			if CSKUnitsPath then 	
			enemyunits = GetArmyBrain(self:GetArmy()):GetUnitsAroundPoint(
			
			categories.ALLUNITS - categories.AIR - categories.EXPERIMENTAL - categories.ELITE - categories.HERO - categories.TITAN,
			self:GetPosition(), 
			radius,
			'Enemy'
			
			)
			
			for _,unit in enemyunits do
				unit:SetStunned(30)
            end
			
			else
			enemyunits = GetArmyBrain(self:GetArmy()):GetUnitsAroundPoint(
			
			categories.ALLUNITS + categories.AIR - categories.EXPERIMENTAL,
			self:GetPosition(), 
			radius,
			'Enemy'
			
			)
			
			for _,unit in enemyunits do
				unit:SetStunned(30)
            end
			
			end

    end,
}
TypeClass = SeraStunBlastEffect01