#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB5101/UAB5101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Wall Piece Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local ALaserFenceUnit = import('/lua/defaultunits.lua').StructureUnit
local ModEffectUtil = import('/mods/Commander Survival Kit Units/lua/CSKUnitsEffectUtilities.lua')
ModBpPath = '/mods/Commander Survival Kit Units/effects/emitters/'
local Effects = '/mods/Commander Survival Kit Units/effects/emitters/aeon_laserfence_beam_01_emit.bp'
local Dummy = nil
local Effect = nil
local BeamChargeEffects = {}
local ChargeEffects01Bag = {}
UABAB0201 = Class(ALaserFenceUnit) {




	OnStopBeingBuilt = function(self, builder, layer)
        ALaserFenceUnit.OnStopBeingBuilt(self, builder, layer)
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


        if bpAnim then		
			if not self.Dead then
				    self.OpenAnim = CreateAnimator(self)
					self.Trash:Add(self.OpenAnim )
                    self.OpenAnim:PlayAnim(bpAnim)
					if Desc == 'Laser Fence' then
					--LOG('Distanz X: ', x)
					--LOG('Distanz Y: ', y)
					Dummy = CreateUnitHPR('UABAB0201a',self:GetArmy(), x, 0, y, 0, 0, 0)
					table.insert(ChargeEffects01Bag,AttachBeamEntityToEntity(self, 'Effect1', builder, 'Effect1', self:GetArmy(), Effects ))
					table.insert(ChargeEffects01Bag,AttachBeamEntityToEntity(self, 'Effect2', builder, 'Effect2', self:GetArmy(), Effects ))
					table.insert(ChargeEffects01Bag,AttachBeamEntityToEntity(self, 'Effect3', builder, 'Effect3', self:GetArmy(), Effects ))
					else
					end
					
            end
		end
			
    end,
	
	OnKilled = function(self)
        ALaserFenceUnit.OnKilled(self)
		Dummy:Destroy()
		if ChargeEffects01Bag then
            for k, v in ChargeEffects01Bag do
                v:Destroy()
            end
            ChargeEffects01Bag = {}
        end
		self:Destroy() -- These is currently an Issue here
    end,

}


TypeClass = UABAB0201