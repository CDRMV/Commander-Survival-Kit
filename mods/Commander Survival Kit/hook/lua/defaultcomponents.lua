
do

local IntelComponentOld = IntelComponent -- load old Unit Class

IntelComponent = Class(IntelComponentOld) {

	OnIntelEnabled = function(self, intel)
        LOG("Enabled intel: " .. tostring(intel))
		local bp = self.Blueprint
		local Faction = self.Blueprint.General.FactionName
        if intel == 'Cloak' or intel == 'CloakField' then
			if Faction == 'UEF' then
		    LOG("Smoke detected for Faction: ", Faction)
            self:UpdateSmokeEffect(true, 'SmokeField')
			else
			self:UpdateCloakEffect(true, intel)
			end
        end

    end,

    ---@param self IntelComponent | Unit
    ---@param intel? IntelType
    OnIntelDisabled = function(self, intel)
        LOG("Disabled intel: " .. tostring(intel))
		local bp = self.Blueprint
		local Faction = self.Blueprint.General.FactionName
        if intel == 'Cloak' or intel == 'CloakField' then
			if Faction == 'UEF' then
		    LOG("Smoke detected for Faction: ", Faction)
            self:UpdateSmokeEffect(true, 'SmokeField')
			else
			self:UpdateCloakEffect(false, intel)
			end
        end
    end,

    ---@param self IntelComponent | Unit
    ---@param cloaked boolean
    ---@param intel IntelType
    UpdateSmokeEffect = function(self, smoked, intel)
        -- When debugging cloak FX issues, remember that once a structure unit is seen by the enemy,
        -- recloaking won't make it vanish again, and they'll see the new FX.
        if self and not self.Dead then
            if intel == 'Smoke' then
                local bpDisplay = self.Blueprint.Display

                if smoked then

                end
            elseif intel == 'SmokeField' then
                if self.SmokeFieldWatcherThread then
                    KillThread(self.SmokeFieldWatcherThread)
                    self.SmokeFieldWatcherThread = nil
                end

                if smoked then
                    self.SmokeFieldWatcherThread = self:ForkThread(self.SmokeFieldWatcher)
                end
            end
        end
    end,

    ---@param self IntelComponent | Unit
    SmokeFieldWatcher = function(self)
        if self and not self.Dead then
            local bp = self.Blueprint
            local radius = bp.Intel.CloakFieldRadius - 2 -- Need to take off 2, because engine reasons
            local brain = self:GetAIBrain()

            while self and not self.Dead and self:IsIntelEnabled('CloakField') do
                local pos = self:GetPosition()
                local units = brain:GetUnitsAroundPoint(categories.ALLUNITS, pos, radius, 'Ally')

                for _, unit in units do
                    if unit and not unit.Dead and unit ~= self then
                        if unit.SmokeFXWatcherThread then
                            KillThread(unit.SmokeFXWatcherThread)
                            unit.SmokeFXWatcherThread = nil
                        end

                        unit:UpdateSmokeEffect(true, 'Smoke') -- Turn on the FX for the unit
                        unit.SmokeFXWatcherThread = unit:ForkThread(unit.SmokeFXWatcher)
                    end
                end

                WaitTicks(6)
            end
        end
    end,

    ---@param self IntelComponent | Unit
    SmokeFXWatcher = function(self)
        WaitTicks(6)

        if self and not self.Dead then
            self:UpdateSmokeEffect(false, 'Smoke')
        end
    end,

}

end	

