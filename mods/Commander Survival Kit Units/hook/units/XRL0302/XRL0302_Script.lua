#****************************************************************************
#**
#**  File     :  /data/units/XRL0302/XRL0302_script.lua
#**  Author(s):  Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Cybran Mobile Bomb Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon


XRL0302 = Class(CWalkingLandUnit) {
    Weapons = {
        
        Suicide = Class(CMobileKamikazeBombWeapon) {        
			OnFire = function(self)			
				#disable death weapon
				self.unit:SetDeathWeaponEnabled(false)
				CMobileKamikazeBombWeapon.OnFire(self)
			end,
        },
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		self:SetScriptBit('RULEUTC_SpecialToggle', true)
        self:RequestRefreshUI()
    end,
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
		if bit == 7 then 
			self.AutomaticDetonationThreadHandle = self:ForkThread(self.AutomaticDetonationThread)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
		if bit == 7 then 
			KillThread(self.AutomaticDetonationThreadHandle)
        end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  

        self:DestroyAllDamageEffects()
		

		self:GetWeaponByLabel'Suicide':FireWeapon()

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
	
	
	AutomaticDetonationThread = function(self)
		while not self:IsDead() do
			local unitPos = self:GetPosition()
            #Get Enemy units in the area
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 3, 'Enemy')
            for _,unit in units do
                self:GetWeaponByLabel'Suicide':FireWeapon()
            end
            
            #Wait 2 seconds
            WaitSeconds(2)
		end	
    end,
}
TypeClass = XRL0302