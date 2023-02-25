TableCat = import('/lua/utilities.lua').TableCat
EmtBpPath = '/effects/emitters/'
EmitterTempEmtBpPath = '/effects/emitters/temp/'
ModEmtBpPath = '/mods/Commander Survival Kit/effects/emitters/'

ANukeRings01 = {
    ModEmtBpPath .. 'aeon_concussion_ring_01_emit.bp',
	ModEmtBpPath .. 'aeon_concussion_ring_02_emit.bp',
}

ANukeRings02 = {
	ModEmtBpPath .. 'aeon_concussion_ring_02_emit.bp',
}

TCNukeRings01 = {
    ModEmtBpPath .. 'cybran_nuke_concussion_ring_01_emit.bp',
	ModEmtBpPath .. 'cybran_nuke_concussion_ring_02_emit.bp',
}
TCNukeFlavorPlume01 = { ModEmtBpPath .. 'cybran_nuke_smoke_trail01_emit.bp', ModEmtBpPath .. 'cybran_nuke_smoke_trail02_emit.bp',}
TCNukeGroundConvectionEffects01 = { ModEmtBpPath .. 'cybran_nuke_mist_01_emit.bp', ModEmtBpPath .. 'cybran_nuke_mist_02_emit.bp',}
TCNukeBaseEffects01 = { ModEmtBpPath .. 'cybran_nuke_base03_emit.bp', }
TCNukeBaseEffects02 = { ModEmtBpPath .. 'cybran_nuke_base05_emit.bp', }
TCNukeHeadEffects01 = { ModEmtBpPath .. 'cybran_nuke_plume_01_emit.bp', }
TCNukeHeadEffects02 = { 
	ModEmtBpPath .. 'cybran_nuke_head_smoke_03_emit.bp',
	ModEmtBpPath .. 'cybran_nuke_head_smoke_04_emit.bp',
		
}
TCNukeHeadEffects03 = { ModEmtBpPath .. 'cybran_nuke_head_fire_01_emit.bp', }

SNukeRings01 = {
    EmtBpPath .. 'seraphim_inaino_concussion_01_emit.bp',
	EmtBpPath .. 'seraphim_inaino_concussion_03_emit.bp',
}
SNukeFlavorPlume01 = { EmtBpPath .. 'seraphim_inaino_explode_02_emit.bp',EmtBpPath .. 'seraphim_inaino_hit_05_emit.bp',     EmtBpPath .. 'seraphim_inaino_concussion_01_emit.bp',}
SNukeGroundConvectionEffects01 = { EmtBpPath .. 'seraphim_inaino_explode_08_emit.bp', EmtBpPath .. 'seraphim_inaino_explode_05_emit.bp', }
SNukeGroundConvectionEffects02 = { ModEmtBpPath .. 'snuke_mist_01_emit.bp', ModEmtBpPath .. 'snuke_mist_02_emit.bp',}
SNukeBaseEffects01 = { EmtBpPath .. 'seraphim_inaino_explode_04_emit.bp', EmtBpPath .. 'seraphim_inaino_explode_03_emit.bp',	}
SNukeBaseEffects02 = { EmtBpPath .. 'seraphim_inaino_explode_03_emit.bp', EmtBpPath .. 'seraphim_inaino_explode_08_emit.bp',}
SNukeHeadEffects01 = { EmtBpPath .. 'seraphim_inaino_explode_03_emit.bp', EmtBpPath .. 'seraphim_inaino_explode_08_emit.bp',}
SNukeHeadEffects02 = { 
	EmtBpPath .. 'seraphim_inaino_explode_01_emit.bp',
	EmtBpPath .. 'seraphim_inaino_explode_06_emit.bp',
	EmtBpPath .. 'seraphim_inaino_explode_08_emit.bp',
	EmtBpPath .. 'seraphim_inaino_hit_05_emit.bp',
		
}
SNukeHeadEffects03 = { EmtBpPath .. 'seraphim_inaino_explode_03_emit.bp', }


