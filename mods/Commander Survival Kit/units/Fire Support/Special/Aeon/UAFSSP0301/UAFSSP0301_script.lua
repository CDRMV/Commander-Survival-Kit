#****************************************************************************
#**
#**  UEF Medium Artillery Strike
#**  Author(s):  CDRMV
#**
#**  Summary  :  A Dummy Unit which fires Artillery Strikes below it. 
#**				 It is Selectable and Untargetable by enemy Units.				
#**				 It attacks enemy Units automatically in Range and will be destroyed after 10 Seconds.
#**              
#**  Copyright © 2022 Fire Support Manager by CDRMV
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit
local AIFMediumArtilleryStrike = import('/mods/Commander Survival Kit/lua/FireSupportBarrages.lua').AIFMediumArtilleryStrike
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'
UAFSSP0301 = Class(AAirUnit) {

    OnCreate = function(self)
        AAirUnit.OnCreate(self)
        local pos = self:GetPosition()
        
        local aiBrain = self:GetAIBrain()

        ForkThread( function()
						WaitSeconds(1)
						CreateLightParticle( self, 0, self:GetArmy(), 3, 7, 'glow_03', 'ramp_white_01' ) 
						self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), ModeffectPath .. 'aeon_teleport_01_emit.bp'):ScaleEmitter(0.55)
						self.Trash:Add(self.Effect1)
						self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), ModeffectPath .. 'aeon_teleport_02_emit.bp'):ScaleEmitter(0.55)
						self.Trash:Add(self.Effect2)
						self.Effect3 = CreateAttachedEmitter(self,0,self:GetArmy(), ModeffectPath .. 'aeon_teleport_03_emit.bp'):ScaleEmitter(0.65)
						self.Trash:Add(self.Effect3)

						WaitSeconds(10)
                        CreateLightParticle( self, 0, self:GetArmy(), 3, 7, 'glow_03', 'ramp_white_01' ) 
						self.Effect4 = CreateAttachedEmitter(self,0,self:GetArmy(), ModeffectPath .. 'aeon_TeleportRing_01_emit.bp'):ScaleEmitter(0.55)
						self.Trash:Add(self.Effect4)
						self.Effect6 = CreateAttachedEmitter(self,0,self:GetArmy(), ModeffectPath .. 'aeon_teleport_03_emit.bp'):ScaleEmitter(0.65)
						self.Trash:Add(self.Effect6)
						self.Effect7 = CreateAttachedEmitter(self,0,self:GetArmy(), ModeffectPath .. 'aeon_teleport_04_emit.bp'):ScaleEmitter(0.75)
						self.Trash:Add(self.Effect7)
						WaitSeconds(5)
                        self.Effect1:Destroy()
						self.Effect2:Destroy()
						self.Effect3:Destroy()
						self.Effect4:Destroy()
						self.Effect6:Destroy()
						self.Effect7:Destroy()
						CreateLightParticle( self, 0, self:GetArmy(), 6, 10, 'glow_03', 'ramp_white_01' ) 
						self.Sphere = import('/lua/sim/Entity.lua').Entity()
						SphereMesh = '/mods/Commander Survival Kit/units/Fire Support/Special/Aeon/UAFSSP0301/Sphere01/Sphere01_mesh',
						self.Sphere:AttachBoneTo( -1, self, 0 )
						self.Sphere:SetMesh(SphereMesh)
						self.Sphere:SetDrawScale(3.0)
						self.Sphere:SetVizToAllies('Intel')
						self.Sphere:SetVizToNeutrals('Intel')
						self.Sphere:SetVizToEnemies('Intel')
						self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), '/effects/emitters/aeon_build_01_emit.bp'):ScaleEmitter(10.0)
						self.Trash:Add(self.Effect1)
						self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), '/effects/emitters/aeon_build_02_emit.bp'):ScaleEmitter(10.0)
						self.Trash:Add(self.Effect2)
						self.ReclaimThreadHandle = self:ForkThread(self.ReclaimThread)
                    end
                  )
    end,
	
	ReclaimThread = function(self)
		local Pos = self:GetPosition()
        while not self:IsDead() do
            local enemyunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.ALLUNITS - categories.AIR, 
			self:GetPosition(), 
			15,
			'Enemy'
			
			)

			if enemyunits[1] == nil and self:IsIdleState() then
			CreateLightParticle( self, 0, self:GetArmy(), 10, 15, 'glow_03', 'ramp_white_01' ) 
			self.Sphere:Destroy()
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self:Destroy()
			elseif enemyunits[1] and not enemyunits[1].Dead and self:IsIdleState() then 
			IssueReclaim({self}, enemyunits[1])
            end
			
            
            WaitSeconds(0.1)
        end
    end,
}

TypeClass = UAFSSP0301