#****************************************************************************
#**
#**  File     :  /effects/Entities/UEFNukeEffect02/UEFNukeEffect02_script.lua
#**  Author(s):  Gordon Duclos
#**
#**  Summary  :  Nuclear explosion script
#**
#**  Copyright � 2005,2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local NullShell = import('/lua/sim/defaultprojectiles.lua').NullShell
local EffectTemplate = import('/lua/EffectTemplates.lua')

Blu3000Effect02 = Class(NullShell) {
    
    OnCreate = function(self)
		NullShell.OnCreate(self)
		self:ForkThread(self.EffectThread)
    end,
    
    EffectThread = function(self)
		local army = self:GetArmy()
		
		
		WaitSeconds(4)
		for k, v in EffectTemplate.TNukeHeadEffects01 do
			CreateEmitterOnEntity(self, army, v )--:ScaleEmitter(0.25) 
		end	

		self:SetVelocity(0,0.05,0)
    end,      
}

TypeClass = Blu3000Effect02