TornadoEffects = {
    EmtBpPath .. 'destruction_explosion_debris_05_emit.bp',
}

TeniumLaserEndPoint01 = {
    ModEmtBpPath .. 'tenium_laser_end_01_emit.bp',
    ModEmtBpPath .. 'tenium_laser_end_02_emit.bp',
    ModEmtBpPath .. 'tenium_laser_end_03_emit.bp',
    ModEmtBpPath .. 'tenium_laser_end_04_emit.bp',
    ModEmtBpPath .. 'tenium_laser_end_06_emit.bp',
}

ATeniumMunition01 = { 
    ModEmtBpPath .. 'atenium_cannon_munition_01_emit.bp',
	ModEmtBpPath .. 'tenium_cannon_munition_01_emit.bp',
    ModEmtBpPath .. 'tenium_cannon_munition_02_emit.bp',
    ModEmtBpPath .. 'tenium_cannon_munition_03_emit.bp',
    ModEmtBpPath .. 'tenium_cannon_munition_04_emit.bp',
}

ATeniumPolytrail01 =  ModEmtBpPath .. 'tenium_cannon_polytrail_01_emit.bp'

ATeniumImpact01 = { 
    ModEmtBpPath .. 'tenium_cloud_01_emit.bp',
	ModEmtBpPath .. 'tenium_cloud_02_emit.bp',
}

TNapalmHvyCarpetBombHitUnit01 = { 
	EmtBpPath .. 'flash_01_emit.bp',
}
TNapalmHvyCarpetBombHitLand01 = {
    ModEmtBpPath .. 'napalm_hvy_flash_emit.bp',
    ModEmtBpPath .. 'napalm_hvy_fire_emit.bp',
    ModEmtBpPath .. 'napalm_hvy_thin_smoke_emit.bp',
    ModEmtBpPath .. 'napalm_hvy_01_emit.bp',
    ModEmtBpPath .. 'napalm_hvy_02_emit.bp',
    ModEmtBpPath .. 'napalm_hvy_03_emit.bp',
	ModEmtBpPath .. 'napalm_hvy_04_emit.bp',
	ModEmtBpPath .. 'napalm_hvy_05_emit.bp',
	ModEmtBpPath .. 'napalm_hvy_06_emit.bp',
}
TNapalmHvyCarpetBombHitWater01 = {
    EmtBpPath .. 'napalm_hvy_waterflash_emit.bp',
    EmtBpPath .. 'napalm_hvy_water_smoke_emit.bp',
    EmtBpPath .. 'napalm_hvy_oilslick_emit.bp',
    EmtBpPath .. 'napalm_hvy_lines_emit.bp',
    EmtBpPath .. 'napalm_hvy_water_ripples_emit.bp',
    EmtBpPath .. 'napalm_hvy_water_dots_emit.bp',    
}

TBluBombHitLand01 = {
    ModEmtBpPath .. 'napalm_hvy_flash_emit.bp',
    ModEmtBpPath .. 'napalm_hvy_fire_emit.bp',
    ModEmtBpPath .. 'napalm_hvy_thin_smoke_emit.bp',
    ModEmtBpPath .. 'napalm_hvy_01_emit.bp',
    ModEmtBpPath .. 'napalm_hvy_02_emit.bp',
    ModEmtBpPath .. 'napalm_hvy_03_emit.bp',
	ModEmtBpPath .. 'napalm_hvy_04_emit.bp',
	ModEmtBpPath .. 'napalm_hvy_05_emit.bp',
	ModEmtBpPath .. 'napalm_hvy_06_emit.bp',
	EmtBpPath .. 'antimatter_hit_01_emit.bp',	##	glow	
    EmtBpPath .. 'antimatter_hit_02_emit.bp',	##	flash	     
    EmtBpPath .. 'antimatter_hit_03_emit.bp', 	##	sparks
    ModEmtBpPath .. 'antimatter_hit_04_emit.bp',	##	plume fire
    ModEmtBpPath .. 'antimatter_hit_06_emit.bp',	##	base fire
    ModEmtBpPath .. 'antimatter_hit_08_emit.bp',	##	plume smoke
    ModEmtBpPath .. 'antimatter_hit_09_emit.bp',	##	base smoke
	ModEmtBpPath .. 'antimatter_hit_12_emit.bp',	##	base smoke
    EmtBpPath .. 'antimatter_ring_01_emit.bp',	##	ring14
    EmtBpPath .. 'antimatter_ring_02_emit.bp',	##	ring11	
}

