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

XES0205_Cargogunship = Class(TAirUnit) {
    
    EngineRotateBones = {'R_Engine01', 'R_Engine02', 'L_Engine01', 'L_Engine02',},
    BeamExhaustCruise = '/effects/emitters/gunship_thruster_beam_01_emit.bp',
    BeamExhaustIdle = '/effects/emitters/gunship_thruster_beam_02_emit.bp',
    
    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
		
if version < 3652 then 
self:SetSpeedMult(1.6) 
else 	
self:SetSpeedMult(0.8)  
end 
		
		self:HideBone( 'L_Claw', true )
		self:HideBone( 'R_Claw', true )
		
		local position = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Cargo = CreateUnitHPR('XES0205', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Cargo:AttachBoneTo(0, self, 'Attachpoint_Lrg_03')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self.Cargo:DisableShield()
		self.Cargo:DestroyIdleEffects()
        self.EngineManipulators = {}
		
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self, 'Tractor_Emitter_Effect', self.Cargo, 0, self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self, 'Tractor_Emitter_Effect', self.Cargo, 0, self:GetArmy(), Effects ))
		table.insert(TransportBeamEffectsBag,AttachBeamEntityToEntity(self, 'Tractor_Emitter_Effect', self.Cargo, 0, self:GetArmy(), Effects ))

        # create the engine thrust manipulators
        for key, value in self.EngineRotateBones do
            table.insert(self.EngineManipulators, CreateThrustController(self, 'Thruster', value))
        end

        # set up the thursting arcs for the engines
        for key,value in self.EngineManipulators do
            #                          XMAX, XMIN, YMAX,YMIN, ZMAX,ZMIN, TURNMULT, TURNSPEED
            value:SetThrustingParam( -0.0, 0.0, -0.25, 0.25, -0.1, 1, 1.0,      0.25 )
        end

        for k, v in self.EngineManipulators do
            self.Trash:Add(v)
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
		
		local NavalRefOrigin = import('/lua/defaultunits.lua').NavalRefOrigin
		local PlayableArea = ScenarioInfo.MapData.PlayableRect
		
		if NavalRefOrigin == 'North'  then
		
		position[3] = PlayableArea[2]


		elseif NavalRefOrigin == 'East' then
		
		position[1] = PlayableArea[3]

		
		elseif NavalRefOrigin == 'South' then
		
		position[3] = PlayableArea[4]

		
		elseif NavalRefOrigin == 'West' then
		
		position[1] = PlayableArea[1]
		
		elseif NavalRefOrigin == 'Random' then
		
		local Random = math.random(4)
		
		if Random == 1 then 
		position[3] = PlayableArea[2]
		elseif Random == 2 then
		position[1] = PlayableArea[3]
		elseif Random == 3 then
		position[3] = PlayableArea[4]
		elseif Random == 4 then
		position[1] = PlayableArea[1]
		end
		
		end
		
		self.SpawnPosition = position
	
	
	    for _,effect in TransportBeamEffectsBag do
			effect:Destroy()
		end
		detachedUnit:TransportAnimation(-1)
		detachedUnit:EnableShield()
		IssueMove({self}, self.SpawnPosition)
		ForkThread( function()
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then

            elseif orders == 1 then
            elseif orders == 0 then
				self:Destroy()
            end
		WaitSeconds(1)	
        end
		end
        )
    end,

    # When one of our attached units gets killed, detach it
    OnAttachedKilled = function(self, attached)
        attached:DetachFrom()
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        TAirUnit.OnKilled(self, instigator, type, overkillRatio)
        # TransportDetachAllUnits takes 1 bool parameter. If true, randomly destroys some of the transported
        # units, otherwise successfully detaches all.
        self:TransportDetachAllUnits(true)
    end,

}
TypeClass = XES0205_Cargogunship