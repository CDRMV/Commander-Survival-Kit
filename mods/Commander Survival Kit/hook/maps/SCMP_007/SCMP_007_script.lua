local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')

function OnPopulate()
	ScenarioUtils.InitializeArmies()
	ScenarioFramework.SetPlayableArea('AREA_1' ,true)
end

function OnStart(self)

#    self.Wind = Sound { Cue='Amb_Planet_Wind_01', Bank='AmbientTest' }
#    PlayLoop(self.Wind)
end
