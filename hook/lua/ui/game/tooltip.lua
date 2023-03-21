--#################################################################### 

-- This Code below is from FAF
-- The Function is missing in the Steam Version.
-- I needed it to make the Tooltips for some Buttons much more easier.

--#################################################################### 


function AddForcedControlTooltipManual(control, title, description, delay, width)
    if not control.oldHandleEvent then
        control.oldHandleEvent = control.HandleEvent
    end
    control.HandleEvent = function(self, event)
        if event.Type == 'MouseEnter' then
            local forced = true
            CreateMouseoverDisplay(self, 
                {
                    text = title,
                    body = description
                }, delay, true, width, forced
            )
        elseif event.Type == 'MouseExit' then
            DestroyMouseoverDisplay()
        end
        return self:oldHandleEvent(event)
    end
end