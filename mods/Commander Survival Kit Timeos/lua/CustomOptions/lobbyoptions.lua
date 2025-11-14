local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then

if DiskGetFileInfo('/lua/AI/CustomAIs_v2/ExtrasAI.lua') then
if import('/lua/AI/CustomAIs_v2/ExtrasAI.lua').AI.Name == 'AI Patch LOUD' and not import('/lua/AI/CustomAIs_v2/ExtrasAI.lua').AI.Name == 'AI Patch (Duncane)' then

LobbyGlobalOptions = {}

else

LobbyGlobalOptions = {
    {
        default = 1,
        label = "<LOC Tech2WaitTimeTitle>Tech 2 available in:",
        help = "<LOC Tech2WaitTimeDesc>Set the wait time for the unlock of Tech 2 for AI and Players in Minutes.",
        key = 'WaitTimeTech2',
		pref = 'WaitTimeTech_2',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC Min5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC Min10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC Min15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC Min20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC Min25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC Min30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC Min35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC Min40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC Min45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC Min50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC Min55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },	
            {
                text = "<LOC h15Min>1 Hour 5 Minutes",
                help = "<LOC h15MinDesc>Set the Wait Time to 1 Hour 5 Minutes",
                key = 3900,
            },	
            {
                text = "<LOC h110Min>1 Hour 10 Minutes",
                help = "<LOC h110MinDesc>Set the Wait Time to 1 Hour 10 Minutes",
                key = 4200,
            },	
            {
                text = "<LOC h115Min>1 Hour 15 Minutes",
                help = "<LOC h115MinDesc>Set the Wait Time to 1 Hour 15 Minutes",
                key = 4500,
            },
            {
                text = "<LOC h120Min>1 Hour 20 Minutes",
                help = "<LOC h120MinDesc>Set the Wait Time to 1 Hour 20 Minutes",
                key = 4800,
            },	
            {
                text = "<LOC h125Min>1 Hour 25 Minutes",
                help = "<LOC h125MinDesc>Set the Wait Time to 1 Hour 25 Minutes",
                key = 5100,
            },	
            {
                text = "<LOC h130Min>1 Hour 30 Minutes",
                help = "<LOC h130MinDesc>Set the Wait Time to 1 Hour 30 Minutes",
                key = 5400,
            },	
            {
                text = "<LOC h135Min>1 Hour 35 Minutes",
                help = "<LOC h135MinDesc>Set the Wait Time to 1 Hour 35 Minutes",
                key = 5700,
            },	
            {
                text = "<LOC h140Min>1 Hour 40 Minutes",
                help = "<LOC h140MinDesc>Set the Wait Time to 1 Hour 40 Minutes",
                key = 6000,
            },	
            {
                text = "<LOC h145Min>1 Hour 45 Minutes",
                help = "<LOC h145MinDesc>Set the Wait Time to 1 Hour 45 Minutes",
                key = 6300,
            },	
            {
                text = "<LOC h150Min>1 Hour 50 Minutes",
                help = "<LOC h150MinDesc>Set the Wait Time to 1 Hour 50 Minutes",
                key = 6600,
            },	
            {
                text = "<LOC h155Min>1 Hour 55 Minutes",
                help = "<LOC h155MinDesc>Set the Wait Time to 1 Hour 55 Minutes",
                key = 6900,
            },	
            {
                text = "<LOC h2>2 Hours",
                help = "<LOC h2Desc>Set the Wait Time to 2 Hours",
                key = 7200,
            },	
        },
    },
	{
        default = 1,
        label = "<LOC Tech3WaitTimeTitle>Tech 3 available in:",
        help = "<LOC Tech3WaitTimeDesc>Set the wait time for the unlock of Tech 3 for AI and Players in Minutes.",
        key = 'WaitTimeTech3',
		pref = 'WaitTimeTech_3',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC Min5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC Min10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC Min15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC Min20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC Min25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC Min30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC Min35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC Min40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC Min45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC Min50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC Min55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },	
            {
                text = "<LOC h15Min>1 Hour 5 Minutes",
                help = "<LOC h15MinDesc>Set the Wait Time to 1 Hour 5 Minutes",
                key = 3900,
            },	
            {
                text = "<LOC h110Min>1 Hour 10 Minutes",
                help = "<LOC h110MinDesc>Set the Wait Time to 1 Hour 10 Minutes",
                key = 4200,
            },	
            {
                text = "<LOC h115Min>1 Hour 15 Minutes",
                help = "<LOC h115MinDesc>Set the Wait Time to 1 Hour 15 Minutes",
                key = 4500,
            },
            {
                text = "<LOC h120Min>1 Hour 20 Minutes",
                help = "<LOC h120MinDesc>Set the Wait Time to 1 Hour 20 Minutes",
                key = 4800,
            },	
            {
                text = "<LOC h125Min>1 Hour 25 Minutes",
                help = "<LOC h125MinDesc>Set the Wait Time to 1 Hour 25 Minutes",
                key = 5100,
            },	
            {
                text = "<LOC h130Min>1 Hour 30 Minutes",
                help = "<LOC h130MinDesc>Set the Wait Time to 1 Hour 30 Minutes",
                key = 5400,
            },	
            {
                text = "<LOC h135Min>1 Hour 35 Minutes",
                help = "<LOC h135MinDesc>Set the Wait Time to 1 Hour 35 Minutes",
                key = 5700,
            },	
            {
                text = "<LOC h140Min>1 Hour 40 Minutes",
                help = "<LOC h140MinDesc>Set the Wait Time to 1 Hour 40 Minutes",
                key = 6000,
            },	
            {
                text = "<LOC h145Min>1 Hour 45 Minutes",
                help = "<LOC h145MinDesc>Set the Wait Time to 1 Hour 45 Minutes",
                key = 6300,
            },	
            {
                text = "<LOC h150Min>1 Hour 50 Minutes",
                help = "<LOC h150MinDesc>Set the Wait Time to 1 Hour 50 Minutes",
                key = 6600,
            },	
            {
                text = "<LOC h155Min>1 Hour 55 Minutes",
                help = "<LOC h155MinDesc>Set the Wait Time to 1 Hour 55 Minutes",
                key = 6900,
            },	
            {
                text = "<LOC h2>2 Hours",
                help = "<LOC h2Desc>Set the Wait Time to 2 Hours",
                key = 7200,
            },	
        },
    },
	{
        default = 1,
        label = "<LOC EXPWaitTimeTitle>Experimentals available in:",
        help = "<LOC EXPWaitTimeDesc>Set the wait time for the unlock of Experimentals for AI and Players in Minutes.",
        key = 'WaitTimeEXP',
		pref = 'WaitTimeExp',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC Min5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC Min10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC Min15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC Min20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC Min25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC Min30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC Min35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC Min40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC Min45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC Min50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC Min55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },	
            {
                text = "<LOC h15Min>1 Hour 5 Minutes",
                help = "<LOC h15MinDesc>Set the Wait Time to 1 Hour 5 Minutes",
                key = 3900,
            },	
            {
                text = "<LOC h110Min>1 Hour 10 Minutes",
                help = "<LOC h110MinDesc>Set the Wait Time to 1 Hour 10 Minutes",
                key = 4200,
            },	
            {
                text = "<LOC h115Min>1 Hour 15 Minutes",
                help = "<LOC h115MinDesc>Set the Wait Time to 1 Hour 15 Minutes",
                key = 4500,
            },
            {
                text = "<LOC h120Min>1 Hour 20 Minutes",
                help = "<LOC h120MinDesc>Set the Wait Time to 1 Hour 20 Minutes",
                key = 4800,
            },	
            {
                text = "<LOC h125Min>1 Hour 25 Minutes",
                help = "<LOC h125MinDesc>Set the Wait Time to 1 Hour 25 Minutes",
                key = 5100,
            },	
            {
                text = "<LOC h130Min>1 Hour 30 Minutes",
                help = "<LOC h130MinDesc>Set the Wait Time to 1 Hour 30 Minutes",
                key = 5400,
            },	
            {
                text = "<LOC h135Min>1 Hour 35 Minutes",
                help = "<LOC h135MinDesc>Set the Wait Time to 1 Hour 35 Minutes",
                key = 5700,
            },	
            {
                text = "<LOC h140Min>1 Hour 40 Minutes",
                help = "<LOC h140MinDesc>Set the Wait Time to 1 Hour 40 Minutes",
                key = 6000,
            },	
            {
                text = "<LOC h145Min>1 Hour 45 Minutes",
                help = "<LOC h145MinDesc>Set the Wait Time to 1 Hour 45 Minutes",
                key = 6300,
            },	
            {
                text = "<LOC h150Min>1 Hour 50 Minutes",
                help = "<LOC h150MinDesc>Set the Wait Time to 1 Hour 50 Minutes",
                key = 6600,
            },	
            {
                text = "<LOC h155Min>1 Hour 55 Minutes",
                help = "<LOC h155MinDesc>Set the Wait Time to 1 Hour 55 Minutes",
                key = 6900,
            },	
            {
                text = "<LOC h2>2 Hours",
                help = "<LOC h2Desc>Set the Wait Time to 2 Hours",
                key = 7200,
            },	
        },
    },
	{
        default = 1,
        label = "<LOC EliteWaitTimeTitle>Elite available in:",
        help = "<LOC EliteWaitTimeDesc>Set the wait time for the unlock of Elite for AI and Players in Minutes.",
        key = 'WaitTimeElite',
		pref = 'WaitTimeElite_',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC Min5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC Min10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC Min15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC Min20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC Min25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC Min30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC Min35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC Min40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC Min45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC Min50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC Min55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },	
            {
                text = "<LOC h15Min>1 Hour 5 Minutes",
                help = "<LOC h15MinDesc>Set the Wait Time to 1 Hour 5 Minutes",
                key = 3900,
            },	
            {
                text = "<LOC h110Min>1 Hour 10 Minutes",
                help = "<LOC h110MinDesc>Set the Wait Time to 1 Hour 10 Minutes",
                key = 4200,
            },	
            {
                text = "<LOC h115Min>1 Hour 15 Minutes",
                help = "<LOC h115MinDesc>Set the Wait Time to 1 Hour 15 Minutes",
                key = 4500,
            },
            {
                text = "<LOC h120Min>1 Hour 20 Minutes",
                help = "<LOC h120MinDesc>Set the Wait Time to 1 Hour 20 Minutes",
                key = 4800,
            },	
            {
                text = "<LOC h125Min>1 Hour 25 Minutes",
                help = "<LOC h125MinDesc>Set the Wait Time to 1 Hour 25 Minutes",
                key = 5100,
            },	
            {
                text = "<LOC h130Min>1 Hour 30 Minutes",
                help = "<LOC h130MinDesc>Set the Wait Time to 1 Hour 30 Minutes",
                key = 5400,
            },	
            {
                text = "<LOC h135Min>1 Hour 35 Minutes",
                help = "<LOC h135MinDesc>Set the Wait Time to 1 Hour 35 Minutes",
                key = 5700,
            },	
            {
                text = "<LOC h140Min>1 Hour 40 Minutes",
                help = "<LOC h140MinDesc>Set the Wait Time to 1 Hour 40 Minutes",
                key = 6000,
            },	
            {
                text = "<LOC h145Min>1 Hour 45 Minutes",
                help = "<LOC h145MinDesc>Set the Wait Time to 1 Hour 45 Minutes",
                key = 6300,
            },	
            {
                text = "<LOC h150Min>1 Hour 50 Minutes",
                help = "<LOC h150MinDesc>Set the Wait Time to 1 Hour 50 Minutes",
                key = 6600,
            },	
            {
                text = "<LOC h155Min>1 Hour 55 Minutes",
                help = "<LOC h155MinDesc>Set the Wait Time to 1 Hour 55 Minutes",
                key = 6900,
            },	
            {
                text = "<LOC h2>2 Hours",
                help = "<LOC h2Desc>Set the Wait Time to 2 Hours",
                key = 7200,
            },	
        },
    },
	{
        default = 1,
        label = "<LOC HeroWaitTimeTitle>Hero available in:",
        help = "<LOC HeroWaitTimeDesc>Set the wait time for the unlock of Heros for AI and Players in Minutes.",
        key = 'WaitTimeHero',
		pref = 'WaitTimeHero_',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC Min5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC Min10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC Min15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC Min20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC Min25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC Min30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC Min35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC Min40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC Min45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC Min50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC Min55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },	
            {
                text = "<LOC h15Min>1 Hour 5 Minutes",
                help = "<LOC h15MinDesc>Set the Wait Time to 1 Hour 5 Minutes",
                key = 3900,
            },	
            {
                text = "<LOC h110Min>1 Hour 10 Minutes",
                help = "<LOC h110MinDesc>Set the Wait Time to 1 Hour 10 Minutes",
                key = 4200,
            },	
            {
                text = "<LOC h115Min>1 Hour 15 Minutes",
                help = "<LOC h115MinDesc>Set the Wait Time to 1 Hour 15 Minutes",
                key = 4500,
            },
            {
                text = "<LOC h120Min>1 Hour 20 Minutes",
                help = "<LOC h120MinDesc>Set the Wait Time to 1 Hour 20 Minutes",
                key = 4800,
            },	
            {
                text = "<LOC h125Min>1 Hour 25 Minutes",
                help = "<LOC h125MinDesc>Set the Wait Time to 1 Hour 25 Minutes",
                key = 5100,
            },	
            {
                text = "<LOC h130Min>1 Hour 30 Minutes",
                help = "<LOC h130MinDesc>Set the Wait Time to 1 Hour 30 Minutes",
                key = 5400,
            },	
            {
                text = "<LOC h135Min>1 Hour 35 Minutes",
                help = "<LOC h135MinDesc>Set the Wait Time to 1 Hour 35 Minutes",
                key = 5700,
            },	
            {
                text = "<LOC h140Min>1 Hour 40 Minutes",
                help = "<LOC h140MinDesc>Set the Wait Time to 1 Hour 40 Minutes",
                key = 6000,
            },	
            {
                text = "<LOC h145Min>1 Hour 45 Minutes",
                help = "<LOC h145MinDesc>Set the Wait Time to 1 Hour 45 Minutes",
                key = 6300,
            },	
            {
                text = "<LOC h150Min>1 Hour 50 Minutes",
                help = "<LOC h150MinDesc>Set the Wait Time to 1 Hour 50 Minutes",
                key = 6600,
            },	
            {
                text = "<LOC h155Min>1 Hour 55 Minutes",
                help = "<LOC h155MinDesc>Set the Wait Time to 1 Hour 55 Minutes",
                key = 6900,
            },	
            {
                text = "<LOC h2>2 Hours",
                help = "<LOC h2Desc>Set the Wait Time to 2 Hours",
                key = 7200,
            },		
        },
    },
			{
        default = 1,
        label = "<LOC TitanWaitTimeTitle>Titan available in:",
        help = "<LOC TitanWaitTimeDesc>Set the wait time for the unlock of Titan for AI and Players in Minutes.",
        key = 'WaitTimeTitan',
		pref = 'WaitTimeTitan_',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC Min5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC Min10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC Min15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC Min20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC Min25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC Min30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC Min35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC Min40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC Min45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC Min50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC Min55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },	
            {
                text = "<LOC h15Min>1 Hour 5 Minutes",
                help = "<LOC h15MinDesc>Set the Wait Time to 1 Hour 5 Minutes",
                key = 3900,
            },	
            {
                text = "<LOC h110Min>1 Hour 10 Minutes",
                help = "<LOC h110MinDesc>Set the Wait Time to 1 Hour 10 Minutes",
                key = 4200,
            },	
            {
                text = "<LOC h115Min>1 Hour 15 Minutes",
                help = "<LOC h115MinDesc>Set the Wait Time to 1 Hour 15 Minutes",
                key = 4500,
            },
            {
                text = "<LOC h120Min>1 Hour 20 Minutes",
                help = "<LOC h120MinDesc>Set the Wait Time to 1 Hour 20 Minutes",
                key = 4800,
            },	
            {
                text = "<LOC h125Min>1 Hour 25 Minutes",
                help = "<LOC h125MinDesc>Set the Wait Time to 1 Hour 25 Minutes",
                key = 5100,
            },	
            {
                text = "<LOC h130Min>1 Hour 30 Minutes",
                help = "<LOC h130MinDesc>Set the Wait Time to 1 Hour 30 Minutes",
                key = 5400,
            },	
            {
                text = "<LOC h135Min>1 Hour 35 Minutes",
                help = "<LOC h135MinDesc>Set the Wait Time to 1 Hour 35 Minutes",
                key = 5700,
            },	
            {
                text = "<LOC h140Min>1 Hour 40 Minutes",
                help = "<LOC h140MinDesc>Set the Wait Time to 1 Hour 40 Minutes",
                key = 6000,
            },	
            {
                text = "<LOC h145Min>1 Hour 45 Minutes",
                help = "<LOC h145MinDesc>Set the Wait Time to 1 Hour 45 Minutes",
                key = 6300,
            },	
            {
                text = "<LOC h150Min>1 Hour 50 Minutes",
                help = "<LOC h150MinDesc>Set the Wait Time to 1 Hour 50 Minutes",
                key = 6600,
            },	
            {
                text = "<LOC h155Min>1 Hour 55 Minutes",
                help = "<LOC h155MinDesc>Set the Wait Time to 1 Hour 55 Minutes",
                key = 6900,
            },	
            {
                text = "<LOC h2>2 Hours",
                help = "<LOC h2Desc>Set the Wait Time to 2 Hours",
                key = 7200,
            },	
        },
    },
}

