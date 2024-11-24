
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')

function SetLayout()
    local controls = import('/lua/ui/game/missiontext.lua').controls
    
    if controls.movieBrackets then
        if import('/lua/ui/game/gamemain.lua').IsNISMode() then
            import(UIUtil.GetLayoutFilename('missiontextnis')).SetLayout()
        else
        LayoutHelpers.AtCenterIn(controls.movieBrackets, GetFrame(0), -400, 0)
        LayoutHelpers.AtCenterIn(controls.subtitles.text[1], GetFrame(0), -270, 0)
        end
    end
end