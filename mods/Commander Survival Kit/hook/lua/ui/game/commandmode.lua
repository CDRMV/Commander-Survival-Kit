----
local legacy = OnCommandIssued --hook to the og codes 
local currentClickLocation = {} 

---- 
---- 

OnCommandIssued = function(command) --the og codes
	legacy(command)
	currentClickLocation[1] = command.Target.Position 
end
 
ClickListener = function()
	return currentClickLocation
end

doscript('/mods/Commander Survival Kit/UI//Main.lua')


local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then

--[[
The Code below is an highly compacted Version of the Code from FAF 

We need this Overwrite below to make the Air Strikes to be spawned with the Green Build Template.
Otherwise the Beacon, which spawns the Air Strike Units will not be spawned in Steam

]]--

local TableGetN = table.getn

local function CheatSpawn(command, data)
    SimCallback({
        Func = data.prop and 'CheatBoxSpawnProp' or 'CheatSpawnUnit',
        Args = {
            army = data.army,
            pos = command.Target.Position,
            bpId = data.unit or data.prop or command.Blueprint,
            count = data.count,
            yaw = data.yaw,
            rand = data.rand,
            veterancy = data.vet,
            CreateTarmac = data.CreateTarmac,
            MeshOnly = data.MeshOnly,
            ShowRaisedPlatforms = data.ShowRaisedPlatforms,
            UnitIconCameraMode = data.UnitIconCameraMode,
        }
    }, true)
end




local function OnBuildMobileIssued(command)
    if not command.Units[1] then
        if modeData.callback then 
            modeData.callback(modeData, command)
            return true
        elseif modeData.cheat then
            CheatSpawn(command, modeData)
            command.Units = {}
            return true
        end
    end
    command.SkipBlip = true
    AddCommandFeedbackBlip(
        {
            Position = command.Target.Position,
            BlueprintID = command.Blueprint,
            TextureName = '/meshes/game/flag02d_albedo.dds',
            ShaderName = 'CommandFeedback',
            UniformScale = 1,
        },
        0.7
    )
end

local OnCommandIssuedCallback = {
    Build = nil,
    BuildMobile = OnBuildMobileIssued,
}

function OnCommandIssued(command)
    if not command.Clear then
        issuedOneCommand = true
    end

    if (OnCommandIssuedCallback[command.CommandType] and OnCommandIssuedCallback[command.CommandType](command))
    or command.CommandType == 'None' then
        if command.Clear then
            if modeData and not modeData.cheat or not modeData then
                EndCommandMode(true)
            end
        end
        return
    end
    
    if command.Clear then
        EndCommandMode(true)
        if command.CommandType ~= 'Stop'
        and TableGetN(command.Units) == 1 then
        end
    end

    AddCommandFeedbackByType(command)
end




else

end