
--[[
do


local EnhAbilityControl = import('/mods/Research/lua/EnhAbilityControl.lua')
local IntelAbilityControl = import('/mods/Research/lua/IntelAbilityControl.lua')
local FieldAbilityControl = import('/mods/Research/lua/FieldAbilityControl.lua')
local SWAbilityControl = import('/mods/Research/lua/SWAbilityControl.lua')


--Enh panel
#resource +20/40/60/80/100%
Callbacks.PassEcoStructureEnhOutputsData = EnhAbilityControl.EcoStructureAddToggle

#buildratebuff +20/40/60/80/100%
Callbacks.PassbuildratebuffAddData = EnhAbilityControl.BuildratebuffToggle

#healthbuff +20/40/60/80/100%
Callbacks.PassHealthBuffData = EnhAbilityControl.HealthBuffToggle

#ROFbuff +10/25/40/65/100%
Callbacks.PassROFBuffData = EnhAbilityControl.ROFBuffToggle

#Damagebuff +20/40/60/80/100%
Callbacks.PassDamageBuffData = EnhAbilityControl.DamageBuffToggle

#range buff +10/20/30/40/50%
Callbacks.PassRangeBuffData = EnhAbilityControl.RangeBuffToggle

#vision buff +10/20/30/40/50%
Callbacks.PassVisionBuffData = EnhAbilityControl.VisionBuffToggle

#veterancy 1/2/3/4/5
Callbacks.PassVeterancyBuffData = EnhAbilityControl.VeterancyBuffToggle

#resource balance
Callbacks.EcoBalExUIToggle = EnhAbilityControl.EcoBalEXUI
Callbacks.PassEcoBalanceData = EnhAbilityControl.EcoEXToggle

#get 5% mass from kills
Callbacks.PassKillReclaimData = EnhAbilityControl.KillReclaimToggle

#give mass 10K
Callbacks.PassGiveResourceData = EnhAbilityControl.GiveResourceMass

#shield buff +20/40/60/80/100%
Callbacks.PassShieldBuffData = EnhAbilityControl.ShieldBuffToggle

#unlock research lab
Callbacks.PassUnlockData = EnhAbilityControl.UnlockResearchLab
#research online prepare ui
Callbacks.GameHasResearchLabThread = EnhAbilityControl.ResearchLabUIThread


--intel panel
#base helper drones, vision drone
Callbacks.PassBaseDroneData = IntelAbilityControl.BaseHelperToggle

#map size viz
Callbacks.PassMapSizeVizData = IntelAbilityControl.CreateMapSizeViz

#field support radar, radar stealth, omni, vision
Callbacks.PassRadarStealthData = IntelAbilityControl.CreateFieldSupportIntel

#pass experimental alert data to ExpAlertPing
Callbacks.PassAlertInitialData = IntelAbilityControl.AlertInitial
#turn on experimental alert
Callbacks.PassExpAlertUnlockData = IntelAbilityControl.StartExpAlert


--field support panel
#field support units 
Callbacks.PassFieldSupports = FieldAbilityControl.CreateFieldSupports

#field regen
Callbacks.PassFieldRegen = FieldAbilityControl.CreateFieldRegen


--super weapon panel
#gate in
Callbacks.PassGateInData = SWAbilityControl.CreateGateInUnit

#gate out
Callbacks.PassGateOutData = SWAbilityControl.CreateGateOutUnit

#teleport units in range
Callbacks.PassUnitstoTeleportData = SWAbilityControl.TeleportUnitsInRange

#UEF black hole
Callbacks.PassUEFBlackHoleStrikeData = SWAbilityControl.CreateUEFBlackHoleStrike

#nuke strike
Callbacks.PassNukeStrikeData = SWAbilityControl.CreateNukeStrike

#UEF Titan square
Callbacks.PassReinforcementData = SWAbilityControl.CreateReinforcementSquare

end

]]--

do
local ControlMechanics = import('/mods/Commander Survival Kit Research/lua/UnlockTechnologies.lua')

Callbacks.DoUnlockTech2 = ControlMechanics.UnlockTech2Structures
Callbacks.DoUnlockTech3 = ControlMechanics.UnlockTech3Structures
Callbacks.DoUnlockExperimental = ControlMechanics.UnlockExperimental

end