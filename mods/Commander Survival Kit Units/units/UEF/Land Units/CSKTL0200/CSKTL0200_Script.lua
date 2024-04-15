#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0304/UEL0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Heavy Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local Modpath = '/mods/Commander Survival Kit Units/effects/emitters/'
local AIUtils = import('/lua/ai/aiutilities.lua')
CSKTL0200 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
        },
    },
	
	OnLayerChange = function(self, new, old)
        TLandUnit.OnLayerChange(self, new, old)
        if self:GetBlueprint().Display.AnimationWater then
            if self.TerrainLayerTransitionThread then
                self.TerrainLayerTransitionThread:Destroy()
                self.TerrainLayerTransitionThread = nil
            end
            if (new == 'Land') and (old != 'None') then
                self.TerrainLayerTransitionThread = self:ForkThread(self.TransformThread, false)
            elseif (new == 'Water') then
                self.TerrainLayerTransitionThread = self:ForkThread(self.TransformThread, true)
            end
        end
    end,

    TransformThread = function(self, water)
        
        if not self.TransformManipulator then
            self.TransformManipulator = CreateAnimator(self)
            self.Trash:Add( self.TransformManipulator )
        end

        if water then
            self.TransformManipulator:PlayAnim(self:GetBlueprint().Display.AnimationWater)
            self.TransformManipulator:SetRate(1)
            self.TransformManipulator:SetPrecedence(0)
        else
            self.TransformManipulator:SetRate(-1)
            self.TransformManipulator:SetPrecedence(0)
            WaitFor(self.TransformManipulator)
            self.TransformManipulator:Destroy()
            self.TransformManipulator = nil
        end
    end,
	
	OnTransportOrdered = function(self)
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0200/CSKTL0200_DoorOpen.sca'):SetRate(1)
    end,
	
	OnTransportAttach = function(self, attachBone, unit)
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0200/CSKTL0200_DoorOpen.sca')
		TLandUnit.OnTransportAttach(self, attachBone, unit)
		self:ForkThread( 
		function()
		unit:HideBone( 0, true )
		WaitSeconds(1)
		Dooropen:SetRate(-1)
		end
        )
    end,

    OnTransportDetach = function(self, attachBone, unit)
		local Dooropen = CreateAnimator(self):PlayAnim('/mods/Commander Survival Kit Units/units/UEF/Land Units/CSKTL0200/CSKTL0200_DoorOpen.sca'):SetRate(1)
        local pos
        if not self.Dying then
            pos = unit:GetPosition()
        end
        TLandUnit.OnTransportDetach(self, attachBone, unit)
        if not self.Dying then
            self:ForkThread( 
                function()
                    WaitTicks(1)
                    local height = GetTerrainHeight(pos[1],pos[3])
						unit:ShowBone( 0, true )
                        Warp(unit, {pos[1], height, pos[3] -1})
						WaitSeconds(0.5)
						Dooropen:SetRate(-1)
                end
            )
        end
    end,
	

	
}

TypeClass = CSKTL0200