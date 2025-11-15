local DefaultUnits = import('/lua/defaultunits.lua')
local MobileUnit = DefaultUnits.MobileUnit
local FactoryUnit = DefaultUnits.FactoryUnit
local StructureUnit = DefaultUnits.StructureUnit
local ModEffectUtil = import('/mods/Commander Survival Kit Units/lua/CSKUnitsEffectUtilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')
local Effects = '/mods/Commander Survival Kit Units/effects/emitters/cybran_electrofence_beam_01_emit.bp'
local TerrainUtils = import('/mods/Commander Survival Kit Units/lua/TerrainUtils.lua')
local Dummy = nil
local NewDummy = nil
local Effect = nil
local BeamChargeEffects = {}
local ChargeEffects01Bag = {}
--------------------------------------------------------------------------------
-- Cybran Laser Fence 
--------------------------------------------------------------------------------

local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 
SStructureUnit = Class(StructureUnit) {
	GetSkirtRect = function(self)
        local bp = self:GetBlueprint()
        local x, y, z = unpack(self:GetPosition())
        local fx = x - bp.Footprint.SizeX*.5
        local fz = z - bp.Footprint.SizeZ*.5
        local sx = fx + bp.Physics.SkirtOffsetX
        local sz = fz + bp.Physics.SkirtOffsetZ
        return sx, sz, sx+bp.Physics.SkirtSizeX, sz+bp.Physics.SkirtSizeZ
    end,
		OnStopBeingBuilt = function(self, builder, layer, ...)
            StructureUnit.OnStopBeingBuilt(self, builder, layer)
            local bp = self:GetBlueprint()

            --
            -- For buildings that don't flatten skirt to slope with the terrain
            --
            local layer = self:GetCurrentLayer()
            if not bp.Physics.FlattenSkirt and bp.Physics.SlopeToTerrain and not self.TerrainSlope and (layer == 'Land' or layer == 'Seabed') then
local GetTerrainAngles = TerrainUtils.GetTerrainSlopeAnglesDegrees
                local Angles = GetTerrainAngles(self:GetPosition(),{bp.Footprint.SizeX or bp.Physics.SkirtSizeX, bp.Footprint.SizeZ or bp.Physics.SkirtSizeZ})
                local Axis = bp.Physics.SlopeToTerrainAxis

                if Axis.InvertAxis then
                    for i, v in Angles do
                        if Axis.InvertAxis[i] then
                            Angles[i] = -v
                        end
                    end
                end
                self.TerrainSlope = {
                    CreateRotator(self, 0, Axis and Axis.Axis1 or 'z', -Angles[1], 99999),
                    CreateRotator(self, 0, Axis and Axis.Axis2 or 'x', Angles[2], 99999)
                }
            end
            if not bp.Physics.FlattenSkirt and bp.Physics.AltitudeToTerrain then
                if not self.TerrainSlope then
                    self.TerrainSlope = {}
                end
                for i, v in bp.Physics.AltitudeToTerrain do
                    OffsetBoneToTerrain(self, type(v) == 'table' and v[1] or v)
                end
            end

        end,

}

SWalkingLandUnit = Class(DefaultUnitsFile.WalkingLandUnit) {

    WalkingAnimRate = 1,
    IdleAnimRate = 1,
    DisabledBones = {},
	
	CreateFootFallManipulators = function( self, footfall )
        if not footfall.Bones or (footfall.Bones and (table.getn(footfall.Bones) == 0)) then
            LOG('*WARNING: No footfall bones defined for unit ',repr(self:GetUnitId()),', ', 'these must be defined to animation collision detector and foot plant controller' )
            return false
        end

        self.Detector = CreateCollisionDetector(self)
        self.Trash:Add(self.Detector)
        for k, v in footfall.Bones do
            self.Detector:WatchBone(v.FootBone)
            if v.FootBone and v.KneeBone and v.HipBone then
                CreateFootPlantController(self, v.FootBone, v.KneeBone, v.HipBone, v.StraightLegs or true, v.MaxFootFall or 0):SetPrecedence(10)
            end
        end
        return true
    end,
    
}

else
SStructureUnit = ClassUnit(StructureUnit) {
	GetSkirtRect = function(self)
        local bp = self:GetBlueprint()
        local x, y, z = unpack(self:GetPosition())
        local fx = x - bp.Footprint.SizeX*.5
        local fz = z - bp.Footprint.SizeZ*.5
        local sx = fx + bp.Physics.SkirtOffsetX
        local sz = fz + bp.Physics.SkirtOffsetZ
        return sx, sz, sx+bp.Physics.SkirtSizeX, sz+bp.Physics.SkirtSizeZ
    end,
		OnStopBeingBuilt = function(self, builder, layer, ...)
            StructureUnit.OnStopBeingBuilt(self, builder, layer)
            local bp = self:GetBlueprint()

            --
            -- For buildings that don't flatten skirt to slope with the terrain
            --
            local layer = self:GetCurrentLayer()
            if not bp.Physics.FlattenSkirt and bp.Physics.SlopeToTerrain and not self.TerrainSlope and (layer == 'Land' or layer == 'Seabed') then
local GetTerrainAngles = TerrainUtils.GetTerrainSlopeAnglesDegrees
                local Angles = GetTerrainAngles(self:GetPosition(),{bp.Footprint.SizeX or bp.Physics.SkirtSizeX, bp.Footprint.SizeZ or bp.Physics.SkirtSizeZ})
                local Axis = bp.Physics.SlopeToTerrainAxis

                if Axis.InvertAxis then
                    for i, v in Angles do
                        if Axis.InvertAxis[i] then
                            Angles[i] = -v
                        end
                    end
                end
                self.TerrainSlope = {
                    CreateRotator(self, 0, Axis and Axis.Axis1 or 'z', -Angles[1], 99999),
                    CreateRotator(self, 0, Axis and Axis.Axis2 or 'x', Angles[2], 99999)
                }
            end
            if not bp.Physics.FlattenSkirt and bp.Physics.AltitudeToTerrain then
                if not self.TerrainSlope then
                    self.TerrainSlope = {}
                end
                for i, v in bp.Physics.AltitudeToTerrain do
                    OffsetBoneToTerrain(self, type(v) == 'table' and v[1] or v)
                end
            end

        end,

}
end

SDimensionFenceUnit = Class(SStructureUnit) {
	OnCreate = function(self, builder, layer)
        SStructureUnit.OnCreate(self, builder, layer)
		
		self:HideBone( 'Turret', true )
			
    end,


	OnStopBeingBuilt = function(self, builder, layer)
        SStructureUnit.OnStopBeingBuilt(self, builder, layer)
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
        SStructureUnit.OnKilled(self)
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

SDimensionFenceDummyUnit = Class(SStructureUnit) {
	OnCreate = function(self, builder, layer)
        SStructureUnit.OnCreate(self, builder, layer)
		
		        self:HideBone( 0, true )
			
    end,


	OnStopBeingBuilt = function(self, builder, layer)
        SStructureUnit.OnStopBeingBuilt(self, builder, layer)
		
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
        SStructureUnit.OnKilled(self)
		self:Destroy()
    end,
	
	
}
