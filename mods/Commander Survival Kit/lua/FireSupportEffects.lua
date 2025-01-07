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
	EmtBpPath .. 'antimatter_hit_01_emit.bp',	##	glow	
    --EmtBpPath .. 'antimatter_hit_02_emit.bp',	##	flash	     
    EmtBpPath .. 'antimatter_hit_03_emit.bp', 	##	sparks
   -- EmtBpPath .. 'antimatter_hit_04_emit.bp',	##	plume fire
   -- EmtBpPath .. 'antimatter_hit_05_emit.bp',	##	plume dark 
    EmtBpPath .. 'antimatter_hit_06_emit.bp',	##	base fire
    --EmtBpPath .. 'antimatter_hit_07_emit.bp',	##	base dark 
    --EmtBpPath .. 'antimatter_hit_08_emit.bp',	##	plume smoke
    EmtBpPath .. 'antimatter_hit_09_emit.bp',	##	base smoke
   -- EmtBpPath .. 'antimatter_hit_10_emit.bp',	##	plume highlights
    --EmtBpPath .. 'antimatter_hit_11_emit.bp',	##	base highlights
    EmtBpPath .. 'antimatter_ring_01_emit.bp',	##	ring14
    EmtBpPath .. 'antimatter_ring_02_emit.bp',	##	ring11	 
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

CPhotonMissileFxtrails= {
	ModEmtBpPath .. 'proton_missile_fxtrail_emit.bp',
    ModEmtBpPath .. 'proton_missile_smoke_exhaust_emit.bp',
}

CPurplePhotonicLaserEndPoint01 = {
    ModEmtBpPath .. 'purple_laserbeam_end_01_emit.bp',
    ModEmtBpPath .. 'purple_laserbeam_end_02_emit.bp',
    ModEmtBpPath .. 'purple_laserbeam_end_03_emit.bp',
    ModEmtBpPath .. 'purple_laserbeam_end_04_emit.bp',
    ModEmtBpPath .. 'purple_laserbeam_end_05_emit.bp',
    ModEmtBpPath .. 'purple_laserbeam_end_06_emit.bp',
}

--------------------------------------------------------------------------
--  Aeon Instable Tendium
--------------------------------------------------------------------------

InstableTendiumFlash = {
    ModEmtBpPath .. 'InstableTendium_06_emit.bp',  -- flash
    ModEmtBpPath .. 'InstableTendium_11_emit.bp',  -- shockwave ring
    ModEmtBpPath .. 'InstableTendium_18_emit.bp',  -- big flash
}

InstableTendiumCore = {
    ModEmtBpPath .. 'InstableTendium_01_emit.bp',  -- large shrinking circle
    ModEmtBpPath .. 'InstableTendium_03_emit.bp',  -- black core
    ModEmtBpPath .. 'InstableTendium_04_emit.bp',  -- refract light stripes inwards
    ModEmtBpPath .. 'InstableTendium_05_emit.bp',  -- refract center core
	ModEmtBpPath .. 'InstableTendium_08_emit.bp',  -- flat distorting ring
    ModEmtBpPath .. 'InstableTendium_09_emit.bp',  -- flat refraction ring
    ModEmtBpPath .. 'InstableTendium_10_emit.bp',  -- flat ring
    ModEmtBpPath .. 'InstableTendium_17_emit.bp',  -- fast dark stripe rings
    ModEmtBpPath .. 'InstableTendium_19_emit.bp',  -- rotating cloud rings big
    ModEmtBpPath .. 'InstableTendium_21_emit.bp',  -- rotating cloud rings small
}

InstableTendiumRadiationBeams = {  -- if changed be sure to update the length and thickness tables below!!
    ModEmtBpPath .. 'InstableTendium_radiationbeam1.bp',
    ModEmtBpPath .. 'InstableTendium_radiationbeam2.bp',
}

InstableTendiumRadiationBeamLengths = {  -- the length parameter of each beam blueprint
    -50,
    50,
}

InstableTendiumRadiationBeamThickness = {  -- the thickness parameter of each beam blueprint
    2,
    2,
}

InstableTendiumGeneric = {
--    ModEmtBpPath .. 'InstableTendium_16_emit.bp',  -- inward stripes
}

