local GetFBPOPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56fa5" then return mod.location end end end
FBPOPath = GetFBPOPath()


local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56facsku120" then return mod.location end end end
CSKUnitsPath = GetCSKUnitsPath()
