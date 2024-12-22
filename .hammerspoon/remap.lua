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

-- Ctrl + h/j/k/l to arrows
remapKey({ "ctrl" }, "k", keyCode("up"))
remapKey({ "ctrl" }, "j", keyCode("down"))
remapKey({ "ctrl" }, "h", keyCode("left"))
remapKey({ "ctrl" }, "l", keyCode("right"))
-- Ctrl + Shift + h/j/k/l to Shift + arrows
remapKey({ "ctrl", "shift" }, "k", keyCode("up", { "shift" }))
remapKey({ "ctrl", "shift" }, "j", keyCode("down", { "shift" }))
remapKey({ "ctrl", "shift" }, "h", keyCode("left", { "shift" }))
remapKey({ "ctrl", "shift" }, "l", keyCode("right", { "shift" }))
-- Optional: Shift + Delete to Forward Delete (if needed)
remapKey({ "shift" }, "delete", keyCode("forwarddelete"))
