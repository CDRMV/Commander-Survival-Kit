#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0202/UEL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ALandUnit = import('/lua/defaultunits.lua').ConstructionUnit
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'
local Buff = import('/lua/sim/Buff.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')
local CreateAeonCommanderBuildingEffects = import('/lua/EffectUtilities.lua').CreateAeonCommanderBuildingEffects
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
local TIFCommanderDeathWeapon = nil

if version < 3652 then
	TIFCommanderDeathWeapon = import('/lua/terranweapons.lua').TIFCommanderDeathWeapon
	else 	
	TIFCommanderDeathWeapon = import("/lua/sim/defaultweapons.lua").SCUDeathWeapon
end 

UAB8802 = Class(ALandUnit) {

	Weapons = {
        DeathWeapon = Class(TIFCommanderDeathWeapon) {},
    },

    ShieldEffects = {
        '/effects/emitters/aeon_shield_generator_t2_01_emit.bp',
        '/effects/emitters/aeon_shield_generator_t2_02_emit.bp',
		'/effects/emitters/aeon_shield_generator_t2_03_emit.bp',
    },

    OnCreate = function(self)
        ALandUnit.OnCreate(self)
		------------------- 
		-- The Turret is an Mobile Unit = Movable Turret durning attack? -- No, so lets deactivate that
		-- Deactivates Move and Turn Speed.
		-- Effects: Keep the Turret to be angled on the Terrian and not movable during attacks
		self:AddBuildRestriction(categories.AEON * categories.BUILTBYTIER3ENGINEER)
		self:SetSpeedMult(0)
		self:SetTurnMult(0)
		self.ShieldEffectsBag = {}
		self.number = 0
		-----------------
		self:SetMaintenanceConsumptionInactive()
		self:HideBone('Armor', false)
		self:HideBone('C', true)
		self:HideBone('Shield_Ring', false)
		self:AddToggleCap('RULEUTC_SpecialToggle')
    end,
	
	RepairThread = function(self)
		local Pos = self:GetPosition()
		while true do
        while not self:IsDead() do
            local landunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.LAND, 
			self:GetPosition(), 
			25,
			'Ally'
			
			)
			
			local navalunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.NAVAL, 
			self:GetPosition(), 
			25,
			'Ally'
			
			)
			
			for _,landunit in landunits do
				IssueRepair({self}, landunit)
            end
			
			for _,navalunit in navalunits do
				IssueRepair({self}, navalunit)
            end
            
            WaitSeconds(1)
        end
		WaitSeconds(1)
		end
    end,
	
	CaptureThread = function(self)
		local Pos = self:GetPosition()
		while true do
        while not self:IsDead() do
            local landunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.LAND, 
			self:GetPosition(), 
			25,
			'Enemy'
			
			)
			
			local navalunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.NAVAL, 
			self:GetPosition(), 
			25,
			'Enemy'
			
			)
			
			for _,landunit in landunits do
				IssueCapture({self}, landunit)
            end
			
			for _,navalunit in navalunits do
				IssueCapture({self}, navalunit)
            end
            
            WaitSeconds(1)
        end
		WaitSeconds(1)
		end
    end,
	
	OnScriptBitSet = function(self, bit)
        ALandUnit.OnScriptBitSet(self, bit)
		local id = self:GetEntityId()
		if bit == 1 then 
		self:Kill()
        end
		if bit == 4 then 
		self:OnProductionUnPaused()
		self.RepairThreadHandle = self:ForkThread(self.RepairThread)
		self.CaptureThreadHandle = self:ForkThread(self.CaptureThread)
        end
        if bit == 7 then 
			self.number = self.number + 1
			if self.number == 1 then
				self:HideBone('Ammo1', false)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				ForkThread( function()
				WaitSeconds(20)
				self:AddToggleCap('RULEUTC_SpecialToggle')
				end)
			end
			if self.number == 2 then
				self:HideBone('Ammo2', false)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				ForkThread( function()
				WaitSeconds(20)
				self:AddToggleCap('RULEUTC_SpecialToggle')
				end)
			end
			if self.number == 3 then
				self:HideBone('Ammo3', false)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				ForkThread( function()
				WaitSeconds(20)
				self:AddToggleCap('RULEUTC_SpecialToggle')
				end)
			end
			if self.number == 4 then
				self:HideBone('Ammo4', false)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				FloatingEntityText(id, 'Warning no more boosts available')
				self:AddToggleCap('RULEUTC_WeaponToggle')
			end
        end
    end,

    OnScriptBitClear = function(self, bit)
        ALandUnit.OnScriptBitClear(self, bit)
		if bit == 4 then 
		KillThread(self.RepairThreadHandle)
		KillThread(self.CaptureThreadHandle)
        end
        if bit == 7 then 
		self:SetScriptBit('RULEUTC_SpecialToggle', true)
        end
    end,
	
	OnStartCapture = function(self, target)
		self:RemoveCommandCap('RULEUCC_Repair')
        self:DoUnitCallbacks( 'OnStartCapture', target )
        self:StartCaptureEffects(target)
        self:BuildManipulatorSetEnabled(true)
    end,
	
	OnStopCapture = function(self, target)
		self:AddCommandCap('RULEUCC_Repair')
        self:DoUnitCallbacks( 'OnStopCapture', target )
        self:StopCaptureEffects(target)
        self:PlayUnitSound('StopCapture')
        self:StopUnitAmbientSound('CaptureLoop')
    end,
	
	OnFailedCapture = function(self, target)
		self:AddCommandCap('RULEUCC_Repair')
        self:DoUnitCallbacks( 'OnFailedCapture', target )
        self:StopCaptureEffects(target)
        self:PlayUnitSound('FailedCapture')
    end,
	
	OnStartBuild = function(self, unitBeingBuilt, order)
		self:RemoveCommandCap('RULEUCC_Capture')
        ALandUnit.OnStartBuild(self, unitBeingBuilt, order)
		self:SetBuildRate(20)
        self.UnitBeingBuilt = unitBeingBuilt
        self.UnitBuildOrder = order  
    end,
	
	OnStopBuild = function(self, unitBeingBuilt)
		self:AddCommandCap('RULEUCC_Capture')
        self:StopBuildingEffects(unitBeingBuilt)
        self:SetActiveConsumptionInactive()
        self:DoOnUnitBuiltCallbacks(unitBeingBuilt)
        self:StopUnitAmbientSound('ConstructLoop')
        self:PlayUnitSound('ConstructStop')
    end,

    OnFailedToBuild = function(self)
        ALandUnit.OnFailedToBuild(self)
		self:AddCommandCap('RULEUCC_Capture')
        if self:BeenDestroyed() then return end
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
		self:SetBuildRate(10)
    end,
	
	CreateBuildEffects = function( self, unitBeingBuilt, order )
        local UpgradesFrom = unitBeingBuilt:GetBlueprint().General.UpgradesFrom
        # If we are assisting an upgrading unit, or repairing a unit, play seperate effects
        if (order == 'Repair' and not unitBeingBuilt:IsBeingBuilt()) or (UpgradesFrom and UpgradesFrom != 'none' and self:IsUnitState('Guarding'))then
            CreateAeonCommanderBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
        end           
    end, 
	
	WeaponBuffThread = function(self)
			
            #Get friendly units in the area (including self)
            local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LAND + categories.MOBILE - categories.DROPSUPPLYDEVICE,
			self:GetPosition(), 
			10
			
			)
            if units == nil then
			FloatingEntityText(id, 'No ally Units in near to give them a boost')
			else
            for _,unit in units do
			    if not Buffs['WeaponBuff'] then
                BuffBlueprint {
                    Name = 'WeaponBuff',
                    DisplayName = 'WeaponBuff',
                    BuffType = 'AMMOWEAPONBUFF',
                    Stacks = 'REPLACE',
                    Duration = 20,
                    Affects = {
						MaxRadius = {
						    Add = 10,
                            Mult = 1,
						},
						Damage = {
                            Add =  50,
                            Mult = 1,
                        },
                    },
                }
				end
                Buff.ApplyBuff(unit, 'WeaponBuff')
            end
			end
    end,
	
	OnShieldEnabled = function(self)
        ALandUnit.OnShieldEnabled(self)
        KillThread( self.DestroyManipulatorsThread )
        if not self.RotatorManipulator then
            self.RotatorManipulator = CreateRotator( self, 'Shield_Ring', 'y' )
            self.Trash:Add( self.RotatorManipulator )
        end
        self.RotatorManipulator:SetAccel( 5 )
        self.RotatorManipulator:SetTargetSpeed( 30 )
        if not self.AnimationManipulator then
            local myBlueprint = self:GetBlueprint()
            #LOG( 'it is ', repr(myBlueprint.Display.AnimationOpen) )
            self.AnimationManipulator = CreateAnimator(self)
            self.AnimationManipulator:PlayAnim( myBlueprint.Display.AnimationOpen )
            self.Trash:Add( self.AnimationManipulator )
        end
        self.AnimationManipulator:SetRate(1)
        
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 'Shield_Ring', self:GetArmy(), v ):ScaleEmitter(0.25):OffsetEmitter(0, -0.73, 0) )
        end
    end,

    OnShieldDisabled = function(self)
        ALandUnit.OnShieldDisabled(self)
        KillThread( self.DestroyManipulatorsThread )
        self.DestroyManipulatorsThread = self:ForkThread( self.DestroyManipulators )
        self.RotatorManipulator:SetTargetSpeed( 0 )
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
    end,
	
	DestroyManipulators = function(self)
        if self.RotatorManipulator then
            self.RotatorManipulator:SetAccel( 10 )
            self.RotatorManipulator:SetTargetSpeed( 0 )
            # Unless it goes smoothly back to its original position,
            # it will snap there when the manipulator is destroyed.
            # So for now, we'll just keep it on.
            #WaitFor( self.RotatorManipulator )
            #self.RotatorManipulator:Destroy()
            #self.RotatorManipulator = nil
        end
    end,
	
	CreateEnhancement = function(self, enh)
        ALandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		if enh =='FluidController' then
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:AddToggleCap('RULEUTC_ProductionToggle')
		self:AddCommandCap('RULEUCC_Capture')
		self:AddCommandCap('RULEUCC_Repair')
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		--self.Effect1 = CreateAttachedEmitter(self,'C',self:GetArmy(), ModeffectPath .. 'aeon_stargate_splash_01_emit.bp'):ScaleEmitter(0.45)
		self.GateEffectEntity = import('/lua/sim/Entity.lua').Entity()
		self.GateEffectEntity:AttachBoneTo(-1, self,'C')
		self.GateEffectEntity:SetMesh('/mods/Commander Survival Kit/units/Drop Stuff/Aeon/Supply Station/UAB8802/Effect/Effect_Mesh')
		self.GateEffectEntity:SetDrawScale(0.4)
		self.GateEffectEntity:SetVizToAllies('Intel')
		self.GateEffectEntity:SetVizToNeutrals('Intel')
		self.GateEffectEntity:SetVizToEnemies('Intel') 
		self:ShowBone('C', true)
        elseif enh == 'FluidControllerRemove' then
		KillThread(self.RepairThreadHandle)
		KillThread(self.CaptureThreadHandle)
		self:RemoveToggleCap('RULEUTC_ProductionToggle')
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self:RemoveCommandCap('RULEUCC_Capture')
		self:RemoveCommandCap('RULEUCC_Repair')
		self.GateEffectEntity:Destroy()
		self:HideBone('C', true)
		elseif enh =='FluidControllerArmor' then
		self:ShowBone('Armor', true)
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
        elseif enh == 'FluidControllerArmorRemove' then
		self:RemoveCommandCap('RULEUCC_Capture')
		self:RemoveCommandCap('RULEUCC_Repair')
		self:RemoveToggleCap('RULEUTC_ProductionToggle')
		self:HideBone('C', true)
		KillThread(self.RepairThreadHandle)
		KillThread(self.CaptureThreadHandle)
		self.GateEffectEntity:Destroy()
		self:HideBone('Armor', true)
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		elseif enh =='SupplyStationArmor' then
		self:ShowBone('Armor', true)
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
        elseif enh == 'SupplyStationArmorRemove' then
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self:HideBone('Armor', true)
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self:HideBone('Supply', true)
		self:HideBone('Shield_Ring', true)
		self:DestroyShield()
		self:SetMaintenanceConsumptionInactive()
        self:RemoveToggleCap('RULEUTC_ShieldToggle')
		elseif enh =='SupplyStationShield' then
		self:HideBone('Armor', true)
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		self:AddToggleCap('RULEUTC_ShieldToggle')
		self:ShowBone('Shield_Ring', true)
		self:CreateShield(bp)
        self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
		self:SetMaintenanceConsumptionActive()
        self:AddToggleCap('RULEUTC_ShieldToggle')
        elseif enh == 'SupplyStationShieldRemove' then
		if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self:HideBone('Supply', true)
		self:HideBone('Shield_Ring', true)
		self:DestroyShield()
		self:SetMaintenanceConsumptionInactive()
        self:RemoveToggleCap('RULEUTC_ShieldToggle')
		end

    end,

	DeathThread = function( self, overkillRatio , instigator) 
		if self.GateEffectEntity then
		self.GateEffectEntity:Destroy()
		end
	
        self:DestroyAllDamageEffects()
		local army = self:GetArmy()

		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		

		self:CreateWreckage(overkillRatio or self.overkillRatio)

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,

}

TypeClass = UAB8802