CNanites01 = {
    ModEmtBpPath .. 'nanites_01_emit.bp',
	ModEmtBpPath .. 'nanites_03_emit.bp',
}

CNanites02 = {
    ModEmtBpPath .. 'nanites_02_emit.bp',
	ModEmtBpPath .. 'nanites_03_emit.bp',
}

--------------------------------------------------------------------------
--  Blackhole
--------------------------------------------------------------------------

NukeBlackholeFlash = {
    ModEmtBpPath .. 'blackhole_06_emit.bp',  -- flash
    ModEmtBpPath .. 'blackhole_11_emit.bp',  -- shockwave ring
    ModEmtBpPath .. 'blackhole_18_emit.bp',  -- big flash
}

NukeBlackholeCore = {
    ModEmtBpPath .. 'blackhole_01_emit.bp',  -- large shrinking circle
    ModEmtBpPath .. 'blackhole_03_emit.bp',  -- black core
    ModEmtBpPath .. 'blackhole_04_emit.bp',  -- refract light stripes inwards
    ModEmtBpPath .. 'blackhole_05_emit.bp',  -- refract center core
	ModEmtBpPath .. 'blackhole_08_emit.bp',  -- flat distorting ring
    ModEmtBpPath .. 'blackhole_09_emit.bp',  -- flat refraction ring
    ModEmtBpPath .. 'blackhole_10_emit.bp',  -- flat ring
    ModEmtBpPath .. 'blackhole_17_emit.bp',  -- fast dark stripe rings
    ModEmtBpPath .. 'blackhole_19_emit.bp',  -- rotating cloud rings big
    ModEmtBpPath .. 'blackhole_21_emit.bp',  -- rotating cloud rings small
}

NukeBlackholeRadiationBeams = {  -- if changed be sure to update the length and thickness tables below!!
    ModEmtBpPath .. 'blackhole_radiationbeam1.bp',
    ModEmtBpPath .. 'blackhole_radiationbeam2.bp',
}

NukeBlackholeRadiationBeamLengths = {  -- the length parameter of each beam blueprint
    -50,
    50,
}

NukeBlackholeRadiationBeamThickness = {  -- the thickness parameter of each beam blueprint
    2,
    2,
}

NukeBlackholeGeneric = {
--    ModEmtBpPath .. 'blackhole_16_emit.bp',  -- inward stripes
}

--NukeBlackholeEnergyBeam1 = EmtBpPath .. 'seraphim_othuy_beam_01_emit.bp'
--NukeBlackholeEnergyBeam2 = EmtBpPath .. 'seraphim_othuy_beam_02_emit.bp'
--NukeBlackholeEnergyBeam3 = EmtBpPath .. 'seraphim_othuy_beam_03_emit.bp'
--NukeBlackholeEnergyBeamEnd = EmtBpPath .. 'seraphim_othuy_hit_01_emit.bp'

NukeBlackholeDissipating = {
    ModEmtBpPath .. 'blackhole_22_emit.bp',  -- star and glowing core
}

