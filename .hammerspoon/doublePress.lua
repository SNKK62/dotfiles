local alert = require("hs.alert")
local timer = require("hs.timer")
local eventtap = require("hs.eventtap")
local keycodes = require("hs.keycodes")

local events = eventtap.event.types
local map = keycodes.map

local func = function(flag, codeName)
	local module = {}

	-- how quickly must the two single flag taps occur?
	module.timeFrame = 1

	module.single_action = function()
		alert("You single tapped flag!")
	end

	module.double_action = function()
		alert("You double tapped flag!")
	end

	local timeFirstFlag, firstDown, secondDown = 0, false, false
	local currentTimer = nil

	-- verify that no keyboard flags are being pressed
	local noFlags = function(ev)
		local result = true
		for _, v in pairs(ev:getFlags()) do
			if v then
				result = false
				break
			end
		end
		return result
	end

	-- verify that *only* the target flag key flag is being pressed
	local onlyTargetFlag = function(ev)
		local keyCode = ev:getKeyCode()
		local result = true
		for k, v in pairs(ev:getFlags()) do
			if k ~= flag and v then
				result = false
				break
			end
		end
		return not noFlags(ev) and result and keyCode == map[codeName]
	end

	module.eventWatcher = eventtap
		.new({ events.flagsChanged, events.keyDown }, function(ev)
			-- if it's been too long; previous state doesn't matter
			if (timer.secondsSinceEpoch() - timeFirstFlag) > module.timeFrame then
				timeFirstFlag, firstDown, secondDown = 0, false, false
			end

			if ev:getType() == events.flagsChanged then
				if noFlags(ev) and firstDown and secondDown then -- flag up and we've seen two, so do action
					if currentTimer then
						currentTimer:stop()
						currentTimer = nil
					end
					if module.double_action then
						module.double_action()
					end
					timeFirstFlag, firstDown, secondDown = 0, false, false
				elseif noFlags(ev) and firstDown then -- flag up and we've seen one, so start over
					currentTimer = timer.doAfter(module.timeFrame, function()
						if module.single_action then
							module.single_action()
						end
						timeFirstFlag, firstDown, secondDown = 0, false, false
					end)
				elseif onlyTargetFlag(ev) and not firstDown then -- flag down and it's a first
					firstDown = true
					timeFirstFlag = timer.secondsSinceEpoch()
				elseif onlyTargetFlag(ev) and firstDown then -- flag down and it's the second
					secondDown = true
				elseif not noFlags(ev) then -- otherwise reset and start over
					timeFirstFlag, firstDown, secondDown = 0, false, false
				end
			else -- it was a key press, so not a lone flag char -- we don't care about it
				timeFirstFlag, firstDown, secondDown = 0, false, false
			end
			return false
		end)
		:start()

	return module
end

return func