--InstableTendiumEnergyBeam1 = EmtBpPath .. 'seraphim_othuy_beam_01_emit.bp'
--InstableTendiumEnergyBeam2 = EmtBpPath .. 'seraphim_othuy_beam_02_emit.bp'
--InstableTendiumEnergyBeam3 = EmtBpPath .. 'seraphim_othuy_beam_03_emit.bp'
--InstableTendiumEnergyBeamEnd = EmtBpPath .. 'seraphim_othuy_hit_01_emit.bp'

InstableTendiumDissipating = {
    ModEmtBpPath .. 'InstableTendium_22_emit.bp',  -- star and glowing core
}

InstableTendiumDissipated = {  -- used when the black hole effects are removed
    ModEmtBpPath .. 'InstableTendium_11_emit.bp',  -- shockwave ring
    ModEmtBpPath .. 'InstableTendium_12_emit.bp',  -- smoke cloud
    ModEmtBpPath .. 'InstableTendium_13_emit.bp',  -- large barely visible smoke cloud
    ModEmtBpPath .. 'InstableTendium_14_emit.bp',  -- flash
    ModEmtBpPath .. 'InstableTendium_15_emit.bp',  -- circle
    ModEmtBpPath .. 'InstableTendium_20_emit.bp',  -- rotating cloud rings inward
    EmtBpPath .. 'destruction_explosion_concussion_ring_03_emit.bp',
}

InstableTendiumDustCloud01 = {
    ModEmtBpPath .. 'InstableTendium_dustcloud01_emit.bp',
}

InstableTendiumDustCloud02 = {
    ModEmtBpPath .. 'InstableTendium_dustcloud02_emit.bp',
}

InstableTendiumFireball = {
    ModEmtBpPath .. 'InstableTendium_fireball01_emit.bp',
}

InstableTendiumFireballHit = {
    ModEmtBpPath .. 'InstableTendium_fireball_hit01_emit.bp',
    ModEmtBpPath .. 'InstableTendium_fireball_hit02_emit.bp',
}

InstableTendiumFireballTrail = {
    ModEmtBpPath .. 'InstableTendium_fireballtrail.bp',
}

InstableTendiumFireballPolyTrail = ModEmtBpPath .. 'InstableTendium_fireballpolytrail.bp'

InstableTendiumFireArmSegment1 = {
    ModEmtBpPath .. 'InstableTendium_fireline05_emit.bp',
}

InstableTendiumFireArmSegment2 = {
    ModEmtBpPath .. 'InstableTendium_fireline04_emit.bp',
}

InstableTendiumFireArmSegment3 = {
    ModEmtBpPath .. 'InstableTendium_fireline03_emit.bp',
}

InstableTendiumFireArmSegment4 = {
    ModEmtBpPath .. 'InstableTendium_fireline02_emit.bp',
}

InstableTendiumFireArmSegment5 = {
    ModEmtBpPath .. 'InstableTendium_fireline01_emit.bp',
}

InstableTendiumFireArmCenter1 = {
    EmtBpPath .. 'destruction_explosion_concussion_ring_03_emit.bp',
    ModEmtBpPath .. 'InstableTendium_firecenter03_emit.bp',
    ModEmtBpPath .. 'InstableTendium_firesparks01_emit.bp',
    ModEmtBpPath .. 'InstableTendium_firesparks02_emit.bp',
}

InstableTendiumFireArmCenter3 = {
	ModEmtBpPath .. 'InstableTendium_mist_01_emit.bp', 
	ModEmtBpPath .. 'InstableTendium_mist_02_emit.bp',
}

InstableTendiumFireArmCenter2 = {
    ModEmtBpPath .. 'InstableTendium_firecenter02_emit.bp',
}

InstableTendiumLeftoverPerm = {
   -- ModEmtBpPath .. 'InstableTendium_leftover_01_emit.bp',  -- fog
    ModEmtBpPath .. 'InstableTendium_leftover_02_emit.bp',  -- ball
    ModEmtBpPath .. 'InstableTendium_leftover_03_emit.bp',  -- ambient fire
    ModEmtBpPath .. 'InstableTendium_leftover_04_emit.bp',  -- ambient fire upward
}

