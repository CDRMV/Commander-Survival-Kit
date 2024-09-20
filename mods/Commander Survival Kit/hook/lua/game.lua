local GetFBPOPath = function() for i, mod in __active_mods do if mod.name == "(F.B.P.) Future Battlefield Pack: Orbital" then return mod.location end end end
FBPOPath = GetFBPOPath()


local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.name == "Commander Survival Kit Units" then return mod.location end end end
CSKUnitsPath = GetCSKUnitsPath()
