local eventtap = require("hs.eventtap")
local timer = require("hs.timer")
local hotkey = require("hs.hotkey")
local alert = require("hs.alert")
local application = require("hs.application")
local fnutils = require("hs.fnutils")
local keycodes = require("hs.keycodes")
local menubar = require("hs.menubar")

local function keyCode(key, mods, callback)
	mods = mods or {}
	callback = callback or function() end
	return function()
		eventtap.event.newKeyEvent(mods, string.lower(key), true):post()
		timer.usleep(1000) -- 1000 microseconds
		eventtap.event.newKeyEvent(mods, string.lower(key), false):post()

		callback()
	end
end

local function remapKey(modifiers, key, action)
	hotkey.bind(modifiers, key, action, nil, action)
end

local excludedApps = { "Terminal", "Code", "WezTerm" }

local function isExcludedApp()
	local app = application.frontmostApplication()
	return app and fnutils.contains(excludedApps, app:name())
end

local isVisualMode = false

local visualModeIcon = nil
local function updateVisualModeIcon()
	if isVisualMode then
		visualModeIcon = menubar.new()
		if visualModeIcon then
			visualModeIcon:setTitle("visual")
		end
	else
		if visualModeIcon then
			visualModeIcon:delete()
		end
	end
end

local function activateVisualMode()
	isVisualMode = true
	updateVisualModeIcon()
end

local function deactivateVisualMode()
	isVisualMode = false
	updateVisualModeIcon()
end

local function toggleVisualMode()
	if isVisualMode then
		deactivateVisualMode()
	else
		activateVisualMode()
	end
end
hotkey.bind({ "ctrl", "shift" }, "v", toggleVisualMode)

-- cmd + c/x and basksapace to exit visual mode
ExitVisualMode = eventtap.new({ eventtap.event.types.keyDown }, function(event)
	local keycode = event:getKeyCode()
	local flags = event:getFlags()

	if
		(flags.cmd and (keycode == keycodes.map["c"] or keycode == keycodes.map["x"]))
		or keycode == keycodes.map["delete"]
	then
		if isVisualMode then
			deactivateVisualMode()
		end
	end
	return false
end)
ExitVisualMode:start()

local function addVisualMove(direction, mods)
	mods = mods or {}
	return function()
		if isExcludedApp() then
			keyCode(direction, mods)()
		elseif isVisualMode then
			local localMods = {}
			for _, v in ipairs(mods) do
				table.insert(localMods, v)
			end
			table.insert(localMods, "shift")
			keyCode(direction, localMods)()
		else
			keyCode(direction, mods)()
		end
	end
end

-- ctrl + h/j/k/l to arrows
remapKey({ "ctrl" }, "h", addVisualMove("left"))
remapKey({ "ctrl" }, "l", addVisualMove("right"))
remapKey({ "ctrl" }, "k", addVisualMove("up"))
remapKey({ "ctrl" }, "j", addVisualMove("down"))

-- ctrl+ '/; to cmd + left/right
remapKey({ "ctrl" }, "'", addVisualMove("left", { "cmd" }))
remapKey({ "ctrl" }, ";", addVisualMove("right", { "cmd" }))
-- ctrl + shift + '/; to home/end
remapKey({ "ctrl" }, ",", addVisualMove("home"))
remapKey({ "ctrl" }, ".", addVisualMove("end"))

-- Shift + Delete to Forward Delete
remapKey({ "shift" }, "delete", keyCode("forwarddelete"))
