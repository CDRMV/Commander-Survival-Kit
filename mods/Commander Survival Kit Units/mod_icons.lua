-- we do not have any manual assignments
UnitIconAssignments = { }

--- Entry point for scripted assignments. This function has a limited scope and any changes to the 
-- units and / or the projectiles do not affect the game as they are deep-copied of the originals. 
-- Functionality that is available:
--  - moho-log interaction: LOG, WARN, _ALERT, SPEW, error, assert
--  - debugging: repr
--  - iterators: pairs, ipairs, next 
--  - typical statements: table, math (excluding math.random), string, tonumber, type, unpack, tostring
-- @param units All available unit blueprints.
-- @param projectiles All available projectile blueprints.
-- @param icons All the file names of the icons part of this mod.
function ScriptedIconAssignments (units, projectiles, icons)

    -- for performance
    local StringSub = string.sub
    local StringFind = string.find

    -- this is where we store the results
    local IconAssignments = {}

    -- loop over all the units
    for id, bp in units do

        -- retrieve the original strategic icon name
        local strategicIconName = bp.StrategicIconName

        -- this can be nil
        if strategicIconName then 

            -- compute this once for all icons
            local target = "/" .. strategicIconName .. "_rest.dds"

            -- check if we have the same identifier in our icon folder
            local partOfIconsMod = false 
            for k, icon in icons do 
                if StringSub(icon, -9) == '_rest.dds' and StringFind(icon, target) then 
                    partOfIconsMod = true 
                    break
                end
            end

            -- if we do, use that instead
            if partOfIconsMod then 
                IconAssignments[id] = { BlueprintId = id, IconSet = bp.StrategicIconName }
            end
        end
    end
    
    return IconAssignments
end