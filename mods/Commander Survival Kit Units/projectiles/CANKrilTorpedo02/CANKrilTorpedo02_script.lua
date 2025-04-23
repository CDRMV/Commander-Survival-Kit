#****************************************************************************
#**
#**  File     :  /data/projectiles/CANKrilTorpedo01/CANKrilTorpedo01_script.lua
#**  Author(s):  Gordon Duclos, Matt Vainio
#**
#**  Summary  :  Kril Torpedo Projectile script, XRB2308
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CKrilTorpedo = import('/lua/cybranprojectiles.lua').CKrilTorpedo

CANKrilTorpedo02 = Class(CKrilTorpedo) {

    FxTrails = {'/effects/emitters/torpedo_munition_trail_01_emit.bp',},
    FxTrailScale = 1,
    FxTrailOffset = 0,
    PolyTrail = '',
    PolyTrailOffset = 0,
    TrailDelay = 5,
    EnterWaterSound = 'Torpedo_Enter_Water_01',


    FxEnterWater= { '/effects/emitters/water_splash_ripples_ring_01_emit.bp',
                    '/effects/emitters/water_splash_plume_01_emit.bp',},                    
	TrailDelay = 2,                    

    OnCreate = function(self)
        CKrilTorpedo.OnCreate(self, false)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)
		ForkThread(
        function()
		local number = 0
		while not self:BeenDestroyed()  do 
		local dist = self:GetDistanceToTarget()
		if dist >= 10 then
		if number == 0 then
		self:SetVelocity(0, -20, 0)
		number = number + 1
		end
		end
		WaitSeconds(0.1)
		end
		end)
    end,	
    
    OnEnterWater = function(self)
        CKrilTorpedo.OnEnterWater(self)
        local army = self:GetArmy()
        for i in self.FxEnterWater do #splash
            CreateEmitterAtEntity(self,army,self.FxEnterWater[i])
        end
    end, 

    GetDistanceToTarget = function(self)
        local tpos = self:GetLauncher():GetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,
}
TypeClass = CANKrilTorpedo02