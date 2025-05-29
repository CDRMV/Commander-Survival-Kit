do

local function GetT2WaitTimeValue(data)

    local value = data.Args.selection
	Sync.TransferT2WaitTime = value

end

local function GetT3WaitTimeValue(data)

    local value = data.Args.selection
	Sync.TransferT3WaitTime = value

end

local function GetEXPWaitTimeValue(data)

    local value = data.Args.selection
	Sync.TransferEXPWaitTime = value

end

local function GetEliteWaitTimeValue(data)

    local value = data.Args.selection
	Sync.TransferEliteWaitTime = value

end

local function GetHeroWaitTimeValue(data)

    local value = data.Args.selection
	Sync.TransferHeroWaitTime = value

end

local function GetTitanWaitTimeValue(data)

    local value = data.Args.selection
	Sync.TransferTitanWaitTime = value

end


function CheckforT2WaitTime()

import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforT2WaitTime", GetT2WaitTimeValue)


end

function CheckforT3WaitTime()

import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforT3WaitTime", GetT3WaitTimeValue)


end

function CheckforEXPWaitTime()

import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforEXPWaitTime", GetEXPWaitTimeValue)


end

function CheckforEliteWaitTime()

import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforEliteWaitTime", GetEliteWaitTimeValue)


end

function CheckforHeroWaitTime()

import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforHeroWaitTime", GetHeroWaitTimeValue)


end

function CheckforTitanWaitTime()

import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforTitanWaitTime", GetTitanWaitTimeValue)


end


end

