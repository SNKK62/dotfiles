-- for Hammerspoon ShiftIt
local shiftIt = hs.loadSpoon("ShiftIt")
shiftIt:bindHotkeys({})

require("input")

local hotkey = require("hs.hotkey")
local application = require("hs.application")
local mouse = require("hs.mouse")
local window = require("hs.window")
local fnutils = require("hs.fnutils")
local geometry = require("hs.geometry")

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
hotkey.bind({ "alt", "ctrl", "cmd" }, "Right", function()
	local win = window.focusedWindow()
	win:moveOneScreenEast(false, true, 0.5)
end)
hotkey.bind({ "alt", "ctrl", "cmd" }, "Left", function()
	local win = window.focusedWindow()
	win:moveOneScreenWest(false, true, 0.5)
end)

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

-- local application = require("hs.application")
--Predicate that checks if a window belongs to a screen
local function isInScreen(screen, win)
	return win:screen() == screen
end

local function isInScreenAndHasTitle(screen, win)
	return isInScreen(screen, win) and #win:title() > 0
end

local cycleApp = function(appName)
	return function()
		local focusedWin = window.focusedWindow()
		local app = application.get(appName)
		local allWins = fnutils.filter(app:allWindows(), fnutils.partial(isInScreenAndHasTitle, focusedWin:screen()))
		if focusedWin == nil or #allWins == 0 then
			application.launchOrFocus(appName)
			return
		end
		allWins[#allWins]:focus()
	end
end
hotkey.bind({ "cmd", "alt" }, "g", cycleApp("Google Chrome"))
-- hotkey.bind({ "cmd", "alt" }, "h", cycleApp("Finder"))

local function focusScreen(screen)
	--Get windows within screen, ordered from front to back.
	--If no windows exist, bring focus to desktop. Otherwise, set focus on
	--front-most application window.
	local windows = fnutils.filter(window.orderedWindows(), fnutils.partial(isInScreen, screen))
	local windowToFocus = #windows > 0 and windows[1] or window.desktop()
	windowToFocus:focus()

	-- Move mouse to center of screen
	local pt = geometry.rectMidPoint(screen:fullFrame())
	mouse.setAbsolutePosition(pt)
end

local function moveToNextScreen()
	focusScreen(window.focusedWindow():screen():next())
end

hotkey.bind({ "cmd", "ctrl" }, "s", moveToNextScreen)

local function focusNextApp()
	local currentApp = window.focusedWindow()
	local sortedWindows =
		fnutils.filter(window.orderedWindows(), fnutils.partial(isInScreenAndHasTitle, currentApp:screen()))
	sortedWindows[#sortedWindows]:focus()
end

hotkey.bind({ "cmd", "ctrl" }, "n", focusNextApp)
