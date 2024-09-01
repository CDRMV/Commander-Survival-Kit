
local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit

Paracute_Dummy_02 = Class(TStructureUnit) {

		OnCreate = function (self)
			TStructureUnit.OnCreate(self)
			self:SetCollisionShape('None', 0, 0, 0, 0)
		end,

	    OnStopBeingBuilt = function(self,builder,layer)
			TStructureUnit.OnStopBeingBuilt(self,builder,layer)
			self:ForkThread(self.ChuteLands)
		end,

		ChuteLands = function (self)
			self.Manip = CreateAnimator(self)
			self.Manip:PlayAnim('/mods/Commander Survival Kit/projectiles/Parachutes/Paracute_Dummy_02/Paracute_Dummy_02_PARACHUTE_LAND_01.sca', false):SetRate(1.0)
			WaitSeconds(6)
			self:Destroy()
		end,



}

TypeClass = Paracute_Dummy_02