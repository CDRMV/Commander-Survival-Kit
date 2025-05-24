do
function EnableButton(data)

    local value = data.Args.selection
	Sync.EnableButton = value


end

function CheckEnableButton()

import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckEnableButton", EnableButton)


end

end