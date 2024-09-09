local window = require("hs.window")
local fnutils = require("hs.fnutils")
local hotkey = require("hs.hotkey")
local application = require("hs.application")

local utils = require("utils")

local open_app = function(appName)
	return function()
		local app = application.get(appName)
		if app == nil or app:isHidden() or not (app:isFrontmost()) then
			application.launchOrFocus(appName)
		else
			app:hide()
		end
	end
end

local cycleApp = function(appName)
	return function()
		local focusedWin = window.focusedWindow()
		local app = application.get(appName)
		local allWins =
			fnutils.filter(app:allWindows(), fnutils.partial(utils.isInScreenAndHasTitle, focusedWin:screen()))
		if focusedWin == nil or #allWins == 0 then
			application.launchOrFocus(appName)
			return
		end
		allWins[#allWins]:focus()
	end
end

local function focusNextApp()
	local currentApp = window.focusedWindow()
	local sortedWindows =
		fnutils.filter(window.orderedWindows(), fnutils.partial(utils.isInScreenAndHasTitle, currentApp:screen()))
	sortedWindows[#sortedWindows]:focus()
end
hotkey.bind({ "cmd", "ctrl" }, "n", focusNextApp)

local function minimizeWindowAndFocusNextApp()
	local focusedWindow = window.focusedWindow()
	focusNextApp()
	focusedWindow:minimize()
end
hotkey.bind({ "cmd", "ctrl" }, "c", minimizeWindowAndFocusNextApp)
