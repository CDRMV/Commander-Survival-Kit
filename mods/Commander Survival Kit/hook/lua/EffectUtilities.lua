

function CreateDefaultBuildBeams2( builder, unitBeingBuilt, BuildEffectBones, BuildEffectsBag )
    local BeamBuildEmtBp = '/effects/emitters/build_beam_01_emit.bp'
    local ox, oy, oz = unpack(unitBeingBuilt:GetPosition())
    local BeamEndEntity = Entity()
    local army = builder:GetArmy()
    BuildEffectsBag:Add( BeamEndEntity )
    Warp( BeamEndEntity, Vector(ox, oy, oz))   
   
    local BuildBeams = {}

    # Create build beams
    if BuildEffectBones != nil then
        local beamEffect = nil
        for i, BuildBone in BuildEffectBones do
            local beamEffect = AttachBeamEntityToEntity(builder, BuildBone, BeamEndEntity, -1, army, BeamBuildEmtBp )
            table.insert( BuildBeams, beamEffect )
            BuildEffectsBag:Add(beamEffect)
        end
    end    

    CreateEmitterOnEntity( BeamEndEntity, builder:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
    local waitTime = util.GetRandomFloat( 0.3, 1.5 )

    while not builder:BeenDestroyed() and not unitBeingBuilt:BeenDestroyed() do
        local x, y, z = builder.GetRandomOffset(unitBeingBuilt, 1 )
        Warp( BeamEndEntity, Vector(ox + x, oy + y, oz + z))
        WaitSeconds(waitTime)
    end
end


function CreateSeraphimBuildBeams( builder, unitBeingBuilt, BuildEffectBones, BuildEffectsBag )
    local ox, oy, oz = unpack(unitBeingBuilt:GetPosition())
    local BeamEndEntity = Entity()
    local army = builder:GetArmy()
    BuildEffectsBag:Add( BeamEndEntity )
    Warp( BeamEndEntity, Vector(ox, oy, oz))   
   
    local BuildBeams = {}

    # Create build beams
    if BuildEffectBones != nil then
        local beamEffect = nil
        for i, BuildBone in BuildEffectBones do
		    for k, v in EffectTemplate.SeraphimBuildBeams01 do
			local beamEffect = AttachBeamEntityToEntity(builder, BuildBone, unitBeingBuilt, -1, army, v )
			BuildEffectsBag:Add(beamEffect)
			end
        end
    end    

    CreateEmitterOnEntity( BeamEndEntity, builder:GetArmy(),'/effects/emitters/seraphim_build_01_emit.bp')
    local waitTime = util.GetRandomFloat( 0.3, 1.5 )

    while not builder:BeenDestroyed() and not unitBeingBuilt:BeenDestroyed() do
        local x, y, z = builder.GetRandomOffset(unitBeingBuilt, 1 )
        Warp( BeamEndEntity, Vector(ox + x, oy + y, oz + z))
        WaitSeconds(waitTime)
    end
end
