#****************************************************************************
#** 
#**  File     :  /cdimage/units/UEB5101/UEB5101_script.lua 
#**  Author(s):  John Comes, David Tomandl 
#** 
#**  Summary  :  UEF Wall Piece Script 
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
UEB5103 = Class(StructureUnit) {
	           

    OnCreate = function(self)
        StructureUnit.OnCreate(self)
		self:RemoveCommandCap('RULEUCC_Transport')
    end,
	OnScriptBitSet = function(self, bit)
        StructureUnit.OnScriptBitSet(self, bit)
		local location = self:GetPosition()
		local SurfaceHeight = GetSurfaceHeight(location[1], location[3]) -- Get Water layer
		local TerrainHeight = GetTerrainHeight(location[1], location[3]) -- Get Land Layer
		local mainbp = self:GetBlueprint()
		LOG("Water: ", SurfaceHeight)
		LOG("Land: ", TerrainHeight)
        if bit == 1 then 
			LOG('Test')
        if self.Dead then return end 

        local cargo = self:GetCargo()
        for _, unit in cargo do
		LOG('cargo: ', cargo)
		local bp = unit:GetBlueprint()
		local MeshBlueprint = bp.Display.MeshBlueprint
		local UniformScale = bp.Display.UniformScale
		unit:SetMesh(MeshBlueprint)
		unit:SetDrawScale(UniformScale)
		unit:DetachFrom(true)
        end
		end
    end,
	
	OnScriptBitClear = function(self, bit)
        StructureUnit.OnScriptBitClear(self, bit)
		local location = self:GetPosition()
		local SurfaceHeight = GetSurfaceHeight(location[1], location[3]) -- Get Water layer
		local TerrainHeight = GetTerrainHeight(location[1], location[3]) -- Get Land Layer
		local mainbp = self:GetBlueprint()
		LOG("Water: ", SurfaceHeight)
		LOG("Land: ", TerrainHeight)
        if bit == 1 then 
			LOG('Test')
        if self.Dead then return end 

        local cargo = self:GetCargo()
        for _, unit in cargo do
		LOG('cargo: ', cargo)
		local bp = unit:GetBlueprint()
		local MeshBlueprint = bp.Display.MeshBlueprint
		local UniformScale = bp.Display.UniformScale
		unit:SetMesh(MeshBlueprint)
		unit:SetDrawScale(UniformScale)
		unit:DetachFrom(true)
        end
		end
    end,

}


TypeClass = UEB5103

