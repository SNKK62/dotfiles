local window = require("hs.window")
local fnutils = require("hs.fnutils")
local hotkey = require("hs.hotkey")

local utils = require("utils")

local function focusNextApp()
	local currentApp = window.focusedWindow()
	local sortedWindows =
		fnutils.filter(window.orderedWindows(), fnutils.partial(utils.isInScreenAndHasTitle, currentApp:screen()))
	sortedWindows[#sortedWindows]:focus()
end

hotkey.bind({ "cmd", "ctrl" }, "n", focusNextApp)

hotkey.bind({ "alt", "ctrl", "cmd" }, "Right", function()
	local win = window.focusedWindow()
	win:moveOneScreenEast(false, true, 0.5)
end)
hotkey.bind({ "alt", "ctrl", "cmd" }, "Left", function()
	local win = window.focusedWindow()
	win:moveOneScreenWest(false, true, 0.5)
end)
