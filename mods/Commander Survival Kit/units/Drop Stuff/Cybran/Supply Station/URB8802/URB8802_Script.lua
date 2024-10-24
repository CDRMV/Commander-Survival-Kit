#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0202/UEL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CLandUnit = import('/lua/defaultunits.lua').ConstructionUnit
local ModEffectpath = '/mods/Commander Survival Kit/effects/emitters/'
local EffectUtil = import('/lua/EffectUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
local TIFCommanderDeathWeapon = nil
local CIFMissileLoaTacticalWeapon = import('/lua/cybranweapons.lua').CIFMissileLoaTacticalWeapon
if version < 3652 then
	TIFCommanderDeathWeapon = import('/lua/terranweapons.lua').TIFCommanderDeathWeapon
	else 	
	TIFCommanderDeathWeapon = import("/lua/sim/defaultweapons.lua").SCUDeathWeapon
end 



URB8802 = Class(CLandUnit) {

	Weapons = {
		NaniteCapsuleMissile = Class(CIFMissileLoaTacticalWeapon) {},
        DeathWeapon = Class(TIFCommanderDeathWeapon) {},
    },


    OnCreate = function(self)
        CLandUnit.OnCreate(self)
		------------------- 
		-- The Turret is an Mobile Unit = Movable Turret durning attack? -- No, so lets deactivate that
		-- Deactivates Move and Turn Speed.
		-- Effects: Keep the Turret to be angled on the Terrian and not movable during attacks

		self:SetSpeedMult(0)
		self:SetTurnMult(0)
		
		-----------------
		self.number = 0
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread( function()
        self:SetWeaponEnabledByLabel('NaniteCapsuleMissile', false)
		self:RemoveCommandCap('RULEUCC_Tactical')
        self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
		self.NaniteDamage = 10
		self.NaniteRegen = 5
		self:SetMaintenanceConsumptionInactive()
		self:DisableUnitIntel('Cloak')
		WaitSeconds(3)
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		end)
    end,
	
	RegenBuffThread = function(self)
        while not self:IsDead() do
            #Get friendly units in the area (including self)
            local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			15
			
			)
            local buff
            local type
			buff = 'NaniteRegen1'
			if not Buffs[buff] then
                local buff_bp = {
                    Name = buff,
                    DisplayName = buff,
                    BuffType = 'VETERANCYREGEN',
                    Stacks = 'REPLACE',
                    Duration = 1,
                    Affects = {
                        Regen = {
                            Add = self.NaniteRegen,
                            Mult = 1,
                        },
                    },
                }
                BuffBlueprint(buff_bp)
            end
            for _,unit in units do
                Buff.ApplyBuff(unit, 'NaniteRegen1')
            end
            
            WaitSeconds(1)
        end
    end,
	
	StunThread = function(self)
        while not self:IsDead() do
            #Get friendly units in the area (including self)
			DamageArea(self, self:GetPosition(), 15, self.NaniteDamage, 'Fire', false, false)
            local units = self:GetAIBrain():GetUnitsAroundPoint(
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			15,
			'Enemy'
			
			)
            for _,unit in units do
				unit:SetStunned(2)
            end
            
            WaitSeconds(5)
        end
    end,
	
	OnScriptBitSet = function(self, bit)
        CLandUnit.OnScriptBitSet(self, bit)
		local id = self:GetEntityId()
		if bit == 1 then 
		self:Kill()
        end
        if bit == 7 then 
			self.number = self.number + 1
			if self.number == 1 then
				ForkThread( function()
				self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'nanites_01_emit.bp'):ScaleEmitter(5.0):SetEmitterParam('LIFETIME', -1)
				self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'nanites_03_emit.bp'):ScaleEmitter(5.0):SetEmitterParam('LIFETIME', -1)
				self.RegenThreadHandle = self:ForkThread(self.RegenBuffThread)
				self.StunThreadHandle = self:ForkThread(self.StunThread)
				self.OpenAnimManip:SetRate(1)
				WaitFor(self.OpenAnimManip)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				WaitSeconds(20)
				KillThread(self.RegenThreadHandle)
				KillThread(self.StunThreadHandle)
				self.Effect1:Destroy()
				self.Effect2:Destroy()
				self.OpenAnimManip:SetRate(-1)
				WaitFor(self.OpenAnimManip)
				self:AddToggleCap('RULEUTC_SpecialToggle')
				end)
			end
			if self.number == 2 then
				ForkThread( function()
				self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'nanites_01_emit.bp'):ScaleEmitter(5.0):SetEmitterParam('LIFETIME', -1)
				self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'nanites_03_emit.bp'):ScaleEmitter(5.0):SetEmitterParam('LIFETIME', -1)
				self.RegenThreadHandle = self:ForkThread(self.RegenBuffThread)
				self.StunThreadHandle = self:ForkThread(self.StunThread)
				self.OpenAnimManip:SetRate(1)
				WaitFor(self.OpenAnimManip)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				WaitSeconds(20)
				KillThread(self.RegenThreadHandle)
				KillThread(self.StunThreadHandle)
				self.Effect1:Destroy()
				self.Effect2:Destroy()
				self.OpenAnimManip:SetRate(-1)
				WaitFor(self.OpenAnimManip)
				self:AddToggleCap('RULEUTC_SpecialToggle')
				end)
			end
			if self.number == 3 then
				ForkThread( function()
				self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'nanites_01_emit.bp'):ScaleEmitter(5.0):SetEmitterParam('LIFETIME', -1)
				self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'nanites_03_emit.bp'):ScaleEmitter(5.0):SetEmitterParam('LIFETIME', -1)
				self.RegenThreadHandle = self:ForkThread(self.RegenBuffThread)
				self.StunThreadHandle = self:ForkThread(self.StunThread)
				self.OpenAnimManip:SetRate(1)
				WaitFor(self.OpenAnimManip)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				WaitSeconds(20)
				KillThread(self.RegenThreadHandle)
				KillThread(self.StunThreadHandle)
				self.Effect1:Destroy()
				self.Effect2:Destroy()
				self.OpenAnimManip:SetRate(-1)
				WaitFor(self.OpenAnimManip)
				self:AddToggleCap('RULEUTC_SpecialToggle')
				end)
			end
			if self.number == 4 then
				ForkThread( function()
				self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'nanites_01_emit.bp'):ScaleEmitter(5.0):SetEmitterParam('LIFETIME', -1)
				self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'nanites_03_emit.bp'):ScaleEmitter(5.0):SetEmitterParam('LIFETIME', -1)
				self.RegenThreadHandle = self:ForkThread(self.RegenBuffThread)
				self.StunThreadHandle = self:ForkThread(self.StunThread)
				self.OpenAnimManip:SetRate(1)
				WaitFor(self.OpenAnimManip)
				self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				WaitSeconds(20)
				KillThread(self.RegenThreadHandle)
				KillThread(self.StunThreadHandle)
				self.Effect1:Destroy()
				self.Effect2:Destroy()
				self.OpenAnimManip:SetRate(-1)
				WaitFor(self.OpenAnimManip)
				self:RemoveToggleCap('RULEUTC_SpecialToggle')
				FloatingEntityText(id, 'Warning no more Nanites available')
				self:AddToggleCap('RULEUTC_WeaponToggle')
				end)
			end
        end
    end,

    OnScriptBitClear = function(self, bit)
        CLandUnit.OnScriptBitClear(self, bit)
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
	

	
	
	CreateEnhancement = function(self, enh)
        CLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		if enh =='CloakGen' then
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		self:AddToggleCap('RULEUTC_CloakToggle')
		self:SetEnergyMaintenanceConsumptionOverride(300)
        self:SetMaintenanceConsumptionActive()
		self:EnableUnitIntel('Cloak')
        elseif enh == 'CloakGenRemove' then
		self:RemoveToggleCap('RULEUTC_CloakToggle')
		self:SetMaintenanceConsumptionInactive()
        self:DisableUnitIntel('Cloak')
		elseif enh =='CloakGenArmor' then
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
        elseif enh == 'CloakGenArmorRemove' then
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		self:RemoveToggleCap('RULEUTC_CloakToggle')
		self:SetMaintenanceConsumptionInactive()
        self:DisableUnitIntel('CloakField')
		elseif enh =='NanitesLevel2' then
		self.NaniteRegen = 10
		self.NaniteDamage = 20
        elseif enh == 'NanitesLevel2Remove' then
		self.NaniteRegen = 5
		self.NaniteDamage = 10
		elseif enh =='NanitesLevel3' then
		self.NaniteRegen = 15
		self.NaniteDamage = 30
        elseif enh == 'NanitesLevel3Remove' then
		self.NaniteRegen = 5
		self.NaniteDamage = 10
		elseif enh =='NanitesLevel4' then
		self.NaniteRegen = 20
		self.NaniteDamage = 40
        elseif enh == 'NanitesLevel4Remove' then
		self.NaniteRegen = 5
		self.NaniteDamage = 10
		elseif enh =='NanitesLevel5' then
		self.NaniteRegen = 25
		self.NaniteDamage = 50
        elseif enh == 'NanitesLevel5Remove' then
		self.NaniteRegen = 5
		self.NaniteDamage = 10
		elseif enh =='NaniteCapsule' then
		self:AddCommandCap('RULEUCC_Tactical')
        self:AddCommandCap('RULEUCC_SiloBuildTactical')
		self:SetWeaponEnabledByLabel('NaniteCapsuleMissile', true)
        elseif enh == 'NaniteCapsuleRemove' then
		self:SetWeaponEnabledByLabel('NaniteCapsuleMissile', false)
		self:RemoveCommandCap('RULEUCC_Tactical')
        self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
        end
    end,

}

TypeClass = URB8802