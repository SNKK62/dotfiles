local eventtap = require("hs.eventtap")
local timer = require("hs.timer")
local hotkey = require("hs.hotkey")
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

-- ctrl + h/j/k/l to arrows
remapKey({ "ctrl" }, "h", keyCode("left"))
remapKey({ "ctrl" }, "l", keyCode("right"))
remapKey({ "ctrl" }, "k", keyCode("up"))
remapKey({ "ctrl" }, "j", keyCode("down"))
-- ctrl + shift + h/j/k/l to shift + arrows
remapKey({ "ctrl", "shift" }, "h", keyCode("left", { "shift" }))
remapKey({ "ctrl", "shift" }, "l", keyCode("right", { "shift" }))
remapKey({ "ctrl", "shift" }, "k", keyCode("up", { "shift" }))
remapKey({ "ctrl", "shift" }, "j", keyCode("down", { "shift" }))

-- ctrl+ '/; to cmd + left/right
remapKey({ "ctrl" }, ";", keyCode("left", { "cmd" }))
remapKey({ "ctrl" }, "'", keyCode("right", { "cmd" }))
-- ctrl+shift '/; to cmd + shift + left/right
remapKey({ "ctrl", "shift" }, ";", keyCode("left", { "cmd", "shift" }))
remapKey({ "ctrl", "shift" }, "'", keyCode("right", { "cmd", "shift" }))

-- Shift + Delete to Forward Delete
remapKey({ "shift" }, "delete", keyCode("forwarddelete"))
