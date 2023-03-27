#
# Terran Napalm Carpet Bomb
#
local CNaniteProjectile = import('/mods/Commander Survival Kit/lua/FireSupportProjectiles.lua').CNaniteProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectpath = '/mods/Commander Survival Kit/effects/emitters/'

Nanites = Class(CNaniteProjectile) {

}

TypeClass = Nanites
