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
local EffectUtil = import('/lua/EffectUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
local TIFCommanderDeathWeapon = nil

if version < 3652 then
	TIFCommanderDeathWeapon = import('/lua/terranweapons.lua').TIFCommanderDeathWeapon
	else 	
	TIFCommanderDeathWeapon = import("/lua/sim/defaultweapons.lua").SCUDeathWeapon
end 



UEB8802 = Class(TLandUnit) {

	Weapons = {
        DeathWeapon = Class(TIFCommanderDeathWeapon) {},
    },



    IntelEffects = {
		{
			Bones = {
				'Effect',
			},
			Offset = {
				0,
				0,
				0,
			},
			Scale = 0.2,
			Type = 'Jammer01',
		},
    },

    ShieldEffects = {
        '/effects/emitters/terran_shield_generator_mobile_01_emit.bp',
        '/effects/emitters/terran_shield_generator_mobile_02_emit.bp',
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
		self.ShieldEffectsBag = {}
		self.number = 0
		self:HideBone('Spinner', true)
		self:HideBone('Spinner2', true)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TLandUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread( function()
		self:SetMaintenanceConsumptionInactive()
        self:DisableUnitIntel('Jammer')
        self:DisableUnitIntel('RadarStealthField')
		WaitSeconds(3)
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(1)
		WaitFor(self.OpenAnimManip)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		end)
    end,
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
		local id = self:GetEntityId()
		if bit == 1 then 
		self:Kill()
        end
        if bit == 7 then 
			self.number = self.number + 1
			if self.number == 1 then
				self:HideBone('Ammo01', false)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				ForkThread( function()
				WaitSeconds(20)
				self:AddToggleCap('RULEUTC_SpecialToggle')
				end)
			end
			if self.number == 2 then
				self:HideBone('Ammo02', false)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				ForkThread( function()
				WaitSeconds(20)
				self:AddToggleCap('RULEUTC_SpecialToggle')
				end)
			end
			if self.number == 3 then
				self:HideBone('Ammo03', false)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				ForkThread( function()
				WaitSeconds(20)
				self:AddToggleCap('RULEUTC_SpecialToggle')
				end)
			end
			if self.number == 4 then
				self:HideBone('Ammo04', false)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				self.OpenAnimManip:SetRate(-1)
				FloatingEntityText(id, 'Warning no more boosts available')
				self:AddToggleCap('RULEUTC_WeaponToggle')
			end
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 7 then 
		self:SetScriptBit('RULEUTC_SpecialToggle', true)
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
        TLandUnit.OnShieldEnabled(self)
        KillThread( self.DestroyManipulatorsThread )
        if not self.RotatorManipulator then
            self.RotatorManipulator = CreateRotator( self, 'Spinner', 'y' )
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
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 'Spinner', self:GetArmy(), v ) )
        end
    end,

    OnShieldDisabled = function(self)
        TLandUnit.OnShieldDisabled(self)
        KillThread( self.DestroyManipulatorsThread )
        self.DestroyManipulatorsThread = self:ForkThread( self.DestroyManipulators )
        
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
    end,
	
	OnIntelEnabled = function(self)
	    if self.IntelEffects and not self.IntelFxOn then
			self.IntelEffectsBag = {}
			self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
			self.IntelFxOn = true
		end
        if not self.MySpinner then
            self.MySpinner = CreateRotator(self, 'Spinner2', 'y', nil, 0, 45, 180)
            self.Trash:Add(self.MySpinner)
        end
        TLandUnit.OnIntelEnabled(self)
        self.MySpinner:SetTargetSpeed(180)
    end,
    
    OnIntelDisabled = function(self)
        TLandUnit.OnIntelDisabled(self)
		EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
        self.IntelFxOn = false
        self.MySpinner:SetTargetSpeed(0)
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
        if self.AnimationManipulator then
            self.AnimationManipulator:SetRate(-1)
            WaitFor( self.AnimationManipulator )
            self.AnimationManipulator:Destroy()
            self.AnimationManipulator = nil
        end
    end,


    NotifyOfPodDeath = function(self, pod)

    end,
	
	
	CreateEnhancement = function(self, enh)
        TLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		if enh =='ShieldGen' then
		self:ShowBone('Spinner', true)
		self:AddToggleCap('RULEUTC_ShieldToggle')
		self:CreateShield(bp)
        self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
        self:SetMaintenanceConsumptionActive()
		self:EnableShield()
        elseif enh == 'ShieldGenRemove' then
		self:HideBone('Spinner', true)
		self:DestroyShield()
        self:SetMaintenanceConsumptionInactive()
        self:RemoveToggleCap('RULEUTC_ShieldToggle')
		elseif enh =='JammerGen' then
		self:ShowBone('Spinner2', true)
		self:AddToggleCap('RULEUTC_StealthToggle')
        self:SetMaintenanceConsumptionActive()
        self:EnableUnitIntel('Jammer')
        self:EnableUnitIntel('RadarStealthField')
        elseif enh == 'JammerGenRemove' then
		self:HideBone('Spinner2', true)
		self:RemoveToggleCap('RULEUTC_StealthToggle')
		self:SetMaintenanceConsumptionInactive()
        self:DisableUnitIntel('Jammer')
        self:DisableUnitIntel('RadarStealthField')
		elseif enh =='RepairDrone' then
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:HideBone('Ammo01', false)
		self:HideBone('Ammo02', false)
		self:HideBone('Ammo03', false)
		self:HideBone('Ammo04', false)
        local location = self:GetPosition('AttachSpecial01')
		local Drone1 = CreateUnitHPR('XEA0010', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
        Drone1:SetParent(self, 'Drone1')
        Drone1:SetCreator(self)
		self.Drone1 = Drone1
		local location2 = self:GetPosition('AttachSpecial02')
		local Drone2 = CreateUnitHPR('XEA0010', self:GetArmy(), location2[1], location2[2], location2[3], 0, 0, 0)
        Drone2:SetParent(self, 'Drone2')
        Drone2:SetCreator(self)
		self.Drone2 = Drone2
		local location3 = self:GetPosition('AttachSpecial03')
		local Drone3 = CreateUnitHPR('XEA0010', self:GetArmy(), location3[1], location3[2], location3[3], 0, 0, 0)
        Drone3:SetParent(self, 'Drone3')
        Drone3:SetCreator(self)
		self.Drone3 = Drone3
		local location4 = self:GetPosition('AttachSpecial04')
		local Drone4 = CreateUnitHPR('XEA0010', self:GetArmy(), location4[1], location4[2], location4[3], 0, 0, 0)
        Drone4:SetParent(self, 'Drone4')
        Drone4:SetCreator(self)
		self.Drone4 = Drone4
        elseif enh == 'RepairDroneRemove' then
		if self.Drone1 and not self.Drone1:IsDead() then
		self.Drone1:Kill()
		end
		if self.Drone2 and not self.Drone2:IsDead() then
		self.Drone2:Kill()
		end
		if self.Drone3 and not self.Drone3:IsDead() then
		self.Drone3:Kill()
		end
		if self.Drone4 and not self.Drone4:IsDead() then
		self.Drone4:Kill()
		end
		elseif enh =='CombatDrone' then
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:HideBone('Ammo01', false)
		self:HideBone('Ammo02', false)
		self:HideBone('Ammo03', false)
		self:HideBone('Ammo04', false)
        local location = self:GetPosition('AttachSpecial01')
		local Drone1 = CreateUnitHPR('XEA0011', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
        Drone1:SetParent(self, 'Drone1')
        Drone1:SetCreator(self)
		self.Drone1 = Drone1
		local location2 = self:GetPosition('AttachSpecial02')
		local Drone2 = CreateUnitHPR('XEA0011', self:GetArmy(), location2[1], location2[2], location2[3], 0, 0, 0)
        Drone2:SetParent(self, 'Drone2')
        Drone2:SetCreator(self)
		self.Drone2 = Drone2
		local location3 = self:GetPosition('AttachSpecial03')
		local Drone3 = CreateUnitHPR('XEA0011', self:GetArmy(), location3[1], location3[2], location3[3], 0, 0, 0)
        Drone3:SetParent(self, 'Drone3')
        Drone3:SetCreator(self)
		self.Drone3 = Drone3
		local location4 = self:GetPosition('AttachSpecial04')
		local Drone4 = CreateUnitHPR('XEA0011', self:GetArmy(), location4[1], location4[2], location4[3], 0, 0, 0)
        Drone4:SetParent(self, 'Drone4')
        Drone4:SetCreator(self)
		self.Drone4 = Drone4
        elseif enh == 'CombatDroneRemove' then
		if self.Drone1 and not self.Drone1:IsDead() then
		self.Drone1:Kill()
		end
		if self.Drone2 and not self.Drone2:IsDead() then
		self.Drone2:Kill()
		end
		if self.Drone3 and not self.Drone3:IsDead() then
		self.Drone3:Kill()
		end
		if self.Drone4 and not self.Drone4:IsDead() then
		self.Drone4:Kill()
		end
        end
    end,

}

TypeClass = UEB8802