end

else
LOG('STEAM')

LobbyGlobalOptions = {
    {
        default = 1,
        label = "<LOC Tech2WaitTimeTitle>Tech 2 available in:",
        help = "<LOC Tech2WaitTimeDesc>Set the wait time for the unlock of Tech 2 for AI and Players in Minutes.",
        key = 'WaitTimeTech2',
		pref = 'WaitTimeTech_2',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC Min5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC Min10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC Min15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC Min20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC Min25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC Min30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC Min35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC Min40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC Min45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC Min50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC Min55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },	
            {
                text = "<LOC h15Min>1 Hour 5 Minutes",
                help = "<LOC h15MinDesc>Set the Wait Time to 1 Hour 5 Minutes",
                key = 3900,
            },	
            {
                text = "<LOC h110Min>1 Hour 10 Minutes",
                help = "<LOC h110MinDesc>Set the Wait Time to 1 Hour 10 Minutes",
                key = 4200,
            },	
            {
                text = "<LOC h115Min>1 Hour 15 Minutes",
                help = "<LOC h115MinDesc>Set the Wait Time to 1 Hour 15 Minutes",
                key = 4500,
            },
            {
                text = "<LOC h120Min>1 Hour 20 Minutes",
                help = "<LOC h120MinDesc>Set the Wait Time to 1 Hour 20 Minutes",
                key = 4800,
            },	
            {
                text = "<LOC h125Min>1 Hour 25 Minutes",
                help = "<LOC h125MinDesc>Set the Wait Time to 1 Hour 25 Minutes",
                key = 5100,
            },	
            {
                text = "<LOC h130Min>1 Hour 30 Minutes",
                help = "<LOC h130MinDesc>Set the Wait Time to 1 Hour 30 Minutes",
                key = 5400,
            },	
            {
                text = "<LOC h135Min>1 Hour 35 Minutes",
                help = "<LOC h135MinDesc>Set the Wait Time to 1 Hour 35 Minutes",
                key = 5700,
            },	
            {
                text = "<LOC h140Min>1 Hour 40 Minutes",
                help = "<LOC h140MinDesc>Set the Wait Time to 1 Hour 40 Minutes",
                key = 6000,
            },	
            {
                text = "<LOC h145Min>1 Hour 45 Minutes",
                help = "<LOC h145MinDesc>Set the Wait Time to 1 Hour 45 Minutes",
                key = 6300,
            },	
            {
                text = "<LOC h150Min>1 Hour 50 Minutes",
                help = "<LOC h150MinDesc>Set the Wait Time to 1 Hour 50 Minutes",
                key = 6600,
            },	
            {
                text = "<LOC h155Min>1 Hour 55 Minutes",
                help = "<LOC h155MinDesc>Set the Wait Time to 1 Hour 55 Minutes",
                key = 6900,
            },	
            {
                text = "<LOC h2>2 Hours",
                help = "<LOC h2Desc>Set the Wait Time to 2 Hours",
                key = 7200,
            },	
        },
    },
	{
        default = 1,
        label = "<LOC Tech3WaitTimeTitle>Tech 3 available in:",
        help = "<LOC Tech3WaitTimeDesc>Set the wait time for the unlock of Tech 3 for AI and Players in Minutes.",
        key = 'WaitTimeTech3',
		pref = 'WaitTimeTech_3',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC Min5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC Min10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC Min15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC Min20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC Min25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC Min30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC Min35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC Min40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC Min45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC Min50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC Min55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },	
            {
                text = "<LOC h15Min>1 Hour 5 Minutes",
                help = "<LOC h15MinDesc>Set the Wait Time to 1 Hour 5 Minutes",
                key = 3900,
            },	
            {
                text = "<LOC h110Min>1 Hour 10 Minutes",
                help = "<LOC h110MinDesc>Set the Wait Time to 1 Hour 10 Minutes",
                key = 4200,
            },	
            {
                text = "<LOC h115Min>1 Hour 15 Minutes",
                help = "<LOC h115MinDesc>Set the Wait Time to 1 Hour 15 Minutes",
                key = 4500,
            },
            {
                text = "<LOC h120Min>1 Hour 20 Minutes",
                help = "<LOC h120MinDesc>Set the Wait Time to 1 Hour 20 Minutes",
                key = 4800,
            },	
            {
                text = "<LOC h125Min>1 Hour 25 Minutes",
                help = "<LOC h125MinDesc>Set the Wait Time to 1 Hour 25 Minutes",
                key = 5100,
            },	
            {
                text = "<LOC h130Min>1 Hour 30 Minutes",
                help = "<LOC h130MinDesc>Set the Wait Time to 1 Hour 30 Minutes",
                key = 5400,
            },	
            {
                text = "<LOC h135Min>1 Hour 35 Minutes",
                help = "<LOC h135MinDesc>Set the Wait Time to 1 Hour 35 Minutes",
                key = 5700,
            },	
            {
                text = "<LOC h140Min>1 Hour 40 Minutes",
                help = "<LOC h140MinDesc>Set the Wait Time to 1 Hour 40 Minutes",
                key = 6000,
            },	
            {
                text = "<LOC h145Min>1 Hour 45 Minutes",
                help = "<LOC h145MinDesc>Set the Wait Time to 1 Hour 45 Minutes",
                key = 6300,
            },	
            {
                text = "<LOC h150Min>1 Hour 50 Minutes",
                help = "<LOC h150MinDesc>Set the Wait Time to 1 Hour 50 Minutes",
                key = 6600,
            },	
            {
                text = "<LOC h155Min>1 Hour 55 Minutes",
                help = "<LOC h155MinDesc>Set the Wait Time to 1 Hour 55 Minutes",
                key = 6900,
            },	
            {
                text = "<LOC h2>2 Hours",
                help = "<LOC h2Desc>Set the Wait Time to 2 Hours",
                key = 7200,
            },	
        },
    },
	{
        default = 1,
        label = "<LOC EXPWaitTimeTitle>Experimentals available in:",
        help = "<LOC EXPWaitTimeDesc>Set the wait time for the unlock of Experimentals for AI and Players in Minutes.",
        key = 'WaitTimeEXP',
		pref = 'WaitTimeExp',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC Min5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC Min10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC Min15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC Min20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC Min25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC Min30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC Min35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC Min40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC Min45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC Min50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC Min55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },	
            {
                text = "<LOC h15Min>1 Hour 5 Minutes",
                help = "<LOC h15MinDesc>Set the Wait Time to 1 Hour 5 Minutes",
                key = 3900,
            },	
            {
                text = "<LOC h110Min>1 Hour 10 Minutes",
                help = "<LOC h110MinDesc>Set the Wait Time to 1 Hour 10 Minutes",
                key = 4200,
            },	
            {
                text = "<LOC h115Min>1 Hour 15 Minutes",
                help = "<LOC h115MinDesc>Set the Wait Time to 1 Hour 15 Minutes",
                key = 4500,
            },
            {
                text = "<LOC h120Min>1 Hour 20 Minutes",
                help = "<LOC h120MinDesc>Set the Wait Time to 1 Hour 20 Minutes",
                key = 4800,
            },	
            {
                text = "<LOC h125Min>1 Hour 25 Minutes",
                help = "<LOC h125MinDesc>Set the Wait Time to 1 Hour 25 Minutes",
                key = 5100,
            },	
            {
                text = "<LOC h130Min>1 Hour 30 Minutes",
                help = "<LOC h130MinDesc>Set the Wait Time to 1 Hour 30 Minutes",
                key = 5400,
            },	
            {
                text = "<LOC h135Min>1 Hour 35 Minutes",
                help = "<LOC h135MinDesc>Set the Wait Time to 1 Hour 35 Minutes",
                key = 5700,
            },	
            {
                text = "<LOC h140Min>1 Hour 40 Minutes",
                help = "<LOC h140MinDesc>Set the Wait Time to 1 Hour 40 Minutes",
                key = 6000,
            },	
            {
                text = "<LOC h145Min>1 Hour 45 Minutes",
                help = "<LOC h145MinDesc>Set the Wait Time to 1 Hour 45 Minutes",
                key = 6300,
            },	
            {
                text = "<LOC h150Min>1 Hour 50 Minutes",
                help = "<LOC h150MinDesc>Set the Wait Time to 1 Hour 50 Minutes",
                key = 6600,
            },	
            {
                text = "<LOC h155Min>1 Hour 55 Minutes",
                help = "<LOC h155MinDesc>Set the Wait Time to 1 Hour 55 Minutes",
                key = 6900,
            },	
            {
                text = "<LOC h2>2 Hours",
                help = "<LOC h2Desc>Set the Wait Time to 2 Hours",
                key = 7200,
            },	
        },
    },
	{
        default = 1,
        label = "<LOC EliteWaitTimeTitle>Elite available in:",
        help = "<LOC EliteWaitTimeDesc>Set the wait time for the unlock of Elite for AI and Players in Minutes.",
        key = 'WaitTimeElite',
		pref = 'WaitTimeElite_',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC Min5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC Min10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC Min15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC Min20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC Min25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC Min30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC Min35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC Min40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC Min45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC Min50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC Min55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },	
            {
                text = "<LOC h15Min>1 Hour 5 Minutes",
                help = "<LOC h15MinDesc>Set the Wait Time to 1 Hour 5 Minutes",
                key = 3900,
            },	
            {
                text = "<LOC h110Min>1 Hour 10 Minutes",
                help = "<LOC h110MinDesc>Set the Wait Time to 1 Hour 10 Minutes",
                key = 4200,
            },	
            {
                text = "<LOC h115Min>1 Hour 15 Minutes",
                help = "<LOC h115MinDesc>Set the Wait Time to 1 Hour 15 Minutes",
                key = 4500,
            },
            {
                text = "<LOC h120Min>1 Hour 20 Minutes",
                help = "<LOC h120MinDesc>Set the Wait Time to 1 Hour 20 Minutes",
                key = 4800,
            },	
            {
                text = "<LOC h125Min>1 Hour 25 Minutes",
                help = "<LOC h125MinDesc>Set the Wait Time to 1 Hour 25 Minutes",
                key = 5100,
            },	
            {
                text = "<LOC h130Min>1 Hour 30 Minutes",
                help = "<LOC h130MinDesc>Set the Wait Time to 1 Hour 30 Minutes",
                key = 5400,
            },	
            {
                text = "<LOC h135Min>1 Hour 35 Minutes",
                help = "<LOC h135MinDesc>Set the Wait Time to 1 Hour 35 Minutes",
                key = 5700,
            },	
            {
                text = "<LOC h140Min>1 Hour 40 Minutes",
                help = "<LOC h140MinDesc>Set the Wait Time to 1 Hour 40 Minutes",
                key = 6000,
            },	
            {
                text = "<LOC h145Min>1 Hour 45 Minutes",
                help = "<LOC h145MinDesc>Set the Wait Time to 1 Hour 45 Minutes",
                key = 6300,
            },	
            {
                text = "<LOC h150Min>1 Hour 50 Minutes",
                help = "<LOC h150MinDesc>Set the Wait Time to 1 Hour 50 Minutes",
                key = 6600,
            },	
            {
                text = "<LOC h155Min>1 Hour 55 Minutes",
                help = "<LOC h155MinDesc>Set the Wait Time to 1 Hour 55 Minutes",
                key = 6900,
            },	
            {
                text = "<LOC h2>2 Hours",
                help = "<LOC h2Desc>Set the Wait Time to 2 Hours",
                key = 7200,
            },	
        },
    },
	{
        default = 1,
        label = "<LOC HeroWaitTimeTitle>Hero available in:",
        help = "<LOC HeroWaitTimeDesc>Set the wait time for the unlock of Heros for AI and Players in Minutes.",
        key = 'WaitTimeHero',
		pref = 'WaitTimeHero_',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC Min5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC Min10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC Min15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC Min20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC Min25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC Min30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC Min35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC Min40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC Min45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC Min50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC Min55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },	
            {
                text = "<LOC h15Min>1 Hour 5 Minutes",
                help = "<LOC h15MinDesc>Set the Wait Time to 1 Hour 5 Minutes",
                key = 3900,
            },	
            {
                text = "<LOC h110Min>1 Hour 10 Minutes",
                help = "<LOC h110MinDesc>Set the Wait Time to 1 Hour 10 Minutes",
                key = 4200,
            },	
            {
                text = "<LOC h115Min>1 Hour 15 Minutes",
                help = "<LOC h115MinDesc>Set the Wait Time to 1 Hour 15 Minutes",
                key = 4500,
            },
            {
                text = "<LOC h120Min>1 Hour 20 Minutes",
                help = "<LOC h120MinDesc>Set the Wait Time to 1 Hour 20 Minutes",
                key = 4800,
            },	
            {
                text = "<LOC h125Min>1 Hour 25 Minutes",
                help = "<LOC h125MinDesc>Set the Wait Time to 1 Hour 25 Minutes",
                key = 5100,
            },	
            {
                text = "<LOC h130Min>1 Hour 30 Minutes",
                help = "<LOC h130MinDesc>Set the Wait Time to 1 Hour 30 Minutes",
                key = 5400,
            },	
            {
                text = "<LOC h135Min>1 Hour 35 Minutes",
                help = "<LOC h135MinDesc>Set the Wait Time to 1 Hour 35 Minutes",
                key = 5700,
            },	
            {
                text = "<LOC h140Min>1 Hour 40 Minutes",
                help = "<LOC h140MinDesc>Set the Wait Time to 1 Hour 40 Minutes",
                key = 6000,
            },	
            {
                text = "<LOC h145Min>1 Hour 45 Minutes",
                help = "<LOC h145MinDesc>Set the Wait Time to 1 Hour 45 Minutes",
                key = 6300,
            },	
            {
                text = "<LOC h150Min>1 Hour 50 Minutes",
                help = "<LOC h150MinDesc>Set the Wait Time to 1 Hour 50 Minutes",
                key = 6600,
            },	
            {
                text = "<LOC h155Min>1 Hour 55 Minutes",
                help = "<LOC h155MinDesc>Set the Wait Time to 1 Hour 55 Minutes",
                key = 6900,
            },	
            {
                text = "<LOC h2>2 Hours",
                help = "<LOC h2Desc>Set the Wait Time to 2 Hours",
                key = 7200,
            },		
        },
    },
			{
        default = 1,
        label = "<LOC TitanWaitTimeTitle>Titan available in:",
        help = "<LOC TitanWaitTimeDesc>Set the wait time for the unlock of Titan for AI and Players in Minutes.",
        key = 'WaitTimeTitan',
		pref = 'WaitTimeTitan_',
        values = {
            {
                text = "<LOC Min5>5 Minutes",
                help = "<LOC Min5Desc>Set the Wait Time to 5 Minutes",
                key = 300,
            },
            {
                text = "<LOC Min10>10 Minutes",
                help = "<LOC Min10Desc>Set the Wait Time to 10 Minutes",
                key = 600,
            },
            {
                text = "<LOC Min15>15 Minutes",
                help = "<LOC Min15Desc>Set the Wait Time to 15 Minutes",
                key = 900,
            },
            {
                text = "<LOC Min20>20 Minutes",
                help = "<LOC Min20Desc>Set the Wait Time to 20 Minutes",
                key = 1200,
            },
            {
                text = "<LOC Min25>25 Minutes",
                help = "<LOC Min25Desc>Set the Wait Time to 25 Minutes",
                key = 1500,
            },
            {
                text = "<LOC Min30>30 Minutes",
                help = "<LOC Min30Desc>Set the Wait Time to 30 Minutes",
                key = 1800,
            },
            {
                text = "<LOC Min35>35 Minutes",
                help = "<LOC Min35Desc>Set the Wait Time to 35 Minutes",
                key = 2100,
            },
            {
                text = "<LOC Min40>40 Minutes",
                help = "<LOC Min40Desc>Set the Wait Time to 40 Minutes",
                key = 2400,
            },
            {
                text = "<LOC Min45>45 Minutes",
                help = "<LOC Min45Desc>Set the Wait Time to 45 Minutes",
                key = 2700,
            },
            {
                text = "<LOC Min50>50 Minutes",
                help = "<LOC Min50Desc>Set the Wait Time to 50 Minutes",
                key = 3000,
            },
            {
                text = "<LOC Min55>55 Minutes",
                help = "<LOC Min55Desc>Set the Wait Time to 55 Minutes",
                key = 3300,
            },
            {
                text = "<LOC h1>1 Hour",
                help = "<LOC tooltipCSKLOBFSPGen60Desc>Set the Wait Time to 1 Hour",
                key = 3600,
            },	
            {
                text = "<LOC h15Min>1 Hour 5 Minutes",
                help = "<LOC h15MinDesc>Set the Wait Time to 1 Hour 5 Minutes",
                key = 3900,
            },	
            {
                text = "<LOC h110Min>1 Hour 10 Minutes",
                help = "<LOC h110MinDesc>Set the Wait Time to 1 Hour 10 Minutes",
                key = 4200,
            },	
            {
                text = "<LOC h115Min>1 Hour 15 Minutes",
                help = "<LOC h115MinDesc>Set the Wait Time to 1 Hour 15 Minutes",
                key = 4500,
            },
            {
                text = "<LOC h120Min>1 Hour 20 Minutes",
                help = "<LOC h120MinDesc>Set the Wait Time to 1 Hour 20 Minutes",
                key = 4800,
            },	
            {
                text = "<LOC h125Min>1 Hour 25 Minutes",
                help = "<LOC h125MinDesc>Set the Wait Time to 1 Hour 25 Minutes",
                key = 5100,
            },	
            {
                text = "<LOC h130Min>1 Hour 30 Minutes",
                help = "<LOC h130MinDesc>Set the Wait Time to 1 Hour 30 Minutes",
                key = 5400,
            },	
            {
                text = "<LOC h135Min>1 Hour 35 Minutes",
                help = "<LOC h135MinDesc>Set the Wait Time to 1 Hour 35 Minutes",
                key = 5700,
            },	
            {
                text = "<LOC h140Min>1 Hour 40 Minutes",
                help = "<LOC h140MinDesc>Set the Wait Time to 1 Hour 40 Minutes",
                key = 6000,
            },	
            {
                text = "<LOC h145Min>1 Hour 45 Minutes",
                help = "<LOC h145MinDesc>Set the Wait Time to 1 Hour 45 Minutes",
                key = 6300,
            },	
            {
                text = "<LOC h150Min>1 Hour 50 Minutes",
                help = "<LOC h150MinDesc>Set the Wait Time to 1 Hour 50 Minutes",
                key = 6600,
            },	
            {
                text = "<LOC h155Min>1 Hour 55 Minutes",
                help = "<LOC h155MinDesc>Set the Wait Time to 1 Hour 55 Minutes",
                key = 6900,
            },	
            {
                text = "<LOC h2>2 Hours",
                help = "<LOC h2Desc>Set the Wait Time to 2 Hours",
                key = 7200,
            },	
        },
    },
}

end
end
