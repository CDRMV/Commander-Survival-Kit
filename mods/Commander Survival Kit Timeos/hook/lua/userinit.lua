do 
function WaitTicks(ticks)
    -- local scope for performance
    local GameTick = GameTick
    local WaitFrames = WaitFrames

    local start = GameTick()
    repeat
        WaitFrames(2)
    until (start + ticks) <= GameTick()
end

end