#****************************************************************************
#**
#**  File     :  /effects/Entities/EXBillyEffect02/EXBillyEffect04_script.lua
#**  Author(s):  Gordon Duclos
#**
#**  Summary  :  Nuclear explosion script
#**
#**  Copyright © 2005,2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local NullShell = import('/lua/sim/defaultprojectiles.lua').NullShell
local ModEffectTemplate = import('/mods/Reinforcement Manager/lua/FireSupportEffects.lua')

TacNukeEffect04 = Class(NullShell) {
    
    OnCreate = function(self)
		NullShell.OnCreate(self)
		self:ForkThread(self.EffectThread)
    end,
    
    EffectThread = function(self)
		local army = self:GetArmy()
		
		
		WaitSeconds(4)
		for k, v in ModEffectTemplate.TCNukeBaseEffects01 do
			CreateEmitterOnEntity(self, army, v ):ScaleEmitter(0.5)
		end	
    end,      
}

TypeClass = TacNukeEffect04

