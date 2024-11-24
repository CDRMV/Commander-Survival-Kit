
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')

function SetLayout()
    local controls = import('/lua/ui/game/missiontext.lua').controls
    
    if controls.movieBrackets then
        LayoutHelpers.AtCenterIn(controls.movieBrackets, GetFrame(0), -400, 0)
        LayoutHelpers.AtCenterIn(controls.subtitles.text[1], GetFrame(0), -270, 0)
		LayoutHelpers.DepthOverParent(controls.movieBrackets, GetFrame(0), 10000)
        LayoutHelpers.DepthOverParent(controls.subtitles, controls.movieBrackets, 10000)
    end
end