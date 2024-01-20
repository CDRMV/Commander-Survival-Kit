local DefaultUnits = import('/lua/defaultunits.lua')
local FactoryUnit = DefaultUnits.FactoryUnit
local StructureUnit = DefaultUnits.StructureUnit
local ModEffectUtil = import('/mods/Commander Survival Kit Units/lua/CSKUnitsEffectUtilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')
local Effects = '/mods/Commander Survival Kit Units/effects/emitters/aeon_laserfence_beam_01_emit.bp'
local Dummy = nil
local Effect = nil
local BeamChargeEffects = {}
local ChargeEffects01Bag = {}
--------------------------------------------------------------------------------
-- Aeon Laser Fence 

-- Note:
-- I have added an function to recolour the Laser Beam Effect
-- However it only works with FAF (Forged Alliance Forever)
-- So I have integrate an Versioncheck to load the right Create Beam Functions 
--------------------------------------------------------------------------------

local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then

ALaserFenceUnit = Class(StructureUnit) {
	OnStopBeingBuilt = function(self, builder, layer)
        StructureUnit.OnStopBeingBuilt(self, builder, layer)
		local bp = self:GetBlueprint()
		local Desc = builder:GetBlueprint().Description
        local bpAnim = bp.Display.AnimationOpen
		local buildpos = builder:GetPosition()
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
		elseif CheckAlpha < 0 and CheckDist == -2 then
		x = buildpos[1] - math.cos(alpha) * dist
		y = buildpos[3] - math.sin(alpha) * dist - 1
		elseif CheckAlpha == 2 and CheckDist == 0 then
		x = buildpos[1] - math.cos(alpha) * dist + 1
		y = buildpos[3] - math.sin(alpha) * dist
		elseif CheckAlpha == -2 and CheckDist < 0 then
		x = buildpos[1] - math.cos(alpha) * dist - 1
		y = buildpos[3] - math.sin(alpha) * dist
		end
		local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LASERWALL,
			self:GetPosition(), 
			3
			
			)
            

            for _,unit in units do
					table.insert(ChargeEffects01Bag,AttachBeamEntityToEntity(self, 'Effect1', unit, 'Effect1', self:GetArmy(), Effects ))
					table.insert(ChargeEffects01Bag,AttachBeamEntityToEntity(self, 'Effect2', unit, 'Effect2', self:GetArmy(), Effects ))
					table.insert(ChargeEffects01Bag,AttachBeamEntityToEntity(self, 'Effect3', unit, 'Effect3', self:GetArmy(), Effects ))
            end

        if bpAnim then		
			if not self.Dead then
				    self.OpenAnim = CreateAnimator(self)
					self.Trash:Add(self.OpenAnim )
                    self.OpenAnim:PlayAnim(bpAnim)
					if Desc == 'Laser Fence' then
					--LOG('Distanz X: ', x)
					--LOG('Distanz Y: ', y)
					Dummy = CreateUnitHPR('UABAB0201a',self:GetArmy(), x, 0, y, 0, 0, 0)
					else
					end
					
            end
		end
			
    end,
	
	OnKilled = function(self)
        StructureUnit.OnKilled(self)
		Dummy:Destroy()
		if ChargeEffects01Bag then
            for k, v in ChargeEffects01Bag do
                v:Destroy()
            end
        end
    end,
}

ALaserFenceDummyUnit = Class(StructureUnit) {
	OnStopBeingBuilt = function(self, builder, layer)
        StructureUnit.OnStopBeingBuilt(self, builder, layer)

			
    end,
	
	OnKilled = function(self)
        StructureUnit.OnKilled(self)
		if ChargeEffects01Bag then
            for k, v in ChargeEffects01Bag do
                v:Destroy()
            end
        end
    end,
	
	
	
}

else

ALaserFenceUnit = Class(StructureUnit) {
	OnStopBeingBuilt = function(self, builder, layer)
        StructureUnit.OnStopBeingBuilt(self, builder, layer)
		local bp = self:GetBlueprint()
		local Desc = builder:GetBlueprint().Description
        local bpAnim = bp.Display.AnimationOpen
		local buildpos = builder:GetPosition()
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
		elseif CheckAlpha < 0 and CheckDist == -2 then
		x = buildpos[1] - math.cos(alpha) * dist
		y = buildpos[3] - math.sin(alpha) * dist - 1
		elseif CheckAlpha == 2 and CheckDist == 0 then
		x = buildpos[1] - math.cos(alpha) * dist + 1
		y = buildpos[3] - math.sin(alpha) * dist
		elseif CheckAlpha == -2 and CheckDist < 0 then
		x = buildpos[1] - math.cos(alpha) * dist - 1
		y = buildpos[3] - math.sin(alpha) * dist
		end
		local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LASERWALL,
			self:GetPosition(), 
			3
			
			)
            

            for _,unit in units do
			if unit == nil then
			else
            Effekt1 = AttachBeamEntityToEntity(self, 'Effect1', unit, 'Effect1', self:GetArmy(), Effects )
			Effekt2 = AttachBeamEntityToEntity(self, 'Effect2', unit, 'Effect2', self:GetArmy(), Effects )
			Effekt3 = AttachBeamEntityToEntity(self, 'Effect3', unit, 'Effect3', self:GetArmy(), Effects )
            end
			end

        if bpAnim then		
			if not self.Dead then
				    self.OpenAnim = CreateAnimator(self)
					self.Trash:Add(self.OpenAnim )
                    self.OpenAnim:PlayAnim(bpAnim)
					if Desc == 'Laser Fence' then
					--LOG('Distanz X: ', x)
					--LOG('Distanz Y: ', y)
					Dummy = CreateUnitHPR('UABAB0201a',self:GetArmy(), x, 0, y, 0, 0, 0)
					else
					end
					
            end
		end
			
    end,
	
	OnReclaimed = function(self, reclaimer)
            Effekt1:Destroy()
			Effekt2:Destroy()
			Effekt3:Destroy()

    end,
	
	OnKilled = function(self)
        StructureUnit.OnKilled(self)
		Dummy:Destroy()
		if ChargeEffects01Bag then
            for k, v in ChargeEffects01Bag do
                v:Destroy()
            end
        end
    end,
}

ALaserFenceDummyUnit = Class(StructureUnit) {
	OnStopBeingBuilt = function(self, builder, layer)
        StructureUnit.OnStopBeingBuilt(self, builder, layer)

			
    end,
	
	OnKilled = function(self)
        StructureUnit.OnKilled(self)
		if ChargeEffects01Bag then
            for k, v in ChargeEffects01Bag do
                v:Destroy()
            end
        end
    end,
	
}


end