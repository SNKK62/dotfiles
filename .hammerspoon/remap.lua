local eventtap = require("hs.eventtap")
local timer = require("hs.timer")
local hotkey = require("hs.hotkey")

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

local function remapKey(modifiers, key, _keyCode)
	hotkey.bind(modifiers, key, _keyCode, nil, _keyCode)
end

remapKey({ "ctrl" }, "k", keyCode("up"))
remapKey({ "ctrl" }, "j", keyCode("down"))
remapKey({ "ctrl" }, "h", keyCode("left"))
remapKey({ "ctrl" }, "l", keyCode("right"))
remapKey({ "shift" }, "delete", keyCode("forwarddelete"))
