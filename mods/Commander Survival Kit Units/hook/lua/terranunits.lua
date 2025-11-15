local DefaultUnits = import('/lua/defaultunits.lua')
local FactoryUnit = DefaultUnits.FactoryUnit
local StructureUnit = DefaultUnits.StructureUnit
local ModEffectUtil = import('/mods/Commander Survival Kit Units/lua/CSKUnitsEffectUtilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')
local Effects = '/mods/Commander Survival Kit Units/effects/emitters/terran_fence_01_emit.bp'
local TerrainUtils = import('/mods/Commander Survival Kit Units/lua/TerrainUtils.lua')
local Dummy = nil
local NewDummy = nil
local Effect = nil
local BeamChargeEffects = {}
local ChargeEffects01Bag = {}
--------------------------------------------------------------------------------
-- UEF Shield Fence 
--------------------------------------------------------------------------------

local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 
TStructureUnit = Class(StructureUnit) {
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

TWalkingLandUnit = Class(WalkingLandUnit) {

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

TLandUnit = Class(LandUnit) {
    OnStartTransportBeamUp = function(self, transport, bone)
		if EntityCategoryContains( categories.AMPHIBIOUSTRANSPORT, transport ) or EntityCategoryContains( categories.BUNKER, transport ) then
		self:HideBone(0,true)
		self:DestroyIdleEffects()
        self:DestroyMovementEffects()
		end
    end,
	
	OnStopTransportBeamUp = function(self)
        self:DestroyIdleEffects()
        self:DestroyMovementEffects()
		if self.TransportBeamEffectsBag == nil then
		
		else
        for k, v in self.TransportBeamEffectsBag do
            v:Destroy()
        end
		end
    end,
}

else
TStructureUnit = ClassUnit(StructureUnit) {
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
local LandUnit = import('/lua/defaultunits.lua').LandUnit

TLandUnit = ClassUnit(LandUnit) {
    OnStartTransportBeamUp = function(self, transport, bone)
		if EntityCategoryContains( categories.AMPHIBIOUSTRANSPORT, transport ) or EntityCategoryContains( categories.BUNKER, transport ) then
		self:HideBone(0,true)
		local slot = transport.slots[bone]
        if slot then
            self:GetAIBrain():OnTransportFull()
            IssueToUnitClearCommands(self)
            return
        end
		self:DestroyIdleEffects()
        self:DestroyMovementEffects()
		
		self.Brain:OnUnitStartTransportBeamUp(self, transport, bone)
		end
    end,
	
	OnStopTransportBeamUp = function(self)
		self:DestroyIdleEffects()
        self:DestroyMovementEffects()
		if self.TransportBeamEffectsBag == nil then
		
		else
        TrashDestroy(self.TransportBeamEffectsBag)
		end

        -- Reset weapons to ensure torso centres and unit survives drop
        for i = 1, self.WeaponCount do
            self.WeaponInstances[i]:ResetTarget()
        end

        -- for AI events
        self.Brain:OnUnitStoptransportBeamUp(self)
    end,
}
end



TShieldFenceUnit = Class(TStructureUnit) {


	OnCreate = function(self, builder, layer)
        TStructureUnit.OnCreate(self, builder, layer)
		
		--self:HideBone('G_Turret', true )
			
    end,

	OnStopBeingBuilt = function(self, builder, layer)
        TStructureUnit.OnStopBeingBuilt(self, builder, layer)
		
						local bp = self:GetBlueprint()			
        local bpAnim = bp.Display.AnimationOpen
					self:ForkThread(function()
					--self:HideBone( 'G_Turret', true )
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
        TStructureUnit.OnKilled(self)
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

TShieldFenceDummyUnit = Class(TStructureUnit) {
	OnCreate = function(self, builder, layer)
        TStructureUnit.OnCreate(self, builder, layer)
		
		        self:HideBone( 0, true )
			
    end,


	OnStopBeingBuilt = function(self, builder, layer)
        TStructureUnit.OnStopBeingBuilt(self, builder, layer)
		
						local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationOpen
					self:ForkThread(function()
					self:HideBone( 0, true )
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
        TStructureUnit.OnKilled(self)
		self:Destroy()
    end,
	
	
}




