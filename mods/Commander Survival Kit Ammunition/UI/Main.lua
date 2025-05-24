function UnitDialog(Unit, Value, boolean)
	
Sync.ManageUnitDialog = boolean
Sync.CreateUnitDialogText = Value


end

function ManageButton(Unit)
if Sync.EnableButton == true then
	
elseif Sync.EnableButton == false then
Unit:SetScriptBit('RULEUTC_SpecialToggle', false)
Sync.CreateUnitDialogText = 'No Data'
Sync.ManageUnitDialog = false
elseif Sync.EnableButton == nil then
Unit:SetScriptBit('RULEUTC_SpecialToggle', false)
Sync.CreateUnitDialogText = 'No Data'
Sync.ManageUnitDialog = false
end

end