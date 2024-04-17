local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then -- For Steam and Loud add Rotation Patch to Unit Class 

do

local UnitOld = Unit -- load old Unit Class
local explosion = import('/lua/defaultexplosions.lua')
local Explosion = import('/lua/defaultexplosions.lua')

Unit = Class(UnitOld) {

    OnStartTransportBeamUp = function(self, transport, bone)
		if EntityCategoryContains( categories.AMPHIBIOUSTRANSPORT, transport ) or EntityCategoryContains( categories.BUNKER, transport ) then
		self:HideBone(0,true)
		self:DestroyIdleEffects()
        self:DestroyMovementEffects()
		end
    end,
	
	OnStopTransportBeamUp = function(self)
        self:DestroyIdleEffects()
        self:DestroyMovementEffects()
		if self.TransportBeamEffectsBag == nil then
		
		else
        for k, v in self.TransportBeamEffectsBag do
            v:Destroy()
        end
		end
    end,

	SetRotation = function(self, angle)
        local qx, qy, qz, qw = Explosion.QuatFromRotation(angle, 0, 1, 0)
        self:SetOrientation({qx, qy, qz, qw}, true)
    end,

    ---@param self Unit
    ---@param angle number
    Rotate = function(self, angle)
        local qx, qy, qz, qw = unpack(self:GetOrientation())
        local a = math.atan2(2.0 * (qx * qz + qw * qy), qw * qw + qx * qx - qz * qz - qy * qy)
        local current_yaw = math.floor(math.abs(a) * (180 / math.pi) + 0.5)

        self:SetRotation(angle + current_yaw)
    end,

    ---@param self Unit
    ---@param tpos number
    RotateTowards = function(self, tpos)
        local pos = self:GetPosition()
        local rad = math.atan2(tpos[1] - pos[1], tpos[3] - pos[3])
        self:SetRotation(rad * (180 / math.pi))
    end,

    ---@param self Unit
    RotateTowardsMid = function(self)
        local x, y = GetMapSize()
        self:RotateTowards({x / 2, 0, y / 2})
    end,
}

end	

else	

do

local UnitOld = Unit -- load old Unit Class
local explosion = import('/lua/defaultexplosions.lua')
local Explosion = import('/lua/defaultexplosions.lua')

Unit = Class(UnitOld) {

    OnStartTransportBeamUp = function(self, transport, bone)
		if EntityCategoryContains( categories.AMPHIBIOUSTRANSPORT, transport ) or EntityCategoryContains( categories.BUNKER, transport ) then
		self:HideBone(0,true)
		local slot = transport.slots[bone]
        if slot then
            self:GetAIBrain():OnTransportFull()
            IssueToUnitClearCommands(self)
            return
        end
		self:DestroyIdleEffects()
        self:DestroyMovementEffects()
		
		self.Brain:OnUnitStartTransportBeamUp(self, transport, bone)

		end
    end,
	
	OnStopTransportBeamUp = function(self)
        self:DestroyIdleEffects()
        self:DestroyMovementEffects()
		if self.TransportBeamEffectsBag == nil then
		
		else
        TrashDestroy(self.TransportBeamEffectsBag)
		end

        -- Reset weapons to ensure torso centres and unit survives drop
        for i = 1, self.WeaponCount do
            self.WeaponInstances[i]:ResetTarget()
        end

        -- for AI events
        self.Brain:OnUnitStoptransportBeamUp(self)
    end,
	
	
}

end		

end
	

