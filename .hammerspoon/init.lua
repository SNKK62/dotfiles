-- for Hammerspoon ShiftIt
-- local shiftIt = hs.loadSpoon("ShiftIt")
-- shiftIt:bindHotkeys({})

local ReloadConfiguration = hs.loadSpoon("ReloadConfiguration")
ReloadConfiguration:bindHotkeys({ reloadConfiguration = { { "cmd", "ctrl" }, "r" } })

require("input")
require("remap")
require("screen")
require("window")
require("caffeinate")
