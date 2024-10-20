#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0202/UEL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Tank Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local EffectTemplate = import('/lua/EffectTemplates.lua')
local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local CDFHeavyMicrowaveLaserGeneratorCom = import('/lua/cybranweapons.lua').CDFHeavyMicrowaveLaserGeneratorCom
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'

URB8801 = Class(CLandUnit) {

    Weapons = {
        MLG = Class(CDFHeavyMicrowaveLaserGeneratorCom) {
            DisabledFiringBones = {'Muzzle'},
            
            SetOnTransport = function(self, transportstate)
                CDFHeavyMicrowaveLaserGeneratorCom.SetOnTransport(self, transportstate)
                self:ForkThread(self.OnTransportWatch)
            end,
            
            OnTransportWatch = function(self)
                while self:GetOnTransport() do
                    self:PlayFxBeamEnd()
                    self:SetWeaponEnabled(false)
                    WaitSeconds(0.3)
                end
            end,          
        },
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
		
		self.MissileLauncherUpgrade = false
		self.ArtilleryUpgrade = false
		ForkThread( function()
		--local wep = self:GetWeaponByLabel('Two_MachineGuns')
        --wep:SetEnabled(false)
		self:SetUnSelectable(true)
		self:HideBone( 'Sensors', false )
		self:HideBone( 'Spikes1', false )
		self:HideBone( 'Spikes2', false )
		self:HideBone( 'Spikes3', false )
		self:HideBone( 'Spikes4', false )
		self:HideBone('Armor', false)
		--local wep = self:GetWeaponByLabel('Dummy')
        --wep:SetEnabled(false)
						WaitSeconds(5)
						self:SetUnSelectable(false)
						--local wep = self:GetWeaponByLabel('Dummy')
						--wep:SetEnabled(true)
            end
        )
    end,
	
	CreateEnhancement = function(self, enh)
        CLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		if enh =='Armor' then
		local wep = self:GetWeaponByLabel('MLG')
		wep:ChangeDamage(200)
		wep:ChangeMaxRadius(20)
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
		self:ShowBone('Armor', false)
		self:HideBone('Grid', false)
        elseif enh =='ArmorRemove' then
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		self:HideBone('Armor', false)
		self:ShowBone('Grid', false)
		elseif enh =='Sensors' then
		self:SetIntelRadius('Vision', 40)
		local wep = self:GetWeaponByLabel('MLG')
		wep:ChangeDamage(200)
		wep:ChangeMaxRadius(40)
		self:ShowBone('Sensors', false)
        elseif enh =='SensorsRemove' then
		self:SetIntelRadius('Vision', 20)
		local wep = self:GetWeaponByLabel('MLG')
		wep:ChangeDamage(200)
		wep:ChangeMaxRadius(20)
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		self:HideBone('Sensors', false)
		self:HideBone('Armor', false)
		self:ShowBone('Grid', false)
		elseif enh =='Laser1' then
		local wep = self:GetWeaponByLabel('MLG')
		wep:ChangeDamage(350)
		self:ShowBone('Spikes1', false)
        elseif enh =='Laser1Remove' then
		self:SetIntelRadius('Vision', 20)
		local wep = self:GetWeaponByLabel('MLG')
		wep:ChangeDamage(200)
		wep:ChangeMaxRadius(20)
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		self:HideBone('Sensors', false)
		self:HideBone('Armor', false)
		self:ShowBone('Grid', false)
		self:HideBone('Spikes1', false)
		elseif enh =='Laser2' then
		local wep = self:GetWeaponByLabel('MLG')
		wep:ChangeDamage(500)
		self:ShowBone('Spikes2', false)
        elseif enh =='Laser2Remove' then
		self:SetIntelRadius('Vision', 20)
		local wep = self:GetWeaponByLabel('MLG')
		wep:ChangeDamage(350)
		wep:ChangeMaxRadius(20)
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		self:HideBone('Sensors', false)
		self:HideBone('Armor', false)
		self:ShowBone('Grid', false)
		self:HideBone('Spikes1', false)
		self:HideBone('Spikes2', false)
		elseif enh =='Laser3' then
		local wep = self:GetWeaponByLabel('MLG')
		wep:ChangeDamage(650)
		self:ShowBone('Spikes3', false)
        elseif enh =='Laser3Remove' then
		self:SetIntelRadius('Vision', 20)
		local wep = self:GetWeaponByLabel('MLG')
		wep:ChangeDamage(500)
		wep:ChangeMaxRadius(20)
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		self:HideBone('Sensors', false)
		self:HideBone('Armor', false)
		self:ShowBone('Grid', false)
		self:HideBone('Spikes1', false)
		self:HideBone('Spikes2', false)
		self:HideBone('Spikes3', false)
		elseif enh =='Laser4' then
		local wep = self:GetWeaponByLabel('MLG')
		wep:ChangeDamage(800)
		self:ShowBone('Spikes4', false)
        elseif enh =='Laser4Remove' then
		self:SetIntelRadius('Vision', 20)
		local wep = self:GetWeaponByLabel('MLG')
		wep:ChangeDamage(650)
		wep:ChangeMaxRadius(20)
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		self:HideBone('Sensors', false)
		self:HideBone('Armor', false)
		self:ShowBone('Grid', false)
		self:HideBone('Spikes1', false)
		self:HideBone('Spikes2', false)
		self:HideBone('Spikes3', false)
		self:HideBone('Spikes4', false)
		end
    end,

}

TypeClass = URB8801