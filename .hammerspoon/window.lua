local window = require("hs.window")
local fnutils = require("hs.fnutils")
local hotkey = require("hs.hotkey")
local application = require("hs.application")

local utils = require("utils")

local open_wezterm = function()
	local appName = "WezTerm"
	local app = application.get(appName)

	if app == nil or app:isHidden() or not (app:isFrontmost()) then
		application.launchOrFocus(appName)
	else
		app:hide()
	end
end
hotkey.bind({ "cmd" }, "g", open_wezterm)
--
local open_chrome = function()
	local appName = "Google Chrome"
	local app = application.get(appName)

	if app == nil or app:isHidden() or not (app:isFrontmost()) then
		application.launchOrFocus(appName)
	else
		-- app:hide()
		--
		app.windows[2]:focus()
	end
end
-- hotkey.bind({ "cmd", "alt" }, "g", open_chrome)

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
hotkey.bind({ "cmd", "ctrl" }, "g", cycleApp("Google Chrome"))
hotkey.bind({ "cmd", "ctrl" }, "v", cycleApp("Code"))

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

hotkey.bind({ "cmd", "ctrl", "shift" }, "Right", function()
	local win = window.focusedWindow()
	win:moveOneScreenEast(false, true, 0.5)
end)
hotkey.bind({ "cmd", "ctrl", "shift" }, "Left", function()
	local win = window.focusedWindow()
	win:moveOneScreenWest(false, true, 0.5)
end)

local expose = require("hs.expose")
local ex = expose.new(nil, { showThumbnails = true })
hotkey.bind({ "cmd", "ctrl" }, "e", function()
	ex:toggleShow()
end)

local function focusDesktop()
	local desktop = window.desktop()
	desktop:focus()
end
hotkey.bind({ "cmd", "ctrl" }, "d", focusDesktop)
