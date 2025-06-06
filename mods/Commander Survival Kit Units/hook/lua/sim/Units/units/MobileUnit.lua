local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 


else



local Unit = import("/lua/sim/unit.lua").Unit
local UnitOnCreate = Unit.OnCreate
local UnitOnKilled = Unit.OnKilled
local UnitDestroyAllTrashBags = Unit.DestroyAllTrashBags
local UnitCreateMovementEffects = Unit.CreateMovementEffects
local UnitDestroyMovementEffects = Unit.DestroyMovementEffects
local UnitStartBeingBuiltEffects = Unit.StartBeingBuiltEffects
local UnitOnStopBeingBuilt = Unit.OnStopBeingBuilt
local UnitOnLayerChange = Unit.OnLayerChange
local UnitOnDetachedFromTransport = Unit.OnDetachedFromTransport

local TreadComponent = import("/lua/defaultcomponents.lua").TreadComponent
local TreadComponentOnCreate = TreadComponent.OnCreate
local TreadComponentCreateMovementEffects = TreadComponent.CreateMovementEffects
local TreadComponentDestroyMovementEffects = TreadComponent.DestroyMovementEffects

-- pre-import for performance
local CreateUEFUnitBeingBuiltEffects = import("/lua/effectutilities.lua").CreateUEFUnitBeingBuiltEffects

-- upvalue scope for performance
local TrashBag = TrashBag

---@class MobileUnit : Unit, TreadComponent
---@field MovementEffectsBag TrashBag
---@field TopSpeedEffectsBag TrashBag
---@field BeamExhaustEffectsBag TrashBag
---@field TransportBeamEffectsBag? TrashBag
---@field OnBeingBuiltEffectsBag? TrashBag
MobileUnit = ClassUnit(Unit, TreadComponent) {

    ---@param self MobileUnit
    OnCreate = function(self)
        UnitOnCreate(self)
        --TreadComponentOnCreate(self)
		self.MovementEffectsBag:Destroy()
        self.MovementEffectsBag = TrashBag()
        self.TopSpeedEffectsBag = TrashBag()
        self.BeamExhaustEffectsBag = TrashBag()
    end,

    ---@param self MobileUnit
    DestroyAllTrashBags = function(self)
        UnitDestroyAllTrashBags(self)

        self.MovementEffectsBag:Destroy()
        self.TopSpeedEffectsBag:Destroy()
        self.BeamExhaustEffectsBag:Destroy()

        -- only exists if unit is transported
        local transportBeamEffectsBag = self.TransportBeamEffectsBag
        if transportBeamEffectsBag then
            transportBeamEffectsBag:Destroy()
        end
    end,

    ---@param self MobileUnit
    ---@param effectsBag TrashBag
    ---@param typeSuffix string
    ---@param terrainType string
    CreateMovementEffects = function(self, effectsBag, typeSuffix, terrainType)
        UnitCreateMovementEffects(self, effectsBag, typeSuffix, terrainType)
        TreadComponentCreateMovementEffects(self)
    end,

    ---@param self MobileUnit
    DestroyMovementEffects = function(self)
        UnitDestroyMovementEffects(self)
        TreadComponentDestroyMovementEffects(self)
    end,

    ---@param self MobileUnit
    ---@param instigator Unit
    ---@param type string
    ---@param overkillRatio number
    OnKilled = function(self, instigator, type, overkillRatio)
        -- Skips a single OnKilled call
        -- currently used by transports with external storage, so that death effects can be applied later from OnImpact
        if self.killedInTransport then
            self.killedInTransport = false
        else
            UnitOnKilled(self, instigator, type, overkillRatio)
        end
    end,

    ---@param self MobileUnit
    ---@param builder Unit
    ---@param layer Layer
    StartBeingBuiltEffects = function(self, builder, layer)
        UnitStartBeingBuiltEffects(self, builder, layer)
        if self.Blueprint.FactionCategory == 'UEF' then
            CreateUEFUnitBeingBuiltEffects(self, builder, self.OnBeingBuiltEffectsBag)
        end
    end,

    -- Units with layer change effects (amphibious units like Megalith) need
    -- those changes applied when build ends, so we need to trigger the
    -- layer change event
    ---@param self MobileUnit
    ---@param builder Unit
    ---@param layer Layer
    OnStopBeingBuilt = function(self, builder, layer)
        UnitOnStopBeingBuilt(self, builder, layer)
        self:OnLayerChange(layer, 'None')
    end,

    ---@param self MobileUnit
    ---@param built Unit
    ---@param order string
    ---@return boolean
    OnStartBuild = function(self, built, order)
        if IsAlly(self.Army, built.Army) then
            return Unit.OnStartBuild(self, built, order)
        else
            self:OnFailedToBuild()
            IssueToUnitClearCommands(self)
            return false
        end
    end,

    ---@param self MobileUnit
    ---@param new string
    ---@param old string
    OnLayerChange = function(self, new, old)
        UnitOnLayerChange(self, new, old)

        -- Do this after the default function so the engine-bug guard in unit.lua works
        if self.transportDrop then
            self.transportDrop = nil
            self:SetImmobile(false)
        end
    end,

    ---@param self MobileUnit
    ---@param transport AirUnit
    ---@param bone Bone
    OnDetachedFromTransport = function(self, transport, bone)
        UnitOnDetachedFromTransport(self, transport, bone)
		TreadComponentCreateMovementEffects(self)
		TreadComponentOnCreate(self)
        -- Set unit immobile to prevent it to accelerating in the air, cleared in OnLayerChange
        if not self.Blueprint.CategoriesHash["AIR"] then
            self:SetImmobile(true)
            self.transportDrop = true
        end
    end,

}




end
	

