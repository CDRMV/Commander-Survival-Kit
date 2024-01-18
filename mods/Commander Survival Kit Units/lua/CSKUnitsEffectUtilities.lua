local EffectTemplate = import('/lua/EffectTemplates.lua')
local Entity = import('/lua/sim/Entity.lua').Entity
local CSKUEffectTemplate = import('/mods/Commander Survival Kit Units/lua/CSKUnitsEffectTemplates.lua')
local util = import('/lua/utilities.lua')


--------------------------------------------------------------------------------

-- Aeon Laserfence Beam Effect

--------------------------------------------------------------------------------
-- Note:
-- Doesn't have the Recolour Function integrated
--------------------------------------------------------------------------------

function CreateLaserFenceEffects( reclaimer, reclaimed, BuildEffectBones)
	local army = reclaimer:GetArmy()
    local pos = reclaimed:GetPosition()
    pos[2] = GetSurfaceHeight(pos[1], pos[3])
	
	
    local beamEnd = Entity()
    Warp( beamEnd, pos )
	
    for kBone, vBone in BuildEffectBones do
		for kEmit, vEmit in CSKUEffectTemplate.AeonLaserFenceBeam do
			local beamEffect = AttachBeamEntityToEntity(reclaimer, vBone, reclaimed, vBone, army, vEmit )
		end
	end
	
end






