local DefaultUnits = import('/lua/defaultunits.lua')
local FactoryUnit = DefaultUnits.FactoryUnit
local StructureUnit = DefaultUnits.StructureUnit
local ModEffectUtil = import('/mods/Commander Survival Kit Units/lua/CSKUnitsEffectUtilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')
local Effects = '/mods/Commander Survival Kit Units/effects/emitters/terran_fence_01_emit.bp'
local Dummy = nil
local NewDummy = nil
local Effect = nil
local BeamChargeEffects = {}
local ChargeEffects01Bag = {}
--------------------------------------------------------------------------------
-- UEF Shield Fence 
--------------------------------------------------------------------------------


TShieldFenceUnit = Class(StructureUnit) {
	OnCreate = function(self, builder, layer)
        StructureUnit.OnCreate(self, builder, layer)
		
		--self:HideBone( 'Turret', true )
			
    end,


	OnStopBeingBuilt = function(self, builder, layer)
        StructureUnit.OnStopBeingBuilt(self, builder, layer)
				--self:HideBone( 'Turret', true )
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
			categories.SHIELDWALL,
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
		Dummy = CreateUnitHPR('UEBTB0202a',self:GetArmy(), x, 0, y, 0, 0, 0)
		elseif CheckAlpha < 0 and CheckDist == -2 then
		x = buildpos[1] - math.cos(alpha) * dist
		y = buildpos[3] - math.sin(alpha) * dist - 1
		Dummy = CreateUnitHPR('UEBTB0202a',self:GetArmy(), x, 0, y, 0, 0, 0)
		elseif CheckAlpha == 2 and CheckDist == 0 then
		x = buildpos[1] - math.cos(alpha) * dist + 1
		y = buildpos[3] - math.sin(alpha) * dist
		Dummy = CreateUnitHPR('UEBTB0202a',self:GetArmy(), x, 0, y, 0, 0, 0)
		elseif CheckAlpha == -2 and CheckDist < 0 then
		x = buildpos[1] - math.cos(alpha) * dist - 1
		y = buildpos[3] - math.sin(alpha) * dist
		Dummy = CreateUnitHPR('UEBTB0202a',self:GetArmy(), x, 0, y, 0, 0, 0)
			end
		end	
		
		end)
			
    end,
	
	OnKilled = function(self)
        StructureUnit.OnKilled(self)
		local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.SHIELDWALLDUMMY,
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

TShieldFenceDummyUnit = Class(StructureUnit) {
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
			categories.SHIELDWALL,
			self:GetPosition(), 
			2
			
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
		
		if CheckAlpha < 0 and CheckDist == 1 then
		table.insert(ChargeEffects01Bag,CreateAttachedEmitter(self, 'Effect1', self:GetArmy(), Effects ):ScaleEmitter(0.3))
		--table.insert(ChargeEffects01Bag,CreateAttachedEmitter(unit, 'Effect2', self:GetArmy(), Effects ):ScaleEmitter(0.3))
		elseif CheckAlpha < 0 and CheckDist == -1 then
		table.insert(ChargeEffects01Bag,CreateAttachedEmitter(self, 'Effect2', self:GetArmy(), Effects ):ScaleEmitter(0.3))
		--table.insert(ChargeEffects01Bag,CreateAttachedEmitter(unit, 'Effect1', self:GetArmy(), Effects ):ScaleEmitter(0.3))
		elseif CheckAlpha == 1 and CheckDist == 0 then
		table.insert(ChargeEffects01Bag,CreateAttachedEmitter(self, 'Effect3', self:GetArmy(), Effects ):ScaleEmitter(0.3))
		--table.insert(ChargeEffects01Bag,CreateAttachedEmitter(unit, 'Effect3', self:GetArmy(), Effects ):ScaleEmitter(0.3))
		elseif CheckAlpha == -1 and CheckDist < 0 then
		table.insert(ChargeEffects01Bag,CreateAttachedEmitter(self, 'Effect4', self:GetArmy(), Effects ):ScaleEmitter(0.3))
		--table.insert(ChargeEffects01Bag,CreateAttachedEmitter(unit, 'Effect4', self:GetArmy(), Effects ):ScaleEmitter(0.3))
			end
			end
			
			end)
			
    end,
	
	OnKilled = function(self)
        StructureUnit.OnKilled(self)
		self:Destroy()
    end,
	
	
}


