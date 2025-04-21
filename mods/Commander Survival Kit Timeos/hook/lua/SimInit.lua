

do

local oldBeginSession = BeginSession
function BeginSession()
    oldBeginSession()
	Sync.Load = false
end

local oldOnPostLoad = OnPostLoad
function OnPostLoad()
    oldOnPostLoad()
	Sync.Load = true
end


end

