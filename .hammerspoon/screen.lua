local hotkey = require("hs.hotkey")
local fnutils = require("hs.fnutils")
local window = require("hs.window")
local mouse = require("hs.mouse")
local geometry = require("hs.geometry")

local utils = require("utils")

local function focusScreen(screen)
	--Get windows within screen, ordered from front to back.
	--If no windows exist, bring focus to desktop. Otherwise, set focus on
	--front-most application window.
	local windows = fnutils.filter(window.orderedWindows(), fnutils.partial(utils.isInScreen, screen))
	local windowToFocus = #windows > 0 and windows[1] or window.desktop()
	windowToFocus:focus()

	-- Move mouse to center of screen
	local pt = geometry.rectMidPoint(screen:fullFrame())
	mouse.setAbsolutePosition(pt)
end

local function moveToNextScreen()
	focusScreen(window.focusedWindow():screen():next())
end

-- hotkey.bind({ "cmd", "ctrl" }, "s", moveToNextScreen)
