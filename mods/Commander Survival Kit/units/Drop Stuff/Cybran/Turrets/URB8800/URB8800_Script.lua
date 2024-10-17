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
local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local CDFHeavyDisintegratorWeapon = import('/lua/cybranweapons.lua').CDFHeavyDisintegratorWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'

URB8800 = Class(CLandUnit) {

    Weapons = {
	    Dummy = Class(CDFHeavyDisintegratorWeapon) {},
		MainGun = Class(CDFHeavyDisintegratorWeapon) {},
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
		ForkThread( function()
		--local wep = self:GetWeaponByLabel('Two_MachineGuns')
        --wep:SetEnabled(false)
		self:SetUnSelectable(true)
		self:HideBone( 'Turret_Barrel_B03', true )
		self:HideBone( 'Turret_Barrel_B02', true )
		self:HideBone( 'Sensors02', false )
		self:HideBone( 'Sensors01', false )
		self:HideBone( 'Heatsinks', false )
		self:HideBone('Armor', false)
		self:ShowBone( 'Turret_Barrel_B01', false )
		local wep = self:GetWeaponByLabel('Dummy')
        wep:SetEnabled(false)
		local wep1 = self:GetWeaponByLabel('MainGun')
        wep1:SetEnabled(false)
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim('/mods/Commander Survival Kit/units/Drop Stuff/Cybran/Turrets/URB8800/URB8800_aactivate.sca', false):SetRate(0)
						WaitSeconds(5)
						self.OpenAnimManip:SetRate(1)
						WaitFor(self.OpenAnimManip)
						self:SetUnSelectable(false)
						local wep = self:GetWeaponByLabel('Dummy')
						wep:SetEnabled(true)
						local wep1 = self:GetWeaponByLabel('MainGun')
						wep1:SetEnabled(true)
            end
        )
    end,
	
	CreateEnhancement = function(self, enh)
        CLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		if enh =='Armor' then
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
		self:ShowBone('Armor', false)
        elseif enh =='ArmorRemove' then
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		self:HideBone('Armor', false)
		end
    end,

}

TypeClass = URB8800