#****************************************************************************
#**
#**  File     :  /cdimage/units/URB1201/URB1201_script.lua
#**  Author(s):  John Comes, Dave Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Tier 2 Power Generator Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CMagnetStructureUnit = import('/lua/defaultunits.lua').StructureUnit

URBCB0400 = Class(CMagnetStructureUnit) {
    AmbientEffects = 'CT2PowerAmbient',
    CircleMesh = '/mods/Commander Survival Kit Units/effects/Entities/CybranRayShield/CybranRayShield_mesh',
	MagnetThread = function(self)
		local Pos = self:GetPosition()
		while true do
        while not self:IsDead() do
            local units = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			self:GetBlueprint().Intel.VisionRadius,
			'Enemy'
			
			)
            for _,unit in units do
				IssueClearCommands({unit})
				IssueMove({unit}, Pos)
            end
            
            WaitSeconds(1)
        end
		WaitSeconds(1)
		end
    end,
	
	DestructionThread = function(self)
		local Pos = self:GetPosition()
		while true do
        while not self:IsDead() do
            local enemyunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			5,
			'Enemy'
			
			)
			
			local allyunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE - categories.UNITMAGNET, 
			self:GetPosition(), 
			5,
			'Ally'
			
			)
            for _,enemyunit in enemyunits do
				enemyunit:Kill()
            end
			
			for _,allyunit in allyunits do
				allyunit:Kill()
            end
            
            WaitSeconds(1)
        end
		WaitSeconds(1)
		end
    end,
	
	StunThread = function(self)
		local Pos = self:GetPosition()
		while true do
        while not self:IsDead() do
            local enemyunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			5,
			'Enemy'
			
			)
			
			local allyunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE - categories.UNITMAGNET, 
			self:GetPosition(), 
			5,
			'Ally'
			
			)
			
			for _,enemyunit in enemyunits do
				enemyunit:SetStunned(2)
            end
			
			for _,allyunit in allyunits do
				allyunit:SetStunned(2)
            end
            
            #Wait 5 seconds
            WaitSeconds(1)
        end
		WaitSeconds(1)
		end
    end,
	
	ReclaimThread = function(self)
		while true do
        while not self:IsDead() do
		local value1,value2, value3, value4 = self:GetSkirtRect()  
		local reclaimprops = GetReclaimablesInRect(value1, value2, value3, value4)
		LOG('reclaimprops: ', reclaimprops)
		for _,prop in reclaimprops do
			IssueReclaim({self}, prop)
        end
		WaitSeconds(1)
        end
		WaitSeconds(1)
		end
    end,
	
	AISupportThread = function(self)
		local Pos = self:GetPosition()
		--local randomnumber = math.random(1,2)
		local randomnumber = 1
		LOG('randomnumber: ', randomnumber)
		while true do
        while not self:IsDead() do
            #Get friendly units in the area (including self)
            local units = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			self:GetBlueprint().Intel.VisionRadius,
			'Enemy'
			
			)
            #Give them a 5 second regen buff
            for _,unit in units do
				while true do
				if randomnumber == 1 then
				if unit == nil then
					self:SetScriptBit('RULEUTC_WeaponToggle', false)
				else
					self:SetScriptBit('RULEUTC_WeaponToggle', true)
				end
				else
				if unit == nil then
					self:SetScriptBit('RULEUTC_SpecialToggle', false)
				else
					self:SetScriptBit('RULEUTC_SpecialToggle', true)
				end
				end
				WaitSeconds(1)
				end
            end
            
            #Wait 5 seconds
            WaitSeconds(1)
        end
		WaitSeconds(1)
		end
    end,
	
    OnStopBeingBuilt = function(self,builder,layer)
		if self:GetAIBrain().BrainType != 'Human' then
			self.ReclaimThreadHandle = self:ForkThread(self.ReclaimThread)
			self.AISupportThreadHandle = self:ForkThread(self.AISupportThread)
		else
			self.ReclaimThreadHandle = self:ForkThread(self.ReclaimThread)
        end
		self:SetMaintenanceConsumptionInactive()
        CMagnetStructureUnit.OnStopBeingBuilt(self,builder,layer)
    end,
	
	CreateWreckage = function (self, overkillRatio)
		if self.RayShieldEntity then
		self.RayShieldEntity:Destroy()
		end
		if self.RayShieldEntity2 then
		self.RayShieldEntity2:Destroy()
		end
		if self.RayShieldEntity3 then
		self.RayShieldEntity3:Destroy()
		end
        if overkillRatio and overkillRatio > 1.0 then
            return
        end
        local bp = self.Blueprint
        local fractionComplete = self:GetFractionComplete()
        if fractionComplete < 0.5 or ((bp.TechCategory == 'EXPERIMENTAL' or bp.CategoriesHash["STRUCTURE"]) and fractionComplete < 1) then
            return
        end
        return self:CreateWreckageProp(overkillRatio)
    end,
	

	OnScriptBitSet = function(self, bit)
        CMagnetStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		ForkThread( function()
			self.MainSpinner = CreateRotator(self, 'Fundament_Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(50)
		    self.Spinner1 = CreateRotator(self, 'Spin1', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner2 = CreateRotator(self, 'Spin2', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner3 = CreateRotator(self, 'Spin3', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner4 = CreateRotator(self, 'Spin4', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner5 = CreateRotator(self, 'Spin5', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner6 = CreateRotator(self, 'Spin6', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner7 = CreateRotator(self, 'Spin7', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner8 = CreateRotator(self, 'Spin8', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner9 = CreateRotator(self, 'Spin9', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner10 = CreateRotator(self, 'Spin10', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner11 = CreateRotator(self, 'Spin11', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner12 = CreateRotator(self, 'Spin12', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner13 = CreateRotator(self, 'Spin13', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner14 = CreateRotator(self, 'Spin14', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner15 = CreateRotator(self, 'Spin15', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.Spinner16 = CreateRotator(self, 'Spin16', 'x', nil, 0, 60, 360):SetTargetSpeed(180)
			self.InnerSpinner1 = CreateRotator(self, 'InnerSpin1', 'x', nil, 0, 60, 360):SetTargetSpeed(-180)
			self.InnerSpinner2 = CreateRotator(self, 'InnerSpin2', 'x', nil, 0, 60, 360):SetTargetSpeed(-180)
			self.InnerSpinner3 = CreateRotator(self, 'InnerSpin3', 'x', nil, 0, 60, 360):SetTargetSpeed(-180)
			self.InnerSpinner4 = CreateRotator(self, 'InnerSpin4', 'x', nil, 0, 60, 360):SetTargetSpeed(-180)
			self.InnerSpinner5 = CreateRotator(self, 'InnerSpin5', 'x', nil, 0, 60, 360):SetTargetSpeed(-180)
			self.InnerSpinner6 = CreateRotator(self, 'InnerSpin6', 'x', nil, 0, 60, 360):SetTargetSpeed(-180)
			self.InnerSpinner7 = CreateRotator(self, 'InnerSpin7', 'x', nil, 0, 60, 360):SetTargetSpeed(-180)
			self.InnerSpinner8 = CreateRotator(self, 'InnerSpin8', 'x', nil, 0, 60, 360):SetTargetSpeed(-180)
			self.Trash:Add(self.MainSpinner)
			self.Trash:Add(self.Spinner1)
			self.Trash:Add(self.Spinner2)
			self.Trash:Add(self.Spinner3)
			self.Trash:Add(self.Spinner4)
			self.Trash:Add(self.Spinner5)
			self.Trash:Add(self.Spinner6)
			self.Trash:Add(self.Spinner7)
			self.Trash:Add(self.Spinner8)
			self.Trash:Add(self.Spinner9)
			self.Trash:Add(self.Spinner10)
			self.Trash:Add(self.Spinner11)
			self.Trash:Add(self.Spinner12)
			self.Trash:Add(self.Spinner13)
			self.Trash:Add(self.Spinner14)
			self.Trash:Add(self.Spinner15)
			self.Trash:Add(self.Spinner16)
			self.Trash:Add(self.InnerSpinner1)
			self.Trash:Add(self.InnerSpinner2)
			self.Trash:Add(self.InnerSpinner3)
			self.Trash:Add(self.InnerSpinner4)
			self.Trash:Add(self.InnerSpinner5)
			self.Trash:Add(self.InnerSpinner6)
			self.Trash:Add(self.InnerSpinner7)
			self.Trash:Add(self.InnerSpinner8)
			self:RemoveToggleCap('RULEUTC_SpecialToggle')
		    self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/magnet_01_emit.bp'):ScaleEmitter(2)
            self.Trash:Add(self.Effect1)
			self:SetMaintenanceConsumptionActive()
			self.MagnetThreadHandle = self:ForkThread(self.MagnetThread)
			self.DestructionThreadHandle = self:ForkThread(self.DestructionThread)
        end)
        end
		if bit == 7 then 
		ForkThread( function()
			self.HideShredders = CreateSlider(self, 'Fundament', 0, -10, 0, 10)
            self.Trash:Add(self.HideShredders)
			WaitFor(self.HideShredders)
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self.RayShieldEntity = import('/lua/sim/Entity.lua').Entity()
			self.RayShieldEntity:AttachBoneTo( -1, self, 'Shield' )
			self.RayShieldEntity:SetMesh(self.CircleMesh)
			self.RayShieldEntity:SetDrawScale(0.30)
			self.RayShieldEntity:SetVizToAllies('Intel')
			self.RayShieldEntity:SetVizToNeutrals('Intel')
			self.RayShieldEntity:SetVizToEnemies('Intel')
			self.RayShieldEntity2 = import('/lua/sim/Entity.lua').Entity()
			self.RayShieldEntity2:AttachBoneTo( -1, self, 'Shield' )
			self.RayShieldEntity2:SetMesh(self.CircleMesh)
			self.RayShieldEntity2:SetDrawScale(0.30)
			self.RayShieldEntity2:SetVizToAllies('Intel')
			self.RayShieldEntity2:SetVizToNeutrals('Intel')
			self.RayShieldEntity2:SetVizToEnemies('Intel')
			self.RayShieldEntity3 = import('/lua/sim/Entity.lua').Entity()
			self.RayShieldEntity3:AttachBoneTo( -1, self, 'Shield' )
			self.RayShieldEntity3:SetMesh(self.CircleMesh)
			self.RayShieldEntity3:SetDrawScale(0.30)
			self.RayShieldEntity3:SetVizToAllies('Intel')
			self.RayShieldEntity3:SetVizToNeutrals('Intel')
			self.RayShieldEntity3:SetVizToEnemies('Intel')
		    self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/magnet_01_emit.bp'):ScaleEmitter(2)
            self.Trash:Add(self.Effect1)
			self:SetMaintenanceConsumptionActive()
			self.MagnetThreadHandle = self:ForkThread(self.MagnetThread)
			self.StunThreadHandle = self:ForkThread(self.StunThread)
        end)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CMagnetStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		ForkThread( function()
			self.MainSpinner:SetTargetSpeed(0)
			self.Spinner1:SetTargetSpeed(0)
			self.Spinner2:SetTargetSpeed(0)
			self.Spinner3:SetTargetSpeed(0)
			self.Spinner4:SetTargetSpeed(0)
			self.Spinner5:SetTargetSpeed(0)
			self.Spinner6:SetTargetSpeed(0)
			self.Spinner7:SetTargetSpeed(0)
			self.Spinner8:SetTargetSpeed(0)
			self.Spinner9:SetTargetSpeed(0)
			self.Spinner10:SetTargetSpeed(0)
			self.Spinner11:SetTargetSpeed(0)
			self.Spinner12:SetTargetSpeed(0)
			self.Spinner13:SetTargetSpeed(0)
			self.Spinner14:SetTargetSpeed(0)
			self.Spinner15:SetTargetSpeed(0)
			self.Spinner16:SetTargetSpeed(0)
			self.InnerSpinner1:SetTargetSpeed(0)
			self.InnerSpinner2:SetTargetSpeed(0)
			self.InnerSpinner3:SetTargetSpeed(0)
			self.InnerSpinner4:SetTargetSpeed(0)
			self.InnerSpinner5:SetTargetSpeed(0)
			self.InnerSpinner6:SetTargetSpeed(0)
			self.InnerSpinner7:SetTargetSpeed(0)
			self.InnerSpinner8:SetTargetSpeed(0)
			self.MainSpinner:Destroy()
			self.Spinner1:Destroy()
			self.Spinner2:Destroy()
			self.Spinner3:Destroy()
			self.Spinner4:Destroy()
			self.Spinner5:Destroy()
			self.Spinner6:Destroy()
			self.Spinner7:Destroy()
			self.Spinner8:Destroy()
			self.Spinner9:Destroy()
			self.Spinner10:Destroy()
			self.Spinner11:Destroy()
			self.Spinner12:Destroy()
			self.Spinner13:Destroy()
			self.Spinner14:Destroy()
			self.Spinner15:Destroy()
			self.Spinner16:Destroy()
			self.InnerSpinner1:Destroy()
			self.InnerSpinner2:Destroy()
			self.InnerSpinner3:Destroy()
			self.InnerSpinner4:Destroy()
			self.InnerSpinner5:Destroy()
			self.InnerSpinner6:Destroy()
			self.InnerSpinner7:Destroy()
			self.InnerSpinner8:Destroy()
			self:SetMaintenanceConsumptionInactive()
			KillThread(self.MagnetThreadHandle)
			KillThread(self.DestructionThreadHandle)
			self.Effect1:Destroy()
			self:AddToggleCap('RULEUTC_SpecialToggle')
        end)
        end
		if bit == 7 then 
		ForkThread( function()
			self.RayShieldEntity:Destroy()
			self.RayShieldEntity2:Destroy()
			self.RayShieldEntity3:Destroy()
			self:SetMaintenanceConsumptionInactive()
			KillThread(self.MagnetThreadHandle)
			KillThread(self.StunThreadHandle)
			self.Effect1:Destroy()
			self.HideShredders = CreateSlider(self, 'Fundament', 0, 10, 0, 10)
            self.Trash:Add(self.HideShredders)
			WaitFor(self.HideShredders)
			self:AddToggleCap('RULEUTC_WeaponToggle')
        end)
        end
    end,
}

TypeClass = URBCB0400