InstableTendiumPropEffects = {
    --ModEmtBpPath .. 'InstableTendium_propeffect01_emit.bp', -- yellow particles
    --ModEmtBpPath .. 'InstableTendium_propeffect02_emit.bp', -- brown particles
    --ModEmtBpPath .. 'InstableTendium_propeffect03_emit.bp', -- white particles
    --ModEmtBpPath .. 'InstableTendium_propeffect04_emit.bp', -- grey particles
--    ModEmtBpPath .. 'InstableTendium_propeffect05_emit.bp', -- dirt chunks
}

--------------------------------------------------------------------------
-- Seraphim Dimensional
--------------------------------------------------------------------------

DimensionalFlash = {
    ModEmtBpPath .. 'Dimensional_06_emit.bp',  -- flash
    ModEmtBpPath .. 'Dimensional_11_emit.bp',  -- shockwave ring
    ModEmtBpPath .. 'Dimensional_18_emit.bp',  -- big flash
}

DimensionalCore = {
    ModEmtBpPath .. 'Dimensional_01_emit.bp',  -- large shrinking circle
    ModEmtBpPath .. 'Dimensional_03_emit.bp',  -- black core
    ModEmtBpPath .. 'Dimensional_04_emit.bp',  -- refract light stripes inwards
    ModEmtBpPath .. 'Dimensional_05_emit.bp',  -- refract center core
	ModEmtBpPath .. 'Dimensional_08_emit.bp',  -- flat distorting ring
    ModEmtBpPath .. 'Dimensional_09_emit.bp',  -- flat refraction ring
    ModEmtBpPath .. 'Dimensional_10_emit.bp',  -- flat ring
    ModEmtBpPath .. 'Dimensional_17_emit.bp',  -- fast dark stripe rings
    ModEmtBpPath .. 'Dimensional_19_emit.bp',  -- rotating cloud rings big
    ModEmtBpPath .. 'Dimensional_21_emit.bp',  -- rotating cloud rings small
}

DimensionalRadiationBeams = {  -- if changed be sure to update the length and thickness tables below!!
    ModEmtBpPath .. 'Dimensional_radiationbeam1.bp',
    ModEmtBpPath .. 'Dimensional_radiationbeam2.bp',
}

DimensionalRadiationBeamLengths = {  -- the length parameter of each beam blueprint
    -50,
    50,
}

DimensionalRadiationBeamThickness = {  -- the thickness parameter of each beam blueprint
    2,
    2,
}

DimensionalGeneric = {
--    ModEmtBpPath .. 'Dimensional_16_emit.bp',  -- inward stripes
}

--DimensionalEnergyBeam1 = EmtBpPath .. 'seraphim_othuy_beam_01_emit.bp'
--DimensionalEnergyBeam2 = EmtBpPath .. 'seraphim_othuy_beam_02_emit.bp'
--DimensionalEnergyBeam3 = EmtBpPath .. 'seraphim_othuy_beam_03_emit.bp'
--DimensionalEnergyBeamEnd = EmtBpPath .. 'seraphim_othuy_hit_01_emit.bp'

DimensionalDissipating = {
    ModEmtBpPath .. 'Dimensional_03_emit.bp',  -- black core
	--ModEmtBpPath .. 'Dimensional_08_emit.bp',  -- flat distorting ring
    --ModEmtBpPath .. 'Dimensional_09_emit.bp',  -- flat refraction ring
    --ModEmtBpPath .. 'Dimensional_10_emit.bp',  -- flat ring
    ModEmtBpPath .. 'Dimensional_22_emit.bp',  -- star and glowing core
}

DimensionalSecondary = {  -- used when the black hole effects are removed
    ModEmtBpPath .. 'Dimensional_11_emit.bp',  -- shockwave ring
    --ModEmtBpPath .. 'Dimensional_12_emit.bp',  -- smoke cloud
    --ModEmtBpPath .. 'Dimensional_13_emit.bp',  -- large barely visible smoke cloud
    ModEmtBpPath .. 'Dimensional_14_emit.bp',  -- flash
    ModEmtBpPath .. 'Dimensional_15_emit.bp',  -- circle
    --ModEmtBpPath .. 'Dimensional_20_emit.bp',  -- rotating cloud rings inward
    EmtBpPath .. 'destruction_explosion_concussion_ring_03_emit.bp',
}

