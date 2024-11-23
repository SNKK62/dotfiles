local menubar = require("hs.menubar")
local caffeinate = require("hs.caffeinate")
local caffeine = menubar.new()

function SetCaffeineDisplay(state)
	if state then
		caffeine:setTitle("wake")
	else
		caffeine:setTitle("sleep")
	end
end

function CaffeineClicked()
	SetCaffeineDisplay(caffeinate.toggle("displayIdle"))
end

if caffeine then
	caffeine:setClickCallback(CaffeineClicked)
	caffeinate.set("displayIdle", true, true)
	SetCaffeineDisplay(caffeinate.get("displayIdle"))
end