NukeBlackholeDissipated = {  -- used when the black hole effects are removed
    ModEmtBpPath .. 'blackhole_11_emit.bp',  -- shockwave ring
    ModEmtBpPath .. 'blackhole_12_emit.bp',  -- smoke cloud
    ModEmtBpPath .. 'blackhole_13_emit.bp',  -- large barely visible smoke cloud
    ModEmtBpPath .. 'blackhole_14_emit.bp',  -- flash
    ModEmtBpPath .. 'blackhole_15_emit.bp',  -- circle
    ModEmtBpPath .. 'blackhole_20_emit.bp',  -- rotating cloud rings inward
    EmtBpPath .. 'destruction_explosion_concussion_ring_03_emit.bp',
}

NukeBlackholeDustCloud01 = {
    ModEmtBpPath .. 'blackhole_dustcloud01_emit.bp',
}

NukeBlackholeDustCloud02 = {
    ModEmtBpPath .. 'blackhole_dustcloud02_emit.bp',
}

NukeBlackholeFireball = {
    ModEmtBpPath .. 'blackhole_fireball01_emit.bp',
}

NukeBlackholeFireballHit = {
    ModEmtBpPath .. 'blackhole_fireball_hit01_emit.bp',
    ModEmtBpPath .. 'blackhole_fireball_hit02_emit.bp',
}

NukeBlackholeFireballTrail = {
    ModEmtBpPath .. 'blackhole_fireballtrail.bp',
}

NukeBlackholeFireballPolyTrail = ModEmtBpPath .. 'blackhole_fireballpolytrail.bp'

NukeBlackholeFireArmSegment1 = {
    ModEmtBpPath .. 'blackhole_fireline05_emit.bp',
}

NukeBlackholeFireArmSegment2 = {
    ModEmtBpPath .. 'blackhole_fireline04_emit.bp',
}

NukeBlackholeFireArmSegment3 = {
    ModEmtBpPath .. 'blackhole_fireline03_emit.bp',
}

NukeBlackholeFireArmSegment4 = {
    ModEmtBpPath .. 'blackhole_fireline02_emit.bp',
}

NukeBlackholeFireArmSegment5 = {
    ModEmtBpPath .. 'blackhole_fireline01_emit.bp',
}

NukeBlackholeFireArmCenter1 = {
    EmtBpPath .. 'destruction_explosion_concussion_ring_03_emit.bp',
    ModEmtBpPath .. 'blackhole_firecenter03_emit.bp',
    ModEmtBpPath .. 'blackhole_firesparks01_emit.bp',
    ModEmtBpPath .. 'blackhole_firesparks02_emit.bp',
}

NukeBlackholeFireArmCenter3 = {
	ModEmtBpPath .. 'anuke_mist_01_emit.bp', 
	ModEmtBpPath .. 'anuke_mist_02_emit.bp',
}

NukeBlackholeFireArmCenter2 = {
    ModEmtBpPath .. 'blackhole_firecenter02_emit.bp',
}

ACUDeathBlackholeFlash = NukeBlackholeFlash
ACUDeathBlackholeCore = NukeBlackholeCore
ACUDeathBlackholeGeneric = NukeBlackholeGeneric
ACUDeathBlackholeDissipated = NukeBlackholeDissipated

BlackholeLeftoverPerm = {
    ModEmtBpPath .. 'blackhole_leftover_01_emit.bp',  -- fog
    ModEmtBpPath .. 'blackhole_leftover_02_emit.bp',  -- ball
    ModEmtBpPath .. 'blackhole_leftover_03_emit.bp',  -- ambient fire
    ModEmtBpPath .. 'blackhole_leftover_04_emit.bp',  -- ambient fire upward
}

BlackholePropEffects = {
    --ModEmtBpPath .. 'blackhole_propeffect01_emit.bp', -- yellow particles
    --ModEmtBpPath .. 'blackhole_propeffect02_emit.bp', -- brown particles
    --ModEmtBpPath .. 'blackhole_propeffect03_emit.bp', -- white particles
    --ModEmtBpPath .. 'blackhole_propeffect04_emit.bp', -- grey particles
--    ModEmtBpPath .. 'blackhole_propeffect05_emit.bp', -- dirt chunks
}
