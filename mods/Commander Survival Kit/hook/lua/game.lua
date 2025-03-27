local GetFBPOPath = function() for i, mod in __active_mods do if mod.FBPProjectModName == "FBP-Orbital" then return mod.location end end end
FBPOPath = GetFBPOPath()


local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK-Units" then return mod.location end end end
CSKUnitsPath = GetCSKUnitsPath()
