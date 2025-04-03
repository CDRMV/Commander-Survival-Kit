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

UAFSSP0400 = Class(AAirUnit) {
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
						SphereMesh = '/mods/Commander Survival Kit/effects/Entities/Symbols/Aeon/Logo/Logo_mesh',
						self.Sphere:AttachBoneTo( -1, self, 0 )
						self.Sphere:SetMesh(SphereMesh)
						self.Sphere:SetDrawScale(3.0)
						self.Sphere:SetVizToAllies('Intel')
						self.Sphere:SetVizToNeutrals('Intel')
						self.Sphere:SetVizToEnemies('Intel')
						self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), ModeffectPath .. 'aeon_captureeffect_01_emit.bp'):ScaleEmitter(15.0)
						self.Trash:Add(self.Effect1)
						self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), ModeffectPath .. 'aeon_captureeffect_02_emit.bp'):ScaleEmitter(15.0)
						self.Trash:Add(self.Effect2)
						while true do	
						if not self.Dead then		
						self:StunThread()
						self:CaptureThread()
						end
						WaitSeconds(0.1)
						end	
                    end
                  )
    end,
	
	CaptureThread = function(self)
			local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK-Units" then return mod.location end end end
			local CSKUnitsPath = GetCSKUnitsPath()
            local enemyunits = nil
			if CSKUnitsPath then 	
			enemyunits = GetArmyBrain(self:GetArmy()):GetUnitsAroundPoint(
			
			categories.ALLUNITS - categories.AIR - categories.EXPERIMENTAL - categories.ELITE - categories.HERO - categories.TITAN,
			self:GetPosition(), 
			15,
			'Enemy'
			
			)
			
			else
			enemyunits = GetArmyBrain(self:GetArmy()):GetUnitsAroundPoint(
			
			categories.ALLUNITS + categories.AIR - categories.EXPERIMENTAL,
			self:GetPosition(), 
			15,
			'Enemy'
			
			)
			end

			if enemyunits[1] == nil and self:IsIdleState() then
			CreateLightParticle( self, 0, self:GetArmy(), 10, 15, 'glow_03', 'ramp_white_01' ) 
			self.Sphere:Destroy()
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self:Destroy()
			else
			self.Sphere1 = import('/lua/sim/Entity.lua').Entity()
			SphereMesh = '/mods/Commander Survival Kit/effects/Entities/Symbols/Aeon/Logo/Logo_mesh',
			self.Sphere1:AttachBoneTo( -1, enemyunits[1], 0 )
			self.Sphere1:SetParentOffset({0,2,0})
			self.Sphere1:SetMesh(SphereMesh)
			self.Sphere1:SetDrawScale(0.3)
			self.Sphere1:SetVizToAllies('Intel')
			self.Sphere1:SetVizToNeutrals('Intel')
			self.Sphere1:SetVizToEnemies('Intel')
			self.UnitEffect1 = CreateAttachedEmitter(enemyunits[1],0,self:GetArmy(), ModeffectPath .. 'aeon_captureeffect_01_emit.bp'):ScaleEmitter(1.0):OffsetEmitter(0, 0.1, 0)
			self.Trash:Add(self.UnitEffect1)
			self.UnitEffect2 = CreateAttachedEmitter(enemyunits[1],0,self:GetArmy(), ModeffectPath .. 'aeon_captureeffect_02_emit.bp'):ScaleEmitter(1.0):OffsetEmitter(0, 0.1, 0)
			self.Trash:Add(self.UnitEffect2)
			WaitSeconds(5)
			ChangeUnitArmy(enemyunits[1], self:GetArmy())
			self.Sphere1:Destroy()
			end
    end,
	
	StunThread = function(self)
			local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK-Units" then return mod.location end end end
			local CSKUnitsPath = GetCSKUnitsPath()
            local enemyunits = nil
			if CSKUnitsPath then 	
			enemyunits = GetArmyBrain(self:GetArmy()):GetUnitsAroundPoint(
			
			categories.ALLUNITS - categories.AIR - categories.EXPERIMENTAL - categories.ELITE - categories.HERO - categories.TITAN,
			self:GetPosition(), 
			15,
			'Enemy'
			
			)
			
			for _,unit in enemyunits do
				unit:SetStunned(99999)
            end
			
			else
			enemyunits = GetArmyBrain(self:GetArmy()):GetUnitsAroundPoint(
			
			categories.ALLUNITS + categories.AIR - categories.EXPERIMENTAL,
			self:GetPosition(), 
			15,
			'Enemy'
			
			)
			
			for _,unit in enemyunits do
				unit:SetStunned(99999)
            end
			
			end

    end,
}

TypeClass = UAFSSP0400