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

UES0401_Cargogunship_Squadron = Class(TAirUnit) {
    

    
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
		self:HideBone('Dummy01', false)
		self:DestroyIdleEffects()
		self:DestroyMovementEffects()
		local position = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Gunship01 = CreateUnitHPR('CSKTA0316b_Cargogunship', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Gunship01:AttachBoneTo(0, self, 'Attachpoint_Lrg01')
		self.Gunship02 = CreateUnitHPR('CSKTA0316b_Cargogunship', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Gunship02:AttachBoneTo(0, self, 'Attachpoint_Lrg02')
		self.Gunship03 = CreateUnitHPR('CSKTA0316b_Cargogunship', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Gunship03:AttachBoneTo(0, self, 'Attachpoint_Lrg03')
		self.Cargo = CreateUnitHPR('UES0401', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Cargo:AttachTo(self, 'Attachpoint_Special')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self.Cargo:DestroyIdleEffects()
        self.EngineManipulators = {}
		
		self.Gunship01:HideBone( 'R_Claw', true )
		self.Gunship01:HideBone( 'L_Claw', true )
		self.Gunship02:HideBone( 'R_Claw', true )
		self.Gunship02:HideBone( 'L_Claw', true )
		self.Gunship03:HideBone( 'R_Claw', true )
		self.Gunship03:HideBone( 'L_Claw', true )
		self.Gunship01:ShowBone( 'Tractor_Emitter', true )
		self.Gunship02:ShowBone( 'Tractor_Emitter', true )
		self.Gunship03:ShowBone( 'Tractor_Emitter', true )
		
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
		
		local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

		if version < 3652 then
		
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship01, 'Tractor_Emitter_Effect', self.Cargo, 'Upgrade_Weapon_Point01', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship01, 'Tractor_Emitter_Effect', self.Cargo, 'Upgrade_Weapon_Point02', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship01, 'Tractor_Emitter_Effect', self.Cargo, 'Upgrade_Weapon_Point03', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship01, 'Tractor_Emitter_Effect', self.Cargo, 'Upgrade_Weapon_Point04', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship02, 'Tractor_Emitter_Effect', self.Cargo, 'Attachpoint02', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship02, 'Tractor_Emitter_Effect', self.Cargo, 'Attachpoint04', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship02, 'Tractor_Emitter_Effect', self.Cargo, 'Attachpoint06', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship02, 'Tractor_Emitter_Effect', self.Cargo, 'Attachpoint08', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship03, 'Tractor_Emitter_Effect', self.Cargo, 'Back_Panel', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship03, 'Tractor_Emitter_Effect', self.Cargo, 'AA_Point', self:GetArmy(), Effects ))
		
		else
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship01, 'Tractor_Emitter_Effect', self.Cargo, 'Front_Right_sam', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship01, 'Tractor_Emitter_Effect', self.Cargo, 'Front_Left_sam', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship01, 'Tractor_Emitter_Effect', self.Cargo, 'Back_Right_sam', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship01, 'Tractor_Emitter_Effect', self.Cargo, 'Back_Left_sam', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship02, 'Tractor_Emitter_Effect', self.Cargo, 'Attachpoint02', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship02, 'Tractor_Emitter_Effect', self.Cargo, 'Attachpoint04', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship02, 'Tractor_Emitter_Effect', self.Cargo, 'Attachpoint06', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship02, 'Tractor_Emitter_Effect', self.Cargo, 'Attachpoint08', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship03, 'Tractor_Emitter_Effect', self.Cargo, 'AA_Platform', self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self.Gunship03, 'Tractor_Emitter_Effect', self.Cargo, 'AA_Point', self:GetArmy(), Effects ))
		end
    end,
	
	
	
	GetPlayableArea = function()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
	end,

	GetNearestPlayablePoint = function(self,position)

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then
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
		
	 
		self.Gunship01:OnTransportDetach()
		self.Gunship02:OnTransportDetach()
		self.Gunship03:OnTransportDetach()

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
TypeClass = UES0401_Cargogunship_Squadron