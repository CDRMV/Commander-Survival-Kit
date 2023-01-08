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
