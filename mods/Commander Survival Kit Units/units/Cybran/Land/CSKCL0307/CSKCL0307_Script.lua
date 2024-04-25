#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0303/URL0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local explosion = import('/lua/defaultexplosions.lua')
local CMobileAdvancedKamikazeBombWeapon = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').CMobileAdvancedKamikazeBombWeapon

CSKCL0307 = Class(CWalkingLandUnit) 
{
    Weapons = {
        
        Suicide = Class(CMobileAdvancedKamikazeBombWeapon) {   
     
			OnFire = function(self)			
				#disable death weapon
				self.unit:SetDeathWeaponEnabled(false)
				CMobileAdvancedKamikazeBombWeapon.OnFire(self)
			end,
        },
    },
	
	OnMotionHorzEventChange = function(self, new, old)
        CWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
		if old == 'Stopped' then
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
        elseif new == 'Stopped' then
			self:AddToggleCap('RULEUTC_WeaponToggle')
			self:SetScriptBit('RULEUTC_WeaponToggle', false)
        end
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0)
        self.Spinner1 = CreateRotator(self, 'Drill', 'x', nil, 0, 60, 360):SetTargetSpeed(0),
        self.Trash:Add(self.Spinner1)

        self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_CloakToggle', true)
		self:RemoveToggleCap('RULEUTC_CloakToggle')
        self:RequestRefreshUI()
    end,
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
			ForkThread( function()
            self.Spinner1:SetTargetSpeed(180)
			self.Effect1 = CreateAttachedEmitter(self,'Drill',self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(1):SetEmitterParam('LIFETIME', 20)
			self.Trash:Add(self.Effect1)
			self:SetUnSelectable(true)
			self:SetImmobile(true)
			self:RemoveCommandCap('RULEUCC_Move')
			self:RemoveCommandCap('RULEUCC_Guard')
			self:RemoveCommandCap('RULEUCC_Patrol')
			self.OpenAnimManip:SetRate(1)
			WaitFor(self.OpenAnimManip)
			CreateDecal(self:GetPosition(), 0, 'scorch_001_albedo', '', 'Albedo', 2, 2, 150, 150, self:GetArmy())
			self:SetMaintenanceConsumptionActive()
			self:AddToggleCap('RULEUTC_CloakToggle')
			self:SetScriptBit('RULEUTC_CloakToggle', false)
			self:SetUnSelectable(false)
			self.MineCheckTargetsThreadHandle = self:ForkThread(self.MineCheckTargetsThread)
			self.Spinner1:SetTargetSpeed(0)
			end)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
			ForkThread( function()
			CreateDecal(self:GetPosition(), 0, 'scorch_001_albedo', '', 'Albedo', 2, 2, 150, 150, self:GetArmy())
			self.Effect1 = CreateAttachedEmitter(self,'Drill',self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(1):SetEmitterParam('LIFETIME', 20)
			self.Trash:Add(self.Effect1)
            self.Spinner1:SetTargetSpeed(180)
			self:SetUnSelectable(true)
		    self:SetMaintenanceConsumptionInactive()
			self:SetScriptBit('RULEUTC_CloakToggle', true)
			self:RemoveToggleCap('RULEUTC_CloakToggle')
			self.OpenAnimManip:SetRate(-1)
			WaitFor(self.OpenAnimManip)
			self:AddCommandCap('RULEUCC_Move')
			self:AddCommandCap('RULEUCC_Guard')
			self:AddCommandCap('RULEUCC_Patrol')
			self:SetImmobile(false)
			self:SetUnSelectable(false)
            self.Spinner1:SetTargetSpeed(0)
			end)
        end
    end,

	
	DeathThread = function( self, overkillRatio , instigator)  

        self:DestroyAllDamageEffects()

        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end

		self:GetWeaponByLabel'Suicide':FireWeapon()

    
        local position = self:GetPosition()
        local Nanites = CreateUnitHPR('URFSSP05XX', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,

	MineCheckTargetsThread = function(self)
		local unitPos = self:GetPosition()
        while not self:IsDead() do
            #Get Enemy units in the area
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE, unitPos, 4, 'Enemy')
            for _,unit in units do
				ForkThread( function()
				self.ArmSlider = CreateSlider(self, 'Trigger')
				self.Trash:Add(self.ArmSlider)
				self.ArmSlider:SetGoal(0, 0, -4)
				self.ArmSlider:SetSpeed(40)
				WaitFor(self.ArmSlider)
                self:GetWeaponByLabel'Suicide':FireWeapon()
				end)
            end
            
            #Wait 5 seconds
            WaitSeconds(5)
        end
    end,

	
}
TypeClass = CSKCL0307