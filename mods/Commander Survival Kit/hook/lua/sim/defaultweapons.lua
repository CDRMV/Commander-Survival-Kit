do


DefaultProjectileWeapon2 = Class(Weapon) {		

    FxRackChargeMuzzleFlash = {},
    FxRackChargeMuzzleFlashScale = 1,
    FxChargeMuzzleFlash = {},
    FxChargeMuzzleFlashScale = 1,
    FxMuzzleFlash = {
		'/effects/emitters/default_muzzle_flash_01_emit.bp',
        '/effects/emitters/default_muzzle_flash_02_emit.bp',
    },
    FxMuzzleFlashScale = 1,    

    OnCreate = function(self)
        Weapon.OnCreate(self)
        local bp = self:GetBlueprint()
        self.WeaponCanFire = true
        if bp.RackRecoilDistance != 0 then
            self.RecoilManipulators = {}
        end
        if not bp.RackBones then
           local strg = '*ERROR: No RackBones table specified, aborting weapon setup.  Weapon: ' .. bp.DisplayName .. ' on Unit: ' .. self.unit:GetUnitId()
           error(strg, 2)
           return
        end
        if not bp.MuzzleSalvoSize then
           local strg = '*ERROR: No MuzzleSalvoSize specified, aborting weapon setup.  Weapon: ' .. bp.DisplayName .. ' on Unit: ' .. self.unit:GetUnitId()
           error(strg, 2)
           return
        end
        if not bp.MuzzleSalvoDelay then
           local strg = '*ERROR: No MuzzleSalvoDelay specified, aborting weapon setup.  Weapon: ' .. bp.DisplayName .. ' on Unit: ' .. self.unit:GetUnitId()
           error(strg, 2)
           return
        end
        self.CurrentRackSalvoNumber = 1
        #Calculate recoil speed so that it finishes returning just as the next shot is ready.
        if bp.RackRecoilDistance != 0 then
            local dist = bp.RackRecoilDistance
            if bp.RackBones[1].TelescopeRecoilDistance then
                local tpDist = bp.RackBones[1].TelescopeRecoilDistance
                if math.abs(tpDist) > math.abs(dist) then
                    dist = tpDist
                end
            end
            self.RackRecoilReturnSpeed = bp.RackRecoilReturnSpeed or math.abs( dist / (( 1 / bp.RateOfFire ) - (bp.MuzzleChargeDelay or 0))) * 1.25
        end
        #Error Checking
        self.NumMuzzles = 0
        for rk, rv in bp.RackBones do
            self.NumMuzzles = self.NumMuzzles + table.getn(rv.MuzzleBones or 0)
        end
        self.NumMuzzles = self.NumMuzzles / table.getn(bp.RackBones)
        local totalMuzzleFiringTime = (self.NumMuzzles - 1) * bp.MuzzleSalvoDelay
        if totalMuzzleFiringTime > (1 / bp.RateOfFire) then
            local strg = '*ERROR: The total time to fire muzzles is longer than the RateOfFire allows, aborting weapon setup.  Weapon: ' .. bp.DisplayName .. ' on Unit: ' .. self.unit:GetUnitId()
            error(strg, 2)
            return false
        end
        if bp.RackRecoilDistance != 0 and bp.MuzzleSalvoDelay != 0 then
            local strg = '*ERROR: You can not have a RackRecoilDistance with a MuzzleSalvoDelay not equal to 0, aborting weapon setup.  Weapon: ' .. bp.DisplayName .. ' on Unit: ' .. self.unit:GetUnitId()
            error(strg, 2)
            return false
        end
        if bp.EnergyChargeForFirstShot == false then
            self.FirstShot = true
        end
        if bp.RenderFireClock then
            self.unit:SetWorkProgress(1)
        end
        ChangeState(self, self.IdleState)
    end,

    OnMotionHorzEventChange = function(self, new, old)
        Weapon.OnMotionHorzEventChange(self, new, old)
        local bp = self:GetBlueprint()
        if bp.WeaponUnpackLocksMotion == true and old == 'Stopped' then
            self:PackAndMove()
        end
        #Changing firing randomness while moving, NOTE: This is hard set.  If it's changed somewhere else this will override
        #I'd do it the proper way but we're at the end of the project and thusly stuck.
        if old == 'Stopped' then
            if bp.FiringRandomnessWhileMoving then
                self:SetFiringRandomness(bp.FiringRandomnessWhileMoving)
            end
        elseif new == 'Stopped' and bp.FiringRandomnessWhileMoving then
            self:SetFiringRandomness(bp.FiringRandomness)
        end
    end,

    CreateProjectileAtMuzzle = function(self, muzzle)
        local proj = self:CreateProjectileForWeapon(muzzle)
        if not proj or proj:BeenDestroyed()then
            return proj
        end
        local bp = self:GetBlueprint()
        if bp.DetonatesAtTargetHeight == true then
            local pos = self:GetCurrentTargetPos()
            if pos then
                local theight = GetSurfaceHeight(pos[1], pos[3])
                local hght = pos[2] - theight
                proj:ChangeDetonateAboveHeight(hght)
            end
        end
        if bp.Flare then
            proj:AddFlare(bp.Flare)
        end
        if self.unit:GetCurrentLayer() == 'Water' and bp.Audio.FireUnderWater then
            self:PlaySound(bp.Audio.FireUnderWater)
        elseif bp.Audio.Fire then
            self:PlaySound(bp.Audio.Fire)
        end
        return proj
    end,

    StartEconomyDrain = function(self)
        if self.FirstShot then return end
        local bp = self:GetBlueprint()
        if not self.EconDrain and bp.EnergyRequired and bp.EnergyDrainPerSecond then
            local nrgReq = self:GetWeaponEnergyRequired()
            local nrgDrain = self:GetWeaponEnergyDrain()
            if nrgReq > 0 and nrgDrain > 0 then
                local time = nrgReq / nrgDrain
                if time < 0.1 then
                    time = 0.1
                end
                self.EconDrain = CreateEconomyEvent(self.unit, nrgReq, 0, time)
                self.FirstShot = true
            end
        end
    end,

    #The adjacency mod only effects the over all cost, not the drain per second. So, the drain will be about the same
    #but the time it takes to drain will not be.
    GetWeaponEnergyRequired = function(self)
        local bp = self:GetBlueprint()
        local weapNRG = (bp.EnergyRequired or 0) * (self.AdjEnergyMod or 1)
        if weapNRG < 0 then
            weapNRG = 0
        end
        return weapNRG
    end,

    GetWeaponEnergyDrain = function(self)
        local bp = self:GetBlueprint()
        local weapNRG = (bp.EnergyDrainPerSecond or 0)
        return weapNRG
    end,

    #Effect functions: Not only visual effects but also plays animations, recoil, etc.

    #PlayFxMuzzleSequence: Played when a muzzle is fired.  Mostly used for muzzle flashes
    PlayFxMuzzleSequence = function(self, muzzle)
        local bp = self:GetBlueprint()
        for k, v in self.FxMuzzleFlash do
            CreateAttachedEmitter(self.unit, muzzle, self.unit:GetArmy(), v):ScaleEmitter(self.FxMuzzleFlashScale)
        end
    end,

    #PlayFxMuzzleSequence: Played during the beginning of the MuzzleChargeDelay time when a muzzle in a rack is fired.
    PlayFxMuzzleChargeSequence = function(self, muzzle)
        local bp = self:GetBlueprint()
        for k, v in self.FxChargeMuzzleFlash do
            CreateAttachedEmitter(self.unit, muzzle, self.unit:GetArmy(), v):ScaleEmitter(self.FxChargeMuzzleFlashScale)
        end
    end,    

    #PlayFxRackSalvoChargeSequence: Played when a rack salvo charges.  Do not put a wait in here or you'll
    #make the time value in the bp off.  Spawn another thread to do waits.
    PlayFxRackSalvoChargeSequence = function(self)
        local bp = self:GetBlueprint()
        for k, v in self.FxRackChargeMuzzleFlash do
            for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                CreateAttachedEmitter(self.unit, ev, self.unit:GetArmy(), v):ScaleEmitter(self.FxRackChargeMuzzleFlashScale)
            end
        end
        if bp.Audio.ChargeStart then
            self:PlaySound(bp.Audio.ChargeStart)
        end
        if bp.AnimationCharge and not self.Animator then
            self.Animator = CreateAnimator(self.unit)
            self.Animator:PlayAnim(self:GetBlueprint().AnimationCharge):SetRate(bp.AnimationChargeRate or 1)
        end
    end,

    #PlayFxRackSalvoReloadSequence: Played when a rack salvo reloads.  Do not put a wait in here or you'll
    #make the time value in the bp off.  Spawn another thread to do waits.
    PlayFxRackSalvoReloadSequence = function(self)
        local bp = self:GetBlueprint()
        if bp.AnimationReload and not self.Animator then
            self.Animator = CreateAnimator(self.unit)
            self.Animator:PlayAnim(self:GetBlueprint().AnimationReload):SetRate(bp.AnimationReloadRate or 1)
        end
    end,

    #PlayFxRackSalvoReloadSequence: Played when a rack reloads. Mostly used for Recoil.
    PlayFxRackReloadSequence = function(self)
        local bp = self:GetBlueprint()
        if bp.CameraShakeRadius and bp.CameraShakeMax and bp.CameraShakeMin and bp.CameraShakeDuration and
            bp.CameraShakeRadius > 0 and bp.CameraShakeMax > 0 and bp.CameraShakeMin >= 0 and bp.CameraShakeDuration > 0 then
            self.unit:ShakeCamera(bp.CameraShakeRadius, bp.CameraShakeMax, bp.CameraShakeMin, bp.CameraShakeDuration)
        end
        if bp.ShipRock == true then
            local ix,iy,iz = self.unit:GetBoneDirection(bp.RackBones[self.CurrentRackSalvoNumber].RackBone)
            self.unit:RecoilImpulse(-ix,-iy,-iz)
        end
        if bp.RackRecoilDistance != 0 then
            self:PlayRackRecoil({bp.RackBones[self.CurrentRackSalvoNumber]})
        end
    end,

    #PlayFxWeaponUnpackSequence: Played when a weapon unpacks.  Here a wait is used because by definition a weapon
    #can not fire while packed up.
    PlayFxWeaponUnpackSequence = function(self)
        local bp = self:GetBlueprint()
        local unitBP = self.unit:GetBlueprint()
        if unitBP.Audio.Activate then
            self:PlaySound(unitBP.Audio.Activate)
        end
        if unitBP.Audio.Open then
            self:PlaySound(unitBP.Audio.Open)
        end
        if bp.Audio.Unpack then
            self:PlaySound(bp.Audio.Unpack)
        end
        if bp.WeaponUnpackAnimation and not self.UnpackAnimator then
            self.UnpackAnimator = CreateAnimator(self.unit)
            self.UnpackAnimator:PlayAnim(bp.WeaponUnpackAnimation):SetRate(0)
            self.UnpackAnimator:SetPrecedence(bp.WeaponUnpackAnimatorPrecedence or 0)
            self.unit.Trash:Add(self.UnpackAnimator)
        end
        if self.UnpackAnimator then
            self.UnpackAnimator:SetRate(bp.WeaponUnpackAnimationRate)
            WaitFor(self.UnpackAnimator)
        end
    end,

    #PlayFxWeaponUnpackSequence: Played when a weapon packs up.  It has no target and is done with all of its rack salvos
    PlayFxWeaponPackSequence = function(self)
        local bp = self:GetBlueprint()
        local unitBP = self.unit:GetBlueprint()
        if unitBP.Audio.Close then
            self:PlaySound(unitBP.Audio.Close)
        end
        if bp.WeaponUnpackAnimation and self.UnpackAnimator then
            self.UnpackAnimator:SetRate(-bp.WeaponUnpackAnimationRate)
        end
        if self.UnpackAnimator then
            WaitFor(self.UnpackAnimator)
        end
    end,


    PlayRackRecoil = function(self, rackList)
        local bp = self:GetBlueprint()
        for k, v in rackList do
            local tmpSldr = CreateSlider(self.unit, v.RackBone)
            table.insert(self.RecoilManipulators, tmpSldr)
            tmpSldr:SetPrecedence(11)
            tmpSldr:SetGoal(0, 0, bp.RackRecoilDistance)
            tmpSldr:SetSpeed(-1)
            self.unit.Trash:Add(tmpSldr)
            if v.TelescopeBone then
                tmpSldr = CreateSlider(self.unit, v.TelescopeBone)
                table.insert(self.RecoilManipulators, tmpSldr)
                tmpSldr:SetPrecedence(11)
                tmpSldr:SetGoal(0, 0, v.TelescopeRecoilDistance or bp.RackRecoilDistance)
                tmpSldr:SetSpeed(-1)
                self.unit.Trash:Add(tmpSldr)
            end
        end
        self:ForkThread(self.PlayRackRecoilReturn, rackList)
    end,

    PlayRackRecoilReturn = function(self, rackList)
        WaitTicks(1)
        for k, v in rackList do
            for mk, mv in self.RecoilManipulators do
                mv:SetGoal(0, 0, 0)
                mv:SetSpeed(self.RackRecoilReturnSpeed)
            end
        end
    end,

    WaitForAndDestroyManips = function(self)
        local manips = self.RecoilManipulators
        if manips then
            for k, v in manips do
                WaitFor(v)
            end
            self:DestroyRecoilManips()
        end
        if self.Animator then
            WaitFor(self.Animator)
            self.Animator:Destroy()
            self.Animator = nil
        end
    end,

    DestroyRecoilManips = function(self)
        local manips = self.RecoilManipulators
        if manips then
            for k, v in manips do
                v:Destroy()
            end
            self.RecoilManipulators = {}
        end
    end,

    #General State-less event handling
    OnLostTarget = function(self)
        Weapon.OnLostTarget(self)
        local bp = self:GetBlueprint()
        if bp.WeaponUnpacks == true then
            ChangeState(self, self.WeaponPackingState)
        else
            ChangeState(self, self.IdleState)
        end
    end,

    OnDestroy = function(self)
        ChangeState(self, self.DeadState)
    end,

    OnEnterState = function(self)
        if self.WeaponWantEnabled and not self.WeaponIsEnabled then
            self.WeaponIsEnabled = true
            self:SetWeaponEnabled(true)
        elseif not self.WeaponWantEnabled and self.WeaponIsEnabled then
            local bp = self:GetBlueprint()
            if bp.CountedProjectile != true then
                self.WeaponIsEnabled = false
                self:SetWeaponEnabled(false)
            end
        end
        if self.WeaponAimWantEnabled and not self.WeaponAimIsEnabled then
            self.WeaponAimIsEnabled = true
            self:AimManipulatorSetEnabled(true)
        elseif not self.WeaponAimWantEnabled and self.WeaponAimIsEnabled then
            self.WeaponAimIsEnabled = false
            self:AimManipulatorSetEnabled(false)
        end

    end,

    PackAndMove = function(self)
        ChangeState(self, self.WeaponPackingState)
    end,

    CanWeaponFire = function(self)
        if self.WeaponCanFire then
            return self.WeaponCanFire
        else
            return true
        end
    end,

    OnWeaponFired = function(self)
    end,

    OnEnableWeapon = function(self)
    end,

    # WEAPON STATES:

    #Weapon is in idle state when it does not have a target and is done with any animations or unpacking.
    IdleState = State {
        WeaponWantEnabled = true,
        WeaponAimWantEnabled = true,

        Main = function(self)
            if self.unit:IsDead() then return end
            
            self.unit:SetBusy(false)
            self:WaitForAndDestroyManips()
            local bp = self:GetBlueprint()
            #LOG("Weapon " .. bp.DisplayName .. " entered IdleState.")
            if not bp.RackBones then
                error('Error on rackbones ' .. self.unit:GetUnitId() )
            end
            for k, v in bp.RackBones do
                if v.HideMuzzle == true then
                    for mk, mv in v.MuzzleBones do
                        self.unit:ShowBone(mv, true)
                    end
                end
            end
            self:StartEconomyDrain()
            if table.getn(bp.RackBones) > 1 and self.CurrentRackSalvoNumber > 1 then
                WaitSeconds(self:GetBlueprint().RackReloadTimeout)
                self:PlayFxRackSalvoReloadSequence()
                self.CurrentRackSalvoNumber = 1
            end

        end,

        OnGotTarget = function(self)
            local bp = self:GetBlueprint()
            if (bp.WeaponUnpackLockMotion != true or (bp.WeaponUnpackLocksMotion == true and not self.unit:IsUnitState('Moving'))) then
                if bp.CountedProjectile == true and not self:CanFire() then
                    return
                end
                if bp.WeaponUnpacks == true then
                    ChangeState(self, self.WeaponUnpackingState)
                else
                    if bp.RackSalvoChargeTime and bp.RackSalvoChargeTime > 0 then
                        ChangeState(self, self.RackSalvoChargeState)
                    else
                        ChangeState(self, self.RackSalvoFireReadyState)
                    end
                end
            end
        end,

        OnFire = function(self)
            local bp = self:GetBlueprint()
            if bp.WeaponUnpacks == true then
                ChangeState(self, self.WeaponUnpackingState)
            else
                if bp.RackSalvoChargeTime and bp.RackSalvoChargeTime > 0 then
                    ChangeState(self, self.RackSalvoChargeState)
                elseif bp.SkipReadyState and bp.SkipReadyState == true then
                    ChangeState(self, self.RackSalvoFiringState)
                else
                    ChangeState(self, self.RackSalvoFireReadyState)
                end
            end
        end,
    },

    RackSalvoChargeState = State {
        WeaponWantEnabled = true,
        WeaponAimWantEnabled = true,

        Main = function(self)
            self.unit:SetBusy(true)
            local bp = self:GetBlueprint()
            self:PlayFxRackSalvoChargeSequence()
            #LOG("Weapon " .. bp.DisplayName .. " entered RackSalvoChargeState.")
            if bp.NotExclusive then
                self.unit:SetBusy(false)
            end
            WaitSeconds(self:GetBlueprint().RackSalvoChargeTime)
            if bp.NotExclusive then
                self.unit:SetBusy(true)
            end
            
            if bp.RackSalvoFiresAfterCharge == true then
                ChangeState(self, self.RackSalvoFiringState)
            else
                ChangeState(self, self.RackSalvoFireReadyState)
            end
        end,

        OnFire = function(self)
        end,
    },

    RackSalvoFireReadyState = State {
        WeaponWantEnabled = true,
        WeaponAimWantEnabled = true,

        Main = function(self)
            local bp = self:GetBlueprint()
            #LOG("Weapon " .. bp.DisplayName .. " entered RackSalvoFireReadyState.")
            if (bp.CountedProjectile == true and bp.WeaponUnpacks == true) then
                self.unit:SetBusy(true)
            else
                self.unit:SetBusy(false)
            end
            self.WeaponCanFire = true
            if self.EconDrain then
                self.WeaponCanFire = false
                WaitFor(self.EconDrain)
                RemoveEconomyEvent(self.unit, self.EconDrain)
                self.EconDrain = nil
                self.WeaponCanFire = true
            end
            #We change the state on counted projectiles because we won't get another OnFire call.
            #The second part is a hack for units with reload animations.  They have the same problem
            #they need a RackSalvoReloadTime that's 1/RateOfFire set to avoid firing twice on the first shot
            if bp.CountedProjectile == true  or bp.AnimationReload then
                ChangeState(self, self.RackSalvoFiringState)
            end
        end,

        OnFire = function(self)
            if self.WeaponCanFire then
                ChangeState(self, self.RackSalvoFiringState)
            end
        end,
    },

    RackSalvoFiringState = State {
        WeaponWantEnabled = true,
        WeaponAimWantEnabled = true,

        RenderClockThread = function(self, rof)
            local clockTime = rof
            local totalTime = clockTime
            while clockTime > 0.0 and 
                  not self:BeenDestroyed() and 
                  not self.unit:IsDead() do
                self.unit:SetWorkProgress( 1 - clockTime / totalTime )
                clockTime = clockTime - 0.1
                WaitSeconds(0.1)                            
            end
        end,
    
        Main = function(self)
            self.unit:SetBusy(true)
            local bp = self:GetBlueprint()
            #LOG("Weapon " .. bp.DisplayName .. " entered RackSalvoFiringState.")
            self:DestroyRecoilManips()
            local numRackFiring = self.CurrentRackSalvoNumber
            #This is done to make sure that when racks fire together, they fire together.
            if bp.RackFireTogether == true then
                numRackFiring = table.getsize(bp.RackBones)
            end

            # Fork timer counter thread carefully....
            if not self:BeenDestroyed() and 
               not self.unit:IsDead() then
                if bp.RenderFireClock and bp.RateOfFire > 0 then
                    local rof = 1 / bp.RateOfFire                
                    self:ForkThread(self.RenderClockThread, rof)                
                end
            end

            #Most of the time this will only run once, the only time it doesn't is when racks fire together.
            while self.CurrentRackSalvoNumber <= numRackFiring and not self.HaltFireOrdered do
                local rackInfo = bp.RackBones[self.CurrentRackSalvoNumber]
                local numMuzzlesFiring = bp.MuzzleSalvoSize
                if bp.MuzzleSalvoDelay == 0 then
                    numMuzzlesFiring = table.getn(rackInfo.MuzzleBones)
                end
                local muzzleIndex = 1
                for i = 1, numMuzzlesFiring do
                    if self.HaltFireOrdered then
                        continue
                    end
                    local muzzle = rackInfo.MuzzleBones[muzzleIndex]
                    if rackInfo.HideMuzzle == true then
                        self.unit:ShowBone(muzzle, true)
                    end
                    if bp.MuzzleChargeDelay and bp.MuzzleChargeDelay > 0 then
                        if bp.Audio.MuzzleChargeStart then
                            self:PlaySound(bp.Audio.MuzzleChargeStart)
                        end
                        self:PlayFxMuzzleChargeSequence(muzzle)
                        if bp.NotExclusive then
                            self.unit:SetBusy(false)
                        end
                        WaitSeconds(bp.MuzzleChargeDelay)
                        if bp.NotExclusive then
                            self.unit:SetBusy(true)
                        end
                    end
                    self:PlayFxMuzzleSequence(muzzle)                    
                    if rackInfo.HideMuzzle == true then
                        self.unit:HideBone(muzzle, true)
                    end
                    if self.HaltFireOrdered then
                        continue
                    end
                    self:CreateProjectileAtMuzzle(muzzle)
                    #Decrement the ammo if they are a counted projectile
                    if bp.CountedProjectile == true then
                        if bp.NukeWeapon == true then
                            self.unit:NukeCreatedAtUnit()
                            self.unit:RemoveNukeSiloAmmo(1)
                        else
                            self.unit:RemoveTacticalSiloAmmo(1)
                        end
                    end
                    muzzleIndex = muzzleIndex + 1
                    if muzzleIndex > table.getn(rackInfo.MuzzleBones) then
                        muzzleIndex = 1
                    end
                    if bp.MuzzleSalvoDelay > 0 then
                        if bp.NotExclusive then
                            self.unit:SetBusy(false)
                        end
                        WaitSeconds(bp.MuzzleSalvoDelay)
                        if bp.NotExclusive then
                            self.unit:SetBusy(true)
                        end         
                    end
                end

                self:PlayFxRackReloadSequence()
                if self.CurrentRackSalvoNumber <= table.getn(bp.RackBones) then
                    self.CurrentRackSalvoNumber = self.CurrentRackSalvoNumber + 1
                end
            end

            --self:DoOnFireBuffs()

            self.FirstShot = false

            self:StartEconomyDrain()

            self:OnWeaponFired()

            # We can fire again after reaching here
            self.HaltFireOrdered = false

            if self.CurrentRackSalvoNumber > table.getn(bp.RackBones) then
                self.CurrentRackSalvoNumber = 1
                if bp.RackSalvoReloadTime > 0 then
                    ChangeState(self, self.RackSalvoReloadState)
                elseif bp.RackSalvoChargeTime > 0 then
                    ChangeState(self, self.IdleState)
                elseif bp.CountedProjectile == true and bp.WeaponUnpacks == true then
                    ChangeState(self, self.WeaponPackingState)
                elseif bp.CountedProjectile == true and not bp.WeaponUnpacks then
                    ChangeState(self, self.IdleState)
                else
                    ChangeState(self, self.RackSalvoFireReadyState)
                end
            elseif bp.CountedProjectile == true and not bp.WeaponUnpacks then
                ChangeState(self, self.IdleState)
            elseif bp.CountedProjectile == true and bp.WeaponUnpacks == true then
                ChangeState(self, self.WeaponPackingState)
            else
                ChangeState(self, self.RackSalvoFireReadyState)
            end
        end,

        OnLostTarget = function(self)
            Weapon.OnLostTarget(self)
            local bp = self:GetBlueprint()
            if bp.WeaponUnpacks == true then
                ChangeState(self, self.WeaponPackingState)
            end
        end,

        # Set a bool so we won't fire if the target reticle is moved
        OnHaltFire = function(self)
            self.HaltFireOrdered = true
        end,
    },

    RackSalvoReloadState = State {
        WeaponWantEnabled = true,
        WeaponAimWantEnabled = true,

        Main = function(self)
            self.unit:SetBusy(true)
            local bp = self:GetBlueprint()
            #LOG("Weapon " .. bp.DisplayName .. " entered RackSalvoReloadState.")
            self:PlayFxRackSalvoReloadSequence()
            if bp.NotExclusive then
                self.unit:SetBusy(false)
            end
            WaitSeconds(self:GetBlueprint().RackSalvoReloadTime)
            self:WaitForAndDestroyManips()
            if bp.NotExclusive then
                self.unit:SetBusy(true)
            end
            if self:WeaponHasTarget() and bp.RackSalvoChargeTime > 0 and self:CanFire() then
                ChangeState(self, self.RackSalvoChargeState)
            elseif self:WeaponHasTarget() and self:CanFire() then
                ChangeState(self, self.RackSalvoFireReadyState)
            elseif not self:WeaponHasTarget() and bp.WeaponUnpacks == true and bp.WeaponUnpackLocksMotion != true then
                ChangeState(self, self.WeaponPackingState)
            else
                ChangeState(self, self.IdleState)
            end
        end,

        OnFire = function(self)
        end,
    },

    WeaponUnpackingState = State {
        WeaponWantEnabled = false,
        WeaponAimWantEnabled = false,

        Main = function(self)
            self.unit:SetBusy(true)

            local bp = self:GetBlueprint()
            #LOG("Weapon " .. bp.DisplayName .. " entered WeaponUnpackingState.")
            if bp.WeaponUnpackLocksMotion then
                self.unit:SetImmobile(true)
            end
            self:PlayFxWeaponUnpackSequence()
            local rackSalvoChargeTime = self:GetBlueprint().RackSalvoChargeTime
            if rackSalvoChargeTime and rackSalvoChargeTime > 0 then
                ChangeState(self, self.RackSalvoChargeState)
            else
                ChangeState(self, self.RackSalvoFireReadyState)
            end
        end,

        # Override so that it doesn't play the firing sound when
        # we're not actually creating the projectile yet
        OnFire = function(self)
        end,
    },

    WeaponPackingState = State {
        WeaponWantEnabled = true,
        WeaponAimWantEnabled = true,

        Main = function(self)
            self.unit:SetBusy(true)
            local bp = self:GetBlueprint()
            #LOG("Weapon " .. bp.DisplayName .. " entered WeaponPackingState.")
            WaitSeconds(self:GetBlueprint().WeaponRepackTimeout)
            self:AimManipulatorSetEnabled(false)
            self:PlayFxWeaponPackSequence()
            if bp.WeaponUnpackLocksMotion then
                self.unit:SetImmobile(false)
            end
            ChangeState(self, self.IdleState)
        end,

        OnGotTarget = function(self)
            if not self:GetBlueprint().ForceSingleFire then
                ChangeState(self, self.WeaponUnpackingState)
            end
        end,

        # Override so that it doesn't play the firing sound when
        # we're not actually creating the projectile yet
        OnFire = function(self)
            local bp = self:GetBlueprint()
            if bp.CountedProjectile == true and not self:GetBlueprint().ForceSingleFire then
                ChangeState(self, self.WeaponUnpackingState)
            end
        end,

    },

    DeadState = State {

        OnEnterState = function(self)
        end,

        Main = function(self)
        end,
    },
}


end
