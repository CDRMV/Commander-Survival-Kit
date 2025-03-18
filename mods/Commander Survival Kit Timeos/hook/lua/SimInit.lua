local GetCSKPath = function() for i, mod in __active_mods do if mod.name == "Commander Survival Kit" then return mod.location end end end
local CSKPath = GetCSKPath()

if CSKPath then

else

do

local oldBeginSession = BeginSession
function BeginSession()
    oldBeginSession()
	Sync.LoadTechlevel = false
end

local oldOnPostLoad = OnPostLoad
function OnPostLoad()
    oldOnPostLoad()
	Sync.LoadTechlevel = true
end


end

end