DimensionalDissipated = {  -- used when the black hole effects are removed
    ModEmtBpPath .. 'Dimensional_11_emit.bp',  -- shockwave ring
    ModEmtBpPath .. 'Dimensional_12_emit.bp',  -- smoke cloud
    ModEmtBpPath .. 'Dimensional_13_emit.bp',  -- large barely visible smoke cloud
    ModEmtBpPath .. 'Dimensional_14_emit.bp',  -- flash
    ModEmtBpPath .. 'Dimensional_15_emit.bp',  -- circle
    ModEmtBpPath .. 'Dimensional_20_emit.bp',  -- rotating cloud rings inward
    EmtBpPath .. 'destruction_explosion_concussion_ring_01_emit.bp',
}

DimensionalDustCloud01 = {
    ModEmtBpPath .. 'Dimensional_dustcloud01_emit.bp',
}

DimensionalDustCloud02 = {
    ModEmtBpPath .. 'Dimensional_dustcloud02_emit.bp',
}

DimensionalFireball = {
    ModEmtBpPath .. 'Dimensional_fireball01_emit.bp',
}

DimensionalFireballHit = {
    ModEmtBpPath .. 'Dimensional_fireball_hit01_emit.bp',
    ModEmtBpPath .. 'Dimensional_fireball_hit02_emit.bp',
}

DimensionalFireballTrail = {
    ModEmtBpPath .. 'Dimensional_fireballtrail.bp',
}

DimensionalFireballPolyTrail = ModEmtBpPath .. 'Dimensional_fireballpolytrail.bp'

DimensionalFireArmSegment1 = {
    ModEmtBpPath .. 'Dimensional_fireline05_emit.bp',
}

DimensionalFireArmSegment2 = {
    ModEmtBpPath .. 'Dimensional_fireline04_emit.bp',
}

DimensionalFireArmSegment3 = {
    ModEmtBpPath .. 'Dimensional_fireline03_emit.bp',
}

DimensionalFireArmSegment4 = {
    ModEmtBpPath .. 'Dimensional_fireline02_emit.bp',
}

DimensionalFireArmSegment5 = {
    ModEmtBpPath .. 'Dimensional_fireline01_emit.bp',
}

DimensionalFireArmCenter1 = {
    EmtBpPath .. 'destruction_explosion_concussion_ring_03_emit.bp',
    ModEmtBpPath .. 'Dimensional_firecenter03_emit.bp',
    ModEmtBpPath .. 'Dimensional_firesparks01_emit.bp',
    ModEmtBpPath .. 'Dimensional_firesparks02_emit.bp',
}

DimensionalFireArmCenter3 = {
	ModEmtBpPath .. 'Dimensional_mist_01_emit.bp', 
	ModEmtBpPath .. 'Dimensional_mist_02_emit.bp',
}

DimensionalFireArmCenter2 = {
    ModEmtBpPath .. 'Dimensional_firecenter02_emit.bp',
}

DimensionalLeftoverPerm = {
    --ModEmtBpPath .. 'Dimensional_leftover_01_emit.bp',  -- fog
    ModEmtBpPath .. 'Dimensional_leftover_02_emit.bp',  -- ball
    ModEmtBpPath .. 'Dimensional_leftover_03_emit.bp',  -- ambient fire
    ModEmtBpPath .. 'Dimensional_leftover_04_emit.bp',  -- ambient fire upward
}

DimensionalPropEffects = {
    --ModEmtBpPath .. 'Dimensional_propeffect01_emit.bp', -- yellow particles
    --ModEmtBpPath .. 'Dimensional_propeffect02_emit.bp', -- brown particles
    --ModEmtBpPath .. 'Dimensional_propeffect03_emit.bp', -- white particles
    --ModEmtBpPath .. 'Dimensional_propeffect04_emit.bp', -- grey particles
--    ModEmtBpPath .. 'Dimensional_propeffect05_emit.bp', -- dirt chunks
}

CExDisintegratorHit01 = {  
    EmtBpPath .. 'proton_bomb_hit_01_emit.bp',
    EmtBpPath .. 'proton_bomb_hit_02_emit.bp', 
    EmtBpPath .. 'disintegratorhvy_hit_flash_01_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_flat_02_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_flat_03_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_04_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_05_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_flat_06_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_07_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_sparks_01_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_flat_08_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_09_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_distort_emit.bp',
}


CExDisintegratorHitLand01 = CExDisintegratorHit01

TDrillMissileImpact01 = {
    EmtBpPath .. 'dust_cloud_05_emit.bp',
    EmtBpPath .. 'dust_cloud_06_emit.bp',
}
