#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0202/UEL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TLandUnit = import('/lua/defaultunits.lua').ConstructionUnit
local CreateDefaultBuildBeams2 = import('/lua/EffectUtilities.lua').CreateDefaultBuildBeams2
local ModWeaponFile = import('/mods/Commander Survival Kit/lua/FireSupportBarrages.lua')
local TDFArmedBuildLaser = ModWeaponFile.TDFArmedBuildLaser
UEB8801 = Class(TLandUnit) {

    Weapons = {
        Laser = Class(TDFArmedBuildLaser) {},
		Laser2 = Class(TDFArmedBuildLaser) {},
    },

    OnCreate = function(self)
        TLandUnit.OnCreate(self)
		------------------- 
		-- The Turret is an Mobile Unit = Movable Turret durning attack? -- No, so lets deactivate that
		-- Deactivates Move and Turn Speed.
		-- Effects: Keep the Turret to be angled on the Terrian and not movable during attacks

		self:SetSpeedMult(0)
		self:SetTurnMult(0)
		
		-----------------

		self:AddBuildRestriction(categories.UEF * categories.BUILTBYTIER3ENGINEER)	
		self:HideBone('Armor', false)
		self:HideBone('L_CoolSystem', false)
		self:HideBone('R_CoolSystem', false)
		self:HideBone('L_Sensor2', false)
		self:HideBone('R_Sensor2', false)
		self:HideBone('L_Armor', false)
		self:HideBone('R_Armor', false)
		self:HideBone('L_Sensor', false)
		self:HideBone('R_Sensor', false)
		self:HideBone('Turret_Barrel', true)
		local wep = self:GetWeaponByLabel('Laser')
        wep:SetEnabled(false)
    end,
	
	OnStartBuild = function(self, unitBeingBuilt, order)
        TLandUnit.OnStartBuild(self, unitBeingBuilt, order)
		self:SetBuildRate(20)
        self.UnitBeingBuilt = unitBeingBuilt
        self.UnitBuildOrder = order  
    end,

    OnFailedToBuild = function(self)
        TLandUnit.OnFailedToBuild(self)
        if self:BeenDestroyed() then return end
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
		self:SetBuildRate(10)
        self:GetWeaponManipulatorByLabel('Laser'):SetHeadingPitch( self.BuildArmManipulator:GetHeadingPitch() )
    end,
	
	CreateBuildEffects = function( self, unitBeingBuilt, order )
        local UpgradesFrom = unitBeingBuilt:GetBlueprint().General.UpgradesFrom
        # If we are assisting an upgrading unit, or repairing a unit, play seperate effects
        if (order == 'Repair' and not unitBeingBuilt:IsBeingBuilt()) or (UpgradesFrom and UpgradesFrom != 'none' and self:IsUnitState('Guarding'))then
            CreateDefaultBuildBeams2( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
        end           
    end, 

	
	OnStopBuild = function(self, unitBeingBuilt)
        TLandUnit.OnStopBuild(self, unitBeingBuilt)
        if self:BeenDestroyed() then return end
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
		self:SetBuildRate(10)
        --self:SetWeaponEnabledByLabel('RightZephyr', true)
        --self:SetWeaponEnabledByLabel('OverCharge', false)
        --self:GetWeaponManipulatorByLabel('RightZephyr'):SetHeadingPitch( self.BuildArmManipulator:GetHeadingPitch() )
        self.UnitBeingBuilt = nil
        self.UnitBuildOrder = nil        
    end,
	
	OnPaused = function(self)
        #When factory is paused take some action
        self:StopUnitAmbientSound( 'ConstructLoop' )
        TLandUnit.OnPaused(self)
        if self.BuildingUnit then
            TLandUnit.StopBuildingEffects(self, self:GetUnitBeingBuilt())
        end    
    end,
    
    OnUnpaused = function(self)
        if self.BuildingUnit then
            self:PlayUnitAmbientSound( 'ConstructLoop' )
            TLandUnit.StartBuildingEffects(self, self:GetUnitBeingBuilt(), self.UnitBuildOrder)
        end
        TLandUnit.OnUnpaused(self)
    end,
    
    StartBuildingEffects = function(self, unitBeingBuilt, order)
        TLandUnit.StartBuildingEffects(self, unitBeingBuilt, order)
    end,
    
    StopBuildingEffects = function(self, unitBeingBuilt)
        TLandUnit.StopBuildingEffects(self, unitBeingBuilt)
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
            
            #Wait 5 seconds
            WaitSeconds(1)
        end
		WaitSeconds(1)
		end
    end,
	
	OnPaused = function(self)

    end,
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
        if bit == 7 then 
			self.RepairThreadHandle = self:ForkThread(self.RepairThread)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 7 then 
			KillThread(self.RepairThreadHandle)
        end
    end,

	
	
	CreateEnhancement = function(self, enh)
        TLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		if enh =='ArmedLaser' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:SetEnabled(true)
		self:AddCommandCap('RULEUCC_Attack')
		self:AddCommandCap('RULEUCC_RetaliateToggle')
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:RemoveCommandCap('RULEUCC_Repair')
		self:HideBone('Repair_Barrel', true)
		self:ShowBone('Turret_Barrel', true)
        elseif enh == 'ArmedLaserRemove' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:SetEnabled(false)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:HideBone('Turret_Barrel', true)
		elseif enh =='RepairLaser' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:SetEnabled(false)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:HideBone('Turret_Barrel', true)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		self:AddCommandCap('RULEUCC_Repair')
		self:HideBone('Turret_Barrel', true)
		self:ShowBone('Repair_Barrel', true)
        elseif enh == 'RepairLaserRemove' then
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:RemoveCommandCap('RULEUCC_Repair')
		self:HideBone('Repair_Barrel', true)
		elseif enh =='LCoolSystem' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:ChangeDamage(400)
		self:ShowBone('L_CoolSystem', true)
		self:HideBone('L_Sensor2', false)
		self:HideBone('L_Sensor', false)
        elseif enh == 'LCoolSystemRemove' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:ChangeDamage(200)
		self:HideBone('L_CoolSystem', false)
		self:HideBone('L_Sensor2', false)
		self:HideBone('L_Sensor', false)
		elseif enh =='LSensor2' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:ChangeMaxRadius(60)
		self:SetIntelRadius('Vision', 60)
		self:HideBone('L_CoolSystem', false)
		self:ShowBone('L_Sensor2', true)
		self:ShowBone('L_Sensor', true)
        elseif enh == 'LSensor2Remove' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:ChangeMaxRadius(40)
		self:SetIntelRadius('Vision', 40)
		self:HideBone('L_CoolSystem', false)
		self:HideBone('L_Sensor2', false)
		self:HideBone('L_Sensor', false)
		elseif enh =='LSensor' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:ChangeMaxRadius(40)
		self:SetIntelRadius('Vision', 40)
		self:HideBone('L_CoolSystem', false)
		self:HideBone('L_Sensor2', false)
		self:ShowBone('L_Sensor', true)
        elseif enh == 'LSensorRemove' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:ChangeMaxRadius(20)
		self:SetIntelRadius('Vision', 20)
		self:HideBone('L_CoolSystem', false)
		self:HideBone('L_Sensor2', false)
		self:HideBone('L_Sensor', false)
		elseif enh =='RCoolSystem' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:ChangeDamage(400)
		self:ShowBone('R_CoolSystem', true)
		self:HideBone('R_Sensor2', false)
		self:HideBone('R_Sensor', false)
        elseif enh == 'RCoolSystemRemove' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:ChangeDamage(200)
		self:HideBone('R_CoolSystem', false)
		self:HideBone('R_Sensor2', false)
		self:HideBone('R_Sensor', false)
		elseif enh =='RSensor2' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:ChangeMaxRadius(60)
		self:SetIntelRadius('Vision', 60)
		self:HideBone('R_CoolSystem', false)
		self:ShowBone('R_Sensor2', true)
		self:ShowBone('R_Sensor', true)
        elseif enh == 'RSensor2Remove' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:ChangeMaxRadius(40)
		self:SetIntelRadius('Vision', 40)
		self:HideBone('R_CoolSystem', false)
		self:HideBone('R_Sensor2', false)
		self:HideBone('R_Sensor', false)
		elseif enh =='RSensor' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:ChangeMaxRadius(40)
		self:SetIntelRadius('Vision', 40)
		self:HideBone('R_CoolSystem', false)
		self:HideBone('R_Sensor2', false)
		self:ShowBone('R_Sensor', true)
        elseif enh == 'RSensorRemove' then
		local wep = self:GetWeaponByLabel('Laser')
        wep:ChangeMaxRadius(20)
		self:SetIntelRadius('Vision', 20)
		self:HideBone('R_CoolSystem', false)
		self:HideBone('R_Sensor2', false)
		self:HideBone('R_Sensor', false)
		elseif enh =='Armor' then
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
		self:ShowBone('Armor', true)
        elseif enh == 'ArmorRemove' then
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		self:HideBone('Armor', false)
        end
    end,

}

TypeClass = UEB8801