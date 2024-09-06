local application = require("hs.application")
local fnutils = require("hs.fnutils")
local hotkey = require("hs.hotkey")
local window = require("hs.window")

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
hotkey.bind({ "cmd", "alt" }, "g", cycleApp("Google Chrome"))
-- hotkey.bind({ "cmd", "alt" }, "h", cycleApp("Finder"))
