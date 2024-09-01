#****************************************************************************
#**
#**  File     :  /units/XSL0202/XSL0202_script.lua
#**
#**  Summary  :  Seraphim Heavy Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SWalkingLandUnit = import('/lua/defaultunits.lua').ConstructionUnit

CSKSL0302 = Class(SWalkingLandUnit) {

	ReclaimThread = function(self)
		local Pos = self:GetPosition()
		while true do
        while not self:IsDead() do
            local enemylandunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.LAND, 
			self:GetPosition(), 
			25,
			'Enemy'
			
			)
			
			local enemynavalunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.NAVAL, 
			self:GetPosition(), 
			25,
			'Enemy'
			
			)
			
			for _,enemylandunit in enemylandunits do
				IssueReclaim({self}, enemylandunit)
            end
			
			for _,enemynavalunit in enemynavalunits do
				IssueReclaim({self}, enemynavalunit)
            end
            
            #Wait 5 seconds
            WaitSeconds(1)
        end
		WaitSeconds(1)
		end
    end,


    OnStopBeingBuilt = function(self,builder,layer)
        SWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)	
		-- Deactivates the Abilitty to Build Tech 1 Structures.
		-- The Walker is Designed to work as an Mobile Reclaimation Unit only. 
		-- So it should not be able to build anything. 
		self:AddBuildRestriction(categories.SERAPHIM * categories.BUILTBYTIER1ENGINEER)	

		-- Now lets add an Range to the Unit to Reclaim  and Enemy units automatically.
		self.ReclaimThreadHandle = self:ForkThread(self.ReclaimThread)
		
	end,

    OnMotionHorzEventChange = function(self, new, old)
	SWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
	ForkThread( function()
		if old == 'Stopped' then
			self.OpenAnimManip = CreateAnimator(self)
			self.Trash:Add(self.OpenAnimManip)
			self.OpenAnimManip:PlayAnim('/mods/Commander Survival kit Units/units/Seraphim/Land/CSKSL0302/CSKSL0302_Awalk.sca', true):SetRate(0.5)
        elseif new == 'Stopped' then
			self.OpenAnimManip:SetRate(0)
			self.OpenAnimManip:Destroy()
        end
	end)
    end,

}
TypeClass = CSKSL0302