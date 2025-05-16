local keycodes = require("hs.keycodes")
local eventtap = require("hs.eventtap")

local events = eventtap.event.types
local map = keycodes.map

--- for debugging new input source
-- local keyDown = eventtap.event.types.keyDown
-- local flagsChanged = eventtap.event.types.flagsChanged
--
-- eventTap = eventtap.new({ keyDown, flagsChanged }, function(event)
-- 	local flags = event:getFlags()
-- 	if flags["shift"] then
-- 		print(keycodes.currentSourceID())
-- 		print(keycodes.currentMethod())
-- 		print(keycodes.currentLayout())
-- 	end
-- end)
-- eventTap:start()
---

local SOURCES = {
	Japanese = {
		layout = "ABC",
		method = "Hiragana",
		id = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese",
	},
	-- azoo
	Anzoo = {
		layout = "U.S.",
		method = "azooKey (日本語)",
		id = "dev.ensan.inputmethod.azooKeyMac.Japanese",
	},
	English = {
		layout = "ABC",
		method = nil,
		id = "com.apple.keylayout.ABC",
	},
	X_layout = {
		layout = "x_layout",
		method = nil,
		id = "org.unknown.keylayout.xlayout",
	},
}

local function switchInputSource(source)
	local currentSourceID = keycodes.currentSourceID()
	if currentSourceID ~= SOURCES[source].id then
		keycodes.setLayout(SOURCES[source].layout)
		if SOURCES[source].method then
			keycodes.setMethod(SOURCES[source].method)
		end
	end
end

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

local onlyTargetFlags = function(ev, targetFlags)
	local result = true
	for k, v in pairs(ev:getFlags()) do
		local found = false
		for i = 1, #targetFlags do
			local flag = targetFlags[i]
			if k == flag and v then
				found = true
				break
			end
		end
		if not found and v then
			result = false
			break
		end
	end
	return not noFlags(ev) and result
end

local rightCmdFlag = false
local shiftFlag = false
local alreadyRightCmdFlag = false
RightCmdEventWatcher = eventtap.new({ events.flagsChanged, events.keyDown }, function(event)
	local keyCode = event:getKeyCode()
	local flags = event:getFlags()

	if event:getType() == events.flagsChanged then
		if noFlags(event) and rightCmdFlag and shiftFlag then
			switchInputSource("X_layout")
			rightCmdFlag, shiftFlag, alreadyRightCmdFlag = false, false, false
		elseif noFlags(event) and rightCmdFlag then
			switchInputSource("Japanese")
			rightCmdFlag, shiftFlag, alreadyRightCmdFlag = false, false, false
		elseif
			flags.shift
			and flags.cmd
			and onlyTargetFlags(event, { "shift", "cmd" })
			and (keyCode == map.rightcmd or (keyCode == map.shift and alreadyRightCmdFlag))
		then
			rightCmdFlag, shiftFlag, alreadyRightCmdFlag = true, true, true
		elseif flags.cmd and onlyTargetFlags(event, { "cmd" }) and keyCode == map.rightcmd then
			rightCmdFlag, shiftFlag, alreadyRightCmdFlag = true, false, true
		elseif not noFlags(event) and not onlyTargetFlags(event, { "shift", "cmd" }) then
			rightCmdFlag, shiftFlag, alreadyRightCmdFlag = false, false, false
		end
	else
		rightCmdFlag, shiftFlag, alreadyRightCmdFlag = false, false, false
	end
end)
RightCmdEventWatcher:start()

local leftCmdFlag = false
LeftCmdEventWacher = eventtap.new({ events.flagsChanged, events.keyDown }, function(event)
	local keyCode = event:getKeyCode()
	local flags = event:getFlags()

	if event:getType() == events.flagsChanged then
		if noFlags(event) and leftCmdFlag then
			switchInputSource("English")
			leftCmdFlag = false
		elseif flags.cmd and onlyTargetFlags(event, { "cmd" }) and keyCode == map.cmd then
			leftCmdFlag = true
		else
			leftCmdFlag = false
		end
	else
		leftCmdFlag = false
	end
end)
LeftCmdEventWacher:start()
