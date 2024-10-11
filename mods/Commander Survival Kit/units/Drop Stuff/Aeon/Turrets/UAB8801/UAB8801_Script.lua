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
local ALandUnit = import('/lua/defaultunits.lua').MobileUnit
local ADFPhasonLaser = import('/mods/Commander Survival Kit/lua/FireSupportBarrages.lua').ADFMiniPhasonLaser
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'
local Buff = import('/lua/sim/Buff.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')

UAB8801 = Class(ALandUnit) {

    Weapons = {
		EyeWeapon = Class(ADFPhasonLaser) {
		
		        PlayFxWeaponUnpackSequence = function(self)
					if self.unit.Stargate == true then
					self.unit:ShowBone('Muzzle', false)
				
					else
					
                    if self.unit.Spinner1 then 
					self.unit.Spinner1:Destroy()
                    end
					if self.unit.Spinner2 then 
					self.unit.Spinner2:Destroy()
                    end
					if self.unit.Spinner3 then 
					self.unit.Spinner3:Destroy()
                    end
					
					end
                    ADFPhasonLaser.PlayFxWeaponUnpackSequence(self)
                end,

                PlayFxWeaponPackSequence = function(self)
					
					if self.unit.Stargate == true then
					ForkThread( function()
					WaitSeconds(1)
					self.unit:HideBone('Muzzle', false)
					end
					)
					else
					
					self.unit.Spinner1 = CreateRotator(self.unit, 'Ring_B01', 'y', nil, 0, 60, 360):SetTargetSpeed(90)
					self.unit.Spinner2 = CreateRotator(self.unit, 'Ring_B02', 'y', nil, 0, 60, -360):SetTargetSpeed(-90)
					self.unit.Spinner3 = CreateRotator(self.unit, 'Ring_B03', 'x', nil, 0, 60, 360):SetTargetSpeed(90)
					
					end
                    ADFPhasonLaser.PlayFxWeaponPackSequence(self)
                end,
		
		},
	},

    OnCreate = function(self)
        ALandUnit.OnCreate(self)
		------------------- 
		-- The Turret is an Mobile Unit = Movable Turret durning attack? -- No, so lets deactivate that
		-- Deactivates Move and Turn Speed.
		-- Effects: Keep the Turret to be angled on the Terrian and not movable during attacks

		self:SetSpeedMult(0)
		self:SetTurnMult(0)
		
		-----------------
		
		self.Stargate = false
		self:ShowBone('Muzzle', false)
		self:SetUnSelectable(true)
		self:HideBone( 'Turret', true )
		self:HideBone('Armor', false)
		local wep = self:GetWeaponByLabel('EyeWeapon')
        wep:SetEnabled(false)
		ForkThread( function()
						WaitSeconds(1)
						CreateLightParticle( self, 'Muzzle', self:GetArmy(), 3, 7, 'glow_03', 'ramp_white_01' ) 
						self.Effect1 = CreateAttachedEmitter(self,'Muzzle',self:GetArmy(), ModeffectPath .. 'aeon_teleport_01_emit.bp'):ScaleEmitter(0.85)
						self.Trash:Add(self.Effect1)
						self.Effect2 = CreateAttachedEmitter(self,'Muzzle',self:GetArmy(), ModeffectPath .. 'aeon_teleport_02_emit.bp'):ScaleEmitter(0.85)
						self.Trash:Add(self.Effect2)
						self.Effect3 = CreateAttachedEmitter(self,'Muzzle',self:GetArmy(), ModeffectPath .. 'aeon_teleport_03_emit.bp'):ScaleEmitter(0.75)
						self.Trash:Add(self.Effect3)

						WaitSeconds(10)
                        CreateLightParticle( self, 'Muzzle', self:GetArmy(), 3, 10, 'glow_03', 'ramp_white_01' ) 
						CreateLightParticle( self, 'Turret', self:GetArmy(), 3, 10, 'glow_03', 'ramp_white_01' ) 
						self.Effect4 = CreateAttachedEmitter(self,'Muzzle',self:GetArmy(), ModeffectPath .. 'aeon_TeleportRing_01_emit.bp'):ScaleEmitter(0.85)
						self.Trash:Add(self.Effect4)
						self.Effect5 = CreateAttachedEmitter(self,'Muzzle',self:GetArmy(), ModeffectPath .. 'aeon_teleport_03_emit.bp'):ScaleEmitter(0.75)
						self.Trash:Add(self.Effect5)
						self.Effect6 = CreateAttachedEmitter(self,'Muzzle',self:GetArmy(), ModeffectPath .. 'aeon_teleport_04_emit.bp'):ScaleEmitter(0.85)
						self.Trash:Add(self.Effect6)
						CreateLightParticle( self, 'Muzzle', self:GetArmy(), 3, 10, 'glow_03', 'ramp_white_01' ) 
						CreateLightParticle( self, 'Turret', self:GetArmy(), 3, 10, 'glow_03', 'ramp_white_01' ) 
						self:ShowBone( 'Turret', true )
						self:HideBone('L_Ammo', false)
						self:HideBone('R_Ammo', false)
						self:HideBone('L_Sensor', false)
						self:HideBone('R_Sensor', false)
						self.Effect1:Destroy()
						self.Effect2:Destroy()
						self.Effect3:Destroy()
						self.Effect4:Destroy()
						self.Effect5:Destroy()
						self.Effect6:Destroy()
						self:SetUnSelectable(false)
						self.Spinner1 = CreateRotator(self, 'Ring_B01', 'y', nil, 0, 60, 360):SetTargetSpeed(90)
						self.Spinner2 = CreateRotator(self, 'Ring_B02', 'y', nil, 0, 60, -360):SetTargetSpeed(-90)
						self.Spinner3 = CreateRotator(self, 'Ring_B03', 'x', nil, 0, 60, 360):SetTargetSpeed(90)
						self.Spinner4 = CreateRotator(self, 'Ring_B04', 'z', nil, 0, 60, 360):SetTargetSpeed(90)
						local wep = self:GetWeaponByLabel('EyeWeapon')
						wep:SetEnabled(true)
            end
        )
    end,
	
	RegenBuffThread = function(self)
        while not self:IsDead() do
            #Get friendly units in the area (including self)
            local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			20
			
			)
            local buff
            local type
			buff = 'MoralRegen1'
			if not Buffs[buff] then
                local buff_bp = {
                    Name = buff,
                    DisplayName = buff,
                    BuffType = 'VETERANCYREGEN',
                    Stacks = 'REPLACE',
                    Duration = 1,
                    Affects = {
                        Regen = {
                            Add = 5,
                            Mult = 1,
                        },
                    },
                }
                BuffBlueprint(buff_bp)
            end
            for _,unit in units do
                Buff.ApplyBuff(unit, 'MoralRegen1')
            end
            
            WaitSeconds(1)
        end
    end,
	
	CreateEnhancement = function(self, enh)
        ALandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		if enh =='StargateBeam' then
		self.Stargate = true
		ForkThread( function()
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		self:HideBone('Ring_B01', false)
		self:HideBone('Ring_B02', false)
		self:HideBone('Ring_B03', false)
		self:HideBone('Muzzle', false)
		self.Spinner4:SetTargetSpeed(0)
		WaitFor(self.Spinner4)
		self.Spinner4:SetTargetSpeed(30)
		WaitFor(self.Spinner4)
		self.Spinner4:SetTargetSpeed(-60)
		WaitFor(self.Spinner4)
		self.Spinner4:SetTargetSpeed(70)
		WaitFor(self.Spinner4)
		self.Spinner4:SetTargetSpeed(-40)
		WaitFor(self.Spinner4)
		self.Spinner4:SetTargetSpeed(0)
		WaitFor(self.Spinner4)
		WaitSeconds(1)
		self.Effect1 = CreateAttachedEmitter(self,'Ring_Effect1',self:GetArmy(), ModeffectPath .. 'aeon_stargate_splash_01_emit.bp'):ScaleEmitter(0.45)
		self.GateEffectEntity = import('/lua/sim/Entity.lua').Entity()
		self.GateEffectEntity:AttachBoneTo(-1, self,'Muzzle')
		self.GateEffectEntity:SetMesh('/mods/Commander Survival Kit/units/Drop Stuff/Aeon/Turrets/UAB8801/Effect/Effect_Mesh')
		self.GateEffectEntity:SetDrawScale(0.4)
		self.GateEffectEntity:SetVizToAllies('Intel')
		self.GateEffectEntity:SetVizToNeutrals('Intel')
		self.GateEffectEntity:SetVizToEnemies('Intel') 
		local wep = self:GetWeaponByLabel('EyeWeapon')
        wep:SetEnabled(true)
		end
		)
        elseif enh =='StargateBeamRemove' then
		if self.GateEffectEntity then
		self.GateEffectEntity:Destroy()
		end
		self.Stargate = false
		elseif enh =='MoralImprover' then
		ForkThread( function()
		if self.GateEffectEntity then
		self.GateEffectEntity:Destroy()
		end
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		self.Spinner4:SetTargetSpeed(90)
		local wep = self:GetWeaponByLabel('EyeWeapon')
        wep:SetEnabled(false)
		self:HideBone('Muzzle', false)
		self:HideBone('Ring_B01', false)
		self:HideBone('Ring_B02', false)
		self:HideBone('Ring_B03', false)
		self.OpenAnimManip = CreateAnimator(self)
        self.Trash:Add(self.OpenAnimManip)
        self.OpenAnimManip:PlayAnim('/mods/Commander Survival Kit/units/Drop Stuff/Aeon/Turrets/UAB8801/UAB8801_aactivate2.sca', false):SetRate(1)
		WaitFor(self.OpenAnimManip)
		self.Effect1 = CreateAttachedEmitter(self,'Ring_Effect1',self:GetArmy(), ModeffectPath .. 'aeon_Ring_01_emit.bp'):ScaleEmitter(0.55)
		self.Effect2 = CreateAttachedEmitter(self,'Ring_Effect1',self:GetArmy(), ModeffectPath .. 'aeon_Ring_02_emit.bp'):ScaleEmitter(0.55)
		self.Effect3 = CreateAttachedEmitter(self,'Ring_Effect1',self:GetArmy(), '/effects/emitters/aeon_t1power_ambient_02_emit.bp'):ScaleEmitter(0.55)
		self.Effect4 = CreateAttachedEmitter(self,'Ring_Effect1',self:GetArmy(), ModeffectPath .. 'aeon_teleport_01_emit.bp'):ScaleEmitter(0.55)
		self.Effect5 = CreateAttachedEmitter(self,'Ring_Effect1',self:GetArmy(), ModeffectPath .. 'aeon_teleport_03_emit.bp'):ScaleEmitter(0.55)
		self.RegenThreadHandle = self:ForkThread(self.RegenBuffThread)
		end
		)
        elseif enh =='MoralImproverRemove' then
		ForkThread( function()
		self.OpenAnimManip:SetRate(-1)
		WaitFor(self.OpenAnimManip)
		self.OpenAnimManip:Destroy()
		self.Effect1:Destroy()
		self.Effect2:Destroy()
		self.Effect3:Destroy()
		self.Effect4:Destroy()
		self.Effect5:Destroy()
		if self.RegenThreadHandle then
            KillThread(self.RegenThreadHandle)
            self.RegenThreadHandle = nil
        end
		end
		)
		elseif enh =='LaserBeamProjector' then
		if self.GateEffectEntity then
		self.GateEffectEntity:Destroy()
		end
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		self.Spinner4:SetTargetSpeed(90)
		self.Stargate = false
		local wep = self:GetWeaponByLabel('EyeWeapon')
        wep:SetEnabled(true)
		self:ShowBone('Muzzle', false)
		self:ShowBone('Ring_B01', false)
		self:ShowBone('Ring_B02', false)
		self:ShowBone('Ring_B03', false)
		elseif enh =='LaserBeamProjectorRemove' then
		self.Spinner4:Destroy()
		self.Stargate = true
		local wep = self:GetWeaponByLabel('EyeWeapon')
        wep:SetEnabled(false)
		self:HideBone('Muzzle', false)
		self:HideBone('Ring_B01', false)
		self:HideBone('Ring_B02', false)
		self:HideBone('Ring_B03', false)
		elseif enh =='LaserBeamProjectorArmor' then
		self:ShowBone('Armor', false)
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
        elseif enh =='LaserBeamProjectorArmorRemove' then
		self:HideBone('Armor', false)
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		elseif enh =='StargateBeamArmor' then
		self:ShowBone('Armor', false)
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
        elseif enh =='StargateBeamArmorRemove' then
		if self.GateEffectEntity then
		self.GateEffectEntity:Destroy()
		end
		self:HideBone('Armor', false)
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		elseif enh =='MoralImproverArmor' then
		self:ShowBone('Armor', false)
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
        elseif enh =='MoralImproverArmorRemove' then
		ForkThread( function()
		self.OpenAnimManip:SetRate(-1)
		WaitFor(self.OpenAnimManip)
		self.OpenAnimManip:Destroy()
		self.Effect1:Destroy()
		self.Effect2:Destroy()
		self.Effect3:Destroy()
		self.Effect4:Destroy()
		self.Effect5:Destroy()
		if self.RegenThreadHandle then
            KillThread(self.RegenThreadHandle)
            self.RegenThreadHandle = nil
        end
		end
		)
		self:HideBone('Armor', false)
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		elseif enh =='LSensor' then
		self:ShowBone('L_Sensor', false)
		local wep = self:GetWeaponByLabel('EyeWeapon')
		wep:ChangeMaxRadius(50)
		self:SetIntelRadius('Vision', 50)
        elseif enh =='LSensorRemove' then
		self:HideBone('L_Sensor', false)
		local wep = self:GetWeaponByLabel('EyeWeapon')
		wep:ChangeMaxRadius(40)
		self:SetIntelRadius('Vision', 40)
		elseif enh =='RSensor' then
		self:ShowBone('R_Sensor', false)
		local wep = self:GetWeaponByLabel('EyeWeapon')
		wep:ChangeMaxRadius(50)
		self:SetIntelRadius('Vision', 50)
        elseif enh =='RSensorRemove' then
		self:HideBone('R_Sensor', false)
		local wep = self:GetWeaponByLabel('EyeWeapon')
		wep:ChangeMaxRadius(40)
		self:SetIntelRadius('Vision', 40)
		elseif enh =='LAmmo' then
		local wep = self:GetWeaponByLabel('EyeWeapon')
		wep:ChangeDamage(200)
		self:ShowBone('L_Ammo', false)
        elseif enh =='LAmmoRemove' then
		self:HideBone('L_Ammo', false)
		local wep = self:GetWeaponByLabel('EyeWeapon')
		wep:ChangeDamage(100)
		elseif enh =='RAmmo' then
		local wep = self:GetWeaponByLabel('EyeWeapon')
		wep:ChangeDamage(200)
		self:ShowBone('R_Ammo', false)
        elseif enh =='RAmmoRemove' then
		local wep = self:GetWeaponByLabel('EyeWeapon')
		wep:ChangeDamage(100)
		self:HideBone('R_Ammo', false)
		end
    end,
	OnKilled = function(self, instigator, type, overkillRatio)
		self:HideBone('Muzzle', false)
		if self.GateEffectEntity then
		self.GateEffectEntity:Destroy()
		end
		if self.Effect1 then
		self.Effect1:Destroy()
		end
		if self.Effect2 then
		self.Effect2:Destroy()
		end
		if self.Effect3 then
		self.Effect3:Destroy()
		end
		if self.Effect4 then
		self.Effect4:Destroy()
		end
		if self.Effect5 then
		self.Effect5:Destroy()
		end
		if self.RegenThreadHandle then
            KillThread(self.RegenThreadHandle)
            self.RegenThreadHandle = nil
        end
		self:ForkThread(self.DeathThread, overkillRatio , instigator)
    end,

}

TypeClass = UAB8801