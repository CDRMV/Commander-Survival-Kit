

do
    local oldUnit = Unit

    Unit = Class(oldUnit) {
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
    }
end