#
# Terran Napalm Carpet Bomb
#
local TNapalmCarpetBombProjectile = import('/lua/terranprojectiles.lua').TNapalmCarpetBombProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')

ToxicRain = Class(TNapalmCarpetBombProjectile) {
    FxImpactUnit = EffectTemplate.GenericDebrisLandImpact01,
    FxImpactProp = EffectTemplate.GenericDebrisLandImpact01,
    FxImpactLand = EffectTemplate.GenericDebrisLandImpact01,
}

TypeClass = ToxicRain
