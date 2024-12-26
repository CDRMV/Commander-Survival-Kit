#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0304/UEA0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local TDFPlasmaCannonWeapon = import('/lua/terranweapons.lua').TDFPlasmaCannonWeapon
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')

UEFSAS10 = Class(TAirUnit) {

EngineRotateBones = {'Gondel',},

    Weapons = {
	AAGun = Class(TAirToAirLinkedRailgun) {},
	AntiAirMissileFlare = Class(TDFGaussCannonWeapon) {
		FxMuzzleFlashScale = 0.25,
	},
	DropFlare = Class(TDFGaussCannonWeapon) {
		FxMuzzleFlashScale = 0.25,
	},
	GatlingCannon = Class(TDFPlasmaCannonWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Turret02_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFPlasmaCannonWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'Turret02_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Turret02_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
        Turret01 = Class(TDFRiotWeapon) {},
		Turret02 = Class(TDFGaussCannonWeapon) {
		
		OnWeaponFired = function(self)
		ForkThread( function()
		WaitSeconds(120)
		local number = 0
		IssueClearCommands({self.unit})
		local pos = self.unit.CachePosition or self.unit:GetPosition()
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

		local position = self.unit.GetNearestPlayablePoint(self.unit,BorderPos)
		local oppoposition = self.unit.GetNearestPlayablePoint(self.unit,OppBorPos)
		self.unit.SpawnPosition = position
		IssueMove({self.unit}, self.unit.SpawnPosition)
        while not self.unit.Dead do
			if number == 0 then
			self.unit:SetUnSelectable(true)
			self.unit:RemoveCommandCap('RULEUCC_Attack')
			self.unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
			number = 1
			end
			self:SetEnabled(false)
            local orders = table.getn(self.unit:GetCommandQueue())
            if orders > 1 then

            elseif orders == 1 then
            elseif orders == 0 then
				self.unit:Destroy()
            end
		WaitSeconds(1)	
        end
		end
        )
		end,
		
		
		}
    },
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'L_Propeller01', 'y', nil, 0, 360, 360):SetTargetSpeed(5000),
			Spinner3 = CreateRotator(self, 'R_Propeller01', 'y', nil, 0, 360, 360):SetTargetSpeed(5000),
        }
		for k, v in self.Spinners do
            self.Trash:Add(v)
        end
		--self.CheckAntiAirUnitsThreadHandle = self:ForkThread(self.CheckAntiAirUnitsThread)

    end,
	
	
	OnMotionVertEventChange = function(self, new, old)
        TAirUnit.OnMotionHorzEventChange(self, new, old)
		if new == 'Down' then
            -- Play the "landing" sound
            self:PlayUnitSound('Landing')
			Gondel = CreateRotator(self, 'Gondel', 'x', 90, 90, 10, 10)
        elseif new == 'Bottom' or new == 'Hover' then
            -- Play the "landed" sound
            self:PlayUnitSound('Landed')
        elseif new == 'Up' or (new == 'Top' and (old == 'Down' or old == 'Bottom')) then
            -- Play the "takeoff" sound
            self:PlayUnitSound('TakeOff')
			Gondel = CreateRotator(self, 'Gondel', 'x', -90, 90, 10, 10)
        end
    end,
	
	CheckAntiAirUnitsThread = function(self)
		while true do
		local Pos = self:GetPosition()
        while not self:IsDead() do
            local units = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.ANTIAIR,
			self:GetPosition(), 
			50,
			'Enemy'
			
			)
            for _,unit in units do
				self:GetWeaponByLabel'AntiAirMissileFlare':FireWeapon()
            end
            
            WaitSeconds(7)
        end
		WaitSeconds(1)
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

	
}

TypeClass = UEFSAS10
