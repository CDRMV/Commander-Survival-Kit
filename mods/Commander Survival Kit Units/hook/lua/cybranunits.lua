local DefaultUnits = import('/lua/defaultunits.lua')
local FactoryUnit = DefaultUnits.FactoryUnit
local StructureUnit = DefaultUnits.StructureUnit
local ModEffectUtil = import('/mods/Commander Survival Kit Units/lua/CSKUnitsEffectUtilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')
local Effects = '/mods/Commander Survival Kit Units/effects/emitters/cybran_electrofence_beam_01_emit.bp'
local Dummy = nil
local NewDummy = nil
local Effect = nil
local BeamChargeEffects = {}
local ChargeEffects01Bag = {}
--------------------------------------------------------------------------------
-- Cybran Laser Fence 
--------------------------------------------------------------------------------

CElectroFenceUnit = Class(StructureUnit) {
	OnCreate = function(self, builder, layer)
        StructureUnit.OnCreate(self, builder, layer)
		
		self:HideBone( 'Turret', true )
			
    end,


	OnStopBeingBuilt = function(self, builder, layer)
        StructureUnit.OnStopBeingBuilt(self, builder, layer)
				self:HideBone( 'Turret', true )
				local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationOpen
								self:ForkThread(function()
					 self.OpenAnim = CreateAnimator(self)
					self.OpenAnim:SetRate(3)
					self.Trash:Add(self.OpenAnim )
                    self.OpenAnim:PlayAnim(bpAnim)
					WaitFor(self.OpenAnim)
						local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LASERWALL,
			self:GetPosition(), 
			3
			
			)
            

            for _,unit in units do
			
					local buildpos = unit:GetPosition()
		local pos = self:GetPosition()
		local alpha = math.atan2 (buildpos[3] - pos[3] ,buildpos[1] - pos[1])
		local dist = VDist2(buildpos[1], buildpos[3], pos[1], pos[3])
		--LOG('Position: ', math.cos(alpha) * dist)
		--LOG('Builder Position: ', math.sin(alpha) * dist)
		
		local CheckAlpha = math.cos(alpha) * dist
		local CheckDist = math.sin(alpha) * dist
		
		if CheckAlpha < 0 and CheckDist == 2 then
		x = buildpos[1] - math.cos(alpha) * dist
		y = buildpos[3] - math.sin(alpha) * dist + 1
		Dummy = CreateUnitHPR('URBCB0201a',self:GetArmy(), x, 0, y, 0, 0, 0)
		elseif CheckAlpha < 0 and CheckDist == -2 then
		x = buildpos[1] - math.cos(alpha) * dist
		y = buildpos[3] - math.sin(alpha) * dist - 1
		Dummy = CreateUnitHPR('URBCB0201a',self:GetArmy(), x, 0, y, 0, 0, 0)
		elseif CheckAlpha == 2 and CheckDist == 0 then
		x = buildpos[1] - math.cos(alpha) * dist + 1
		y = buildpos[3] - math.sin(alpha) * dist
		Dummy = CreateUnitHPR('URBCB0201a',self:GetArmy(), x, 0, y, 0, 0, 0)
		elseif CheckAlpha == -2 and CheckDist < 0 then
		x = buildpos[1] - math.cos(alpha) * dist - 1
		y = buildpos[3] - math.sin(alpha) * dist
		Dummy = CreateUnitHPR('URBCB0201a',self:GetArmy(), x, 0, y, 0, 0, 0)
			end
		end	
		
		end)
			
    end,
	
	OnKilled = function(self)
        StructureUnit.OnKilled(self)
		local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LASERWALLDUMMY,
			self:GetPosition(), 
			2
			
			)
            

            for _,unit in units do
			if unit == nil then
			else
				unit:Destroy()
            end
			end
    end,
}

CElectroFenceDummyUnit = Class(StructureUnit) {
	OnCreate = function(self, builder, layer)
        StructureUnit.OnCreate(self, builder, layer)
		
		        self:HideBone( 0, true )
			
    end,


	OnStopBeingBuilt = function(self, builder, layer)
        StructureUnit.OnStopBeingBuilt(self, builder, layer)
		
		        self:HideBone( 0, true )
		
						local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationOpen
					self:ForkThread(function()
					 self.OpenAnim = CreateAnimator(self)
					 self.OpenAnim:SetRate(3)
					self.Trash:Add(self.OpenAnim )
                    self.OpenAnim:PlayAnim(bpAnim)
					WaitFor(self.OpenAnim)
		
		
				local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LASERWALL,
			self:GetPosition(), 
			2
			
			)
            

            for _,unit in units do
					table.insert(ChargeEffects01Bag,AttachBeamEntityToEntity(self, 'Effect1', unit, 'Effect1', self:GetArmy(), Effects ))
					table.insert(ChargeEffects01Bag,AttachBeamEntityToEntity(self, 'Effect2', unit, 'Effect2', self:GetArmy(), Effects ))
					table.insert(ChargeEffects01Bag,AttachBeamEntityToEntity(self, 'Effect3', unit, 'Effect3', self:GetArmy(), Effects ))
			end
			
			end)
			
    end,
	
	OnKilled = function(self)
        StructureUnit.OnKilled(self)
		self:Destroy()
    end,
	
	
}