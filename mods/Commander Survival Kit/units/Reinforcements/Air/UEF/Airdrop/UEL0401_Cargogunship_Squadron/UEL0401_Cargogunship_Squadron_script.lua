#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0305/UEA0305_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Gunship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local Effects = '/effects/emitters/terran_transport_beam_01_emit.bp'
local TransportBeamEffectsBag = {}
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

UEL0401_Cargogunship_Squadron = Class(TAirUnit) {
    

    
    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)

--[[
The following Game Version Check is required to setup the Speed of the Dummy correctly
Without that the Dummy was pretty slow in Steam and in FAF to fast.
]]--

if version < 3652 then 
self:SetSpeedMult(25) 
else 	
self:SetSpeedMult(0.5) 
end 
		self:DestroyIdleEffects()
		self:DestroyMovementEffects()
		local position = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Gunship01 = CreateUnitHPR('CSKTA0316_Cargogunship', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Gunship01:AttachBoneTo(0, self, 'Attachpoint_Lrg01')
		self.Gunship02 = CreateUnitHPR('CSKTA0316_Cargogunship', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Gunship02:AttachBoneTo(0, self, 'Attachpoint_Lrg02')
		self.Gunship03 = CreateUnitHPR('CSKTA0316_Cargogunship', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Gunship03:AttachBoneTo(0, self, 'Attachpoint_Lrg03')
		self.Gunship04 = CreateUnitHPR('CSKTA0316_Cargogunship', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Gunship04:AttachBoneTo(0, self, 'Attachpoint_Lrg04')
		self.Gunship05 = CreateUnitHPR('CSKTA0316_Cargogunship', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Gunship05:AttachBoneTo(0, self, 'Attachpoint_Lrg05')
		self.Cargo = CreateUnitHPR('UEL0401', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Cargo:AttachTo(self, 'Attachpoint_Special')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self.Cargo:DisableShield()
		self.Cargo:DestroyIdleEffects()
        self.EngineManipulators = {}
		
		self.Gunship01:HideBone( 'R_Claw', true )
		self.Gunship01:HideBone( 'L_Claw', true )
		self.Gunship02:HideBone( 'R_Claw', true )
		self.Gunship02:HideBone( 'L_Claw', true )
		self.Gunship03:HideBone( 'R_Claw', true )
		self.Gunship03:HideBone( 'L_Claw', true )
		self.Gunship04:HideBone( 'R_Claw', true )
		self.Gunship04:HideBone( 'L_Claw', true )
		self.Gunship05:HideBone( 'R_Claw', true )
		self.Gunship05:HideBone( 'L_Claw', true )
		self.Gunship01:ShowBone( 'Tractor_Emitter', true )
		self.Gunship02:ShowBone( 'Tractor_Emitter', true )
		self.Gunship03:ShowBone( 'Tractor_Emitter', true )
		self.Gunship04:ShowBone( 'Tractor_Emitter', true )
		self.Gunship05:ShowBone( 'Tractor_Emitter', true )
		
            self.Gunship01.EngineRotator01 = CreateRotator(self.Gunship01, 'R_Engine01', 'x')
            self.Trash:Add(self.Gunship01.EngineRotator01)
            self.Gunship01.EngineRotator02 = CreateRotator(self.Gunship01, 'L_Engine01', 'x')
            self.Trash:Add(self.Gunship01.EngineRotator02)
			self.Gunship01.EngineRotator03 = CreateRotator(self.Gunship01, 'R_Engine02', 'x')
            self.Trash:Add(self.Gunship01.EngineRotator03)
            self.Gunship01.EngineRotator04 = CreateRotator(self.Gunship01, 'L_Engine02', 'x')
            self.Trash:Add(self.Gunship01.EngineRotator04)
			self.Gunship02.EngineRotator01 = CreateRotator(self.Gunship02, 'R_Engine01', 'x')
            self.Trash:Add(self.Gunship02.EngineRotator01)
            self.Gunship02.EngineRotator02 = CreateRotator(self.Gunship02, 'L_Engine01', 'x')
            self.Trash:Add(self.Gunship02.EngineRotator02)
			self.Gunship02.EngineRotator03 = CreateRotator(self.Gunship02, 'R_Engine02', 'x')
            self.Trash:Add(self.Gunship02.EngineRotator03)
            self.Gunship02.EngineRotator04 = CreateRotator(self.Gunship02, 'L_Engine02', 'x')
            self.Trash:Add(self.Gunship02.EngineRotator04)
			self.Gunship03.EngineRotator01 = CreateRotator(self.Gunship03, 'R_Engine01', 'x')
            self.Trash:Add(self.Gunship03.EngineRotator01)
            self.Gunship03.EngineRotator02 = CreateRotator(self.Gunship03, 'L_Engine01', 'x')
            self.Trash:Add(self.Gunship03.EngineRotator02)
			self.Gunship03.EngineRotator03 = CreateRotator(self.Gunship03, 'R_Engine02', 'x')
            self.Trash:Add(self.Gunship03.EngineRotator03)
            self.Gunship03.EngineRotator04 = CreateRotator(self.Gunship03, 'L_Engine02', 'x')
            self.Trash:Add(self.Gunship03.EngineRotator04)
			self.Gunship04.EngineRotator01 = CreateRotator(self.Gunship04, 'R_Engine01', 'x')
            self.Trash:Add(self.Gunship03.EngineRotator01)
            self.Gunship04.EngineRotator02 = CreateRotator(self.Gunship04, 'L_Engine01', 'x')
            self.Trash:Add(self.Gunship03.EngineRotator02)
			self.Gunship04.EngineRotator03 = CreateRotator(self.Gunship04, 'R_Engine02', 'x')
            self.Trash:Add(self.Gunship03.EngineRotator03)
            self.Gunship04.EngineRotator04 = CreateRotator(self.Gunship04, 'L_Engine02', 'x')
            self.Trash:Add(self.Gunship03.EngineRotator04)
			self.Gunship05.EngineRotator01 = CreateRotator(self.Gunship05, 'R_Engine01', 'x')
            self.Trash:Add(self.Gunship03.EngineRotator01)
            self.Gunship05.EngineRotator02 = CreateRotator(self.Gunship05, 'L_Engine01', 'x')
            self.Trash:Add(self.Gunship03.EngineRotator02)
			self.Gunship05.EngineRotator03 = CreateRotator(self.Gunship05, 'R_Engine02', 'x')
            self.Trash:Add(self.Gunship03.EngineRotator03)
            self.Gunship05.EngineRotator04 = CreateRotator(self.Gunship05, 'L_Engine02', 'x')
            self.Trash:Add(self.Gunship03.EngineRotator04)

        local Angle1 = -90
		local Angle2 = -90
        local Speed = 45
		        self.Gunship01.EngineRotator01:SetSpeed(Speed)
                self.Gunship01.EngineRotator01:SetGoal(Angle1)
				self.Gunship01.EngineRotator02:SetSpeed(Speed)
                self.Gunship01.EngineRotator02:SetGoal(Angle2)
				self.Gunship01.EngineRotator03:SetSpeed(Speed)
                self.Gunship01.EngineRotator03:SetGoal(Angle1)
				self.Gunship01.EngineRotator04:SetSpeed(Speed)
                self.Gunship01.EngineRotator04:SetGoal(Angle2)
				self.Gunship02.EngineRotator01:SetSpeed(Speed)
                self.Gunship02.EngineRotator01:SetGoal(Angle1)
				self.Gunship02.EngineRotator02:SetSpeed(Speed)
                self.Gunship02.EngineRotator02:SetGoal(Angle2)
				self.Gunship02.EngineRotator03:SetSpeed(Speed)
                self.Gunship02.EngineRotator03:SetGoal(Angle1)
				self.Gunship02.EngineRotator04:SetSpeed(Speed)
                self.Gunship02.EngineRotator04:SetGoal(Angle2)
				self.Gunship03.EngineRotator01:SetSpeed(Speed)
                self.Gunship03.EngineRotator01:SetGoal(Angle1)
				self.Gunship03.EngineRotator02:SetSpeed(Speed)
                self.Gunship03.EngineRotator02:SetGoal(Angle2)
				self.Gunship03.EngineRotator03:SetSpeed(Speed)
                self.Gunship03.EngineRotator03:SetGoal(Angle1)
				self.Gunship03.EngineRotator04:SetSpeed(Speed)
                self.Gunship03.EngineRotator04:SetGoal(Angle2)
				self.Gunship04.EngineRotator01:SetSpeed(Speed)
                self.Gunship04.EngineRotator01:SetGoal(Angle1)
				self.Gunship04.EngineRotator02:SetSpeed(Speed)
                self.Gunship04.EngineRotator02:SetGoal(Angle2)
				self.Gunship04.EngineRotator03:SetSpeed(Speed)
                self.Gunship04.EngineRotator03:SetGoal(Angle1)
				self.Gunship04.EngineRotator04:SetSpeed(Speed)
                self.Gunship04.EngineRotator04:SetGoal(Angle2)
				self.Gunship05.EngineRotator01:SetSpeed(Speed)
                self.Gunship05.EngineRotator01:SetGoal(Angle1)
				self.Gunship05.EngineRotator02:SetSpeed(Speed)
                self.Gunship05.EngineRotator02:SetGoal(Angle2)
				self.Gunship05.EngineRotator03:SetSpeed(Speed)
                self.Gunship05.EngineRotator03:SetGoal(Angle1)
				self.Gunship05.EngineRotator04:SetSpeed(Speed)
                self.Gunship05.EngineRotator04:SetGoal(Angle2)
		
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship01, 'Tractor_Emitter_Effect', self.Cargo, 'Attachpoint02', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship01, 'Tractor_Emitter_Effect', self.Cargo, 'Turret_Left_AA', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship01, 'Tractor_Emitter_Effect', self.Cargo, 'Turret_Right_AA', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship02, 'Tractor_Emitter_Effect', self.Cargo, 'Turret_Left02', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship03, 'Tractor_Emitter_Effect', self.Cargo, 'Turret_Right02', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship04, 'Tractor_Emitter_Effect', self.Cargo, 'Turret_Left01', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship05, 'Tractor_Emitter_Effect', self.Cargo, 'Turret_Right01', self:GetArmy(), Effects ))

    end,
	
	
	
	GetPlayableArea = function()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
	end,

	GetNearestPlayablePoint = function(self,position)

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign' then
	local playableArea = self.GetPlayableArea()

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end

	elseif ScenarioInfo.type == 'skirmish' then
local playableArea = self.GetPlayableArea()
if playableArea[1] == 0 and playableArea[2] == 0 then
return position
else

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end
end	
	else
	return position
	end
end,


    OnTransportDetach = function(self, attachBone, detachedUnit)
		local pos = self.CachePosition or self:GetPosition()
        local BorderPos, OppBorPos

        local x, z = pos[1] / ScenarioInfo.size[1] - 0.5, pos[3] / ScenarioInfo.size[2] - 0.6

        if math.abs(x) <= math.abs(z) then
            BorderPos = {pos[1], nil, math.ceil(z) * ScenarioInfo.size[2]}
            OppBorPos = {pos[1], nil, BorderPos[3]==0 and ScenarioInfo.size[2] or 0}
            x, z = 1, 0
        else
            BorderPos = {math.ceil(x) * ScenarioInfo.size[1], nil, pos[3]}
            OppBorPos = {BorderPos[1]==0 and ScenarioInfo.size[1] or 0, nil, pos[3]}
            x, z = 0, 1
        end

        BorderPos[2] = GetTerrainHeight(BorderPos[1], BorderPos[3])
        OppBorPos[2] = GetTerrainHeight(OppBorPos[1], OppBorPos[3])

		local position = self.GetNearestPlayablePoint(self,BorderPos)
		local oppoposition = self.GetNearestPlayablePoint(self,OppBorPos)
		self.SpawnPosition = position
		
		for _,effect in TransportBeamEffectsBag do
			effect:Destroy()
		end
		
		detachedUnit:EnableShield()
	 
		self.Gunship01:OnTransportDetach()
		self.Gunship02:OnTransportDetach()
		self.Gunship03:OnTransportDetach()
		self.Gunship04:OnTransportDetach()
		self.Gunship05:OnTransportDetach()
		self:Destroy()
    end,
	

	

    # When one of our attached units gets killed, detach it
    OnAttachedKilled = function(self, attached)
        attached:DetachFrom()
		self:OnTransportDetach()
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        TAirUnit.OnKilled(self, instigator, type, overkillRatio)
		self:OnTransportDetach()
    end,

}
TypeClass = UEL0401_Cargogunship_Squadron