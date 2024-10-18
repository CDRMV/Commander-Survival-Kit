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
local CIFGrenadeWeapon = import('/lua/cybranweapons.lua').CIFGrenadeWeapon
local CIFArtilleryWeapon = import('/lua/cybranweapons.lua').CIFArtilleryWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'

URB8800 = Class(CLandUnit) {

    Weapons = {
	    Dummy = Class(CDFHeavyDisintegratorWeapon) {},
		MainGun = Class(CDFHeavyDisintegratorWeapon) {},
		MainGun2 = Class(CDFHeavyDisintegratorWeapon) {},
		MissileRack = Class(CIFGrenadeWeapon) {},
		ArtGun = Class(CIFArtilleryWeapon) {
            FxMuzzleFlash = {
                '/effects/emitters/cybran_artillery_muzzle_flash_01_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_flash_02_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_smoke_01_emit.bp',
            },
        }
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
		self:HideBone( 'Turret_Barrel_B04', true )
		self:HideBone( 'Turret_Barrel_B03', true )
		self:HideBone( 'Turret_Barrel_B02', true )
		self:HideBone( 'Sensors01', false )
		self:HideBone( 'Heatsinks', false )
		self:HideBone('Armor', false)
		self:ShowBone( 'Turret_Barrel_B01', false )
		local wep = self:GetWeaponByLabel('Dummy')
        wep:SetEnabled(false)
		local wep1 = self:GetWeaponByLabel('MainGun')
        wep1:SetEnabled(false)
		local wep2 = self:GetWeaponByLabel('MainGun2')
        wep2:SetEnabled(false)
		local wep3 = self:GetWeaponByLabel('MissileRack')
        wep3:SetEnabled(false)
		local wep4 = self:GetWeaponByLabel('ArtGun')
        wep4:SetEnabled(false)
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
		elseif enh =='HeatSink' then
		self:ShowBone('Heatsinks', false)
		
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:ChangeDamage(100)
		wep1:ChangeRateOfFire(2.0)
		local wep2 = self:GetWeaponByLabel('MainGun2')
        wep2:ChangeDamage(100)
		wep2:ChangeRateOfFire(2.0)
		local wep3 = self:GetWeaponByLabel('MissileRack')
		wep3:ChangeDamage(450)
		wep3:ChangeRateOfFire(0.2)
		local wep4 = self:GetWeaponByLabel('ArtGun')
		wep4:ChangeDamage(1850)
		wep4:ChangeRateOfFire(0.1)
        elseif enh =='HeatSinkRemove' then
		self:HideBone('Heatsinks', false)
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:ChangeDamage(50)
		wep1:ChangeRateOfFire(1.5)
		local wep2 = self:GetWeaponByLabel('MainGun2')
        wep2:ChangeDamage(50)
		wep2:ChangeRateOfFire(1.5)
		local wep3 = self:GetWeaponByLabel('MissileRack')
		wep3:ChangeDamage(450)
		wep3:ChangeRateOfFire(0.1)
		local wep4 = self:GetWeaponByLabel('ArtGun')
		wep4:ChangeDamage(1850)
		wep4:ChangeRateOfFire(0.05)
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		self:HideBone('Armor', false)
		elseif enh =='Sensors' then
		self:ShowBone('Sensors01', false)
		self:SetIntelRadius('Vision', 60)
		ForkThread( function()
		while true do
		if self.MissileLauncherUpgrade == true then
		local wep = self:GetWeaponByLabel('Dummy')
		wep:ChangeMaxRadius(125)
		wep:ChangeMinRadius(5)
		local wep3 = self:GetWeaponByLabel('MissileRack')
		wep3:ChangeMaxRadius(125)
		wep3:ChangeMinRadius(5)
		else
		self:SetIntelRadius('Vision', 60)
		local wep = self:GetWeaponByLabel('Dummy')
		wep:ChangeMaxRadius(60)
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:ChangeMaxRadius(60)
		local wep2 = self:GetWeaponByLabel('MainGun2')
        wep2:ChangeMaxRadius(60)
		end
		if self.ArtilleryUpgrade == true then
		local wep = self:GetWeaponByLabel('Dummy')
		wep:ChangeMaxRadius(135)
		wep:ChangeMinRadius(5)
		local wep4 = self:GetWeaponByLabel('ArtGun')
		wep4:ChangeMaxRadius(135)
		wep4:ChangeMinRadius(5)
		else
		local wep = self:GetWeaponByLabel('Dummy')
		wep:ChangeMaxRadius(60)
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:ChangeMaxRadius(60)
		local wep2 = self:GetWeaponByLabel('MainGun2')
        wep2:ChangeMaxRadius(60)
		end
		WaitSeconds(1)
		end
		end
		)
        elseif enh =='SensorsRemove' then
		self:SetIntelRadius('Vision', 40)
		local wep = self:GetWeaponByLabel('Dummy')
		wep:ChangeMaxRadius(40)
		wep:ChangeMinRadius(0)
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:ChangeMaxRadius(40)
		local wep2 = self:GetWeaponByLabel('MainGun2')
        wep2:ChangeMaxRadius(40)
		local wep3 = self:GetWeaponByLabel('MissileRack')
		wep3:ChangeMaxRadius(120)
		wep4:ChangeMinRadius(5)
		local wep4 = self:GetWeaponByLabel('ArtGun')
		wep4:ChangeMaxRadius(128)
		wep4:ChangeMinRadius(5)
        self:HideBone('Sensors01', false)
		self:HideBone('Heatsinks', false)
		self:SetMaxHealth(5000)
		self:SetHealth(self, 5000)
		self:HideBone('Armor', false)
		elseif enh =='Laser' then
		local wep = self:GetWeaponByLabel('Dummy')
		wep:ChangeMaxRadius(40)
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:SetEnabled(false)
		local wep2 = self:GetWeaponByLabel('MainGun2')
        wep2:SetEnabled(true)
		local wep3 = self:GetWeaponByLabel('MissileRack')
        wep3:SetEnabled(false)
		local wep4 = self:GetWeaponByLabel('ArtGun')
        wep4:SetEnabled(false)
		self:HideBone( 'Turret_Barrel_B01', false )
		self:ShowBone('Turret_Barrel_B02', true)
        elseif enh =='LaserRemove' then
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:SetEnabled(true)
		local wep2 = self:GetWeaponByLabel('MainGun2')
        wep2:SetEnabled(false)
		local wep3 = self:GetWeaponByLabel('MissileRack')
        wep3:SetEnabled(false)
		local wep4 = self:GetWeaponByLabel('ArtGun')
        wep4:SetEnabled(false)
		self:HideBone('Turret_Barrel_B02', true)
		self:ShowBone( 'Turret_Barrel_B01', false )
		self:ShowBone( 'Turret_Barrel', false )
		self:ShowBone( 'Turret_Muzzle01', false )
		self:ShowBone( 'Turret_Muzzle02', false )
		elseif enh =='Artillery' then
		self.ArtilleryUpgrade = true
		local wep = self:GetWeaponByLabel('Dummy')
		wep:ChangeMaxRadius(128)
		wep:ChangeMinRadius(5)
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:SetEnabled(false)
		local wep2 = self:GetWeaponByLabel('MainGun2')
        wep2:SetEnabled(false)
		local wep3 = self:GetWeaponByLabel('MissileRack')
        wep3:SetEnabled(false)
		local wep4 = self:GetWeaponByLabel('ArtGun')
        wep4:SetEnabled(true)
		self:HideBone( 'Turret_Barrel', true )
		self:ShowBone('Turret_Barrel_B04', true)
        elseif enh =='ArtilleryRemove' then
		local wep = self:GetWeaponByLabel('Dummy')
		wep:ChangeMaxRadius(40)
		wep:ChangeMinRadius(0)
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:SetEnabled(true)
		local wep2 = self:GetWeaponByLabel('MainGun2')
        wep2:SetEnabled(false)
		local wep3 = self:GetWeaponByLabel('MissileRack')
        wep3:SetEnabled(false)
		local wep4 = self:GetWeaponByLabel('ArtGun')
        wep4:SetEnabled(false)
		self:HideBone('Turret_Barrel_B04', true)
		self:ShowBone( 'Turret_Barrel_B01', false )
		self:ShowBone( 'Turret_Barrel', false )
		self:ShowBone( 'Turret_Muzzle01', false )
		self:ShowBone( 'Turret_Muzzle02', false )
		elseif enh =='MissileLauncher' then
		self.MissileLauncherUpgrade = true
		local wep = self:GetWeaponByLabel('Dummy')
		wep:ChangeMaxRadius(120)
		wep:ChangeMinRadius(5)
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:SetEnabled(false)
		local wep2 = self:GetWeaponByLabel('MainGun2')
        wep2:SetEnabled(false)
		local wep3 = self:GetWeaponByLabel('MissileRack')
        wep3:SetEnabled(true)
		local wep4 = self:GetWeaponByLabel('ArtGun')
        wep4:SetEnabled(false)
		self:HideBone( 'Turret_Barrel', true )
		self:ShowBone('Turret_Barrel_B03', true)
        elseif enh =='MissileLauncherRemove' then
		self.MissileLauncherUpgrade = false
		local wep = self:GetWeaponByLabel('Dummy')
		wep:ChangeMaxRadius(40)
		wep:ChangeMinRadius(0)
		local wep1 = self:GetWeaponByLabel('MainGun')
		wep1:SetEnabled(true)
		local wep2 = self:GetWeaponByLabel('MainGun2')
        wep2:SetEnabled(false)
		local wep3 = self:GetWeaponByLabel('MissileRack')
        wep3:SetEnabled(false)
		local wep4 = self:GetWeaponByLabel('ArtGun')
        wep4:SetEnabled(false)
		self:HideBone('Turret_Barrel_B03', true)
		self:ShowBone( 'Turret_Barrel_B01', false )
		self:ShowBone( 'Turret_Barrel', false )
		self:ShowBone( 'Turret_Muzzle01', false )
		self:ShowBone( 'Turret_Muzzle02', false )
		end
    end,

}

TypeClass = URB8800