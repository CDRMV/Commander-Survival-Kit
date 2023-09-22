
function GetEnhancementPrefix(unitID, iconID)
    local selection = sortedOptions.selection
    local Fractionname = selection[1]:GetBlueprint().General.FactionName 
    local factionPrefix = ''
	if Fractionname == 'Aeon' then
        factionPrefix = 'aeon-enhancements/' 
    elseif Fractionname == 'UEF' then
        factionPrefix = 'uef-enhancements/'
    elseif Fractionname == 'Cybran' then
        factionPrefix = 'cybran-enhancements/'
    elseif Fractionname == 'Seraphim' then
        factionPrefix = 'seraphim-enhancements/'
	elseif Fractionname == 'Nomads' then
        factionPrefix = 'Nomads-enhancements/'	
    end
	
    local prefix = '/game/' .. factionPrefix .. iconID
    --# If it is a stock icon...
    if not DiskGetFileInfo('/textures/ui/common'..prefix..'_btn_up.dds') then
        --# return a path to shared icons
        local altPathEX =  '/mods/Commander Survival Kit Units/icons/'
        prefix = altPathEX .. factionPrefix .. iconID
    end
    return prefix
end

function GetEnhancementTextures(unitID, iconID)
    local selection = sortedOptions.selection
    local Fractionname = selection[1]:GetBlueprint().General.FactionName 
    local factionPrefix = ''
	if Fractionname == 'Aeon' then
        factionPrefix = 'aeon-enhancements/' 
    elseif Fractionname == 'UEF' then
        factionPrefix = 'uef-enhancements/'
    elseif Fractionname == 'Cybran' then
        factionPrefix = 'cybran-enhancements/'
    elseif Fractionname == 'Seraphim' then
        factionPrefix = 'seraphim-enhancements/'
	elseif Fractionname == 'Nomads' then
        factionPrefix = 'Nomads-enhancements/'	
    end
    
    local prefix = '/game/' .. factionPrefix .. iconID
    --# If it is a stock icon...
    if DiskGetFileInfo('/textures/ui/common'..prefix..'_btn_up.dds') then
        return UIUtil.UIFile(prefix..'_btn_up.dds'),
            UIUtil.UIFile(prefix..'_btn_down.dds'),
            UIUtil.UIFile(prefix..'_btn_over.dds'),
            UIUtil.UIFile(prefix..'_btn_up.dds'),
            UIUtil.UIFile(prefix..'_btn_sel.dds')
    else
        --# return a path to shared icons
        local altPathEX =  '/mods/Commander Survival Kit Units/icons/'
        prefix = altPathEX .. factionPrefix .. iconID
        --# Bypass UIFile as these icons 
        --# are not skinabble!
        return prefix..'_btn_up.dds',
            prefix..'_btn_down.dds',
            prefix..'_btn_over.dds',
            prefix..'_btn_up.dds',
            prefix..'_btn_sel.dds'
    end
end
