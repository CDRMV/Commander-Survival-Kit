local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then -- For Steam and Loud add Rotation Patch to Unit Class 

do

function GuardFormation( formationUnits )
    local rotate = true
    local FormationPos = {}
    local numUnits = table.getn(formationUnits)
    local sizeMult = 0 + math.max(0, numUnits / 6.0)

    # make circle around center point
    for i in formationUnits do
        offsetX = sizeMult * math.sin( lerp( i/numUnits, 0.0, math.pi * 2.0 ) )
        offsetY = sizeMult * math.cos( lerp( i/numUnits, 0.0, math.pi * 2.0 ) )
        table.insert(FormationPos, { offsetX, offsetY, categories.ALLUNITS, 0, rotate })
    end

    return FormationPos
end

end

else	

-- FAF doesn't need the Rotation Patch, because it has the Functions already included.

end

