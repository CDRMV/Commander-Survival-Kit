
RollingLandUnit = Class(MobileUnit) {
    RollingAnim = nil,
    RollingAnimRate = 1,
    IdleAnim = false,
    IdleAnimRate = 1,
    DeathAnim = false,
    DisabledBones = {},

    OnMotionHorzEventChange = function( self, new, old )
        MobileUnit.OnMotionHorzEventChange(self, new, old)
        
    end,
}


do
    local oldStructureUnit = StructureUnit

    StructureUnit = Class(oldStructureUnit) {
        FlattenSkirt = function(self)
            if not (__blueprints[self.BpId] or self:GetBlueprint()).Physics.ConditionalFlattenSkirt then
                oldStructureUnit.FlattenSkirt(self)
            else
                self:ForkThread(function(self)
                    coroutine.yield(1) -- Delay because this triggers before it gets attached to anything.
                    local pos = self.CachePosition or self:GetPosition()
                    local terrain = GetTerrainHeight(pos[1], pos[3])
                    if pos[2] == terrain then
                        oldStructureUnit.FlattenSkirt(self)
                    end
                end)
            end
        end
    }
end