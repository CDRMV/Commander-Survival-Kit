--[[

#****************************************************************************
#**
#**  File     :  /lua/unit.lua
#**  Author(s):  John Comes, David Tomandl, Gordon Duclos
#**
#**  Summary  : The Unit lua module
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local Entity = import('/lua/sim/Entity.lua').Entity
local explosion = import('/lua/defaultexplosions.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtilities = import('/lua/EffectUtilities.lua')
local Game = import('/lua/game.lua')
local utilities = import('/lua/utilities.lua')
local Shield = import('/lua/shield.lua').Shield
local UnitShield = import('/lua/shield.lua').UnitShield
local AntiArtilleryShield = import('/lua/shield.lua').AntiArtilleryShield
local Buff = import('/lua/sim/buff.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')

SyncMeta = {
    __index = function(t,key)
        local id = rawget(t,'id')
        return UnitData[id].Data[key]
    end,

    __newindex = function(t,key,val)
        #LOG( "SYNC: " .. key .. ' = ' .. repr(val))
        local id = rawget(t,'id')
        local army = rawget(t,'army')
        if not UnitData[id] then
            UnitData[id] = {
                OwnerArmy = rawget(t,'army'),
                Data = {}
            }
        end
        UnitData[id].Data[key] = val

        if army == GetFocusArmy() then
            if not Sync.UnitData[id] then
                Sync.UnitData[id] = {}
            end
            Sync.UnitData[id][key] = val
        end
    end,
}

Unit = Class(moho.unit_methods) {
    Weapons = {},

    FxScale = 1,
    FxDamageScale = 1,
    # FX Damage tables. A random damage effect table of emitters is choosen out of this table
    FxDamage1 = { EffectTemplate.DamageSmoke01, EffectTemplate.DamageSparks01 },
    FxDamage2 = { EffectTemplate.DamageFireSmoke01, EffectTemplate.DamageSparks01 },
    FxDamage3 = { EffectTemplate.DamageFire01, EffectTemplate.DamageSparks01 },

    # This will be true for all units being constructed as upgrades
    DisallowCollisions = false,

    # Destruction params
    PlayDestructionEffects = true,
    PlayEndAnimDestructionEffects = true,
    ShowUnitDestructionDebris = true,
    DestructionExplosionWaitDelayMin = 0,
    DestructionExplosionWaitDelayMax = 0.5,
    DeathThreadDestructionWaitTime = 0,
    DestructionPartsHighToss = {},
    DestructionPartsLowToss = {},
    DestructionPartsChassisToss = {},
    EconomyProductionInitiallyActive = true,

    GetSync = function(self)
        if not Sync.UnitData[self:GetEntityId()] then
            Sync.UnitData[self:GetEntityId()] = {}
        end
        return Sync.UnitData[self:GetEntityId()]
    end,

    ##########################################################################################
    ## INITIALIZATION
    ##########################################################################################

    OnPreCreate = function(self)
        # Each unit has a sync table that magically knows when values change and stuffs it
        # in the global sync table to copy to the user layer at sync time.
        self.Sync = {}
        self.Sync.id = self:GetEntityId()
        self.Sync.army = self:GetArmy()
        setmetatable(self.Sync,SyncMeta)

        #Entity.OnPreCreate(self)
        if not self.Trash then
            self.Trash = TrashBag()
        end
        self.EventCallbacks = {
                OnKilled = {},
                OnUnitBuilt = {},
                OnStartBuild = {},
                OnReclaimed = {},
                OnStartReclaim = {},
                OnStopReclaim = {},
                OnStopBeingBuilt = {},
                OnHorizontalStartMove = {},
                OnCaptured = {},
                OnCapturedNewUnit = {},
                OnDamaged = {},
                OnStartCapture = {},
                OnStopCapture = {},
                OnFailedCapture = {},
                OnStartBeingCaptured = {},
                OnStopBeingCaptured = {},
                OnFailedBeingCaptured = {},
                OnFailedToBuild = {},
                OnVeteran = {},
                ProjectileDamaged = {},
                SpecialToggleEnableFunction = false,
                SpecialToggleDisableFunction = false,
        }
    end,

    OnCreate = function(self)
        Entity.OnCreate(self)
        # Turn off land bones if this unit has them.
        self:HideLandBones()
		self.Sync.CurrentAmmunition = 0
		LOG('self.Sync.CurrentAmmunition: ', self.Sync.CurrentAmmunition)
        # Set number of effects per damage depending on its volume
        local x, y, z = self:GetUnitSizes()
        local vol = x*y*z
        #print('Created ' .. self:GetBlueprint().Display.DisplayName .. ': Volume:' .. vol)
        local damageamounts = 1
        if vol >= 20 then
            damageamounts = 6
            self.FxDamageScale = 2
        elseif vol >= 10 then
            damageamounts = 4
            self.FxDamageScale = 1.5
        elseif vol >= 0.5 then
            damageamounts = 2
        end
        #print('Damage Amounts: ' .. damageamounts)
        self.FxDamage1Amount = self.FxDamage1Amount or damageamounts
        self.FxDamage2Amount = self.FxDamage2Amount or damageamounts
        self.FxDamage3Amount = self.FxDamage3Amount or damageamounts
        self.DamageEffectsBag = {
            {},
            {},
            {},
        }

        # Setup effect emitter bags
        self.MovementEffectsBag = {}
        self.IdleEffectsBag = {}
        self.TopSpeedEffectsBag = {}
        self.BeamExhaustEffectsBag = {}
        self.TransportBeamEffectsBag = {}
        self.BuildEffectsBag = TrashBag()
        self.ReclaimEffectsBag = TrashBag()
        self.OnBeingBuiltEffectsBag = TrashBag()
        self.CaptureEffectsBag = TrashBag()
        self.UpgradeEffectsBag = TrashBag()

        self.HasFuel = true

        local bpEcon = self:GetBlueprint().Economy

        self:SetConsumptionPerSecondEnergy(bpEcon.MaintenanceConsumptionPerSecondEnergy or 0)
        self:SetConsumptionPerSecondMass(bpEcon.MaintenanceConsumptionPerSecondMass or 0)
        self:SetProductionPerSecondEnergy(bpEcon.ProductionPerSecondEnergy or 0)
        self:SetProductionPerSecondMass(bpEcon.ProductionPerSecondMass or 0)

        if self.EconomyProductionInitiallyActive then
            #LOG('*DEBUG: SETTING PRODUCTION ACTIVE')
            self:SetProductionActive(true)
        end

        self.Buffs = {
            BuffTable = {},
            Affects = {},
        }

        local bpVision = self:GetBlueprint().Intel.VisionRadius
        if bpVision then
            self:SetIntelRadius('Vision', bpVision)
        else
            self:SetIntelRadius('Vision', 0)
        end

        self:SetCanTakeDamage(true)

        self:SetCanBeKilled(true)

        local bpDeathAnim = self:GetBlueprint().Display.AnimationDeath

        if bpDeathAnim and table.getn(bpDeathAnim) > 0 then
            self.PlayDeathAnimation = true
        end
        
        # Used for keeping track of resource consumption
        self.MaintenanceConsumption = false
        self.ActiveConsumption = false
        self.ProductionEnabled = true
        self.EnergyModifier = 0
        self.MassModifier = 0

        self.VeteranLevel = 0

        if self:GetAIBrain().CheatEnabled then
            AIUtils.ApplyCheatBuffs(self)
        end
        
        self.Dead = false        
    end,
	
EnableButton = function(self, boolean)
self:AddToggleCap('RULEUTC_SpecialToggle')
end,


    ##########################################################################################
    ## MISC FUNCTIONS
    ##########################################################################################

    SetDead = function(self)
        self.Dead = true
    end,

    IsDead = function(self)
        return self.Dead
    end,

    GetCachePosition = function(self)
        return self:GetPosition()
    end,

    GetFootPrintSize = function(self)
        local fp = self:GetBlueprint().Footprint
        return math.max(fp.SizeX, fp.SizeZ)
    end,

    # Returns 4 numbers:
    #   skirt x0, skirt z0, skirt.x1, skirt.z1
    GetSkirtRect = function(self)
        local bp = self:GetBlueprint()
        local x, y, z = unpack(self:GetPosition())
        local fx = x - bp.Footprint.SizeX*.5
        local fz = z - bp.Footprint.SizeZ*.5
        local sx = fx + bp.Physics.SkirtOffsetX
        local sz = fz + bp.Physics.SkirtOffsetZ
        return sx, sz, sx+bp.Physics.SkirtSizeX, sz+bp.Physics.SkirtSizeZ
    end,

    GetUnitSizes = function(self)
        local bp = self:GetBlueprint()
        return bp.SizeX, bp.SizeY, bp.SizeZ
    end,

    GetRandomOffset = function(self, scalar)
        local sx, sy, sz = self:GetUnitSizes()
        local heading = self:GetHeading()
        sx = sx * scalar
        sy = sy * scalar
        sz = sz * scalar
        local rx = Random() * sx - (sx * 0.5)
        local y  = Random() * sy + (self:GetBlueprint().CollisionOffsetY or 0)
        local rz = Random() * sz - (sz * 0.5)
        local x = math.cos(heading)*rx - math.sin(heading)*rz
        local z = math.sin(heading)*rx - math.cos(heading)*rz
        return x,y,z
    end,

    ForkThread = function(self, fn, ...)
        if fn then
            local thread = ForkThread(fn, self, unpack(arg))
            self.Trash:Add(thread)
            return thread
        else
            return nil
        end
    end,

    LifeTimeThread = function(self)
        local bp = self:GetBlueprint().Defense.LifeTime
        if not bp then return end
        WaitSeconds(bp)
        self:Destroy()
    end,

    SetTargetPriorities = function(self, priTable)
        for i = 1, self:GetWeaponCount() do
            local wep = self:GetWeapon(i)
            wep:SetWeaponPriorities(priTable)
        end
    end,
    
    SetLandTargetPriorities = function(self, priTable)
        for i = 1, self:GetWeaponCount() do
            local wep = self:GetWeapon(i)
            
            for onLayer, targetLayers in wep:GetBlueprint().FireTargetLayerCapsTable do
                if string.find(targetLayers, 'Land') then
                    wep:SetWeaponPriorities(priTable)
                    break
                end
            end
        end
    end,

    ##########################################################################################
    ## TOGGLES
    ##########################################################################################
     OnScriptBitSet = function(self, bit)
        if bit == 0 then # shield toggle
            self:PlayUnitAmbientSound( 'ActiveLoop' )
            self:EnableShield()
        elseif bit == 1 then # weapon toggle
            # do something
        elseif bit == 2 then # jamming toggle
            self:StopUnitAmbientSound( 'ActiveLoop' )
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('Jammer')
        elseif bit == 3 then # intel toggle
            self:StopUnitAmbientSound( 'ActiveLoop' )
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('RadarStealth')
            self:DisableUnitIntel('RadarStealthField')
            self:DisableUnitIntel('SonarStealth')
            self:DisableUnitIntel('SonarStealthField')
            self:DisableUnitIntel('Sonar')
            self:DisableUnitIntel('Omni')
            self:DisableUnitIntel('Cloak')
            self:DisableUnitIntel('CloakField')
            self:DisableUnitIntel('Spoof')
            self:DisableUnitIntel('Jammer')
            self:DisableUnitIntel('Radar')
        elseif bit == 4 then # production toggle
            self:OnProductionPaused()
        elseif bit == 5 then # stealth toggle
            self:StopUnitAmbientSound( 'ActiveLoop' )
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('RadarStealth')
            self:DisableUnitIntel('RadarStealthField')
            self:DisableUnitIntel('SonarStealth')
            self:DisableUnitIntel('SonarStealthField')
        elseif bit == 6 then # generic pause toggle
            self:SetPaused(true)
        elseif bit == 7 then # special toggle
            self:EnableSpecialToggle()
        elseif bit == 8 then # cloak toggle
            self:StopUnitAmbientSound( 'ActiveLoop' )
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('Cloak')
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 0 then # shield toggle
            self:StopUnitAmbientSound( 'ActiveLoop' )
            self:DisableShield()
        elseif bit == 1 then # weapon toggle
            # do something
        elseif bit == 2 then # jamming toggle
            self:PlayUnitAmbientSound( 'ActiveLoop' )
            self:SetMaintenanceConsumptionActive()
            self:EnableUnitIntel('Jammer')
        elseif bit == 3 then # intel toggle
            self:PlayUnitAmbientSound( 'ActiveLoop' )
            self:SetMaintenanceConsumptionActive()
            self:EnableUnitIntel('Radar')
            self:EnableUnitIntel('RadarStealth')
            self:EnableUnitIntel('RadarStealthField')
            self:EnableUnitIntel('SonarStealth')
            self:EnableUnitIntel('SonarStealthField')
            self:EnableUnitIntel('Sonar')
            self:EnableUnitIntel('Omni')
            self:EnableUnitIntel('Cloak')
            self:EnableUnitIntel('CloakField')
            self:EnableUnitIntel('Spoof')
            self:EnableUnitIntel('Jammer')
        elseif bit == 4 then # production toggle
            self:OnProductionUnpaused()
        elseif bit == 5 then # stealth toggle
            self:PlayUnitAmbientSound( 'ActiveLoop' )
            self:SetMaintenanceConsumptionActive()
            self:EnableUnitIntel('RadarStealth')
            self:EnableUnitIntel('RadarStealthField')
            self:EnableUnitIntel('SonarStealth')
            self:EnableUnitIntel('SonarStealthField')
        elseif bit == 6 then # generic pause toggle
            self:SetPaused(false)
        elseif bit == 7 then # special toggle
            self:DisableSpecialToggle()
        elseif bit == 8 then # cloak toggle
            self:PlayUnitAmbientSound( 'ActiveLoop' )
            self:SetMaintenanceConsumptionActive()
            self:EnableUnitIntel('Cloak')
        end
    end,

    OnPaused = function(self)
        self:SetActiveConsumptionInactive()
        self:StopUnitAmbientSound( 'ConstructLoop' )
    end,

    OnUnpaused = function(self)
        if self:IsUnitState('Building') or self:IsUnitState('Upgrading') or self:IsUnitState('Repairing') then
            self:SetActiveConsumptionActive()
            self:PlayUnitAmbientSound( 'ConstructLoop' )
        end
    end,

    EnableSpecialToggle = function(self)
        if self.EventCallbacks.SpecialToggleEnableFunction then
            self.EventCallbacks.SpecialToggleEnableFunction(self)
        end
    end,

    DisableSpecialToggle = function(self)
        if self.EventCallbacks.SpecialToggleDisableFunction then
            self.EventCallbacks.SpecialToggleDisableFunction(self)
        end
    end,

    AddSpecialToggleEnable = function(self, fn)
        if fn then
            self.EventCallbacks.SpecialToggleEnableFunction = fn
        end
    end,

    AddSpecialToggleDisable = function(self, fn)
        if fn then
            self.EventCallbacks.SpecialToggleDisableFunction = fn
        end
    end,

    EnableDefaultToggleCaps = function( self )
        if self.ToggleCaps then
            for k,v in self.ToggleCaps do
                self:AddToggleCap(v)
            end
        end
    end,

    DisableDefaultToggleCaps = function( self )
        self.ToggleCaps = {}
        local capsCheckTable = {'RULEUTC_WeaponToggle', 'RULEUTC_ProductionToggle', 'RULEUTC_GenericToggle', 'RULEUTC_SpecialToggle'}
        for k,v in capsCheckTable do
            if self:TestToggleCaps(v) == true then
                table.insert( self.ToggleCaps, v )
            end
            self:RemoveToggleCap(v)
        end
    end,


    ##########################################################################################
    ## MISC EVENTS
    ##########################################################################################

    OnSpecialAction = function(self, location)
    end,

    OnProductionActive = function(self)
         #LOG('*DEBUG: PRODUCTION IS NOW ACTIVE')
    end,

    OnActive = function(self)
    end,

    OnInactive = function(self)
    end,


    OnStartCapture = function(self, target)
        self:DoUnitCallbacks( 'OnStartCapture', target )
        self:StartCaptureEffects(target)
        self:PlayUnitSound('StartCapture')
        self:PlayUnitAmbientSound('CaptureLoop')
    end,

    OnStopCapture = function(self, target)
        self:DoUnitCallbacks( 'OnStopCapture', target )
        self:StopCaptureEffects(target)
        self:PlayUnitSound('StopCapture')
        self:StopUnitAmbientSound('CaptureLoop')
    end,

    StartCaptureEffects = function( self, target )
		self.CaptureEffectsBag:Add( self:ForkThread( self.CreateCaptureEffects, target ) )
    end,

    CreateCaptureEffects = function( self, target )
    end,

    StopCaptureEffects = function( self, target )
		self.CaptureEffectsBag:Destroy()
    end,

    OnFailedCapture = function(self, target)
        self:DoUnitCallbacks( 'OnFailedCapture', target )
        self:StopCaptureEffects(target)
        self:PlayUnitSound('FailedCapture')
    end,

    OnStartBeingCaptured = function(self, captor)
        self:DoUnitCallbacks( 'OnStartBeingCaptured', captor )
        self:PlayUnitSound('StartBeingCaptured')
    end,

    OnStopBeingCaptured = function(self, captor)
        self:DoUnitCallbacks( 'OnStopBeingCaptured', captor )
        self:PlayUnitSound('StopBeingCaptured')
    end,

    OnFailedBeingCaptured = function(self, captor)
        self:DoUnitCallbacks( 'OnFailedBeingCaptured', captor )
        self:PlayUnitSound('FailedBeingCaptured')
    end,

    OnReclaimed = function(self, entity)
        self:DoUnitCallbacks('OnReclaimed', entity)
        self.CreateReclaimEndEffects( entity, self )
        self:Destroy()
    end,

    OnStartReclaim = function(self, target)
        self:DoUnitCallbacks('OnStartReclaim', target)
        self:StartReclaimEffects(target)
        self:PlayUnitSound('StartReclaim')
        self:PlayUnitAmbientSound('ReclaimLoop')
    end,

    OnStopReclaim = function(self, target)
        self:DoUnitCallbacks('OnStopReclaim', target)
		self:StopReclaimEffects(target)
		self:StopUnitAmbientSound('ReclaimLoop')
		self:PlayUnitSound('StopReclaim')
    end,

    StartReclaimEffects = function( self, target )
		self.ReclaimEffectsBag:Add( self:ForkThread( self.CreateReclaimEffects, target ) )
    end,

    CreateReclaimEffects = function( self, target )
    end,

    CreateReclaimEndEffects = function( self, target )
    end,

    StopReclaimEffects = function( self, target )
		self.ReclaimEffectsBag:Destroy()
    end,

    OnDecayed = function(self)
        self:Destroy()
    end,

    OnCaptured = function(self, captor)
        if self and not self:IsDead() and captor and not captor:IsDead() and self:GetAIBrain() ~= captor:GetAIBrain() then
            if not self:IsCapturable() then
                self:Kill()
                return
            end
            # kill non capturable things on a transport
            if EntityCategoryContains( categories.TRANSPORTATION, self ) then
                local cargo = self:GetCargo()
                for _,v in cargo do
                    if not v:IsDead() and not v:IsCapturable() then
                        v:Kill()
                    end
                end
            end 
            self:DoUnitCallbacks('OnCaptured', captor)
            local newUnitCallbacks = {}
            if self.EventCallbacks.OnCapturedNewUnit then
                newUnitCallbacks = self.EventCallbacks.OnCapturedNewUnit
            end
            local entId = self:GetEntityId()
            local unitEnh = SimUnitEnhancements[entId]
            local captorArmyIndex = captor:GetArmy()
            local captorBrain = false
            
            # For campaigns:
            # We need the brain to ignore army cap when transfering the unit
            # do all necessary steps to set brain to ignore, then un-ignore if necessary the unit cap
            
            if ScenarioInfo.CampaignMode then
                captorBrain = captor:GetAIBrain()
                SetIgnoreArmyUnitCap(captorArmyIndex, true)
            end
            
            #bugfix when capturing an enemy it should retain its data
            local newUnits = import('/lua/SimUtils.lua').TransferUnitsOwnership( {self}, captorArmyIndex)
           
            if ScenarioInfo.CampaignMode and not captorBrain.IgnoreArmyCaps then
                SetIgnoreArmyUnitCap(captorArmyIndex, false)
            end

            # the unit transfer function returns a table of units. since we transfered 1 unit the table contains 1
            # unit (the new unit).
            if table.getn(newUnits) != 1 then
                return
            end
            local newUnit
            for k, unit in newUnits do
                newUnit = unit
                break
            end
            
            # no need for this anymore
            #if unitEnh then
            #    for k,v in unitEnh do
            #        newUnit:CreateEnhancement(v)
            #    end
            #end
            # Because the old unit is lost we cannot call a member function for newUnit callbacks
            for k,cb in newUnitCallbacks do
                if cb then
                    cb(newUnit, captor)
                end
            end
        end
    end,



    ##########################################################################################
    ## ECONOMY
    ##########################################################################################

    OnConsumptionActive = function(self)
    end,

    OnConsumptionInActive = function(self)
    end,

    # We are splitting Consumption into two catagories:
    #   Maintenance -- for units that are usually "on": radar, mass extractors, etc.
    #   Active -- when upgrading, constructing, or something similar.
    #
    # It will be possible for both or neither of these consumption methods to be
    # in operation at the same time.  Here are the functions to turn them off and on.
    SetMaintenanceConsumptionActive = function(self)
        self.MaintenanceConsumption = true
        self:UpdateConsumptionValues()
    end,

    SetMaintenanceConsumptionInactive = function(self)
        self.MaintenanceConsumption = false
        self:UpdateConsumptionValues()
    end,

    SetActiveConsumptionActive = function(self)
        self.ActiveConsumption = true
        self:UpdateConsumptionValues()
    end,

    SetActiveConsumptionInactive = function(self)
        self.ActiveConsumption = false
        self:UpdateConsumptionValues()
    end,

    OnProductionPaused = function(self)
        self:SetMaintenanceConsumptionInactive()
        self:SetProductionActive(false)
    end,

    OnProductionUnpaused = function(self)
        self:SetMaintenanceConsumptionActive()
        self:SetProductionActive(true)
    end,

    SetBuildTimeMultiplier = function(self, time_mult)
        self.BuildTimeMultiplier = time_mult
    end,

    GetMassBuildAdjMod = function(self)
        return (self.MassBuildAdjMod or 1)
    end,

    GetEnergyBuildAdjMod = function(self)
        return (self.EnergyBuildAdjMod or 1)
    end,

    GetEconomyBuildRate = function(self)
        return self:GetBuildRate() 
    end,

    #
    # Called when we start building a unit, turn on/off, get/lose bonuses, or on
    # any other change that might affect our build rate or resource use.
    #
    UpdateConsumptionValues = function(self)
        local myBlueprint = self:GetBlueprint()

        local energy_rate = 0
        local mass_rate = 0
        local build_rate = 0

        if self.ActiveConsumption then
            local focus = self:GetFocusUnit()
            local time = 1
            local mass = 0
            local energy = 0
            if self.WorkItem then
                time, energy, mass = Game.GetConstructEconomyModel(self, self.WorkItem)
            elseif focus and focus:IsUnitState('SiloBuildingAmmo') then
                # If building silo ammo; create the energy and mass costs based on build rate of the silo
                #     against the build rate of the assisting unit
                time, energy, mass = focus:GetBuildCosts(focus.SiloProjectile)
                
                local siloBuildRate = focus:GetBuildRate() or 1
                energy = (energy / siloBuildRate) * (self:GetBuildRate() or 1)
                mass = (mass / siloBuildRate) * (self:GetBuildRate() or 1)
            elseif focus then
                # bonuses are already factored in by GetBuildCosts
                time, energy, mass = self:GetBuildCosts(focus:GetBlueprint())
            end
            energy = energy * (self.EnergyBuildAdjMod or 1)
            if energy < 1 then
                energy = 1
            end
            mass = mass * (self.MassBuildAdjMod or 1)
            if mass < 1 then
                mass = 1
            end

            energy_rate = energy / time
            mass_rate = mass / time
        end

        if self.MaintenanceConsumption then
            local mai_energy = (self.EnergyMaintenanceConsumptionOverride or myBlueprint.Economy.MaintenanceConsumptionPerSecondEnergy)  or 0
            local mai_mass = myBlueprint.Economy.MaintenanceConsumptionPerSecondMass or 0

            # apply bonuses
            mai_energy = mai_energy * (100 + self.EnergyModifier) * (self.EnergyMaintAdjMod or 1) * 0.01
            mai_mass = mai_mass * (100 + self.MassModifier) * (self.MassMaintAdjMod or 1) * 0.01

            energy_rate = energy_rate + mai_energy
            mass_rate = mass_rate + mai_mass
        end

        # apply minimum rates
        energy_rate = math.max(energy_rate, myBlueprint.Economy.MinConsumptionPerSecondEnergy or 0)
        mass_rate = math.max(mass_rate, myBlueprint.Economy.MinConsumptionPerSecondMass or 0)

        self:SetConsumptionPerSecondEnergy(energy_rate)
        self:SetConsumptionPerSecondMass(mass_rate)

        if (energy_rate > 0) or (mass_rate > 0) then
            self:SetConsumptionActive(true)
        else
            self:SetConsumptionActive(false)
        end
    end,

    UpdateProductionValues = function(self)
        local bpEcon = self:GetBlueprint().Economy
        if not bpEcon then return end
        self:SetProductionPerSecondEnergy((bpEcon.ProductionPerSecondEnergy or 0) * (self.EnergyProdAdjMod or 1))
        self:SetProductionPerSecondMass((bpEcon.ProductionPerSecondMass or 0) * (self.MassProdAdjMod or 1))
    end,

    SetEnergyMaintenanceConsumptionOverride = function(self, override)
        self.EnergyMaintenanceConsumptionOverride = override or 0
    end,

    SetBuildRateOverride = function(self, overRide)
        self.BuildRateOverride = overRide
    end,

    GetBuildRateOverride = function(self)
        return self.BuildRateOverride
    end,

    ##########################################################################################
    ## DAMAGE
    ##########################################################################################
    #Sets if the unit can take damage.  val = true means it can take damage.
    #val = false means it can't take damage
    SetCanTakeDamage = function(self, val)
        self.CanTakeDamage = val
    end,

    CheckCanTakeDamage = function(self)
        return self.CanTakeDamage
    end,
    
    OnDamage = function(self, instigator, amount, vector, damageType)
        if self.CanTakeDamage then
            self:DoOnDamagedCallbacks(instigator)
            self:DoTakeDamage(instigator, amount, vector, damageType)
        end
    end,

    DoTakeDamage = function(self, instigator, amount, vector, damageType)
        local preAdjHealth = self:GetHealth()
        self:AdjustHealth(instigator, -amount)
        local health = self:GetHealth()
        if( health <= 0 ) then
            if( damageType == 'Reclaimed' ) then
                self:Destroy()
            else
                local excessDamageRatio = 0.0
                # Calculate the excess damage amount
                local excess = preAdjHealth - amount
                local maxHealth = self:GetMaxHealth()
                if(excess < 0 and maxHealth > 0) then
                    excessDamageRatio = -excess / maxHealth
                end
                self:Kill(instigator, damageType, excessDamageRatio)
            end
        end
        if EntityCategoryContains(categories.COMMAND, self) then
            local aiBrain = self:GetAIBrain()
            if aiBrain then
                aiBrain:OnPlayCommanderUnderAttackVO()
            end
        end
    end,

    ManageDamageEffects = function(self, newHealth, oldHealth)
        #LOG('*DEBUG: ManageDamageEffects, New: ', repr(newHealth), ' Old: ', repr(oldHealth))

        # Health values come in at fixed 25% intervals
        if newHealth < oldHealth then
            if oldHealth == 0.75 then
                for i = 1, self.FxDamage1Amount do
                    self:PlayDamageEffect(self.FxDamage1, self.DamageEffectsBag[1])
                end
            elseif oldHealth == 0.5 then
                for i = 1, self.FxDamage2Amount do
                    self:PlayDamageEffect(self.FxDamage2, self.DamageEffectsBag[2])
                end
            elseif oldHealth == 0.25 then
                for i = 1, self.FxDamage3Amount do
                    self:PlayDamageEffect(self.FxDamage3, self.DamageEffectsBag[3])
                end
            end
        else
            if newHealth <= 0.25 and newHealth > 0 then
                for k, v in self.DamageEffectsBag[3] do
                    v:Destroy()
                end
            elseif newHealth <= 0.5 and newHealth > 0.25 then
                for k, v in self.DamageEffectsBag[2] do
                    v:Destroy()
                end
            elseif newHealth <= 0.75 and newHealth > 0.5 then
                for k, v in self.DamageEffectsBag[1] do
                    v:Destroy()
                end
            elseif newHealth > 0.75 then
                self:DestroyAllDamageEffects()    
            end
        end
    end,

    PlayDamageEffect = function(self, fxTable, fxBag)
        local army = self:GetArmy()
        local effects = fxTable[Random(1,table.getn(fxTable))]
        if not effects then return end
        local totalBones = self:GetBoneCount()
        local bone = Random(1, totalBones) - 1
        local bpDE = self:GetBlueprint().Display.DamageEffects
        for k, v in effects do
            local fx
            if bpDE then
                local num = Random(1, table.getsize(bpDE))
                local bpFx = bpDE[num]
                fx = CreateAttachedEmitter(self, bpFx.Bone or 0,army, v):ScaleEmitter(self.FxDamageScale):OffsetEmitter(bpFx.OffsetX or 0, bpFx.OffsetY or 0, bpFx.OffsetZ or 0)
            else
                fx = CreateAttachedEmitter(self, bone, army, v):ScaleEmitter(self.FxDamageScale)
            end
            table.insert(fxBag, fx)
        end
    end,

    OnHealthChanged = function(self, new, old)
        self:ManageDamageEffects(new, old)
    end,


    DestroyAllDamageEffects = function(self)
        for kb, vb in self.DamageEffectsBag do
            for ke, ve in vb do
                ve:Destroy()
            end
        end
    end,

    CheckCanBeKilled = function(self,other)
        return self.CanBeKilled
    end,

    # On killed: this function plays when the unit takes a mortal hit.  It plays all the default death effect
    # it also spawns the wreckage based upon how much it was overkilled.
    OnKilled = function(self, instigator, type, overkillRatio)
        
        self.Dead = true
    
        local bp = self:GetBlueprint()
        if self:GetCurrentLayer() == 'Water' and bp.Physics.MotionType == 'RULEUMT_Hover' then
            self:PlayUnitSound('HoverKilledOnWater')
        end
        
        if self:GetCurrentLayer() == 'Land' and bp.Physics.MotionType == 'RULEUMT_AmphibiousFloating' then
            --Handle ships that can walk on land...
            self:PlayUnitSound('AmphibiousFloatingKilledOnLand')
        else
            self:PlayUnitSound('Killed')
        end
        

        #If factory, destory what I'm building if I die
        if EntityCategoryContains(categories.FACTORY, self) then
            if self.UnitBeingBuilt and not self.UnitBeingBuilt:IsDead() and self.UnitBeingBuilt:GetFractionComplete() != 1 then
                self.UnitBeingBuilt:Kill()
            end
        end

        if self.PlayDeathAnimation and not self:IsBeingBuilt() then
            self:ForkThread(self.PlayAnimationThread, 'AnimationDeath')
            self:SetCollisionShape('None')
        end
        self:OnKilledVO()
        self:DoUnitCallbacks( 'OnKilled' )
        self:DestroyTopSpeedEffects()

        if self.UnitBeingTeleported and not self.UnitBeingTeleported:IsDead() then
            self.UnitBeingTeleported:Destroy()
            self.UnitBeingTeleported = nil
        end

        #Notify instigator that you killed me.
        if instigator and IsUnit(instigator) then
            instigator:OnKilledUnit(self)
        end
        if self.DeathWeaponEnabled != false then
            self:DoDeathWeapon()
        end
        self:DisableShield()
        self:DisableUnitIntel()
        self:ForkThread(self.DeathThread, overkillRatio , instigator)
    end,


    #Sets if the unit can be killed.  val = true means it can be killed.
    #val = false means it can't be killed
    SetCanBeKilled = function(self, val)
        self.CanBeKilled = val
    end,

    OnKilledUnit = function(self, unitKilled)
        self:CheckVeteranLevel()
    end,

    DoDeathWeapon = function(self)
        if self:IsBeingBuilt() then return end
        local bp = self:GetBlueprint()
        for k, v in bp.Weapon do
            if(v.Label == 'DeathWeapon') then
                if v.FireOnDeath == true then
                    self:SetWeaponEnabledByLabel('DeathWeapon', true)
                    self:GetWeaponByLabel('DeathWeapon'):Fire()
                else
                    self:ForkThread(self.DeathWeaponDamageThread, v.DamageRadius, v.Damage, v.DamageType, v.DamageFriendly)
                end
                break
            end
        end
    end,

    OnCollisionCheck = function(self, other, firingWeapon)
        if self.DisallowCollisions then
            return false
        end
        if EntityCategoryContains(categories.PROJECTILE, other) then
            if self:GetArmy() == other:GetArmy() then
                return other:GetCollideFriendly()
            end
        end
        
		# if this unit category is on the unit's do-not-collide list, skip!
		local bp = other:GetBlueprint()	
		if bp.DoNotCollideList then
			for k, v in pairs(bp.DoNotCollideList) do
				if EntityCategoryContains(ParseEntityCategory(v), self) then
					return false
				end
			end
		end
		 
		bp = self:GetBlueprint()	
		if bp.DoNotCollideList then
			for k, v in pairs(bp.DoNotCollideList) do
				if EntityCategoryContains(ParseEntityCategory(v), other) then
					return false
				end
			end
		end		 
		        
        return true
    end,


    OnCollisionCheckWeapon = function(self, firingWeapon)
        if self.DisallowCollisions then
            return false
        end
        local weaponBP = firingWeapon:GetBlueprint()
		
		# skip friendly collisions if specified
        local collide = weaponBP.CollideFriendly
        if collide == false then
            if self:GetArmy() == firingWeapon.unit:GetArmy() then
                return false
            end
        end

		# if this unit category is on the weapon's do-not-collide list, skip!	
		if weaponBP.DoNotCollideList then
			for k, v in pairs(weaponBP.DoNotCollideList) do
				if EntityCategoryContains(ParseEntityCategory(v), self) then
					return false
				end
			end
		end
		
        return true
    end,

    ChooseAnimBlock = function(self, bp)
        local totWeight = 0
        for k, v in bp do
            if v.Weight then
                totWeight = totWeight + v.Weight
            end
        end
        local val = 1
        local num = Random(0, totWeight)
        for k, v in bp do
            if v.Weight then
                val = val + v.Weight
            end
            if num < val then
                return v
            end
        end
    end,

    PlayAnimationThread = function(self, anim, rate)
        local bp = self:GetBlueprint().Display[anim]
        if bp then
            local animBlock = self:ChooseAnimBlock( bp )
            if animBlock.Mesh then
                self:SetMesh(animBlock.Mesh)
            end
            if animBlock.Animation then
                local sinkAnim = CreateAnimator(self)
                self:StopRocking()
                self.DeathAnimManip = sinkAnim
                sinkAnim:PlayAnim(animBlock.Animation)
                rate = rate or 1
                if animBlock.AnimationRateMax and animBlock.AnimationRateMin then
                    rate = Random(animBlock.AnimationRateMin * 10, animBlock.AnimationRateMax * 10) / 10
                end
                sinkAnim:SetRate(rate)
                self.Trash:Add(sinkAnim)
                WaitFor(sinkAnim)
            end
        end
    end,
    
    #
    # Create a unit's wrecked mesh blueprint from its regular mesh blueprint, by changing the shader and albedo
    #
    CreateWreckage = function( self, overkillRatio )
		# if overkill ratio is high, the wreck is vaporized! No wreackage for you!
		if overkillRatio then
			if overkillRatio > 1.0 then
				return
			end
		end

		# generate wreakage in place of the dead unit
        if self:GetBlueprint().Wreckage.WreckageLayers[self:GetCurrentLayer()] then
			self:CreateWreckageProp(overkillRatio)
        end
    end,

    CreateWreckageProp = function( self, overkillRatio )
		local bp = self:GetBlueprint()
		local wreck = bp.Wreckage.Blueprint
		if wreck then
			#LOG('*DEBUG: Spawning Wreckage = ', repr(wreck), 'overkill = ',repr(overkillRatio))
			local pos = self:GetPosition()
			local mass = bp.Economy.BuildCostMass * (bp.Wreckage.MassMult or 0)
			local energy = bp.Economy.BuildCostEnergy * (bp.Wreckage.EnergyMult or 0)
			local time = (bp.Wreckage.ReclaimTimeMultiplier or 1)
			if self:GetCurrentLayer() == 'Seabed' or self:GetCurrentLayer() == 'Land' then
			    pos[2] = GetTerrainHeight(pos[1], pos[3]) + GetTerrainTypeOffset(pos[1], pos[3])
			else
			    pos[2] = GetSurfaceHeight(pos[1], pos[3]) + GetTerrainTypeOffset(pos[1], pos[3])
			end

			local prop = CreateProp( pos, wreck )

			# We make sure keep only a bounded list of wreckages around so we don't get into perf issues when
			# we accumulate too many wreckages
			prop:AddBoundedProp(mass)

			prop:SetScale(bp.Display.UniformScale)
			prop:SetOrientation(self:GetOrientation(), true)
			prop:SetPropCollision('Box', bp.CollisionOffsetX, bp.CollisionOffsetY, bp.CollisionOffsetZ, bp.SizeX* 0.5, bp.SizeY* 0.5, bp.SizeZ * 0.5)
			prop:SetMaxReclaimValues(time, time, mass, energy)

			mass = (mass - (mass * (overkillRatio or 1))) * self:GetFractionComplete()
			energy = (energy - (energy * (overkillRatio or 1))) * self:GetFractionComplete()
			time = time - (time * (overkillRatio or 1))

			prop:SetReclaimValues(time, time, mass, energy)
			prop:SetMaxHealth(bp.Defense.Health)
			prop:SetHealth(self, bp.Defense.Health * (bp.Wreckage.HealthMult or 1))

			#FIXME: SetVizToNeurals('Intel') is correct here, so you can't see enemy wreckage appearing
			# under the fog. However the engine has a bug with prop intel that makes the wreckage
			# never appear at all, even when you drive up to it, so this is disabled for now.
			#prop:SetVizToNeutrals('Intel')
            if not bp.Wreckage.UseCustomMesh then
    	        prop:SetMesh(bp.Display.MeshBlueprintWrecked)
            end

            # Attempt to copy our animation pose to the prop. Only works if
            # the mesh and skeletons are the same, but will not produce an error
            # if not.
            TryCopyPose(self,prop,false)

            prop.AssociatedBP = self:GetBlueprint().BlueprintId

			# Create some ambient wreckage smoke
			explosion.CreateWreckageEffects(self,prop)

			return prop
	    else
	        return nil
		end
    end,

    CreateUnitDestructionDebris = function( self, high, low, chassis )
        #LOG('*DEBUG: CreateUnitDestructionDebris TOSSING HIGH = ', repr(high), ' LOW = ', repr(low), ' CHASSIS = ', repr(chassis))
        local HighDestructionParts = table.getn(self.DestructionPartsHighToss)
        local LowDestructionParts = table.getn(self.DestructionPartsLowToss)
        local ChassisDestructionParts = table.getn(self.DestructionPartsChassisToss)

        # Limit the number of parts that we throw out
        local HighPartLimit = HighDestructionParts
        local LowPartLimit = LowDestructionParts
        local ChassisPartLimit = ChassisDestructionParts

        # Create projectiles and accelerate them out and away from the unit
        if high and (HighDestructionParts > 0) then
            HighPartLimit = Random( 1, HighDestructionParts)
            for i = 1, HighPartLimit do
                self:ShowBone( self.DestructionPartsHighToss[i], false )
                boneProj = self:CreateProjectileAtBone('/effects/entities/DebrisBoneAttachHigh01/DebrisBoneAttachHigh01_proj.bp',self.DestructionPartsHighToss[i])
                self:AttachBoneToEntityBone(self.DestructionPartsHighToss[i],boneProj,-1,false)
                #explosion.CreateUnitDebrisEffects( self, self.DestructionPartsHighToss[i] )
            end
        end
        if low and (LowDestructionParts > 0) then
            LowPartLimit = Random( 1, LowDestructionParts)
            #LOG('*DEBUG: CreateUnitDestructionDebris Parts', repr(self.DestructionPartsLowToss))
            #LOG('*DEBUG: CreateUnitDestructionDebris LowPartLimit ', repr(LowPartLimit))
            for i = 1, LowPartLimit do
                self:ShowBone( self.DestructionPartsLowToss[i], false )
                boneProj = self:CreateProjectileAtBone('/effects/entities/DebrisBoneAttachLow01/DebrisBoneAttachLow01_proj.bp',self.DestructionPartsLowToss[i])
                self:AttachBoneToEntityBone(self.DestructionPartsLowToss[i],boneProj,-1,false)
                #explosion.CreateUnitDebrisEffects( self, self.DestructionPartsLowToss[i] )
            end
        end
        if chassis and (ChassisDestructionParts > 0) then
            ChassisPartLimit = Random( 1, ChassisDestructionParts)
            for i = 1, Random( 1, ChassisDestructionParts) do
                self:ShowBone( self.DestructionPartsChassisToss[i], false )
                boneProj = self:CreateProjectileAtBone('/effects/entities/DebrisBoneAttachChassis01/DebrisBoneAttachChassis01_proj.bp',self.DestructionPartsChassisToss[i])
                self:AttachBoneToEntityBone(self.DestructionPartsChassisToss[i],boneProj,-1,false)
                #explosion.CreateUnitDebrisEffects( self, self.DestructionPartsChassisToss[i] )
            end
        end
    end,

    CreateDestructionEffects = function( self, overKillRatio )
        explosion.CreateScalableUnitExplosion( self, overKillRatio )
    end,

    DeathWeaponDamageThread = function( self , damageRadius, damage, damageType, damageFriendly)
        WaitSeconds( 0.1 )
        DamageArea(self, self:GetPosition(), damageRadius or 1, damage or 1, damageType or 'Normal', damageFriendly or false)
    end,

    DeathThread = function( self, overkillRatio, instigator)

        #LOG('*DEBUG: OVERKILL RATIO = ', repr(overkillRatio))

        WaitSeconds( utilities.GetRandomFloat( self.DestructionExplosionWaitDelayMin, self.DestructionExplosionWaitDelayMax) )
        self:DestroyAllDamageEffects()

        if self.PlayDestructionEffects then
            self:CreateDestructionEffects( self, overkillRatio )
        end

        #MetaImpact( self, self:GetPosition(), 0.1, 0.5 )
        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
            if self.PlayDestructionEffects and self.PlayEndAnimDestructionEffects then
                self:CreateDestructionEffects( self, overkillRatio )
            end
        end

        self:CreateWreckage( overkillRatio )

        # CURRENTLY DISABLED UNTIL DESTRUCTION
        # Create destruction debris out of the mesh, currently these projectiles look like crap,
        # since projectile rotation and terrain collision doesn't work that great. These are left in
        # hopes that this will look better in the future.. =)
        if( self.ShowUnitDestructionDebris and overkillRatio ) then
            if overkillRatio <= 1 then
                self.CreateUnitDestructionDebris( self, true, true, false )
            elseif overkillRatio <= 2 then
                self.CreateUnitDestructionDebris( self, true, true, false )
            elseif overkillRatio <= 3 then
                self.CreateUnitDestructionDebris( self, true, true, true )
            else #VAPORIZED
                self.CreateUnitDestructionDebris( self, true, true, true )
            end
        end

        #LOG('*DEBUG: DeathThread Destroying in ',  self.DeathThreadDestructionWaitTime )
        WaitSeconds(self.DeathThreadDestructionWaitTime)

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,

    OnDestroy = function(self)
    
        self.Dead = true
    
        # Clear out our sync data
        UnitData[self:GetEntityId()] = false
        Sync.UnitData[self:GetEntityId()] = false

        # Don't allow anyone to stuff anything else in the table
        self.Sync = false

        # Let the user layer know this id is kaput
        Sync.ReleaseIds[self:GetEntityId()] = true

        #If factory, destory what I'm building if I die
        if EntityCategoryContains(categories.FACTORY, self) then
            if self.UnitBeingBuilt and not self.UnitBeingBuilt:IsDead() and self.UnitBeingBuilt:GetFractionComplete() != 1 then
                self.UnitBeingBuilt:Destroy()
            end
        end

        # destroy everything added to the trash
        #LOG('*DEBUG: Unit:OnDestroy')
        self.Trash:Destroy()
        if self.BuildEffectsBag then
            self.BuildEffectsBag:Destroy()
        end
        if self.CaptureEffectsBag then
			self.CaptureEffectsBag:Destroy()
		end
        if self.ReclaimEffectsBag then
			self.ReclaimEffectsBag:Destroy()
        end
        if self.OnBeingBuiltEffectsBag then
            self.OnBeingBuiltEffectsBag:Destroy()
        end
        if self.UpgradeEffectsBag then
            self.UpgradeEffectsBag:Destroy()
        end

        if self.TeleportDrain then
            RemoveEconomyEvent( self, self.TeleportDrain)
        end
        RemoveAllUnitEnhancements(self)
        ChangeState(self, self.DeadState)
    end,

    HideLandBones = function(self)
        #LOG( self:GetUnitId() .. " being built on layer '" .. self:GetCurrentLayer() .. "'" )
        #HIDE THE BONES FOR BUILDINGS BUILT ON LAND.
        if self.LandBuiltHiddenBones and self:GetCurrentLayer() == 'Land' then
            for k, v in self.LandBuiltHiddenBones do
                #LOG('*DEBUG: HIDING BONE = ', repr(v), ' BECAUSE IT IS BUILT ON LAND')
                if self:IsValidBone(v) then
                    self:HideBone(v, true)
                #else
                    #LOG('*WARNING: NOT HIDING BONE ', repr(v), ' BECAUSE IT IS INVALID ON UNIT ', repr(self:GetUnitId()))
                end
            end
        #else
            #LOG('*DEBUG: _NOT_ HIDING BONE = ', repr(v), ' BECAUSE IT IS BUILT ON ', self:GetCurrentLayer())
        end
    end,

    #GENERIC FUNCTION FOR SHOWING A TABLE OF BONES
    #TABLE = LIST OF BONES
    #CHILDREND = TRUE/FALSE TO SHOW CHILD BONES
    ShowBones = function(self, table, children)
        #LOG('*DEBUG: IN SHOWBONES TABLE = ', repr(table))
        for k, v in table do
            if self:IsValidBone(v) then
                self:ShowBone(v, children)
            else
                LOG('*WARNING: TRYING TO SHOW BONE ', repr(v), ' ON UNIT ',repr(self:GetUnitId()),' BUT IT DOES NOT EXIST IN THE MODEL. PLEASE CHECK YOUR SCRIPT IN THE BUILD PROGRESS BONES.')
            end
        end
    end,


    OnFerryPointSet = function(self)
        local bp = self:GetBlueprint().Audio
        if bp then
            local aiBrain = self:GetAIBrain()
            local factionIndex = aiBrain:GetFactionIndex()
            if factionIndex == 1 then
                if bp['FerryPointSetByUEF'] then
                    aiBrain:FerryPointSet(bp['FerryPointSetByUEF'])
                end
            elseif factionIndex == 2 then
                if bp['FerryPointSetByAeon'] then
                    aiBrain:FerryPointSet(bp['FerryPointSetByAeon'])
                end
            elseif factionIndex == 3 then
                if bp['FerryPointSetByCybran'] then
                    aiBrain:FerryPointSet(bp['FerryPointSetByCybran'])
                end
            end
        end
    end,

    OnDamageBy = function(self,index)
        local bp = self:GetBlueprint().Audio
        if bp then
            local aiBrain = self:GetAIBrain()
            local factionIndex = aiBrain:GetFactionIndex()
            if factionIndex == 1 then
                if bp['UnderAttackUEF'] then
                    aiBrain:UnderAttack(bp['UnderAttackUEF'])
                end
                if EntityCategoryContains(categories.STRUCTURE, self) then
                    if bp['BaseUnderAttackUEF'] then
                        aiBrain:BaseUnderAttack(bp['BaseUnderAttackUEF'])
                    end
                end
            elseif factionIndex == 2 then
                if bp['UnderAttackAeon'] then
                    aiBrain:UnderAttack(bp['UnderAttackAeon'])
                end
                if EntityCategoryContains(categories.STRUCTURE, self) then
                    if bp['BaseUnderAttackAeon'] then
                        aiBrain:BaseUnderAttack(bp['BaseUnderAttackAeon'])
                    end
                end
            elseif factionIndex == 3 then
                if bp['UnderAttackCybran'] then
                    aiBrain:UnderAttack(bp['UnderAttackCybran'])
                end
                if EntityCategoryContains(categories.STRUCTURE, self) then
                    if bp['BaseUnderAttackCybran'] then
                        aiBrain:BaseUnderAttack(bp['BaseUnderAttackCybran'])
                    end
                end
            end
        end
    end,

    OnNukeArmed = function(self)
        local bp = self:GetBlueprint().Audio
        if bp then
            local aiBrain = self:GetAIBrain()
            local factionIndex = aiBrain:GetFactionIndex()
            if factionIndex == 1 then
                if bp['NukeArmedUEF'] then
                    aiBrain:NukeArmed(bp['NukeArmedUEF'])
                end
            elseif factionIndex == 2 then
                if bp['NukeArmedAeon'] then
                    aiBrain:NukeArmed(bp['NukeArmedAeon'])
                end
            elseif factionIndex == 3 then
                if bp['NukeArmedCybran'] then
                    aiBrain:NukeArmed(bp['NukeArmedCybran'])
                end
            end
        end
    end,

    OnNukeLaunched = function(self)
    end,
    
    NukeCreatedAtUnit = function(self)
        if self:GetNukeSiloAmmoCount() <= 0 then
            return
        end
        local bp = self:GetBlueprint().Audio
        local unitBrain = self:GetAIBrain()
        if bp then
            for num, aiBrain in ArmyBrains do
                local factionIndex = aiBrain:GetFactionIndex()
                if unitBrain == aiBrain then
                    if bp['NuclearLaunchInitiated'] then
                        aiBrain:NuclearLaunchInitiated(bp['NuclearLaunchInitiated'])
                    end
                else
                    if bp['NuclearLaunchDetected'] then
                        aiBrain:NuclearLaunchDetected(bp['NuclearLaunchDetected'])
                    end
                end
            end
        end
    end,

    OnKilledVO = function(self)
        local bp = self:GetBlueprint().Audio
        if bp then
            for num, aiBrain in ArmyBrains do
                local factionIndex = aiBrain:GetFactionIndex()
                if factionIndex == 1 then
                    if bp['ExperimentalUnitDestroyedUEF'] then
                        aiBrain:ExperimentalUnitDestroyed(bp['ExperimentalUnitDestroyedUEF'])
                    elseif bp['BattleshipDestroyedUEF'] then
                        aiBrain:BattleshipDestroyed(bp['BattleshipDestroyedUEF'])
                    end
                elseif factionIndex == 2 then
                    if bp['ExperimentalUnitDestroyedAeon'] then
                        aiBrain:ExperimentalUnitDestroyed(bp['ExperimentalUnitDestroyedAeon'])
                    elseif bp['BattleshipDestroyedAeon'] then
                        aiBrain:BattleshipDestroyed(bp['BattleshipDestroyedAeon'])
                    end
                elseif factionIndex == 3 then
                    if bp['ExperimentalUnitDestroyedCybran'] then
                        aiBrain:ExperimentalUnitDestroyed(bp['ExperimentalUnitDestroyedCybran'])
                    elseif bp['BattleshipDestroyedCybran'] then
                        aiBrain:BattleshipDestroyed(bp['BattleshipDestroyedCybran'])
                    end
                end
            end
        end
    end,

    SetAllWeaponsEnabled = function(self, enable)
        for i = 1, self:GetWeaponCount() do
            local wep = self:GetWeapon(i)
            wep:SetWeaponEnabled(enable)
            wep:AimManipulatorSetEnabled(enable)
        end
    end,

    SetWeaponEnabledByLabel = function(self, label, enable)
        local wep = self:GetWeaponByLabel(label)
        if not wep then return end
        if not enable then
            wep:OnLostTarget()
        end
        wep:SetWeaponEnabled(enable)
        wep:AimManipulatorSetEnabled(enable)
    end,

    GetWeaponManipulatorByLabel = function(self, label)
        local wep = self:GetWeaponByLabel(label)
        return wep:GetAimManipulator()
    end,

    GetWeaponByLabel = function(self, label)
        local wep
        for i = 1, self:GetWeaponCount() do
            wep = self:GetWeapon(i)
            if (wep:GetBlueprint().Label == label) then
                return wep
            end
        end
        return nil
    end,

    ResetWeaponByLabel = function(self, label)
        local wep = self:GetWeaponByLabel(label)
        wep:ResetTarget()
    end,

    SetDeathWeaponEnabled = function(self, enable)
        self.DeathWeaponEnabled = enable
    end,

    #############################################################################################
    ## CONSTRUCTING - BEING BUILT
    #############################################################################################
    OnBeingBuiltProgress = function(self, unit, oldProg, newProg)
    end,

    OnStartBeingBuilt = function(self, builder, layer)
        self:StartBeingBuiltEffects(builder, layer)
        local aiBrain = self:GetAIBrain()
        if table.getn(aiBrain.UnitBuiltTriggerList) > 0 then
            for k,v in aiBrain.UnitBuiltTriggerList do
                if EntityCategoryContains(v.Category, self) then
                    self:ForkThread(self.UnitBuiltPercentageCallbackThread, v.Percent, v.Callback)
                end
            end
        end
    end,

    UnitBuiltPercentageCallbackThread = function(self, percent, callback)
        while not self:IsDead() and self:GetHealthPercent() < percent do
            WaitSeconds(1)
        end
        local aiBrain = self:GetAIBrain()
        for k,v in aiBrain.UnitBuiltTriggerList do
            if v.Callback == callback then
                callback(self)
                aiBrain.UnitBuiltTriggerList[k] = nil
            end
        end
    end,

    OnStopBeingBuilt = function(self, builder, layer)

        local bp = self:GetBlueprint()

        self:SetupIntel()

        self:ForkThread( self.StopBeingBuiltEffects, builder, layer )

        if ( self:GetCurrentLayer() == 'Water' ) then
            self:StartRocking()
            local surfaceAnim = self:GetBlueprint().Display.AnimationSurface
            if not self.SurfaceAnimator and surfaceAnim then
                self.SurfaceAnimator = CreateAnimator(self)
            end
            if surfaceAnim and self.SurfaceAnimator then
                self.SurfaceAnimator:PlayAnim(surfaceAnim):SetRate(1)
            end
        end

        if bp.Defense.LifeTime then
            self:ForkThread(self.LifeTimeThread)
        end

        self:PlayUnitSound('DoneBeingBuilt')

        self:PlayUnitAmbientSound( 'ActiveLoop' )

        if self.DisallowCollisions and builder then
            self.DisallowCollisions = false
            local healthPercentage = builder:GetHealthPercent()
            local newHealthAmount = healthPercentage * self:GetBlueprint().Defense.MaxHealth
            self:SetHealth(self, newHealthAmount)
        end

        # Turn off land bones if this unit has them.
        self:HideLandBones()
        self:DoUnitCallbacks('OnStopBeingBuilt')

        # Create any idle effects on unit
        if( table.getn( self.IdleEffectsBag ) == 0) then
            self:CreateIdleEffects()
        end

        # If we have a shield spec'd create it.
        if bp.Defense.Shield.ShieldSize > 0 then
            if bp.Defense.Shield.StartOn != false then
                if bp.Defense.Shield.PersonalShield == true then
                    self:CreatePersonalShield()
                elseif bp.Defense.Shield.AntiArtilleryShield then
                    self:CreateAntiArtilleryShield()
                else
                    self:CreateShield()
                end
            end
        end

        if bp.Display.AnimationPermOpen then
            self.PermOpenAnimManipulator = CreateAnimator(self):PlayAnim(bp.Display.AnimationPermOpen)
            self.Trash:Add(self.PermOpenAnimManipulator)
        end

        # Initialize movement effects subsystems, idle effects, beam exhaust, and footfall manipulators
        local bpTable = bp.Display.MovementEffects
        if bpTable.Land or bpTable.Air or bpTable.Water or bpTable.Sub or bpTable.BeamExhaust then
            self.MovementEffectsExist = true
            if bpTable.BeamExhaust and (bpTable.BeamExhaust.Idle != false) then
                self:UpdateBeamExhaust( 'Idle' )
            end
            if not self.Footfalls and bpTable[layer].Footfall then
                #LOG('Creating Footfall Manips')
                self.Footfalls = self:CreateFootFallManipulators( bpTable[layer].Footfall )
            end
        else
            self.MovementEffectsExist = false
        end
    end,

    StartBeingBuiltEffects = function(self, builder, layer)
		local BuildMeshBp = self:GetBlueprint().Display.BuildMeshBlueprint
		if BuildMeshBp then
			self:SetMesh(self:GetBlueprint().Display.BuildMeshBlueprint, true)
		end
    end,

    StopBeingBuiltEffects = function(self, builder, layer)
        local bp = self:GetBlueprint().Display
        local useTerrainType = false
        if bp then
            if bp.TerrainMeshes then
                local bpTM = bp.TerrainMeshes
                local pos = self:GetPosition()
                local terrainType = GetTerrainType( pos[1], pos[3] )
                if bpTM[terrainType.Style] then
                    self:SetMesh(bpTM[terrainType.Style])
                    useTerrainType = true
                end
            end
            if not useTerrainType then
                self:SetMesh(bp.MeshBlueprint, true)
            end
        end
        self.OnBeingBuiltEffectsBag:Destroy()
    end,

    OnFailedToBeBuilt = function(self)
        self:Destroy()
    end,
    
    OnSiloBuildStart = function(self, weapon)
        self.SiloWeapon = weapon
        self.SiloProjectile = weapon:GetProjectileBlueprint()
    end,
    
    OnSiloBuildEnd = function(self, weapon)
        self.SiloWeapon = nil
        self.SiloProjectile = nil
    end,


    #############################################################################################
    ## CONSTRUCTING - BUILDING - REPAIR
    #############################################################################################
    SetupBuildBones = function(self)
        local bp = self:GetBlueprint()
        if not bp.General.BuildBones or
           not bp.General.BuildBones.YawBone or
           not bp.General.BuildBones.PitchBone or
           not bp.General.BuildBones.AimBone then
           return
        end
        # Syntactical reference:
        #CreateBuilderArmController(unit,turretBone, [barrelBone], [aimBone])
        #BuilderArmManipulator:SetAimingArc(minHeading, maxHeading, headingMaxSlew, minPitch, maxPitch, pitchMaxSlew)
        self.BuildArmManipulator = CreateBuilderArmController(self, bp.General.BuildBones.YawBone or 0 , bp.General.BuildBones.PitchBone or 0, bp.General.BuildBones.AimBone or 0)
        self.BuildArmManipulator:SetAimingArc(-180, 180, 360, -90, 90, 360)
        self.BuildArmManipulator:SetPrecedence(5)
        if self.BuildingOpenAnimManip and self.BuildArmManipulator then
            self.BuildArmManipulator:Disable()
        end
        self.Trash:Add(self.BuildArmManipulator)
    end,

    BuildManipulatorSetEnabled = function(self, enable)
        if self:IsDead() or not self.BuildArmManipulator then return end
        if enable then
            self.BuildArmManipulator:Enable()
        else
            self.BuildArmManipulator:Disable()
        end
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
		if order == 'Repair' and unitBeingBuilt.WorkItem != self.WorkItem then
			self:InheritWork(unitBeingBuilt)
		end
        local bp = self:GetBlueprint()
        if order != 'Upgrade' or bp.Display.ShowBuildEffectsDuringUpgrade then
            self:StartBuildingEffects(unitBeingBuilt, order)
        end
        self:DoOnStartBuildCallbacks(unitBeingBuilt)
        self:SetActiveConsumptionActive()
        self:PlayUnitSound('Construct')
        self:PlayUnitAmbientSound('ConstructLoop')
        if bp.General.UpgradesTo and unitBeingBuilt:GetUnitId() == bp.General.UpgradesTo and order == 'Upgrade' then
            unitBeingBuilt.DisallowCollisions = true
        end
        
        if unitBeingBuilt:GetBlueprint().Physics.FlattenSkirt and not unitBeingBuilt:HasTarmac() then
            if self.TarmacBag and self:HasTarmac() then
                unitBeingBuilt:CreateTarmac(true, true, true, self.TarmacBag.Orientation, self.TarmacBag.CurrentBP )
            else
                unitBeingBuilt:CreateTarmac(true, true, true, false, false)
            end
        end           
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        self:StopBuildingEffects(unitBeingBuilt)
        self:SetActiveConsumptionInactive()
        self:DoOnUnitBuiltCallbacks(unitBeingBuilt)
        self:StopUnitAmbientSound('ConstructLoop')
        self:PlayUnitSound('ConstructStop')
    end,

    GetUnitBeingBuilt = function(self)
        return self.UnitBeingBuilt
    end,

    OnFailedToBuild = function(self)
        self:DoOnFailedToBuildCallbacks()
        self:SetActiveConsumptionInactive()
        self:StopUnitAmbientSound('ConstructLoop')
    end,

    OnPrepareArmToBuild = function(self)
    end,

    OnStartBuilderTracking = function(self)
    end,

    OnStopBuilderTracking = function(self)
    end,

    OnBuildProgress = function(self, unit, oldProg, newProg)
    end,

    StartBuildingEffects = function(self, unitBeingBuilt, order)
        self.BuildEffectsBag:Add( self:ForkThread( self.CreateBuildEffects, unitBeingBuilt, order ) )
    end,

    CreateBuildEffects = function( self, unitBeingBuilt, order )
    end,

    StopBuildingEffects = function(self, unitBeingBuilt)
        self.BuildEffectsBag:Destroy()
    end,

    OnStartSacrifice = function(self, target_unit)
		EffectUtilities.PlaySacrificingEffects(self,target_unit)
    end,

    OnStopSacrifice = function(self, target_unit)
		EffectUtilities.PlaySacrificeEffects(self,target_unit)
        self:SetDeathWeaponEnabled(false)
        self:Destroy()
    end,

    ##########################################################################################
    ## INTEL
    ##########################################################################################
    #Setup the initial intelligence of the unit.  Return true if it can, false if it can't.
    SetupIntel = function(self)
        local bp = self:GetBlueprint().Intel
        self:EnableIntel('Vision')
        if bp then
            self.IntelDisables = {
                Radar = 1,
                Sonar = 1,
                Omni = 1,
                RadarStealth = 1,
                SonarStealth = 1,
                RadarStealthField = 1,
                SonarStealthField = 1,
                Cloak = 1,
                CloakField = 1,
                Spoof = 1,
                Jammer = 1,
            }
            self:EnableUnitIntel(nil)
            return true
        end
        return false
    end,

    DisableUnitIntel = function(self, intel)
		local intDisabled = false
        if not self.IntelDisables then return end
        if intel then
            self.IntelDisables[intel] = self.IntelDisables[intel] + 1
            if self.IntelDisables[intel] == 1 then
				#LOG('*DEBUG: Disabling Intel: ', repr(intel))
				self:DisableIntel(intel)
				intDisabled = true
			end
        else
            for k, v in self.IntelDisables do
                self.IntelDisables[k] = v + 1
                if self.IntelDisables[k] == 1 then
                    #LOG('*DEBUG: Disabling Intel: ', repr(k))
                    self:DisableIntel(k)
                    intDisabled = true
                end
            end
        end       
        if intDisabled then
			self:OnIntelDisabled()
		end
    end,

    EnableUnitIntel = function(self, intel)
        local layer = self:GetCurrentLayer()
        local bp = self:GetBlueprint()
        local intEnabled = false
        if layer == 'Seabed' or layer == 'Sub' or layer == 'Water' then
            self:EnableIntel('WaterVision')
        end
        if intel then
            if self.IntelDisables[intel] == 1 then
                self:EnableIntel(intel)
                #LOG('*DEBUG: Enabling Intel: ', repr(intel))
                intEnabled = true
            end
            self.IntelDisables[intel] = self.IntelDisables[intel] - 1
        else
            for k, v in self.IntelDisables do
                if v == 1 then
                    self:EnableIntel(k)
                    #LOG('*DEBUG: Enabling Intel: ', repr(k))
                    if self:IsIntelEnabled(k) then
                        intEnabled = true
                    end
                end
                self.IntelDisables[k] = v - 1
            end
        end

        if not self.IntelThread then
            self.IntelThread = self:ForkThread(self.IntelWatchThread)
        end  
      
        if intEnabled then
            self:OnIntelEnabled()
        end
    end,

    OnIntelEnabled = function(self)

    end,

    OnIntelDisabled = function(self)

    end,

    ShouldWatchIntel = function(self)
        if self:GetBlueprint().Intel.FreeIntel then
            return false
        end
        local bpVal = self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy
        # check enhancements
        if not bpVal or bpVal <= 0 then
            local enh = self:GetBlueprint().Enhancements
            if enh then
                for k,v in enh do
                    if self:HasEnhancement(k) and v.MaintenanceConsumptionPerSecondEnergy and v.MaintenanceConsumptionPerSecondEnergy > 0 then
                        bpVal = v.MaintenanceConsumptionPerSecondEnergy
                        break
                    end
                end
            end
        end
        local watchPower = false
        if bpVal and bpVal > 0 then    
            local intelTypeTbl = {'JamRadius', 'SpoofRadius'}
            local intelTypeBool = {'RadarStealth', 'SonarStealth', 'Cloak'}
            local intelTypeNum = {'RadarRadius', 'SonarRadius', 'OmniRadius', 'RadarStealthFieldRadius', 'SonarStealthFieldRadius', 'CloakFieldRadius', }
            local bpInt = self:GetBlueprint().Intel
            if bpInt then
                for k, v in intelTypeTbl do
                    for ki, vi in bpInt[v] do
                        if vi > 0 then
                            watchPower = true
                            break
                        end
                    end
                    if watchPower then break end
                end
                for k,v in intelTypeBool do
                    if bpInt[v] then
                        watchPower = true
                        break
                    end
                end
                for k,v in intelTypeNum do
                    if bpInt[v] > 0 then
                        watchPower = true
                        break
                    end
                end
            end
        end        
        return watchPower    
    end,


    #Watch the economy.  If this unit doesn't get all it needs, shut off the intel.
    IntelWatchThread = function(self)
        local bp = self:GetBlueprint()
        while self:ShouldWatchIntel() do
            WaitSeconds(0.5)
            local fraction = self:GetResourceConsumed()
            while fraction == 1 do
                WaitSeconds(0.5)
                fraction = self:GetResourceConsumed()
            end
            self:DisableUnitIntel(nil)
            local recharge = bp.Intel.ReactivateTime or 10
            WaitSeconds(recharge)
            self:EnableUnitIntel(nil)
        end
        if self.IntelThread then 
            self.IntelThread = nil
        end
    end,

    AddDetectedByHook = function(self,hook)
        if not self.DetectedByHooks then
            self.DetectedByHooks = {}
        end
        table.insert(self.DetectedByHooks,hook)
    end,

    RemoveDetectedByHook = function(self,hook)
        if self.DetectedByHooks then
            for k,v in self.DetectedByHooks do
                if v == hook then
                    table.remove(self.DetectedByHooks,k)
                    return
                end
            end
        end
    end,

    OnDetectedBy = function(self, index)
        if self.DetectedByHooks then
            for k,v in self.DetectedByHooks do
                v(self,index)
            end
        end

        local bp = self:GetBlueprint().Audio
        if bp then
            local aiBrain = ArmyBrains[index]
            local factionIndex = aiBrain:GetFactionIndex()
            if factionIndex == 1 then
                if bp['ExperimentalDetectedByUEF'] then
                    aiBrain:ExperimentalDetected(bp['ExperimentalDetectedByUEF'])
                elseif bp['EnemyForcesDetectedByUEF'] then
                    aiBrain:EnemyForcesDetected(bp['EnemyForcesDetectedByUEF'])
                end
            elseif factionIndex == 2 then
                if bp['ExperimentalDetectedByAeon'] then
                    aiBrain:ExperimentalDetected(bp['ExperimentalDetectedByAeon'])
                elseif bp['EnemyForcesDetectedByAeon'] then
                    aiBrain:EnemyForcesDetected(bp['EnemyForcesDetectedByAeon'])
                end
            elseif factionIndex == 3 then
                if bp['ExperimentalDetectedByCybran'] then
                    aiBrain:ExperimentalDetected(bp['ExperimentalDetectedByCybran'])
                elseif bp['EnemyForcesDetectedByCybran'] then
                    aiBrain:EnemyForcesDetected(bp['EnemyForcesDetectedByCybran'])
                end
            end
        end
    end,


    ##########################################################################################
    ## GENERIC WORK
    ##########################################################################################

    InheritWork = function(self, target)
        self.WorkItem = target.WorkItem
        self.WorkItemBuildCostEnergy = target.WorkItemBuildCostEnergy
        self.WorkItemBuildCostMass = target.WorkItemBuildCostMass
        self.WorkItemBuildTime = target.WorkItemBuildTime
    end,

    ClearWork = function(self)
        self.WorkItem = nil
        self.WorkItemBuildCostEnergy = nil
        self.WorkItemBuildCostMass = nil
        self.WorkItemBuildTime = nil
    end,

    OnWorkBegin = function(self, work)
        local unitEnhancements = import('/lua/enhancementcommon.lua').GetEnhancements(self:GetEntityId())
        local tempEnhanceBp = self:GetBlueprint().Enhancements[work]
        if tempEnhanceBp.Prerequisite then
            if unitEnhancements[tempEnhanceBp.Slot] != tempEnhanceBp.Prerequisite then
                error('*ERROR: Ordered enhancement does not have the proper prereq!', 2)
                return false
            end
        elseif unitEnhancements[tempEnhanceBp.Slot] then
            error('*ERROR: Ordered enhancement does not have the proper slot available!', 2)
            return false
        end
        self.WorkItem = tempEnhanceBp
        self.WorkItemBuildCostEnergy = tempEnhanceBp.BuildCostEnergy
        self.WorkItemBuildCostMass = tempEnhanceBp.BuildCostEnergy
        self.WorkItemBuildTime = tempEnhanceBp.BuildTime
        self.WorkProgress = 0
        self:SetActiveConsumptionActive()
        self:PlayUnitSound('EnhanceStart')
        self:PlayUnitAmbientSound('EnhanceLoop')
        self:UpdateConsumptionValues()
        self:CreateEnhancementEffects(work)
        ChangeState(self,self.WorkingState)
    end,

    OnWorkEnd = function(self, work)
        self:SetActiveConsumptionInactive()
        self:PlayUnitSound('EnhanceEnd')
        self:StopUnitAmbientSound('EnhanceLoop')
        self:CleanupEnhancementEffects()
    end,

    OnWorkFail = function(self, work)
        self:SetActiveConsumptionInactive()
        self:PlayUnitSound('EnhanceFail')
        self:StopUnitAmbientSound('EnhanceLoop')
        self:ClearWork()
        self:CleanupEnhancementEffects()
    end,

    CreateEnhancement = function(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then
            error('*ERROR: Got CreateEnhancement call with an enhancement that doesnt exist in the blueprint.', 2)
            return false
        end
        if bp.ShowBones then
            for k, v in bp.ShowBones do
                if self:IsValidBone(v) then
                    self:ShowBone(v, true)
                end
            end
        end
        if bp.HideBones then
            for k, v in bp.HideBones do
                if self:IsValidBone(v) then
                    self:HideBone(v, true)
                end
            end
        end
        AddUnitEnhancement(self, enh, bp.Slot or '')
        if bp.RemoveEnhancements then
            for k, v in bp.RemoveEnhancements do
                RemoveUnitEnhancement(self, v)
            end
        end
        self:RequestRefreshUI()
    end,

    CreateEnhancementEffects = function( self, enhancement )
        local bp = self:GetBlueprint().Enhancements[enhancement]
        if bp.UpgradeEffectBones then
            for k, v in bp.UpgradeEffectBones do
                if self:IsValidBone(v) then
                    EffectUtilities.CreateEnhancementEffectAtBone(self, v, self.UpgradeEffectsBag )
                end
            end
        end
        if bp.UpgradeUnitAmbientBones then
            for k, v in bp.UpgradeUnitAmbientBones do
                if self:IsValidBone(v) then
                    EffectUtilities.CreateEnhancementUnitAmbient(self, v, self.UpgradeEffectsBag )
                end
            end
        end
    end,

    CleanupEnhancementEffects = function( self )
        self.UpgradeEffectsBag:Destroy()
    end,

    HasEnhancement = function(self, enh)
        local entId = self:GetEntityId()
        local unitEnh = SimUnitEnhancements[entId]
        if unitEnh then
            for k,v in unitEnh do
                if v == enh then
                    return true
                end
            end
        end
        return false
    end,


    ##########################################################################################
    ##
    ##########################################################################################

    OnLayerChange = function(self, new, old)
        #LOG('LayerChange old=',old,' new=',new,' for ',self:GetBlueprint().BlueprintId )
        for i = 1, self:GetWeaponCount() do
            self:GetWeapon(i):SetValidTargetsForCurrentLayer(new)
        end

        if old == 'Seabed' and new == 'Land' then
            self:EnableIntel('Vision')
                self:DisableIntel('WaterVision')
        elseif old == 'Land' and new == 'Seabed' then
                self:EnableIntel('WaterVision')
            end

        if( new == 'Land' ) then
            self:PlayUnitSound('TransitionLand')
            self:PlayUnitAmbientSound('AmbientMoveLand')
        elseif(( new == 'Water' ) or ( new == 'Seabed' )) then
            self:PlayUnitSound('TransitionWater')
            self:PlayUnitAmbientSound('AmbientMoveWater')
        elseif ( new == 'Sub' ) then
            self:PlayUnitAmbientSound('AmbientMoveSub')
        end

        local bpTable = self:GetBlueprint().Display.MovementEffects

        if not self.Footfalls and bpTable[new].Footfall then
            self.Footfalls = self:CreateFootFallManipulators( bpTable[new].Footfall )
        end

        self:CreateLayerChangeEffects( new, old )
    end,

    OnMotionHorzEventChange = function( self, new, old )
        if self:IsDead() then
            return
        end
        local layer = self:GetCurrentLayer()
        #LOG( 'OnMotionHorzEventChange, unit=', repr(self:GetBlueprint().BlueprintId), ' old = ', old, ', new = ', new, ', layer = ', self:GetCurrentLayer() )

        if ( old == 'Stopped' or (old == 'Stopping' and (new == 'Cruise' or new == 'TopSpeed'))) then
            # This will play the first appropriate StartMove sound that it finds
            if not (
                ((self:GetCurrentLayer() == 'Water') and self:PlayUnitSound('StartMoveWater')) or
                ((self:GetCurrentLayer() == 'Sub') and self:PlayUnitAmbientSound('StartMoveSub')) or
                ((self:GetCurrentLayer() == 'Land') and self:PlayUnitSound('StartMoveLand')) or
                ((self:GetCurrentLayer() == 'Air') and self:PlayUnitSound('StartMoveAir'))
                )
            then
                self:PlayUnitSound('StartMove')
            end

            # Initiate the unit's ambient movement sound
            # Note that there is not currently an 'Air' version, and that
            # AmbientMoveWater plays if the unit is in either the Water or Seabed layer.
            if not (
                (((self:GetCurrentLayer() == 'Water') or (self:GetCurrentLayer() == 'Seabed')) and self:PlayUnitAmbientSound('AmbientMoveWater')) or
                ((self:GetCurrentLayer() == 'Sub') and self:PlayUnitAmbientSound('AmbientMoveSub')) or 
                ((self:GetCurrentLayer() == 'Land') and self:PlayUnitAmbientSound('AmbientMoveLand'))
                )
            then
                self:PlayUnitAmbientSound('AmbientMove')
            end

            self:StopRocking()
        end

        if ((new == 'Stopped' or new == 'Stopping') and (old == 'Cruise' or old == 'TopSpeed')) then
            # This will play the first appropriate StopMove sound that it finds
            if not (
                ((self:GetCurrentLayer() == 'Water') and self:PlayUnitSound('StopMoveWater')) or
                ((self:GetCurrentLayer() == 'Sub') and self:PlayUnitSound('StopMoveSub')) or
                ((self:GetCurrentLayer() == 'Land') and self:PlayUnitSound('StopMoveLand')) or
                ((self:GetCurrentLayer() == 'Air') and self:PlayUnitSound('StopMoveAir'))
                )
            then
                self:PlayUnitSound('StopMove')
            end

            # Units in the water will rock back and forth a bit
            if ( self:GetCurrentLayer() == 'Water' ) then
                self:StartRocking()
            end
        end

        if( new == 'Stopped' or new == 'Stopping' ) then
            # Stop ambient sounds
            self:StopUnitAmbientSound( 'AmbientMove' )
            self:StopUnitAmbientSound( 'AmbientMoveWater' )
            self:StopUnitAmbientSound( 'AmbientMoveSub' )
            self:StopUnitAmbientSound( 'AmbientMoveLand' )
        end

        if self.MovementEffectsExist then
            self:UpdateMovementEffectsOnMotionEventChange( new, old )
        end

        if old == 'Stopped' then
            self:DoOnHorizontalStartMoveCallbacks()
        end
        for i = 1, self:GetWeaponCount() do
            local wep = self:GetWeapon(i)
            wep:OnMotionHorzEventChange(new, old)
        end
    end,

    OnMotionVertEventChange = function( self, new, old )
        if self:IsDead() then
            return
        end
        local layer = self:GetCurrentLayer()

        #LOG( 'OnMotionVertEventChange, unit=', repr(self:GetBlueprint().BlueprintId), ' old = ', old, ', new = ', new, ', layer = ', self:GetCurrentLayer() )
        if (new == 'Down') then
            # Play the "landing" sound
            self:PlayUnitSound('Landing')
        elseif (new == 'Bottom') or (new == 'Hover') then
            # Play the "landed" sound
            self:PlayUnitSound('Landed')
        elseif (new == 'Up' or ( new == 'Top' and ( old == 'Down' or old == 'Bottom' ))) then
            # Play the "takeoff" sound
            self:PlayUnitSound('TakeOff')
        end

        # Adjust any beam exhaust
        if new == 'Bottom' then
            self:UpdateBeamExhaust('Landed')
        elseif old == 'Bottom' then
            self:UpdateBeamExhaust('Cruise')
        end

        # Surfacing and sinking, landing and take off idle effects
        if (new == 'Up' and old == 'Bottom') or
           (new == 'Down' and old == 'Top') then
            self:DestroyIdleEffects()
            if new == 'Up' and layer == 'Sub' then
                self:PlayUnitSound('SurfaceStart')
            end
            if new == 'Down' and layer == 'Water' then
                self:PlayUnitSound('SubmergeStart')
                if self.SurfaceAnimator then
                    self.SurfaceAnimator:SetRate(-1)
                end
            end
        end

        if (new == 'Top' and old == 'Up') or
           (new == 'Bottom' and old == 'Down') then
            self:CreateIdleEffects()
            if new == 'Bottom' and layer == 'Sub' then
                self:PlayUnitSound('SubmergeEnd')
            end
            if new == 'Top' and layer == 'Water' then
                self:PlayUnitSound('SurfaceEnd')
                local surfaceAnim = self:GetBlueprint().Display.AnimationSurface
                if not self.SurfaceAnimator and surfaceAnim then
                    self.SurfaceAnimator = CreateAnimator(self)
                end
                if surfaceAnim and self.SurfaceAnimator then
                    self.SurfaceAnimator:PlayAnim(surfaceAnim):SetRate(1)
                end
            end
        end

        self:CreateMotionChangeEffects(new,old)
    end,

    OnMotionTurnEventChange = function(self, newEvent, oldEvent)
        if self:IsDead() then
            return
        end

        if newEvent == 'Straight' then
            self:PlayUnitSound('MoveStraight')
        elseif newEvent == 'Turn' then
            self:PlayUnitSound('MoveTurn')
        elseif newEvent == 'SharpTurn' then
            self:PlayUnitSound('MoveSharpTurn')
        end
    end,

    OnTerrainTypeChange = function(self, new, old)
        #LOG('TerrainChange old=',repr(old.Description),' new=',repr(new.Description),' for ',self:GetBlueprint().BlueprintId)
        if self.MovementEffectsExist then
            self:DestroyMovementEffects()
            self:CreateMovementEffects( self.MovementEffectsBag, nil, new )
        end
    end,

    OnAnimCollision = function(self, bone, x, y, z)
        local layer = self:GetCurrentLayer()
        local bpTable = self:GetBlueprint().Display.MovementEffects

        if bpTable[layer].Footfall then
            bpTable = bpTable[layer].Footfall
            local effects = {}
            local scale = 1
            local offset = nil
            local army = self:GetArmy()
            local boneTable = nil

            if bpTable.Damage then
                local bpDamage = bpTable.Damage
                DamageArea(self, self:GetPosition(bone), bpDamage.Radius, bpDamage.Amount, bpDamage.Type, bpDamage.DamageFriendly )
            end

            if bpTable.CameraShake then
                local shake = bpTable.CameraShake
                self:ShakeCamera( shake.Radius, shake.MaxShakeEpicenter, shake.MinShakeAtRadius, shake.Interval )
            end

            for k, v in bpTable.Bones do
                if bone == v.FootBone then
                    boneTable = v
                    bone = v.FootBone
                    scale = boneTable.Scale or 1
                    offset = bone.Offset
                    if v.Type then
                        effects = self.GetTerrainTypeEffects( 'FXMovement', layer, self:GetPosition(v.FootBone), v.Type )
                    end
                    break
                end
            end

            if boneTable.Tread and self:GetTTTreadType(self:GetPosition(bone)) != 'None' then
                CreateSplatOnBone(self, boneTable.Tread.TreadOffset, 0, boneTable.Tread.TreadMarks, boneTable.Tread.TreadMarksSizeX, boneTable.Tread.TreadMarksSizeZ, 100, boneTable.Tread.TreadLifeTime or 15, army )
                local treadOffsetX = boneTable.Tread.TreadOffset[1]
                if x and x > 0 then
                    if layer != 'Seabed' then
                    self:PlayUnitSound('FootFallLeft')
                    else
                        self:PlayUnitSound('FootFallLeftSeabed')
                    end
                elseif x and x < 0 then
                    if layer != 'Seabed' then
                    self:PlayUnitSound('FootFallRight')
                    else
                        self:PlayUnitSound('FootFallRightSeabed')
                    end
                end
            end

            for k, v in effects do
                CreateEmitterAtBone(self, bone, army, v):ScaleEmitter(scale):OffsetEmitter(offset.x or 0,offset.y or 0,offset.z or 0)
            end
        end
        if layer != 'Seabed' then
            self:PlayUnitSound('FootFallGeneric')
        else
            self:PlayUnitSound('FootFallGenericSeabed')
        end
    end,

    UpdateMovementEffectsOnMotionEventChange = function( self, new, old )
        #LOG('UpdateMovementEffectsOnMotionEventChange ', new, ' ', old )
        local layer = self:GetCurrentLayer()
        local bpMTable = self:GetBlueprint().Display.MovementEffects

        if( old == 'TopSpeed' ) then
            # Destroy topspeed contrails, and exhaust effects
            self:DestroyTopSpeedEffects()
        end

        if new == 'TopSpeed' and self.HasFuel then
            if bpMTable[layer].Contrails and self.ContrailEffects then
                self:CreateContrails( bpMTable[layer].Contrails )
            end
            if bpMTable[layer].TopSpeedFX then
                self:CreateMovementEffects( self.TopSpeedEffectsBag, 'TopSpeed' )
            end
        end

        if (old == 'Stopped' and new != 'Stopping') or
           (old == 'Stopping' and new != 'Stopped') then
            self:DestroyIdleEffects()
            self:DestroyMovementEffects()
            self:CreateMovementEffects( self.MovementEffectsBag, nil )
            if bpMTable.BeamExhaust then
                self:UpdateBeamExhaust( 'Cruise' )
            end
            if self.Detector then
                self.Detector:Enable()
            end
        end

        if new == 'Stopped' then
            self:DestroyMovementEffects()
            self:DestroyIdleEffects()
            self:CreateIdleEffects()
            if bpMTable.BeamExhaust then
                self:UpdateBeamExhaust( 'Idle' )
            end
            if self.Detector then
                self.Detector:Disable()
            end
        end
    end,

    GetTTTreadType = function( self, pos )
        local TerrainType = GetTerrainType( pos.x,pos.z )
        return TerrainType.Treads or 'None'
    end,

    GetTerrainTypeEffects = function( FxType, layer, pos, type, typesuffix )
        local TerrainType

        # Get terrain type mapped to local position and if none defined use default
        if type then
            TerrainType = GetTerrainType( pos.x,pos.z )
        else
            TerrainType = GetTerrainType( -1, -1 )
            type = 'Default'
        end

        # Add in type suffix to type mask name
        if typesuffix then
            type = type .. typesuffix
        end

        # If our current masking is empty try and get the default layer effect
        if TerrainType[FxType][layer][type] == nil then
			TerrainType = GetTerrainType( -1, -1 )
		end

        #LOG( 'GetTerrainTypeEffects ', TerrainType.Name .. ' ' .. TerrainType.Description, ' ', layer, ' ', type )
        return TerrainType[FxType][layer][type] or {}
    end,

    CreateTerrainTypeEffects = function( self, effectTypeGroups, FxBlockType, FxBlockKey, TypeSuffix, EffectBag, TerrainType )
        local army = self:GetArmy()
        local pos = self:GetPosition()
        local effects = {}
        local emit = nil

        for kBG, vTypeGroup in effectTypeGroups do
            if TerrainType then
                effects = TerrainType[FxBlockType][FxBlockKey][vTypeGroup.Type] or {}
            else
                effects = self.GetTerrainTypeEffects( FxBlockType, FxBlockKey, pos, vTypeGroup.Type, TypeSuffix )
            end

            if not vTypeGroup.Bones or (vTypeGroup.Bones and (table.getn(vTypeGroup.Bones) == 0)) then
                LOG('*WARNING: No effect bones defined for layer group ',repr(self:GetUnitId()),', Add these to a table in Display.[EffectGroup].', self:GetCurrentLayer(), '.Effects { Bones ={} } in unit blueprint.' )
                continue
            end

            for kb, vBone in vTypeGroup.Bones do
                for ke, vEffect in effects do
                    emit = CreateAttachedEmitter(self,vBone,army,vEffect):ScaleEmitter(vTypeGroup.Scale or 1)
                    if vTypeGroup.Offset then
                        emit:OffsetEmitter(vTypeGroup.Offset[1] or 0, vTypeGroup.Offset[2] or 0,vTypeGroup.Offset[3] or 0)
                    end
                    if EffectBag then
                        table.insert( EffectBag, emit )
                    end
                end
            end
        end
    end,

    CreateIdleEffects = function( self )
        local layer = self:GetCurrentLayer()
        local bpTable = self:GetBlueprint().Display.IdleEffects
        if bpTable[layer] and bpTable[layer].Effects then
            self:CreateTerrainTypeEffects( bpTable[layer].Effects, 'FXIdle',  layer, nil, self.IdleEffectsBag )
        end
    end,

    CreateMovementEffects = function( self, EffectsBag, TypeSuffix, TerrainType )
        local layer = self:GetCurrentLayer()
        local bpTable = self:GetBlueprint().Display.MovementEffects

        if bpTable[layer] then
            bpTable = bpTable[layer]
            local effectTypeGroups = bpTable.Effects

            if bpTable.Treads then
                self:CreateTreads( bpTable.Treads )
            else
                self:RemoveScroller()
            end

            if (not effectTypeGroups or (effectTypeGroups and (table.getn(effectTypeGroups) == 0))) then
                if not self.Footfalls and bpTable.Footfall then
                    LOG('*WARNING: No movement effect groups defined for unit ',repr(self:GetUnitId()),', Effect groups with bone lists must be defined to play movement effects. Add these to the Display.MovementEffects', layer, '.Effects table in unit blueprint. ' )
                end
                return false
            end

            if bpTable.CameraShake then
                self.CamShakeT1 = self:ForkThread(self.MovementCameraShakeThread, bpTable.CameraShake )
            end

            self:CreateTerrainTypeEffects( effectTypeGroups, 'FXMovement', layer, TypeSuffix, EffectsBag, TerrainType )
        end
    end,

    CreateLayerChangeEffects = function( self, new, old )
        local key = old..new
        local bpTable = self:GetBlueprint().Display.LayerChangeEffects[key]

        if bpTable then
            self:CreateTerrainTypeEffects( bpTable.Effects, 'FXLayerChange', key )
        end
    end,

    CreateMotionChangeEffects = function( self, new, old )
        local key = self:GetCurrentLayer()..old..new
        local bpTable = self:GetBlueprint().Display.MotionChangeEffects[key]

        if bpTable then
            self:CreateTerrainTypeEffects( bpTable.Effects, 'FXMotionChange', key )
        end
    end,

    DestroyMovementEffects = function( self )
        local bpTable = self:GetBlueprint().Display.MovementEffects
        local layer = self:GetCurrentLayer()

        EffectUtilities.CleanupEffectBag(self,'MovementEffectsBag')

        # Cleanup any camera shake going on.
        if self.CamShakeT1 then
            KillThread( self.CamShakeT1 )
            local shake = bpTable[layer].CameraShake
            if shake and shake.Radius and shake.MaxShakeEpicenter and shake.MinShakeAtRadius then
                self:ShakeCamera( shake.Radius, shake.MaxShakeEpicenter * 0.25, shake.MinShakeAtRadius * 0.25, 1 )
            end
        end

        # Cleanup treads
        if self.TreadThreads then
            for k, v in self.TreadThreads do
                KillThread(v)
            end
            self.TreadThreads = {}
        end
        if bpTable[layer].Treads.ScrollTreads then
            self:RemoveScroller()
        end
    end,

    DestroyTopSpeedEffects = function( self )
        EffectUtilities.CleanupEffectBag(self,'TopSpeedEffectsBag')
    end,

    DestroyIdleEffects = function( self )
        EffectUtilities.CleanupEffectBag(self,'IdleEffectsBag')
    end,

    UpdateBeamExhaust = function( self, motionState )
        local bpTable = self:GetBlueprint().Display.MovementEffects.BeamExhaust
        if not bpTable then
            return false
        end

        if motionState == 'Idle' then
            if self.BeamExhaustCruise  then
                self:DestroyBeamExhaust()
            end
            if self.BeamExhaustIdle and (table.getn(self.BeamExhaustEffectsBag) == 0) and (bpTable.Idle != false) then
                self:CreateBeamExhaust( bpTable, self.BeamExhaustIdle )
            end
        elseif motionState == 'Cruise' then
            if self.BeamExhaustIdle and self.BeamExhaustCruise then
                self:DestroyBeamExhaust()
            end
            if self.BeamExhaustCruise and (bpTable.Cruise != false) then
                self:CreateBeamExhaust( bpTable, self.BeamExhaustCruise )
            end
        elseif motionState == 'Landed' then
            if not bpTable.Landed then
                self:DestroyBeamExhaust()
            end
        end
    end,

    CreateBeamExhaust = function( self, bpTable, beamBP )
        local effectBones = bpTable.Bones
        if not effectBones or (effectBones and (table.getn(effectBones) == 0)) then
            LOG('*WARNING: No beam exhaust effect bones defined for unit ',repr(self:GetUnitId()),', Effect Bones must be defined to play beam exhaust effects. Add these to the Display.MovementEffects.BeamExhaust.Bones table in unit blueprint.' )
            return false
        end
        local army = self:GetArmy()
        for kb, vb in effectBones do
            table.insert( self.BeamExhaustEffectsBag, CreateBeamEmitterOnEntity(self, vb, army, beamBP ))
        end
    end,

    DestroyBeamExhaust = function( self )
        EffectUtilities.CleanupEffectBag(self,'BeamExhaustEffectsBag')
    end,

    CreateContrails = function(self, tableData )
        local effectBones = tableData.Bones
        if not effectBones or (effectBones and (table.getn(effectBones) == 0)) then
            LOG('*WARNING: No contrail effect bones defined for unit ',repr(self:GetUnitId()),', Effect Bones must be defined to play contrail effects. Add these to the Display.MovementEffects.Air.Contrail.Bones table in unit blueprint. ' )
            return false
        end
        local army = self:GetArmy()
        local ZOffset = tableData.ZOffset or 0.0
        for ke, ve in self.ContrailEffects do
            for kb, vb in effectBones do
                table.insert(self.TopSpeedEffectsBag, CreateTrail(self,vb,army,ve):SetEmitterParam('POSITION_Z', ZOffset))
            end
        end
    end,

    MovementCameraShakeThread = function( self, camShake )
        local radius = camShake.Radius or 5.0
        local maxShakeEpicenter = camShake.MaxShakeEpicenter or 1.0
        local minShakeAtRadius = camShake.MinShakeAtRadius or 0.0
        local interval = camShake.Interval or 10.0
        if interval != 0.0 then
            while true do
                self:ShakeCamera( radius, maxShakeEpicenter, minShakeAtRadius, interval )
                WaitSeconds(interval)
            end
        end
    end,

    CreateTreads = function(self, treads)
        if treads.ScrollTreads then
            self:AddThreadScroller(1.0, treads.ScrollMultiplier or 0.2)
        end
        self.TreadThreads = {}
        if treads.TreadMarks then
            local type = self:GetTTTreadType(self:GetPosition())
            if type != 'None' then
                for k, v in treads.TreadMarks do
                    table.insert( self.TreadThreads, self:ForkThread(self.CreateTreadsThread, v, type ))
                end
            end
        end
    end,

    CreateTreadsThread = function(self, treads, type )
        local sizeX = treads.TreadMarksSizeX
        local sizeZ = treads.TreadMarksSizeZ
        local interval = treads.TreadMarksInterval
        local treadOffset = treads.TreadOffset
        local treadBone = treads.BoneName or 0
        local treadTexture = treads.TreadMarks
        local duration = treads.TreadLifeTime or 10
        local army = self:GetArmy()

        while true do
            # Syntatic reference
            # CreateSplatOnBone(entity, offset, boneName, textureName, sizeX, sizeZ, lodParam, duration, army)
            CreateSplatOnBone(self, treadOffset, treadBone, treadTexture, sizeX, sizeZ, 130, duration, army)
            WaitSeconds(interval)
        end
    end,

    CreateFootFallManipulators = function( self, footfall )
        if not footfall.Bones or (footfall.Bones and (table.getn(footfall.Bones) == 0)) then
            LOG('*WARNING: No footfall bones defined for unit ',repr(self:GetUnitId()),', ', 'these must be defined to animation collision detector and foot plant controller' )
            return false
        end

        self.Detector = CreateCollisionDetector(self)
        self.Trash:Add(self.Detector)
        for k, v in footfall.Bones do
            self.Detector:WatchBone(v.FootBone)
            if v.FootBone and v.KneeBone and v.HipBone then
                CreateFootPlantController(self, v.FootBone, v.KneeBone, v.HipBone, v.StraightLegs or true, v.MaxFootFall or 0):SetPrecedence(10)
            end
        end
        return true
    end,

    OnStartRefueling = function(self)
        self:PlayUnitSound('Refueling')
    end,

    OnRunOutOfFuel = function(self)
        self.HasFuel = false
        self:DestroyTopSpeedEffects()
    end,

    OnGotFuel = function(self)
        self.HasFuel = true
    end,

    GetWeaponClass = function(self, label)
        return self.Weapons[label] or import('/lua/sim/Weapon.lua').Weapon
    end,

    # Return the total time in seconds, cost in energy, and cost in mass to build the given target type.
    GetBuildCosts = function(self, target_bp)
        return Game.GetConstructEconomyModel(self, target_bp.Economy)
    end,

    SetReclaimTimeMultiplier = function(self, time_mult)
        self.ReclaimTimeMultiplier = time_mult
    end,

    # Return the total time in seconds, cost in energy, and cost in mass to reclaim the given target from 100%.
    # The energy and mass costs will normally be negative, to indicate that you gain mass/energy back.
    GetReclaimCosts = function(self, target_entity)
        local bp = self:GetBlueprint()
        local target_bp = target_entity:GetBlueprint()
        if IsUnit(target_entity) then
            #LOG('Reclaim Target Is Unit')

            local mtime = target_bp.Economy.BuildCostEnergy / self:GetBuildRate()
            local etime = target_bp.Economy.BuildCostMass / self:GetBuildRate()
            local time = mtime
            if mtime < etime then
                time = etime
            end
            
            time = time * (self.ReclaimTimeMultiplier or 1)
            return (time/10), target_bp.Economy.BuildCostEnergy, target_bp.Economy.BuildCostMass
        elseif IsProp(target_entity) then
            local time, energy, mass =  target_entity:GetReclaimCosts(self)
            #LOG('*DEBUG: Reclaiming a prop.  Time = ', repr(time), ' Mass = ', repr(mass), ' Energy = ', repr(energy))
            return time, energy, mass
        end
    end,

    # Return the Bonus Build Multiplier for the target we are re-building if we are trying to rebuild the same
    # structure that was destroyed earlier.
    GetRebuildBonus = function(self, rebuildUnitBP)
        # for now everything is re-built is 50% complete to begin with
        return 0.5
    end,

    SetCaptureTimeMultiplier = function(self, time_mult)
        self.CaptureTimeMultiplier = time_mult
    end,

    # Return the total time in seconds, cost in energy, and cost in mass to capture the given target.
    # Calculation given by Jake - 6/26/06
    GetCaptureCosts = function(self, target_entity)
        local target_bp = target_entity:GetBlueprint().Economy
        local bp = self:GetBlueprint().Economy

        local time = ((target_bp.BuildTime or 10) / self:GetBuildRate()) / 2
        local energy = target_bp.BuildCostEnergy or 100
        time = time * (self.CaptureTimeMultiplier or 1)

        return time, energy, 0
    end,

    GetHealthPercent = function(self)
        local health = self:GetHealth()
        local maxHealth = self:GetBlueprint().Defense.MaxHealth
        return health / maxHealth
    end,

    ValidateBone = function(self, bone)
        if self:IsValidBone(bone) then
            return true
        end
        error('*ERROR: Trying to use the bone, ' .. bone .. ' on unit ' .. self:GetUnitId() .. ' and it does not exist in the model.', 2)
        return false
    end,

    CheckBuildRestriction = function(self, target_bp)
        if self:CanBuild(target_bp.BlueprintId) then
            return true
        else
            return false
        end
    end,

    PlayUnitSound = function(self, sound)
        local bp = self:GetBlueprint().Audio
        if bp and bp[sound] then
            #LOG( 'Playing ', sound )
            self:PlaySound(bp[sound])
            return true
        end
        #LOG( 'Could not play ', sound )
        return false
    end,

    PlayUnitAmbientSound = function(self, sound)
        local bp = self:GetBlueprint()
        local id = bp.BlueprintId
        if not bp.Audio[sound] then return end
        if not self.AmbientSounds then
            self.AmbientSounds = {}
        end
        if not self.AmbientSounds[sound] then
            local sndEnt = Entity {}
            self.AmbientSounds[sound] = sndEnt
            self.Trash:Add(sndEnt)
            sndEnt:AttachTo(self,-1)
        end
        self.AmbientSounds[sound]:SetAmbientSound( bp.Audio[sound], nil )
    end,

    StopUnitAmbientSound = function(self, sound)
        local id = self:GetUnitId()
        if not self.AmbientSounds then return end
        if not self.AmbientSounds[sound] then return end
        self.AmbientSounds[sound]:SetAmbientSound(nil, nil)
        self.AmbientSounds[sound]:Destroy()
        self.AmbientSounds[sound] = nil
    end,

    ##########################################################################################
    ## UNIT CALLBACKS
    ##########################################################################################
    AddUnitCallback = function(self, fn, type)
        if not fn then
            error('*ERROR: Tried to add a callback type - ' .. type .. ' with a nil function')
            return
        end
        table.insert( self.EventCallbacks[type], fn )
    end,
    
    DoUnitCallbacks = function(self, type, param)
        if ( self.EventCallbacks[type] ) then
            for num,cb in self.EventCallbacks[type] do
                if cb then
                    cb( self, param )
                end
            end
        end
    end,


    AddProjectileDamagedCallback = function( self, fn )
        if not fn then
            error('*ERROR: tried to add a projectile damaged callback with a nil function')
            return
        end
        table.insert( self.EventCallbacks.ProjectileDamaged, fn )
    end,

    AddOnCapturedCallback = function(self, cbOldUnit, cbNewUnit)
        if not cbOldUnit and not cbNewUnit then
            error('*ERROR: Tried to add an OnCaptured callback without any functions', 2)
            return
        end
        if cbOldUnit then
            self:AddUnitCallback( cbOldUnit, 'OnCaptured' )
        end
        if cbNewUnit then
            self:AddUnitCallback( cbNewUnit, 'OnCapturedNewUnit' )
        end
    end,
    
    AddOnStartBuildCallback = function(self, fn, category)
        if not fn then
            error('*ERROR: Tried to add an OnStartBuild callback with a nil function')
            return
        end
        local insertedTable = {
                CallbackFunction = fn,
                Category = category
            }
        table.insert(self.EventCallbacks.OnStartBuild, insertedTable)
    end,
    
    DoOnStartBuildCallbacks = function(self, unit)
        for k,v in self.EventCallbacks.OnStartBuild do
            if v and unit and not unit:IsDead() and EntityCategoryContains(v.Category, unit) then
                v.CallbackFunction(self, unit)
            end
        end
    end,
           
    DoOnFailedToBuildCallbacks = function(self)
        if self.EventCallbacks.OnFailedToBuild then
            for k, cb in self.EventCallbacks.OnFailedToBuild do
                if cb then
                    cb(self)
                end
            end
        end
    end,

    AddOnUnitBuiltCallback = function(self, fn, category)
        if not fn then
            error('*ERROR: Tried to add an OnUnitBuilt callback with a nil function')
            return
        end
        local insertedTable = {
                CallBackFunction = fn,
                Category = category
            }
        table.insert(self.EventCallbacks.OnUnitBuilt, insertedTable)
        #LOG('*DEBUG: CALLBACK ADDED')
    end,

    DoOnUnitBuiltCallbacks = function(self, unit)
        #LOG('*DEBUG: CALLBACK FIRED')
        if self.EventCallbacks.OnUnitBuilt then
            for k, v in self.EventCallbacks.OnUnitBuilt do
                if v and unit and not unit:IsDead() and EntityCategoryContains(v.Category, unit) then
                    #LOG('*DEBUG: CALLBACK FIRED, RUNNING FUNCTION')
                    #Function will call back with both the unit's and the unit being built's handle
                    v.CallBackFunction(self, unit)
                end
            end
        end
    end,

    AddOnHorizontalStartMoveCallback = function(self, fn)
        if not fn then
            error('*ERROR: Tried to add an OnHorizontalMove callback with a nil function')
            return
        end
        table.insert(self.EventCallbacks.OnHorizontalStartMove, fn)
    end,

    DoOnHorizontalStartMoveCallbacks = function(self)
        if self.EventCallbacks.OnHorizontalStartMove then
            for k, cb in self.EventCallbacks.OnHorizontalStartMove do
                if cb then
                    cb(self)
                end
            end
        end
    end,

    RemoveCallback = function(self, fn)
        --EventCallbacks has "SpecialToggle(Enable/Disable)Function" booleans in it so skip over those.
        
        for k, v in self.EventCallbacks do
            if type(v) == "table" then
                for kcb, vcb in v do
                    if vcb == fn then
                        #LOG('*DEBUG: REMOVED TRIGGER ', repr(kcb))
                        v[kcb] = nil
                    end
                end
            end
        end
    end,

    AddOnDamagedCallback = function(self, fn, amount, repeatNum)
        if not fn then
            error('*ERROR: Tried to add an OnDamaged callback with a nil function')
            return
        end
        local num = amount or -1
        repeatNum = repeatNum or 1
        table.insert(self.EventCallbacks.OnDamaged, {Func=fn, Amount=num, Called=0, Repeat=repeatNum})
    end,

    DoOnDamagedCallbacks = function(self, instigator)
        if self.EventCallbacks.OnDamaged then
            for num, callback in self.EventCallbacks.OnDamaged do
                if (callback.Called < callback.Repeat or callback.Repeat == -1) and ( callback.Amount == -1 or (1 - self:GetHealthPercent() > callback.Amount) ) then
                    callback.Called = callback.Called + 1
                    callback.Func(self, instigator)
                end
            end
        end
    end,


    ##########################################################################################
    ## STATES
    ##########################################################################################

    IdleState = State {
        Main = function(self)
        end,
    },

    DeadState = State {
        Main = function(self)
        end,
    },

    WorkingState = State {
        Main = function(self)
            while self.WorkProgress < 1 and not self:IsDead() do
                WaitSeconds(0.1)
            end
        end,

        OnWorkEnd = function(self, work)
            self:SetActiveConsumptionInactive()
            AddUnitEnhancement(self, work)
            self:CleanupEnhancementEffects(work)
            self:CreateEnhancement(work)
            self.WorkItem = nil
            self.WorkItemBuildCostEnergy = nil
            self.WorkItemBuildCostMass = nil
            self.WorkItemBuildTime = nil
            self:PlayUnitSound('EnhanceEnd')
            self:StopUnitAmbientSound('EnhanceLoop')
            self:EnableDefaultToggleCaps()
            ChangeState(self, self.IdleState)
        end,
    },


    ##########################################################################################
    ## BUFFS
    ##########################################################################################

    AddBuff = function(self, buffTable, PosEntity)
        local bt = buffTable.BuffType

        if not bt then
            error('*ERROR: Tried to add a unit buff in unit.lua but got no buff table.  Wierd.', 1)
            return
        end
        #When adding debuffs we have to make sure that we check for permissions
        local allow = categories.ALLUNITS
        if buffTable.TargetAllow then
            allow = ParseEntityCategory(buffTable.TargetAllow)
        end
        local disallow
        if buffTable.TargetDisallow then
            disallow = ParseEntityCategory(buffTable.TargetDisallow)
        end

        if bt == 'STUN' then
           if buffTable.Radius and buffTable.Radius > 0 then
                #if the radius is bigger than 0 then we will use the unit as the center of the stun blast
                #and collect all targets from that point
                local targets = {}
                if PosEntity then
                    targets = utilities.GetEnemyUnitsInSphere(self, PosEntity, buffTable.Radius)
                else
                    targets = utilities.GetEnemyUnitsInSphere(self, self:GetPosition(), buffTable.Radius)
                end
                if not targets then
                    #LOG('*DEBUG: No targets in radius to buff')
                    return
                end
                for k, v in targets do
                    if EntityCategoryContains(allow, v) and (not disallow or not EntityCategoryContains(disallow, v)) then
                        v:SetStunned(buffTable.Duration or 1)
                    end
                end
            else
                #The buff will be applied to the unit only
                if EntityCategoryContains(allow, self) and (not disallow or not EntityCategoryContains(disallow, self)) then
                    self:SetStunned(buffTable.Duration or 1)
                end
            end
        elseif bt == 'MAXHEALTH' then
            self:SetMaxHealth(self:GetMaxHealth() + (buffTable.Value or 0))
        elseif bt == 'HEALTH' then
            self:SetHealth(self, self:GetHealth() + (buffTable.Value or 0))
        elseif bt == 'SPEEDMULT' then
            self:SetSpeedMult(buffTable.Value or 0)
        elseif bt == 'MAXFUEL' then
            self:SetFuelUseTime(buffTable.Value or 0)
        elseif bt == 'FUELRATIO' then
            self:SetFuelRatio(buffTable.Value or 0)
        elseif bt == 'HEALTHREGENRATE' then
            self:SetRegenRate(buffTable.Value or 0)
        end
    end,

    AddWeaponBuff = function(self, buffTable, weapon)
        local bt = buffTable.BuffType
        if not bt then
            error('*ERROR: Tried to add a weapon buff in unit.lua but got no buff table.  Wierd.', 1)
            return
        end
        if bt == 'RATEOFFIRE' then
            weapon:ChangeRateOfFire(buffTable.Value or 1)
        elseif bt == 'TURRETYAWSPEED' then
            weapon:SetTurretYawSpeed(buffTable.Value or 0)
        elseif bt == 'TURRETPITCHSPEED' then
            weapon:SetTurretPitchSpeed(buffTable.Value or 0)
        elseif bt == 'DAMAGE' then
            weapon:AddDamageMod(buffTable.Value or 0)
        elseif bt == 'MAXRADIUS' then
            weapon:ChangeMaxRadius(buffTable.Value or weapon:GetBlueprint().MaxRadius)
        elseif bt == 'FIRINGRANDOMNESS' then
            weapon:SetFiringRandomness(buffTable.Value or 0)
        else
            self:AddBuff(buffTable)
        end
    end,

    ##########################################################################################
    ## VETERANCY
    ##########################################################################################
    
    #This function should be used for kills made through the script, since kills through the engine (projectiles etc...) are already counted.
    AddKills = function(self, numKills)
        #Add the kills, then check veterancy junk.
        local unitKills = self:GetStat('KILLS', 0).Value + numKills
        self:SetStat('KILLS', unitKills)
        
        local vet = self:GetBlueprint().Veteran or Game.VeteranDefault
        
        local vetLevels = table.getsize(vet)
        if self.VeteranLevel == vetLevels then
            return
        end

        local nextLvl = self.VeteranLevel + 1
        local nextKills = vet[('Level' .. nextLvl)]
        
        #Since we could potentially be gaining a lot of kills here, check if we gained more than one level
        while unitKills >= nextKills and self.VeteranLevel ~= vetLevels do
            self:SetVeteranLevel(nextLvl)
            
            nextLvl = self.VeteranLevel + 1
            nextKills = vet[('Level' .. nextLvl)]
        end 
    end,

    # use this to go through the AddKills function rather than directly setting veterancy
    SetVeterancy = function(self, veteranLevel)
        veteranLevel = veteranLevel or 5
        if veteranLevel == 0 or veteranLevel > 5 then
            return
        end
        local bp = self:GetBlueprint()
        if bp.Veteran['Level'..veteranLevel] then
            self:AddKills(bp.Veteran['Level'..veteranLevel])
        elseif import('/lua/game.lua').VeteranDefault['Level'..veteranLevel] then
            self:AddKills(import('/lua/game.lua').VeteranDefault['Level'..veteranLevel])
        else
            error('Invalid veteran level - ' .. veteranLevel)
        end 
    end, 

    #Return the unit's current vet level
    GetVeteranLevel = function(self)
        return self.VeteranLevel
    end,


    #Check to see if we should veteran up.
    CheckVeteranLevel = function(self)
        local bp = self:GetBlueprint().Veteran
        #There is no veteran block in the bp, return
        if not bp then
            bp = Game.VeteranDefault
        end
        #LOG('*DEBUG: Vet Table = ', repr(bp))
        #We add 1 because we get this before the stat gets updated
        local unitKills = self:GetStat('KILLS', 0).Value + 1
        #LOG('*DEBUG: Veteran Kills = ', repr(unitKills))
        #We are already at the highest veteran level, return
        if self.VeteranLevel == table.getsize(bp) then
            return
        end

        local nextLvl = self.VeteranLevel + 1
        local nextKills = bp[('Level' .. nextLvl)]
        if unitKills >= nextKills then
            self:SetVeteranLevel(nextLvl)
        end
    end,

    #Set the veteran level to the level specified
    SetVeteranLevel = function(self, level)
        #LOG('*DEBUG: VETERAN UP! LEVEL ', repr(level))
        local old = self.VeteranLevel
        self.VeteranLevel = level

        # Apply default veterancy buffs
        local buffTypes = { 'Regen', 'Health', }
        for k,bType in buffTypes do
            Buff.ApplyBuff( self, 'Veterancy' .. bType .. level )
        end

        # Inform all weapons that have veteraned - Damage already defaulted increase
        # Each weapon can override the buff if desired
        
        # TODO: Enable per weapon buffs again
        #for i = 1, self:GetWeaponCount() do
            #local wep = self:GetWeapon(i)
            #wep:OnVeteranLevel(old, level)
        #end

        # Get any overriding buffs if they exist
        local bp = self:GetBlueprint().Buffs
        #Check for unit buffs
        if bp then
            for bType,bData in bp do
                for lName,lValue in bData do
                    if lName == 'Level'..level then
                        # Generate a buff based on the data paseed in
                        local buffName = self:CreateVeterancyBuff( lName, lValue, bType )
                        if buffName then
                            Buff.ApplyBuff( self, buffName )
                        end
                    end
                end
            end
        end
        self:GetAIBrain():OnBrainUnitVeterancyLevel(self, level)
        self:DoUnitCallbacks('OnVeteran')
    end,
    
    # Table housing data on what to use to generate buffs for a unit
    BuffTypes = {
        Regen = { BuffType = 'VETERANCYREGEN', BuffValFunction = 'Add', BuffDuration = -1, BuffStacks = 'REPLACE' },
        Health = { BuffType = 'VETERANCYHEALTH', BuffValFunction = 'Mult', BuffDuration = -1, BuffStacks = 'REPLACE' },
    },
    
    CreateVeterancyBuff = function(self, levelName, levelValue, buffType)
        if buffType == 'Damage' then
            return false
        end
    
        # Make sure there is an appropriate buff type for this unit
        if not self.BuffTypes[buffType] then
            WARN('*WARNING: Tried to generate a buff of unknown type to units: ' .. buffType .. ' - UnitId: ' .. self:GetUnitId() )
            return nil
        end
        
        # Generate a buff based on the unitId
        local buffName = self:GetUnitId() .. levelName .. buffType
        
        # Figure out what we want the Add and Mult values to be based on the BuffTypes table
        local addVal = 0
        local multVal = 1
        if self.BuffTypes[buffType].BuffValFunction == 'Add' then 
            addVal = levelValue
        else
            multVal = levelValue
        end
        
        # Create the buff if needed
        if not Buffs[buffName] then
            BuffBlueprint {
                Name = buffName,
                DisplayName = buffName,
                BuffType = self.BuffTypes[buffType].BuffType,
                Stacks = self.BuffTypes[buffType].BuffStacks,
                Duration = self.BuffTypes[buffType].BuffDuration,
                Affects = {
                    Regen = {
                        Add = addVal,
                        Mult = multVal,
                    },
                },
            }
        end
        
        # Return the buffname so the buff can be applied to the unit
        return buffName
    end,

    PlayVeteranFx = function(self, newLvl)
        #NOTE: Place vet FX here
        CreateAttachedEmitter(self, 0, self:GetArmy(), 'destruction_explosion_concussion_ring_03_emit.bp'):ScaleEmitter(1)
    end,

    ##########################################################################################
    ## SHIELDS
    ##########################################################################################
    CreateShield = function(self, shieldSpec)
        local bp = self:GetBlueprint()
        local bpShield = shieldSpec
        if not shieldSpec then
            bpShield = bp.Defense.Shield
        end
        if bpShield then
            self:DestroyShield()
            self.MyShield = Shield {
                Owner = self,
				Mesh = bpShield.Mesh or '',
				MeshZ = bpShield.MeshZ or '',
				ImpactMesh = bpShield.ImpactMesh or '',
				ImpactEffects = bpShield.ImpactEffects or '',    
                Size = bpShield.ShieldSize or 10,
                ShieldMaxHealth = bpShield.ShieldMaxHealth or 250,
                ShieldRechargeTime = bpShield.ShieldRechargeTime or 10,
                ShieldEnergyDrainRechargeTime = bpShield.ShieldEnergyDrainRechargeTime or 10,
                ShieldVerticalOffset = bpShield.ShieldVerticalOffset or -1,
                ShieldRegenRate = bpShield.ShieldRegenRate or 1,
                ShieldRegenStartTime = bpShield.ShieldRegenStartTime or 5,
                PassOverkillDamage = bpShield.PassOverkillDamage or false,
            }
            self:SetFocusEntity(self.MyShield)
            self:EnableShield()
            self.Trash:Add(self.MyShield)
        end
    end,

    CreatePersonalShield = function(self, shieldSpec)
        local bp = self:GetBlueprint()
        local bpShield = shieldSpec
        if not shieldSpec then
            bpShield = bp.Defense.Shield
        end
        if bpShield then
            self:DestroyShield()
            if bpShield.OwnerShieldMesh then
                self.MyShield = UnitShield {
                    Owner = self,
					ImpactEffects = bpShield.ImpactEffects or '',                     
                    CollisionSizeX = bp.SizeX * 0.75 or 1,
                    CollisionSizeY = bp.SizeY * 0.75 or 1,
                    CollisionSizeZ = bp.SizeZ * 0.75 or 1,
                    CollisionCenterX = bp.CollisionOffsetX or 0,
                    CollisionCenterY = bp.CollisionOffsetY or 0,
                    CollisionCenterZ = bp.CollisionOffsetZ or 0,
                    OwnerShieldMesh = bpShield.OwnerShieldMesh,
                    ShieldMaxHealth = bpShield.ShieldMaxHealth or 250,
                    ShieldRechargeTime = bpShield.ShieldRechargeTime or 10,
                    ShieldEnergyDrainRechargeTime = bpShield.ShieldEnergyDrainRechargeTime or 10,
                    ShieldRegenRate = bpShield.ShieldRegenRate or 1,
                    ShieldRegenStartTime = bpShield.ShieldRegenStartTime or 5,
                    PassOverkillDamage = bpShield.PassOverkillDamage != false, -- default to true
                }
                self:SetFocusEntity(self.MyShield)
                self:EnableShield()
                self.Trash:Add(self.MyShield)
            else
                LOG('*WARNING: TRYING TO CREATE PERSONAL SHIELD ON UNIT ',repr(self:GetUnitId()),', but it does not have an OwnerShieldMesh=<meshBpName> defined in the Blueprint.')
            end
        end
    end,

    CreateAntiArtilleryShield = function(self, shieldSpec)
        local bp = self:GetBlueprint()
        local bpShield = shieldSpec
        if not shieldSpec then
            bpShield = bp.Defense.Shield
        end
        if bpShield then
            self:DestroyShield()
            self.MyShield = AntiArtilleryShield {
                Owner = self,
				Mesh = bpShield.Mesh or '',
				MeshZ = bpShield.MeshZ or '',
				ImpactMesh = bpShield.ImpactMesh or '',
				ImpactEffects = bpShield.ImpactEffects or '',                
                Size = bpShield.ShieldSize or 10,
                ShieldMaxHealth = bpShield.ShieldMaxHealth or 250,
                ShieldRechargeTime = bpShield.ShieldRechargeTime or 10,
                ShieldEnergyDrainRechargeTime = bpShield.ShieldEnergyDrainRechargeTime or 10,
                ShieldVerticalOffset = bpShield.ShieldVerticalOffset or -1,
                ShieldRegenRate = bpShield.ShieldRegenRate or 1,
                ShieldRegenStartTime = bpShield.ShieldRegenStartTime or 5,
                PassOverkillDamage = bpShield.PassOverkillDamage or false,
            }
            self:SetFocusEntity(self.MyShield)
            self:EnableShield()
            self.Trash:Add(self.MyShield)
        end
    end,

    OnShieldEnabled = function(self)
        #self:PlayUnitSound('Activate')
        self:PlayUnitSound('ShieldOn')
        # Make the shield drain energy
        self:SetMaintenanceConsumptionActive()
    end,

    OnShieldDisabled = function(self)
        #self:PlayUnitSound('Deactivate')
        self:PlayUnitSound('ShieldOff')
        # Turn off the energy drain
        self:SetMaintenanceConsumptionInactive()
    end,

    EnableShield = function(self)
        self:SetScriptBit('RULEUTC_ShieldToggle', true)
        if self.MyShield then
            self.MyShield:TurnOn()
        end
    end,

    DisableShield = function(self)
        self:SetScriptBit('RULEUTC_ShieldToggle', false)
        if self.MyShield then
            self.MyShield:TurnOff()
        end
    end,

    DestroyShield = function(self)
        if self.MyShield then
            self:ClearFocusEntity()
            self.MyShield:Destroy()
            self.MyShield = nil
        end
    end,

    ShieldIsOn = function(self)
        if self.MyShield then
            return self.MyShield:IsOn()
        else
            return false
        end
    end,

    ##########################################################################################
    ## TRANSPORTING
    ##########################################################################################
    OnStartTransportBeamUp = function(self, transport, bone)
        self:DestroyIdleEffects()
        self:DestroyMovementEffects()
        local army =  self:GetArmy()
        table.insert( self.TransportBeamEffectsBag, AttachBeamEntityToEntity(self, -1, transport, bone, army, EffectTemplate.TTransportBeam01))
        table.insert( self.TransportBeamEffectsBag, AttachBeamEntityToEntity( transport, bone, self, -1, army, EffectTemplate.TTransportBeam02))
        table.insert( self.TransportBeamEffectsBag, CreateEmitterAtBone( transport, bone, army, EffectTemplate.TTransportGlow01) )
        self:TransportAnimation()
    end,

    OnStopTransportBeamUp = function(self)
        self:DestroyIdleEffects()
        self:DestroyMovementEffects()
        for k, v in self.TransportBeamEffectsBag do
            v:Destroy()
        end
    end,

    OnTransportAborted = function(self)
        #LOG('TransportAborted')
    end,

    OnTransportOrdered = function(self)
        #LOG('TransportOrdered')
    end,

    MarkWeaponsOnTransport = function(self, unit, transport)
        #Mark the weapons on a transport
        if unit then
            for i = 1, unit:GetWeaponCount() do
                local wep = unit:GetWeapon(i)
                wep:SetOnTransport(transport)
            end
        end
    end,
    
    DestroyedOnTransport = function(self)
    end,

    DestroyedOnTransport = function(self)
    end,

    OnTransportAttach = function(self, attachBone, unit)
        self:PlayUnitSound('Load')
        self:MarkWeaponsOnTransport(unit, true)
        if unit:ShieldIsOn() then
            unit:DisableShield()
            unit:DisableDefaultToggleCaps()
        end
        if not EntityCategoryContains(categories.PODSTAGINGPLATFORM, self) then
            self:RequestRefreshUI()
        end
    end,

    OnTransportDetach = function(self, attachBone, unit)
        self:PlayUnitSound('Unload')
        self:MarkWeaponsOnTransport(unit, false)
        unit:EnableShield()
        unit:EnableDefaultToggleCaps()
        if not EntityCategoryContains(categories.PODSTAGINGPLATFORM, self) then
            self:RequestRefreshUI()
        end
        unit:TransportAnimation(-1)
    end,

    OnStartTransportLoading = function(self)
    end,

    OnStopTransportLoading = function(self)
    end,

    OnAddToStorage = function(self, unit)
        if EntityCategoryContains(categories.CARRIER, unit) then
            self:MarkWeaponsOnTransport(self, true)
            self:HideBone(0, true)
            self:SetCanTakeDamage(false)
            self:SetReclaimable(false)
            self:SetCapturable(false)
            if EntityCategoryContains(categories.TRANSPORTATION, self) then
                local cargo = self:GetCargo()
                if table.getn(cargo) > 0 then
                    for k, v in cargo do
                        v:MarkWeaponsOnTransport(self, true)
                        v:HideBone(0, true)
                        v:SetCanTakeDamage(false)
                        v:SetReclaimable(false)
                        v:SetCapturable(false)
                        #v:DisableShield()
                    end
                end
            end
        end
    end,

    OnRemoveFromStorage = function(self, unit)
        if EntityCategoryContains(categories.CARRIER, unit) then
            self:SetCanTakeDamage(true)
            self:SetReclaimable(true)
            self:SetCapturable(true)
            self:ShowBone(0, true)
            self:MarkWeaponsOnTransport(self, false)
            if EntityCategoryContains(categories.TRANSPORTATION, self) then
                local cargo = self:GetCargo()
                if table.getn(cargo) > 0 then
                    for k, v in cargo do
                        v:MarkWeaponsOnTransport(self, false)
                        v:ShowBone(0, true)
                        v:SetCanTakeDamage(true)
                        v:SetReclaimable(true)
                        v:SetCapturable(true)
                        #v:EnableShield()
                    end
                end
            end
        end
    end,


    GetTransportClass = function(self)
        local bp = self:GetBlueprint().Transport
        return bp.TransportClass
    end,

    TransportAnimation = function(self, rate)
        self:ForkThread( self.TransportAnimationThread, rate )
    end,
    
    TransportAnimationThread = function(self,rate)
        local bp = self:GetBlueprint().Display.TransportAnimation
        
        if rate and rate < 0 and self:GetBlueprint().Display.TransportDropAnimation then
            bp = self:GetBlueprint().Display.TransportDropAnimation
            rate = -rate
        end

        WaitSeconds(.5)
        if bp then
            local animBlock = self:ChooseAnimBlock( bp )
            if animBlock.Animation then
                if not self.TransAnimation then
                    self.TransAnimation = CreateAnimator(self)
                    self.Trash:Add(self.TransAnimation)
                end
                self.TransAnimation:PlayAnim(animBlock.Animation)
                rate = rate or 1
                self.TransAnimation:SetRate(rate)
                WaitFor(self.TransAnimation)
            end
        end
    end,



    ##########################################################################################
    ## TELEPORTING
    ##########################################################################################
    OnTeleportUnit = function(self, teleporter, location, orientation)
        if self.TeleportDrain then
            RemoveEconomyEvent( self, self.TeleportDrain)
            self.TeleportDrain = nil
        end
        if self.TeleportThread then
            KillThread(self.TeleportThread)
            self.TeleportThread = nil
        end
        self:CleanupTeleportChargeEffects()
        self.TeleportThread = self:ForkThread(self.InitiateTeleportThread, teleporter, location, orientation)
    end,

    OnFailedTeleport = function(self)
        if self.TeleportDrain then
            RemoveEconomyEvent( self, self.TeleportDrain)
            self.TeleportDrain = nil
        end
        if self.TeleportThread then
            KillThread(self.TeleportThread)
            self.TeleportThread = nil
        end
        self:StopUnitAmbientSound('TeleportLoop')
        self:CleanupTeleportChargeEffects()
        self:SetWorkProgress(0.0)
        self:SetImmobile(false)
        self.UnitBeingTeleported = nil
    end,

    UpdateTeleportProgress = function(self, progress)
        #LOG(' UpdatingTeleportProgress ')
        self:SetWorkProgress(progress)
    end,

    InitiateTeleportThread = function(self, teleporter, location, orientation)
        local tbp = teleporter:GetBlueprint()
        local ubp = self:GetBlueprint()
        self.UnitBeingTeleported = self
        self:SetImmobile(true)
        self:PlayUnitSound('TeleportStart')
        self:PlayUnitAmbientSound('TeleportLoop')
        local bp = self:GetBlueprint().Economy
        local energyCost, time
        if bp then
            local mass = bp.BuildCostMass * (bp.TeleportMassMod or 0.01)
            local energy = bp.BuildCostEnergy * (bp.TeleportEnergyMod or 0.01)
            energyCost = mass + energy
            time = energyCost * (bp.TeleportTimeMod or 0.01)
        end

        #LOG('*UNIT DEBUG: TELEPORTING, energyCost = ', repr(energyCost), ' time = ', repr(time))
        self.TeleportDrain = CreateEconomyEvent(self, energyCost or 100, 0, time or 5, self.UpdateTeleportProgress)

        # create teleport charge effect
        self:PlayTeleportChargeEffects()

        WaitFor( self.TeleportDrain  ) # Perform fancy Teleportation FX here

        if self.TeleportDrain then
            RemoveEconomyEvent(self, self.TeleportDrain )
            self.TeleportDrain = nil
        end

        self:PlayTeleportOutEffects()
        self:CleanupTeleportChargeEffects()

        WaitSeconds( 0.1 )

        self:SetWorkProgress(0.0)
        Warp(self, location, orientation)
        self:PlayTeleportInEffects()

        WaitSeconds( 0.1 ) # Perform cooldown Teleportation FX here
        #Landing Sound
        #LOG('DROP')
        self:StopUnitAmbientSound('TeleportLoop')
        self:PlayUnitSound('TeleportEnd')
        self:SetImmobile(false)
        self.UnitBeingTeleported = nil
        self.TeleportThread = nil
    end,

    PlayTeleportChargeEffects = function(self)
        local army = self:GetArmy()
        local bp = self:GetBlueprint()

        self.TeleportChargeBag = {}
        for k, v in EffectTemplate.GenericTeleportCharge01 do
            local fx = CreateEmitterAtEntity(self,army,v):OffsetEmitter(0, (bp.Physics.MeshExtentsY or 1) / 2, 0)
            self.Trash:Add(fx)
            table.insert( self.TeleportChargeBag, fx)
        end
    end,

    CleanupTeleportChargeEffects = function( self )
        if self.TeleportChargeBag then
            for keys,values in self.TeleportChargeBag do
                values:Destroy()
            end
            self.TeleportChargeBag = {}
        end
    end,

    PlayTeleportOutEffects = function(self)
        local army = self:GetArmy()
        local emit = nil
        for k, v in EffectTemplate.GenericTeleportOut01 do
            emit = CreateEmitterAtEntity(self,army,v)
        end
    end,


    PlayTeleportInEffects = function(self)
        local army = self:GetArmy()
        local bp = self:GetBlueprint()
        for k, v in EffectTemplate.GenericTeleportIn01 do
            emit = CreateEmitterAtEntity(self,army,v):OffsetEmitter(0, (bp.Physics.MeshExtentsY or 1) / 2, 0)
        end
    end,

    #########################################################################################
    ## ROCKING
    ##########################################################################################
    # While not as exciting as Rock 'n Roll, this will make the unit rock from side to side slowly
    # in the water
    StartRocking = function(self)
        KillThread(self.StopRockThread)
        self.StartRockThread = self:ForkThread( self.RockingThread )
    end,

    StopRocking = function(self)
        KillThread(self.StartRockThread)
        self.StopRockThread = self:ForkThread( self.EndRockingThread )
    end,

    RockingThread = function(self)
        local bp = self:GetBlueprint().Display
        if not self.RockManip and not self:IsDead() and (bp.MaxRockSpeed and bp.MaxRockSpeed > 0) then
            self.RockManip = CreateRotator( self, 0, 'z', nil, 0, (bp.MaxRockSpeed or 1.5) / 5, (bp.MaxRockSpeed or 1.5) * 3 / 5 )
            self.Trash:Add(self.RockManip)
            self.RockManip:SetPrecedence(0)
            while (true) do
                WaitFor( self.RockManip )
                if self:IsDead() then break end # abort if the unit died
                self.RockManip:SetTargetSpeed( -(bp.MaxRockSpeed or 1.5) )
                WaitFor( self.RockManip )
                if self:IsDead() then break end # abort if the unit died
                self.RockManip:SetTargetSpeed( bp.MaxRockSpeed or 1.5 )
            end
        end
    end,

    EndRockingThread = function(self)
        local bp = self:GetBlueprint().Display
        if self.RockManip then
            self.RockManip:SetGoal( 0 )
            self.RockManip:SetSpeed( (bp.MaxRockSpeed or 1.5) / 4 )
            WaitFor( self.RockManip )

            if self.RockManip then
                self.RockManip:Destroy()
                self.RockManip = nil
            end
        end
    end,

}
]]--
