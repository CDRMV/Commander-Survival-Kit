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